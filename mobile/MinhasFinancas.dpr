program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  UnitLancamento in 'UnitLancamento.pas' {FormLancamento},
  UnitConfig in 'UnitConfig.pas' {FormConfig},
  UnitLancamentoCad in 'UnitLancamentoCad.pas' {FormLancamentoCad},
  UnitCategoria in 'UnitCategoria.pas' {FormCategoria};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormLancamentoCad, FormLancamentoCad);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.CreateForm(TFormLancamento, FormLancamento);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormCategoria, FormCategoria);
  Application.Run;
end.
