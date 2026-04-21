unit UnitEditarSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, uLoading ;

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
    procedure ImgSalvarSenhaClick(Sender: TObject);
  private
    procedure TerminateEditarSenha(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditarSenha: TFormEditarSenha;

implementation

{$R *.fmx}

uses Dm.Global;

procedure TFormEditarSenha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormEditarSenha:= nil;
end;

procedure TFormEditarSenha.ImgBackEditarSenhaClick(Sender: TObject);
begin
        Close;
end;

procedure TFormEditarSenha.ImgSalvarSenhaClick(Sender: TObject);
begin
  if (EditSenha.Text <> EditConfirmaSenha.Text) then
  begin
    showmessage('As senhas não conferem. Digite novamente.');
    exit;
  end;

  TLoading.Show(FormEditarSenha, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.EditarSenha(EditSenha.Text);
    end,
    TerminateEditarSenha
  );
end;

procedure TFormEditarSenha.TerminateEditarSenha(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  Close;
end;

end.
