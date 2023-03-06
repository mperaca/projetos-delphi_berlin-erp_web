unit uOrcamento;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompEdit, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent, System.StrUtils,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IniFiles, System.JSON, IWHTMLTag, IdAuthentication,
  IWCompMemo, System.Math,
  FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt;


type
  TF_Orcamento = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWEDITNUMERO: TIWEdit;
    IWEDITNUMERODOCUMENTO: TIWEdit;
    IWEDITDATADOCUMENTO: TIWEdit;
    IWEDITDATAEMISSAO: TIWEdit;
    IWEDITNOMECLIENTE: TIWEdit;
    IWEDITCONDICAOPAGAMENTO: TIWEdit;
    IWEDITNOMEVENDEDOR: TIWEdit;
    IWEDITDOCUMENTOCOBRANCA: TIWEdit;
    IWEDITNOMEEMITENTE: TIWEdit;
    IWEDITNOMETRANSPORTADORA: TIWEdit;
    IWEDITNOMERESPONSAVEL: TIWEdit;
    IWEDITAC: TIWEdit;
    IWEDITDATAENTREGA: TIWEdit;
    IWEDITHORAENTREGA: TIWEdit;
    IWEDITNUMEROORDEM: TIWEdit;
    IWEDITNUMEROORDEMSERVICO: TIWEdit;
    IWEDITVALIDADEORDEMSERVICO: TIWEdit;
    IWEDITTOTAL: TIWEdit;
    IWEDITIDORCAMENTO: TIWEdit;
    IWEDITIDCLIENTE: TIWEdit;
    IWEDITIDREPRESENTANTE: TIWEdit;
    IWEDITIDCONDICAO: TIWEdit;
    IWEDITIDCOBRANCA: TIWEdit;
    IWEDITOBSERVACAO: TIWEdit;
    IWEDITCODIGO: TIWEdit;
    IWEDITDESCRICAO: TIWEdit;
    IWEDITCFOP: TIWEdit;
    IWEDITCEAN: TIWEdit;
    IWEDITUNIDADE: TIWEdit;
    IWEDITUNITARIO: TIWEdit;
    IWEDITQUANTIDADE: TIWEdit;
    IWEDITPERCDESCONTO: TIWEdit;
    IWEDITVALORDESCONTO: TIWEdit;
    IWEDITVALORTOTAL: TIWEdit;
    IWEDITCSTICMS: TIWEdit;
    IWEDITCODALIQICMS: TIWEdit;
    IWEDITALIQICMS: TIWEdit;
    IWEDITBASEICMS: TIWEdit;
    IWEDITVALORICMS: TIWEdit;
    IWEDITCSTPIS: TIWEdit;
    IWEDITALIQPIS: TIWEdit;
    IWEDITBASEPIS: TIWEdit;
    IWEDITVALORPIS: TIWEdit;
    IWEDITCSTCOFINS: TIWEdit;
    IWEDITALIQCOFINS: TIWEdit;
    IWEDITBASECOFINS: TIWEdit;
    IWEDITVALORCOFINS: TIWEdit;
    IWEDITIDPRODUTO: TIWEdit;
    procedure IWEDITNUMEROHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWMEMOOBSERVACAOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITDATADOCUMENTOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITNOMECLIENTEAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITNOMEVENDEDORAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCONDICAOPAGAMENTOAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITDOCUMENTOCOBRANCAAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCODIGOAsyncKeyUp(Sender: TObject; EventParams: TStringList);
    procedure IWEDITDESCRICAOAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITQUANTIDADEAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITUNITARIOAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
  private
    procedure PopulaCamposOrcamento(XId: integer);
    procedure LimpaCampos;
    function ConfirmaOrcamento(XId: integer): boolean;
    function ExcluiOrcamento(XId: integer): boolean;
    function RetornaRegistros(XRecurso, XCampo, XValor: string): TFDMemTable;
    procedure CarregaObservacao(XJSON: TJSONObject);
    function IncluiOrcamento: boolean;
    procedure PopulaCamposItem(XIdItem: integer);
    procedure LimpaCamposItens;
    function ConfirmaOrcamentoItem(XId: integer): boolean;
    procedure CalculaTotal(XTipo: string);
    procedure CarregaCamposProduto(XIdProduto: integer);
    function IncluiOrcamentoItem: boolean;
    function ExcluiOrcamentoItem(XId: integer): boolean;
  public
  end;

implementation

{$R *.dfm}

uses UserSessionUnit, ServerController, DataSet.Serialize;


procedure TF_Orcamento.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widorcamento,widcliente,widvendedor,widcondicao,widcobranca,widitem,widproduto: integer;
    wpagina,wcliente,wvendedor,wcondicao,wcobranca: string;
begin
  if pos('[LimpaOrcamento]',IWEDITNOME.Text)>0 then
     LimpaCampos
  else if pos('[LimpaOrcamentoItem]',IWEDITNOME.Text)>0 then
     LimpaCamposItens
  else if pos('[CalculaTotal]',IWEDITNOME.Text)>0 then
     begin
       if UserSession.FIdOrcamentoItem>0 then
          CalculaTotal('item')
       else
          CalculaTotal('produto');
     end
  else if pos('[HelpProduto]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTipoHelpProduto := copy(IWEDITNOME.Text,pos('[HelpProduto]',IWEDITNOME.Text)+13,100);
       if UserSession.FTipoHelpProduto='codigo' then
          UserSession.FCodProdutoItem := ''
       else if UserSession.FTipoHelpProduto='descricao' then
          UserSession.FDescProdutoItem := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaProdutos(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalProduto'').modal(''show'');');
     end
  else if pos('[HelpCliente]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FClienteOrcamento := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClientes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCliente'').modal(''show'');');
     end
  else if pos('[HelpVendedor]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FVendedorOrcamento := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaVendedores(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalVendedor'').modal(''show'');');
     end
  else if pos('[HelpCondicao]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCondicaoOrcamento := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCondicoes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCondicao'').modal(''show'');');
     end
  else if pos('[HelpCobranca]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCobrancaOrcamento := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCobrancas(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCobranca'').modal(''show'');');
     end
  else if pos('[SelecionaProduto]',IWEDITNOME.Text)>0 then
     begin
       widproduto := strtointdef(IWEDITIDPRODUTO.Text,0);
       CarregaCamposProduto(widproduto);
     end
  else if pos('[SelecionaCliente]',IWEDITNOME.Text)>0 then
     begin
       widcliente := strtointdef(IWEDITIDCLIENTE.Text,0);
       wcliente   := copy(IWEDITNOME.Text,pos('[SelecionaCliente]',IWEDITNOME.Text)+18,100);
       IWEDITNOMECLIENTE.Text        := wcliente;
       IWEDITNOMECLIENTE.Tag         := widcliente;
       UserSession.FClienteOrcamento := wcliente;
     end
  else if pos('[SelecionaRepresentante]',IWEDITNOME.Text)>0 then
     begin
       widvendedor := strtointdef(IWEDITIDREPRESENTANTE.Text,0);
       wvendedor   := copy(IWEDITNOME.Text,pos('[SelecionaRepresentante]',IWEDITNOME.Text)+24,100);
       IWEDITNOMEVENDEDOR.Text        := wvendedor;
       IWEDITNOMEVENDEDOR.Tag         := widvendedor;
       UserSession.FVendedorOrcamento := wvendedor;
     end
  else if pos('[SelecionaCondicao]',IWEDITNOME.Text)>0 then
     begin
       widcondicao := strtointdef(IWEDITIDCONDICAO.Text,0);
       wcondicao   := copy(IWEDITNOME.Text,pos('[SelecionaCondicao]',IWEDITNOME.Text)+19,100);
       IWEDITCONDICAOPAGAMENTO.Text   := wcondicao;
       IWEDITCONDICAOPAGAMENTO.Tag    := widcondicao;
       UserSession.FCondicaoOrcamento := wcondicao;
     end
  else if pos('[SelecionaCobranca]',IWEDITNOME.Text)>0 then
     begin
       widcobranca := strtointdef(IWEDITIDCOBRANCA.Text,0);
       wcobranca   := copy(IWEDITNOME.Text,pos('[SelecionaCobranca]',IWEDITNOME.Text)+19,100);
       IWEDITDOCUMENTOCOBRANCA.Text   := wcobranca;
       IWEDITDOCUMENTOCOBRANCA.Tag    := widcobranca;
       UserSession.FCobrancaOrcamento := wcobranca;
     end
  else if pos('[CarregaOrcamento]',IWEDITNOME.Text)>0 then
     begin
       widorcamento  := strtointdef(IWEDITID.Text,0);
       PopulaCamposOrcamento(widorcamento);
     end
  else if pos('[IncluiOrcamento]',IWEDITNOME.Text)>0 then
     begin
       LimpaCampos;
       UserSession.FIdOrcamento := 0;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(10);');
       PopulaCamposOrcamento(0);
       IWEDITDATAEMISSAO.Text := FormatDateTime('dd/mm/yyyy',date);
       IWEDITDATAEMISSAO.SetFocus;
     end
  else if pos('[AlteraOrcamento]',IWEDITNOME.Text)>0 then
     begin
       IWEDITDATAEMISSAO.SetFocus;
     end
  else if pos('[CancelaOrcamento]',IWEDITNOME.Text)>0 then
     begin
       widorcamento  := strtointdef(IWEDITIDORCAMENTO.Text,0);
       if widorcamento>0 then
          PopulaCamposOrcamento(widorcamento)
       else
          LimpaCampos;
     end
  else if pos('[ConfirmaOrcamento]',IWEDITNOME.Text)>0 then
     begin
//       widpessoa  := strtointdef(IWEDITID.Text,0);
       widorcamento := strtointdef(IWEDITIDORCAMENTO.Text,0);
       wpagina    := copy(IWEDITNOME.Text,pos('[ConfirmaOrcamento]',IWEDITNOME.Text)+19,10);
       if widorcamento>0 then
          begin
            if ConfirmaOrcamento(widorcamento) then
               begin
                 PopulaCamposOrcamento(widorcamento);
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiOrcamento then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[AlteraItem]',IWEDITNOME.Text)>0 then
     begin
       widitem := strtointdef(IWEDITID.Text,0);
       PopulaCamposItem(widitem);
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#itensOrcamento'').hide();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#itemOrcamento'').show();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCODIGO'').focus();');
     end
  else if pos('[ConfirmaItem]',IWEDITNOME.Text)>0 then
     begin
       if (UserSession.FIdOrcamentoItem>0) and (ConfirmaOrcamentoItem(UserSession.FIdOrcamentoItem)) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
//            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(10);');
//            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(10);');
          end
       else if (UserSession.FIdOrcamentoItem=0) and (IncluiOrcamentoItem) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
//            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(10);');
//            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(10);');
          end
       else
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end
  else if pos('[ExcluiOrcamento]',IWEDITNOME.Text)>0 then
     begin
       widorcamento  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiOrcamento]',IWEDITNOME.Text)+17,10);
       if ExcluiOrcamento(widorcamento) then
          begin
            LimpaCampos;
            PopulaCamposOrcamento(0);
            WebApplication.CallBackResponse.AddJavaScriptToExecute('desabilitaEdicao();');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[ExcluiItem]',IWEDITNOME.Text)>0 then
     begin
       widitem  := strtointdef(IWEDITID.Text,0);
       wpagina  := copy(IWEDITNOME.Text,pos('[ExcluiItem]',IWEDITNOME.Text)+12,10);
       if ExcluiOrcamentoItem(widitem) then
          begin
            LimpaCamposItens;
            PopulaCamposOrcamento(UserSession.FIdOrcamento);
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina2('+wpagina+');');
          end;
     end;
end;

procedure TF_Orcamento.PopulaCamposItem(XIdItem: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
begin
  try
    UserSession.FMemTableOrcamentoItem.Filtered := false;
    UserSession.FMemTableOrcamentoItem.Filter   := 'id = '+inttostr(XIdItem);
    UserSession.FMemTableOrcamentoItem.Filtered := true;
    UserSession.FIdOrcamentoItem := UserSession.FMemTableOrcamentoItem.FieldByName('id').AsInteger;

    IWEDITCODIGO.Text    := UserSession.FMemTableOrcamentoItem.FieldByName('xcodproduto').AsString;
    IWEDITCODIGO.Tag     := UserSession.FMemTableOrcamentoItem.FieldByName('idproduto').AsInteger;
    IWEDITDESCRICAO.Text := UserSession.FMemTableOrcamentoItem.FieldByName('xdescproduto').AsString;
    IWEDITDESCRICAO.Tag  := UserSession.FMemTableOrcamentoItem.FieldByName('idproduto').AsInteger;

    IWEDITUNIDADE.Text     := UserSession.FMemTableOrcamentoItem.FieldByName('xunidadeproduto').AsString;
    if UserSession.FMemTableOrcamentoItem.FieldByName('valorunitario').IsNull then
       IWEDITUNITARIO.Text := '0.00'
    else
       IWEDITUNITARIO.Text := formatfloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('valorunitario').AsFloat);
    IWEDITCSTICMS.Text    := UserSession.FMemTableOrcamentoItem.FieldByName('xsituacaotributaria').AsString;
    IWEDITCSTICMS.Tag     := UserSession.FMemTableOrcamentoItem.FieldByName('idsituacaotributaria').AsInteger;
    IWEDITCEAN.Text       := UserSession.FMemTableOrcamentoItem.FieldByName('xceanproduto').AsString;
    IWEDITCFOP.Text       := UserSession.FMemTableOrcamentoItem.FieldByName('xcodigofiscal').AsString;
    IWEDITCFOP.Tag        := UserSession.FMemTableOrcamentoItem.FieldByName('idcodigofiscal').AsInteger;

    IWEDITCODALIQICMS.Text  := UserSession.FMemTableOrcamentoItem.FieldByName('xcodaliquota').AsString;
    IWEDITCODALIQICMS.Tag   := UserSession.FMemTableOrcamentoItem.FieldByName('idaliquota').AsInteger;
    if UserSession.FMemTableOrcamentoItem.FieldByName('percentualicms').IsNull then
       IWEDITALIQICMS.Text  := '0.00%'
    else
       IWEDITALIQICMS.Text  := formatfloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('percentualicms').AsFloat);
    IWEDITALIQICMS.Tag      := UserSession.FMemTableOrcamentoItem.FieldByName('idaliquota').AsInteger;
    IWEDITCSTPIS.Text       := UserSession.FMemTableOrcamentoItem.FieldByName('cstpis').AsString;
    IWEDITCSTCOFINS.Text    := UserSession.FMemTableOrcamentoItem.FieldByName('cstcofins').AsString;
    if UserSession.FMemTableOrcamentoItem.FieldByName('percentualdesconto').IsNull then
       IWEDITPERCDESCONTO.Text := '0.00%'
    else
       IWEDITPERCDESCONTO.Text := FormatFloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('percentualdesconto').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('baseicms').IsNull then
       IWEDITBASEICMS.Text     := '0.00%'
    else
       IWEDITBASEICMS.Text     := formatfloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('baseicms').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('xpercpis').IsNull then
       IWEDITALIQPIS.Text      := '0.00%'
    else
       IWEDITALIQPIS.Text      := formatfloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('xpercpis').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('xperccofins').IsNull then
       IWEDITALIQCOFINS.Text   := '0.00%'
    else
       IWEDITALIQCOFINS.Text   := formatfloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('xperccofins').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasepis').IsNull then
       IWEDITBASEPIS.Text   := '0.00%'
    else
       IWEDITBASEPIS.Text   := formatfloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasepis').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasecofins').IsNull then
       IWEDITBASECOFINS.Text:= '0.00%'
    else
       IWEDITBASECOFINS.Text:= formatfloat('#,0.00%',UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasecofins').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('quantidade').IsNull then
       IWEDITQUANTIDADE.Text   := '0.000'
    else
       IWEDITQUANTIDADE.Text   := formatfloat('#,0.000',UserSession.FMemTableOrcamentoItem.FieldByName('quantidade').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('valordesconto').IsNull then
       IWEDITVALORDESCONTO.Text := '0.00'
    else
       IWEDITVALORDESCONTO.Text := FormatFloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('valordesconto').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('baseicms').IsNull then
       IWEDITBASEICMS.Text      := '0.00'
    else
       IWEDITBASEICMS.Text      := FormatFloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('baseicms').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('valoricms').IsNull then
       IWEDITVALORICMS.Text     := '0.00'
    else
       IWEDITVALORICMS.Text     := FormatFloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('valoricms').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('valorpis').IsNull then
       IWEDITVALORPIS.Text      := '0.00'
    else
       IWEDITVALORPIS.Text      := FormatFloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('valorpis').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('valorcofins').IsNull then
       IWEDITVALORCOFINS.Text   := '0.00'
    else
       IWEDITVALORCOFINS.Text   := FormatFloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('valorcofins').AsFloat);
    if UserSession.FMemTableOrcamentoItem.FieldByName('valortotal').IsNull then
       IWEDITVALORTOTAL.Text    := '0.00'
    else
       IWEDITVALORTOTAL.Text    := FormatFloat('#,0.00',UserSession.FMemTableOrcamentoItem.FieldByName('valortotal').AsFloat);
  except

  end;
end;

procedure TF_Orcamento.IWEDITCODIGOAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtProduto: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCodProdutoItem<>IWEDITCODIGO.Text then
     begin
       UserSession.FCodProdutoItem  := IWEDITCODIGO.Text;
       UserSession.FTipoHelpProduto := 'codigo';
       wmtProduto := RetornaRegistros('produtos','codigo',IWEDITCODIGO.Text);
       if wmtProduto.RecordCount=1 then
          begin
            IWEDITCODIGO.Text := wmtProduto.FieldByName('codigo').AsString;
            IWEDITCODIGO.Tag  := wmtProduto.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtProduto.RecordCount=0 then
               UserSession.FCodProdutoItem := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaProdutos(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalProduto'').modal(''show'');');
          end;
     end;
  IWEDITDESCRICAO.SetFocus;
end;

procedure TF_Orcamento.IWEDITCONDICAOPAGAMENTOAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCondicao: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCondicaoOrcamento<>IWEDITCONDICAOPAGAMENTO.Text then
     begin
       UserSession.FCondicaoOrcamento := IWEDITCONDICAOPAGAMENTO.Text;
       wmtCondicao := RetornaRegistros('condicoes','descricao',IWEDITCONDICAOPAGAMENTO.Text);
       if wmtCondicao.RecordCount=1 then
          begin
            IWEDITCONDICAOPAGAMENTO.Text := wmtCondicao.FieldByName('descricao').AsString;
            IWEDITCONDICAOPAGAMENTO.Tag  := wmtCondicao.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCondicao.RecordCount=0 then
               UserSession.FCondicaoOrcamento := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCondicoes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCondicao'').modal(''show'');');
          end;
     end;
end;

procedure TF_Orcamento.IWEDITDATADOCUMENTOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: red" required="true" autocomplete="off" placeholder="" ');
end;

procedure TF_Orcamento.IWEDITDESCRICAOAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtProduto: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FDescProdutoItem<>IWEDITDESCRICAO.Text then
     begin
       UserSession.FDescProdutoItem  := IWEDITDESCRICAO.Text;
       UserSession.FTipoHelpProduto := 'descricao';
       wmtProduto := RetornaRegistros('produtos','descricao',IWEDITDESCRICAO.Text);
       if wmtProduto.RecordCount=1 then
          begin
            IWEDITCODIGO.Text    := wmtProduto.FieldByName('codigo').AsString;
            IWEDITCODIGO.Tag     := wmtProduto.FieldByName('id').AsInteger;
            IWEDITDESCRICAO.Text := wmtProduto.FieldByName('descricao').AsString;
            IWEDITDESCRICAO.Tag  := wmtProduto.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtProduto.RecordCount=0 then
               UserSession.FDescProdutoItem := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaProdutos(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalProduto'').modal(''show'');');
          end;
     end;
  IWEDITUNITARIO.SetFocus;
end;

procedure TF_Orcamento.IWEDITDOCUMENTOCOBRANCAAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCobranca: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCobrancaOrcamento<>IWEDITDOCUMENTOCOBRANCA.Text then
     begin
       UserSession.FCobrancaOrcamento := IWEDITDOCUMENTOCOBRANCA.Text;
       wmtCobranca := RetornaRegistros('cobrancas','nome',IWEDITDOCUMENTOCOBRANCA.Text);
       if wmtCobranca.RecordCount=1 then
          begin
            IWEDITDOCUMENTOCOBRANCA.Text := wmtCobranca.FieldByName('nome').AsString;
            IWEDITDOCUMENTOCOBRANCA.Tag  := wmtCobranca.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCobranca.RecordCount=0 then
               UserSession.FCobrancaOrcamento := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCobrancas(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCobranca'').modal(''show'');');
          end;
     end;
end;

procedure TF_Orcamento.IWEDITNOMECLIENTEAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCliente: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FClienteOrcamento<>IWEDITNOMECLIENTE.Text then
     begin
       UserSession.FClienteOrcamento := IWEDITNOMECLIENTE.Text;
       wmtCliente := RetornaRegistros('pessoas','nome',IWEDITNOMECLIENTE.Text);
       if wmtCliente.RecordCount=1 then
          begin
            IWEDITNOMECLIENTE.Text := wmtCliente.FieldByName('nome').AsString;
            IWEDITNOMECLIENTE.Tag  := wmtCliente.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCliente.RecordCount=0 then
               UserSession.FClienteOrcamento := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClientes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCliente'').modal(''show'');');
          end;
     end;
//  IWEDITCEPPESSOA.SetFocus;
end;

procedure TF_Orcamento.IWEDITNOMEVENDEDORAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtVendedor: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FVendedorOrcamento<>IWEDITNOMEVENDEDOR.Text then
     begin
       UserSession.FVendedorOrcamento := IWEDITNOMEVENDEDOR.Text;
       wmtVendedor := RetornaRegistros('pessoas','nome',IWEDITNOMEVENDEDOR.Text);
       if wmtVendedor.RecordCount=1 then
          begin
            IWEDITNOMEVENDEDOR.Text := wmtVendedor.FieldByName('nome').AsString;
            IWEDITNOMEVENDEDOR.Tag  := wmtVendedor.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtVendedor.RecordCount=0 then
               UserSession.FVendedorOrcamento := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaVendedores(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalVendedor'').modal(''show'');');
          end;
     end;
end;

procedure TF_Orcamento.IWEDITNUMEROHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Orcamento.IWEDITQUANTIDADEAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  IWEDITCODIGO.SetFocus;
end;

procedure TF_Orcamento.IWEDITUNITARIOAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  IWEDITQUANTIDADE.SetFocus;
end;

procedure TF_Orcamento.IWMEMOOBSERVACAOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff"; rows=5 required="false" autocomplete="off" placeholder="" ');
end;

procedure TF_Orcamento.PopulaCamposOrcamento(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
begin
  try
    if XId>0 then
       begin
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
          URL := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/'+inttostr(XId);
          wretjson := wIdHTTP.Get(URL);
          wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
          UserSession.FJSONOrcamento := wjson;

          IWEDITIDORCAMENTO.Text            := wjson.GetValue('id').Value;
          IWEDITNUMERO.Text                 := wjson.GetValue('numero').Value;
          IWEDITNUMERO.Tag                  := strtointdef(wjson.GetValue('id').Value,0);
          IWEDITNUMERODOCUMENTO.Text        := ifthen(wjson.GetValue('xdocumentonota').Value='null','',wjson.GetValue('xdocumentonota').Value);
          if wjson.GetValue('xemissaonota').Value='null' then
             IWEDITDATADOCUMENTO.Text       := ''
          else
             IWEDITDATADOCUMENTO.Text       := formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('xemissaonota').Value));
          if (wjson.GetValue('total').Value='0') or (wjson.GetValue('total').Value='null') then
             IWEDITTOTAL.Text               := '0.00'
          else
             IWEDITTOTAL.Text               := formatfloat('#,0.00',strtofloat(wjson.GetValue('total').Value));

          IWEDITNOMECLIENTE.Text            := ifthen(wjson.GetValue('xcliente').Value='null','',wjson.GetValue('xcliente').Value);
          IWEDITNOMECLIENTE.Tag             := strtoint(ifthen(wjson.GetValue('xcliente').Value='null','0',wjson.GetValue('idcliente').Value));
          IWEDITNOMEVENDEDOR.Text           := ifthen(wjson.GetValue('xvendedor').Value='null','',wjson.GetValue('xvendedor').Value);
          IWEDITNOMEVENDEDOR.Tag            := strtoint(ifthen(wjson.GetValue('xvendedor').Value='null','0',wjson.GetValue('idvendedor').Value));
          IWEDITNOMETRANSPORTADORA.Text     := ifthen(wjson.GetValue('xtransportador').Value='null','',wjson.GetValue('xtransportador').Value);
          IWEDITNOMETRANSPORTADORA.Tag      := strtoint(ifthen(wjson.GetValue('xtransportador').Value='null','0',wjson.GetValue('idtransportador').Value));
          IWEDITCONDICAOPAGAMENTO.Text      := ifthen(wjson.GetValue('xcondicao').Value='null','',wjson.GetValue('xcondicao').Value);
          IWEDITCONDICAOPAGAMENTO.Tag       := strtoint(ifthen(wjson.GetValue('xcondicao').Value='null','0',wjson.GetValue('idcondicao').Value));
          IWEDITDOCUMENTOCOBRANCA.Text      := ifthen(wjson.GetValue('xcobranca').Value='null','',wjson.GetValue('xcobranca').Value);
          IWEDITDOCUMENTOCOBRANCA.Tag       := strtoint(ifthen(wjson.GetValue('xcobranca').Value='null','0',wjson.GetValue('idcobranca').Value));
          IWEDITDATAEMISSAO.Text            := ifthen(wjson.GetValue('dataemissao').Value='null','',formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('dataemissao').Value)));
//          IWMEMOOBSERVACAO.Text             := ifthen(wjson.GetValue('observacao').Value='null','',wjson.GetValue('observacao').Value);
          IWEDITVALIDADEORDEMSERVICO.Text   := ifthen(wjson.GetValue('datavalidade').Value='null','',formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datavalidade').Value)));

          CarregaObservacao(wjson);

          UserSession.FIdOrcamento          := strtoint(wjson.GetValue('id').Value);
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(10);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(10);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#divBotoes'').css(''display'',''block'');');
       end
    else
       begin
          UserSession.FIdOrcamento          := 0;
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(0);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(0);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('montaObservacao('+QuotedStr('')+');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#divBotoes'').css(''display'',''none'');');
       end;

//    CarregaGeral(wjson);
//    CarregaClassificacao(wjson);
//    CarregaOutros(wjson);
//    CarregaSelect(wjson);
    IWEDITDATAEMISSAO.SetFocus;
  except
    on E: Exception do
    begin
      if XId>0 then
         WebApplication.ShowMessage('Problema ao popular campos do orçamento'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_Orcamento.LimpaCampos;
begin
  try
    UserSession.FIdOrcamento         := 0;
    UserSession.FClienteOrcamento    := '';
    UserSession.FVendedorOrcamento   := '';
    UserSession.FCondicaoOrcamento   := '';
    UserSession.FCobrancaOrcamento   := '';
    UserSession.FCodProdutoItem      := '';
    UserSession.FDescProdutoItem     := '';
    IWEDITIDORCAMENTO.Text           := '';
    IWEDITNUMERO.Text                := '';
    IWEDITNUMERODOCUMENTO.Text       := '';
    IWEDITDATADOCUMENTO.Text         := '';
    IWEDITTOTAL.Text                 := '';
    IWEDITDATAEMISSAO.Text           := '';
    IWEDITNOMECLIENTE.Text           := '';
    IWEDITNOMECLIENTE.Tag            := 0;
    IWEDITCONDICAOPAGAMENTO.Text     := '';
    IWEDITCONDICAOPAGAMENTO.Tag      := 0;
    IWEDITDOCUMENTOCOBRANCA.Text     := '';
    IWEDITDOCUMENTOCOBRANCA.Tag      := 0;
    IWEDITNOMEEMITENTE.Text          := '';
    IWEDITNOMERESPONSAVEL.Text       := '';
    IWEDITNOMETRANSPORTADORA.Text    := '';
    IWEDITNOMEVENDEDOR.Text          := '';
    IWEDITNOMEVENDEDOR.Tag           := 0;
    IWEDITAC.Text                    := '';
//    IWMEMOOBSERVACAO.Text            := '';
    IWEDITDATAENTREGA.Text           := '';
    IWEDITHORAENTREGA.Text           := '';
    IWEDITNUMEROORDEM.Text           := '';
    IWEDITNUMEROORDEMSERVICO.Text    := '';
    IWEDITVALIDADEORDEMSERVICO.Text  := '';
    IWEDITOBSERVACAO.Text            := '';
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaObservacao('+QuotedStr('')+');');
  finally

  end;
end;

procedure TF_Orcamento.LimpaCamposItens;
begin
  try
    UserSession.FIdOrcamentoItem := 0;
    UserSession.FCodProdutoItem  := '';
    UserSession.FDescProdutoItem := '';
    IWEDITCODIGO.Text       := '';
    IWEDITCODIGO.Tag        := 0;
    IWEDITDESCRICAO.Text    := '';
    IWEDITDESCRICAO.Tag     := 0;
    IWEDITUNIDADE.Text      := '';
    IWEDITUNITARIO.Text     := '';
    IWEDITCSTICMS.Text      := '';
    IWEDITCSTICMS.Tag       := 0;
    IWEDITCEAN.Text         := '';
    IWEDITCFOP.Text         := '';
    IWEDITCFOP.Tag          := 0;

    IWEDITCODALIQICMS.Text  := '';
    IWEDITCODALIQICMS.Tag   := 0;
    IWEDITALIQICMS.Text     := '';
    IWEDITALIQICMS.Tag      := 0;
    IWEDITCSTPIS.Text       := '';
    IWEDITCSTCOFINS.Text    := '';
    IWEDITPERCDESCONTO.Text := '';
    IWEDITBASEICMS.Text     := '';
    IWEDITALIQPIS.Text      := '';
    IWEDITALIQCOFINS.Text   := '';
    IWEDITBASEPIS.Text      := '';
    IWEDITBASECOFINS.Text   := '';
    IWEDITQUANTIDADE.Text   := '';

    IWEDITVALORDESCONTO.Text := '';
    IWEDITBASEICMS.Text      := '';
    IWEDITVALORICMS.Text     := '';
    IWEDITVALORPIS.Text      := '';
    IWEDITVALORCOFINS.Text   := '';
    IWEDITVALORTOTAL.Text    := '';
  finally

  end;
end;


function TF_Orcamento.ConfirmaOrcamento(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno,wuf,wregiao: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    worcamento: TJSONObject;
begin
  try
    worcamento := TJSONObject.Create;
    worcamento.AddPair('numero',IWEDITNUMERO.Text);
    worcamento.AddPair('idcliente',ifthen(Length(trim(IWEDITNOMECLIENTE.Text))>0,inttostr(IWEDITNOMECLIENTE.Tag),'0'));
    worcamento.AddPair('idcondicao',ifthen(Length(trim(IWEDITCONDICAOPAGAMENTO.Text))>0,inttostr(IWEDITCONDICAOPAGAMENTO.Tag),'0'));
    worcamento.AddPair('idvendedor',ifthen(Length(trim(IWEDITNOMEVENDEDOR.Text))>0,inttostr(IWEDITNOMEVENDEDOR.Tag),'0'));
    worcamento.AddPair('idcobranca',ifthen(Length(trim(IWEDITDOCUMENTOCOBRANCA.Text))>0,inttostr(IWEDITDOCUMENTOCOBRANCA.Tag),'0'));
    worcamento.AddPair('observacao',ifthen(Length(trim(IWEDITOBSERVACAO.Text))>0,IWEDITOBSERVACAO.Text,'null'));
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

    wJsonToSend := TStringStream.Create(worcamento.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);

    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao alterar orçamento'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Orcamento.ConfirmaOrcamentoItem(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno,wuf,wregiao: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    witem: TJSONObject;
    wpercdesconto,wtotalitem,wquantidade,wunitario,wvaldesconto,wbaseicms,wvalicms,wpercpis,wperccofins,wvalpis,wpercbasepis,wvalcofins,wpercbasecofins: string;
begin
  try
    wquantidade     := StringReplace(IWEDITQUANTIDADE.Text,'.','',[rfReplaceAll]);
    wunitario       := StringReplace(IWEDITUNITARIO.Text,'.','',[rfReplaceAll]);
    wtotalitem      := StringReplace(IWEDITVALORTOTAL.Text,'.','',[rfReplaceAll]);
    wpercdesconto   := StringReplace((StringReplace(IWEDITPERCDESCONTO.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wvaldesconto    := StringReplace(IWEDITVALORDESCONTO.Text,'.','',[rfReplaceAll]);
    wbaseicms       := StringReplace(IWEDITBASEICMS.Text,'.','',[rfReplaceAll]);
    wvalicms        := StringReplace(IWEDITVALORICMS.Text,'.','',[rfReplaceAll]);
    wpercpis        := StringReplace((StringReplace(IWEDITALIQPIS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wperccofins     := StringReplace((StringReplace(IWEDITALIQCOFINS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wvalpis         := StringReplace(IWEDITVALORPIS.Text,'.','',[rfReplaceAll]);
    wpercbasepis    := StringReplace((StringReplace(IWEDITBASEPIS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wvalcofins      := StringReplace(IWEDITVALORCOFINS.Text,'.','',[rfReplaceAll]);
    wpercbasecofins := StringReplace((StringReplace(IWEDITBASECOFINS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);

    witem := TJSONObject.Create;
//    witem.AddPair('idproduto',ifthen(Length(trim(IWEDITCODIGO.Text))>0,inttostr(IWEDITCODIGO.Tag),'0'));
    witem.AddPair('quantidade',ifthen(Length(trim(wquantidade))>0,wquantidade,'0'));
    witem.AddPair('valorunitario',ifthen(Length(trim(wunitario))>0,wunitario,'0'));
    witem.AddPair('valortotal',ifthen(Length(trim(wtotalitem))>0,wtotalitem,'0'));
    witem.AddPair('percentualdesconto',ifthen(Length(trim(wpercdesconto))>0,wpercdesconto,'0'));
    witem.AddPair('valordesconto',ifthen(Length(trim(wvaldesconto))>0,wvaldesconto,'0'));
    witem.AddPair('baseicms',ifthen(Length(trim(wbaseicms))>0,wbaseicms,'0'));
    witem.AddPair('valoricms',ifthen(Length(trim(wvalicms))>0,wvalicms,'0'));
    witem.AddPair('percentualpis',ifthen(Length(trim(wpercpis))>0,wpercpis,'0'));
    witem.AddPair('percentualcofins',ifthen(Length(trim(wperccofins))>0,wperccofins,'0'));
    witem.AddPair('valorpis',ifthen(Length(trim(wvalpis))>0,wvalpis,'0'));
    witem.AddPair('valorcofins',ifthen(Length(trim(wvalcofins))>0,wvalcofins,'0'));
    witem.AddPair('percentualbasepis',ifthen(Length(trim(wpercbasepis))>0,wpercbasepis,'0'));
    witem.AddPair('percentualbasecofins',ifthen(Length(trim(wpercbasecofins))>0,wpercbasecofins,'0'));
    witem.AddPair('idaliquota',ifthen(Length(trim(IWEDITALIQICMS.Text))>0,inttostr(IWEDITALIQICMS.Tag),'0'));
    witem.AddPair('idcodigofiscal',ifthen(Length(trim(IWEDITCFOP.Text))>0,inttostr(IWEDITCFOP.Tag),'0'));
    witem.AddPair('idsituacaotributaria',ifthen(Length(trim(IWEDITCSTICMS.Text))>0,inttostr(IWEDITCSTICMS.Tag),'0'));
    witem.AddPair('cstpis',ifthen(Length(trim(IWEDITCSTPIS.Text))>0,IWEDITCSTPIS.Text,'null'));
    witem.AddPair('cstcofins',ifthen(Length(trim(IWEDITCSTCOFINS.Text))>0,IWEDITCSTCOFINS.Text,'null'));

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

    wJsonToSend := TStringStream.Create(witem.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/'+inttostr(UserSession.FIdOrcamento)+'/itens/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);

    PopulaCamposOrcamento(UserSession.FIdOrcamento);
    wret        := true;

  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao alterar item'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;


function TF_Orcamento.ExcluiOrcamento(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao excluir orçamento'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Orcamento.ExcluiOrcamentoItem(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/'+inttostr(UserSession.FIdOrcamento)+'/itens/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao excluir item'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;


function TF_Orcamento.RetornaRegistros(XRecurso,XCampo,XValor: string): TFDMemTable;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONArray;
    wmtRegistro: TFDMemTable;

begin
  try
    wmtRegistro      := TFDMemTable.Create(nil);
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/'+XRecurso+'?'+XCampo+'='+XValor+'&limit=2';
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;
// Transforma o JSONArray em DataSet
    wmtRegistro.LoadFromJSON(wjson);
    if not wmtRegistro.Active then
       wmtRegistro.Open;
  except
//    On E: Exception do
//    begin
//      WebApplication.ShowMessage('Problema ao localizar pessoa'+slinebreak+E.Message);
//    end;
  end;
  Result := wmtRegistro;
end;

procedure TF_Orcamento.CarregaObservacao(XJSON: TJSONObject);
var wobs: string;
begin
  try
    wobs     := ifthen(XJSON.GetValue('observacao').Value='null','',XJSON.GetValue('observacao').Value);
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaObservacao('+QuotedStr(wobs)+');');
  finally
  end;
end;

function TF_Orcamento.IncluiOrcamento: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wpessoa,JObj: TJSONObject;
begin
  try
    wpessoa := TJSONObject.Create;
    wpessoa.AddPair('idcliente',ifthen(Length(trim(IWEDITNOMECLIENTE.Text))>0,inttostr(IWEDITNOMECLIENTE.Tag),'null'));
    wpessoa.AddPair('idvendedor',ifthen(Length(trim(IWEDITNOMEVENDEDOR.Text))>0,inttostr(IWEDITNOMEVENDEDOR.Tag),'null'));
    wpessoa.AddPair('idcondicao',ifthen(Length(trim(IWEDITCONDICAOPAGAMENTO.Text))>0,inttostr(IWEDITCONDICAOPAGAMENTO.Tag),'null'));
    wpessoa.AddPair('idcobranca',ifthen(Length(trim(IWEDITDOCUMENTOCOBRANCA.Text))>0,inttostr(IWEDITDOCUMENTOCOBRANCA.Tag),'null'));
    wpessoa.AddPair('dataemissao',ifthen(Length(trim(IWEDITDATAEMISSAO.Text))>0,IWEDITDATAEMISSAO.Text,'null'));
    wpessoa.AddPair('observacao',ifthen(Length(trim(IWEDITOBSERVACAO.Text))>0,IWEDITOBSERVACAO.Text,'null'));

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

    wJsonToSend := TStringStream.Create(wpessoa.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    JObj        := TJSONObject.ParseJSONValue(wretorno) as TJSONObject;
    if strtointdef(JObj.GetValue('id').Value,0)>0 then
       begin
         wret   := true;
         PopulaCamposOrcamento(strtointdef(JObj.GetValue('id').Value,0));
       end
    else
       wret     := false;

//    WebApplication.ShowMessage('Código Fiscal incluído com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao incluir orçamento'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Orcamento.IncluiOrcamentoItem: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    witem,JObj: TJSONObject;
    wpercdesconto,wquantidade,wunitario,wvaldesconto,wbaseicms,wvalicms,wpercpis,wperccofins,wvalpis,wpercbasepis,wvalcofins,wpercbasecofins: string;
begin
  try
    wquantidade     := StringReplace(IWEDITQUANTIDADE.Text,'.','',[rfReplaceAll]);
    wunitario       := StringReplace(IWEDITUNITARIO.Text,'.','',[rfReplaceAll]);
    wpercdesconto   := StringReplace((StringReplace(IWEDITPERCDESCONTO.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wvaldesconto    := StringReplace(IWEDITVALORDESCONTO.Text,'.','',[rfReplaceAll]);
    wbaseicms       := StringReplace(IWEDITBASEICMS.Text,'.','',[rfReplaceAll]);
    wvalicms        := StringReplace(IWEDITVALORICMS.Text,'.','',[rfReplaceAll]);
    wpercpis        := StringReplace((StringReplace(IWEDITALIQPIS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wperccofins     := StringReplace((StringReplace(IWEDITALIQCOFINS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wvalpis         := StringReplace(IWEDITVALORPIS.Text,'.','',[rfReplaceAll]);
    wpercbasepis    := StringReplace((StringReplace(IWEDITBASEPIS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);
    wvalcofins      := StringReplace(IWEDITVALORCOFINS.Text,'.','',[rfReplaceAll]);
    wpercbasecofins := StringReplace((StringReplace(IWEDITBASECOFINS.Text,'%','',[rfReplaceAll])),'.','',[rfReplaceAll]);

    witem := TJSONObject.Create;
    witem.AddPair('idproduto',ifthen(Length(trim(IWEDITCODIGO.Text))>0,inttostr(IWEDITCODIGO.Tag),'0'));
    witem.AddPair('quantidade',ifthen(Length(trim(wquantidade))>0,wquantidade,'0'));
    witem.AddPair('valorunitario',ifthen(Length(trim(wunitario))>0,wunitario,'0'));
    witem.AddPair('percentualdesconto',ifthen(Length(trim(wpercdesconto))>0,wpercdesconto,'0'));
    witem.AddPair('valordesconto',ifthen(Length(trim(wvaldesconto))>0,wvaldesconto,'0'));
    witem.AddPair('baseicms',ifthen(Length(trim(wbaseicms))>0,wbaseicms,'0'));
    witem.AddPair('valoricms',ifthen(Length(trim(wvalicms))>0,wvalicms,'0'));
    witem.AddPair('percentualpis',ifthen(Length(trim(wpercpis))>0,wpercpis,'0'));
    witem.AddPair('percentualcofins',ifthen(Length(trim(wperccofins))>0,wperccofins,'0'));
    witem.AddPair('valorpis',ifthen(Length(trim(wvalpis))>0,wvalpis,'0'));
    witem.AddPair('valorcofins',ifthen(Length(trim(wvalcofins))>0,wvalcofins,'0'));
    witem.AddPair('percentualbasepis',ifthen(Length(trim(wpercbasepis))>0,wpercbasepis,'0'));
    witem.AddPair('percentualbasecofins',ifthen(Length(trim(wpercbasecofins))>0,wpercbasecofins,'0'));
    witem.AddPair('idaliquota',ifthen(Length(trim(IWEDITALIQICMS.Text))>0,inttostr(IWEDITALIQICMS.Tag),'0'));
    witem.AddPair('idsituacaotributaria',ifthen(Length(trim(IWEDITCFOP.Text))>0,inttostr(IWEDITCFOP.Tag),'0'));
    witem.AddPair('cstpis',ifthen(Length(trim(IWEDITCSTPIS.Text))>0,IWEDITCSTPIS.Text,'null'));
    witem.AddPair('cstcofins',ifthen(Length(trim(IWEDITCSTCOFINS.Text))>0,IWEDITCSTCOFINS.Text,'null'));

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

    wJsonToSend := TStringStream.Create(witem.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/orcamentos/'+inttostr(UserSession.FIdOrcamento)+'/itens';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    JObj        := TJSONObject.ParseJSONValue(wretorno) as TJSONObject;
    if strtointdef(JObj.GetValue('id').Value,0)>0 then
       begin
         wret   := true;
         PopulaCamposOrcamento(UserSession.FIdOrcamento);
         PopulaCamposItem(strtointdef(JObj.GetValue('id').Value,0));
       end
    else
       wret     := false;

//    WebApplication.ShowMessage('Código Fiscal incluído com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao incluir item'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;


procedure TF_Orcamento.CalculaTotal(XTipo: string);
var wvaltotal,wvalunitario,wqtde,wvaldesconto,wpercdesconto,wpercbaseicm,wvalbaseicm,wpercicm,wvalicm,wpercbasepis,wpercbasecofins,wvalbasepis,wvalbasecofins,wvalpis,wvalcofins,wpercpis,wperccofins: double;
    werro: string;
begin
  try
    wvalunitario  := strtofloatdef(IWEDITUNITARIO.Text,0);
    wqtde         := strtofloatdef(IWEDITQUANTIDADE.Text,0);
    wpercdesconto := StrToFloatDef(UserSession.FJSONOrcamento.GetValue('xdesccondicao').Value,0);
    wvaldesconto  := ((wvalunitario * wqtde) * wpercdesconto)/100;

    if XTipo='item' then
       begin
         if UserSession.FMemTableOrcamentoItem.FieldByName('baseicms').IsNull then
            wvalbaseicm  := 0
         else
            wvalbaseicm   := UserSession.FMemTableOrcamentoItem.FieldByName('baseicms').AsFloat;
         if UserSession.FMemTableOrcamentoItem.FieldByName('percentualicms').IsNull then
            wpercicm      := 0
         else
            wpercicm      := UserSession.FMemTableOrcamentoItem.FieldByName('percentualicms').AsFloat;
         if UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasepis').IsNull then
            wpercbasepis  := 0
         else
            wpercbasepis  := UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasepis').AsFloat;
         wvalbasepis   := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasepis)/100;

         if UserSession.FMemTableOrcamentoItem.FieldByName('xpercpis').IsNull then
            wpercpis      := 0
         else
            wpercpis      := UserSession.FMemTableOrcamentoItem.FieldByName('xpercpis').AsFloat;

         if UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasecofins').IsNull then
            wpercbasecofins := 0
         else
            wpercbasecofins := UserSession.FMemTableOrcamentoItem.FieldByName('percentualbasecofins').AsFloat;
         wvalbasecofins  := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasecofins)/100;

         if UserSession.FMemTableOrcamentoItem.FieldByName('xperccofins').IsNull then
            wperccofins     := 0
         else
            wperccofins     := UserSession.FMemTableOrcamentoItem.FieldByName('xperccofins').AsFloat;
       end
    else
       begin
         if UserSession.FMemTableProdutoHelp.FieldByName('xbaseicm').IsNull then
            wpercbaseicm  := 0
         else
            wpercbaseicm  := UserSession.FMemTableProdutoHelp.FieldByName('xbaseicm').AsFloat;
         wvalbaseicm   := (((wvalunitario * wqtde) - wvaldesconto) * wpercbaseicm)/100;
         if UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').IsNull then
            wpercicm      := 0
         else
            wpercicm      := UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').AsFloat;

         if UserSession.FMemTableProdutoHelp.FieldByName('basepissaida').IsNull then
            wpercbasepis  := 0
         else
            wpercbasepis  := UserSession.FMemTableProdutoHelp.FieldByName('basepissaida').AsFloat;
         wvalbasepis   := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasepis)/100;
         if UserSession.FMemTableProdutoHelp.FieldByName('xpercpis').IsNull then
            wpercpis      := 0
         else
            wpercpis      := UserSession.FMemTableProdutoHelp.FieldByName('xpercpis').AsFloat;

         if UserSession.FMemTableProdutoHelp.FieldByName('basecofinssaida').IsNull then
            wpercbasecofins := 0
         else
            wpercbasecofins := UserSession.FMemTableProdutoHelp.FieldByName('basecofinssaida').AsFloat;
         wvalbasecofins  := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasecofins)/100;
         if UserSession.FMemTableProdutoHelp.FieldByName('xperccofins').IsNull then
            wperccofins     := 0
         else
            wperccofins     := UserSession.FMemTableProdutoHelp.FieldByName('xperccofins').AsFloat;
       end;

    wvalicm       := (wvalbaseicm * wpercicm)/100;
    wvalpis       := (wvalbasepis * wpercpis)/100;
    wvalcofins    := (wvalbasecofins * wperccofins)/100;

    wvaltotal     := (wvalunitario * wqtde) - wvaldesconto;

    IWEDITVALORDESCONTO.Text := FormatFloat('#,0.00',wvaldesconto);
    IWEDITBASEICMS.Text      := FormatFloat('#,0.00',wvalbaseicm);
    IWEDITVALORICMS.Text     := FormatFloat('#,0.00',wvalicm);
    IWEDITVALORPIS.Text      := FormatFloat('#,0.00',wvalpis);
    IWEDITVALORCOFINS.Text   := FormatFloat('#,0.00',wvalcofins);
    IWEDITVALORTOTAL.Text    := FormatFloat('#,0.00',wvaltotal);

  except
    On E: Exception do
    begin
      werro := E.Message;
    end;

  end;
end;

procedure TF_Orcamento.CarregaCamposProduto(XIdProduto: integer);
begin
  try
     UserSession.FMemTableProdutoHelp.Filtered := false;
     UserSession.FMemTableProdutoHelp.Filter   := 'id='+inttostr(XIdProduto);
     UserSession.FMemTableProdutoHelp.Filtered := true;
     IWEDITCODIGO.Text     := UserSession.FMemTableProdutoHelp.FieldByName('codigo').AsString;
     IWEDITCODIGO.Tag      := UserSession.FMemTableProdutoHelp.FieldByName('id').AsInteger;
     IWEDITDESCRICAO.Text  := UserSession.FMemTableProdutoHelp.FieldByName('descricao').AsString;
     IWEDITDESCRICAO.Tag   := UserSession.FMemTableProdutoHelp.FieldByName('id').AsInteger;
     IWEDITUNIDADE.Text    := UserSession.FMemTableProdutoHelp.FieldByName('unidade').AsString;
     IWEDITUNITARIO.Text   := formatfloat('#,0.00',IfThen(UserSession.FMemTableProdutoHelp.FieldByName('preco1').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('preco1').AsFloat));
     IWEDITCSTICMS.Text    := UserSession.FMemTableProdutoHelp.FieldByName('xsituacaotributaria').AsString;
     IWEDITCSTICMS.Tag     := UserSession.FMemTableProdutoHelp.FieldByName('idsituacaotributaria').AsInteger;
     IWEDITCEAN.Text       := UserSession.FMemTableProdutoHelp.FieldByName('cean').AsString;
     if UserSession.FMemTableProdutoHelp.FieldByName('incidest').AsBoolean then
        begin
          IWEDITCFOP.Text    := UserSession.FJSONOrcamento.GetValue('xcfopstcondicao').Value;
          IWEDITCFOP.Tag     := strtointdef(UserSession.FJSONOrcamento.GetValue('xidcfopstcondicao').Value,0);
        end
     else
        begin
          IWEDITCFOP.Text    := UserSession.FJSONOrcamento.GetValue('xcfopcondicao').Value;
          IWEDITCFOP.Tag     := strtointdef(UserSession.FJSONOrcamento.GetValue('xidcfopcondicao').Value,0);
        end;
     IWEDITCODALIQICMS.Text  := UserSession.FMemTableProdutoHelp.FieldByName('xcodaliquotaicm').AsString;
     IWEDITCODALIQICMS.Tag   := UserSession.FMemTableProdutoHelp.FieldByName('idaliquota').AsInteger;
     IWEDITALIQICMS.Text     := formatfloat('#,0.00%',ifthen(UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').AsFloat));
     IWEDITALIQICMS.Tag      := UserSession.FMemTableProdutoHelp.FieldByName('idaliquota').AsInteger;
     IWEDITCSTPIS.Text       := UserSession.FMemTableProdutoHelp.FieldByName('cstpissaida').AsString;
     IWEDITCSTCOFINS.Text    := UserSession.FMemTableProdutoHelp.FieldByName('cstcofinssaida').AsString;
     IWEDITPERCDESCONTO.Text := FormatFloat('#,0.00%',strtofloat(UserSession.FJSONOrcamento.GetValue('xdesccondicao').Value));
     IWEDITBASEICMS.Text     := formatfloat('#,0.00%',ifthen(UserSession.FMemTableProdutoHelp.FieldByName('xbaseicm').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('xbaseicm').AsFloat));
     IWEDITALIQPIS.Text      := formatfloat('#,0.00%',ifthen(UserSession.FMemTableProdutoHelp.FieldByName('xpercpis').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('xpercpis').AsFloat));
     IWEDITALIQCOFINS.Text   := formatfloat('#,0.00%',IfThen(UserSession.FMemTableProdutoHelp.FieldByName('xperccofins').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('xperccofins').AsFloat));
     IWEDITBASEPIS.Text      := formatfloat('#,0.00%',IfThen(UserSession.FMemTableProdutoHelp.FieldByName('basepissaida').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('basepissaida').AsFloat));
     IWEDITBASECOFINS.Text   := formatfloat('#,0.00%',IfThen(UserSession.FMemTableProdutoHelp.FieldByName('basecofinssaida').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('basecofinssaida').AsFloat));
     IWEDITQUANTIDADE.Text   := '1,000';

     // Calcula Totais
     CalculaTotal('produto');
  except

  end;
end;
end.
