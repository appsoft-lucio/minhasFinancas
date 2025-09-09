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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditarSenha: TFormEditarSenha;

implementation

{$R *.fmx}

end.
