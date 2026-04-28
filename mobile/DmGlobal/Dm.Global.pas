unit Dm.Global;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  uSession;

type
  TDmGlobal = class(TDataModule)
    TabUsuario: TFDMemTable;
    TabLancamento: TFDMemTable;
    TabCategoria: TFDMemTable;

    procedure DataModuleCreate(Sender: TObject);

  public

    // ======================
    // USUÁRIO
    // ======================
    procedure Login(email, senha: string);
    procedure CriarConta(nome, email, senha: string);
    procedure DadosUsuarios;
    procedure EditarUsuario(nome, email: string);
    procedure EditarSenha(senha: string);

    // ======================
    // CATEGORIAS
    // ======================
    procedure ConsultarCategorias;
    procedure ConsultarCategoriasId(id_categoria: integer);
    procedure InserirCategoria(descricao: string);
    procedure EditarCategoria(id_categoria: integer; descricao: string);
    procedure ExcluirCategoria(id_categoria: integer);

    // ======================
    // LANÇAMENTOS
    // ======================
    procedure ConsultarLancamentos(id_categoria: Integer; dt_de, dt_ate: string);
    procedure ConsultarLancamentosId(id_lancamento: Integer);
    procedure InserirLancamento(descricao, tipo, dt: string; valor: Double; id_categoria: Integer);
    procedure EditarLancamento(id_lancamento: Integer; descricao, tipo, dt: string; valor: Double; id_categoria: Integer);
    procedure ExcluirLancamento(id_lancamento: Integer);

  end;

var
  DmGlobal: TDmGlobal;

const

  BASE_URL = 'http://192.168.1.18:3001';
  // BASE_URL = 'http://localhost:3001';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


// ======================
// CONFIGURAÇÃO
// ======================
procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;


// ======================
// USUÁRIO
// ======================
procedure TDmGlobal.Login(email, senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  if TabUsuario.Active then
  begin
    TabUsuario.EmptyDataSet;
    TabUsuario.FieldDefs.Clear;
  end;

  json := TJSONObject.Create;
  try
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/login')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.CriarConta(nome, email, senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  json := TJSONObject.Create;
  try
    json.AddPair('nome', nome);
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/cadastro')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.DadosUsuarios;
var
  resp: IResponse;
begin
  if TabUsuario.Active then
  begin
    TabUsuario.EmptyDataSet;
    TabUsuario.FieldDefs.Clear;
  end;

  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/usuarios')
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
    .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.EditarUsuario(nome, email: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('nome', nome);
    json.AddPair('email', email);

    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios')
      .AddBody(json.ToString)
      .Accept('application/json')
      .TokenBearer(TSession.token)
      .Put;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarSenha(senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('senha', senha);

    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/password')
      .AddBody(json.ToString)
      .Accept('application/json')
      .TokenBearer(TSession.token)
      .Post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;


// ======================
// CATEGORIAS
// ======================
procedure TDmGlobal.ConsultarCategorias;
var
  resp: IResponse;
begin
  if TabCategoria.Active then
    TabCategoria.EmptyDataSet;

  TabCategoria.FieldDefs.Clear;

  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/categorias')
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabCategoria))
    .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.ConsultarCategoriasId(id_categoria: integer);
var
  resp: IResponse;
begin
  if TabCategoria.Active then
    TabCategoria.EmptyDataSet;

  TabCategoria.FieldDefs.Clear;

  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/categorias')
    .ResourceSuffix(id_categoria.toString)
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabCategoria))
    .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.InserirCategoria(descricao: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('descricao', descricao);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/categorias')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .post;

    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarCategoria(id_categoria: integer; descricao: string);
var
  resp: IResponse;
  json: TJsonObject;
begin
  json := TJsonObject.Create;
  try
    json.AddPair('descricao', descricao);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/categorias')
                        .ResourceSuffix(id_categoria.tostring)
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .TokenBearer(TSession.token)
                        .put;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ExcluirCategoria(id_categoria: integer);
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/categorias')
                      .ResourceSuffix(id_categoria.tostring)
                      .Accept('application/json')
                      .TokenBearer(TSession.token)
                      .delete;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;


// ======================
// LANÇAMENTOS
// ======================
procedure TDmGlobal.ConsultarLancamentos(id_categoria: Integer; dt_de, dt_ate: string);
var
  resp: IResponse;
begin
  if TabLancamento.Active then
    TabLancamento.EmptyDataSet;

  TabLancamento.FieldDefs.Clear;

  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/lancamentos')
    .AddParam('id_categoria', id_categoria.ToString)
    .AddParam('dt_de', dt_de)
    .AddParam('dt_ate', dt_ate)
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabLancamento))
    .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.ConsultarLancamentosId(id_lancamento: Integer);
var
  resp: IResponse;
begin
  if TabLancamento.Active then
    TabLancamento.EmptyDataSet;

  TabLancamento.FieldDefs.Clear;

  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/lancamentos')
    .ResourceSuffix(id_lancamento.ToString)
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabLancamento))
    .Get;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.InserirLancamento(descricao, tipo, dt: string; valor: Double; id_categoria: Integer);
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('descricao', descricao);
    json.AddPair('tipo', tipo);
    json.AddPair('dt_lancamento', dt);
    json.AddPair('valor', TJSONNumber.Create(valor));
    json.AddPair('id_categoria', TJSONNumber.Create(id_categoria));

    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/lancamentos')
      .AddBody(json.ToString)
      .Accept('application/json')
      .TokenBearer(TSession.token)
      .Post;

    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarLancamento(id_lancamento: Integer; descricao, tipo, dt: string; valor: Double; id_categoria: Integer);
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('descricao', descricao);
    json.AddPair('tipo', tipo);
    json.AddPair('dt_lancamento', dt);
    json.AddPair('valor', TJSONNumber.Create(valor));
    json.AddPair('id_categoria', TJSONNumber.Create(id_categoria));

    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/lancamentos')
      .ResourceSuffix(id_lancamento.ToString)
      .AddBody(json.ToString)
      .Accept('application/json')
      .TokenBearer(TSession.token)
      .Put;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ExcluirLancamento(id_lancamento: Integer);
var
  resp: IResponse;
begin
  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/lancamentos')
    .ResourceSuffix(id_lancamento.ToString)
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Delete;

  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

end.
