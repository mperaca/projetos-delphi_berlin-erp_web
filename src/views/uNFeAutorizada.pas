unit uNFeAutorizada;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout, IdAuthentication,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IWCompLabel, IniFiles;

type
  TF_NFeAutorizada = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWLabelArquivoXML: TIWLabel;
    IWLabelArquivoPDF: TIWLabel;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
  private
    function CancelaNFe(XIdNota: integer): boolean;
    function RetornaXML(XChave: string): boolean;
    procedure SalvaArquivoXML(XChave: string; XStream: TMemoryStream);
    procedure MostraArquivoXML(XChave: string);
    function RetornaPDF(XChave: string): boolean;
    procedure SalvaArquivoPDF(XChave: string; XStream: TMemoryStream);
    procedure MostraArquivoPDF(XChave: string);
  public
  end;

implementation

{$R *.dfm}

var warqini: TIniFile;


procedure TF_NFeAutorizada.IWAppFormCreate(Sender: TObject);
begin
  warqini := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
end;

procedure TF_NFeAutorizada.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widnota: integer;
    wpagina,wchave: string;
begin
  if pos('[CancelaNFe]',IWEDITNOME.Text)>0 then
     begin
       widnota := strtointdef(IWEDITID.Text,0);
       wpagina  := copy(IWEDITNOME.Text,pos('[CancelaNFe]',IWEDITNOME.Text)+12,10);
       if CancelaNFe(widnota) then
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFeAutorizadas(20);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end
  else if pos('[RetornaXML]',IWEDITNOME.Text)>0 then
     begin
       wchave   := IWEDITID.Text;
       wpagina  := copy(IWEDITNOME.Text,pos('[RetornaXML]',IWEDITNOME.Text)+12,10);
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFeAutorizadas(20);');
       if RetornaXML(wchave) then
          begin
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            MostraArquivoXML(wchave);
          end;
     end
  else if pos('[RetornaPDF]',IWEDITNOME.Text)>0 then
     begin
       wchave   := IWEDITID.Text;
       wpagina  := copy(IWEDITNOME.Text,pos('[RetornaPDF]',IWEDITNOME.Text)+12,10);
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFeAutorizadas(20);');
       if RetornaPDF(wchave) then
          begin
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            MostraArquivoPDF(wchave);
          end;
     end;
end;

// Mostra Arquivo XML
procedure TF_NFeAutorizada.MostraArquivoXML(XChave: string);
var wcaminho,wcaminho2,wmes,wano,warquivo,warquivo2: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := '/notas/'+wano+'/'+wmes;
  wcaminho2 := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho2) then
     ForceDirectories(wcaminho2);
  warquivo  := wcaminho+'/'+XChave+'-nfe.xml';
  warquivo2 := wcaminho2+'\'+XChave+'-nfe.xml';
  if FileExists(warquivo2) then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalArquivoXML'').modal(''show'');');
       IWLabelArquivoXML.Text := ' <iframe src="'+warquivo+'" width="100%" style="height:80vh;"></iframe> ';
     end
  else
     WebApplication.ShowMessage('Arquivo xml não encontrado');
end;

// Mostra Arquivo PDF
procedure TF_NFeAutorizada.MostraArquivoPDF(XChave: string);
var wcaminho,wcaminho2,wmes,wano,warquivo,warquivo2: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := '/notas/'+wano+'/'+wmes;
  wcaminho2 := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho2) then
     ForceDirectories(wcaminho2);
  warquivo  := wcaminho+'/'+XChave+'-nfe.pdf';
  warquivo2 := wcaminho2+'\'+XChave+'-nfe.pdf';
  if FileExists(warquivo2) then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalArquivoPDF'').modal(''show'');');
       IWLabelArquivoPDF.Text := ' <iframe src="'+warquivo+'" width="100%" style="height:80vh;"></iframe> ';
     end
  else
     WebApplication.ShowMessage('Arquivo pdf não encontrado');
end;


// Cancela NFe
function TF_NFeAutorizada.CancelaNFe(XIdNota: integer): boolean;
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

    wURL     := warqini.ReadString('Geral','URL','')+'/servicos/nfe/'+inttostr(XIdNota);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/servicos/nfe/'+inttostr(XIdNota);
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

// Retorna XML NFe
function TF_NFeAutorizada.RetornaXML(XChave: string): boolean;
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

// Salva Arquivo XML
procedure TF_NFeAutorizada.SalvaArquivoXML(XChave: string; XStream: TMemoryStream);
var wcaminho,wmes,wano,warquivo: string;
    wdata: tdate;
begin
  wano     := '20'+copy(XChave,3,2);
  wmes     := copy(XChave,5,2);
  wdata    := strtodate('01/'+wmes+'/'+wano);
  wmes     := formatdatetime('mmmm',wdata);
  wcaminho := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);
  warquivo := wcaminho+'\'+XChave+'-nfe.xml';
  XStream.SaveToFile(warquivo);
end;


// Retorna PDF NFe
function TF_NFeAutorizada.RetornaPDF(XChave: string): boolean;
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

// Salva Arquivo PDF
procedure TF_NFeAutorizada.SalvaArquivoPDF(XChave: string; XStream: TMemoryStream);
var wcaminho,wmes,wano,warquivo: string;
    wdata: tdate;
begin
  wano     := '20'+copy(XChave,3,2);
  wmes     := copy(XChave,5,2);
  wdata    := strtodate('01/'+wmes+'/'+wano);
  wmes     := formatdatetime('mmmm',wdata);
  wcaminho := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);
  warquivo := wcaminho+'\'+XChave+'-nfe.pdf';
  XStream.SaveToFile(warquivo);
end;


end.
