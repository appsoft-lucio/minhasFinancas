unit Repositories.Lancamentos;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, System.JSON, DataSet.Serialize, FireDAC.DApt;

type
  TDmLancamentos = class(TDataModule)
    ConnLancamento: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
  private
    procedure DataModuleCreate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    function ListarLancamentos(id_usuario, id_categoria: integer): TJsonArray;
  end;

var
  DmLancamentos: TDmLancamentos;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmLancamentos.DataModuleCreate(Sender: TObject);
begin
  ConnLancamento.Params.Add('Database=127.0.0.1/3050:E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB');
  FDPhysFBDriverLink.VendorLib:= 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll';
end;

function TDmLancamentos.ListarLancamentos(id_usuario, id_categoria: integer): TJsonArray;
var
    qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := ConnLancamento;
    qry.SQL.Add('Select l.* From lancamento l');
    qry.SQL.Add('Where l.id_usuario = :id_usuario');

    if id_categoria > 0 then
    begin
      qry.SQL.Add('And l.id_categoria = :id_categoria');
      qry.ParamByName('id_categoria').Value := id_categoria;
    end;

    qry.ParamByName('id_usuario').Value := id_usuario;

    qry.Active := true;

    Result := qry.ToJSONArray;
  finally
    FreeAndNil(qry);
  end;
end;



end.
