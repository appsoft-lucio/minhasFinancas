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
    procedure DataModuleCreate(Sender: TObject);
  private
    { Declarações privadas }
  public
    { Declarações públicas }

    // Realiza o login do usuário enviando e-mail e senha para a API
    procedure Login(email, senha: string);
    procedure CriarConta(nome, email, senha: string);
    procedure ConsultarLancamentos(id_categoria: integer; dt_de,
                                   dt_ate: string);
  end;

var
  DmGlobal: TDmGlobal;

const
  // URL base da API
  BASE_URL = 'http://localhost:3001';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  // Define que os nomes dos campos recebidos/gerados
  // serão tratados em letras minúsculas
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;

  // Define o separador decimal para importação de dados numéricos
  // útil para evitar problemas com ponto e vírgula
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

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

  // Cria o objeto JSON que será enviado no corpo da requisição
  json := TJSONObject.Create;
  try
    // Adiciona os dados de login ao JSON
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    // Faz a requisição POST para o endpoint de login
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/login')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    // Se a API retornar um status diferente de 200,
    // gera uma exceção com o conteúdo retornado
    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    // Libera o objeto JSON da memória
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

  // Cria o objeto JSON que será enviado no corpo da requisição
  json := TJSONObject.Create;
  try
    // Faz a requisição POST para o endpoint de login
    json.AddPair('nome', nome);
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    // Faz a requisição POST para o endpoint de login
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/cadastro')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    // Se a API retornar um status diferente de 201,
    // gera uma exceção com o conteúdo retornado
    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    // Libera o objeto JSON da memória
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ConsultarLancamentos(id_categoria: integer;
                                         dt_de, dt_ate: string);
var
  resp: IResponse;
begin
  if TabLancamento.Active then
     TabLancamento.EmptyDataSet;

  TabLancamento.FieldDefs.Clear;

    // Faz a requisição POST para o endpoint de login
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

    // Se a API retornar um status diferente de 200,
    // gera uma exceção com o conteúdo retornado
    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

end;

end.
