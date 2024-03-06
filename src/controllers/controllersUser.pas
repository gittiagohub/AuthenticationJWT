unit controllersUser;

interface

uses
   Horse,
   SimpleDAO,
   SimpleInterface,
   SimpleQueryFiredac,
   DataSet.Serialize,
   SimpleValidator,
   URepositoryUser,
   UUtils;

type
   TTokenInformation = record
      Expiration: TDateTime;
      Token: String;
   end;

const
   xSkipRoutes: TArray<string> = ['/login', '/swagger/doc/html',
     '/swagger/doc/json', '/favicon.ico','v1/login', 'v1/swagger/doc/html',
     'v1/swagger/doc/json', 'v1/favicon.ico'];

procedure RegistryRoutes(App: Thorse);
procedure ValidationTokenBlackList(req: THorseRequest; res: THorseResponse;
  next: TNextProc);
procedure Login(req: THorseRequest; res: THorseResponse; next: TNextProc);
procedure Logout(req: THorseRequest; res: THorseResponse; next: TNextProc);
procedure getUsers(req: THorseRequest; res: THorseResponse; next: TNextProc);
procedure getUsersByID(req: THorseRequest; res: THorseResponse;
  next: TNextProc);
procedure InsertUsers(req: THorseRequest; res: THorseResponse; next: TNextProc);
procedure deleteUserByID(req: THorseRequest; res: THorseResponse;
  next: TNextProc);
procedure UpdateUser(req: THorseRequest; res: THorseResponse;
  next: TNextProc);

function GeneratToken: TTokenInformation;
procedure ValidationToken(App: Thorse);

implementation

uses UModelUser, UModelConnection, System.Generics.Collections, Data.DB,
   FireDAC.Comp.Client, System.JSON, System.SysUtils, REST.JSON,
   System.Classes, BCrypt, BCrypt.Types,
   URepositoryAuthentication, UModelAuthentication,
   Horse.JWT,
   JOSE.Core.JWT,
   JOSE.Core.Builder,
   DateUtils, JOSE.Context, Web.HTTPApp, UConfig;

procedure RegistryRoutes(App: Thorse);
begin
   ValidationToken(App);
   App.Use(ValidationTokenBlackList);
   App.Group.Prefix('v1')
   .Get('/users', getUsers)
   .Get('/user/:id', getUsersByID)
   .Post('/users', InsertUsers)
   .Post('/login', Login)
   .Post('/logout', Logout)
   .Put('/user', UpdateUser)
   .Delete('/user/:id', deleteUserByID);
end;

procedure ValidationTokenBlackList(req: THorseRequest; res: THorseResponse;
  next: TNextProc);
var
   LToken: String;
   LJWT: TJOSEContext;
   i: Integer;
   xSkipRoute: Boolean;
begin
   xSkipRoute := False;
   if not((req.MethodType = TMethodType.mtPost)) then
   begin
      for i := Low(xSkipRoutes) to High(xSkipRoutes) do
      begin
         if xSkipRoutes[i] = req.PathInfo then
         begin
            xSkipRoute := True;
            break
         end;
      end;
      if not(xSkipRoute) then
      begin
         LToken := req.Headers.items['Authorization'];
         LToken := Trim(LToken.Replace('bearer', '', [rfIgnoreCase]));

         if TRepositoryAuthentication.inBlackList(LToken) then
         begin
            res.Send('UNAUTHORIZED').Status(THTTPStatus.Unauthorized);
            raise EHorseCallbackInterrupted.Create('UNAUTHORIZED');
         end;
      end;
   end;
   next;
end;

procedure ValidationToken(App: Thorse);
var
   xConfig: IHorseJWTConfig;
begin
   xConfig := THorseJWTConfig.Create;
   xConfig.SkipRoutes(xSkipRoutes);

   App.Use(HorseJWT(TConfig.APISecretJWT, xConfig));
end;

function GeneratToken: TTokenInformation;
var
   xToken: TJWT;

begin
   try
      xToken := TJWT.Create;
      xToken.Claims.Issuer := 'User';
      xToken.Claims.Subject := 'Key';
      xToken.Claims.Expiration := IncMinute(Now, TConfig.APITimeExpiry);

      // Outros claims
      xToken.Claims.SetClaimOfType<String>('Name', 'Tiago');
      xToken.Claims.SetClaimOfType<Boolean>('Active', True);

      Result.Expiration := xToken.Claims.Expiration;
      Result.Token := TJOSE.SHA256CompactToken(TConfig.APISecretJWT, xToken);
   finally
      FreeAndNil(xToken);
   end;
end;

procedure Login(req: THorseRequest; res: THorseResponse; next: TNextProc);
var
   xTokenInformation: TTokenInformation;
   xJSONBody: TJSONvalue;
   xPassword: String;
   xEmail: String;
   xUser: TUser;
   XUserToken: TUserToken;
begin

   try
      xJSONBody := TJSONObject.ParseJSONValue
        (TEncoding.UTF8.GetBytes(req.Body), 0);
      xEmail := xJSONBody.GetValue<String>('email');
      xPassword := xJSONBody.GetValue<String>('password');

      xUser := TRepositoryUser.getByEmail(xEmail, []);

      if TBCrypt.CompareHash(xPassword, xUser.password) then
      begin

         // desativa todos os tokens do usuario que esta logando
         TRepositoryAuthentication.desativaTokenByField('id_Users', xUser.id);
         xTokenInformation := GeneratToken;

         TRepositoryAuthentication.insert(xUser.id, xTokenInformation.Token,
           xTokenInformation.Expiration);

         res.Send<TJSONObject>(TJSONObject.Create.AddPair('Token',
           xTokenInformation.Token).AddPair('Expiry',
           DateTimeToStr(xTokenInformation.Expiration)).AddPair('id',
           xUser.id.ToString())).Status(THTTPStatus.OK);

      end
      else
      begin
         res.Send<TJSONObject>(TJSONObject.Create.AddPair('failed to log in',
           '')).Status(THTTPStatus.Unauthorized);
      end;
   finally
      FreeAndNil(xUser);
   end;
end;

procedure Logout(req: THorseRequest; res: THorseResponse; next: TNextProc);
var
   xRepositoryAuthentication: TRepositoryAuthentication;
   xJSONBody: TJSONvalue;
   xPassword: String;
   xEmail: String;
   xUser: TUser;
   XUserToken: TUserToken;
   LToken : String;
begin
   LToken := req.Headers.items['Authorization'];
   LToken := Trim(LToken.Replace('bearer', '', [rfIgnoreCase]));

   xRepositoryAuthentication := TRepositoryAuthentication.Create;
   try
      // desativa todos os tokens do usuario que esta logando
      if xRepositoryAuthentication.desativaTokenByField('token', LToken) then
      begin
         res.Send<TJSONObject>(TJSONObject.Create.AddPair('Logout: ',
           'efetuado')).Status(THTTPStatus.OK);
      end
      else
      begin
         res.Send<TJSONObject>(TJSONObject.Create.AddPair('failed to logout',
           '')).Status(THTTPStatus.Unauthorized);
      end;
   finally
      FreeAndNil(xRepositoryAuthentication);
   end;
end;

procedure InsertUsers(req: THorseRequest; res: THorseResponse; next: TNextProc);

var
   JSON: TJSONArray;
   xResult : TResult;
begin
   try
      JSON := (TJSONObject.Create.ParseJSONValue(req.Body) as TJSONArray);
   except
      on E: Exception do
      begin
         try
            JSON := TJSONArray.Create;
            JSON.add(TJSONObject.Create.ParseJSONValue(req.Body)
              as TJSONObject);
         except
            on E: Exception do

         end;
      end;
   end;

   xResult := TRepositoryUser.insert(JSON);

   res.Send<TJSONObject>(xResult.JSONObject).Status(xResult.HTTPStatus);
end;

procedure getUsers(req: THorseRequest; res: THorseResponse; next: TNextProc);
var
   xResult: TResult;
   xFiltro: String;
begin
     if req.Query.ContainsKey('birthdate')then
     begin
          xFiltro := 'birthdate > '+ req.Query['birthdate'].QuotedString;
     end;

     if req.Query.ContainsKey('fullname')then
     begin
          if not(xFiltro.IsEmpty) then
          begin
               xFiltro := xFiltro + ' and ';
          end;

          xFiltro := ' fullname like '+ QuotedStr(req.Query['fullname']+'%');
     end;

     xResult := TRepositoryUser.Get(xFiltro);
     res.Send<TJSONArray>(xResult.JSONArray).Status(xResult.HTTPStatus);
end;

procedure getUsersByID(req: THorseRequest; res: THorseResponse;
  next: TNextProc);

var
   xResult: TResult;
begin
   xResult := TRepositoryUser.Get('id',req.Params.items['id'].tointeger());

   res.Send<TJSONArray>(xResult.JSONArray).Status(xResult.HTTPStatus);
end;

procedure deleteUserByID(req: THorseRequest; res: THorseResponse;
  next: TNextProc);

var
   xResult: TResult;
begin
   xResult := TRepositoryUser.Delete('id', req.Params.items['id']);
   res.Send<TJSONArray>(xResult.JSONArray).Status(xResult.HTTPStatus);
end;

procedure UpdateUser(req: THorseRequest; res: THorseResponse;
  next: TNextProc);
var
   xResult: TResult;
   JSON: TJSONObject;
begin
   JSON   := (TJSONObject.Create.ParseJSONValue(req.Body) as TJSONObject);
   xResult:= TRepositoryUser.Update(JSON);
   res.Send<TJSONArray>(xResult.JSONArray).Status(xResult.HTTPStatus);
end;

end.
