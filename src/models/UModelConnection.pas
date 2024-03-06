unit UModelConnection;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
   FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
   FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
   Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
   System.Classes, Inifiles;

type
   Tconnection = class(TFDConnection)
   private
      FDPhysPGDriverLink: TFDPhysPGDriverLink;
      { private declarations }
   protected
      { protected declarations }
   public
      { public declarations }
      constructor Create(AOwner: TComponent); override;

   published
      { published declarations }
   end;

implementation

uses
   System.SysUtils, System.IOUtils,UConfig;

{ Tconnection }

constructor Tconnection.Create(AOwner: TComponent);
begin
   inherited;
   try
      Self.Params.DriverID := TConfig.Database;
      Self.Params.add('Server=' +TConfig.DatabaseHost);
      Self.Params.add('Port=' +IntToStr(TConfig.DatabasePort));
      Self.Params.Database := TConfig.DatabaseName;
      Self.Params.UserName := TConfig.DatabaseUserName;
      Self.Params.Password := TConfig.DatabasePassword;

//         To work with uuid in PG  delphi version 12
//         Self.Params.add('GUIDEndian=Big');

      Self.ResourceOptions.Persistent := True;
      Self.UpdateOptions.AutoCommitUpdates :=True;

      FDPhysPGDriverLink := TFDPhysPGDriverLink.Create(AOwner);
      FDPhysPGDriverLink.VendorHome := ExtractFilePath(ParamStr(0));

      Self.Connected := True;

//     CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
//      SELECT pg_get_serial_sequence('users', 'id');
//
//      select setval('public.users_id_seq', 1);
//SELECT currval('public.users_id_seq');

   except
      on E: Exception do
         raise Exception.Create('Erro fazer  conexão com o banco de dados ' +
           TConfig.DatabaseName + '.');
   end;

end;
end.
