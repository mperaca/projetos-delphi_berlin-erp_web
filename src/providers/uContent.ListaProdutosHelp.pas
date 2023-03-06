unit uContent.ListaProdutosHelp;

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
  TContentListaProdutosHelp = class(TContentBase)
  private
    function CarregaProdutosDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaProdutosHelp;
    wnumprodutos: integer;

{ TContentClientes }

constructor TContentListaProdutosHelp.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaProdutosHelp.CarregaProdutosDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao,werro: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumProdutos,wmtProduto: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini        := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumProdutos := TFDMemTable.Create(nil);
    wmtProduto     := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/produtos/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/produtos/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumProdutos.LoadFromJSON(JObj2);
         if not wmtNumProdutos.Active then
            wmtNumProdutos.Open;
         wnumprodutos := wmtNumProdutos.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/produtos'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/produtos?'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/produtos';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtProduto.LoadFromJSON(JObj);
    if not wmtProduto.Active then
       wmtProduto.Open;
  except
    On E: Exception do
    begin
      werro := E.Message;
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtProduto;
end;

function TContentListaProdutosHelp.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,wdescricao: string;
  ix,wtotal: Integer;
  wmtProduto: TFDMemTable;
  wdraw,wlength,wstart: integer;
begin
  try
    wdraw   := StrToIntDef(aRequest.QueryFields.Values['draw'],0);
    wlength := StrToIntDef(aRequest.QueryFields.Values['length'],0);
    wstart  := StrToIntDef(aRequest.QueryFields.Values['start'],0);
    wsearch      := aRequest.QueryFields.Values['search[value]'];
    wordercolumn := aRequest.QueryFields.Values['order[0][column]'];
    wdir         := aRequest.QueryFields.Values['order[0][dir]'];
    case wordercolumn.ToInteger of
      0: worder  := IfThen(UserSession.FTipoHelpProduto='codigo','codigo','descricao');
      1: worder  := IfThen(UserSession.FTipoHelpProduto='descricao','descricao','codigo');
      2: worder  := 'xestrutura';
      3: worder  := 'referencia';
      4: worder  := 'cean';
      5: worder  := 'preco1';
      6: worder  := 'xsaldo';
    else
      worder := '';
    end;
    if UserSession.FTipoHelpProduto='codigo' then
       begin
         if ((wdraw=1) or (wsearch=''))  and (UserSession.FCodProdutoItem<>'') then
            wsearch := UserSession.FCodProdutoItem;
         if ((wdraw=1) or (wsearch=''))  and (UserSession.FCodProdutoNotaItem<>'') then
            wsearch := UserSession.FCodProdutoNotaItem;
       end
    else if UserSession.FTipoHelpProduto='descricao' then
       begin
         if ((wdraw=1) or (wsearch=''))  and (UserSession.FDescProdutoItem<>'') then
            wsearch := UserSession.FDescProdutoItem;
         if ((wdraw=1) or (wsearch=''))  and (UserSession.FDescProdutoNotaItem<>'') then
            wsearch := UserSession.FDescProdutoNotaItem;
       end;
    wmtProduto := CarregaProdutosDaAPI(wsearch,worder,wdir,wlength,wstart);
    UserSession.FMemTableProdutoHelp := wmtProduto;
    if wmtProduto.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumprodutos)+', ' +
          '"recordsFiltered": '+inttostr(wnumprodutos)+', ' +
          '"data": [';
            while not wmtProduto.Eof do
            begin
              wdescricao := StringReplace(wmtProduto.FieldByName('descricao').asString,'"','''',[rfReplaceAll]);
              wresult := wresult + '['+
                                 '"'+wmtProduto.FieldByName('codigo').asString+'", '+
                                 '"'+wdescricao+'", '+
                                 '"'+wmtProduto.FieldByName('xestrutura').asString+'", '+
                                 '"'+wmtProduto.FieldByName('referencia').asString+'", '+
                                 '"'+wmtProduto.FieldByName('cean').asString+'", '+
                                 '"'+formatfloat('#,0.00',wmtProduto.FieldByName('preco1').AsFloat)+'", '+
                                 '"'+formatfloat('#,0.00',wmtProduto.FieldByName('xsaldo').AsFloat)+'", '+
                                 '"<center><span class=\"fas fa-share\" align=\"middle\" title=\"Seleciona\" onclick=\"selecionaProduto('+QuotedStr(wmtProduto.FieldByName('id').asString)+','+QuotedStr(wmtProduto.FieldByName('codigo').asString)+','+QuotedStr(wdescricao)+');\"></span></center>" '+
                                 '],';
              wmtProduto.Next;
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
  //     ApplicationShowException(E);
    end;
  end;
  Result:=True;
end;

end.
