unit Dm.Global;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config, System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDmGlobal = class(TDataModule)
    TabUsuario: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Login(email, senha: string);
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

  json := TJsonObject.Create;
  try
    json.AddPair('email', email);
    json.AddPair('senha', senha);

    resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/usuarios/login')
                        .AddBody(json.ToString)
                        .Accept('application/json')
                        .Adapters(TDataSetSerializeAdapter.New(TabUsuario))
                        .Post;

    if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);

  finally
    FreeAndNil(json);
  end;

end;

end.
