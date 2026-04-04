unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uLoading, System.DateUtils, uFunctions;

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

uses UnitLancamento, UnitConfig, UnitLancamentoCad, Dm.Global;

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
        TListItemText(item.Objects.FindDrawable('TxtValor')).Text :=Copy(dt, 1, 6);
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

  var
    dt_de, dt_ate : string;

    begin
      FormatDateTime('yyyy-mm-dd', startOfTheMonth(date));
      FormatDateTime('yyyy-mm-dd', EndOfTheMonth(date));

      //Sleep(500); // Simula acesso ao servidor
      DmGlobal.ConsultarLancamentos(0, dt_de, dt_ate)
    end,
  TerminateLancamentos
  );

end;

procedure TFormPrincipal.TerminateLancamentos(Sender: TObject);
begin
  TLoading.Hide;

  //Se deu erro na Thread
  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  while NOT DmGlobal.TabLancamento.Eof do
  begin
    AddLancamentosLv(DmGlobal.TabLancamento.FieldByName('id_lancamento').AsInteger,
    DmGlobal.TabLancamento.FieldByName('descricao').AsString,
    DmGlobal.TabLancamento.FieldByName('categoria').AsString,
    UTCtoShortDateBR(DmGlobal.TabLancamento.FieldByName('dt_lancamento').AsString),
    DmGlobal.TabLancamento.FieldByName('valor').AsFloat);

    DmGlobal.TabLancamento.Next;
  end;



end;

end.








