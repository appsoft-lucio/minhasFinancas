unit UnitLancamentoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FMX.DateTimeCtrls;

type
  TFormLancamentoCad = class(TForm)
    LytCabecalhoConfig: TLayout;
    LblTitulo: TLabel;
    ImgBackNovoLancamento: TImage;
    ImgSalvar: TImage;
    LayoutNovoLancamento: TLayout;
    EditDescricao: TEdit;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    DateEdit1: TDateEdit;
    Layout2: TLayout;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImgBackNovoLancamentoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLancamentoCad: TFormLancamentoCad;

implementation

{$R *.fmx}

procedure TFormLancamentoCad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormLancamentoCad:= nil;
end;

procedure TFormLancamentoCad.ImgBackNovoLancamentoClick(Sender: TObject);
begin
        Close;
end;

end.
