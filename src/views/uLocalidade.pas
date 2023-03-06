unit uLocalidade;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,IdAuthentication,System.JSON,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IniFiles, IWHTMLTag,
  IWCompLabel, System.StrUtils;

type
  TF_Localidade = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWEDITLOCALIDADENOME: TIWEdit;
    IWEDITLOCALIDADECODIBGE: TIWEdit;
    IWEDITUF: TIWEdit;
    IWEDITREGIAO: TIWEdit;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITLOCALIDADENOMEHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITLOCALIDADEUFHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITLOCALIDADEREGIAOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITLOCALIDADECODIBGEHTMLTag(ASender: TObject;
      ATag: TIWHTMLTag);
  private
    function ExcluiLocalidade(XId: integer): boolean;
    procedure PopulaCamposLocalidade(XId: integer);
    function ConfirmaLocalidade(XId: integer): boolean;
    function IncluiLocalidade: boolean;
    procedure CarregaSelect(XUF,XRegiao: string);
  public
  end;

implementation

{$R *.dfm}


procedure TF_Localidade.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widlocalidade: integer;
    wpagina: string;
begin
  if pos('[ExcluiLocalidade]',IWEDITNOME.Text)>0 then
     begin
       widlocalidade  := strtointdef(IWEDITID.Text,0);
       wpagina        := copy(IWEDITNOME.Text,pos('[ExcluiLocalidade]',IWEDITNOME.Text)+18,10);
       if ExcluiLocalidade(widlocalidade) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[AlteraLocalidade]',IWEDITNOME.Text)>0 then
     begin
       widlocalidade  := strtointdef(IWEDITID.Text,0);
       PopulaCamposLocalidade(widlocalidade);
     end
  else if pos('[IncluiLocalidade]',IWEDITNOME.Text)>0 then
     begin
       widlocalidade  := 0;
       IWEDITLOCALIDADENOME.Text    := '';
       IWEDITLOCALIDADECODIBGE.Text := '';
       IWEDITLOCALIDADENOME.SetFocus;
     end
  else if pos('[ConfirmaLocalidade]',IWEDITNOME.Text)>0 then
     begin
       widlocalidade := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ConfirmaLocalidade]',IWEDITNOME.Text)+20,10);
       if widlocalidade>0 then
          begin
            if ConfirmaLocalidade(widlocalidade) then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiLocalidade then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end;
end;

procedure TF_Localidade.IWEDITLOCALIDADECODIBGEHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Código do IBGE" ');
end;

procedure TF_Localidade.IWEDITLOCALIDADENOMEHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Descrição da Localidade" ');
end;

procedure TF_Localidade.IWEDITLOCALIDADEREGIAOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Região da Localidade" ');
end;

procedure TF_Localidade.IWEDITLOCALIDADEUFHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="UF da Localidade" ');
end;

function TF_Localidade.ExcluiLocalidade(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/localidades/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao excluir localidade'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_Localidade.PopulaCamposLocalidade(XId: integer);
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/localidades/'+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    IWEDITLOCALIDADENOME.Text    := wjson.GetValue('nome').Value;
    IWEDITLOCALIDADECODIBGE.Text := wjson.GetValue('codibge').Value;
    IWEDITLOCALIDADENOME.SetFocus;
    CarregaSelect(wjson.GetValue('uf').Value,wjson.GetValue('regiao').Value);
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao popular campos da localidade'+slinebreak+E.Message);
    end;
  end;
end;

function TF_Localidade.ConfirmaLocalidade(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno,wuf,wregiao: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wlocalidade: TJSONObject;
begin
  try
    wlocalidade := TJSONObject.Create;
    wlocalidade.AddPair('nome',IWEDITLOCALIDADENOME.Text);
    wlocalidade.AddPair('uf',IWEDITUF.Text);
    wlocalidade.AddPair('regiao',IWEDITREGIAO.Text);
    wlocalidade.AddPair('codibge',IWEDITLOCALIDADECODIBGE.Text);

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

    wJsonToSend := TStringStream.Create(wlocalidade.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/localidades/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);
    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao alterar localidade'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Localidade.IncluiLocalidade: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wlocalidade: TJSONObject;
begin
  try
    wlocalidade := TJSONObject.Create;
    wlocalidade.AddPair('nome',IWEDITLOCALIDADENOME.Text);
    wlocalidade.AddPair('uf',IWEDITUF.Text);
    wlocalidade.AddPair('regiao',IWEDITREGIAO.Text);
    wlocalidade.AddPair('codibge',IWEDITLOCALIDADECODIBGE.Text);

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

    wJsonToSend := TStringStream.Create(wlocalidade.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/localidades';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    wret        := true;
//    WebApplication.ShowMessage('Localidade incluída com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao incluir localidade'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_Localidade.CarregaSelect(XUF,XRegiao: string);
var html,wespecie,wserie,wnomevendedor: string;
    ix,wcta,widvendedor: integer;
begin
  try
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectuf").val('+QuotedStr(XUF)+');');
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectregiao").val('+QuotedStr(XRegiao)+');');
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao carregar campos de select'+slinebreak+E.Message);
    end;
  end;
end;

end.
