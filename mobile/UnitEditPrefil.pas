unit UnitEditPrefil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.StdCtrls;

type
  TFormEditPerfil = class(TForm)
    LytCabecalhoEditPerfil: TLayout;
    LblPerfil: TLabel;
    ImgSalvarPerfil: TImage;
    ImgBackEditarPerfil: TImage;
    LytEditarPerfil: TLayout;
    EditNome: TEdit;
    EditEmail: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditPerfil: TFormEditPerfil;

implementation

{$R *.fmx}

end.
