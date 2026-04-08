unit Repositories.Lancamentos;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Param,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase,
  Data.DB, FireDAC.Comp.Client, System.JSON, DataSet.Serialize, FireDAC.DApt;

type
  TDmLancamentos = class(TDataModule)
    ConnLancamento: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
  private
    procedure DataModuleCreate(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
    function ListarLancamentos(id_usuario, id_categoria: integer;
                               dt_de, dt_ate: string): TJsonArray;

    function ListarLancamentoId(id_usuario, id_lancamento: integer): TJsonObject;

    function InserirLancamentoId(id_usuario, id_categoria: integer; descricao,
      tipo, dt_lancamento: string; valor: double): TJsonObject;

    function InserirLancamento(id_usuario, id_categoria: integer; descricao,
      tipo, dt_lancamento: string; valor: double): TJsonObject;

    procedure EditarLancamento(id_usuario, id_lancamento, id_categoria: integer; descricao,
      tipo, dt_lancamento: string; valor: double);

    function ExcluirLancamento(
  id_usuario, id_lancamento: Integer
): Integer;
  end;

  var
  DmLancamentos: TDmLancamentos;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmLancamentos.DataModuleCreate(Sender: TObject);
begin
  ConnLancamento.Params.Add('Database=127.0.0.1/3050:E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB');
  FDPhysFBDriverLink.VendorLib:= 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll';
end;

function TDmLancamentos.ListarLancamentos(id_usuario, id_categoria: integer;
                                    dt_de, dt_ate: string): TJsonArray;
var
    qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := ConnLancamento;

    qry.SQL.Add('Select l.*, coalesce(c.descricao, ''Sem Categoria'') as categoria From lancamento l ');
    qry.SQL.Add('left join categoria c on (c.id_categoria = l.id_categoria and c.id_usuario = l.id_usuario)');
    qry.SQL.Add('Where l.id_usuario = :id_usuario');

    if id_categoria > 0 then
    begin
      qry.SQL.Add('And l.id_categoria = :id_categoria');
      qry.ParamByName('id_categoria').Value := id_categoria;
    end;

    if dt_de <> '' then
    begin
      qry.SQL.Add('And l.dt_lancamento >= :dt_de');
      qry.ParamByName('dt_de').Value := dt_de;
    end;

    if dt_ate <> '' then
    begin
      qry.SQL.Add('And l.dt_lancamento <= :dt_ate');
      qry.ParamByName('dt_ate').Value := dt_ate;
    end;

    qry.SQL.Add('Order By l.dt_lancamento DESC');

    qry.ParamByName('id_usuario').Value := id_usuario;
    qry.Active := true;

    Result := qry.ToJSONArray;

  finally
    FreeAndNil(qry);
  end;
end;

function TDmLancamentos.ListarLancamentoId(id_usuario,
                                     id_lancamento: integer): TJsonObject;

var
    qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := ConnLancamento;

    qry.SQL.Add('Select l.*, coalesce(c.descricao, ''Sem Categoria'') as categoria  From lancamento l ');
    qry.SQL.Add('left join categoria c on (c.id_categoria = l.id_categoria and c.id_usuario = l.id_usuario)');
    qry.SQL.Add('Where l.id_lancamento = :id_lancamento And l.id_usuario = :id_usuario');

    qry.ParamByName('id_usuario').Value := id_usuario;
    qry.ParamByName('id_lancamento').Value := id_lancamento;

    qry.Active := true;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;



function TDmLancamentos.InserirLancamentoId(id_usuario, id_categoria: integer;
                                            descricao, tipo, dt_lancamento: string;
                                            valor: double): TJsonObject;

var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnLancamento;

    qry.SQL.Add('INSERT INTO lancamento (descricao, valor, tipo, id_categoria, dt_lancamento, id_usuario)');
    qry.SQL.Add('VALUES (:descricao, :valor, :tipo, :id_categoria, :dt_lancamento, :id_usuario)');
    qry.SQL.Add('RETURNING id_lancamento');

     //✅ Parâmetros
    qry.ParamByName('descricao').AsString := descricao;
    qry.ParamByName('valor').AsFloat := valor;
    qry.ParamByName('tipo').AsString := tipo;
    qry.ParamByName('id_categoria').AsInteger := id_categoria;
    qry.ParamByName('dt_lancamento').AsString := dt_lancamento;
    qry.ParamByName('id_usuario').AsInteger := id_usuario;

     //✅ Executa e retorna o id inserido como JSON
    qry.Open;
    Result := qry.ToJSONObject;
  finally
    qry.Free;
  end;
end;

function TDmLancamentos.InserirLancamento(id_usuario, id_categoria: integer;
                                            descricao, tipo, dt_lancamento: string;
                                            valor: double): TJsonObject;

var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnLancamento;

    qry.SQL.Add('INSERT INTO lancamento (descricao, valor, tipo, id_categoria, dt_lancamento, id_usuario)');
    qry.SQL.Add('VALUES (:descricao, :valor, :tipo, :id_categoria, :dt_lancamento, :id_usuario)');
    qry.SQL.Add('RETURNING id_lancamento');

     //✅ Parâmetros
    qry.ParamByName('descricao').AsString := descricao;
    qry.ParamByName('valor').AsFloat := valor;
    qry.ParamByName('tipo').AsString := tipo;
    qry.ParamByName('id_categoria').AsInteger := id_categoria;
    qry.ParamByName('dt_lancamento').AsString := dt_lancamento;
    qry.ParamByName('id_usuario').AsInteger := id_usuario;

     //✅ Executa e retorna o id inserido como JSON
    qry.Open;
    Result := qry.ToJSONObject;
  finally
    qry.Free;
  end;
end;

procedure TDmLancamentos.EditarLancamento(id_usuario, id_lancamento, id_categoria: integer;
                                            descricao, tipo, dt_lancamento: string;
                                            valor: double);

var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnLancamento;

    qry.SQL.Add('UPDATE lancamento SET descricao = :descricao, valor = :valor, tipo = :tipo,');
    qry.SQL.Add('id_categoria = :id_categoria, dt_lancamento = :dt_lancamento');
    qry.SQL.Add('WHERE id_lancamento = :id_lancamento AND id_usuario = :id_usuario');

     //✅ Parâmetros
    qry.ParamByName('descricao').Value := descricao;
    qry.ParamByName('valor').Value := valor;
    qry.ParamByName('tipo').Value := tipo;
    qry.ParamByName('id_categoria').Value := id_categoria;
    qry.ParamByName('dt_lancamento').Value := dt_lancamento;
    qry.ParamByName('id_lancamento').Value := id_lancamento;
    qry.ParamByName('id_usuario').Value := id_usuario;

    qry.ExecSQL;

  finally
    FreeAndNil(qry);
  end;
end;

function TDmLancamentos.ExcluirLancamento(
  id_usuario, id_lancamento: Integer
): Integer;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnLancamento;

    qry.SQL.Text :=
      'DELETE FROM lancamento ' +
      'WHERE id_lancamento = :id_lancamento ' +
      'AND id_usuario = :id_usuario';

    qry.ParamByName('id_lancamento').AsInteger := id_lancamento;
    qry.ParamByName('id_usuario').AsInteger := id_usuario;

    qry.ExecSQL;

    // 🔑 Retorna quantos registros foram afetados
    Result := qry.RowsAffected;

  finally
    qry.Free;
  end;
end;


end.
