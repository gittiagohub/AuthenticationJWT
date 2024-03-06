unit URepositoryAuthentication;

interface

uses
   UModelAuthentication, System.Generics.Collections;

type
   TRepositoryAuthentication = class
   private
      { private declarations }
   protected
      { protected declarations }
   public
      class function getByField(AField : String; aValue: Variant;
        aFieldsToReturn: array of string): TObjectList<TUserToken>;
      class function insert(aUserToken: TUserToken): Boolean; overload;
      class function insert(aIdUsers: Integer; aToken: String;
        aExpiryAt: TDateTime): Boolean; overload;
      class function delete(aIdUsers: Integer): Boolean; overload;
      class function delete(aUserToken: TUserToken): Boolean; overload;
      class function desativaTokenByUser(aUserToken: TUserToken)
        : Boolean; overload;
      class function desativaTokenByField(AField : String; aValue: Variant): Boolean; overload;

      class function inBlackList(atoken: String): Boolean;
      { public declarations }

   published
      { published declarations }
   end;

implementation

uses
   UModelDAO, System.SysUtils;

{ TRepositoryUser }

class function TRepositoryAuthentication.inBlackList(aToken: String): Boolean;
var
   xDAO: iDao<TUserToken>;
begin
    if aToken.IsEmpty then
    begin
         Result:=True;
    end;

   Result := False;
   try
      xDAO := TDAO<TUserToken>.Create;
      xDAO.find('token', aToken);
      Result := xDAO.DataSet.FieldByName('ATIVO').AsInteger = 0;
   except
      on E: Exception do
         Result := False;
   end;

end;

class function TRepositoryAuthentication.delete(aIdUsers: Integer): Boolean;
var
   xDAO: iDao<TUserToken>;
begin
   Result := True;
   try
      xDAO := TDAO<TUserToken>.Create;
      xDAO.Delete('id_Users', aIdUsers.ToString.QuotedString);
   except
      on E: Exception do
         Result := False;
   end;

end;

class function TRepositoryAuthentication.delete(aUserToken: TUserToken)
  : Boolean;
var
   xDAO: iDao<TUserToken>;
begin
   Result := True;
   try
      xDAO := TDAO<TUserToken>.Create;
      xDAO.delete(aUserToken);
   except
      on E: Exception do
      begin
         Result := False;
      end;
   end;
end;

class function TRepositoryAuthentication.desativaTokenByUser(
 aUserToken: TUserToken): Boolean;
var
   xDAO: iDao<TUserToken>;
begin
   Result := True;
   try
      xDAO := TDAO<TUserToken>.Create;

      //Delete records
//      xDAO.SQL.Where('id_users ='+aUserToken.idUsers.ToString()+
//                     ' and expiry_at < '+DateTimeToStr(now) ).&End;
//      xDAO.Delete();

      aUserToken.ativo := 0;
      xDAO.Update(aUserToken);
   except
      on E: Exception do
         Result := False;
   end;
end;

class function TRepositoryAuthentication.desativaTokenByField
  (AField : String; aValue: Variant): Boolean;
var
   xDAO: iDao<TUserToken>;
   I: Integer;
   xListUserToken: TObjectList<TUserToken>;
begin
   Result := True;
   try
      xListUserToken := getByField(AField,aValue,[]);

      for I := 0 to xListUserToken.Count -1 do
      begin
           desativaTokenByUser(xListUserToken[i]);
      end;

   except
      on E: Exception do
         Result := False;
   end;
end;
//
class function TRepositoryAuthentication.getByField(AField : String; aValue: Variant;
  aFieldsToReturn: array of string): TObjectList<TUserToken>;

   function Fields: String;
   var
      I: Integer;
   begin
      Result := EmptyStr;
      for I := 0 to High(aFieldsToReturn) do
      begin
         if not(Result.IsEmpty) then
         begin
            Result := Result + ','
         end;
         Result := aFieldsToReturn[I];
      end;

      // Se o array vir vazio retorna todos os campos
      if Result.IsEmpty then
         Result := '*';
   end;

var
   xDAO: iDao<TUserToken>;
begin
   xDAO := TDAO<TUserToken>.Create;

   xDAO.SQL.Fields(Fields)
     .Where(AField+' = ' + QuotedStr(aValue)).&End;

   Result := TObjectList<TUserToken>.Create;

   xDAO.Find(Result);

   //Result := xDAO.ToTType;
end;

class function TRepositoryAuthentication.insert(aUserToken: TUserToken)
  : Boolean;
var
   xDAO: iDao<TUserToken>;
begin
   Result := True;
   xDAO := TDAO<TUserToken>.Create;
   try
      aUserToken.ativo:=1;
      xDAO.insert(aUserToken);
   except
      on E: Exception do
      begin
         Result := False;
      end;
   end;
end;

class function TRepositoryAuthentication.insert(aIdUsers: Integer;
  aToken: String; aExpiryAt: TDateTime): Boolean;
var
   XUserToken: TUserToken;
begin
   XUserToken := TUserToken.Create;
   XUserToken.IdUsers := aIdUsers;
   XUserToken.token := aToken;
   XUserToken.expiryAt := aExpiryAt;

   Result := insert(XUserToken);

end;

end.
