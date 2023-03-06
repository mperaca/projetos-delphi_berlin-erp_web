unit uContent.ListaNFeAutorizadas;

interface

uses System.SysUtils, Classes, IW.Content.Base, HTTPApp, IWApplication, IW.HTTP.Request,
    IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
    IW.HTTP.Reply, System.StrUtils, IWCompMemo, IWHTMLTag, IWCompLabel, System.JSON,
    IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
    IdAuthentication,IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Rest.JSON, Data.DBXJSON, REST.Response.Adapter,
    FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
    Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt, IniFiles;

type
  TContentListaNFeAutorizadas = class(TContentBase)
  private
    function CarregaNFeAutorizadasDaAPI: TFDMemTable;

  protected
    function Execute(aRequest: THttpRequest;
                     aReply: THttpReply;
                     const aPathname: string;
                     aSession: TIWApplication): boolean; override;


  public
    constructor Create;
//    constructor Create; override;

  end;

implementation

uses ServerController, DataSet.Serialize;

var wcontent: TContentListaNFeAutorizadas;
    warqini: TIniFile;

{ TContentClientes }

constructor TContentListaNFeAutorizadas.Create;
begin
  inherited;
  mFileMustExist:=False;
  warqini := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
end;

function TContentListaNFeAutorizadas.CarregaNFeAutorizadasDaAPI: TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson: string;
    JObj: TJSONArray;
    wstatus: integer;
    wmtNFeAutorizada: TFDMemTable;
begin
  try
    wmtNFeAutorizada := TFDMemTable.Create(nil);

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

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_autorizadas';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_autorizadas';
    wretjson := wIdHTTP.Get(wURL);
    wstatus  := wIdHTTP.ResponseCode;

    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtNFeAutorizada.LoadFromJSON(JObj);
    if not wmtNFeAutorizada.Active then
       wmtNFeAutorizada.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtNFeAutorizada;
end;

function TContentListaNFeAutorizadas.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wresult,wstring: string;
  wtotal: Integer;
  wmtNFeAutorizada: TFDMemTable;
begin
  try
// carrega a lista de nfes autorizadas da TrabinAPI
    wmtNFeAutorizada := CarregaNFeAutorizadasDaAPI;

    if wmtNFeAutorizada.RecordCount>0 then
       begin
         wmtNFeAutorizada.First;
         wresult:='{'+
          '"draw": 20, ' +
          '"recordsTotal": '+inttostr(wmtNFeAutorizada.RecordCount)+', ' +
          '"recordsFiltered": '+inttostr(wmtNFeAutorizada.RecordCount)+', ' +
          '"data": [';
         while not wmtNFeAutorizada.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtNFeAutorizada.FieldByName('pedido').asString+'", '+
//                               '"'+formatdatetime('dd/mm/yy',wmtNFePendente.FieldByName('dataemissao').AsDateTime)+'", '+
                               '"'+wmtNFeAutorizada.FieldByName('dataemissao').AsString+'", '+
                               '"'+wmtNFeAutorizada.FieldByName('cliente').asString+'", '+
                               '"'+wmtNFeAutorizada.FieldByName('numdoc').asString+wmtNFeAutorizada.FieldByName('situacao').asString+'", '+
                               '"'+wmtNFeAutorizada.FieldByName('chave').asString+'", '+
                               '"'+formatfloat('#,0.00',wmtNFeAutorizada.FieldByName('total').AsFloat)+'", '+
                               '"<center><span class=\"fas fa-file-pdf\" align=\"middle\" title=\"PDF\" onclick=\"retornaPDF('+QuotedStr(wmtNFeAutorizada.FieldByName('chave').asString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-file-code\" align=\"middle\" title=\"XML\" onclick=\"retornaXML('+QuotedStr(wmtNFeAutorizada.FieldByName('chave').asString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Cancela\" onclick=\"cancelaNFe('+QuotedStr(wmtNFeAutorizada.FieldByName('id').asString)+','+QuotedStr(wmtNFeAutorizada.FieldByName('situacao').asString)+');\"></span></center>" '+
                               '],';
           wmtNFeAutorizada.Next;
         end;
         wresult := LeftStr(Trim(wresult),Length(Trim(wresult))-1) + ']}';
       end
    else
       begin
         wresult:='{'+
          '"draw": 20, ' +
          '"recordsTotal": 0, ' +
          '"recordsFiltered": 0, ' +
          '"data": []}';
       end;
    aReply.WriteString(wresult);
  except
    On E: Exception do
    begin
       ApplicationShowException(E);
    end;
  end;
  Result:=True;
end;

end.
