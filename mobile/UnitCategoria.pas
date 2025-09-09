unit UnitCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFormCategoria = class(TForm)
    LytCabecalhoCategorias: TLayout;
    LblCabecalhoCategorias: TLabel;
    ImgBackLacamento: TImage;
    Image1: TImage;
    LvCategorias: TListView;
    procedure FormShow(Sender: TObject);
    procedure ImgBackLacamentoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure AddCategoriaLv(id_categoria: integer; descricao: string);
    procedure ListarCategoria;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCategoria: TFormCategoria;

implementation

{$R *.fmx}

procedure TFormCategoria.AddCategoriaLv(id_categoria: integer;
                                          descricao: string);

var
        item: TListViewItem;
begin
        item:= LvCategorias.Items.Add;
        item.Height:= 75;
        item.Tag:= id_categoria;
        item.Text:= descricao;

end;

procedure TFormCategoria.ListarCategoria;

begin
        AddCategoriaLv(1, 'Combustivel');
        AddCategoriaLv(2, 'Agua');
        AddCategoriaLv(3, 'Luz');
        AddCategoriaLv(4, 'Internet');
        AddCategoriaLv(5, 'Lazer');


end;

procedure TFormCategoria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormCategoria:= nil;
end;

procedure TFormCategoria.FormShow(Sender: TObject);
begin
        ListarCategoria;
end;

procedure TFormCategoria.ImgBackLacamentoClick(Sender: TObject);
begin
        Close;
end;

end.
