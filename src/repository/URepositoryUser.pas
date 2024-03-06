unit URepositoryUser;

interface

uses
   UModelUser, System.JSON,UUtils;

type

   TRepositoryUser = class
   private
       class function Fields (aArrayField : array of string) : String;
      { private declarations }
   protected
      { protected declarations }
   public
      class function getByEmail(aEmail: String;
        aFieldsToReturn: array of string): TUser;

      class function Insert(aJSON : TJSONArray): TResult;
      class function Update(aJSON : TJSONObject): TResult;
      class function Get(aField: String ;aValue: String ): TResult;overload;
      class function Get(aField: String ;aValue: Variant ): TResult;overload;
      class function Get(aWhere: String): TResult;overload;
      class function Delete(aField: String = '';aValue: String =''): TResult;
      { public declarations }

   published
      { published declarations }
   end;

implementation

uses
   UModelDAO, System.SysUtils, System.Classes, SimpleValidator,
  REST.Json, BCrypt;

{ TRepositoryUser }

class function TRepositoryUser.Delete(aField, aValue: String): TResult;
var
 xDAO: iDAO<TUser>;
begin
   Result.IniVars;
   try
      xDAO := TDAO<TUser>.Create;

      xDAO.Delete(aField, QuotedStr(aValue));

      Result.OK := True;
      Result.HTTPStatus := 204;

   except on E: Exception do
      begin
           Result.OK := False;
           Result.HTTPStatus := 500;
      end;
   end;
end;

class function TRepositoryUser.Get(aField: String ;aValue: Variant): TResult;
var
   xDAO: iDAO<TUser>;
   i: Integer;
begin
   Result.IniVars;
   try
      xDAO := TDAO<TUser>.Create;

      if aField.IsEmpty then
      begin
         xDAO.Find();
      end
      else
      begin
         xDAO.Find(aField,aValue);
      end;

      Result.JSONArray := xDAO.ToJSONArray;

      for i := 0 to Result.JSONArray.count - 1 do
      begin
         TJSONObject(Result.JSONArray.items[i]).RemovePair('guid').Free;
         TJSONObject(Result.JSONArray.items[i]).RemovePair('password').Free;
      end;

      Result.HTTPStatus := 200;
      Result.OK := True;
   except
      on E: Exception do
      begin
           Result.OK := False;
           Result.HTTPStatus := 500;
      end;

   end;
end;

class function TRepositoryUser.Get(aField, aValue: String): TResult;
begin
   Result.IniVars;
   Result:= TRepositoryUser.Get(aField,Variant(aValue));
end;

class function TRepositoryUser.getByEmail(aEmail: String;
  aFieldsToReturn: array of string): TUser;
var
   xDAO: iDao<TUser>;
   xUser: TUser;
begin
   xDAO := TDAO<TUser>.Create;

   xDAO
   .SQL
    .Fields(Fields(aFieldsToReturn))
    .Where('email = ' + aEmail.QuotedString)
    .&End;
   xDAO.Find();

   Result := xDAO.ToTType;
end;

class function TRepositoryUser.Update(aJSON: TJSONObject): TResult;
var xDAO : iDAO<TUser>;
begin
   Result.IniVars;

   try
      xDAO := TDAO<TUser>.Create;

      xDAO.Update(TJson.JsonToObject<TUser>(aJSON));

      Result.OK := True;
      Result.HTTPStatus := 200;
   except
      on E: Exception do
      begin
         Result.OK := False;
         Result.HTTPStatus := 500;
      end;
   end;

end;

class function TRepositoryUser.Insert(aJSON : TJSONArray): TResult;
var
  XErrosValidate: TStringList;
  i: Integer;
  xUser: TUser;
   xDAO: iDAO<TUser>;
begin
   Result.IniVars;

   try
      XErrosValidate := TStringList.Create;
      xDAO := TDAO<TUser>.Create;
      try
         for i := 0 to aJSON.count - 1 do
         begin
            TSimpleValidator.Validate
              (TJson.JsonToObject<TUser>(TJSONObject(aJSON.items[i])),
              XErrosValidate);
         end;

         if XErrosValidate.count > 0 then
         begin
            Result.JSONObject := TJSONObject.Create.AddPair('Dados inválidos: ',XErrosValidate.Text);
            Result.OK := False;
            Result.HTTPStatus := 201;
            Exit;
         end;

         for i := 0 to aJSON.count - 1 do
         begin
            xUser := TJson.JsonToObject<TUser>(TJSONObject(aJSON.items[i]));
            xUser.password := TBCrypt.GenerateHash(xUser.password);
            xDAO.insert(xUser);
         end;

         Result.JSONObject := TJSONObject.Create.AddPair('Sucesso','');
         Result.OK := True;
         Result.HTTPStatus := 200;
      finally
         FreeAndNil(XErrosValidate);
      end;
   except on E: Exception do
        begin
           Result.JSONObject:= nil;
           Result.JSONArray := nil;
           Result.OK := False;
           Result.HTTPStatus := 500;
           Result.MSGError   := E.message;
        end;
   end;
end;



class function TRepositoryUser.Fields(aArrayField : array of string ): String;
var
   i: Integer;
begin
   Result := EmptyStr;
   for i := 0 to High(aArrayField) do
   begin
      if not(Result.IsEmpty) then
      begin
         Result := Result + ','
      end;
      Result := aArrayField[i];
   end;

   // Se o array vir vazio retorna todos os campos
   if Result.IsEmpty then
      Result := '*';
end;

class function TRepositoryUser.Get(aWhere: String): TResult;
var
   xDAO: iDAO<TUser>;
   i: Integer;
begin
   xDAO := TDAO<TUser>.Create;

   if aWhere.IsEmpty then
   begin
      xDAO.SQL.Fields(Fields([])).&End;
   end
   else
   begin
      xDAO.SQL.Fields(Fields([])).Where(aWhere).&End;
   end;

   xDAO.Find();

   Result.JSONArray := xDAO.ToJSONArray;

   for i := 0 to Result.JSONArray.count - 1 do
   begin
      TJSONObject(Result.JSONArray.items[i]).RemovePair('guid').Free;
      TJSONObject(Result.JSONArray.items[i]).RemovePair('password').Free;
   end;

   Result.JSONObject := TJSONObject.Create.AddPair('Sucesso', '');
   Result.OK := True;
   Result.HTTPStatus := 200;

end;

end.
