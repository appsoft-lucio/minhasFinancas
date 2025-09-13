unit UnitLancamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uLoading;

type
  TFormLancamento = class(TForm)
    LytCabecalhoLancamento: TLayout;
    ImgBackLacamento: TImage;
    LblCabecalhoLancamentos: TLabel;
    RectDataLacamentos: TRectangle;
    LblDada: TLabel;
    RectMeses: TRectangle;
    ImgMesNext: TImage;
    ImgMesBack: TImage;
    Rect: TRectangle;
    Layout1: TLayout;
    LblLancamentosReceita: TLabel;
    LblLancamentosValorReceita: TLabel;
    LblLancamentosDespesa: TLabel;
    LblLancamentosValorDespesas: TLabel;
    LblLancamentosSaldo: TLabel;
    LblLancamentosValorSaldo: TLabel;
    LvLancamentos: TListView;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure ImgBackLacamentoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1Click(Sender: TObject);
  private
    procedure AddLancamentosLv(id_lancamentos: integer;
                               descricao, categoria,
                               dt: string; valor: double);
    procedure ListarLacamentos;
    procedure TerminateLancamentos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLancamento: TFormLancamento;

implementation

{$R *.fmx}

uses UnitLancamentoCad;

procedure TFormLancamento.AddLancamentosLv(id_lancamentos: integer;
                                          descricao, categoria,
                                          dt: string; valor: double);

var
        item: TListViewItem;
begin
        item:= LvLancamentos.Items.Add;
        item.Height:= 75;
        item.Tag:= id_lancamentos;

        TListItemText(item.Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(item.Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(item.Objects.FindDrawable('TxtValor')).Text := dt;
        TListItemText(item.Objects.FindDrawable('TxtData')).Text := FormatFloat('R$#,##0.00', valor);
end;

procedure TFormLancamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormLancamento:= nil;
end;

procedure TFormLancamento.FormShow(Sender: TObject);
begin
        ListarLacamentos;
end;

procedure TFormLancamento.Image1Click(Sender: TObject);
begin
        if NOT Assigned(FormLancamentoCad) then
        Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);

        FormLancamentoCad.Show;
end;

procedure TFormLancamento.ImgBackLacamentoClick(Sender: TObject);
begin
        Close;
end;

procedure TFormLancamento.ListarLacamentos;

begin

        TLoading.Show(FormLancamento, 'Carregando...');
        TLoading.ExecuteThread(
        procedure
        begin
        Sleep(500); // Simula acesso ao servidor
        end,
        TerminateLancamentos
        );



end;

procedure TFormLancamento.TerminateLancamentos(Sender: TObject);
begin
  TLoading.Hide;
  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

        AddLancamentosLv(1, 'Compra de gasolina', 'Transporte', '01/08/2025', 170);
        AddLancamentosLv(2, 'Almoço no restaurante', 'Alimentação', '02/08/2025', 45);
        AddLancamentosLv(3, 'Supermercado', 'Alimentação', '03/08/2025', 320);
        AddLancamentosLv(4, 'Cinema', 'Lazer', '04/08/2025', 25);
        AddLancamentosLv(5, 'Mensalidade Academia', 'Saúde', '05/08/2025', 120);
        AddLancamentosLv(6, 'Conta de luz', 'Moradia', '06/08/2025', 180);
        AddLancamentosLv(7, 'Pagamento do cartão', 'Dívidas', '07/08/2025', 500);
        AddLancamentosLv(8, 'Uber para trabalho', 'Transporte', '08/08/2025', 35);
        AddLancamentosLv(9, 'Água e esgoto', 'Moradia', '09/08/2025', 90);
        AddLancamentosLv(10, 'Compra de roupas', 'Vestuário', '10/08/2025', 250);
        AddLancamentosLv(11, 'Compra de gasolina', 'Transporte', '01/09', 170);

end;

end.
