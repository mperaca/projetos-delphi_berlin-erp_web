unit uCriaNota;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout, IdAuthentication,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl, IWBaseControl,IWHTMLTag,
  IWBaseHTMLControl, IWControl, IWCompEdit, IWCompButton, IdIOHandler, System.JSON,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IWCompLabel, IniFiles;

type
  TF_CriaNota = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWEditNumeroPedido: TIWEdit;
    IWEditDataEmissao: TIWEdit;
    IWEditSubTotal: TIWEdit;
    IWEditTotal: TIWEdit;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWLabelListaClientes: TIWLabel;
    IWEditCliente: TIWEdit;
    IWEditCondicao: TIWEdit;
    IWLabelListaCondicoes: TIWLabel;
    IWEditVendedor: TIWEdit;
    IWLabelListaVendedores: TIWLabel;
    IWEditCobranca: TIWEdit;
    IWLabelListaCobrancas: TIWLabel;
    IWEditCodProduto: TIWEdit;
    IWEditDescProduto: TIWEdit;
    IWEditUnitario: TIWEdit;
    IWEditQuantidade: TIWEdit;
    IWEditTotalItem: TIWEdit;
    IWLabelListaProdutos: TIWLabel;
    IWEditBaseICMS: TIWEdit;
    IWEditTotalICMS: TIWEdit;
    IWEditBaseST: TIWEdit;
    IWEditTotalST: TIWEdit;
    IWEditTotalIPI: TIWEdit;
    IWEditTotalPIS: TIWEdit;
    IWEditTotalCOFINS: TIWEdit;
    IWEditTotalDescontos: TIWEdit;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEditClienteHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditClienteAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWEditCondicaoHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditCondicaoAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWEditNumeroPedidoHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditVendedorAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWEditVendedorHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditCobrancaAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWEditCobrancaHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditCodProdutoHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditCodProdutoAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWEditDescProdutoAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
  private
    FProdutos: TFDMemTable;
    FNumItem: integer;

    procedure IniciaNota;
    procedure ConfirmaNota;
    procedure CancelaNota;
    function RetornaUltimoPedidoVenda: integer;
    procedure LimpaCampos;
    function LocalizaCliente(XCliente: string): TFDMemTable;
    procedure MontaGridPesquisaCliente(XQueryCliente: TFDMemTable);
    function RetornaFiltroPesquisa(XCliente: string): string;
    procedure MontaGridPesquisaCondicao(XQueryCondicao: TFDMemTable);
    function LocalizaCondicao(XCondicao: string): TFDMemTable;
    function LocalizaVendedor(XVendedor: string): TFDMemTable;
    procedure MontaGridPesquisaVendedor(XQueryVendedor: TFDMemTable);
    function LocalizaCobranca(XCobranca: string): TFDMemTable;
    procedure MontaGridPesquisaCobranca(XQueryCobranca: TFDMemTable);
    function GravaNotaNaAPI: boolean;
    function GravaItemNaAPI: boolean;
    function LocalizaProduto(XFiltro, XProduto: string): TFDMemTable;
    procedure MontaGridPesquisaProduto(XQueryProduto: TFDMemTable);
    procedure LimpaCamposItens;
    procedure ConfirmaItem;
    function ExcluiItemDaAPI(XIdItem: integer): boolean;
    procedure CarregaTotaisNota;
    procedure GravaParcelasNaAPI;
    procedure GravaImpostosItem(XIdItem: integer);
  public
  end;

implementation

uses DataSet.Serialize, ServerController, UserSessionUnit;

{$R *.dfm}

var warqini: TIniFile;


procedure TF_CriaNota.IWAppFormCreate(Sender: TObject);
begin
  ServerController.UserSession.FIdNFePendente := 0;
  FNumItem := 0;
  warqini := TIniFile.Create(GetCurrentDir+'\TrabinWeb.ini');
end;

procedure TF_CriaNota.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widcliente,widcondicao,widvendedor,widcobranca,widproduto,widitem,wcta: integer;
    wnomecliente,wdescricaocondicao,wnomevendedor,wnomecobranca,wcodproduto: string;
begin
  if pos('[IniciaNota]',IWEDITNOME.Text)>0 then
     begin
       IniciaNota;
     end
  else if pos('[Confirma]',IWEDITNOME.Text)>0 then
     begin
       ConfirmaNota;
     end
  else if pos('[Cancela]',IWEDITNOME.Text)>0 then
     begin
       CancelaNota;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(20);'); // carrega lista
     end
  else if pos('[ConfirmaItem]',IWEDITNOME.Text)>0 then
     begin
       ConfirmaItem;
     end
  else if pos('[ChamaNotaItem]',IWEDITNOME.Text)>0 then
     begin
       LimpaCamposItens;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#ModalNotaItem").modal({backdrop: "static"});');
       IWEditCodProduto.SetFocus;
     end
  else if pos('[ChamaParcela]',IWEDITNOME.Text)>0 then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaParcelas(20);'); // carrega lista
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#ModalNotaParcela").modal({backdrop: "static"});');
     end
  else if pos('[ExcluiItem]',IWEDITNOME.Text)>0 then
     begin
       widitem  := strtointdef(IWEDITID.Text,0);
       if not ExcluiItemDaAPI(widitem) then
          WebApplication.ShowMessage('Ítem não excluído da API');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(20);'); // carrega lista
     end
  else if pos('[SelecionaCliente]',IWEDITNOME.Text)>0 then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacliente").hide();'); // fecha lista
       widcliente   := strtointdef(IWEDITID.Text,0);
       wnomecliente := copy(IWEDITNOME.Text,pos('[SelecionaCliente]',IWEDITNOME.Text)+18,100);
       IWEditCliente.Text := wnomecliente;
     end
  else if pos('[SelecionaCondicao]',IWEDITNOME.Text)>0 then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").hide();'); // fecha lista
       widcondicao         := strtointdef(IWEDITID.Text,0);
       wdescricaocondicao  := copy(IWEDITNOME.Text,pos('[SelecionaCondicao]',IWEDITNOME.Text)+19,100);
       IWEditCondicao.Text := wdescricaocondicao;
     end
  else if pos('[SelecionaVendedor]',IWEDITNOME.Text)>0 then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listavendedor").hide();'); // fecha lista
       widvendedor         := strtointdef(IWEDITID.Text,0);
       wnomevendedor       := copy(IWEDITNOME.Text,pos('[SelecionaVendedor]',IWEDITNOME.Text)+19,100);
       IWEditVendedor.Text := wnomevendedor;
     end
  else if pos('[SelecionaCobranca]',IWEDITNOME.Text)>0 then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").hide();'); // fecha lista
       widcobranca         := strtointdef(IWEDITID.Text,0);
       wnomecobranca       := copy(IWEDITNOME.Text,pos('[SelecionaCobranca]',IWEDITNOME.Text)+19,100);
       IWEditCobranca.Text := wnomecobranca;
     end
  else if pos('[SelecionaProduto]',IWEDITNOME.Text)>0 then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").hide();'); // fecha lista
       widproduto             := strtointdef(IWEDITID.Text,0);
       wcta := FProdutos.RecordCount;
       FProdutos.Filtered     := false;
       FProdutos.Filter       := 'id = '+IWEDITID.Text;
       FProdutos.Filtered     := true;
       wcta := FProdutos.RecordCount;
       wcodproduto            := copy(IWEDITNOME.Text,pos('[SelecionaProduto]',IWEDITNOME.Text)+18,100);
       IWEditCodProduto.Text  := FProdutos.FieldByName('codigo').AsString;
       IWEditDescProduto.Text := FProdutos.FieldByName('descricao').AsString;
       IWEditQuantidade.Text  := '1,000';
       IWEditUnitario.Text    := formatfloat('#,0.00',strtofloat(FProdutos.FieldByName('preco').AsString));
       IWEditTotalItem.Text   := formatfloat('#,0.00',strtofloat(FProdutos.FieldByName('preco').AsString));
     end;
end;

procedure TF_CriaNota.IWEditClienteAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
    wclientes: TFDMemTable;
begin
  try
    wchar := EventParams.Strings[7];
    if (wchar='which=13') then
       begin
         wclientes := LocalizaCliente(IWEditCliente.Text);
         if wclientes.RecordCount=1 then
            begin
              IWEditCliente.Text := wclientes.FieldByName('nome').AsString;
              IWBUTTONACAO.OnAsyncClick(Sender,nil);
            end
         else if wclientes.RecordCount>1 then
            begin
              MontaGridPesquisaCliente(wclientes);
            end
         else
            begin
              WebApplication.ShowMessage('Cliente não localizado');
            end;
       end
    else
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacliente").hide();'); // fecha lista
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage(E.Message);
    end;
  end;
end;

procedure TF_CriaNota.IWEditClienteHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Digite nome/cpf/cnpj do cliente" ');
end;

procedure TF_CriaNota.IWEditCobrancaAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
    wcobrancas: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if (wchar='which=13') then // tecla ENTER
     begin
       wcobrancas := LocalizaCobranca(IWEditCobranca.Text);
       if wcobrancas.RecordCount=1 then
          begin
            IWEditCobranca.Text := wcobrancas.FieldByName('nome').AsString;
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").hide();'); // fecha lista
          end
       else if wcobrancas.RecordCount>1 then
          begin
            MontaGridPesquisaCobranca(wcobrancas);
          end
       else
          begin
            WebApplication.ShowMessage('Cobrança não localizada');
          end;
     end
  else
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").hide();'); // fecha lista
end;

procedure TF_CriaNota.IWEditCobrancaHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Digite nome cobrança" ');
end;

procedure TF_CriaNota.IWEditCodProdutoAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
//    wprodutos: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if (wchar='which=13') then
     begin
       FProdutos := LocalizaProduto('codigo',IWEditCodProduto.Text);
       if FProdutos.RecordCount=1 then
          begin
            IWEditCodProduto.Text  := FProdutos.FieldByName('codigo').AsString;
            IWEditDescProduto.Text := FProdutos.FieldByName('descricao').AsString;
            IWEditUnitario.Text    := FProdutos.FieldByName('preco').AsString;
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").hide();'); // fecha lista
          end
       else if FProdutos.RecordCount>1 then
          begin
            MontaGridPesquisaProduto(FProdutos);
          end
       else
          begin
            WebApplication.ShowMessage('Produto não localizado');
          end;
     end
  else
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").hide();'); // fecha lista
end;

procedure TF_CriaNota.IWEditCodProdutoHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off"');
end;

procedure TF_CriaNota.IWEditCondicaoAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
    wcondicoes: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if (wchar='which=13') then // tecla ENTER
     begin
       wcondicoes := LocalizaCondicao(IWEditCondicao.Text);
       if wcondicoes.RecordCount=1 then
          begin
            IWEditCondicao.Text := wcondicoes.FieldByName('descricao').AsString;
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").hide();'); // fecha lista
//            IWBUTTONACAO.OnAsyncClick(Sender,nil);
          end
       else if wcondicoes.RecordCount>1 then
          begin
            MontaGridPesquisaCondicao(wcondicoes);
          end
       else
          begin
            WebApplication.ShowMessage('Condição não localizada');
          end;
     end
  else
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").hide();'); // fecha lista
end;

procedure TF_CriaNota.IWEditCondicaoHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Digite nome condição" ');
end;

procedure TF_CriaNota.IWEditDescProdutoAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
    wprodutos: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if (wchar='which=13') then
     begin
       wprodutos := LocalizaProduto('descricao',IWEditDescProduto.Text);
       if wprodutos.RecordCount=1 then
          begin
            IWEditCodProduto.Text  := wprodutos.FieldByName('codigo').AsString;
            IWEditDescProduto.Text := wprodutos.FieldByName('descricao').AsString;
            IWEditUnitario.Text    := wprodutos.FieldByName('preco').AsString;
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").hide();'); // fecha lista
          end
       else if wprodutos.RecordCount>1 then
          begin
            MontaGridPesquisaProduto(wprodutos);
          end
       else
          begin
            WebApplication.ShowMessage('Produto não localizado');
          end;
     end
  else
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").hide();'); // fecha lista
end;

procedure TF_CriaNota.IWEditNumeroPedidoHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" ');
end;

procedure TF_CriaNota.IWEditVendedorAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
    wvendedores: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if (wchar='which=13') then
     begin
       wvendedores := LocalizaVendedor(IWEditVendedor.Text);
       if wvendedores.RecordCount=1 then
          begin
            IWEditVendedor.Text := wvendedores.FieldByName('nome').AsString;
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listavendedor").hide();'); // fecha lista
          end
       else if wvendedores.RecordCount>1 then
          begin
            MontaGridPesquisaVendedor(wvendedores);
          end
       else
          begin
            WebApplication.ShowMessage('Vendedor não localizado');
          end;
     end
  else
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listavendedor").hide();'); // fecha lista
end;

procedure TF_CriaNota.IWEditVendedorHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Digite nome/cpf/cnpj do vendedor" ');
end;

procedure TF_CriaNota.IniciaNota;
var wnumped: integer;
begin
  ServerController.UserSession.FIdNFePendente := 0;
  LimpaCampos;
  LimpaCamposItens;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(20);'); // carrega lista
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#IWBUTTONCRIAITEM").attr("disabled",true);');
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#IWBUTTONCRIAPARCELA").attr("disabled",true);');

  wnumped := RetornaUltimoPedidoVenda;

  IWEditDataEmissao.Text  := formatdatetime('dd/mm/yyyy',now);
  IWEditSubTotal.Text     := '0,00';
  IWEditTotal.Text        := '0,00';
  IWEditNumeroPedido.Text := formatfloat('0000',wnumped);

  IWEditCliente.Enabled   := true;
  IWEditCondicao.Enabled  := true;
  IWEditVendedor.Enabled  := true;
  IWEditCobranca.Enabled  := true;
  IWEditCliente.SetFocus;
end;

procedure TF_CriaNota.ConfirmaNota;
begin
  if not GravaNotaNaAPI then
     begin
       WebApplication.ShowMessage('Nfe não gravada na API');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end
  else
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#IWBUTTONCRIAITEM").attr("disabled",false);');
     end;

//  LimpaCampos;
end;

procedure TF_CriaNota.ConfirmaItem;
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalNotaItem'').modal(''hide'');');
  if not GravaItemNaAPI then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
       WebApplication.ShowMessage('Ítem não gravado na API');
     end
  else
     begin
       CarregaTotaisNota;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end;

  WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(20);'); // carrega lista
//  LimpaCampos;
end;

procedure TF_CriaNota.CarregaTotaisNota;
var wret: integer;
    wURL,wjsonret: string;
    wjson: TJSONObject;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente);
    wjsonret := IdHTTP1.Get(wURL);
    wjson    := TJSONObject.ParseJSONValue(wjsonret) as TJSONObject;

    IWEditTotal.Text       := formatfloat('#,0.00',strtofloat(wjson.GetValue('total').Value));
    IWEditSubTotal.Text    := formatfloat('#,0.00',strtofloat(wjson.GetValue('subtotal').Value));
    IWEditBaseICMS.Text    := formatfloat('#,0.00',strtofloat(wjson.GetValue('baseicms').Value));
    IWEditBaseST.Text      := formatfloat('#,0.00',strtofloat(wjson.GetValue('basest').Value));
    IWEditTotalICMS.Text   := formatfloat('#,0.00',strtofloat(wjson.GetValue('totalicms').Value));
    IWEditTotalST.Text     := formatfloat('#,0.00',strtofloat(wjson.GetValue('totalst').Value));
    IWEditTotalIPI.Text    := formatfloat('#,0.00',strtofloat(wjson.GetValue('totalipi').Value));
    IWEditTotalPIS.Text    := formatfloat('#,0.00',strtofloat(wjson.GetValue('totalpis').Value));
    IWEditTotalCOFINS.Text := formatfloat('#,0.00',strtofloat(wjson.GetValue('totalcofins').Value));
    IWEditTotalDescontos.Text := '0,00';

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao retornar totais da NFe '+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_CriaNota.CancelaNota;
begin
  LimpaCampos;
  LimpaCamposItens;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#IWBUTTONCRIAITEM").attr("disabled",true);');
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#IWBUTTONCRIAPARCELA").attr("disabled",true);');
end;

function TF_CriaNota.RetornaUltimoPedidoVenda: integer;
var wret: integer;
    wURL,wjsonret: string;
    wjson: TJSONObject;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/sequencias/ultimopedidovenda';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/sequencias/ultimopedidovenda';
    wjsonret := IdHTTP1.Get(wURL);
    wjson    := TJSONObject.ParseJSONValue(wjsonret) as TJSONObject;
    wret     := StrToIntDef(wjson.GetValue('ultped').Value,1);
  except
    On E: Exception do
    begin
      wret := 0;
      WebApplication.ShowMessage('Erro ao retornar sequence '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

// Limpa campos editáveis
procedure TF_CriaNota.LimpaCampos;
begin
  FNumItem := 0;
  ServerController.UserSession.FIdNFePendente := 0;

  IWEditDataEmissao.Text  := '';
  IWEditTotal.Text        := '';
  IWEditSubTotal.Text    := '';
  IWEditBaseICMS.Text    := '';
  IWEditBaseST.Text      := '';
  IWEditTotalICMS.Text   := '';
  IWEditTotalST.Text     := '';
  IWEditTotalIPI.Text    := '';
  IWEditTotalPIS.Text    := '';
  IWEditTotalCOFINS.Text := '';
  IWEditTotalDescontos.Text := '';

  IWEditNumeroPedido.Text := '';
  IWEditCliente.Text      := '';
  IWEditCondicao.Text     := '';
  IWEditVendedor.Text     := '';
  IWEditCobranca.Text     := '';


  IWEditCliente.Enabled   := false;
  IWEditCondicao.Enabled  := false;
  IWEditVendedor.Enabled  := false;
  IWEditCobranca.Enabled  := false;

  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacliente").hide();'); // fecha lista
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").hide();'); // fecha lista
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listavendedor").hide();'); // fecha lista
  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").hide();'); // fecha lista
end;

// Localiza Cliente
function TF_CriaNota.LocalizaCliente(XCliente: string): TFDMemTable;
var wretjson,wURL,wfiltro: string;
    warray: TJSONArray;
    wmtclientes: TFDMemTable;
begin
  try
    wmtclientes := TFDMemTable.Create(nil);
    wfiltro     := RetornaFiltroPesquisa(XCliente);

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/cadastros/clientes?'+wfiltro+'='+XCliente;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/clientes?'+wfiltro+'='+XCliente;
    wretjson := IdHTTP1.Get(wURL);
    warray   := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtclientes.LoadFromJSON(warray);
    if not wmtclientes.Active then
       wmtclientes.Open;

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao localizar cliente '+slinebreak+E.Message);
    end;
  end;
  Result := wmtclientes;
end;


// Localiza Condicao
function TF_CriaNota.LocalizaCondicao(XCondicao: string): TFDMemTable;
var wretjson,wURL,wfiltro: string;
    warray: TJSONArray;
    wmtcondicoes: TFDMemTable;
begin
  try
    wmtcondicoes := TFDMemTable.Create(nil);
    wfiltro      := 'descricao';

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/cadastros/condicoes?'+wfiltro+'='+XCondicao;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/condicoes?'+wfiltro+'='+XCondicao;
    wretjson := IdHTTP1.Get(wURL);
    warray   := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtcondicoes.LoadFromJSON(warray);
    if not wmtcondicoes.Active then
       wmtcondicoes.Open;

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao localizar condição '+slinebreak+E.Message);
    end;
  end;
  Result := wmtcondicoes;
end;

// Localiza Vendedor
function TF_CriaNota.LocalizaVendedor(XVendedor: string): TFDMemTable;
var wretjson,wURL,wfiltro: string;
    warray: TJSONArray;
    wmtvendedores: TFDMemTable;
begin
  try
    wmtvendedores := TFDMemTable.Create(nil);
    wfiltro       := RetornaFiltroPesquisa(XVendedor);

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/cadastros/vendedores?'+wfiltro+'='+XVendedor;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/vendedores?'+wfiltro+'='+XVendedor;
    wretjson := IdHTTP1.Get(wURL);
    warray   := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtvendedores.LoadFromJSON(warray);
    if not wmtvendedores.Active then
       wmtvendedores.Open;

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao localizar vendedor '+slinebreak+E.Message);
    end;
  end;
  Result := wmtvendedores;
end;

// Localiza Cobrança
function TF_CriaNota.LocalizaCobranca(XCobranca: string): TFDMemTable;
var wretjson,wURL,wfiltro: string;
    warray: TJSONArray;
    wmtcobrancas: TFDMemTable;
begin
  try
    wmtcobrancas := TFDMemTable.Create(nil);
    wfiltro      := 'nome';

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/cadastros/cobrancas?'+wfiltro+'='+XCobranca;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/cobrancas?'+wfiltro+'='+XCobranca;
    wretjson := IdHTTP1.Get(wURL);
    warray   := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtcobrancas.LoadFromJSON(warray);
    if not wmtcobrancas.Active then
       wmtcobrancas.Open;

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao localizar cobrança '+slinebreak+E.Message);
    end;
  end;
  Result := wmtcobrancas;
end;

// Localiza Produto
function TF_CriaNota.LocalizaProduto(XFiltro,XProduto: string): TFDMemTable;
var wretjson,wURL,wfiltro: string;
    warray: TJSONArray;
    wmtprodutos: TFDMemTable;
begin
  try
    wmtprodutos := TFDMemTable.Create(nil);

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/cadastros/produtos?'+XFiltro+'='+XProduto;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/cadastros/produtos?'+XFiltro+'='+XProduto;
    wretjson := IdHTTP1.Get(wURL);
    warray   := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;

// Transforma o JSONArray em DataSet
    wmtprodutos.LoadFromJSON(warray);
    if not wmtprodutos.Active then
       wmtprodutos.Open;

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao localizar produto '+slinebreak+E.Message);
    end;
  end;
  Result := wmtprodutos;
end;


function TF_CriaNota.RetornaFiltroPesquisa(XCliente: string): string;
var ix,wtam: integer;
    wret,wvalor: string;
begin
  try
    wvalor := XCliente;
    wtam   := length(trim(XCliente));
    for ix := 0 to 9 do
    begin
      wvalor := StringReplace(wvalor,inttostr(ix),' ',[rfReplaceAll]);
    end;
    if length(trim(wvalor))>0 then
       wret := 'nome'
    else if wtam>11 then
       wret := 'cnpj'
    else
       wret := 'cpf';
  except
  end;
  Result := wret;
end;

// Monta Grid Pesquisa Cliente
procedure TF_CriaNota.MontaGridPesquisaCliente(XQueryCliente: TFDMemTable);
var html,parametro: string;
begin
  try
    html := '<div class="table-responsive">' +#13+#10+
            '<table class="table table-hover table-striped table-sm">' +#13+#10+
            '    <thead class="thead-dark" style="font-size: 12px">' +#13+#10+
            '      <tr>' +#13+#10+
            '        <th width="80px" style="text-align: left;">Nome Cliente</th>' +#13+#10+
            '        <th width="15px" style="text-align: left;">CPF/CNPJ</th>' +#13+#10+
            '        <th width="20px" style="text-align: left;">Cidade</th>' +#13+#10+
            '      </tr>' +#13+#10+
            '    </thead>' +#13+#10+
            '    <tbody>';

    while not XQueryCliente.EOF do
    begin
      parametro := QuotedStr(XQueryCliente.FieldByName('id').AsString)+','+QuotedStr(XQueryCliente.FieldByName('nome').AsString);
      html := html + '<tr href="#" onclick="selecionaCliente('+parametro+');"> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCliente.FieldByName('nome').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCliente.FieldByName('cpf').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCliente.FieldByName('cidade').AsString+'</td></tr> '+slinebreak;
      XQueryCliente.Next;
    end;

    html := html + '    </tbody>' +#13+#10+
                   '</table>' +#13+#10+
                   '</div>' +#13+#10+
                   '<br />' +#13+#10;

    IWLabelListaClientes.Text := html;

    WebApplication.CallBackResponse.AddJavaScriptToExecute('var InputWidth = $("#divteste").width(); '+
                                                           'var lista = $("#listacliente"); '+
                                                           'lista.width(InputWidth-110);');

    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacliente").show();'); // fecha lista
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacliente").focus();'); // seta foco

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao montar lista de clientes'+slinebreak+E.Message);
    end;
  end;
end;

// Monta Grid Pesquisa Condição
procedure TF_CriaNota.MontaGridPesquisaCondicao(XQueryCondicao: TFDMemTable);
var html,parametro: string;
begin
  try
    html := '<div class="table-responsive">' +#13+#10+
            '<table class="table table-hover table-striped table-sm" id="tablecondicao">' +#13+#10+
            '    <thead class="thead-dark" style="font-size: 12px">' +#13+#10+
            '      <tr>' +#13+#10+
            '        <th width="50px" style="text-align: left;">Descrição Condição</th>' +#13+#10+
            '        <th width="8px" style="text-align: left;">Nº Pagtos</th>' +#13+#10+
            '      </tr>' +#13+#10+
            '    </thead>' +#13+#10+
            '    <tbody>';

    while not XQueryCondicao.EOF do
    begin
      parametro := QuotedStr(XQueryCondicao.FieldByName('id').AsString)+','+QuotedStr(XQueryCondicao.FieldByName('descricao').AsString);
      html := html + '<tr href="#" onclick="selecionaCondicao('+parametro+');"> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCondicao.FieldByName('descricao').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCondicao.FieldByName('numpag').AsString+'</td></tr> '+slinebreak;
      XQueryCondicao.Next;
    end;

    html := html + '    </tbody>' +#13+#10+
                   '</table>' +#13+#10+
                   '</div>' +#13+#10+
                   '<br />' +#13+#10;

    IWLabelListaCondicoes.Text := html;

    WebApplication.CallBackResponse.AddJavaScriptToExecute('var InputWidth = $("#divteste").width(); '+
                                                           'var lista = $("#listacondicao"); '+
                                                           'lista.width((InputWidth/2)-90);');

    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").show();'); // fecha lista
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").find("tr:first");'); // posiciona na primeira linha da tabela
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacondicao").focus();'); // seta foco
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao montar lista de condições'+slinebreak+E.Message);
    end;
  end;
end;

// Monta Grid Pesquisa Vendedor
procedure TF_CriaNota.MontaGridPesquisaVendedor(XQueryVendedor: TFDMemTable);
var html,parametro: string;
begin
  try
    html := '<div class="table-responsive">' +#13+#10+
            '<table class="table table-hover table-striped table-sm">' +#13+#10+
            '    <thead class="thead-dark" style="font-size: 12px">' +#13+#10+
            '      <tr>' +#13+#10+
            '        <th width="80px" style="text-align: left;">Nome Vendedor</th>' +#13+#10+
            '        <th width="15px" style="text-align: left;">CPF/CNPJ</th>' +#13+#10+
            '        <th width="20px" style="text-align: left;">Cidade</th>' +#13+#10+
            '      </tr>' +#13+#10+
            '    </thead>' +#13+#10+
            '    <tbody>';

    while not XQueryVendedor.EOF do
    begin
      parametro := QuotedStr(XQueryVendedor.FieldByName('id').AsString)+','+QuotedStr(XQueryVendedor.FieldByName('nome').AsString);
      html := html + '<tr href="#" onclick="selecionaVendedor('+parametro+');"> '+
                    ' <td nowrap style="font-size:12px">'+XQueryVendedor.FieldByName('nome').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryVendedor.FieldByName('cpf').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryVendedor.FieldByName('cidade').AsString+'</td></tr> '+slinebreak;
      XQueryVendedor.Next;
    end;

    html := html + '    </tbody>' +#13+#10+
                   '</table>' +#13+#10+
                   '</div>' +#13+#10+
                   '<br />' +#13+#10;

    IWLabelListaVendedores.Text := html;

    WebApplication.CallBackResponse.AddJavaScriptToExecute('var InputWidth = $("#divteste").width(); '+
                                                           'var lista = $("#listavendedor"); '+
                                                           'lista.width(InputWidth-110);');

    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listavendedor").show();'); // fecha lista
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listavendedor").focus();'); // seta foco

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao montar lista de vendedores'+slinebreak+E.Message);
    end;
  end;
end;

// Monta Grid Pesquisa Cobrança
procedure TF_CriaNota.MontaGridPesquisaCobranca(XQueryCobranca: TFDMemTable);
var html,parametro: string;
begin
  try
    html := '<div class="table-responsive">' +#13+#10+
            '<table class="table table-hover table-striped table-sm" id="tablecobranca">' +#13+#10+
            '    <thead class="thead-dark" style="font-size: 12px">' +#13+#10+
            '      <tr>' +#13+#10+
            '        <th width="50px" style="text-align: left;">Nome Cobrança</th>' +#13+#10+
            '        <th width="8px" style="text-align: left;">Tipo</th>' +#13+#10+
            '      </tr>' +#13+#10+
            '    </thead>' +#13+#10+
            '    <tbody>';

    while not XQueryCobranca.EOF do
    begin
      parametro := QuotedStr(XQueryCobranca.FieldByName('id').AsString)+','+QuotedStr(XQueryCobranca.FieldByName('nome').AsString);
      html := html + '<tr href="#" onclick="selecionaCobranca('+parametro+');"> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCobranca.FieldByName('nome').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryCobranca.FieldByName('tipo').AsString+'</td></tr> '+slinebreak;
      XQueryCobranca.Next;
    end;

    html := html + '    </tbody>' +#13+#10+
                   '</table>' +#13+#10+
                   '</div>' +#13+#10+
                   '<br />' +#13+#10;

    IWLabelListaCobrancas.Text := html;

    WebApplication.CallBackResponse.AddJavaScriptToExecute('var InputWidth = $("#divteste").width(); '+
                                                           'var lista = $("#listacobranca"); '+
                                                           'lista.width((InputWidth/2)-90);');

    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").show();'); // fecha lista
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").find("tr:first");'); // posiciona na primeira linha da tabela
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listacobranca").focus();'); // seta foco
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao montar lista de cobranças'+slinebreak+E.Message);
    end;
  end;
end;

// Monta Grid Pesquisa Produto
procedure TF_CriaNota.MontaGridPesquisaProduto(XQueryProduto: TFDMemTable);
var html,parametro: string;
begin
  try
    html := '<div class="table-responsive">' +#13+#10+
            '<table class="table table-hover table-striped table-sm" id="tableproduto">' +#13+#10+
            '    <thead class="thead-dark" style="font-size: 12px">' +#13+#10+
            '      <tr>' +#13+#10+
            '        <th width="10%" style="text-align: left;">Código</th>' +#13+#10+
            '        <th width="50%" style="text-align: left;">Descrição Produto</th>' +#13+#10+
            '        <th width="10%" style="text-align: left;">Und</th>' +#13+#10+
            '        <th width="10%" style="text-align: left;">Marca</th>' +#13+#10+
            '        <th width="10%" style="text-align: left;">Preço</th>' +#13+#10+
            '      </tr>' +#13+#10+
            '    </thead>' +#13+#10+
            '    <tbody>';

    while not XQueryProduto.EOF do
    begin
      parametro := QuotedStr(XQueryProduto.FieldByName('id').AsString)+','+QuotedStr(XQueryProduto.FieldByName('codigo').AsString);
      html := html + '<tr href="#" onclick="selecionaProduto('+parametro+');"> '+
                    ' <td nowrap style="font-size:12px">'+XQueryProduto.FieldByName('codigo').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryProduto.FieldByName('descricao').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryProduto.FieldByName('unidade').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryProduto.FieldByName('marca').AsString+'</td> '+
                    ' <td nowrap style="font-size:12px">'+XQueryProduto.FieldByName('preco').AsString+'</td></tr> '+slinebreak;
      XQueryProduto.Next;
    end;

    html := html + '    </tbody>' +#13+#10+
                   '</table>' +#13+#10+
                   '</div>' +#13+#10+
                   '<br />' +#13+#10;

    IWLabelListaProdutos.Text := html;

    WebApplication.CallBackResponse.AddJavaScriptToExecute('var InputWidth = $("#divteste").width(); '+
                                                           'var lista = $("#listaproduto"); '+
                                                           'lista.width(InputWidth-150);');

    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").show();'); // fecha lista
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").find("tr:first");'); // posiciona na primeira linha da tabela
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").focus();'); // seta foco
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao montar lista de produtos'+slinebreak+E.Message);
    end;
  end;
end;

function TF_CriaNota.GravaItemNaAPI: boolean;
var wret: boolean;
    wURL,wresult,wretorno,wbody: string;
    wstatus,widitem: integer;
    witem,wjson: TJSONObject;
    wjsontosend: TStringStream;
begin
  try
    witem := TJSONObject.Create;
    witem.AddPair('numitem',inttostr(FNumItem+1));
    witem.AddPair('datamovimento',formatdatetime('dd/mm/yyyy hh:nn:ss',now));
    witem.AddPair('codproduto',IWEditCodProduto.Text);
    witem.AddPair('quantidade',IWEditQuantidade.Text);
    witem.AddPair('unitario',IWEditUnitario.Text);
    witem.AddPair('total',IWEditTotalItem.Text);

    wbody := witem.ToString;

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    // transforma string em stringstream
    wJsonToSend := TStringStream.Create(wbody, TEncoding.UTF8);
    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens';
    wresult  := IdHTTP1.Post(wURL,wjsontosend);
    wjson    := TJSONObject.ParseJSONValue(wresult) as TJSONObject;
    FNumItem := StrToInt(wjson.GetValue('numitem').Value); //atualiza o numero do item
    widitem  := StrToInt(wjson.GetValue('id').Value); //recupera o id do item

    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;

    wret := wstatus = 201;

    if wret then
       begin
         GravaParcelasNaAPI;
         GravaImpostosItem(widitem);
       end;

  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Erro ao gravar ítem na API'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_CriaNota.GravaImpostosItem(XIdItem: integer);
var wURL,wresult,wretorno: string;
    wstatus: integer;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    // transforma string em stringstream
    wJsonToSend := TStringStream.Create('', TEncoding.UTF8);
    wURL     := warqini.ReadString('Geral','URL','')+'/servicos/nfe/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens/'+inttostr(XIdItem)+'/impostos';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/servicos/nfe/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens/'+inttostr(XIdItem)+'/impostos';
    wresult  := IdHTTP1.Post(wURL,wjsontosend);
    wjson    := TJSONObject.ParseJSONValue(wresult) as TJSONObject;

    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao gravar impostos do ítem'+slinebreak+E.Message);
    end;
  end;
end;

function TF_CriaNota.GravaNotaNaAPI: boolean;
var wret: boolean;
    wURL,wresult,wretorno,wbody: string;
    wstatus: integer;
    wnfe,wjson: TJSONObject;
    wjsontosend: TStringStream;
begin
  try
    wnfe := TJSONObject.Create;
    wnfe.AddPair('dataemissao',formatdatetime('dd/mm/yyyy',now));
    wnfe.AddPair('cliente',IWEditCliente.Text);
    wnfe.AddPair('vendedor',IWEditVendedor.Text);
    wnfe.AddPair('condicao',IWEditCondicao.Text);
    wnfe.AddPair('cobranca',IWEditCobranca.Text);

    wbody := wnfe.ToString;

    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    // transforma string em stringstream
    wJsonToSend := TStringStream.Create(wbody, TEncoding.UTF8);
    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes';
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes';
    wresult  := IdHTTP1.Post(wURL,wjsontosend);
    wjson    := TJSONObject.ParseJSONValue(wresult) as TJSONObject;

    // salva o id da NFe
    ServerController.UserSession.FIdNFePendente := strtoint(wjson.GetValue('id').Value);

    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;

    wret := wstatus = 201;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Erro ao gravar NFe na API'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_CriaNota.LimpaCamposItens;
begin
  IWEditCodProduto.Text  := '';
  IWEditDescProduto.Text := '';
  IWEditQuantidade.Text  := '';
  IWEditUnitario.Text    := '';
  IWEditTotalItem.Text   := '';

  WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#listaproduto").hide();'); // fecha lista
end;

// Exclui item
function TF_CriaNota.ExcluiItemDaAPI(XIdItem: integer): boolean;
var wstatus: integer;
    wURL,wretorno: string;
    wjson: TJSONObject;
    wret: boolean;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens/'+inttostr(XIdItem);
//    wURL     := 'http://192.168.1.32:9000/trabinapi/movimentos/nfe_pendentes/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/itens/'+inttostr(XIdItem);
    IdHTTP1.Delete(wURL);
    wstatus  := IdHTTP1.ResponseCode;
    wretorno := IdHTTP1.ResponseText;
    wret     := true;

    GravaParcelasNaAPI;

  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage('Erro ao excluir ítem '+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

// Grava Parcelas na API
procedure TF_CriaNota.GravaParcelasNaAPI;
var wstatus: integer;
    wURL,wretorno,wretjson: string;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
begin
  try
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.Charset      := 'UTF-8';
    IdHTTP1.Request.Clear;
    IdHTTP1.Request.BasicAuthentication     := true;
    IdHTTP1.Request.Authentication          := TIdBasicAuthentication.Create;
    IdHTTP1.Request.Authentication.Username := 'user';
    IdHTTP1.Request.Authentication.Password := 'password';

    IdHTTP1.Request.Clear;
    IdHTTP1.Request.CustomHeaders.Clear;
    IdHTTP1.Request.ContentType  := 'application/json';
    IdHTTP1.Request.CharSet      := 'utf-8';
    IdHTTP1.Request.CustomHeaders.AddValue('idempresa','77222');

    IdHTTP1.Response.ContentType := 'application/json';
    IdHTTP1.Response.CharSet     := 'UTF-8';

    // transforma string em stringstream
    wJsonToSend := TStringStream.Create('', TEncoding.UTF8);
    wURL        := warqini.ReadString('Geral','URL','')+'/servicos/nfe/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/parcelas';
//    wURL        := 'http://192.168.1.32:9000/trabinapi/servicos/nfe/'+inttostr(ServerController.UserSession.FIdNFePendente)+'/parcelas';
    wretjson    := IdHTTP1.Post(wURL,wjsontosend);
    wstatus     := IdHTTP1.ResponseCode;
    wretorno    := IdHTTP1.ResponseText;

    if wstatus=201 then
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#IWBUTTONCRIAPARCELA").attr("disabled",false);');

  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao criar parcelas'+slinebreak+E.Message);
    end;
  end;
end;

end.
