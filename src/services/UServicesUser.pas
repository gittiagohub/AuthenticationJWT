unit UServicesUser;

interface

uses
   UUtils,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, UModelUser;

type
   TLogin = record
      id: Integer;
      email: String;
      token: String;
      expiry: TDateTime;
   end;

function login(aEmail, aPassword: String): TResult;
function logout(): TResult;
function SendGetUser(aID : integer;  const aFDMemTable : TFDMemTable): TResult;
function SendDeleteUser(aID : integer;  const aFDMemTable : TFDMemTable): TResult;
function SendGetAllUsers(const aFDMemTable : TFDMemTable): TResult;
function SendPostUser(aUsername,aFullname,aEmail,aPassWord : String;aBirthDate : TDateTime): TResult;
function SendUpdateUser(aID: integer;aUsername,aFullname,aEmail,aPassWord : String;aBirthDate : TDateTime): TResult;
function SendGetUserByID(aID : integer;  const aFDMemTable : TFDMemTable): TResult;

implementation

uses
  DataSet.Serialize.Adapter.RESTRequest4D, RESTRequest4D, System.JSON,
  System.SysUtils, UConfig,IpPeerClient;

var
   xBaseUrl: String;
   xLogin: TLogin;

function login(aEmail, aPassword: String): TResult;
var
   LResponse: IResponse;
begin
   try
      Result.IniVars;

      if aEmail.Trim.IsEmpty then
      begin
         Result.MSGError:= 'Preencha o email.';
         Exit;
      end;

      if aPassword.Trim.IsEmpty then
      begin
         Result.MSGError:= 'Preencha a senha.';
         Exit;
      end;

      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .Resource('/login')
        .Accept('application/json').AcceptCharset('UTF-8')
         .AddBody(TJSONObject.Create.AddPair('email', aEmail)
         .AddPair('password',aPassword))
        .Post;

      if LResponse.StatusCode = 200 then
      begin
         xLogin.email := aEmail;
         xLogin.token := LResponse.JSONValue.GetValue<string>('Token');
         xLogin.expiry := StrToDateTime(LResponse.JSONValue.GetValue<String>('Expiry'));
         xLogin.id := LResponse.JSONValue.GetValue<integer>('id');

         Result.OK := True;
      end
      else
      begin
         Result.MSGError :='Erro ao logar.';
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao logar.';
      end;
   end;
end;

function logout(): TResult;
var
   LResponse: IResponse;
begin
   try
      Result.IniVars;
      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .TokenBearer(xLogin.token)
        .Resource('/logout')
        //.AddHeader('Authorization','bearer '+xLogin.token)
        .Accept('application/json').AcceptCharset('UTF-8')
        .Post;

      if LResponse.StatusCode = 200 then
      begin
         Result.OK := True;
      end
      else
      begin
         Result.MSGError :='Erro ao fazer logout.';
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao fazer logout.';
      end;
   end;
end;


function SendGetUser(aID : integer; const  aFDMemTable :TFDMemTable ): TResult;
var
   LResponse: IResponse;
begin
    try
      Result.IniVars;

      if aID = 0 then
      begin
         aID:= xLogin.id;
//         Result.MSGError:= 'Preencha o ID.';
//         Exit;
      end;

      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .TokenBearer(xLogin.token)
        .Adapters(TDataSetSerializeAdapter.New(aFDMemTable))
//        .AddParam())
        .Resource('/user/'+aID.ToString())
        .Accept('application/json').AcceptCharset('UTF-8')
        .Get;

      if LResponse.StatusCode = 200 then
      begin
           Result.MSGError :='Sucesso ao Obter Usuário.';
           Result.OK       := True;
      end
      else
      begin
         Result.MSGError :='Erro ao Obter Usuário.';
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao Obter Usuários.';
      end;
   end;
end;

function SendDeleteUser(aID : integer;  const aFDMemTable : TFDMemTable): TResult;
var
   LResponse: IResponse;
begin
    try
      Result.IniVars;

      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .TokenBearer(xLogin.token)
        //todo
        //fazer com que o delete retorno os usuarios
//        .Adapters(TDataSetSerializeAdapter.New(aFDMemTable))
        .Resource('/user/'+aID.ToString())
        .Accept('application/json').AcceptCharset('UTF-8')
        .Delete;

      if LResponse.StatusCode = 204 then
      begin
           SendGetAllUsers(aFDMemTable);

           Result.MSGError :='Sucesso ao apagar Usuário.';
           Result.OK       := True;
      end
      else
      begin
         Result.MSGError :='Erro ao apagar Usuário.';
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao apagar Usuários.';
      end;
   end;
end;

function SendGetUserByID(aID : integer;  const aFDMemTable : TFDMemTable): TResult;
var
   LResponse: IResponse;
begin
    try
      Result.IniVars;

      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .TokenBearer(xLogin.token)
        //todo
        //fazer com que o delete retorno os usuarios
        .Adapters(TDataSetSerializeAdapter.New(aFDMemTable))
        .Resource('/user/'+aID.ToString())
        .Accept('application/json').AcceptCharset('UTF-8')
        .Get;

      if LResponse.StatusCode = 200 then
      begin
           Result.MSGError :='Sucesso ao Obter Usuário.';
           Result.OK       := True;
      end
      else
      begin
         Result.MSGError :='Erro ao Obter Usuário.';
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao Obter Usuários.';
      end;
   end;
end;

function SendGetAllUsers(const aFDMemTable: TFDMemTable): TResult;
var
  LResponse: IResponse;
begin
   try
      Result.IniVars;

      LResponse := TRequest.New.BaseURL(xBaseUrl).TokenBearer(xLogin.token)
        .Adapters(TDataSetSerializeAdapter.New(aFDMemTable))
      // .AddParam())
        .Resource('/users')
        .Accept('application/json')
        .AcceptCharset('UTF-8').Get;

      if LResponse.StatusCode = 200 then
      begin
         Result.MSGError := 'Sucesso ao Obter Usuários.';
         Result.OK := True;
      end
      else
      begin
         Result.MSGError := 'Erro ao Obter Usuários.';
      end;
   except
      on E: Exception do
      begin
         Result.MSGError := 'Erro ao Obter Usuários.';
      end;
   end;

end;
function SendUpdateUser(aID: integer; aUsername,aFullname,aEmail,aPassWord : String;aBirthDate : TDateTime): TResult;
var
  LResponse: IResponse;
  xUser: Tuser;
begin
   try
      Result.IniVars;

      //To do. validar os params

      xUser := Tuser.Create;
      xUser.id  := aID;
      xUser.username  := aUsername;
      xUser.fullname  := aFullname;
      xUser.email     := aemail;
      xUser.birthdate := aBirthDate;
      xUser.password  := aPassWord;

      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .TokenBearer(xLogin.token)
        .AddBody(xUser)
        .Resource('/user/')
        .Accept('application/json')
        .AcceptCharset('utf-8')
        .Put;

      if LResponse.StatusCode = 200 then
      begin
           Result.MSGError :='Sucesso ao atualizar Usuário.';
           Result.OK       := True;
      end
      else
      begin
         Result.MSGError :='Erro ao atualizar Usuário.'+slinebreak+
          LResponse.JSONValue.GetValue<string>('Dados inválidos: ')  ;
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao atualizar Usuário.';
      end;
   end;
end;

function SendPostUser(aUsername,aFullname,aemail,aPassWord : String;aBirthDate : TDateTime): TResult;
var
  LResponse: IResponse;
  xUser: Tuser;
begin
   try
      Result.IniVars;

      //To do. validar os params

      xUser := Tuser.Create;
      xUser.username  := aUsername;
      xUser.fullname  := aFullname;
      xUser.email     := aemail;
      xUser.birthdate := aBirthDate;
      xUser.password  := aPassWord;

      LResponse := TRequest.New.BaseURL(xBaseUrl)
        .TokenBearer(xLogin.token)
        .AddBody(xUser)
        .Resource('/users')
        .Accept('application/json')
        .AcceptCharset('utf-8')
        .Post;
//          LResponse.ContentType
      if LResponse.StatusCode = 200 then
      begin
           Result.MSGError :='Sucesso ao inserir Usuário.';
           Result.OK       := True;
      end
      else
      begin
         Result.MSGError :='Erro ao inserir Usuários.'+slinebreak+
          LResponse.JSONValue.GetValue<string>('Dados inválidos: ')  ;
      end;
   except on E: Exception do
      begin
         Result.MSGError :='Erro ao inserir Usuários.';
      end;
   end;
end;

initialization

Tconfig.LoadVariables;
xBaseUrl := Tconfig.APIHost + ':' + Tconfig.APIPort.ToString() + '/v1';

end.
