unit uContent.ListaValidacoesHelp;

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
  TContentListaValidacoesHelp = class(TContentBase)
  private
    function CarregaValidacoesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaValidacoesHelp;
    wnumvalidacoes: integer;

{ TContentClientes }

constructor TContentListaValidacoesHelp.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaValidacoesHelp.CarregaValidacoesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumValidacoes,wmtValidacao: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini        := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumValidacoes := TFDMemTable.Create(nil);
    wmtValidacao     := TFDMemTable.Create(nil);

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
         if UserSession.FTipoHelpValidacao='especie' then
            begin
              if Length(trim(XSearch))>0 then
                 wURL := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes/total?tipo=E&'+XOrder+'='+XSearch
              else
                 wURL := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes/total?tipo=E';
            end
         else if UserSession.FTipoHelpValidacao='serie' then
            begin
              if Length(trim(XSearch))>0 then
                 wURL := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes/total?tipo=S&'+XOrder+'='+XSearch
              else
                 wURL := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes/total?tipo=S';
            end;
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumValidacoes.LoadFromJSON(JObj2);
         if not wmtNumValidacoes.Active then
            wmtNumValidacoes.Open;
         wnumvalidacoes := wmtNumValidacoes.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if UserSession.FTipoHelpValidacao='especie' then
            begin
              if Length(trim(XSearch))>0 then
                 wpaginacao := '?tipo=E&'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
              else
                 wpaginacao := '?tipo=E&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
            end
         else if UserSession.FTipoHelpValidacao='serie' then
            begin
              if Length(trim(XSearch))>0 then
                 wpaginacao := '?tipo=S&'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
              else
                 wpaginacao := '?tipo=S&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
            end;
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes'+wpaginacao;
       end
    else
       begin
         if UserSession.FTipoHelpValidacao='especie' then
            begin
              if Length(trim(XSearch))>0 then
                 wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes?tipo=E&'+XOrder+'='+XSearch
              else
                 wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes?tipo=E';
            end
         else if UserSession.FTipoHelpValidacao='serie' then
            begin
              if Length(trim(XSearch))>0 then
                 wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes?tipo=S&'+XOrder+'='+XSearch
              else
                 wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/validacoes?tipo=S';
            end;
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtValidacao.LoadFromJSON(JObj);
    if not wmtValidacao.Active then
       wmtValidacao.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtValidacao;
end;

function TContentListaValidacoesHelp.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,wnomecidade: string;
  ix,wtotal: Integer;
  wmtValidacao: TFDMemTable;
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
      0: worder  := 'abrevia';
      1: worder  := 'descricao';
    else
      worder := '';
    end;
    if ((wdraw=1) or (wsearch=''))  and (UserSession.FSerieNota<>'') then
       wsearch := UserSession.FSerieNota
    else if ((wdraw=1) or (wsearch=''))  and (UserSession.FEspecieNota<>'') then
       wsearch := UserSession.FEspecieNota;
    wmtValidacao := CarregaValidacoesDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtValidacao.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumvalidacoes)+', ' +
          '"recordsFiltered": '+inttostr(wnumvalidacoes)+', ' +
          '"data": [';
         while not wmtValidacao.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtValidacao.FieldByName('abrevia').asString+'", '+
                               '"'+wmtValidacao.FieldByName('descricao').asString+'", '+
                               '"<center><span class=\"fas fa-share\" align=\"middle\" title=\"Seleciona\" onclick=\"selecionaValidacao('+QuotedStr(wmtValidacao.FieldByName('id').asString)+','+QuotedStr(wmtValidacao.FieldByName('abrevia').asString)+');\"></span></center>" '+
                               '],';
           wmtValidacao.Next;
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
