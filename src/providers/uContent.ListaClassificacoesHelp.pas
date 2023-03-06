unit uContent.ListaClassificacoesHelp;

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
  TContentListaClassificacoesHelp = class(TContentBase)
  private
    function CarregaClassificacoesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaClassificacoesHelp;
    wnumclassificacoes: integer;

{ TContentClientes }

constructor TContentListaClassificacoesHelp.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaClassificacoesHelp.CarregaClassificacoesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumClassificacoes,wmtClassificacao: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini              := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumClassificacoes := TFDMemTable.Create(nil);
    wmtClassificacao     := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/classificacoes/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/classificacoes/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumClassificacoes.LoadFromJSON(JObj2);
         if not wmtNumClassificacoes.Active then
            wmtNumClassificacoes.Open;
         wnumclassificacoes := wmtNumClassificacoes.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/classificacoes'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/classificacoes?'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/classificacoes';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtClassificacao.LoadFromJSON(JObj);
    if not wmtClassificacao.Active then
       wmtClassificacao.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtClassificacao;
end;

function TContentListaClassificacoesHelp.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,wtipo: string;
  ix,wtotal: Integer;
  wmtClassificacao: TFDMemTable;
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
      0: worder  := 'descricao';
      1: worder  := 'tipo';
    else
      worder := '';
    end;
    if ((wdraw=1) or (wsearch=''))  and (UserSession.FClassificacaoNota<>'') then
       wsearch := UserSession.FClassificacaoNota;
    wmtClassificacao := CarregaClassificacoesDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtClassificacao.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumclassificacoes)+', ' +
          '"recordsFiltered": '+inttostr(wnumclassificacoes)+', ' +
          '"data": [';
         while not wmtClassificacao.Eof do
         begin
           wtipo := wmtClassificacao.FieldByName('tipo').asString;
           wresult := wresult + '['+
                               '"'+wmtClassificacao.FieldByName('descricao').asString+'", '+
                               '"'+wtipo+'", '+
                               '"<center><span class=\"fas fa-share\" align=\"middle\" title=\"Seleciona\" onclick=\"selecionaClassificacao('+QuotedStr(wmtClassificacao.FieldByName('id').asString)+','+QuotedStr(wmtClassificacao.FieldByName('descricao').asString)+');\"></span></center>" '+
                               '],';
           wmtClassificacao.Next;
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
