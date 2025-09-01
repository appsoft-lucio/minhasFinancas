unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

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
    Image1: TImage;
    ListView1: TListView;
    ImgHome: TImage;
    ImgLancamentos: TImage;
    ImgConfig: TImage;
    LvLancamentos: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

end.
