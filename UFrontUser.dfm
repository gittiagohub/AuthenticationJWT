object FormUsers: TFormUsers
  Left = 0
  Top = 0
  Caption = 'Usu'#225'rios'
  ClientHeight = 439
  ClientWidth = 638
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
    Left = 33
    Top = 24
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 32
    Top = 51
    Width = 81
    Height = 13
    Caption = 'Nome do Usu'#225'rio'
  end
  object Label3: TLabel
    Left = 33
    Top = 78
    Width = 75
    Height = 13
    Caption = 'Nome Completo'
  end
  object Label4: TLabel
    Left = 32
    Top = 105
    Width = 24
    Height = 13
    Caption = 'Email'
  end
  object Label5: TLabel
    Left = 33
    Top = 132
    Width = 96
    Height = 13
    Caption = 'Data de Nascimento'
  end
  object Label6: TLabel
    Left = 32
    Top = 159
    Width = 85
    Height = 13
    Caption = 'Data do Cadastro'
  end
  object LabelSenha: TLabel
    Left = 32
    Top = 186
    Width = 30
    Height = 13
    Caption = 'Senha'
    Visible = False
  end
  object DBEditID: TDBEdit
    Left = 129
    Top = 21
    Width = 232
    Height = 21
    DataField = 'ID'
    DataSource = DataSourceUsers
    ReadOnly = True
    TabOrder = 0
  end
  object DBEditNomeUsuario: TDBEdit
    Left = 129
    Top = 48
    Width = 232
    Height = 21
    DataField = 'username'
    DataSource = DataSourceUsers
    TabOrder = 1
  end
  object DBEditNomeCompleto: TDBEdit
    Left = 129
    Top = 75
    Width = 232
    Height = 21
    DataField = 'fullname'
    DataSource = DataSourceUsers
    TabOrder = 2
  end
  object DBEditEmail: TDBEdit
    Left = 129
    Top = 102
    Width = 232
    Height = 21
    DataField = 'email'
    DataSource = DataSourceUsers
    TabOrder = 3
  end
  object DBEditDataNascimento: TDBEdit
    Left = 129
    Top = 129
    Width = 232
    Height = 21
    DataField = 'birthdate'
    DataSource = DataSourceUsers
    TabOrder = 4
  end
  object DBEditDataCadastro: TDBEdit
    Left = 128
    Top = 156
    Width = 233
    Height = 21
    DataField = 'created_at'
    DataSource = DataSourceUsers
    ReadOnly = True
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 288
    Width = 638
    Height = 151
    Align = alBottom
    DataSource = DataSourceUsers
    ReadOnly = True
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'username'
        Title.Caption = 'Nome'
        Width = 144
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'fullname'
        Title.Caption = 'Nome Completo'
        Width = 131
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'email'
        Title.Caption = 'Email'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'birthdate'
        Title.Caption = 'Data de Nascimento'
        Width = 112
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'created_at'
        Title.Caption = 'Data de Cria'#231#227'o'
        Width = 100
        Visible = True
      end>
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 219
    Width = 638
    Height = 69
    Align = alBottom
    Caption = 'A'#231#245'es'
    TabOrder = 7
    object BitBtnNovo: TBitBtn
      Left = 18
      Top = 23
      Width = 75
      Height = 42
      Caption = 'Novo'
      TabOrder = 0
      OnClick = BitBtnNovoClick
    end
    object BitBtnAtualizar: TBitBtn
      Left = 121
      Top = 23
      Width = 75
      Height = 42
      Caption = 'Atualizar'
      TabOrder = 1
      OnClick = BitBtnAtualizarClick
    end
    object BitBtnApagar: TBitBtn
      Left = 224
      Top = 23
      Width = 75
      Height = 42
      Caption = 'Apagar'
      TabOrder = 2
      OnClick = BitBtnApagarClick
    end
    object BitBtnBuscaTodos: TBitBtn
      Left = 323
      Top = 23
      Width = 78
      Height = 42
      Caption = 'Buscar Todos'
      TabOrder = 3
      OnClick = BitBtnBuscaTodosClick
    end
    object BitBtnBuscaPorID: TBitBtn
      Left = 427
      Top = 23
      Width = 75
      Height = 42
      Caption = 'Buscar por ID'
      TabOrder = 4
      OnClick = BitBtnBuscaPorIDClick
    end
    object EditBuscaPorID: TEdit
      Left = 508
      Top = 40
      Width = 77
      Height = 21
      NumbersOnly = True
      TabOrder = 5
    end
  end
  object EditSenha: TEdit
    Left = 129
    Top = 183
    Width = 232
    Height = 21
    TabOrder = 8
    Visible = False
  end
  object ButtonLogout: TButton
    Left = 544
    Top = 8
    Width = 86
    Height = 56
    Caption = 'Logout'
    TabOrder = 9
    OnClick = ButtonLogoutClick
  end
  object FDMemTableUsers: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 512
    Top = 72
  end
  object DataSourceUsers: TDataSource
    DataSet = FDMemTableUsers
    Left = 416
    Top = 72
  end
end
