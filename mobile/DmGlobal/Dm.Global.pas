unit Dm.Global;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config, System.JSON;

type
  TDmGlobal = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmGlobal: TDmGlobal;

const
  BASE_URL = 'http://localhost:3001';

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition:= cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator:= '.';
end;

procedure TDmGlobal.Login(email, senha: string);
var
  resp : IResponse;
  json : TJsonObject;
begin
  try
    json := TJsonObject.Create;
    json.AddPair('email', email);
    json.AddPair('senha', senha)

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/usuarios/login')
                        .AddBody(json.ToString)
                        .Accept('application/json')
                        .Post;
  finally
    FreeAndNil(json);
  end;

end;

end.
