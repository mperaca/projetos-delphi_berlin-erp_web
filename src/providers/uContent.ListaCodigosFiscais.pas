unit uContent.ListaCodigosFiscais;

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
  TContentListaCodigosFiscais = class(TContentBase)
  private
    function CarregaCodigosFiscaisDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaCodigosFiscais;
    wnumcodigosfiscais: integer;

{ TContentClientes }

constructor TContentListaCodigosFiscais.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaCodigosFiscais.CarregaCodigosFiscaisDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumCodigosFiscais,wmtCodigoFiscal: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini              := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumCodigosFiscais := TFDMemTable.Create(nil);
    wmtCodigoFiscal      := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumCodigosFiscais.LoadFromJSON(JObj2);
         if not wmtNumCodigosFiscais.Active then
            wmtNumCodigosFiscais.Open;
         wnumcodigosfiscais := wmtNumCodigosFiscais.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais?'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/codigosfiscais';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtCodigoFiscal.LoadFromJSON(JObj);
    if not wmtCodigoFiscal.Active then
       wmtCodigoFiscal.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtCodigoFiscal;
end;

function TContentListaCodigosFiscais.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder: string;
  ix,wtotal: Integer;
  wmtCodigoFiscal: TFDMemTable;
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
      0: worder  := 'codigo';
      1: worder  := 'digito';
      2: worder  := 'natureza';
      3: worder  := 'abrevia';
      4: worder  := 'incideicms';
      5: worder  := 'incideipi';
      6: worder  := 'incideirt';
      7: worder  := 'incidepis';
      8: worder  := 'incidecofins';
      9: worder  := 'compoevenda';
    else
      worder := '';
    end;
// carrega a lista de atividades da TrabinAPI
    wmtCodigoFiscal := CarregaCodigosFiscaisDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtCodigoFiscal.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumcodigosfiscais)+', ' +
          '"recordsFiltered": '+inttostr(wnumcodigosfiscais)+', ' +
          '"data": [';
         while not wmtCodigoFiscal.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtCodigoFiscal.FieldByName('codigo').asString+'", '+
                               '"'+wmtCodigoFiscal.FieldByName('digito').asString+'", '+
                               '"'+wmtCodigoFiscal.FieldByName('natureza').asString+'", '+
                               '"'+wmtCodigoFiscal.FieldByName('abrevia').asString+'", '+
                               '"<center>'+IfThen(wmtCodigoFiscal.FieldByName('incideicms').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center>'+IfThen(wmtCodigoFiscal.FieldByName('incideipi').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center>'+IfThen(wmtCodigoFiscal.FieldByName('incideirt').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center>'+IfThen(wmtCodigoFiscal.FieldByName('incidepis').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center>'+IfThen(wmtCodigoFiscal.FieldByName('incidecofins').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center>'+IfThen(wmtCodigoFiscal.FieldByName('compoevenda').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center><span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"alteraCodigoFiscal('+QuotedStr(wmtCodigoFiscal.FieldByName('id').asString)+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiCodigoFiscal('+QuotedStr(wmtCodigoFiscal.FieldByName('id').asString)+','+QuotedStr(wmtCodigoFiscal.FieldByName('codigo').asString)+');\"></span></center>" '+
                               '],';
           wmtCodigoFiscal.Next;
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
