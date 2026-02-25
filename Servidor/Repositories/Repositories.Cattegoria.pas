unit Repositories.Cattegoria;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, System.JSON, DataSet.Serialize, FireDAC.DApt;

type
  TDmCategoria = class(TDataModule)
    ConnCategoria: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ListarCategorias(id_usuario: integer): TJsonArray;
    function ListarCategoriaId(id_usuario, id_categoria: integer): TJsonObject;
    function Inserir(id_usuario: integer; descricao: string): TJsonObject;
    procedure Editar(id_usuario, id_categoria: integer; descricao: string);
    procedure Excluir(id_usuario, id_categoria: integer);
  end;

var
  DmCategoria: TDmCategoria;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmCategoria.DataModuleCreate(Sender: TObject);
begin
  ConnCategoria.Params.Add('Database=127.0.0.1/3050:E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB');
  FDPhysFBDriverLink.VendorLib:= 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll';
end;

function TDmCategoria.ListarCategorias(id_usuario: integer): TJsonArray;
var
    qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnCategoria;
    qry.SQL.Add('Select * From categoria');
    qry.SQL.Add('Where id_usuario = :id_usuario');
    qry.SQL.Add('Order By Descricao');

    qry.ParamByName('id_usuario').Value := id_usuario;

    qry.Active := true;

    Result := qry.ToJSONArray;
  finally
    FreeAndNil(qry);
  end;
end;

function TDmCategoria.ListarCategoriaId(id_usuario,
                                  id_categoria: integer): TJsonObject;
var
    qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnCategoria;
    qry.SQL.Add('Select * From categoria');
    qry.SQL.Add('Where id_categoria = :id_categoria');
    qry.SQL.Add('And id_usuario = :id_usuario');

    qry.ParamByName('id_categoria').Value := id_categoria;
    qry.ParamByName('id_usuario').Value := id_usuario;

    qry.Active := true;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

function TDmCategoria.Inserir(id_usuario: integer; descricao: string): TJsonObject;
var
    qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnCategoria;
    qry.SQL.Add('Insert Into categoria (descricao, id_usuario)');
    qry.SQL.Add('Values(:descricao, :id_usuario)');
    qry.SQL.Add('Returning id_categoria');

    qry.ParamByName('descricao').Value := descricao;
    qry.ParamByName('id_usuario').Value := id_usuario;

    qry.Open;

    Result := qry.ToJSonObject;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TDmCategoria.Editar(id_usuario, id_categoria: integer;
                               descricao: string);
var
    qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnCategoria;
    qry.SQL.Add('Update categoria set descricao = :descricao');
    qry.SQL.Add('Where id_categoria = :id_categoria');
    qry.SQL.Add('And id_usuario = :id_usuario');

    qry.ParamByName('id_usuario').Value := id_usuario;
    qry.ParamByName('id_categoria').Value := id_categoria;
    qry.ParamByName('descricao').Value := descricao;

    qry.ExecSQL;

    if qry.RowsAffected = 0 then
      raise Exception.Create('Categoria não encontrada ou não pertence ao usuário! 😕');
  finally
    FreeAndNil(qry);
  end;
end;

procedure TDmCategoria.Excluir(id_usuario, id_categoria: integer);
var
    qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnCategoria;
    qry.SQL.Add('Delete From categoria');
    qry.SQL.Add('Where id_categoria = :id_categoria');
    qry.SQL.Add('And id_usuario = :id_usuario');

    qry.ParamByName('id_usuario').Value := id_usuario;
    qry.ParamByName('id_categoria').Value := id_categoria;

    qry.ExecSQL;
  finally
    FreeAndNil(qry);
  end;
end;

end.

