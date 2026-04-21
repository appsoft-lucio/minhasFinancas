unit Services.Categoria;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  Repositories.Cattegoria,
  Repositories.Lancamentos;

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

procedure Excluir(id_usuario, id_categoria: integer);
var
  dm: TDmCategoria;
  dml: TDmLancamentos;
  categoria: TJSONObject;
begin
  try
    dm := TDmCategoria.Create(nil);
    dml := TDmLancamentos.Create(nil);

    // ?? Descobre qual categoria é
    categoria := dm.ListarCategoriaId(id_usuario, id_categoria);

    if categoria.GetValue<string>('descricao').ToLower = 'sem categoria' then
      raise Exception.Create('Categoria padrão não pode ser excluída.');

    // 1?? garante existência
    dm.GarantirCategoriaPadrao(id_usuario);

    // 2?? move lançamentos
    dml.AtualizarCategoriaPorDescricao(
      id_usuario,
      id_categoria,
      'Sem categoria'
    );

    // 3?? exclui
    dm.Excluir(id_usuario, id_categoria);

  finally
    FreeAndNil(dm);
    FreeAndNil(dml);
    FreeAndNil(categoria);
  end;
end;

end.
