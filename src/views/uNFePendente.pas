unit uNFePendente;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout, IdAuthentication,
  IWTemplateProcessorHTML, IWCompButton, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON, IniFiles;

type
  TF_NFePendente = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWEDITNOME: TIWEdit;
    IWEDITID: TIWEdit;
    IWBUTTONACAO: TIWButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBUTTONACAOClick(Sender: TObject);
  private
    function ExcluiNFe(XIdNota: integer): boolean;
    function AutorizaNFe(XIdNota: integer): boolean;
    function ConsultaNotaAutorizada(XIdNota: integer): string;
    function RetornaXML(XChave: string): boolean;
    procedure SalvaArquivoXML(XChave: string; XStream: TMemoryStream);
    function RetornaPDF(XChave: string): boolean;
    procedure SalvaArquivoPDF(XChave: string; XStream: TMemoryStream);
    function ExcluiItemDaAPI(XIdItem: integer): boolean;
  public
  end;

implementation

{$R *.dfm}

uses ServerController;

var warqini: TIniFile;


procedure TF_NFePendente.IWAppFormCreate(Sender: TObject);
begin
  ServerController.UserSession.FIdNFePendente := 0;
  warqini := TIniFile.Create(GetCurrentDir+'/TrabinWeb.ini');
end;

procedure TF_NFePendente.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widnota,widitem: integer;
    wpagina: string;
begin
  if pos('[ExcluiNFe]',IWEDITNOME.Text)>0 then
     begin
       widnota := strtointdef(IWEDITID.Text,0);
       wpagina  := copy(IWEDITNOME.Text,pos('[ExcluiNFe]',IWEDITNOME.Text)+11,10);
       if ExcluiNFe(widnota) then
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFePendentes(20);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end;
  if pos('[AutorizaNFe]',IWEDITNOME.Text)>0 then
     begin
       widnota := strtointdef(IWEDITID.Text,0);
       wpagina  := copy(IWEDITNOME.Text,pos('[AutorizaNFe]',IWEDITNOME.Text)+13,10);
       if AutorizaNFe(widnota) then
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFePendentes(20);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end;
  if pos('[ItensNFe]',IWEDITNOME.Text)>0 then
     begin
       widnota := strtointdef(IWEDITID.Text,0);
//       wpagina  := copy(IWEDITNOME.Text,pos('[AutorizaNFe]',IWEDITNOME.Text)+13,10);
       ServerController.UserSession.FIdNFePendente := widnota;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(20);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end;
  if pos('[ParcelasNFe]',IWEDITNOME.Text)>0 then
     begin
       widnota := strtointdef(IWEDITID.Text,0);
//       wpagina  := copy(IWEDITNOME.Text,pos('[AutorizaNFe]',IWEDITNOME.Text)+13,10);
       ServerController.UserSession.FIdNFePendente := widnota;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaParcelas(20);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end;
  if pos('[ExcluiItem]',IWEDITNOME.Text)>0 then
     begin
       widitem  := strtointdef(IWEDITID.Text,0);
       widnota  := strtoint(trim(copy(IWEDITNOME.Text,pos('[ExcluiItem]',IWEDITNOME.Text)+12,10)));

       ServerController.UserSession.FIdNFePendente := widnota;
       if not ExcluiItemDaAPI(widitem) then
          WebApplication.ShowMessage('Ítem não excluído da API');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(20);'); // carrega lista
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFePendentes(20);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end
end;


procedure TF_NFePendente.IWBUTTONACAOClick(Sender: TObject);
begin

end;

// Exclui NFe
function TF_NFePendente.ExcluiNFe(XIdNota: integer): boolean;
var wret: boolean;
    wURL,wretorno: string;
    wstatus: integer;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes/'+inttostr(XIdNota);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes/'+inttostr(XIdNota);
    IdHTTP1.Delete(wURL);
    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Autoriza NFe
function TF_NFePendente.AutorizaNFe(XIdNota: integer): boolean;
var wret: boolean;
    wURL,wretorno,wresult,wchave: string;
    wstatus: integer;
    wjsontosend: TStringStream;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    // transforma string em stringstream
    wJsonToSend := TStringStream.Create('', TEncoding.UTF8);
    wURL     := warqini.ReadString('Geral','URL','')+'/servicos/nfe/'+inttostr(XIdNota);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/servicos/nfe/'+inttostr(XIdNota);
    IdHTTP1.Post(wURL,wjsontosend);
    wresult  := IdHTTP1.Post(wURL,wjsontosend);
    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;

    if wstatus=201 then // Autorizou NFe
       begin
         wchave := ConsultaNotaAutorizada(XIdNota);
         wret   := RetornaXML(wchave);
         wret   := RetornaPDF(wchave);
       end
    else
       wret := false;
  except
    On E: EIdHTTPProtocolException do
    begin
      wret := false;
      WebApplication.ShowMessage(E.ErrorMessage);
    end;
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Consulta NFe Autorizada pelo Id da Nota
function TF_NFePendente.ConsultaNotaAutorizada(XIdNota: integer): string;
var wret,wURL,wretjson,wchave: string;
    wjson: TJSONObject;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/octet-stream';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/octet-stream';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_autorizadas/'+inttostr(XIdNota);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_autorizadas/'+inttostr(XIdNota);
    wretjson := IdHTTP1.Get(wURL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    wret     := wjson.GetValue('chave').Value;

  except
    wret := '';
  end;
  Result := wret;
end;

// Retorna XML NFe
function TF_NFePendente.RetornaXML(XChave: string): boolean;
var wret: boolean;
    wURL,wretorno,wretjson: string;
    wstatus: integer;
    wstream: TMemoryStream;
begin
  try
    wstream := TMemoryStream.Create;

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/octet-stream';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/octet-stream';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/arquivos/nfe_xml/'+XChave;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/arquivos/nfe_xml/'+XChave;
    IdHTTP1.Get(wURL,wstream);
    wstream.Position := 0;

    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
    if wstatus=200 then
       begin
         SalvaArquivoXML(XChave,wstream);
         wret := true;
       end
    else
       wret := false;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Salvar Arquivo XML
procedure TF_NFePendente.SalvaArquivoXML(XChave: string; XStream: TMemoryStream);
var wcaminho,wmes,wano,warquivo: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);
  warquivo := wcaminho+'\'+XChave+'-nfe.xml';
  XStream.SaveToFile(warquivo);
end;


// Retorna PDF NFe
function TF_NFePendente.RetornaPDF(XChave: string): boolean;
var wret: boolean;
    wURL,wretorno,wretjson: string;
    wstatus: integer;
    wstream: TMemoryStream;
begin
  try
    wstream := TMemoryStream.Create;

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/octet-stream';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/octet-stream';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/arquivos/nfe_pdf/'+XChave;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/arquivos/nfe_pdf/'+XChave;
    IdHTTP1.Get(wURL,wstream);
    wstream.Position := 0;

    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
    if wstatus=200 then
       begin
         SalvaArquivoPDF(XChave,wstream);
         wret := true;
       end
    else
       wret := false;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Salvar Arquivo PDF
procedure TF_NFePendente.SalvaArquivoPDF(XChave: string; XStream: TMemoryStream);
var wcaminho,wmes,wano,warquivo: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);
  warquivo := wcaminho+'\'+XChave+'-nfe.pdf';
  XStream.SaveToFile(warquivo);
end;


// Exclui item
function TF_NFePendente.ExcluiItemDaAPI(XIdItem: integer): boolean;
var wstatus: integer;
    wURL,wretorno: string;
    wjson: TJSONObject;
    wret: boolean;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens/'+inttostr(XIdItem);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens/'+inttostr(XIdItem);
    IdHTTP1.Delete(wURL);
    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Erro ao excluir ítem '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.
