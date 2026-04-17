unit UnitLancamentoCad;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.RegularExpressions,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Edit,
  FMX.ListBox,
  FMX.DateTimeCtrls,
  FMX.DialogService,
  uLoading,
  uFunctions;

type
  TExecuteOnClose = procedure of object;

  TFormLancamentoCad = class(TForm)
    LytCabecalhoNewCategoria: TLayout;
    LblTitulo: TLabel;
    ImgBackNovoLancamento: TImage;
    ImgSalvarLancamento: TImage;
    LayoutNovoLancamento: TLayout;
    EditDescricao: TEdit;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    EditValor: TEdit;
    LabelReceita: TLabel;
    LabelDespesa: TLabel;
    ComboBoxCategoria: TComboBox;
    EditDataLancamento: TDateEdit;
    Layout2: TLayout;
    ImageDelete: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImgBackNovoLancamentoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelReceitaClick(Sender: TObject);
    procedure LabelDespesaClick(Sender: TObject);
    procedure ImgSalvarLancamentoClick(Sender: TObject);
    procedure EditValorTyping(Sender: TObject);
    procedure ImageDeleteClick(Sender: TObject);
  private
    Fid_lancamento: Integer;
    Ftipo: string;
    FExecuteOnClose: TExecuteOnClose;

    procedure CarregarTela;
    procedure TerminateTela(Sender: TObject);
    procedure SetTipo(tp: string);
    procedure TerminateSalvar(Sender: TObject);
    procedure DadosLancamento(id_lanc: Integer);
    procedure ExcluirLancamento(id_lanc: Integer);
  public
    property id_lancamento: Integer read Fid_lancamento write Fid_lancamento;
    procedure TerminateEidtarLancamento(Sender: TObject);
    property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;
  end;

var
  FormLancamentoCad: TFormLancamentoCad;

implementation

{$R *.fmx}

uses
  Dm.Global,
  UnitPrincipal;

procedure TFormLancamentoCad.FormShow(Sender: TObject);
begin
  if id_lancamento = 0 then
  begin
    EditDescricao.Text := '';
    EditValor.Text := '0,00';
    EditDataLancamento.Date := Date;
    Ftipo := '';
    ComboBoxCategoria.ItemIndex := -1;
  end;

  CarregarTela;
end;

procedure TFormLancamentoCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FormLancamentoCad := nil;
end;

procedure TFormLancamentoCad.ImgBackNovoLancamentoClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLancamentoCad.ImgSalvarLancamentoClick(Sender: TObject);
var
  idCategoria: Integer;
begin
  // Define categoria padrão
  if ComboBoxCategoria.ItemIndex < 0 then
    idCategoria := 1 // ID da "Sem categoria"
  else
    idCategoria := ComboGetId(ComboBoxCategoria);

  TLoading.Show(FormLancamentoCad, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      if id_lancamento = 0 then
        DmGlobal.InserirLancamento(
          EditDescricao.Text,
          Ftipo,
          FormatDateTime('yyyy-mm-dd', EditDataLancamento.Date),
          StrToFloat(StringReplace(EditValor.Text, '.', '', [rfReplaceAll])),
          idCategoria
        )
      else
        DmGlobal.EditarLancamento(
          id_lancamento,
          EditDescricao.Text,
          Ftipo,
          FormatDateTime('yyyy-mm-dd', EditDataLancamento.Date),
          StrToFloat(StringReplace(EditValor.Text, '.', '', [rfReplaceAll])),
          idCategoria
        );
    end,
    TerminateSalvar
  );
end;

procedure TFormLancamentoCad.ImageDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog(
    'Confirma exclusao do lacamento?',
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        ExcluirLancamento(id_lancamento);
      end;
    end
  );
end;

procedure TFormLancamentoCad.LabelReceitaClick(Sender: TObject);
begin
  SetTipo('R');
end;

procedure TFormLancamentoCad.LabelDespesaClick(Sender: TObject);
begin
  SetTipo('D');
end;

procedure TFormLancamentoCad.EditValorTyping(Sender: TObject);
var
  v: string;
  valor: Currency;
begin
  // pega só números
  v := TRegEx.Replace(EditValor.Text, '[^0-9]', '');

  if v = '' then
    v := '0';

  // converte direto para número (sem locale)
  valor := StrToInt64(v) / 100;

  // formata com padrão brasileiro
  EditValor.Text := FormatFloat('#,##0.00', valor);

  EditValor.GoToTextEnd;
end;

procedure TFormLancamentoCad.SetTipo(tp: string);
begin
  Ftipo := tp;
end;

procedure TFormLancamentoCad.CarregarTela;
begin
  TLoading.Show(FormLancamentoCad, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.ConsultarCategotias;
    end,
    TerminateTela
  );
end;

procedure TFormLancamentoCad.DadosLancamento(id_lanc: Integer);
begin
  lblTitulo.Text := 'Editar Lançamento';
  imageDelete.Visible := id_lancamento >= 0;
  TLoading.Show(FormLancamentoCad, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.ConsultarLancamentosId(id_lanc);
    end,
    TerminateEidtarLancamento
  );
end;

procedure TFormLancamentoCad.ExcluirLancamento(id_lanc: Integer);
begin
  TLoading.Show(FormLancamentoCad, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.ExcluirLancamento(id_lanc);
    end,
    TerminateSalvar
  );
end;

procedure TFormLancamentoCad.TerminateTela(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  MontaCombo(
    ComboBoxCategoria,
    DmGlobal.TabCategoria,
    'id_categoria',
    'descricao',
    false
  );

  //Modo Edicao
  if id_lancamento > 0 then
    DadosLancamento(id_lancamento);
end;

procedure TFormLancamentoCad.TerminateEidtarLancamento(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  EditDescricao.Text := DmGlobal.TabLancamento
    .FieldByName('descricao')
    .AsString;

  EditValor.Text := DmGlobal.TabLancamento
    .FieldByName('valor')
    .AsString;

  SetTipo(
    DmGlobal.TabLancamento
      .FieldByName('Tipo')
      .AsString
  );

  ComboSelecionarById(
    ComboBoxCategoria,
    DmGlobal.TabLancamento
      .FieldByName('id_categoria')
      .AsInteger
  );

  EditDataLancamento.Date := ShortStringUTCToDate(
    DmGlobal.TabLancamento
      .FieldByName('Dt_lancamento')
      .AsString
  );
end;

procedure TFormLancamentoCad.TerminateSalvar(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

    if Assigned(FExecuteOnClose) then
    FExecuteOnClose;

  Close;
end;

end.
