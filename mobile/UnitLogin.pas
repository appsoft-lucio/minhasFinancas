unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TFormLogin = class(TForm)
    TabControl: TTabControl;
    TabInicio: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Layout1: TLayout;
    imgPorquinho: TImage;
    LabelImgPorquinho: TLabel;
    Label1: TLabel;
    RectAcessarLogin: TRectangle;
    SpeedButtonAcessarLogin: TSpeedButton;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Layout2: TLayout;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Rectangle2: TRectangle;
    SpeedButton2: TSpeedButton;
    Rectangle3: TRectangle;
    SpeedButton3: TSpeedButton;
    EditEmail: TEdit;
    EditSenha: TEdit;
    Layout3: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Rectangle4: TRectangle;
    SpeedButton4: TSpeedButton;
    Rectangle5: TRectangle;
    SpeedButton5: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
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
