program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  UnitLancamento in 'UnitLancamento.pas' {FormLancamento},
  UnitConfig in 'UnitConfig.pas' {FormConfig},
  UnitLancamentoCad in 'UnitLancamentoCad.pas' {FormLancamentoCad},
  UnitCategoria in 'UnitCategoria.pas' {FormCategoria},
  UnitNewCategory in 'UnitNewCategory.pas' {FormNewCategory},
  UnitEditPerfil in 'UnitEditPerfil.pas' {FormEditPerfil},
  UnitEditarSenha in 'UnitEditarSenha.pas' {FormEditarSenha},
  uLoading in 'Utils\uLoading.pas',
  uFunctions in 'Utils\uFunctions.pas',
  uCombobox in 'Utils\uCombobox.pas',
  uSession in 'Utils\uSession.pas',
  Dm.Global in 'DmGlobal\Dm.Global.pas' {DmGlobal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.CreateForm(TFormLancamento, FormLancamento);
  Application.CreateForm(TFormCategoria, FormCategoria);
  Application.CreateForm(TFormNewCategory, FormNewCategory);
  Application.CreateForm(TFormEditPerfil, FormEditPerfil);
  Application.CreateForm(TFormEditarSenha, FormEditarSenha);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.Run;
end.
