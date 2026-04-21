unit UnitNewCategory;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, uLoading,
  FMX.DialogService;

type
  TExecuteOnClose = procedure of object;

  TFormNewCategory = class(TForm)
    LytCabecalhoNewCategoria: TLayout;
    LblTitulo: TLabel;
    ImgSalvarCategoria: TImage;
    ImgBackCategoria: TImage;
    LytNovoLancamento: TLayout;
    EditCategoria: TEdit;
    Layout2: TLayout;
    ImageDelete: TImage;
    procedure ImgBackCategoriaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ImgSalvarCategoriaClick(Sender: TObject);
    procedure ImageDeleteClick(Sender: TObject);
  private
    Fid_categoria: Integer;
    FExecuteOnClose: TExecuteOnClose;
    procedure DadosCategoria(id_cat: integer);
    procedure TerminateCategoria(Sender: TObject);
    procedure TerminateSalvar(Sender: TObject);
    procedure ExcluirCategoria(id_categoria: Integer);
    { Private declarations }
  public
    property id_categoria: Integer read Fid_categoria write Fid_categoria;
    property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;
  end;

var
  FormNewCategory: TFormNewCategory;

implementation

{$R *.fmx}

uses Dm.Global;

procedure TFormNewCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormNewCategory:= nil;
end;

procedure  TFormNewCategory.TerminateCategoria(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  EditCategoria.Text := DmGlobal.TabCategoria.FieldByName('descricao').AsString;
end;

procedure  TFormNewCategory.DadosCategoria(id_cat: integer);
begin
  TLoading.Show(FormNewCategory, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.ConsultarCategoriasId(id_cat);
    end,
    TerminateCategoria
  );
end;

procedure TFormNewCategory.FormShow(Sender: TObject);
begin
  if id_categoria > 0 then
  begin
    imageDelete.Visible := true;
    LblTitulo.Text := 'Editar Categoria';
    DadosCategoria(id_categoria);
  end;
end;

procedure TFormNewCategory.ExcluirCategoria(id_categoria: Integer);
begin
    if id_categoria = 1 then
      begin
        ShowMessage('Essa categoria não pode ser excluída.');
        Exit;
      end;

  TLoading.Show(FormNewCategory, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin

      DmGlobal.ExcluirCategoria(id_categoria);
    end,
    TerminateSalvar
  );
end;

procedure TFormNewCategory.ImageDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog(
    'Confirma exclusão  da categoria?',
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo,
    0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        ExcluirCategoria(id_categoria);
      end;
    end
  );
end;

procedure TFormNewCategory.ImgBackCategoriaClick(Sender: TObject);
begin
        Close;
end;

procedure  TFormNewCategory.TerminateSalvar(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  if Assigned(ExecuteOnClose) then
    ExecuteOnClose;

  close;
end;


procedure TFormNewCategory.ImgSalvarCategoriaClick(Sender: TObject);
begin
  TLoading.Show(FormNewCategory, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      if id_categoria = 0 then
        DmGlobal.InserirCategoria(EditCategoria.Text)
      else
        DmGlobal.EditarCategoria(
          id_categoria,
          EditCategoria.Text
        );
    end,
    TerminateSalvar
  );
end;

end.
