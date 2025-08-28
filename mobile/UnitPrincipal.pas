unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects;

type
  TFormPrincipal = class(TForm)
    TabControl: TTabControl;
    TabHome: TTabItem;
    TabLancamentos: TTabItem;
    TabUserConfig: TTabItem;
    LytToolbarHomer: TLayout;
    LblToolbarHomer: TLabel;
    LytSaldoReceitaDespesa: TLayout;
    LytSaldo: TLayout;
    ImgSaldoMes: TImage;
    Label1: TLabel;
    LblValorSaldo: TLabel;
    LytTotalReceitas: TLayout;
    Image2: TImage;
    LblReceita: TLabel;
    LblValorReceita: TLabel;
    LytDespesas: TLayout;
    Image3: TImage;
    LblDespesa: TLabel;
    LblValorDespesa: TLabel;
    RecCabecalhoHome: TRectangle;
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
