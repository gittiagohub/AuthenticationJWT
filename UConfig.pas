unit UConfig;

interface

uses
   System.IniFiles;

// var
// Database: String;
// DatabaseHost: String;
// DatabasePort: integer;
// DatabaseName: String;
// DatabaseUserName: String;
// DatabasePassword: String;

type
   TConfig = class
   private

     const
     {$IFDEF _CONSOLE_TESTRUNNER}
     constConfig: String = 'ConfigTest.ini';
     {$ELSE}
     constConfig: String = 'Config.ini';
     {$ENDIF }

   const
      constDatabaseSection: String = 'DataBaseConnection';

   const
      constDatabase: String = 'Database';

   const
      constDatabaseHost: String = 'Host';

   const
      constDatabasePort: String = 'Port';

   const
      constDatabaseName: String = 'DatabaseName';

   const
      constDatabaseUserName: String = 'User';

   const
      constDatabasePassword: String = 'Pass';

      // Default values to create the file
   const
      constDefaultValueDatabase: String = 'PG';

   const
      constDefaultValueDatabaseHost: String = 'localhost';

   const
      constDefaultValueDatabasePort: integer = 5432;

   const
      constDefaultValueDatabaseName: String = 'postgres';

   const
      constDefaultValueDatabaseUserName: String = 'postgres';

   const
      constDefaultValueDatabasePassword: String = 'masterkey';

      class var FDatabase: String;
      class var FDatabaseHost: String;
      class var FDatabasePort: integer;
      class var FDatabaseName: String;
      class var FDatabaseUserName: String;
      class var FDatabasePassword: String;

   const
      constAPISection: String = 'API';

   const
      constAPIPort: String = 'Port';

   const
      constAPISecretJWT: String = 'SecretJWT';

   const
      constAPITimeExpiry: String = 'TimeExpiry';

   const
      constAPIHost: String = 'Host';

      // Default values to create the file

   const
      constDefaultValueAPIPort: integer = 9001;

   const
      constDefaultValueAPISecretJWT
        : String = 'B6D45672-5E21-455C-AB0C-ACEA5A7C8338';

   const
      constDefaultValueAPITimeExpiry: integer = 540; // 9 hours

   const
      constDefaultValueAPIHost: String = 'localhost';

      class var FAPIPort: integer;
      class var FAPISecretJWT: String;
      class var FAPITimeExpiry: integer;
      class var FAPIHost: String;

      class function LoadFile(aFileDir: String): TIniFile;

      { private declarations }
   protected
      { protected declarations }
   public
      class property Database: String read FDatabase;
      class property DatabaseHost: String read FDatabaseHost;
      class property DatabasePort: integer read FDatabasePort;
      class property DatabaseName: String read FDatabaseName;
      class property DatabaseUserName: String read FDatabaseUserName;
      class property DatabasePassword: String read FDatabasePassword;

      class property APIPort: integer read FAPIPort;
      class property APISecretJWT: String read FAPISecretJWT;
      class property APITimeExpiry: integer read FAPITimeExpiry;
      class property APIHost: String read FAPIHost;
      class Procedure LoadVariables();
      { public declarations }

   published
      { published declarations }
   end;

implementation

uses
   System.Classes, System.IOUtils, System.SysUtils;

{ TConfig }

class function TConfig.LoadFile(aFileDir: string): TIniFile;
begin
   Result := TIniFile.Create(aFileDir);

   // if there ins't a API Section, create with default values
   if not(Result.SectionExists(constAPISection)) then
   begin
      Result.WriteInteger(constAPISection, constAPIPort,
        constDefaultValueAPIPort);

      Result.WriteInteger(constAPISection, constAPITimeExpiry,
        constDefaultValueAPITimeExpiry);

      Result.WriteString(constAPISection, constAPISecretJWT,
        constDefaultValueAPISecretJWT);

      Result.WriteString(constAPISection, constAPIHost,
        constDefaultValueAPIHost);

   end;

   // if there ins't a Database Section, create with default values
   if not(Result.SectionExists(constDatabaseSection)) then
   begin
      Result.WriteString(constDatabaseSection, constDatabase,
        constDefaultValueDatabase);
      Result.WriteString(constDatabaseSection, constDatabaseHost,
        constDefaultValueDatabaseHost);
      Result.WriteInteger(constDatabaseSection, constDatabasePort,
        constDefaultValueDatabasePort);
      Result.WriteString(constDatabaseSection, constDatabaseName,
        constDefaultValueDatabaseName);
      Result.WriteString(constDatabaseSection, constDatabaseUserName,
        constDefaultValueDatabaseUserName);
      Result.WriteString(constDatabaseSection, constDatabasePassword,
        constDefaultValueDatabasePassword);
   end;
end;

class procedure TConfig.LoadVariables;
var
   xPathConfigFile: String;
   xConfigFile: TIniFile;
begin
   xPathConfigFile := TPath.Combine(ExtractFilePath(ParamStr(0)), constConfig);

   xConfigFile := LoadFile(xPathConfigFile);
   try
      FDatabase := xConfigFile.ReadString(constDatabaseSection,
        constDatabase, '');
      FDatabaseHost := xConfigFile.ReadString(constDatabaseSection,
        constDatabaseHost, '');
      FDatabasePort := xConfigFile.ReadInteger(constDatabaseSection,
        constDatabasePort, 0);
      FDatabaseName := xConfigFile.ReadString(constDatabaseSection,
        constDatabaseName, '');
      FDatabaseUserName := xConfigFile.ReadString(constDatabaseSection,
        constDatabaseUserName, '');
      FDatabasePassword := xConfigFile.ReadString(constDatabaseSection,
        constDatabasePassword, '');

      FAPIPort := xConfigFile.ReadInteger(constAPISection, constAPIPort, 0);
      FAPISecretJWT := xConfigFile.ReadString(constAPISection,
        constAPISecretJWT, '');
      FAPITimeExpiry := xConfigFile.ReadInteger(constAPISection,
        constAPITimeExpiry, 0);
      FAPIHost := xConfigFile.ReadString(constAPISection,
        constAPIHost, '');  

   finally
      FreeandNil(xConfigFile);
   end;
end;

end.
