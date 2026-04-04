unit UnitLogin;

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
  FMX.TabControl,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Edit,
  uLoading,
  uSession;

type
  TFormLogin = class(TForm)
    // Aba inicio
    TabControl: TTabControl;
    TabInicio: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;

    // Aba Login
    ScrollBoxLogin: TScrollBox;
    lblEmailLogin: TLabel;
    EditEmailLogin: TEdit;
    EditSenhaLogin: TEdit;
    BtnLogin: TSpeedButton;
    ImgOcultarSenha: TImage;

    // Aba Criar conta
    ScrollBoxCriarConta: TScrollBox;
    EditNomeCriarConta: TEdit;
    EditEmailCriarConta: TEdit;
    EditSenhaCriarConta: TEdit;
    EditConfirmarSenhaCriarConta: TEdit;
    ImgOcultarSenhaCriarConta: TImage;

    procedure FormShow(Sender: TObject);

    procedure SpeedButtonAcessarLoginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);

    procedure BtnLoginClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);

    procedure ImgOcultarSenhaClick(Sender: TObject);
    procedure ImgOcultarSenhaCriarContaClick(Sender: TObject);
  private
    procedure OpenMainForm;
    procedure TerminateLogin(Sender: TObject);
  public
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}

uses
  UnitPrincipal,
  Dm.Global;

procedure TFormLogin.FormShow(Sender: TObject);
begin
  TabControl.ActiveTab := TabInicio;
end;

procedure TFormLogin.SpeedButtonAcessarLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFormLogin.SpeedButton1Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

procedure TFormLogin.SpeedButton3Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

procedure TFormLogin.SpeedButton5Click(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFormLogin.ImgOcultarSenhaClick(Sender: TObject);
begin
  EditSenhaLogin.Password := not EditSenhaLogin.Password;
end;

procedure TFormLogin.ImgOcultarSenhaCriarContaClick(Sender: TObject);
begin
  EditSenhaCriarConta.Password := not EditSenhaCriarConta.Password;
end;

procedure TFormLogin.BtnLoginClick(Sender: TObject);
begin
  TLoading.Show(FormLogin, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.Login(EditEmailLogin.Text, EditSenhaLogin.Text);
    end,
    TerminateLogin
  );
end;

procedure TFormLogin.btnCriarContaClick(Sender: TObject);
begin
  if EditSenhaCriarConta.Text <> EditConfirmarSenhaCriarConta.Text then
  begin
    ShowMessage('As senhas não conferem. Verifique e digite novamente.');
    Exit;
  end;

  TLoading.Show(FormLogin, 'Carregando...');

  TLoading.ExecuteThread(
    procedure
    begin
      DmGlobal.CriarConta(
        EditNomeCriarConta.Text,
        EditEmailCriarConta.Text,
        EditSenhaCriarConta.Text
      );
    end,
    TerminateLogin
  );
end;

procedure TFormLogin.TerminateLogin(Sender: TObject);
begin
  TLoading.Hide;

  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  TSession.id_usuario := DmGlobal.TabUsuario.FieldByName('id_usuario').AsInteger;
  TSession.nome       := DmGlobal.TabUsuario.FieldByName('nome').AsString;
  TSession.email      := DmGlobal.TabUsuario.FieldByName('email').AsString;
  TSession.token      := DmGlobal.TabUsuario.FieldByName('token').AsString;
  TSession.status     := '????';

  OpenMainForm;
end;

procedure TFormLogin.OpenMainForm;
begin
  if not Assigned(FormPrincipal) then
    Application.CreateForm(TFormPrincipal, FormPrincipal);

  FormPrincipal.Show;
end;

end.
