program AuthenticationJWT;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  Horse.JWT,
  Horse.GBSwagger,
  Horse.Request,
  Web.HTTPApp,
  DateUtils,
  JOSE.Context,
  AuthenticationJWT2 in 'AuthenticationJWT2.pas',
  UModelUser in 'src\models\UModelUser.pas',
  UModelConnection in 'src\models\UModelConnection.pas',
  controllersUser in 'src\controllers\controllersUser.pas',
  UModelDAO in 'src\models\UModelDAO.pas',
  URepositoryUser in 'src\repository\URepositoryUser.pas',
  UModelAuthentication in 'src\models\UModelAuthentication.pas',
  URepositoryAuthentication in 'src\repository\URepositoryAuthentication.pas',
  UConfig in 'UConfig.pas',
  UUtils in 'src\UUtils.pas';

var
   Server: THorse;
   xConfig: IHorseJWTConfig;
   xAuthenticationJWT: TAuthenticationJWT;
   xConnection: Tconnection;

procedure StartSwaggerDocumentation;
begin
  Swagger
      .Info
        .Title('Documentação API - AuthenticationJWT')
          .TermsOfService('')
          .License
            .Name('Criado por - Tiago da Silva Montalvão')
            .Email('tiago_cba10@hotmail.com')
            .URL('https://linkedin.com/in/tiago-da-silva-montalv%C3%A3o-959974241')
          .&End
          .Contact
            .Name('Tiago da Silva Montalvão')
            .Email('tiago_cba10@hotmail.com')
            .URL('https://linkedin.com/in/tiago-da-silva-montalv%C3%A3o-959974241/')
          .&End
          .Version('1.0.0.1')
          .Description('Documentação para familiarização com a API desenvolvida')
        .&End
      .BasePath('v1')
      .Path('/logout')
        .Tag('Login')
        .POST('Logout', 'Logout do sistema')
          .AddParamHeader('Authorization', 'Insira: Bearer token')
            .Required(True)
            .&End
          .AddResponse(200).&End
          .AddResponse(401).&End
          .AddResponse(500).&End
        .&End
      .&End
      .Path('/login')
        .Tag('Login')
        .POST('Logar', 'Logar no sistema')
          .AddParamBody('Dados do Usuário', 'Email e Password')
            .Required(True)
            .Schema(TUser)
          .&End
          .AddResponse(200).&End
          .AddResponse(401).&End
          .AddResponse(500).&End
        .&End
      .&End
      .Path('/users')
      .Tag('Users')
        .Get('Obter usuários', 'Obter todos os Usuários')
        .AddParamHeader('Authorization', 'Insira: Bearer token')
            .Required(True)
            .&End
          .AddResponse(200).IsArray(true).&End
          .AddResponse(400).&End
          .AddResponse(500).&End
        .&End
         .&End
      .Path('/user/{id}')
      .Tag('Users')
        .Get('Obter usuário', 'Obter usuário por código')
         .AddParamPath('id', 'código do Usuário ')
           .Schema(SWAG_INTEGER).&End
        .AddParamHeader('Authorization', 'Insira: Bearer token')
            .Required(True)
            .&End
          .AddResponse(200).IsArray(False).&End
          .AddResponse(400).&End
          .AddResponse(500).&End
        .&End
        .&End
      .Path('/user/{id}')
      .Tag('Users')
        .DELETE('Apagar usuário', 'Apagar usuário por código')
         .AddParamPath('id', 'código do Usuário ')
           .Schema(SWAG_INTEGER).&End
        .AddParamHeader('Authorization', 'Insira: Bearer token')
            .Required(True)
            .&End
          .AddResponse(204).IsArray(False).&End
          .AddResponse(400).&End
          .AddResponse(500).&End
        .&End
        .&End
      .Path('/users')
      .Tag('Users')
        .Post('Inserir usuário', 'Inserir um ou varios usuários')
         .AddParamBody('Dados do Usuário', 'Dados do Usuário (pode ser um objeto ou um array) ')
         .Schema(TUser)
         .Required(True).&End
        .AddParamHeader('Authorization', 'Insira: Bearer token')
            .Required(True)
            .&End
          .AddResponse(201).IsArray(False).&End
          .AddResponse(400).&End
          .AddResponse(500).&End
        .&End
        .&End
      .Path('/user')
      .Tag('Users')
        .Put('Alterar usuário', 'Alterar usuário')
         .AddParamBody('Dados do Usuário', 'Dados do Usuário ')
         .Schema(TUser)
         .Required(True).&End
        .AddParamHeader('Authorization', 'Insira: Bearer token')
            .Required(True)
            .&End
          .AddResponse(200).IsArray(False).&End
          .AddResponse(400).&End
          .AddResponse(500).&End
        .&End
end;

begin
   TConfig.LoadVariables;

   Server := THorse.Create();
   Server.Use(HorseSwagger());// Access http://localhost:9000/swagger/doc/html
   Server.Use(Jhonson());


   controllersUser.RegistryRoutes(Server);
   StartSwaggerDocumentation;

   Server.Listen(TConfig.ApiPort, TConfig.APIHost,
      procedure
      begin
         Writeln('Iniciado em ' + Server.Host + ':' + Server.Port.ToString);
      end,
      procedure
      begin
         Writeln('Finalizado server ' + Server.Host + ':' +
           Server.Port.ToString);
      end);

   ReportMemoryLeaksOnShutdown := True;

end.

//todo
//        criptografar senha
//        atualizar coluna
//        fazer patch user
