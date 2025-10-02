unit Repositories.Usuario;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, System.JSON, DataSet.Serialize, FireDAC.DApt;

type
  TDmUsuario = class(TDataModule)
    ConnUsuario: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
  private
    procedure DataModuleCreate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    function Login(email, senha: string): TJsonObject;
  end;

var
  DmUsuario: TDmUsuario;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmUsuario.DataModuleCreate(Sender: TObject);
begin
  ConnUsuario.Params.Add('Database=127.0.0.1/3050:E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB');
  FDPhysFBDriverLink.VendorLib:= 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll';
  end;

function TDmUsuario.Login(email, senha: string): TJsonObject;

var
    qry: TFDQuery;

begin
  try
    qry:= TFDQuery.Create(nil);
    qry.Connection:= ConnUsuario;

    qry.SQL.Add('Select id_usuario, nome, dt_cadastro, status From usuario');
    qry.SQL.Add('Where email= :email And senha= :senha');

    qry.ParamByName('email').Value:= email;
    qry.ParamByName('senha').Value:= senha;

    qry.Active:= true;

    Result:= qry.ToJSONObject;
  finally
    FreeAndNil(qry);

  end;

end;

  end.
