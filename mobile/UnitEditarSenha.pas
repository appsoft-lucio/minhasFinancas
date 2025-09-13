unit UnitEditarSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFormEditarSenha = class(TForm)
    LytCabecalhoEditarSenha: TLayout;
    LblEditarSenha: TLabel;
    ImgSalvarSenha: TImage;
    ImgBackEditarSenha: TImage;
    LytEditarSenha: TLayout;
    EditSenha: TEdit;
    EditConfirmaSenha: TEdit;
    procedure ImgBackEditarSenhaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditarSenha: TFormEditarSenha;

implementation

{$R *.fmx}

procedure TFormEditarSenha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormEditarSenha:= nil;
end;

procedure TFormEditarSenha.ImgBackEditarSenhaClick(Sender: TObject);
begin
        Close;
end;

end.
