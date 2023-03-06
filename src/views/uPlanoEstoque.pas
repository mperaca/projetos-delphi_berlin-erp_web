unit uPlanoEstoque;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl, System.JSON,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IWCompLabel, IniFiles,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,IWHTMLTag, IdAuthentication,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option, System.StrUtils,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt;

type
  TF_PlanoEstoque = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IWLabelProdutos: TIWLabel;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWEDITESTRUTURA: TIWEdit;
    IWEDITDESCRICAO: TIWEdit;
    IWEDITCATEGORIA: TIWEdit;
    IWLabelAtivo: TIWLabel;
    IWEDITATIVO: TIWEdit;
    IWLabelListaCategorias: TIWLabel;
    IWEDITIDCATEGORIA: TIWEdit;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITESTRUTURAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITDESCRICAOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITATIVOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCATEGORIAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    procedure MontaTabelaProdutos(XId: integer);
    procedure PopulaCamposPlanoEstoque(XId: integer);
    function ConfirmaPlanoEstoque(XId: integer): boolean;
    function IncluiPlanoEstoque: boolean;
    function ExcluiPlanoEstoque(XId: integer): boolean;
    procedure CarregaAtivo(XAtivo: boolean);
    procedure MontaGridPesquisaCategorias;
  public
  end;

implementation

uses DataSet.Serialize;

{$R *.dfm}


procedure TF_PlanoEstoque.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widplanoestoque,widcategoria: integer;
    wpagina,wcategoria: string;
begin
  if pos('[SelecionaCategoria]',IWEDITNOME.Text)>0 then
     begin
       widcategoria        := strtointdef(IWEDITIDCATEGORIA.Text,0);
       wcategoria          := copy(IWEDITNOME.Text,pos('[SelecionaCategoria]',IWEDITNOME.Text)+20,100);
       IWEDITCATEGORIA.Tag := widcategoria;
     end
  else if pos('[ExcluiPlanoEstoque]',IWEDITNOME.Text)>0 then
     begin
       widplanoestoque  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiPlanoEstoque]',IWEDITNOME.Text)+20,10);
       if ExcluiPlanoEstoque(widplanoestoque) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[RetornaProdutos]',IWEDITNOME.Text)>0 then
     begin
       widplanoestoque := strtointdef(IWEDITID.Text,0);
       MontaTabelaProdutos(widplanoestoque);
     end
  else if pos('[AlteraPlanoEstoque]',IWEDITNOME.Text)>0 then
     begin
       widplanoestoque  := strtointdef(IWEDITID.Text,0);
       PopulaCamposPlanoEstoque(widplanoestoque);
     end
  else if pos('[ConfirmaPlanoEstoque]',IWEDITNOME.Text)>0 then
     begin
       widplanoestoque  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ConfirmaPlanoEstoque]',IWEDITNOME.Text)+22,10);
       if widplanoestoque>0 then
          begin
            if ConfirmaPlanoEstoque(widplanoestoque) then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiPlanoEstoque then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[IncluiPlanoEstoque]',IWEDITNOME.Text)>0 then
     begin
       widplanoestoque        := 0;
       IWEDITESTRUTURA.Text   := '';
       IWEDITDESCRICAO.Text   := '';
       IWEDITATIVO.Text       := '';
       IWEDITCATEGORIA.Text   := '';
       IWEDITCATEGORIA.Tag    := 0;
       CarregaAtivo(true);
       IWEDITESTRUTURA.SetFocus;
     end
  else if pos('[CarregaCategorias]',IWEDITNOME.Text)>0 then
     begin
       MontaGridPesquisaCategorias;
     end;
end;

procedure TF_PlanoEstoque.MontaGridPesquisaCategorias;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    Jobj: TJSONArray;
    wmtCategoria: TFDMemTable;
    html: string;
begin
  try
    wmtCategoria                 := TFDMemTable.Create(nil);
    warqini                      := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
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
    // Get
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/categorias';
    wretjson := wIdHTTP.Get(URL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;
// Transforma o JSONArray em DataSet
    wmtCategoria.LoadFromJSON(JObj);
    if not wmtCategoria.Active then
       wmtCategoria.Open;
//Monta HTML
    html := '<table class="table table-hover table-striped table-sm">' +slinebreak+
            '    <thead class="thead-dark" style="font-size: 12px">' +slinebreak+
            '      <tr>' +slinebreak;
    html := html +'<th style="text-align: left; width: 92%">Nome Categoria</th>'+slinebreak;
    html := html +'<th style="text-align: center; width: 8%">Ação</th>'+slinebreak;
    html := html +'</tr></thead>'+slinebreak;
    html := html +'<tbody>'+slinebreak;

    wmtCategoria.First;
    while not wmtCategoria.EOF do
    begin
      html := html + '<tr>'+slinebreak;
      html := html + '<td nowrap style="font-size:12px; text-align: left">'+wmtCategoria.FieldByName('nome').AsString+'</td> '+slinebreak;
      html := html + '<td nowrap style="font-size:12px; text-align: center"><span class="fas fa-edit" align="middle" title="Altera" onclick="selecionaCategoria('+QuotedStr(wmtCategoria.FieldByName('id').AsString)+','+QuotedStr(wmtCategoria.FieldByName('nome').AsString)+')"></span></td>'+slinebreak;
      html := html + '</tr>'+slinebreak;
      wmtCategoria.Next;
    end;
    html := html +'</tbody></table>';
    IWLabelListaCategorias.Text := html;
  finally

  end;
end;

procedure TF_PlanoEstoque.IWEDITATIVOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Ativo" ');
end;

procedure TF_PlanoEstoque.IWEDITCATEGORIAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Categoria Plano de Estoque" ');
end;

procedure TF_PlanoEstoque.IWEDITESTRUTURAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Estrutura Plano de Estoque" ');
end;

procedure TF_PlanoEstoque.IWEDITDESCRICAOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Descrição Plano de Estoque" ');
end;

procedure TF_PlanoEstoque.MontaTabelaProdutos(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    Jobj: TJSONArray;
    wmtProduto: TFDMemTable;
    html: string;
begin
  try
    wmtProduto                   := TFDMemTable.Create(nil);
    warqini                      := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
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
    // Get
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/produtos?idestrutura='+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    JObj     := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;
// Transforma o JSONArray em DataSet
    wmtProduto.LoadFromJSON(JObj);
    if not wmtProduto.Active then
       wmtProduto.Open;
//Monta HTML
    html := '<table class="table table-hover table-striped table-sm">' +slinebreak+
            '    <thead class="thead-dark" style="font-size: 12px">' +slinebreak+
            '      <tr>' +slinebreak;
    html := html +'<th style="text-align: left; width: 10%">Código</th>'+slinebreak;
    html := html +'<th style="text-align: left; width: 75%">Descrição</th>'+slinebreak;
    html := html +'<th style="text-align: center; width: 5%">Und</th>'+slinebreak;
    html := html +'<th style="text-align: right; width: 10%">Preço</th>'+slinebreak;
//    html := html +'<th style="text-align: right; width: 5%">Ação</th>'+slinebreak;
    html := html +'</tr></thead>'+slinebreak;
    html := html +'<tbody>'+slinebreak;

    wmtProduto.First;
    while not wmtProduto.EOF do
    begin
      html := html + '<tr>'+slinebreak;
      html := html + '<td nowrap style="font-size:12px; text-align: left">'+wmtProduto.FieldByName('codigo').AsString+'</td> '+slinebreak;
      html := html + '<td nowrap style="font-size:12px; text-align: left">'+wmtProduto.FieldByName('descricao').AsString+'</td> '+slinebreak;
      html := html + '<td nowrap style="font-size:12px; text-align: center">'+wmtProduto.FieldByName('unidade').AsString+'</td> '+slinebreak;
      html := html + '<td nowrap style="font-size:12px; text-align: right">'+formatfloat('#,0.00',wmtProduto.FieldByName('preco1').AsFloat)+'</td> '+slinebreak;
      html := html + '</tr>'+slinebreak;
      wmtProduto.Next;
    end;
    html := html +'</tbody></table>';
    IWLabelProdutos.Text := html;
//    WebApplication.ShowMessage(inttostr(wmtProduto.RecordCount));
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao montar tabela de produtos'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_PlanoEstoque.PopulaCamposPlanoEstoque(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson: string;
    warqini: TIniFile;
    wjson: TJSONObject;
begin
  try
    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
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
    // Get
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques/'+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    IWEDITESTRUTURA.Text   := wjson.GetValue('estrutural').Value;
    IWEDITDESCRICAO.Text   := wjson.GetValue('nomeconta').Value;
    IWEDITATIVO.Text       := wjson.GetValue('ativo').Value;
    if strtointdef(wjson.GetValue('idcategoria').Value,0)>0 then
       begin
         IWEDITCATEGORIA.Text   := wjson.GetValue('xcategoria').Value;
         IWEDITCATEGORIA.Tag    := strtointdef(wjson.GetValue('idcategoria').Value,0);
       end
    else
       begin
         IWEDITCATEGORIA.Text   := '';
         IWEDITCATEGORIA.Tag    := 0;
       end;
    CarregaAtivo(strtobooldef(wjson.GetValue('ativo').Value,false));
    IWEDITESTRUTURA.SetFocus;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao popular campos dos planos de estoque'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_PlanoEstoque.CarregaAtivo(XAtivo: boolean);
var html: string;
begin
  try
     html := '<div class="custom-control custom-toggle custom-toggle-sm mb-1" style="margin-top: 35px">'+slinebreak+
                 IfThen(XAtivo,'<input type="checkbox" id="customToggle1" name="customToggle1" class="custom-control-input" checked="checked" >',
             '     <input type="checkbox" id="customToggle1" name="customToggle1" class="custom-control-input" >')+slinebreak+
             '     <label class="custom-control-label" for="customToggle1" style="font-size: 20px; font-weight: bold; color: #00bfff">Ativo</label>'+slinebreak+
             '</div>'+slinebreak;
     IWLabelAtivo.Text := html;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao carregar campo ativo'+slinebreak+E.Message);
    end;
  end;
end;

function TF_PlanoEstoque.ConfirmaPlanoEstoque(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wplanoestoque: TJSONObject;
begin
  try
    wplanoestoque := TJSONObject.Create;
    wplanoestoque.AddPair('estrutural',IWEDITESTRUTURA.Text);
    wplanoestoque.AddPair('nomeconta',IWEDITDESCRICAO.Text);
    wplanoestoque.AddPair('ativo',booltostr(IWEDITATIVO.Text='SIM'));
    wplanoestoque.AddPair('idcategoria',FormatFloat('0',IWEDITCATEGORIA.Tag));

    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
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

    wJsonToSend := TStringStream.Create(wplanoestoque.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);
    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao alterar plano de estoque'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_PlanoEstoque.IncluiPlanoEstoque: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wplanoestoque: TJSONObject;
begin
  try
    wplanoestoque := TJSONObject.Create;
    wplanoestoque.AddPair('estrutural',IWEDITESTRUTURA.Text);
    wplanoestoque.AddPair('nomeconta',IWEDITDESCRICAO.Text);
    wplanoestoque.AddPair('ativo',IWEDITATIVO.Text);

    warqini                      := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
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

    wJsonToSend := TStringStream.Create(wplanoestoque.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    wret        := true;
//    WebApplication.ShowMessage('Plano de Estoque incluído com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao incluir plano de estoque'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_PlanoEstoque.ExcluiPlanoEstoque(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL: string;
    warqini: TIniFile;
begin
  try
    warqini          := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
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
    // Delete
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/planoestoques/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao excluir plano de estoque'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

end.
