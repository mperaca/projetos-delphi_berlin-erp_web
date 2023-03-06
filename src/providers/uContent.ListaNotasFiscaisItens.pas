unit uContent.ListaNotasFiscaisItens;

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
  TContentListaNotasFiscaisItens = class(TContentBase)
  private
    function CarregaNotasFiscaisItensDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaNotasFiscaisItens;
    wnumitens: integer;

{ TContentClientes }

constructor TContentListaNotasFiscaisItens.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaNotasFiscaisItens.CarregaNotasFiscaisItensDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao,werro: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumItens,wmtItem: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini     := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumItens := TFDMemTable.Create(nil);
    wmtItem     := TFDMemTable.Create(nil);

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

    if XOffset=0 then // primeira pesquisa
       begin
         if Length(trim(XSearch))>0 then
            wURL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumItens.LoadFromJSON(JObj2);
         if not wmtNumItens.Active then
            wmtNumItens.Open;
         wnumitens := wmtNumItens.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            begin
              wURL  := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens?'+XOrder+'='+XSearch;
              if Length(trim(XOrder))>0 then
                 wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
            end
         else
            begin
              wURL  := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens';
              if Length(trim(XOrder))>0 then
                 wURL  := wURL+'?order='+XOrder+'&dir='+XDir;
            end;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtItem.LoadFromJSON(JObj);
    if not wmtItem.Active then
       wmtItem.Open;
  except
    On E: Exception do
    begin
      werro := E.Message;
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtItem;
end;

function TContentListaNotasFiscaisItens.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,werro,wdescricao: string;
  ix,wtotal: Integer;
  wmtItem: TFDMemTable;
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
      0: worder  := 'xcodproduto';
      1: worder  := 'xdescproduto';
      2: worder  := 'xcodigofiscal';
      3: worder  := 'quantidade';
      4: worder  := 'valorunitario';
      5: worder  := 'percentualdesconto';
      6: worder  := 'valordesconto';
      7: worder  := 'valortotal';
    else
      worder := '';
    end;
    wmtItem := CarregaNotasFiscaisItensDaAPI(wsearch,worder,wdir,wlength,wstart);
    UserSession.FMemTableNotaItem := wmtItem;
    if wmtItem.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumitens)+', ' +
          '"recordsFiltered": '+inttostr(wnumitens)+', ' +
          '"data": [';
         while not wmtItem.Eof do
         begin
           wdescricao := StringReplace(wmtItem.FieldByName('xdescproduto').asString,'"','''',[rfReplaceAll]);
           wresult := wresult + '['+
                               '"'+wmtItem.FieldByName('xcodproduto').asString+'", '+
                               '"'+wdescricao+'", '+
                               '"'+wmtItem.FieldByName('xcodigofiscal').asString+'", '+
                               '"'+FormatFloat('#,0.000',strtofloatdef(wmtItem.FieldByName('quantidade').asString,0))+'", '+
                               '"'+FormatFloat('#,0.00',strtofloatdef(wmtItem.FieldByName('valorunitario').asString,0))+'", '+
                               '"'+FormatFloat('#,0.00%',strtofloatdef(wmtItem.FieldByName('percentualdesconto').asString,0))+'", '+
                               '"'+FormatFloat('#,0.00',strtofloatdef(wmtItem.FieldByName('valordesconto').asString,0))+'", '+
                               '"'+FormatFloat('#,0.00',strtofloatdef(wmtItem.FieldByName('valortotal').asString,0))+'", '+
                               '"<center><span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"alteraItem('+QuotedStr(wmtItem.FieldByName('id').asString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiItem('+QuotedStr(wmtItem.FieldByName('id').asString)+','+QuotedStr(wmtItem.FieldByName('xcodproduto').asString)+');\"></span></center>" '+
                               '],';
           wmtItem.Next;
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
    end;
  end;
  Result:=True;
end;

end.
