unit uContent.ListaPlanoEstoques;

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
  TContentListaPlanoEstoques = class(TContentBase)
  private
    function CarregaPlanoEstoquesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;

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

var wcontent: TContentListaPlanoEstoques;
    wnumplanoestoques: integer;

{ TContentClientes }

constructor TContentListaPlanoEstoques.Create;
begin
  inherited;
  mFileMustExist:=False;
end;

function TContentListaPlanoEstoques.CarregaPlanoEstoquesDaAPI(XSearch,XOrder,XDir: string; XLimit,XOffset: integer): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretjson,wpaginacao: string;
    JObj: TJSONArray;
    JObj2: TJSONObject;
    wmtNumPlanoEstoques,wmtPlanoEstoque: TFDMemTable;
    warqini: TIniFile;
begin
  try
    warqini             := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
    wmtNumPlanoEstoques := TFDMemTable.Create(nil);
    wmtPlanoEstoque     := TFDMemTable.Create(nil);

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
                          
    wIdHTTP.Request.CustomHeaders.Clear;
    wIdHTTP.Request.ContentType  := 'utf-8';
//    wIdHTTP.Request.CustomHeaders.AddValue('Content-Type','application/json');
    wIdHTTP.Request.CustomHeaders.AddValue('idempresa','77222');

    wIdHTTP.Response.ContentType := 'application/json';
    wIdHTTP.Response.CharSet     := 'UTF-8';

    if XOffset=0 then // primeira pesquisa
       begin
         if Length(trim(XSearch))>0 then
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques/total?'+XOrder+'='+XSearch
         else
            wURL := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques/total';
         wretjson := wIdHTTP.Get(wURL);
         JObj2    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
         // Transforma o JSONArray em DataSet
         wmtNumPlanoEstoques.LoadFromJSON(JObj2);
         if not wmtNumPlanoEstoques.Active then
            wmtNumPlanoEstoques.Open;
         wnumplanoestoques := wmtNumPlanoEstoques.FieldByName('registros').AsInteger;
       end;

    if XLimit>0 then
       begin
         if Length(trim(XSearch))>0 then
            wpaginacao := '?'+XOrder+'='+XSearch+'&limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset)
         else
            wpaginacao := '?limit='+inttostr(XLimit)+'&offset='+inttostr(XOffset);
         if Length(trim(XOrder))>0 then
            wpaginacao := wpaginacao+'&order='+XOrder+'&dir='+XDir;
         wURL := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques'+wpaginacao;
       end
    else
       begin
         if Length(trim(XSearch))>0 then
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques?'+XOrder+'='+XSearch
         else
            wURL  := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques';
         if Length(trim(XOrder))>0 then
            wURL  := wURL+'&order='+XOrder+'&dir='+XDir;
       end;
    wretjson := wIdHTTP.Get(wURL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtPlanoEstoque.LoadFromJSON(JObj);
    if not wmtPlanoEstoque.Active then
       wmtPlanoEstoque.Open;
  except
    On E: Exception do
    begin
//       ApplicationShowException(E);
    end;
  end;
  Result := wmtPlanoEstoque;
end;

function TContentListaPlanoEstoques.Execute(aRequest: THttpRequest; aReply: THttpReply;
  const aPathname: string; aSession: TIWApplication): boolean;
var
  wtext,wvalue,wresult,wstring,wsearch,wordercolumn,wdir,worder,wnomeconta: string;
  ix,wtotal: Integer;
  wmtPlanoEstoque: TFDMemTable;
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
      0: worder  := 'estrutural';
      1: worder  := 'nomeconta';
      2: worder  := 'xqtdeproduto';
      3: worder  := 'xcategoria';
      4: worder  := 'ativo';
    else
      worder := '';
    end;
// carrega a lista de planos de estoques da TrabinAPI
    wmtPlanoEstoque := CarregaPlanoEstoquesDaAPI(wsearch,worder,wdir,wlength,wstart);
    if wmtPlanoEstoque.RecordCount>0 then
       begin
         wresult:='{'+
          '"draw": '+inttostr(wdraw)+', ' +
          '"recordsTotal": '+inttostr(wnumplanoestoques)+', ' +
          '"recordsFiltered": '+inttostr(wnumplanoestoques)+', ' +
          '"data": [';
         while not wmtPlanoEstoque.Eof do
         begin
           wnomeconta := trim(StringReplace(wmtPlanoEstoque.FieldByName('nomeconta').asString,'"','',[]));
           wnomeconta := trim(StringReplace(wnomeconta,'\\','//',[]));
           wnomeconta := trim(StringReplace(wnomeconta,'\','/',[]));
           wresult := wresult + '['+
                               '"'+wmtPlanoEstoque.FieldByName('estrutural').asString+'", '+
                               '"'+wnomeconta+'", '+
                               '"<center>'+wmtPlanoEstoque.FieldByName('xqtdeproduto').asString+'</center>", '+
                               '"'+wmtPlanoEstoque.FieldByName('xcategoria').asString+'", '+
                               '"<center>'+IfThen(wmtPlanoEstoque.FieldByName('ativo').AsBoolean,'<i class=\"fa fa-check-circle\" aria-hidden=\"true\">','<i class=\"fa fa-circle-o\" aria-hidden=\"true\">')+'</i><center>", '+
                               '"<center><span class=\"fa fa-gift\" align=\"middle\" title=\"Produtos\" onclick=\"retornaProdutos('+QuotedStr(wmtPlanoEstoque.FieldByName('id').asString)+','+QuotedStr(wmtPlanoEstoque.FieldByName('estrutural').asString)+','+QuotedStr(wmtPlanoEstoque.FieldByName('nomeconta').asString)+','+wmtPlanoEstoque.FieldByName('xqtdeproduto').asString+');\">'+
                               '</span>&nbsp&nbsp<span class=\"fas fa-edit\" align=\"middle\" title=\"Altera\" onclick=\"alteraPlanoEstoque('+QuotedStr(wmtPlanoEstoque.FieldByName('id').asString)+');\"> '+
                               '</span>&nbsp&nbsp<span class=\"fas fa-trash\" align=\"middle\" title=\"Exclui\" onclick=\"excluiPlanoEstoque('+QuotedStr(wmtPlanoEstoque.FieldByName('id').asString)+','+QuotedStr(wmtPlanoEstoque.FieldByName('estrutural').asString)+');\"></span></center>" '+
                               '],';
           wmtPlanoEstoque.Next;
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
