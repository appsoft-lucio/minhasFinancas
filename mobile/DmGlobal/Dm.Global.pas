unit Dm.Global;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config;

type
  TDmGlobal = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmGlobal: TDmGlobal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.Login(email, senha: string);
begin

end;

end.
