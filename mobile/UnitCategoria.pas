unit UnitCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  uLoading;

type
  TFormCategoria = class(TForm)
    LytCabecalhoCategorias: TLayout;
    LblCabecalhoCategorias: TLabel;
    ImgBackLacamento: TImage;
    ImageAdicionarCategoria: TImage;
    LvCategorias: TListView;
    procedure FormShow(Sender: TObject);
    procedure ImgBackLacamentoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageAdicionarCategoriaClick(Sender: TObject);
    procedure LvCategoriasItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddCategoriaLv(id_categoria: integer; descricao: string);
    procedure ListarCategoria;
    procedure TerminateCategorias(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCategoria: TFormCategoria;

implementation

{$R *.fmx}

uses UnitNewCategory, Dm.Global;

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
        TLoading.Show(FormCategoria, 'Carregando...');
        TLoading.ExecuteThread(
        procedure
        begin
        DmGlobal.ConsultarCategorias;
        end,
        TerminateCategorias
        );
end;

procedure TFormCategoria.LvCategoriasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  begin
        if not Assigned(FormNewCategory) then
        Application.CreateForm(TFormNewCategory, FormNewCategory);

        FormNewCategory.ExecuteOnClose := ListarCategoria;
        FormNewCategory.id_categoria := Aitem.Tag;
        FormNewCategory.Show;
end;
end;

procedure TFormCategoria.TerminateCategorias(Sender: TObject);
begin
  TLoading.Hide;
  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  LvCategorias.Items.Clear; // importante limpar antes

  DmGlobal.TabCategoria.First; // garantir início

  while NOT DmGlobal.TabCategoria.Eof do
  begin
    AddCategoriaLv(DmGlobal.TabCategoria.FieldByName('id_categoria').AsInteger,
                   DmGlobal.TabCategoria.FieldByName('descricao').AsString);

  DmGlobal.TabCategoria.Next;
  end;
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

procedure TFormCategoria.ImageAdicionarCategoriaClick(Sender: TObject);
begin
        if not Assigned(FormNewCategory) then
        Application.CreateForm(TFormNewCategory, FormNewCategory);

        FormNewCategory.ExecuteOnClose := ListarCategoria;
        FormNewCategory.id_categoria := 0;
        FormNewCategory.Show;
end;

procedure TFormCategoria.ImgBackLacamentoClick(Sender: TObject);
begin
        Close;
end;

end.
