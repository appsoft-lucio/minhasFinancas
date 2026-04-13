unit UnitLancamentoCad;

interface

uses
  System.SysUtils,
  System.Types, System.UITypes,
  System.Classes, System.Variants,
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
  uLoading,
  uFunctions;

type
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
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImgBackNovoLancamentoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelReceitaClick(Sender: TObject);
    procedure LabelDespesaClick(Sender: TObject);
    procedure ImgSalvarLancamentoClick(Sender: TObject);
  private
    Fid_lancamento: integer;
    Ftipo: string;
    procedure CarregarTela;
    procedure TerminateTela(Sender: TObject);
    procedure SetTipo(tp: string);
    procedure TerminateSalvar(Sender: TObject);
    procedure DadosLancamento(id_lanc: integer);
    { Private declarations }
  public
    { Public declarations }
    property id_lancamento: integer read Fid_lancamento write Fid_lancamento;
  end;

var
  FormLancamentoCad: TFormLancamentoCad;

implementation

{$R *.fmx}

uses Dm.Global,
     UnitPrincipal;

procedure TFormLancamentoCad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormLancamentoCad:= nil;
end;

procedure TFormLancamentoCad.FormShow(Sender: TObject);
begin
  if id_lancamento = 0 then
  begin
    EditDescricao.Text := '';
    EditValor.Text := '';
    EditDataLancamento.Date := Date;
    Ftipo := '';
    ComboBoxCategoria.ItemIndex := -1;
  end;

  CarregarTela;
end;

procedure TFormLancamentoCad.ImgBackNovoLancamentoClick(Sender: TObject);
begin
        Close;
end;

procedure TFormLancamentoCad.TerminateSalvar(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  if Assigned(FormPrincipal) then
    FormPrincipal.ListarUltimosLacamentos;

  Close;
end;

procedure TFormLancamentoCad.ImgSalvarLancamentoClick(Sender: TObject);
begin
        TLoading.Show(FormLancamentoCad, 'Carregando...');

        TLoading.ExecuteThread(
        procedure
        begin
        DmGlobal.InserirLancamento(EditDescricao.Text,
                                   Ftipo,
                                   FormatDatetime('yyyy-mm-dd', EditDataLancamento.Date),
                                   EditValor.Text.ToDouble,
                                   ComboGetId(ComboBoxCategoria)
                                   );
        end,
        TerminateSalvar
        );



end;

procedure TFormLancamentoCad.SetTipo(tp: string);
begin
  Ftipo := tp;
end;

procedure TFormLancamentoCad.LabelDespesaClick(Sender: TObject);
begin
  SetTipo('D');
end;

procedure TFormLancamentoCad.LabelReceitaClick(Sender: TObject);
begin
  SetTipo('R');
end;

procedure TFormLancamentoCad.DadosLancamento(id_lanc: integer);
begin
        TLoading.Show(FormLancamentoCad, 'Carregando...');

        TLoading.ExecuteThread(
        procedure
        begin
        DmGlobal.ConsultarLancamentosId(id_lanc);
        end,
        TerminateTela
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

  MontaCombo(ComboBoxCategoria, DmGlobal.TabCategoria,
                       'id_categoria', 'descricao', false);

  //Modo Edicao
  if id_lancamento > 0 then
    DadosLancamento(id_lancamento);
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

end.
