unit uContent.ListaOrcamentos;

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
  TContentListaOrcamentos = class(TContentBase)
  private
    function CarregaOrcamentosDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset,XDraw: integer): TFDMemTable;

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

var wcontent: TContentListaOrcamentos;
    wnumorcamentos: integer;

{ TContentClientes }

constructor TContentListaOrcamentos.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaOrcamentos.CarregaOrcamentosDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset,XDraw: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao,werro: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumOrcamentos,wmtOrcamento: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini           := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumOrcamentos  := TFDMemTable.Create(nil);
    wmtOrcamento      := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/total'+ifthen(XSearch='','?dataemissao='+formatdatetime('dd/mm/yyyy',date)+'&','?')+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/total'+ifthen(XSearch='','?dataemissao='+formatdatetime('dd/mm/yyyy',date),'');
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumOrcamentos.LoadFromJSON(JObj2);
         if not wmtNumOrcamentos.Active then
            wmtNumOrcamentos.Open;
         wnumorcamentos := wmtNumOrcamentos.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := ifthen(XSearch='','?dataemissao='+formatdatetime('dd/mm/yyyy',date)+'&','?')+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := ifthen(XSearch='','?dataemissao='+formatdatetime('dd/mm/yyyy',date)+'&','?')+'limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos'+ifthen(XSearch='','?dataemissao='+formatdatetime('dd/mm/yyyy',date)+'&','?')+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos'+ifthen(XSearch='','?dataemissao='+formatdatetime('dd/mm/yyyy',date),'');
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtOrcamento.LoadFromJSON(JObj);
    if not wmtOrcamento.Active then
       wmtOrcamento.Open;
  except
    On E: Exception do
    begin
      werro := E.Message;
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtOrcamento;
end;

function TContentListaOrcamentos.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,werro: string;
  ix: Integer;
  wmtOrcamento: TFDMemTable;
  wdraw,wlength,wstart: integer;
  wtotal: double;
begin
  try
    wdraw   := StrToIntDef(aRequest.QueryFields.Values['draw'],0);
    wlength := StrToIntDef(aRequest.QueryFields.Values['length'],0);
    wstart  := StrToIntDef(aRequest.QueryFields.Values['start'],0);
    wsearch      := aRequest.QueryFields.Values['search[value]'];
    wordercolumn := aRequest.QueryFields.Values['order[0][column]'];
    wdir         := aRequest.QueryFields.Values['order[0][dir]'];
    case wordercolumn.ToInteger of
      0: worder  := 'numero';
      1: worder  := 'dataemissao';
      2: worder  := 'xcliente';
      3: worder  := 'xcondicao';
      4: worder  := 'xvendedor';
      5: worder  := 'total';
    else
      worder := '';
    end;
// carrega a lista de pessoas da TrabinAPI
    wmtOrcamento := CarregaOrcamentosDaAPI(wsearch,worder,wdir,wlength,wstart,wdraw);
    if wmtOrcamento.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumorcamentos)+', ' +
          '"recordsFiltered": '+inttostr(wnumorcamentos)+', ' +
          '"data": [';
         while not wmtOrcamento.Eof do
         begin
           if wmtOrcamento.FieldByName('total').IsNull then
              wtotal := 0
           else
              wtotal := wmtOrcamento.FieldByName('total').AsFloat;
           wresult := wresult + '['+
                               '"'+wmtOrcamento.FieldByName('numero').asString+'", '+
                               '"'+formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wmtOrcamento.FieldByName('dataemissao').AsString))+'", '+
                               '"'+wmtOrcamento.FieldByName('xcliente').asString+'", '+
                               '"'+wmtOrcamento.FieldByName('xcondicao').asString+'", '+
                               '"'+wmtOrcamento.FieldByName('xvendedor').asString+'", '+
                               '"'+formatfloat('#,0.00',wtotal)+'", '+
                               '"<center><span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"carregaOrcamento('+wmtOrcamento.FieldByName('id').asString+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiOrcamento('+QuotedStr(wmtOrcamento.FieldByName('id').asString)+','+QuotedStr(wmtOrcamento.FieldByName('numero').asString)+');\"></span></center>" '+
                               '],';
           wmtOrcamento.Next;
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
