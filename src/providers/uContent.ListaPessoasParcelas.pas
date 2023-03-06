unit uContent.ListaPessoasParcelas;

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
  TContentListaPessoasParcelas = class(TContentBase)
  private
    function CarregaPessoasParcelasDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaPessoasParcelas;
    wnumparcelas: integer;

{ TContentClientes }

constructor TContentListaPessoasParcelas.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaPessoasParcelas.CarregaPessoasParcelasDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao,werro: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumParcelas,wmtParcela: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini        := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumParcelas := TFDMemTable.Create(nil);
    wmtParcela     := TFDMemTable.Create(nil);

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
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/parcelas/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/parcelas/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumParcelas.LoadFromJSON(JObj2);
         if not wmtNumParcelas.Active then
            wmtNumParcelas.Open;
         wnumparcelas := wmtNumParcelas.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/parcelas'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/parcelas?'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/parcelas';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;

//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/localidades';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtParcela.LoadFromJSON(JObj);
    if not wmtParcela.Active then
       wmtParcela.Open;
  except
    On E: Exception do
    begin
      werro := E.Message;
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtParcela;
end;

function TContentListaPessoasParcelas.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,werro: string;
  ix,wtotal: Integer;
  wmtParcela: TFDMemTable;
  wdraw,wlength,wstart: integer;
  wemissao,wvencimento,woperacao: TDateTime;
begin
  try
    wdraw   := StrToIntDef(aRequest.QueryFields.Values['draw'],0);
    wlength := StrToIntDef(aRequest.QueryFields.Values['length'],0);
    wstart  := StrToIntDef(aRequest.QueryFields.Values['start'],0);
    wsearch      := aRequest.QueryFields.Values['search[value]'];
    wordercolumn := aRequest.QueryFields.Values['order[0][column]'];
    wdir         := aRequest.QueryFields.Values['order[0][dir]'];
    case wordercolumn.ToInteger of
      0: worder  := 'origem';
      1: worder  := 'numerodocumento';
      2: worder  := 'numparcela';
      3: worder  := 'prefixoorigem';
      4: worder  := 'tipooperacao';
      5: worder  := 'descricaopagamento';
      6: worder  := 'emissao';
      7: worder  := 'vencimento';
      8: worder  := 'operacao';
      9: worder  := 'valorfinal';
    else
      worder := '';
    end;
    wmtParcela := CarregaPessoasParcelasDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtParcela.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumparcelas)+', ' +
          '"recordsFiltered": '+inttostr(wnumparcelas)+', ' +
          '"data": [';
         while not wmtParcela.Eof do
         begin
           wemissao    := UserSession.RetornaData(wmtParcela.FieldByName('emissao').asString);
           wvencimento := UserSession.RetornaData(wmtParcela.FieldByName('vencimento').asString);
           woperacao   := UserSession.RetornaData(wmtParcela.FieldByName('operacao').asString);
           wresult := wresult + '['+
                               '"'+wmtParcela.FieldByName('origem').asString+'", '+
                               '"'+wmtParcela.FieldByName('numerodocumento').asString+'", '+
                               '"'+wmtParcela.FieldByName('numparcela').asString+'", '+
                               '"'+wmtParcela.FieldByName('prefixoorigem').asString+'", '+
                               '"'+wmtParcela.FieldByName('tipooperacao').asString+'", '+
                               '"'+wmtParcela.FieldByName('descricaopagamento').asString+'", '+
                               '"'+FormatDateTime('dd/mm/yyyy',wemissao)+'", '+
                               '"'+FormatDateTime('dd/mm/yyyy',wvencimento)+'", '+
                               '"'+FormatDateTime('dd/mm/yyyy',woperacao)+'", '+
                               '"'+FormatFloat('#,0.00',strtofloatdef(wmtParcela.FieldByName('valorfinal').asString,0))+'", '+
                               '"<center><span class=\"fas fa-share\" align=\"middle\" title=\"Seleciona\" onclick=\"selecionaParcela('+QuotedStr(wmtParcela.FieldByName('id').asString)+');\"></span></center>" '+
                               '],';
           wmtParcela.Next;
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
