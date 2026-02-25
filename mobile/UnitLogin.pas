unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  uLoading;

type
  TFormLogin = class(TForm)
    TabControl: TTabControl;
    TabInicio: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    ScrollBoxCriarConta: TScrollBox;
    EditNomeCriarConta: TEdit;
    EditEmailCriarConta: TEdit;
    EditSenhaCriarConta: TEdit;
    EditConfirmarSenhaCriarConta: TEdit;
    BtnLogin: TSpeedButton;
    procedure SpeedButtonAcessarLoginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
  private
    procedure OpenMainForm;
    procedure TerminateLogin(Sender: TObject);
    procedure BtnMostrarConfirmaSenhaClick(Sender: TObject);
    procedure BtnMostrarSenhaCriarClick(Sender: TObject);
  public
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}

uses UnitPrincipal,
     Repositories.Usuario ;

procedure TFormLogin.FormShow(Sender: TObject);
begin
  TabControl.ActiveTab := TabInicio;
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

procedure TFormLogin.SpeedButtonAcessarLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFormLogin.BtnLoginClick(Sender: TObject);
begin
  TLoading.Show(FormLogin, 'Carregando...');
  TLoading.ExecuteThread(
    procedure
    begin
      DmUsuario.Login(EditEmail.Text, EditSenha.Text);
    end,
    TerminateLogin
  );
end;

procedure TFormLogin.OpenMainForm;
begin
  if not Assigned(FormPrincipal) then
    Application.CreateForm(TFormPrincipal, FormPrincipal);

  FormPrincipal.Show;
end;

procedure TFormLogin.TerminateLogin(Sender: TObject);
begin
  TLoading.Hide;
  if Assigned(TThread(Sender).FatalException) then
  begin
    ShowMessage(Exception(TThread(Sender).FatalException).Message);
    Exit;
  end;

  OpenMainForm;
end;

// Botão para EditSenhaCriarConta
procedure TFormLogin.BtnMostrarSenhaCriarClick(Sender: TObject);
begin
  EditSenhaCriarConta.Password := not EditSenhaCriarConta.Password;
end;

// Botão para EditConfirmarSenhaCriarConta
procedure TFormLogin.BtnMostrarConfirmaSenhaClick(Sender: TObject);
begin
  EditConfirmarSenhaCriarConta.Password := not EditConfirmarSenhaCriarConta.Password;
end;


end.

