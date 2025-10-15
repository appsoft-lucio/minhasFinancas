unit Controllers.Usuario;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Services.Usuario,
  Controllers.JWT,
  Horse.JWT;

procedure RegistrarRotas;
procedure Login (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure InserirUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure EditarSenha (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure ListarUsuarioId (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure EditarUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
implementation

procedure RegistrarRotas;
begin
    //Rotas abertas
    THorse.Post('/usuarios/login', Login);
    THorse.Post('/usuarios/cadastro', InserirUsuario);

    //Rotas protegidas
    THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                        THorseJWTConfig.New.SessionClass(TMyClaims)))
                        .Post('/usuarios/password', EditarSenha);
    THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                        THorseJWTConfig.New.SessionClass(TMyClaims)))
                        .Get('/usuarios', ListarUsuarioId);
    THorse.AddCallback(HorseJWT(Controllers.JWT.SECRET,
                        THorseJWTConfig.New.SessionClass(TMyClaims)))
                        .Put('/usuarios', EditarUsuario);

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
var
  nome, email, senha: string;
  body, json_retorno: TJsonObject;

begin
  try
    body  := Req.Body<TJSONObject>;
    nome := body.GetValue<string>('nome', '');
    email := body.GetValue<string>('email', '');
    senha := body.GetValue<string>('senha','');

    json_retorno := Services.Usuario.InserirUsuario(nome, email, senha);

    //Gerar um token JWT...
    json_retorno.AddPair('token',
            Criar_Token(json_retorno.GetValue<integer>('id_usuario')));

    Res.Send<TJsonObject>(json_retorno).Status(201);

  except on ex:exception do
    Res.Send(ex.Message).Status(500);

  end;
end;

procedure EditarSenha (Req: THorseRequest; Res: THorseResponse; Next: TProc );
var
  senha: string;
  id_usuario: integer;
  body: TJsonObject;
begin
  try
    body  := Req.Body<TJSONObject>;
    senha := body.GetValue<string>('senha','');

    id_usuario:= Get_usuario_Request(Req);

    Services.Usuario.EditarSenha(id_usuario, senha);



    Res.Send('Ok');

  except on ex:exception do
    Res.Send(ex.Message).Status(500);

  end;
end;

procedure ListarUsuarioId (Req: THorseRequest; Res: THorseResponse; Next: TProc );
var
  id_usuario: integer;

begin
  try
    id_usuario:= Get_usuario_Request(Req);

    Res.Send<TJsonObject>(Services.Usuario.ListarUsuarioId(id_usuario));

  except on ex:exception do
    Res.Send(ex.Message).Status(500);

  end;
end;

procedure EditarUsuario (Req: THorseRequest; Res: THorseResponse; Next: TProc );
var
  nome, email: string;
  id_usuario: integer;
  body, respJSON: TJsonObject;
begin
  try
    body  := Req.Body<TJSONObject>;
    nome := body.GetValue<string>('nome','');
    email := body.GetValue<string>('email','');

    id_usuario := Get_usuario_Request(Req);

    // Pega o JSON de retorno da função
    respJSON := Services.Usuario.EditarUsuario(id_usuario, nome, email);

    // Envia o JSON para o cliente
    Res.Send<TJsonObject>(respJSON);

  except on ex:exception do
    Res.Send(ex.Message).Status(500);
  end;
end;

end.
