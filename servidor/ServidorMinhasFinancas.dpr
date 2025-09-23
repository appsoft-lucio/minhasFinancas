program ServidorMinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  Controllers.Users in 'Controllers\Controllers.Users.pas',
  Controllers.Category in 'Controllers\Controllers.Category.pas',
  Services.Category in 'Services\Services.Category.pas',
  Repositories.Category in 'Repositories\Repositories.Category.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
