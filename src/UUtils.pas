unit UUtils;

interface

uses
  System.JSON;
type
TResult = record
    JSONObject : TJSONObject;
    JSONArray  : TJSONArray;
    OK         : Boolean;
    HTTPStatus : Integer;
    MSGError   : String;

    procedure IniVars;
  end;

implementation

{ TResult }

procedure TResult.IniVars;
begin
    Self.JSONObject:= nil;
    Self.JSONArray := nil;
    Self.OK := False;
    Self.HTTPStatus := 500;
    Self.MSGError   := '';
end;


end.
