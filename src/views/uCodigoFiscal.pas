unit uCodigoFiscal;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl,System.StrUtils,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IniFiles, System.JSON, IWHTMLTag, IdAuthentication,
  IWCompLabel;

type
  TF_CodigoFiscal = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWEDITCODIGO: TIWEdit;
    IWEDITDIGITO: TIWEdit;
    IWEDITNATUREZA: TIWEdit;
    IWEDITABREVIA: TIWEdit;
    IWLabelImpostos: TIWLabel;
    IWLabel1: TIWLabel;
    IWEDITICMS: TIWEdit;
    IWEDITIPI: TIWEdit;
    IWEDITIRT: TIWEdit;
    IWEDITPIS: TIWEdit;
    IWEDITCOFINS: TIWEdit;
    IWEDITVENDAS: TIWEdit;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITCODIGOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITDIGITOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITNATUREZAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITABREVIAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    procedure PopulaCamposCodigoFiscal(XId: integer);
    procedure CarregaImpostos(XICMS,XIPI,XIRT,XPIS,XCOFINS,XVendas: boolean);
    function ConfirmaCodigoFiscal(XId: integer): boolean;
    function IncluiCodigoFiscal: boolean;
    function ExcluiCodigoFiscal(XId: integer): boolean;
  public
  end;

implementation

{$R *.dfm}


procedure TF_CodigoFiscal.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widcodigofiscal: integer;
    wpagina: string;
begin
  if pos('[ExcluiCodigoFiscal]',IWEDITNOME.Text)>0 then
     begin
       widcodigofiscal  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiCodigoFiscal]',IWEDITNOME.Text)+20,10);
       if ExcluiCodigoFiscal(widcodigofiscal) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[AlteraCodigoFiscal]',IWEDITNOME.Text)>0 then
     begin
       widcodigofiscal  := strtointdef(IWEDITID.Text,0);
       PopulaCamposCodigoFiscal(widcodigofiscal);
     end
  else if pos('[ConfirmaCodigoFiscal]',IWEDITNOME.Text)>0 then
     begin
       widcodigofiscal  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ConfirmaCodigoFiscal]',IWEDITNOME.Text)+22,10);
       if widcodigofiscal>0 then
          begin
            if ConfirmaCodigoFiscal(widcodigofiscal) then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiCodigoFiscal then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[IncluiCodigoFiscal]',IWEDITNOME.Text)>0 then
     begin
       widcodigofiscal     := 0;
       IWEDITCODIGO.Text   := '';
       IWEDITDIGITO.Text   := '';
       IWEDITNATUREZA.Text := '';
       IWEDITABREVIA.Text  := '';
       CarregaImpostos(false,false,false,false,false,false);
       IWEDITCODIGO.SetFocus;
     end;
end;

procedure TF_CodigoFiscal.IWEDITABREVIAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Abreviatura" ');
end;

procedure TF_CodigoFiscal.IWEDITCODIGOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Código Fiscal" ');
end;

procedure TF_CodigoFiscal.IWEDITDIGITOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Dígito" ');
end;

procedure TF_CodigoFiscal.IWEDITNATUREZAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Natureza da Operação" ');
end;

procedure TF_CodigoFiscal.PopulaCamposCodigoFiscal(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wicms,wipi,wirt,wpis,wcofins,wvendas: boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais/'+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    IWEDITCODIGO.Text   := wjson.GetValue('codigo').Value;
    IWEDITDIGITO.Text   := wjson.GetValue('digito').Value;
    IWEDITNATUREZA.Text := wjson.GetValue('natureza').Value;
    IWEDITABREVIA.Text  := wjson.GetValue('abrevia').Value;
    wicms               := strtobooldef(wjson.GetValue('incideicms').Value,false);
    wipi                := strtobooldef(wjson.GetValue('incideipi').Value,false);
    wirt                := strtobooldef(wjson.GetValue('incideirt').Value,false);
    wpis                := strtobooldef(wjson.GetValue('incidepis').Value,false);
    wcofins             := strtobooldef(wjson.GetValue('incidecofins').Value,false);
    wvendas             := strtobooldef(wjson.GetValue('compoevenda').Value,false);
    CarregaImpostos(wicms,wipi,wirt,wpis,wcofins,wvendas);
    IWEDITCODIGO.SetFocus;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao popular campos dos códigos fiscais'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_CodigoFiscal.CarregaImpostos(XICMS,XIPI,XIRT,XPIS,XCOFINS,XVendas: boolean);
var html,html2: string;
begin
  try
     html := '<div class="row">'+slinebreak+
             '  <div class="col-md-4">'+slinebreak+
             '    <div class="custom-control custom-toggle custom-toggle-sm mb-1">'+slinebreak+
                      IfThen(XICMS,'<input type="checkbox" id="customToggle2" name="customToggle2" class="custom-control-input" checked="checked" >',
                      '<input type="checkbox" id="customToggle2" name="customToggle2" class="custom-control-input" >')+slinebreak+
             '        <label class="custom-control-label" for="customToggle2" style="font-size: 20px; font-weight: bold; color: #00bfff">ICMS</label>'+slinebreak+
             '    </div>'+slinebreak+
             '  </div>'+slinebreak+
             '  <div class="col-md-4">'+slinebreak+
             '    <div class="custom-control custom-toggle custom-toggle-sm mb-1">'+slinebreak+
                      IfThen(XIPI,'<input type="checkbox" id="customToggle3" name="customToggle3" class="custom-control-input" checked="checked" >',
                      '<input type="checkbox" id="customToggle3" name="customToggle3" class="custom-control-input" >')+slinebreak+
             '        <label class="custom-control-label" for="customToggle3" style="font-size: 20px; font-weight: bold; color: #00bfff">IPI</label>'+slinebreak+
             '   </div>'+slinebreak+
             '  </div>'+slinebreak+
             '  <div class="col-md-4">'+slinebreak+
             '    <div class="custom-control custom-toggle custom-toggle-sm mb-1">'+slinebreak+
                      IfThen(XIRT,'<input type="checkbox" id="customToggle4" name="customToggle4" class="custom-control-input" checked="checked" >',
                      '<input type="checkbox" id="customToggle4" name="customToggle4" class="custom-control-input" >')+slinebreak+
             '        <label class="custom-control-label" for="customToggle4" style="font-size: 20px; font-weight: bold; color: #00bfff">IRT</label>'+slinebreak+
             '    </div>'+slinebreak+
             '  </div>'+slinebreak+
             '</div><br>';
     html2 := '<div class="row">'+slinebreak+
             '  <div class="col-md-4">'+slinebreak+
             '    <div class="custom-control custom-toggle custom-toggle-sm mb-1">'+slinebreak+
                      IfThen(XPIS,'<input type="checkbox" id="customToggle5" name="customToggle5" class="custom-control-input" checked="checked" >',
                      '<input type="checkbox" id="customToggle5" name="customToggle5" class="custom-control-input" >')+slinebreak+
             '        <label class="custom-control-label" for="customToggle5" style="font-size: 20px; font-weight: bold; color: #00bfff">PIS</label>'+slinebreak+
             '    </div>'+slinebreak+
             '  </div>'+slinebreak+
             '  <div class="col-md-4">'+slinebreak+
             '    <div class="custom-control custom-toggle custom-toggle-sm mb-1">'+slinebreak+
                      IfThen(XCOFINS,'<input type="checkbox" id="customToggle6" name="customToggle6" class="custom-control-input" checked="checked" >',
                      '<input type="checkbox" id="customToggle6" name="customToggle6" class="custom-control-input" >')+slinebreak+
             '        <label class="custom-control-label" for="customToggle6" style="font-size: 20px; font-weight: bold; color: #00bfff">COFINS</label>'+slinebreak+
             '   </div>'+slinebreak+
             '  </div>'+slinebreak+
             '  <div class="col-md-4">'+slinebreak+
             '    <div class="custom-control custom-toggle custom-toggle-sm mb-1">'+slinebreak+
                      IfThen(XVendas,'<input type="checkbox" id="customToggle7" name="customToggle7" class="custom-control-input" checked="checked" >',
                      '<input type="checkbox" id="customToggle7" name="customToggle7" class="custom-control-input" >')+slinebreak+
             '        <label class="custom-control-label" for="customToggle7" style="font-size: 20px; font-weight: bold; color: #00bfff">VENDAS</label>'+slinebreak+
             '    </div>'+slinebreak+
             '  </div>'+slinebreak+
             '</div>';
    IWLabelImpostos.Text := html+slinebreak+html2;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao carregar impostos'+slinebreak+E.Message);
    end;
  end;
end;

function TF_CodigoFiscal.ConfirmaCodigoFiscal(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wcodigofiscal: TJSONObject;
begin
  try
    wcodigofiscal := TJSONObject.Create;
    wcodigofiscal.AddPair('codigo',IWEDITCODIGO.Text);
    wcodigofiscal.AddPair('digito',IWEDITDIGITO.Text);
    wcodigofiscal.AddPair('natureza',IWEDITNATUREZA.Text);
    wcodigofiscal.AddPair('abrevia',IWEDITABREVIA.Text);
    wcodigofiscal.AddPair('incideicms',IfThen(IWEDITICMS.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incideipi',IfThen(IWEDITIPI.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incideirt',IfThen(IWEDITIRT.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incidepis',IfThen(IWEDITPIS.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incidecofins',IfThen(IWEDITCOFINS.Text='SIM','true','false'));
    wcodigofiscal.AddPair('compoevenda',IfThen(IWEDITVENDAS.Text='SIM','true','false'));

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

    wJsonToSend := TStringStream.Create(wcodigofiscal.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);
    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao alterar código fiscal'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_CodigoFiscal.IncluiCodigoFiscal: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wcodigofiscal: TJSONObject;
begin
  try
    wcodigofiscal := TJSONObject.Create;
    wcodigofiscal.AddPair('codigo',IWEDITCODIGO.Text);
    wcodigofiscal.AddPair('digito',IWEDITDIGITO.Text);
    wcodigofiscal.AddPair('natureza',IWEDITNATUREZA.Text);
    wcodigofiscal.AddPair('abrevia',IWEDITABREVIA.Text);
    wcodigofiscal.AddPair('incideicms',IfThen(IWEDITICMS.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incideipi',IfThen(IWEDITIPI.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incideirt',IfThen(IWEDITIRT.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incidepis',IfThen(IWEDITPIS.Text='SIM','true','false'));
    wcodigofiscal.AddPair('incidecofins',IfThen(IWEDITCOFINS.Text='SIM','true','false'));
    wcodigofiscal.AddPair('compoevenda',IfThen(IWEDITVENDAS.Text='SIM','true','false'));

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

    wJsonToSend := TStringStream.Create(wcodigofiscal.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    wret        := true;
//    WebApplication.ShowMessage('Código Fiscal incluído com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao incluir código fiscal'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_CodigoFiscal.ExcluiCodigoFiscal(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Problema ao excluir código fiscal'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.
