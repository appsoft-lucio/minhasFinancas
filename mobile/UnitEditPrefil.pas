unit UnitEditPrefil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.StdCtrls,
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
  private
    procedure CarregarDadosPerfil;
    procedure TerminateDadosPerfil(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditPerfil: TFormEditPerfil;

implementation

{$R *.fmx}

procedure TFormEditPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormEditPerfil:= nil;
end;

procedure TFormEditPerfil.FormShow(Sender: TObject);
begin
        CarregarDadosPerfil;
end;

procedure TFormEditPerfil.ImgBackEditarPerfilClick(Sender: TObject);
begin
        Close;
end;

procedure TFormEditPerfil.CarregarDadosPerfil;

begin
        TLoading.Show(FormEditPerfil, 'Carregando...');
        TLoading.ExecuteThread(
        procedure
        begin
        Sleep(500); // Simula acesso ao servidor
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

        EditNomePerfil.Text:= 'Lucio Cecilio';
        EditEmailPerfil.Text:= 'luciominhasfinancas@teste.com';

end;

end.
