unit UFrontUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.Buttons;

type
  TFormUsers = class(TForm)
    DBEditID: TDBEdit;
    DBEditNomeUsuario: TDBEdit;
    DBEditNomeCompleto: TDBEdit;
    DBEditEmail: TDBEdit;
    DBEditDataNascimento: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FDMemTableUsers: TFDMemTable;
    DataSourceUsers: TDataSource;
    Label6: TLabel;
    DBEditDataCadastro: TDBEdit;
    DBGrid1: TDBGrid;
    BitBtnNovo: TBitBtn;
    BitBtnAtualizar: TBitBtn;
    BitBtnApagar: TBitBtn;
    BitBtnBuscaTodos: TBitBtn;
    BitBtnBuscaPorID: TBitBtn;
    GroupBox1: TGroupBox;
    EditBuscaPorID: TEdit;
    EditSenha: TEdit;
    LabelSenha: TLabel;
    ButtonLogout: TButton;
    procedure BitBtnNovoClick(Sender: TObject);
    procedure BitBtnBuscaTodosClick(Sender: TObject);
    procedure BitBtnApagarClick(Sender: TObject);
    procedure BitBtnAtualizarClick(Sender: TObject);
    procedure BitBtnBuscaPorIDClick(Sender: TObject);
    procedure ButtonLogoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
  end;

var
  FormUsers: TFormUsers;

implementation

uses
  UServicesUser, UUtils;

{$R *.dfm}

{ TFormUsers }

procedure TFormUsers.BitBtnAtualizarClick(Sender: TObject);
var
  LResult: TResult;
begin
   LResult:= UServicesUser.SendUpdateUser(strToint(DBEditID.text),
                                          DBEditNomeUsuario.Text,
                                          DBEditNomeCompleto.Text,
                                          DBEditEmail.Text,
                                          EditSenha.Text,
                                          StrtodateTime(DBEditDataNascimento.Text));
   if not(LResult.OK) then
   begin
       ShowMessage(LResult.MSGError);
   end
end;

procedure TFormUsers.BitBtnApagarClick(Sender: TObject);
var LResult : TResult;
begin
   LResult := UServicesUser.SendDeleteUser(StrToInt(DBEditID.Text),FDMemTableUsers);
   if not(LResult.OK) then
   begin
       ShowMessage(LResult.MSGError);
   end;
end;

procedure TFormUsers.BitBtnBuscaPorIDClick(Sender: TObject);
var
  LResult: TResult;
begin
   LResult := UServicesUser.SendGetUserByID(StrToInt(EditBuscaPorID.Text),FDMemTableUsers);
   if not(LResult.OK) then
   begin
       ShowMessage(LResult.MSGError);
   end;

   EditBuscaPorID.Clear;
end;

procedure TFormUsers.BitBtnBuscaTodosClick(Sender: TObject);
var
  LResult: TResult;
begin
   LResult := UServicesUser.SendGetAllUsers(FDMemTableUsers);
   if not(LResult.OK) then
   begin
       ShowMessage(LResult.MSGError);
   end;
end;

procedure TFormUsers.BitBtnNovoClick(Sender: TObject);
var LResult : TResult;
begin
    if FDMemTableUsers.State = dsBrowse  then
    begin
         FDMemTableUsers.Append;
         BitBtnNovo.Caption := 'Gravar';
         EditSenha.Visible :=True;
         LabelSenha.Visible:=True;
    end
    else
    begin
      LResult:= UServicesUser.SendpostUser(DBEditNomeUsuario.Text,
                                  DBEditNomeCompleto.Text,
                                  DBEditEmail.Text,
                                  EditSenha.Text,
                                  StrtodateTime(DBEditDataNascimento.Text));

       if LResult.OK then
       begin
             BitBtnNovo.Caption := 'Novo';

             EditSenha.Visible :=False;
             LabelSenha.Visible:=False;
       end
       else
       begin
           ShowMessage(LResult.MSGError);
       end;
    end;
end;

procedure TFormUsers.ButtonLogoutClick(Sender: TObject);
begin
   UServicesUser.logout();
end;

constructor TFormUsers.Create(AOwner: TComponent);
begin
  inherited;
   UServicesUser.SendGetUser(0,  FDMemTableUsers );
end;

end.
