unit Controllers.Users;

interface

uses Horse;

procedure RegistrarRotas;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure InsertUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditPassword(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListUserId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
        THorse.Post('/users/login', Login);
        THorse.Post('/users/registration', InsertUser);
        THorse.Post('/users/password', EditPassword);
        THorse.Get('/users/ListUserId', ListUserId);
        THorse.Put('/users', EditUser);
end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Rotina de login acessada ;).')
end;

procedure InsertUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Inserindo usuario ;).')
end;

procedure EditPassword(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Editar senha ;).')
end;

procedure ListUserId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Listar usuario ;).')
end;

procedure EditUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
        Res.Send('Editar usuario ;).')
end;
end.
