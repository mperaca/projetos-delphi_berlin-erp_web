unit uContent.ListaNFePendentesParcelas;

interface

uses System.SysUtils, Classes, IW.Content.Base, HTTPApp, IWApplication, IW.HTTP.Request,
    IW.HTTP.Reply, System.StrUtils, IWCompMemo, IWHTMLTag, IWCompLabel, System.JSON,
    IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IWBaseForm,
    IdAuthentication,IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Rest.JSON, Data.DBXJSON, REST.Response.Adapter,
    FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
    Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,IniFiles;

type
  TContentListaNFePendentesParcelas = class(TContentBase)
  private
    function CarregaNFePendentesParcelasDaAPI: TFDMemTable;

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

var wcontent: TContentListaNFePendentesParcelas;
    warqini: TIniFile;

{ TContentClientes }

constructor TContentListaNFePendentesParcelas.Create;
begin
  inherited;
  mFileMustExist:=False;
  warqini:=TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
end;

function TContentListaNFePendentesParcelas.CarregaNFePendentesParcelasDaAPI: TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson: string;
    JObj: TJSONArray;
    wmtNFePendenteParcelas: TFDMemTable;
begin
  try


    wmtNFePendenteParcelas := TFDMemTable.Create(nil);

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
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/parcelas';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/parcelas';
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtNFePendenteParcelas.LoadFromJSON(JObj);
    if not wmtNFePendenteParcelas.Active then
       wmtNFePendenteParcelas.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtNFePendenteParcelas;
end;

function TContentListaNFePendentesParcelas.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wresult,wstring,wdescricao: string;
  wtotal: Integer;
  wmtNFePendenteParcelas: TFDMemTable;
begin
  try

// carrega a lista de itens da NFe da TrabinAPI
    wmtNFePendenteParcelas := CarregaNFePendentesParcelasDaAPI;

    if wmtNFePendenteParcelas.RecordCount>0 then
       begin
         wmtNFePendenteParcelas.First;
         wresult:='{'+
          '"draw": 20, ' +
          '"recordsTotal": '+inttostr(wmtNFePendenteParcelas.RecordCount)+', ' +
          '"recordsFiltered": '+inttostr(wmtNFePendenteParcelas.RecordCount)+', ' +
          '"data": [';
         while not wmtNFePendenteParcelas.Eof do
         begin
//           wdescricao := RetornaDescricao(wmtNFePendenteItens.FieldByName('descproduto').AsString);
//           wdescricao := trim(copy(StringReplace(wmtNFePendenteItens.FieldByName('descproduto').AsString,'''','',[]),1,80));
           wresult := wresult + '['+
                               '"'+wmtNFePendenteParcelas.FieldByName('numero').asString+'", '+
                               '"'+wmtNFePendenteParcelas.FieldByName('emissao').asString+'", '+
                               '"'+formatfloat('#,0.00',wmtNFePendenteParcelas.FieldByName('valor').AsFloat)+'", '+
                               '"'+wmtNFePendenteParcelas.FieldByName('vencimento').asString+'", '+
                               '"'+wmtNFePendenteParcelas.FieldByName('operacao').asString+'", '+
                               '"'+wmtNFePendenteParcelas.FieldByName('situacao').asString+'", '+
                               '"<center><span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"alteraParcela('+QuotedStr(wmtNFePendenteParcelas.FieldByName('id').AsString)+');\"></span></center>" '+
                               '],';
           wmtNFePendenteParcelas.Next;
         end;
         wresult := LeftStr(Trim(wresult),Length(Trim(wresult))-1) + ']}';
       end
    else
       begin
         wresult:='{'+
          '"draw": 20, ' +
          '"recordsTotal": 0, ' +
          '"recordsFiltered": 0, ' +
          '"data": []}';
       end;
    aReply.WriteString(wresult);
  except
    On E: Exception do
    begin
       ApplicationShowException(E);
    end;
  end;
  Result:=True;
end;

{function TContentListaNFePendentesItens.RetornaDescricao(XDescricao: string): string;
var ix: integer;
    wret: string;
begin
  wret := '';
  for ix := 1 to length(XDescricao) do
  begin
    if (ord(XDescricao[ix])<>34) and // '
       (ord(XDescricao[ix])<>39) and // "
       (ord(XDescricao[ix])<>239) then // ´
       wret := wret + XDescricao[ix];
  end;
  Result := wret;
end;}

end.
