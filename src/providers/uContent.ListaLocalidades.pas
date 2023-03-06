unit uContent.ListaLocalidades;

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
  TContentListaLocalidades = class(TContentBase)
  private
    function CarregaLocalidadesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaLocalidades;
    wnumlocalidades: integer;

{ TContentClientes }

constructor TContentListaLocalidades.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaLocalidades.CarregaLocalidadesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumLocalidades,wmtLocalidade: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini           := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumLocalidades := TFDMemTable.Create(nil);
    wmtLocalidade     := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/localidades/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/localidades/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumLocalidades.LoadFromJSON(JObj2);
         if not wmtNumLocalidades.Active then
            wmtNumLocalidades.Open;
         wnumlocalidades := wmtNumLocalidades.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/localidades'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/localidades?'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/localidades';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtLocalidade.LoadFromJSON(JObj);
    if not wmtLocalidade.Active then
       wmtLocalidade.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtLocalidade;
end;

function TContentListaLocalidades.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder: string;
  ix,wtotal: Integer;
  wmtLocalidade: TFDMemTable;
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
      0: worder  := 'nome';
      1: worder  := 'uf';
      2: worder  := 'regiao';
      3: worder  := 'codibge';
    else
      worder := '';
    end;
// carrega a lista de atividades da TrabinAPI
    wmtLocalidade := CarregaLocalidadesDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtLocalidade.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumlocalidades)+', ' +
          '"recordsFiltered": '+inttostr(wnumlocalidades)+', ' +
          '"data": [';
         while not wmtLocalidade.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtLocalidade.FieldByName('nome').asString+'", '+
                               '"'+wmtLocalidade.FieldByName('uf').asString+'", '+
                               '"'+wmtLocalidade.FieldByName('regiao').asString+'", '+
                               '"'+wmtLocalidade.FieldByName('codibge').asString+'", '+
                               '"<center><span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"alteraLocalidade('+QuotedStr(wmtLocalidade.FieldByName('id').asString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiLocalidade('+QuotedStr(wmtLocalidade.FieldByName('id').asString)+','+QuotedStr(wmtLocalidade.FieldByName('nome').asString)+');\"></span></center>" '+
                               '],';
           wmtLocalidade.Next;
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
