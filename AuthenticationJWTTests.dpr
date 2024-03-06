program AuthenticationJWTTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
 DUnitTestRunner,
  TestURepositoryUser in 'src\repository\TestURepositoryUser.pas',
   UModelUser in 'src\models\UModelUser.pas',
   UModelConnection in 'src\models\UModelConnection.pas',
   controllersUser in 'src\controllers\controllersUser.pas',
   UModelDAO in 'src\models\UModelDAO.pas',
   URepositoryUser in 'src\repository\URepositoryUser.pas',
   UModelAuthentication in 'src\models\UModelAuthentication.pas',
   URepositoryAuthentication in 'src\repository\URepositoryAuthentication.pas',
   UUtils in 'src\UUtils.pas',
   UConfig in 'UConfig.pas';

{R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

