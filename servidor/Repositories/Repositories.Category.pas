unit Repositories.Category;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, System.JSON, DataSet.Serialize, FireDAC.DApt;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  function ListCategorys(id_user: integer): TJsonArray;
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
        Conn.Params.Add('DataBase=E:\git_hub\minhasFinancas\backand\BANCO.FDB');
        FDPhysFBDriverLink.VendorLib:= 'C:\Program Files\Firebird\Firebird_4_0\fbclient.dll';
end;

function TDM.ListCategorys(id_user: integer): TJsonArray;
var
        qry: TFDQuery;
begin
        try
          qry:= TFDQuery.Create(nil);
          qry.Connection:= Conn;

          qry.SQL.Add('select * from categoria order by descricao');
          qry.Active:= true;

          Result:= qry.ToJSONArray;
        finally
          FreeAndNil(qry);

        end;

end;
end.
