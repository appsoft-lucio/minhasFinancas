unit Services.Usuario;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Repositories.Usuario,
  uMD5;

function Login (email, senha: string): TJsonObject;
implementation

function Login (email, senha: string): TJsonObject;
var
  dm : TDmUsuario;
begin
  try
    dm := TDmUsuario.Create(nil);

    Result := dm.Login(email, SaltPassword(senha));

  finally
    FreeAndNil(dm);
  end;

end;

end.
