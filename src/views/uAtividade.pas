unit uAtividade;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, Vcl.ExtCtrls,
  IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent, IdComponent,
  IdAuthentication,System.JSON, IWHTMLTag,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IniFiles;

type
  TF_Atividade = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    TrayIcon1: TTrayIcon;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP1: TIdHTTP;
    IWEditAtividadeId: TIWEdit;
    IWEDITATIVIDADENOME: TIWEdit;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITATIVIDADENOMEHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    function ExcluiAtividade(XId: integer): boolean;
    procedure PopulaCamposAtividade(XId: integer);
    function ConfirmaAtividade(XId: integer): boolean;
    function IncluiAtividade: boolean;
  public
  end;

implementation

{$R *.dfm}

procedure TF_Atividade.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widatividade: integer;
    wpagina: string;
begin
  if pos('[ExcluiAtividade]',IWEDITNOME.Text)>0 then
     begin
       widatividade  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiAtividade]',IWEDITNOME.Text)+17,10);
       if ExcluiAtividade(widatividade) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[AlteraAtividade]',IWEDITNOME.Text)>0 then
     begin
       widatividade  := strtointdef(IWEDITID.Text,0);
       PopulaCamposAtividade(widatividade);
     end
  else if pos('[ConfirmaAtividade]',IWEDITNOME.Text)>0 then
     begin
       widatividade  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ConfirmaAtividade]',IWEDITNOME.Text)+19,10);
       if widatividade>0 then
          begin
            if ConfirmaAtividade(widatividade) then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiAtividade then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[IncluiAtividade]',IWEDITNOME.Text)>0 then
     begin
       widatividade  := 0;
       IWEDITATIVIDADENOME.Text := '';
       IWEDITATIVIDADENOME.SetFocus;
     end;
end;

procedure TF_Atividade.IWEDITATIVIDADENOMEHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Descrição da Atividade" ');
end;

procedure TF_Atividade.PopulaCamposAtividade(XId: integer);
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/atividades/'+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    wnome    := wjson.GetValue('nome').Value;
    IWEDITATIVIDADENOME.Text := wnome;
    IWEDITATIVIDADENOME.SetFocus;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao popular campos da atividade'+slinebreak+E.Message);
    end;
  end;
end;

function TF_Atividade.ConfirmaAtividade(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    watividade: TJSONObject;
begin
  try
    watividade := TJSONObject.Create;
    watividade.AddPair('nome',IWEDITATIVIDADENOME.Text);

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

    wJsonToSend := TStringStream.Create(watividade.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/atividades/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);
    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao alterar atividade'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Atividade.ExcluiAtividade(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/atividades/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao excluir atividade'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Atividade.IncluiAtividade: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    watividade: TJSONObject;
begin
  try
    watividade := TJSONObject.Create;
    watividade.AddPair('nome',IWEDITATIVIDADENOME.Text);

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

    wJsonToSend := TStringStream.Create(watividade.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/atividades';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    wret        := true;
//    WebApplication.ShowMessage('Atividade incluída com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao incluir atividade'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.
