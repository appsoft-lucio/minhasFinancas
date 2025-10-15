unit Services.Categoria;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  Repositories.Cattegoria;

function Listar (id_usuario: integer): TJsonArray;
function ListarCategoriaId (id_usuario, id_categoria: integer): TJSONObject;
function Inserir (id_usuario: integer; descricao: string): TJSONObject;
procedure Editar (id_usuario, id_categoria: integer; descricao: string);
procedure Excluir (id_usuario, id_categoria: integer);
implementation

function Listar (id_usuario: integer): TJsonArray;
var
  dm: TDmCategoria;
begin
  try
    dm:= TDmCategoria.Create(nil);

    Result:= dm.ListarCategorias(id_usuario);
  finally
    FreeAndNil(dm);
  end;
end;

function ListarCategoriaId (id_usuario, id_categoria: integer): TJSONObject;
var
  dm: TDmCategoria;
begin
  try
    dm:= TDmCategoria.Create(nil);

    Result:= dm.ListarCategoriaId(id_usuario, id_categoria);
  finally
    FreeAndNil(dm);
  end;
end;

function Inserir (id_usuario: integer; descricao: string): TJSONObject;
var
  dm: TDmCategoria;
begin
  try
    dm:= TDmCategoria.Create(nil);

    Result := dm.Inserir(id_usuario, descricao);
  finally
    FreeAndNil(dm);
  end;
end;

procedure Editar (id_usuario, id_categoria: integer; descricao: string);
var
  dm: TDmCategoria;
begin
  try
    dm:= TDmCategoria.Create(nil);

    dm.Editar(id_usuario, id_categoria, descricao);
  finally
    FreeAndNil(dm);
  end;
end;

procedure Excluir (id_usuario, id_categoria: integer);
var
  dm: TDmCategoria;
begin
  try
    dm:= TDmCategoria.Create(nil);

    dm.Excluir(id_usuario, id_categoria);
  finally
    FreeAndNil(dm);
  end;
end;

end.
