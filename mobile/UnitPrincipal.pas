unit UnitPrincipal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.TabControl,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Objects,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  uLoading,
  System.DateUtils,
  uFunctions;

type
  TFormPrincipal = class(TForm)
    LytToolbarHomer: TLayout;
    LblToolbarHomer: TLabel;
    LytSaldoReceitaDespesa: TLayout;
    LytSaldo: TLayout;
    ImgSaldoMes: TImage;
    Label1: TLabel;
    LblSaldo: TLabel;
    LytTotalReceitas: TLayout;
    ImgValorReceita: TImage;
    LblReceita: TLabel;
    LblTotalReceita: TLabel;
    LytDespesas: TLayout;
    ImgValorDespesa: TImage;
    LblDespesa: TLabel;
    RecCabecalhoHome: TRectangle;
    Rectangle1: TRectangle;
    LblUltimosLancamentos: TLabel;
    Label2: TLabel;
    RectBtnAbas: TRectangle;
    RectAbas: TRectangle;
    LytAbas: TLayout;
    ImgAdicinar: TImage;
    ImgAbaHome: TImage;
    ImgAbaLancamentos: TImage;
    ImgAbaConfig: TImage;
    LvLancamentos: TListView;
    Layout1: TLayout;
    LayoutReceitaEDespesas: TLayout;
    LblTotalDespesa: TLabel;

    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ImgAbaConfigClick(Sender: TObject);
    procedure ImgAdicinarClick(Sender: TObject);
    procedure LblSaldoClick(Sender: TObject);

  private
    // Adiciona um item de lançamento no ListView
    procedure AddLancamentosLv(
      id_lancamentos: integer;
      descricao, categoria, dt: string;
      valor: double
    );

    // Faz a consulta dos últimos lançamentos
    procedure ListarUltimosLacamentos;

    // Método executado ao terminar a thread de carregamento
    procedure TerminateLancamentos(Sender: TObject);

  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses
  UnitLancamento,
  UnitConfig,
  UnitLancamentoCad,
  Dm.Global;

{------------------------------------------------------------------------------
  Adiciona um lançamento ao ListView da tela principal
------------------------------------------------------------------------------}
procedure TFormPrincipal.AddLancamentosLv(
  id_lancamentos: integer;
  descricao, categoria, dt: string;
  valor: double
);
var
  item: TListViewItem;
begin
  // Cria um novo item no ListView
  item := LvLancamentos.Items.Add;
  item.Height := 75;
  item.Tag := id_lancamentos;

  // Preenche os textos do item
  TListItemText(item.Objects.FindDrawable('TxtDescricao')).Text := descricao;
  TListItemText(item.Objects.FindDrawable('TxtCategoria')).Text := categoria;
  TListItemText(item.Objects.FindDrawable('TxtValor')).Text := Copy(dt, 1, 6);
  TListItemText(item.Objects.FindDrawable('TxtData')).Text := FormatFloat('R$#,##0.00', valor);
end;

{------------------------------------------------------------------------------
  Evento executado ao exibir o formulário
------------------------------------------------------------------------------}
procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  ListarUltimosLacamentos
end;

{------------------------------------------------------------------------------
  Abre o formulário de configurações
------------------------------------------------------------------------------}
procedure TFormPrincipal.ImgAbaConfigClick(Sender: TObject);
begin
  if not Assigned(FormConfig) then
    Application.CreateForm(TFormConfig, FormConfig);

  FormConfig.Show;
end;

{------------------------------------------------------------------------------
  Abre o formulário de cadastro de lançamento
------------------------------------------------------------------------------}
procedure TFormPrincipal.ImgAdicinarClick(Sender: TObject);
begin
  if not Assigned(FormLancamentoCad) then
    Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);

  FormLancamentoCad.Show;
end;

{------------------------------------------------------------------------------
  Abre o formulário de lançamentos
------------------------------------------------------------------------------}
procedure TFormPrincipal.Label2Click(Sender: TObject);
begin
  if not Assigned(FormLancamento) then
    Application.CreateForm(TFormLancamento, FormLancamento);

  FormLancamento.Show;
end;

procedure TFormPrincipal.LblSaldoClick(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------
  Consulta os últimos lançamentos utilizando thread
------------------------------------------------------------------------------}
procedure TFormPrincipal.ListarUltimosLacamentos;
begin
  TLoading.Show(FormPrincipal, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    var
      dt_de, dt_ate: string;
    begin
      FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Date));
      FormatDateTime('yyyy-mm-dd', EndOfTheMonth(Date));

      // Sleep(500); // Simula acesso ao servidor
      DmGlobal.ConsultarLancamentos(0, dt_de, dt_ate)
    end,
    TerminateLancamentos
  );
end;

{------------------------------------------------------------------------------
  Executado ao finalizar a thread de carregamento dos lançamentos
------------------------------------------------------------------------------}
procedure TFormPrincipal.TerminateLancamentos(Sender: TObject);
var
  total_receita, total_despesa : double;

begin
  TLoading.Hide;

  // Se ocorreu erro na thread, exibe a mensagem
  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  total_receita := 0;
  total_despesa := 0;

  // Percorre os lançamentos retornados e adiciona no ListView
  while not DmGlobal.TabLancamento.Eof do
  begin
    AddLancamentosLv(
      DmGlobal.TabLancamento.FieldByName('id_lancamento').AsInteger,
      DmGlobal.TabLancamento.FieldByName('descricao').AsString,
      DmGlobal.TabLancamento.FieldByName('categoria').AsString,
      UTCtoShortDateBR(DmGlobal.TabLancamento.FieldByName('dt_lancamento').AsString),
      DmGlobal.TabLancamento.FieldByName('valor').AsFloat
    );

    if DmGlobal.TabLancamento.FieldByName('tipo').AsString = 'D' then
      total_despesa := total_despesa + DmGlobal.TabLancamento.FieldByName('valor').AsFloat
      else
      total_receita := total_receita + DmGlobal.TabLancamento.FieldByName('valor').AsFloat;

    DmGlobal.TabLancamento.Next;
  end;

  LblTotalDespesa.Text := FormatFloat('R$#,##0.00', total_despesa );
  LblTotalReceita.Text := FormatFloat('R$#,##0.00', total_receita );
  LblSaldo.Text := FormatFloat('R$#,##0.00', total_receita - total_despesa );

end;

end.
