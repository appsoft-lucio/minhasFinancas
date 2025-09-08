program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  UnitLancamento in 'UnitLancamento.pas' {FormLancamento},
  UnitConfig in 'UnitConfig.pas' {FormConfig},
  UnitLancamentoCad in 'UnitLancamentoCad.pas' {FormLancamentoCad};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.CreateForm(TFormLancamento, FormLancamento);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
