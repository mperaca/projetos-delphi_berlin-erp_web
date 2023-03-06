unit uContent.ListaRepresentantesHelp;

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
  TContentListaRepresentantesHelp = class(TContentBase)
  private
    function CarregaRepresentantesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaRepresentantesHelp;
    wnumrepresentantes: integer;

{ TContentClientes }

constructor TContentListaRepresentantesHelp.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaRepresentantesHelp.CarregaRepresentantesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumRepresentantes,wmtRepresentante: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini              := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumRepresentantes := TFDMemTable.Create(nil);
    wmtRepresentante     := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/total?ehrepresentante=true&'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/total?ehrepresentante=true';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumRepresentantes.LoadFromJSON(JObj2);
         if not wmtNumRepresentantes.Active then
            wmtNumRepresentantes.Open;
         wnumrepresentantes := wmtNumRepresentantes.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?ehrepresentante=true&'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?ehrepresentante=true&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas?ehrepresentante=true&'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas?ehrepresentante=true';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtRepresentante.LoadFromJSON(JObj);
    if not wmtRepresentante.Active then
       wmtRepresentante.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtRepresentante;
end;

function TContentListaRepresentantesHelp.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,wnomecidade: string;
  ix,wtotal: Integer;
  wmtRepresentante: TFDMemTable;
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
      1: worder  := 'codigo';
      2: worder  := 'cpf';
      3: worder  := 'rg';
      4: worder  := 'cnpj';
    else
      worder := '';
    end;
    if ((wdraw=1) or (wsearch=''))  and (UserSession.FRepresentante<>'') then
       wsearch := UserSession.FRepresentante
    else if ((wdraw=1) or (wsearch=''))  and (UserSession.FVendedorOrcamento<>'') then
       wsearch := UserSession.FVendedorOrcamento
    else if ((wdraw=1) or (wsearch=''))  and (UserSession.FVendedorNota<>'') then
       wsearch := UserSession.FVendedorNota;
    wmtRepresentante := CarregaRepresentantesDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtRepresentante.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumrepresentantes)+', ' +
          '"recordsFiltered": '+inttostr(wnumrepresentantes)+', ' +
          '"data": [';
         while not wmtRepresentante.Eof do
         begin
           wresult := wresult + '['+
                               '"'+wmtRepresentante.FieldByName('nome').asString+'", '+
                               '"'+wmtRepresentante.FieldByName('codigo').asString+'", '+
                               '"'+wmtRepresentante.FieldByName('cpf').asString+'", '+
                               '"'+wmtRepresentante.FieldByName('rg').asString+'", '+
                               '"'+wmtRepresentante.FieldByName('cnpj').asString+'", '+
                               '"<center><span class=\"fas fa-share\" align=\"middle\" title=\"Seleciona\" onclick=\"selecionaRepresentante('+QuotedStr(wmtRepresentante.FieldByName('id').asString)+','+QuotedStr(wmtRepresentante.FieldByName('nome').asString)+');\"></span></center>" '+
                               '],';
           wmtRepresentante.Next;
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
