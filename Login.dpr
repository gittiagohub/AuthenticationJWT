program Login;

uses
  Vcl.Forms,
  UFrontLogin in 'UFrontLogin.pas' {FormLogin},
  UServicesUser in 'src\services\UServicesUser.pas',
  UUtils in 'src\UUtils.pas',
  UFrontUser in 'UFrontUser.pas' {FormUsers},
  System.UITypes {FormUsers},
  UModelUser in 'src\models\UModelUser.pas';

{$R *.res}
 var xFormLogin: TFormLogin;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  xFormLogin:= TFormLogin.Create(nil);
  xFormLogin.ShowModal;
  if xFormLogin.modalResult =  mrOk then
  begin
  Application.CreateForm(TFormUsers, FormUsers);
  Application.Run;
  end;
end.
