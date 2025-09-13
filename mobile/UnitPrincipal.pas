unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uLoading   ;

type
  TFormPrincipal = class(TForm)
    LytToolbarHomer: TLayout;
    LblToolbarHomer: TLabel;
    LytSaldoReceitaDespesa: TLayout;
    LytSaldo: TLayout;
    ImgSaldoMes: TImage;
    Label1: TLabel;
    LblValorSaldo: TLabel;
    LytTotalReceitas: TLayout;
    ImgValorReceita: TImage;
    LblReceita: TLabel;
    LblValorReceita: TLabel;
    LytDespesas: TLayout;
    ImgValorDespesa: TImage;
    LblDespesa: TLabel;
    LblValorDespesa: TLabel;
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
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ImgAbaConfigClick(Sender: TObject);
    procedure ImgAdicinarClick(Sender: TObject);
  private
    procedure AddLancamentosLv(id_lancamentos: integer;
                               descricao, categoria,
                               dt: string; valor: double);
    procedure ListarUltimosLacamentos;
    procedure TerminateLancamentos(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses UnitLancamento, UnitConfig, UnitLancamentoCad;

procedure TFormPrincipal.AddLancamentosLv(id_lancamentos: integer;
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

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
        ListarUltimosLacamentos
end;

procedure TFormPrincipal.ImgAbaConfigClick(Sender: TObject);
begin
        if NOT Assigned(FormConfig) then
        Application.CreateForm(TFormConfig, FormConfig);

        FormConfig.Show;
end;

procedure TFormPrincipal.ImgAdicinarClick(Sender: TObject);
begin
        if NOT Assigned(FormLancamentoCad) then
        Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);

        FormLancamentoCad.Show;
end;

procedure TFormPrincipal.Label2Click(Sender: TObject);
begin
        if NOT Assigned(FormLancamento) then
        Application.CreateForm(TFormLancamento, FormLancamento);

        FormLancamento.Show;
end;

procedure TFormPrincipal.ListarUltimosLacamentos;

begin

        TLoading.Show(FormPrincipal, 'Carregando...');
        TLoading.ExecuteThread(
        procedure
        begin
        Sleep(500); // Simula acesso ao servidor
        end,
        TerminateLancamentos
        );

end;

procedure TFormPrincipal.TerminateLancamentos(Sender: TObject);
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
  AddLancamentosLv(10, 'Compra de roupas', 'Vestuário', '10/08/2025', 2050);
  AddLancamentosLv(11, 'Compra de gasolina', 'Transporte', '01/09', 170);

end;

end.
