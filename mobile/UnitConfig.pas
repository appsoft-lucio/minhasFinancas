unit UnitConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFormConfig = class(TForm)
    LytCabecalhoConfig: TLayout;
    LblCabecalhoConfig: TLabel;
    ImgBackConfig: TImage;
    RectEditarPerfil: TRectangle;
    ImgEditarPerfil: TImage;
    LblEditarPerfil: TLabel;
    ImgGoEditarPerfil: TImage;
    RectDesconectar: TRectangle;
    ImgDesconectar: TImage;
    LblDesconectar: TLabel;
    ImgGoDesconectar: TImage;
    RectAssinatura: TRectangle;
    ImgAssinatura: TImage;
    LblAssinatura: TLabel;
    ImgGoAssinatura: TImage;
    RecAlterarSenha: TRectangle;
    ImgAlterarSenha: TImage;
    LblAlterarSenha: TLabel;
    ImgGoAlterarSenha: TImage;
    RectCategoria: TRectangle;
    ImgCategoria: TImage;
    LblCategoria: TLabel;
    ImgGoCategoria: TImage;
    procedure ImgBackConfigClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RectCategoriaClick(Sender: TObject);
    procedure RectEditarPerfilClick(Sender: TObject);
    procedure RecAlterarSenhaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConfig: TFormConfig;

implementation

{$R *.fmx}

uses UnitCategoria, UnitEditPrefil, UnitEditarSenha;

procedure TFormConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        Action:= TCloseAction.caFree;
        FormConfig:= nil;
end;

procedure TFormConfig.ImgBackConfigClick(Sender: TObject);
begin
        Close;
end;

procedure TFormConfig.RecAlterarSenhaClick(Sender: TObject);
begin
        if not Assigned(FormCategoria) then
        Application.CreateForm(TFormEditarSenha, FormEditarSenha);

        FormEditarSenha.Show;
end;

procedure TFormConfig.RectCategoriaClick(Sender: TObject);
begin
        if not Assigned(FormCategoria) then
        Application.CreateForm(TFormCategoria, FormCategoria);

        FormCategoria.Show;
end;

procedure TFormConfig.RectEditarPerfilClick(Sender: TObject);
begin
        if not Assigned(FormEditPerfil) then
        Application.CreateForm(TFormEditPerfil, FormEditPerfil);

        FormEditPerfil.Show;
end;

end.
