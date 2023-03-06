unit uContent.ListaAtividades;

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
  TContentListaAtividades = class(TContentBase)
  private
    function CarregaAtividadesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaAtividades;
    wnumatividades: integer;

{ TContentClientes }

constructor TContentListaAtividades.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaAtividades.CarregaAtividadesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wpaginacao,wURL,wretjson,werro: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wcta: integer;
    wmtNumAtividades,wmtAtividade: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumAtividades := TFDMemTable.Create(nil);
    wmtAtividade     := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/atividades/total?nome='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/atividades/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumAtividades.LoadFromJSON(JObj2);
         if not wmtNumAtividades.Active then
            wmtNumAtividades.Open;
         wnumatividades := wmtNumAtividades.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?nome='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL          := warqini.ReadString('Geral','URL','')+'/cadastros/atividades'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL       := warqini.ReadString('Geral','URL','')+'/cadastros/atividades?nome='+XSearch
         else
            wURL       := warqini.ReadString('Geral','URL','')+'/cadastros/atividades';
         if Length(trim(XOrder))>0 then
            wURL       := wURL+'&order='+XOrder+'&dir='+XDir;
       end;
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtAtividade.LoadFromJSON(JObj);
    if not wmtAtividade.Active then
       wmtAtividade.Open;

    wcta := wmtAtividade.RecordCount;
  except
    On E: Exception do
    begin
      werro := E.Message;
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtAtividade;
end;

function TContentListaAtividades.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wresult,wstring,wsearch,wordercolumn,worder,wdir: string;
  wtotal: Integer;
  wmtAtividade: TFDMemTable;
  wdraw,wlength,wstart,ix: integer;
begin
  try
    wdraw        := StrToIntDef(aRequest.QueryFields.Values['draw'],0);
    wlength      := StrToIntDef(aRequest.QueryFields.Values['length'],0);
    wstart       := StrToIntDef(aRequest.QueryFields.Values['start'],0);
    wsearch      := aRequest.QueryFields.Values['search[value]'];
    wordercolumn := aRequest.QueryFields.Values['order[0][column]'];
    wdir         := aRequest.QueryFields.Values['order[0][dir]'];
    case wordercolumn.ToInteger of
      0: worder  := 'NomeAtividade';
    else
      worder := '';
    end;

// carrega a lista de atividades da TrabinAPI
    wmtAtividade := CarregaAtividadesDaAPI(wsearch,worder,wdir,wlength,wstart);

    if wmtAtividade.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumatividades)+', ' +
          '"recordsFiltered": '+inttostr(wnumatividades)+', ' +
          '"data": [';
         while not wmtAtividade.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtAtividade.FieldByName('nome').asString+'", '+
                               '"<center><span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"alteraAtividade('+QuotedStr(wmtAtividade.FieldByName('id').AsString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiAtividade('+QuotedStr(wmtAtividade.FieldByName('id').AsString)+','+QuotedStr(wmtAtividade.FieldByName('nome').AsString)+');\"></span></center>" '+
                               '],';
           wmtAtividade.Next;
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
//       ApplicationShowException(E);
    end;
  end;
  Result:=True;
end;

end.
