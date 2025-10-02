unit Controllers.Categoria;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  Services.Categoria;

procedure RegistrarRotas;
procedure Listar (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure ListarId (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure Inserir (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure Editar (Req: THorseRequest; Res: THorseResponse; Next: TProc );
procedure Excluir (Req: THorseRequest; Res: THorseResponse; Next: TProc );
implementation

procedure RegistrarRotas;
begin
    THorse.Get('/categorias', Listar);
    THorse.Get('/categorias/:id_categoria', ListarId);
    THorse.Post('/categorias', Inserir);
    THorse.Put('/categorias/:id_categoria', Editar);
    THorse.Delete('/categorias/:id_categoria', Excluir);

end;

procedure Listar (Req: THorseRequest; Res: THorseResponse; Next: TProc );

var
  id_usuario: integer;

begin
  try
    id_usuario:= 1;

    Res.Send<TJsonArray>(Services.Categoria.Listar(id_usuario))

  except on ex:exception do

    Res.Send(ex.message).status(500);

  end;

end;

procedure ListarId (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Listar Categoria por Id :).')
end;

procedure Inserir (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Listar Categoria por Id :).')
end;


procedure Editar (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Editar Categoria :).')
end;

procedure Excluir (Req: THorseRequest; Res: THorseResponse; Next: TProc );
begin
  Res.Send('Vc acessou a rota Excluir Categoria :).')
end;

end.
