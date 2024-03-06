unit UModelDAO;

interface

uses
   SimpleInterface,
   SimpleDAO,
   SimpleAttributes,
   SimpleQueryFiredac,
   DataSet.Serialize,
   UModelConnection, Data.DB, JOSE.Types.JSON, System.Generics.Collections,
  Vcl.Forms;

type

//    iDAO<T : Class> = interface
//    ['{2A6C6ED9-40BC-4AF5-A635-26615D8DD321}']
//    {$IFNDEF CONSOLE}
//    function Insert: iSimpleDAO<T>; overload;
//    function Update: iSimpleDAO<T>; overload;
//    function Delete: iSimpleDAO<T>; overload;
//    {$ENDIF}
//    function Insert(aValue: T): iSimpleDAO<T>; overload;
//    function Update(aValue: T): iSimpleDAO<T>; overload;
//    function Delete(aValue: T): iSimpleDAO<T>; overload;
//    function LastID: iSimpleDAO<T>;
//    function LastRecord: iSimpleDAO<T>;
//    function Delete(aField: String; aValue: String): iSimpleDAO<T>; overload;
//    function DataSource(aDataSource: TDataSource): iSimpleDAO<T>;
//    function Find(aBindList: Boolean = True): iSimpleDAO<T>; overload;
//    function Find(var aList: TObjectList<T>): iSimpleDAO<T>; overload;
//    function Find(aId: Integer): T; overload;
//    function Find(aKey: String; aValue: Variant): iSimpleDAO<T>; overload;
//    function SQL: iSimpleDAOSQLAttribute<T>;
//    function DataSet(): TDataSet;
//    function ToJSONArray(): TJSONArray;
//    function ToJSONObject(): TJSONObject;
//    end;
   iDAO<T: Class> = interface(iSimpleDAO<T>)
      ['{6A4DC5AA-20D0-4E8E-8173-9E36893A5176}']
      function FindByGuid(aGuid: string) : T;
      function DataSet(): TDataSet;
      function ToJSONArray(): TJSONArray;
      function ToJSONObject(): TJSONObject;
      function ToTType(): T;
   end;

   TDAO<T: class, constructor> = class(TInterfacedObject, iDAO<T>)
   private
      FConnection: Tconnection;
      FDataSource: TDataSource;
      FDAO: iSimpleDAO<T>;
      procedure SetConnection(const Value: Tconnection);
      { private declarations }
   protected
      { protected declarations }
   public
      constructor Create();
      destructor destroy; override;

{$IFNDEF CONSOLE}
      function Insert: iSimpleDAO<T>; overload;
      function Update: iSimpleDAO<T>; overload;
      function Delete: iSimpleDAO<T>; overload;
{$ENDIF}
      function Insert(aValue: T): iSimpleDAO<T>; overload;
      function Update(aValue: T): iSimpleDAO<T>; overload;
      function Delete(aValue: T): iSimpleDAO<T>; overload;
      function LastID: iSimpleDAO<T>;
      function LastRecord: iSimpleDAO<T>;
      function Delete(aField: String; aValue: String): iSimpleDAO<T>; overload;
      function DataSource(aDataSource: TDataSource): iSimpleDAO<T>;
      function Find(aBindList: Boolean = True): iSimpleDAO<T>; overload;
      function Find(var aList: TObjectList<T>): iSimpleDAO<T>; overload;
      function Find(aId: Integer): T; overload;
      function Find(aKey: String; aValue: Variant): iSimpleDAO<T>; overload;
      function FindByGuid(aGuid : String) : T;
      function SQL: iSimpleDAOSQLAttribute<T>;
      function DataSet(): TDataSet;
      function ToJSONArray(): TJSONArray;
      function ToJSONObject(): TJSONObject;
      function ToTType(): T;

      {$IFNDEF CONSOLE}
    function BindForm(aForm : TForm)  : iSimpleDAO<T>;virtual;abstract;
    {$ENDIF}

      property Connection: Tconnection read FConnection;
   published
      { published declarations }
   end;

implementation

uses
   System.SysUtils, SimpleRTTI;

{ TDAO<T> }

constructor TDAO<T>.Create();
begin
   inherited;
   FConnection := Tconnection.Create(nil);
   FDataSource := TDataSource.Create(nil);

   FDAO := TSimpleDAO<T>.New(TSimpleQueryFiredac.New(FConnection))
     .DataSource(FDataSource);

end;

function TDAO<T>.DataSet: TDataSet;
begin
   Result := FDataSource.DataSet;
end;

function TDAO<T>.DataSource(aDataSource: TDataSource): iSimpleDAO<T>;
begin
   FDAO.DataSource(aDataSource);
end;

function TDAO<T>.Delete(aField, aValue: String): iSimpleDAO<T>;
begin
   Result := FDAO.Delete(aField, aValue);
end;

{$IFNDEF CONSOLE}

function TDAO<T>.Delete: iSimpleDAO<T>;
begin
   Result := FDAO.Delete;
end;
{$ENDIF}

function TDAO<T>.Delete(aValue: T): iSimpleDAO<T>;
begin
   Result := FDAO.Delete(aValue);
end;

destructor TDAO<T>.destroy;
begin
    if assigned(FConnection) then
    FConnection.close;
   FreeAndNil(FConnection);
   FreeAndNil(FDataSource);
end;

function TDAO<T>.Find(aId: Integer): T;
begin
   Result := FDAO.Find(aId);
end;

function TDAO<T>.Find(aKey: String; aValue: Variant): iSimpleDAO<T>;
begin
   Result := FDAO.Find(aKey, aValue);
end;

function TDAO<T>.FindByGuid(aGuid: String): T;
begin
     Result := T.Create;
     FDAO.Find('guid', aGuid);
     TSimpleRTTI<T>.New(nil).DataSetToEntity(DataSet, Result);
end;

function TDAO<T>.Find(aBindList: Boolean): iSimpleDAO<T>;
begin
   Result := FDAO.Find(aBindList);
end;

function TDAO<T>.Find(var aList: TObjectList<T>): iSimpleDAO<T>;
begin
   Result := FDAO.Find(aList);
end;

function TDAO<T>.Insert(aValue: T): iSimpleDAO<T>;
begin
   Result := FDAO.Insert(aValue);
end;

{$IFNDEF CONSOLE}

function TDAO<T>.Insert: iSimpleDAO<T>;
begin
   Result := FDAO.Insert;
end;

{$ENDIF}

function TDAO<T>.LastID: iSimpleDAO<T>;
begin
   Result := FDAO.LastID;
end;

function TDAO<T>.LastRecord: iSimpleDAO<T>;
begin
   Result := FDAO.LastRecord;
end;

procedure TDAO<T>.SetConnection(const Value: Tconnection);
begin
   FConnection := Value;
end;

function TDAO<T>.SQL: iSimpleDAOSQLAttribute<T>;
begin
   Result := FDAO.SQL;
end;

function TDAO<T>.ToJSONArray: TJSONArray;
begin
   Result:= DataSet.ToJSONArray();
end;

function TDAO<T>.ToJSONObject: TJSONObject;
begin
   Result:= DataSet.ToJSONObject();
end;

function TDAO<T>.ToTType: T;
begin
     Result := T.Create;
     TSimpleRTTI<T>.New(nil).DataSetToEntity(DataSet, Result);
end;

function TDAO<T>.Update(aValue: T): iSimpleDAO<T>;
begin
   Result := FDAO.Update(aValue);
end;

{$IFNDEF CONSOLE}

function TDAO<T>.Update: iSimpleDAO<T>;
begin
   Result := FDAO.Update;
end;
{$ENDIF}

end.
