unit UnitEditPerfil;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Layouts,
  FMX.StdCtrls,
  uLoading;

type
  TFormEditPerfil = class(TForm)
    LytCabecalhoEditPerfil: TLayout;
    LblPerfil: TLabel;
    ImgSalvarPerfil: TImage;
    ImgBackEditarPerfil: TImage;
    LytEditarPerfil: TLayout;
    EditNomePerfil: TEdit;
    EditEmailPerfil: TEdit;
    procedure ImgBackEditarPerfilClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ImgSalvarPerfilClick(Sender: TObject);
  private
    procedure CarregarDadosPerfil;
    procedure TerminateDadosPerfil(Sender: TObject);
    procedure TerminateEditarUsuario(Sender: TObject);
  public
  end;

var
  FormEditPerfil: TFormEditPerfil;

implementation

{$R *.fmx}

uses
  Dm.Global;

procedure TFormEditPerfil.FormShow(Sender: TObject);
begin
  CarregarDadosPerfil;
end;

procedure TFormEditPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FormEditPerfil := nil;
end;

procedure TFormEditPerfil.ImgBackEditarPerfilClick(Sender: TObject);
begin
  Close;
end;

procedure TFormEditPerfil.ImgSalvarPerfilClick(Sender: TObject);
begin
  TLoading.Show(FormEditPerfil, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.EditarUsuario(EditNomePerfil.Text, EditEmailPerfil.Text);
    end,
    TerminateEditarUsuario
  );
end;

procedure TFormEditPerfil.TerminateEditarUsuario(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  Close;
end;

procedure TFormEditPerfil.CarregarDadosPerfil;
begin
  TLoading.Show(FormEditPerfil, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.DadosUsuarios;
    end,
    TerminateDadosPerfil
  );
end;

procedure TFormEditPerfil.TerminateDadosPerfil(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  if not DmGlobal.TabUsuario.Active then
  begin
    ShowMessage('TabUsuario nao esta ativa.');
    Exit;
  end;

  if DmGlobal.TabUsuario.IsEmpty then
  begin
    ShowMessage('TabUsuario esta vazia.');
    Exit;
  end;

  EditNomePerfil.Text := DmGlobal.TabUsuario.FieldByName('nome').AsString;
  EditEmailPerfil.Text := DmGlobal.TabUsuario.FieldByName('email').AsString;
end;

end.
