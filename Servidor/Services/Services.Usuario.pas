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
function ListarUsuarioId (id_usuario: integer): TJSONObject;
function EditarUsuario (id_usuario: integer; nome, email: string): TJSONObject;
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
  json_retorno : TJSONObject;
begin
  // Validar campos obrigatórios...
    if (nome = '') or (email = '') or (senha = '') then
    raise Exception.Create('Informe todos os campos: Nome, E-mal e Senha.');

// Validação dos campos antes de salvar o usuário
if Length(Trim(nome)) < 3 then
  raise Exception.Create('O nome deve conter pelo menos 3 caracteres.');

if not email.Contains('@') or not email.Contains('.') then
  raise Exception.Create('Informe um e-mail válido.');

if Length(Trim(senha)) < 5 then
  raise Exception.Create('A senha deve conter pelo menos 5 caracteres.');


  try
    dm := TDmUsuario.Create(nil);

     // Validar se o e-mail existe...
    json_retorno := dm.ListarUsuarioByEmail(email);

    if json_retorno.Count > 0 then
      raise Exception.Create('Já existe uma conta criada com esse e-mail.');


    Result := dm.InserirUsuario(nome, email, SaltPassword(senha));

  finally
    FreeAndNil(json_retorno);
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

function ListarUsuarioId(id_usuario: Integer): TJSONObject;
var
  dm: TDmUsuario;
  usuarioJSON: TJSONObject;
begin
  Result := TJSONObject.Create; // JSON principal de resposta
  dm := TDmUsuario.Create(nil);
  try
    // Busca o usuário no banco
    usuarioJSON := dm.ListarUsuarioId(id_usuario);

    // Se encontrou o usuário
    if Assigned(usuarioJSON) then
    begin
      Result.AddPair('mensagem', 'Usuário encontrado com sucesso!');
      Result.AddPair('usuario', usuarioJSON); // insere o JSON do usuário dentro do resultado
    end
    else
    begin
      Result.AddPair('mensagem', 'Usuário não encontrado.');
      Result.AddPair('usuario', TJSONObject.Create); // evita retornar null
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function EditarUsuario(id_usuario: Integer; nome, email: string): TJSONObject;
var
  dm: TDmUsuario;
begin
  Result := TJSONObject.Create;
  dm := TDmUsuario.Create(nil);

  try
    try
      // Atualiza os dados do usuário
      dm.EditarUsuario(id_usuario, nome, email);

      // Monta o JSON de sucesso com dados atualizados
      Result.AddPair('sucesso', TJSONBool.Create(True));
      Result.AddPair('mensagem', 'Usuário atualizado com sucesso!');
      Result.AddPair('nome', nome);
      Result.AddPair('email', email);

    except
      on E: Exception do
      begin
        // Caso aconteça erro durante a atualização
        Result.AddPair('sucesso', TJSONBool.Create(False));
        Result.AddPair('mensagem', 'Erro ao atualizar usuário: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(dm);
  end;
end;





end.


