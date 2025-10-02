unit Services.Categoria;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  Repositories.Cattegoria;

function Listar (id_usuario: integer): TJsonArray;
procedure ListarId ();
procedure Inserir ();
procedure Editar ();
procedure Excluir ();
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

procedure ListarId ();
begin
end;

procedure Inserir ();
begin
end;

procedure Editar ();
begin
end;

procedure Excluir ();
begin
end;

end.
