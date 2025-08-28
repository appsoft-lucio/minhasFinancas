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
    Layout1: TLayout;
    LytSaldo: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LytTotalReceitas: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    LytDespesas: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
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
