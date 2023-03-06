unit uContent.ListaNotasFiscaisCFOPS;

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
  TContentListaNotasFiscaisCFOPS = class(TContentBase)
  private
    function CarregaNotasFiscaisCFOPSDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaNotasFiscaisCFOPS;

{ TContentClientes }

constructor TContentListaNotasFiscaisCFOPS.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaNotasFiscaisCFOPS.CarregaNotasFiscaisCFOPSDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao,werro: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtCFOP: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini     := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtCFOP     := TFDMemTable.Create(nil);

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
//    wIdHTTP.Request.CustomHeaders.AddValue('Content-Type','application/json');
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/cfops'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            begin
              wURL  := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/cfops?'+XOrder+'='+XSearch;
              if Length(trim(XOrder))>0 then
                 wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
            end
         else
            begin
              wURL  := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/cfops';
              if Length(trim(XOrder))>0 then
                 wURL  := wURL+'?order='+XOrder+'&dir='+XDir;
            end;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtCFOP.LoadFromJSON(JObj);
    if not wmtCFOP.Active then
       wmtCFOP.Open;
  except
    On E: Exception do
    begin
      werro := E.Message;
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtCFOP;
end;

function TContentListaNotasFiscaisCFOPS.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,werro: string;
  ix,wtotal: Integer;
  wmtCFOP: TFDMemTable;
  wdraw,wlength,wstart: integer;
begin
  try
    wdraw   := StrToIntDef(aRequest.QueryFields.Values['draw'],0);
    wlength := StrToIntDef(aRequest.QueryFields.Values['length'],0);
    wstart  := StrToIntDef(aRequest.QueryFields.Values['start'],0);
    wsearch      := aRequest.QueryFields.Values['search[value]'];
    wordercolumn := aRequest.QueryFields.Values['order[0][column]'];
    wdir         := aRequest.QueryFields.Values['order[0][dir]'];
    case strtointdef(wordercolumn,0) of
      0: worder  := 'xcfop';
      1: worder  := 'totalitem';
    else
      worder := '';
    end;
    wmtCFOP := CarregaNotasFiscaisCFOPSDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtCFOP.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wmtCFOP.RecordCount)+', ' +
          '"recordsFiltered": '+inttostr(wmtCFOP.RecordCount)+', ' +
          '"data": [';
         while not wmtCFOP.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtCFOP.FieldByName('xcfop').asString+'", '+
                               '"'+FormatFloat('#,0.00',strtofloatdef(wmtCFOP.FieldByName('totalitem').asString,0))+'" '+
                               '],';
           wmtCFOP.Next;
         end;
         wresult := LeftStr(Trim(wresult),Length(Trim(wresult))-1) + ']}';
       end
    else
       begin
         wresult:='{'+
          '"draw": 0, ' +
          '"recordsTotal": 0, ' +
          '"recordsFiltered": 0, ' +
          '"data": []}';
       end;
    aReply.WriteString(wresult);
  except
    On E: Exception do
    begin
      werro := E.Message;
  //     ApplicationShowException(E);
    end;
  end;
  Result:=True;
end;

end.
