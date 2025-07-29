unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl;

type
  TFormLogin = class(TForm)
    TabControl: TTabControl;
    TabInicio: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}

end.
