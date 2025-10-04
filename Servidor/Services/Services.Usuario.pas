unit Services.Usuario;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Repositories.Usuario,
  uMD5;

function Login (email, senha: string): TJsonObject;
function InserirUsuario (nome, email, senha: string): TJsonObject;
procedure EditarSenha (id_usuario: integer; senha: string);
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

function InserirUsuario (nome, email, senha: string): TJsonObject;
var
  dm : TDmUsuario;
begin
  try
    dm := TDmUsuario.Create(nil);

    Result := dm.InserirUsuario(nome, email, SaltPassword(senha));

  finally
    FreeAndNil(dm);
  end;

end;

procedure EditarSenha (id_usuario: integer; senha: string);
var
  dm : TDmUsuario;
begin
  try
    dm := TDmUsuario.Create(nil);

    dm.EditarSenha(id_usuario, SaltPassword(senha));

  finally
    FreeAndNil(dm);
  end;

end;

end.


