unit uCategoria;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,System.StrUtils,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IniFiles, System.JSON, IWHTMLTag, IdAuthentication,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IWCompLabel;

type
  TF_Categoria = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IWEDITNOMECATEGORIA: TIWEdit;
    IWEDITATIVO: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWLabelAtivo: TIWLabel;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITNOMECATEGORIAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITATIVOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    procedure PopulaCamposCategoria(XId: integer);
    function ConfirmaCategoria(XId: integer): boolean;
    function IncluiCategoria: boolean;
    procedure CarregaAtivo(XAtivo: boolean);
    function ExcluiCategoria(XId: integer): boolean;
  public
  end;

implementation

{$R *.dfm}


procedure TF_Categoria.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widcategoria: integer;
    wpagina: string;
begin
  if pos('[ExcluiCategoria]',IWEDITNOME.Text)>0 then
     begin
       widcategoria  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiCategoria]',IWEDITNOME.Text)+17,10);
       if ExcluiCategoria(widcategoria) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[AlteraCategoria]',IWEDITNOME.Text)>0 then
     begin
       widcategoria  := strtointdef(IWEDITID.Text,0);
       PopulaCamposCategoria(widcategoria);
     end
  else if pos('[ConfirmaCategoria]',IWEDITNOME.Text)>0 then
     begin
       widcategoria  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ConfirmaCategoria]',IWEDITNOME.Text)+19,10);
       if widcategoria>0 then
          begin
            if ConfirmaCategoria(widcategoria) then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiCategoria then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[IncluiCategoria]',IWEDITNOME.Text)>0 then
     begin
       widcategoria     := 0;
       IWEDITNOMECATEGORIA.Text := '';
       IWEDITATIVO.Text         := '';
       CarregaAtivo(true);
       IWEDITNOMECATEGORIA.SetFocus;
     end;
end;

procedure TF_Categoria.IWEDITATIVOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Ativo" ');
end;

procedure TF_Categoria.IWEDITNOMECATEGORIAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Nome Categoria" ');
end;

procedure TF_Categoria.PopulaCamposCategoria(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
begin
  try
    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    wIdHTTP                      := TIdHTTP.Create(nil);
    wIdHTTP.IOHandler            := wIdSSLIOHandlerSocketOpenSSL;

    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.Charset      := 'UTF-8';
    wIdHTTP.Request.Clear;
    wIdHTTP.Request.BasicAuthentication     := true;
    wIdHTTP.Request.Authentication          := TIdBasicAuthentication.Create;
    wIdHTTP.Request.Authentication.Username := 'user';
    wIdHTTP.Request.Authentication.Password := 'password';

    wIdHTTP.Request.Clear;
    wIdHTTP.Request.CustomHeaders.Clear;
    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.CharSet      := 'utf-8';
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';
    // Get
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/categorias/'+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    IWEDITNOMECATEGORIA.Text   := wjson.GetValue('nome').Value;
    CarregaAtivo(strtobool(wjson.GetValue('ativo').Value));
    IWEDITNOMECATEGORIA.SetFocus;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao popular campos da categoria'+slinebreak+E.Message);
    end;
  end;
end;

function TF_Categoria.ConfirmaCategoria(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wcategoria: TJSONObject;
begin
  try
    wcategoria := TJSONObject.Create;
    wcategoria.AddPair('nome',IWEDITNOMECATEGORIA.Text);
    wcategoria.AddPair('ativo',booltostr(IWEDITATIVO.Text='SIM'));

    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    wIdHTTP                      := TIdHTTP.Create(nil);
    wIdHTTP.IOHandler            := wIdSSLIOHandlerSocketOpenSSL;

    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.Charset      := 'UTF-8';
    wIdHTTP.Request.Clear;
    wIdHTTP.Request.BasicAuthentication     := true;
    wIdHTTP.Request.Authentication          := TIdBasicAuthentication.Create;
    wIdHTTP.Request.Authentication.Username := 'user';
    wIdHTTP.Request.Authentication.Password := 'password';

    wIdHTTP.Request.Clear;
    wIdHTTP.Request.CustomHeaders.Clear;
    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.CharSet      := 'utf-8';
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';

    wJsonToSend := TStringStream.Create(wcategoria.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/categorias/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);
    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao alterar categoria'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Categoria.IncluiCategoria: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wcategoria: TJSONObject;
begin
  try
    wcategoria := TJSONObject.Create;
    wcategoria.AddPair('nome',IWEDITNOMECATEGORIA.Text);
    wcategoria.AddPair('ativo',booltostr(IWEDITATIVO.Text='SIM'));

    warqini                      := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    wIdHTTP                      := TIdHTTP.Create(nil);
    wIdHTTP.IOHandler            := wIdSSLIOHandlerSocketOpenSSL;

    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.Charset      := 'UTF-8';
    wIdHTTP.Request.Clear;
    wIdHTTP.Request.BasicAuthentication     := true;
    wIdHTTP.Request.Authentication          := TIdBasicAuthentication.Create;
    wIdHTTP.Request.Authentication.Username := 'user';
    wIdHTTP.Request.Authentication.Password := 'password';

    wIdHTTP.Request.Clear;
    wIdHTTP.Request.CustomHeaders.Clear;
    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.CharSet      := 'utf-8';
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';

    wJsonToSend := TStringStream.Create(wcategoria.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/categorias';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    wret        := true;
//    WebApplication.ShowMessage('Categoria incluída com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao incluir categoria'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_Categoria.CarregaAtivo(XAtivo: boolean);
var html: string;
begin
  try
     html := '<div class="custom-control custom-toggle custom-toggle-sm mb-1" style="margin-top: 35px">'+slinebreak+
                 IfThen(XAtivo,'<input type="checkbox" id="customToggle1" name="customToggle1" class="custom-control-input" checked="checked" >',
             '     <input type="checkbox" id="customToggle1" name="customToggle1" class="custom-control-input" >')+slinebreak+
             '     <label class="custom-control-label" for="customToggle1" style="font-size: 20px; font-weight: bold; color: #00bfff">Ativo</label>'+slinebreak+
             '</div>'+slinebreak;
     IWLabelAtivo.Text := html;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao carregar campo ativo'+slinebreak+E.Message);
    end;
  end;
end;

function TF_Categoria.ExcluiCategoria(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL: string;
    warqini: TIniFile;
begin
  try
    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    wIdHTTP                      := TIdHTTP.Create(nil);
    wIdHTTP.IOHandler            := wIdSSLIOHandlerSocketOpenSSL;

    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.Charset      := 'UTF-8';
    wIdHTTP.Request.Clear;
    wIdHTTP.Request.BasicAuthentication     := true;
    wIdHTTP.Request.Authentication          := TIdBasicAuthentication.Create;
    wIdHTTP.Request.Authentication.Username := 'user';
    wIdHTTP.Request.Authentication.Password := 'password';

    wIdHTTP.Request.Clear;
    wIdHTTP.Request.CustomHeaders.Clear;
    wIdHTTP.Request.ContentType  := 'application/json';
    wIdHTTP.Request.CharSet      := 'utf-8';
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';
    // Delete
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/categorias/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao excluir categoria'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.
