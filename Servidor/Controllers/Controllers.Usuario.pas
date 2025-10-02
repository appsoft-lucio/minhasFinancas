unit Controllers.Usuario;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Services.Usuario,
  Controllers.JWT;

procedure RegistrarRotas;
procedure Login (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure InserirUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure EditarSenha (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure ListarUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure EditarUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
implementation

procedure RegistrarRotas;
begin
    THorse.Post('/usuarios/login', Login);
    THorse.Post('/usuarios/cadastro', InserirUsuario);
    THorse.Post('/usuarios', EditarSenha);
    THorse.Post('/usuarios', ListarUsuario);
    THorse.Post('/usuarios', EditarUsuario);

end;

procedure Login (Req: THorseRequest; Res: THorseResponse; Next: TProc );
var
  email, senha: string;
  body, json_retorno: TJsonObject;

begin
  try
    body  := Req.Body<TJSONObject>;
    email := body.GetValue<string>('email', '');
    senha := body.GetValue<string>('senha','');

    json_retorno := Services.Usuario.Login(email, senha);

    if json_retorno.Count = 0 then
    begin
      Res.Send('E-mail ou Senha inválidos').status(401);

      FreeAndNil(json_retorno);
    end
    else
    begin
      //Gerar um token JWT...
      json_retorno.AddPair('token',
              Criar_Token(json_retorno.GetValue<integer>('id_usuario')));

      Res.Send<TJsonObject>(json_retorno);
    end;


  except on ex:exception do
    Res.Send(ex.Message).Status(500);

  end;

end;

procedure InserirUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Inserir Ususario :).')
end;

procedure EditarSenha (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Editar Senha :).')
end;

procedure ListarUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Listar Usuario :).')
end;

procedure EditarUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Editar Ususario :).')
end;

end.
