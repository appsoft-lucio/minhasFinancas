unit Services.Category;

interface

uses Horse,
     System.SysUtils,
     System.JSON;

function List(id_user: integer): TJsonArray;
procedure ListId();
procedure Insert();
procedure Edit();
procedure DeleteCategory();

implementation


function List(id_user: integer): TJsonArray;
begin

end;

procedure ListId();
begin
        //Res.Send('Rotina de lista uma categoria acessada ;).')
end;

procedure Insert();
begin
        //Res.Send('Inserir categoria;).')
end;

procedure Edit();
begin
        //Res.Send('Editar categoria ;).')
end;

procedure DeleteCategory();
begin
        //Res.Send('Deletar categoria ;).')
end;

end.
