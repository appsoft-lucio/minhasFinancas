unit UnitNewCategory;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFormNewCategory = class(TForm)
    LytCabecalhoNewCategoria: TLayout;
    LblTitulo: TLabel;
    ImgSalvarCategoria: TImage;
    ImgBackNovoCategoria: TImage;
    LytNovoLancamento: TLayout;
    EditCategoria: TEdit;
    Layout2: TLayout;
    Image1: TImage;
    procedure ImgBackNovoCategoriaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNewCategory: TFormNewCategory;

implementation

{$R *.fmx}

procedure TFormNewCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormNewCategory:= nil;
end;

procedure TFormNewCategory.ImgBackNovoCategoriaClick(Sender: TObject);
begin
        Close;
end;

end.
