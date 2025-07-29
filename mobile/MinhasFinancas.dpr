program MinhasFinancas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
