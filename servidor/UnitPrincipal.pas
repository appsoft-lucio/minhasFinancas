unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  DataSet.Serialize.Config;

type
  TForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Horse,
     Horse.Jhonson,
     Horse.CORS;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Rotina de login acessada ;).')
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        THorse.Use(Jhonson());
        THorse.Use(CORS);

        THorse.Get('/usuarios/login', Login);

        TDataSetSerializeConfig.GetInstance.CaseNameDefinition:= cndLower;
        TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator:= '.';

        THorse.Listen(3001);
end;

end.
