unit Dm.Global;

interface

uses
  // Units básicas do Delphi
  System.SysUtils,
  System.Classes,
  System.JSON,

  // Biblioteca para requisições HTTP
  RESTRequest4D,

  // Adapter para converter JSON da API em dataset
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config,

  // FireDAC para datasets em memória
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

  // Sessão do usuário logado
  uSession;

type
  TDmGlobal = class(TDataModule)
    // Dataset em memória para dados do usuário
    TabUsuario: TFDMemTable;

    // Dataset em memória para lançamentos financeiros
    TabLancamento: TFDMemTable;

    // Dataset em memória para categorias
    TabCategoria: TFDMemTable;

    // Evento executado ao criar o DataModule
    procedure DataModuleCreate(Sender: TObject);
  private
    { Declarações privadas }
  public
    { Declarações públicas }

    // Realiza login do usuário
    procedure Login(email, senha: string);

    // Cria uma nova conta de usuário
    procedure CriarConta(nome, email, senha: string);

    // Consulta lançamentos com filtro por categoria e período
    procedure ConsultarLancamentos(id_categoria: Integer; dt_de, dt_ate: string);

    // Consulta as categorias do usuário
    procedure ConsultarCategotias;

    // Insere um novo lançamento financeiro
    procedure InserirLancamento(descricao, tipo, dt: string; valor: Double;
      id_categoria: Integer);

    procedure ConsultarLancamentosId(id_lancamento: Integer);

    procedure EditarLancamento(id_lancamento: integer; descricao, tipo,
      dt: string; valor: Double; id_categoria: Integer);

    procedure ExcluirLancamento(id_lancamento: integer);
  end;

var
  DmGlobal: TDmGlobal;

const
  {
    URL base da API.

    Use uma das opções abaixo conforme o ambiente de teste:

    1) Teste no PC:
       localhost aponta para a própria máquina

    2) Teste no celular:
       use o IP local do computador
       Exemplo: http://192.168.1.16:3001

    Observações:
    - PC e celular devem estar na mesma rede
    - A API deve estar em execução
    - O firewall pode bloquear a conexão
  }
  // BASE_URL = 'http://192.168.1.16:3001';
   BASE_URL = 'http://localhost:3001';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  {
    Define que os nomes dos campos importados do JSON
    serão tratados em letras minúsculas.

    Exemplo:
    "ID_USUARIO" -> "id_usuario"
  }
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;

  {
    Define o separador decimal usado ao importar números.

    Isso evita problemas com valores decimais vindos da API,
    principalmente quando o JSON usa ponto como separador.
  }
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDmGlobal.Login(email, senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  {
    Limpa o dataset do usuário antes de carregar novos dados.
    Isso evita misturar informações antigas com a resposta atual.
  }
  if TabUsuario.Active then
  begin
    TabUsuario.EmptyDataSet;
    TabUsuario.FieldDefs.Clear;
  end;

  // Cria o JSON que será enviado para a API
  json := TJSONObject.Create;
  try
    {
      Monta o corpo da requisição com os dados de login.
    }
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    {
      Envia uma requisição POST para o endpoint de login.

      - /usuarios/login: endpoint de autenticação
      - AddBody: envia o JSON no corpo da requisição
      - Accept('application/json'): informa que a resposta esperada é JSON
      - Adapters(...): converte o JSON recebido em dataset
    }
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/login')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    {
      Se o status retornado não for 200,
      considera que houve erro no login.
    }
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
  {
    Limpa o dataset do usuário antes de carregar os dados do novo cadastro.
  }
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  // Cria o JSON que será enviado para a API
  json := TJSONObject.Create;
  try
    {
      Monta o corpo da requisição com os dados do usuário.
    }
    json.AddPair('nome', nome);
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    {
      Envia uma requisição POST para o endpoint de cadastro.
    }
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/cadastro')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    {
      Cadastro com sucesso normalmente retorna 201 (Created).
      Se retornar outro código, gera exceção com a mensagem da API.
    }
    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    // Libera o objeto JSON da memória
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ConsultarLancamentos(id_categoria: Integer; dt_de, dt_ate: string);
var
  resp: IResponse;
begin
  {
    Limpa os lançamentos antigos antes de buscar os novos dados.
  }
  if TabLancamento.Active then
    TabLancamento.EmptyDataSet;

  TabLancamento.FieldDefs.Clear;

  {
    Faz uma requisição GET para consultar os lançamentos.

    Parâmetros enviados:
    - id_categoria: filtra por categoria
    - dt_de: data inicial
    - dt_ate: data final

    O token JWT é enviado para permitir acesso aos dados protegidos.
  }
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

  {
    Se a API não retornar 200, houve erro na consulta.
  }
  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.ConsultarLancamentosId(id_lancamento: Integer);
var
  resp: IResponse;
begin
  {
    Limpa os lançamentos antigos antes de buscar os novos dados.
  }
  if TabLancamento.Active then
    TabLancamento.EmptyDataSet;

  TabLancamento.FieldDefs.Clear;

  {
    Faz uma requisição GET para consultar os lançamentos.

    Parâmetros enviados:
    - id_categoria: filtra por categoria
    - dt_de: data inicial
    - dt_ate: data final

    O token JWT é enviado para permitir acesso aos dados protegidos.
  }
  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/lancamentos')
    .ResourceSuffix(id_lancamento.ToString)
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabLancamento))
    .Get;

  {
    Se a API não retornar 200, houve erro na consulta.
  }
  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.ConsultarCategotias;
var
  resp: IResponse;
begin
  {
    Limpa os dados antigos das categorias antes de carregar os novos.
    Isso evita duplicidade e dados desatualizados.
  }
  if TabCategoria.Active then
    TabCategoria.EmptyDataSet;

  {
    Remove os campos antigos para que sejam recriados
    conforme o novo retorno da API.
  }
  TabCategoria.FieldDefs.Clear;

  {
    Faz uma requisição GET para buscar as categorias.

    - Endpoint: /categorias
    - TokenBearer: envia o token JWT do usuário logado
    - Adapter: converte a resposta JSON para o dataset TabCategoria
  }
  resp := TRequest.New
    .BaseURL(BASE_URL)
    .Resource('/categorias')
    .Accept('application/json')
    .TokenBearer(TSession.token)
    .Adapters(TDataSetSerializeAdapter.New(TabCategoria))
    .Get;

  {
    Verifica se a consulta foi concluída com sucesso.
    Status 200 significa OK.
  }
  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

procedure TDmGlobal.InserirLancamento(descricao, tipo, dt: string;
  valor: Double; id_categoria: Integer);
var
  resp: IResponse;
  json: TJSONObject;
begin
  // Cria o JSON que será enviado para a API
  json := TJSONObject.Create;
  try
    {
      Monta o corpo da requisição com os dados do lançamento.
    }
    json.AddPair('descricao', descricao);
    json.AddPair('tipo', tipo);
    json.AddPair('dt_lancamento', dt);
    json.AddPair('valor', TJSONNumber.Create(valor));
    json.AddPair('id_categoria', TJSONNumber.Create(id_categoria));

    {
      Envia uma requisição POST para cadastrar um novo lançamento.

      Observação:
      como o endpoint é protegido, o ideal é enviar também o token JWT.
    }
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/lancamentos')
      .AddBody(json.ToString)
      .Accept('application/json')
      .TokenBearer(TSession.token)
      .Post;

    {
      Inclusão com sucesso normalmente retorna 201 (Created).
      Se vier outro status, gera exceção com a mensagem da API.
    }
    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    // Libera o objeto JSON da memória
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.EditarLancamento(id_lancamento: integer; descricao, tipo, dt: string;
  valor: Double; id_categoria: Integer);
var
  resp: IResponse;
  json: TJSONObject;
begin
  // Cria o JSON que será enviado para a API
  json := TJSONObject.Create;
  try
    {
      Monta o corpo da requisição com os dados do lançamento.
    }
    json.AddPair('descricao', descricao);
    json.AddPair('tipo', tipo);
    json.AddPair('dt_lancamento', dt);
    json.AddPair('valor', TJSONNumber.Create(valor));
    json.AddPair('id_categoria', TJSONNumber.Create(id_categoria));

    {
      Envia uma requisição POST para cadastrar um novo lançamento.

      Observação:
      como o endpoint é protegido, o ideal é enviar também o token JWT.
    }
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/lancamentos')
      .ResourceSuffix(id_lancamento.ToString)
      .AddBody(json.ToString)
      .Accept('application/json')
      .TokenBearer(TSession.token)
      .Put;

    {
      Inclusão com sucesso normalmente retorna 201 (Created).
      Se vier outro status, gera exceção com a mensagem da API.
    }
    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    // Libera o objeto JSON da memória
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ExcluirLancamento(id_lancamento: integer);
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
