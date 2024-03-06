unit AuthenticationJWT2;

interface

uses
   Horse,
   Horse.JWT,
   JOSE.Core.JWT,
   JOSE.Core.Builder,
   DateUtils,
   System.SysUtils;

type
   TTokenInformation = record
      Expiration: TDateTime;
      Token: String;
   end;

   TAuthenticationJWT = class
   private

      { private declarations }
   protected
      { protected declarations }
   public
      function GeneratToken(): TTokenInformation;
     class procedure ValidationToken(pServer: THorse);

      { public declarations }

   published
      { published declarations }
   end;

implementation

{ TAuthenticationJWT }

function TAuthenticationJWT.GeneratToken: TTokenInformation;
var
   xToken: TJWT;

begin
   try
      xToken := TJWT.Create;
      xToken.Claims.Issuer := 'User';
      xToken.Claims.Subject := 'Key';
      xToken.Claims.Expiration := IncMinute(Now, 11);

      // Outros claims
      xToken.Claims.SetClaimOfType<String>('Name', 'Tiago');
      xToken.Claims.SetClaimOfType<boolean>('Active', True);

      Result.Expiration := xToken.Claims.Expiration;
      Result.Token := TJOSE.SHA256CompactToken
        ('my_very_long_and_safe_secret_key1', xToken);
   finally
      FreeAndNil(xToken);
   end;
end;

class procedure TAuthenticationJWT.ValidationToken(pServer: THorse);
var
   xConfig: IHorseJWTConfig;
begin
   xConfig := THorseJWTConfig.Create;
   xConfig.SkipRoutes('/login');

   pServer.use(HorseJWT('my_very_long_and_safe_secret_key1', xConfig));
end;

end.
