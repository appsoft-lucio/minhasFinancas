program ServidorMinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  Controllers.Usuario in 'Controllers\Controllers.Usuario.pas',
  Controllers.Categoria in 'Controllers\Controllers.Categoria.pas',
  Services.Categoria in 'Services\Services.Categoria.pas',
  Repositories.Cattegoria in 'Repositories\Repositories.Cattegoria.pas' {DmCategoria: TDataModule},
  Controllers.JWT in 'Controllers\Controllers.JWT.pas',
  Services.Usuario in 'Services\Services.Usuario.pas',
  uMD5 in 'Utils\uMD5.pas',
  Repositories.Usuario in 'Repositories\Repositories.Usuario.pas' {DmUsuario: TDataModule},
  Repositories.Lancamentos in 'Repositories\Repositories.Lancamentos.pas' {DmLancamentos: TDataModule};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TDmUsuario, DmUsuario);
  Application.CreateForm(TDmLancamentos, DmLancamentos);
  Application.Run;
end.
