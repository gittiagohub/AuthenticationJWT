object FormLogin: TFormLogin
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 225
  ClientWidth = 235
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 64
    Width = 25
    Height = 13
    Caption = 'Login'
  end
  object Label2: TLabel
    Left = 24
    Top = 101
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object EditLogin: TEdit
    Left = 56
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EditSenha: TEdit
    Left = 56
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 56
    Top = 144
    Width = 121
    Height = 25
    Caption = 'Logar'
    TabOrder = 2
    OnClick = Button1Click
  end
end
