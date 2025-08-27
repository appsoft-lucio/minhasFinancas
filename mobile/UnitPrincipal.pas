unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl;

type
  TFormPrincipal = class(TForm)
    TabControl: TTabControl;
    TabHome: TTabItem;
    TabLancamentos: TTabItem;
    TabUserConfig: TTabItem;
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
