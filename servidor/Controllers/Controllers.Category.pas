unit Controllers.Category;

interface

uses Horse,
     System.SysUtils,
     Services.Category,
     System.Json;

procedure RegistrarRotas;
procedure List(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Edit(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DeleteCategory(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
        THorse.Get('/category', List);
        THorse.Get('/category/:id_category', ListId);
        THorse.Post('/category', Insert);
        THorse.Put('/category/:id_category', Edit);
        THorse.Delete('/category/:id_category', DeleteCategory);
end;

procedure List(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        var
                id_user: integer;
        try
                id_user:= 1; //Pegaremos depois token do JWT
                Res.Send<TJsonArray>(Services.Category.List(id_user));

        except on ex:exception do
                Res.Send('Erro: ' + ex.ClassName + ' - ' + ex.Message).Status(500);

        end;

end;

procedure ListId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Rotina de lista uma categoria acessada ;).')
end;

procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Inserir categoria;).')
end;

procedure Edit(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Editar categoria ;).')
end;

procedure DeleteCategory(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Deletar categoria ;).')
end;

end.

