unit UnitLancamento;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes, System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  uLoading, System.StrUtils,
  system.DateUtils,
  ufunctions;

type
  TFormLancamento = class(TForm)
    LytCabecalhoLancamento: TLayout;
    ImgBackLacamento: TImage;
    LblCabecalhoLancamentos: TLabel;
    RectDataLacamentos: TRectangle;
    LblMes: TLabel;
    RectMeses: TRectangle;
    ImgMesNext: TImage;
    ImgMesBack: TImage;
    Rect: TRectangle;
    Layout1: TLayout;
    LblLancamentosReceita: TLabel;
    LblTotalReceita: TLabel;
    LblLancamentosDespesa: TLabel;
    LblTotalDespesa: TLabel;
    LblLancamentosSaldo: TLabel;
    LblSaldo: TLabel;
    LvLancamentos: TListView;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure ImgBackLacamentoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
    procedure ImgMesNextClick(Sender: TObject);
    procedure ImgMesBackClick(Sender: TObject);
  private
    FData : TdateTime;
    procedure AddLancamentosLv(id_lancamentos: integer;
                               descricao, categoria,
                               dt, tipo : string;
                               valor: double);
    procedure ListarLancamentos;
    procedure TerminateLancamentos(Sender: TObject);
    procedure NavegacaoMes(param: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLancamento: TFormLancamento;

implementation

{$R *.fmx}

uses UnitLancamentoCad, Dm.Global;

procedure TFormLancamento.AddLancamentosLv(id_lancamentos: integer;
                                          descricao, categoria,
                                          dt, tipo: string;
                                          valor: double);

var
        item: TListViewItem;
        txtValor: TListItemText;
begin
        item:= LvLancamentos.Items.Add;
        item.Height:= 75;
        item.Tag:= id_lancamentos;

       TListItemText(item.Objects.FindDrawable('TxtDescricao')).Text := descricao;
       TListItemText(item.Objects.FindDrawable('TxtCategoria')).Text := categoria;
       TListItemText(item.Objects.FindDrawable('TxtValor')).Text := Copy(dt, 1, 5);

       txtValor := TListItemText(item.Objects.FindDrawable('TxtData'));

       txtValor.Text :=
       IfThen(tipo = 'D', '- ', '') +
       FormatFloat('R$#,##0.00', valor);

  // Mudar a cor do texto
  if tipo = 'D' then
  begin
    txtValor.TextColor := $FFB00020;
  end
  else
  begin
    txtValor.TextColor := $FF2E7D32;
  end;
end;

procedure TFormLancamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormLancamento:= nil;
end;

procedure TFormLancamento.FormShow(Sender: TObject);
begin
        FData := now;
        ListarLancamentos;
end;

procedure TFormLancamento.Image1Click(Sender: TObject);
begin
        if NOT Assigned(FormLancamentoCad) then
        Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);

        FormLancamentoCad.id_lancamento := 0;
        FormLancamentoCad.Show;
end;

procedure TFormLancamento.ImgBackLacamentoClick(Sender: TObject);
begin
        Close;
end;

procedure TFormLancamento.NavegacaoMes(param: integer);
begin
  FData.AddMonth(param);
  ListarLancamentos;
end;

procedure TFormLancamento.ImgMesBackClick(Sender: TObject);
begin
  NavegacaoMes(-1)
end;

procedure TFormLancamento.ImgMesNextClick(Sender: TObject);
begin
  NavegacaoMes(1)
end;

procedure TFormLancamento.ListarLancamentos;

begin
        LvLancamentos.Items.Clear;
        LblMes.Text := MonthDescription(FData) + ' / ' + FormatDateTime('yyyy', FData);
        TLoading.Show(FormLancamento, 'Carregando...');
        TLoading.ExecuteThread(
        procedure
        begin
        DmGlobal.ConsultarLancamentos(0,
                                      FormatDateTime('yyyy-mm-dd', StartOfTheMonth(FData)),
                                      FormatDateTime('yyyy-mm-dd', EndOfTheMonth(FData))
                                      );
        end,
        TerminateLancamentos
        );



end;

procedure TFormLancamento.TerminateLancamentos(Sender: TObject);
var
  total_receita, total_despesa : double;

begin
  TLoading.Hide;
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
      DmGlobal.TabLancamento.FieldByName('tipo').AsString,
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

  if DmGlobal.TabLancamento.IsEmpty then
begin
  LblTotalDespesa.Text := 'R$0,00';
  LblTotalReceita.Text := 'R$0,00';
  LblSaldo.Text := 'R$0,00';

  ShowMessage('Nenhum lançamento encontrado.');
  Exit;

end;
end;

end.
