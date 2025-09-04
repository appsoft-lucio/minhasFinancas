unit UnitConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFormConfig = class(TForm)
    LytCabecalhoConfig: TLayout;
    LblCabecalhoConfig: TLabel;
    ImgBackConfig: TImage;
    RectEditarPerfil: TRectangle;
    ImgEditarPerfil: TImage;
    LblEditarPerfil: TLabel;
    ImgGoEditarPerfil: TImage;
    Rectangle1: TRectangle;
    ImgDesconectar: TImage;
    LblDesconectar: TLabel;
    ImgGoDesconectar: TImage;
    Rectangle2: TRectangle;
    ImgAssinatura: TImage;
    LblAssinatura: TLabel;
    ImgGoAssinatura: TImage;
    Rectangle3: TRectangle;
    ImgAlterarSenha: TImage;
    LblAlterarSenha: TLabel;
    ImgGoAlterarSenha: TImage;
    procedure ImgBackConfigClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConfig: TFormConfig;

implementation

{$R *.fmx}

procedure TFormConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormConfig:= nil;
end;

procedure TFormConfig.ImgBackConfigClick(Sender: TObject);
begin
        Close;
end;

end.
