unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  DataSet.Serialize.Config;

type
  TFormPrincipal = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses Horse,
     Horse.Jhonson,
     Horse.CORS,
     Controllers.Users,
     Controllers.Category;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
        THorse.Use(Jhonson());
        THorse.Use(CORS);

        TDataSetSerializeConfig.GetInstance.CaseNameDefinition:= cndLower;
        TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator:= '.';

        Controllers.Users.RegistrarRotas;
        Controllers.Category.RegistrarRotas;

        THorse.Listen(3001);
end;

end.
