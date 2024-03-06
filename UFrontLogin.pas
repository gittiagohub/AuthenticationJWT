unit UFrontLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormLogin = class(TForm)
    EditLogin: TEdit;
    EditSenha: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation

uses
UServicesUser, UFrontUser;

{$R *.dfm}

procedure TFormLogin.Button1Click(Sender: TObject);
var XFormUsers : TFormUsers;
begin
    if UServicesUser.login(EditLogin.Text,EditSenha.Text).Ok then
    begin
        Close;
        ModalResult:= mrOk;
    end;
end;

end.
