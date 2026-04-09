unit Dm.Global;

interface

uses
  // Units básicas do Delphi
  System.SysUtils,
  System.Classes,
  System.JSON,

  // Biblioteca para fazer requisições HTTP para a API
  RESTRequest4D,

  // Adapter que converte resposta JSON da API para dataset
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config,

  // Units do FireDAC para trabalhar com datasets em memória
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

  // Unit da sessão do usuário logado
  uSession;

type
  TDmGlobal = class(TDataModule)
    // Dataset em memória para armazenar os dados do usuário
    TabUsuario: TFDMemTable;

    // Dataset em memória para armazenar os lançamentos financeiros
    TabLancamento: TFDMemTable;

    // Evento executado quando o DataModule é criado
    procedure DataModuleCreate(Sender: TObject);
  private
    { Declarações privadas }
  public
    { Declarações públicas }

    // Faz login enviando email e senha para a API
    procedure Login(email, senha: string);

    // Faz cadastro de um novo usuário
    procedure CriarConta(nome, email, senha: string);

    // Consulta os lançamentos filtrando por categoria e período
    procedure ConsultarLancamentos(id_categoria: integer; dt_de, dt_ate: string);
  end;

var
  // Variável global do DataModule
  DmGlobal: TDmGlobal;

const
  {
    URL base da API

    Use uma das opções abaixo conforme o teste:

    1) Teste no PC:
       localhost significa "este mesmo computador"

    2) Teste no celular:
       troque para o IP do computador na rede local
       Exemplo: http://192.168.0.10:3001

    IMPORTANTE:
    - Para testar no celular, PC e celular precisam estar no mesmo Wi-Fi
    - A API precisa estar rodando
    - O firewall do Windows pode bloquear a conexão
  }

  // BASE_URL = 'http://192.168.0.10:3001'; // teste no celular
  BASE_URL = 'http://localhost:3001';       // teste no PC

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  {
    Essa configuração define como os nomes dos campos vindos do JSON
    serão criados no dataset.

    cndLower = tudo em letras minúsculas

    Exemplo:
    Se a API retornar "ID_USUARIO" ou "Id_Usuario",
    o dataset vai tratar como "id_usuario".
  }
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;

  {
    Define o separador decimal usado na importação de números.

    Isso ajuda a evitar erro com valores decimais,
    principalmente quando a API retorna números com ponto.

    Exemplo:
    10.50
  }
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDmGlobal.Login(email, senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  {
    Antes de carregar novos dados no dataset, limpamos o conteúdo anterior.
    Isso evita misturar dados antigos com os novos.
  }
  if TabUsuario.Active then
  begin
    TabUsuario.EmptyDataSet;
    TabUsuario.FieldDefs.Clear;
  end;

  // Cria o objeto JSON que será enviado para a API
  json := TJSONObject.Create;
  try
    {
      Monta o corpo da requisição no formato JSON.
      A API espera receber email e senha.
    }
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    {
      Faz a requisição POST para o endpoint de login.

      .BaseURL(BASE_URL)
        define a URL principal da API

      .Resource('/usuarios/login')
        define o endpoint de login

      .AddBody(json.ToString)
        envia o JSON no corpo da requisição

      .Accept('application/json')
        informa que esperamos resposta em JSON

      .Adapters(...)
        converte a resposta da API para o dataset TabUsuario

      .Post
        executa a requisição HTTP do tipo POST
    }
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/login')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    {
      Se a API não retornar status 200,
      entendemos que houve erro no login.
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
    Limpa o dataset antes de receber os dados do novo cadastro.
  }
  if TabUsuario.Active then
    TabUsuario.EmptyDataSet;

  TabUsuario.FieldDefs.Clear;

  // Cria o objeto JSON que será enviado para a API
  json := TJSONObject.Create;
  try
    {
      Monta o JSON com os dados necessários para cadastro.
    }
    json.AddPair('nome', nome);
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    {
      Faz a requisição POST para o endpoint de cadastro.
    }
    resp := TRequest.New
      .BaseURL(BASE_URL)
      .Resource('/usuarios/cadastro')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
      .Post;

    {
      Normalmente cadastro com sucesso retorna 201 (Created).
      Se vier outro status, geramos erro.
    }
    if resp.StatusCode <> 201 then
      raise Exception.Create(resp.Content);

  finally
    // Libera o objeto JSON da memória
    FreeAndNil(json);
  end;
end;

procedure TDmGlobal.ConsultarLancamentos(id_categoria: integer; dt_de, dt_ate: string);
var
  resp: IResponse;
begin
  {
    Limpa os lançamentos antigos antes de carregar novos dados.
  }
  if TabLancamento.Active then
    TabLancamento.EmptyDataSet;

  TabLancamento.FieldDefs.Clear;

  {
    Faz a requisição GET para buscar os lançamentos.

    Parâmetros enviados:
    - id_categoria
    - dt_de
    - dt_ate

    .TokenBearer(TSession.token)
    envia o token JWT do usuário logado para a API,
    permitindo acesso aos dados protegidos.
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
    Se a API não retornar 200, entendemos que houve erro.
  }
  if resp.StatusCode <> 200 then
    raise Exception.Create(resp.Content);
end;

end.
