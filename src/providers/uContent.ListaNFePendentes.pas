unit uContent.ListaNFePendentes;

interface

uses System.SysUtils, Classes, IW.Content.Base, HTTPApp, IWApplication, IW.HTTP.Request,
    IW.HTTP.Reply, System.StrUtils, IWCompMemo, IWHTMLTag, IWCompLabel, System.JSON,
    IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
    IdAuthentication,IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Rest.JSON, Data.DBXJSON, REST.Response.Adapter,
    FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
    Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt, IniFiles;

type
  TContentListaNFePendentes = class(TContentBase)
  private
    function CarregaNFePendentesDaAPI: TFDMemTable;

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

var wcontent: TContentListaNFePendentes;
    warqini: TIniFile;

{ TContentClientes }

constructor TContentListaNFePendentes.Create;
begin
  inherited;
  mFileMustExist:=False;
  warqini := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
end;

function TContentListaNFePendentes.CarregaNFePendentesDaAPI: TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson: string;
    JObj: TJSONArray;
    wmtNFePendente: TFDMemTable;
begin
  try
    wmtNFePendente := TFDMemTable.Create(nil);

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

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtNFePendente.LoadFromJSON(JObj);
    if not wmtNFePendente.Active then
       wmtNFePendente.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtNFePendente;
end;

function TContentListaNFePendentes.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wresult,wstring: string;
  wtotal: Integer;
  wmtNFePendente: TFDMemTable;
begin
  try
// carrega a lista de atividades da TrabinAPI
    wmtNFePendente := CarregaNFePendentesDaAPI;

    if wmtNFePendente.RecordCount>0 then
       begin
         wmtNFePendente.First;
         wresult:='{'+
          '"draw": 20, ' +
          '"recordsTotal": '+inttostr(wmtNFePendente.RecordCount)+', ' +
          '"recordsFiltered": '+inttostr(wmtNFePendente.RecordCount)+', ' +
          '"data": [';
         while not wmtNFePendente.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtNFePendente.FieldByName('pedido').asString+'", '+
//                               '"'+formatdatetime('dd/mm/yy',wmtNFePendente.FieldByName('dataemissao').AsDateTime)+'", '+
                               '"'+wmtNFePendente.FieldByName('dataemissao').AsString+'", '+
                               '"'+wmtNFePendente.FieldByName('cliente').asString+'", '+
                               '"'+wmtNFePendente.FieldByName('numdoc').asString+wmtNFePendente.FieldByName('situacao').asString+'", '+
                               '"'+wmtNFePendente.FieldByName('chave').asString+'", '+
                               '"'+formatfloat('#,0.00',wmtNFePendente.FieldByName('total').AsFloat)+'", '+
                               '"<center><span class=\"fas fa-list-alt\" align=\"middle\" title=\"Ítens\" onclick=\"itensNFe('+QuotedStr(wmtNFePendente.FieldByName('id').AsString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-money-bill-alt\" align=\"middle\" title=\"Parcelas\" onclick=\"parcelasNFe('+QuotedStr(wmtNFePendente.FieldByName('id').AsString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-bolt\" align=\"middle\" title=\"Autoriza\" onclick=\"autorizaNFe('+QuotedStr(wmtNFePendente.FieldByName('id').AsString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiNFe('+QuotedStr(wmtNFePendente.FieldByName('id').AsString)+');\"></span></center>" '+
                               '],';
           wmtNFePendente.Next;
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
