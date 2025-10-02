unit Repositories.Cattegoria;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, System.JSON, DataSet.Serialize, FireDAC.DApt;

type
  TDmCategoria = class(TDataModule)
    ConnCategoria: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function ListarCategorias(id_usuario: integer): TJsonArray;
    { Public declarations }
  end;

var
  DmCategoria: TDmCategoria;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmCategoria.DataModuleCreate(Sender: TObject);
begin
  ConnCategoria.Params.Add('Database=127.0.0.1/3050:E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB');
  FDPhysFBDriverLink.VendorLib:= 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll';
  end;

function TDmCategoria.ListarCategorias(id_usuario: integer): TJsonArray;

var
    qry: TFDQuery;

begin
  try
    qry:= TFDQuery.Create(nil);
    qry.Connection:= ConnCategoria;

    qry.SQL.Add('Select * From categoria');
    qry.SQL.Add('Where id_usuario = :id_usuario');
    qry.SQL.Add('Order By Descricao');

    qry.ParamByName('id_usuario').Value:= id_usuario;

    qry.Active:= true;

    Result:= qry.ToJSONArray;
  finally
    FreeAndNil(qry);

  end;

end;
end.
