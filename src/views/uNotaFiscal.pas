unit uNotaFiscal;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IWCompEdit, Vcl.Controls, IWVCLBaseControl, System.Math,
  IniFiles, System.JSON, IWHTMLTag, IdAuthentication, System.StrUtils,
  FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IWCompLabel;

type
  TF_NotaFiscal = class(TIWAppForm)
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IWEDITPEDIDO: TIWEdit;
    IWEDITIDNOTAFISCAL: TIWEdit;
    IWEDITDATAEMISSAO: TIWEdit;
    IWEDITNUMERODOCUMENTO: TIWEdit;
    IWEDITTOTAL: TIWEdit;
    IWEDITORIGEM: TIWEdit;
    IWEDITNOMECLIENTE: TIWEdit;
    IWEDITNOMEVENDEDOR: TIWEdit;
    IWEDITCONDICAOPAGAMENTO: TIWEdit;
    IWEDITDOCUMENTOCOBRANCA: TIWEdit;
    IWEDITOBSERVACAO: TIWEdit;
    IWEDITIDCLIENTE: TIWEdit;
    IWEDITIDREPRESENTANTE: TIWEdit;
    IWEDITIDCONDICAO: TIWEdit;
    IWEDITIDCOBRANCA: TIWEdit;
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
    IWEDITMODELO: TIWEdit;
    IWEDITESPECIE: TIWEdit;
    IWEDITSERIE: TIWEdit;
    IWEDITORDEMCOMPRA: TIWEdit;
    IWEDITORDEMSERVICO: TIWEdit;
    IWEDITCHAVENFE: TIWEdit;
    IWEDITDATASAIDA: TIWEdit;
    IWEDITHORASAIDA: TIWEdit;
    IWEDITIDVALIDACAO: TIWEdit;
    IWEDITNOMEALVO: TIWEdit;
    IWEDITCLASSIFICACAO: TIWEdit;
    IWEDITIDCLASSIFICACAO: TIWEdit;
    IWEDITIDALVO: TIWEdit;
    IWLabelArquivoXML: TIWLabel;
    IWLabelArquivoPDF: TIWLabel;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITPEDIDOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITNOMECLIENTEAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITNOMEVENDEDORAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCONDICAOPAGAMENTOAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITDOCUMENTOCOBRANCAAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITQUANTIDADEAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITUNITARIOAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
  private
    procedure PopulaCamposNotaFiscal(XId: integer);
    procedure CarregaObservacao(XJSON: TJSONObject);
    procedure LimpaCampos;
    function ConfirmaNotaFiscal(XId: integer): boolean;
    function ExcluiNotaFiscal(XId: integer): boolean;
    function RetornaRegistros(XRecurso, XCampo, XValor: string): TFDMemTable;
    function IncluiNotaFiscal: boolean;
    procedure PopulaCamposItem(XIdItem: integer);
    procedure LimpaCamposItens;
    function ExcluiNotaItem(XId: integer): boolean;
    function ConfirmaNotaItem(XId: integer): boolean;
    procedure CalculaTotal(XTipo: string);
    procedure CarregaCamposProduto(XIdProduto: integer);
    procedure CarregaSelect(XJSON: TJSONObject);
    function AutorizaNFe(XIdNota: integer): boolean;
    function ConsultaNotaAutorizada(XIdNota: integer): string;
    function RetornaXML(XChave: string): boolean;
    procedure SalvaArquivoXML(XChave: string; XStream: TMemoryStream);
    function RetornaPDF(XChave: string): boolean;
    procedure SalvaArquivoPDF(XChave: string; XStream: TMemoryStream);
    procedure MostraArquivoXML(XChave: string);
    procedure MostraArquivoPDF(XChave: string);
    function CancelaNFe(XIdNota: integer): boolean;
    procedure AcertaCorFonteElemento(XSituacao: string);
  public
  end;

implementation

{$R *.dfm}

uses ServerController, DataSet.Serialize;


procedure TF_NotaFiscal.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widnotafiscal,widcliente,widvendedor,widcondicao,widcobranca,widitem,widproduto,widespecie,widserie,widclassificacao: integer;
    wpagina,wcliente,wvendedor,wcondicao,wcobranca,wespecie,wserie,wclassificacao,wchave: string;
begin
  if pos('[AnulaNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       widnotafiscal := strtointdef(IWEDITID.Text,0);
       wpagina  := copy(IWEDITNOME.Text,pos('[AnulaNotaFiscal]',IWEDITNOME.Text)+17,10);
       if CancelaNFe(widnotafiscal) then
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNotas(25);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end
  else if pos('[RetornaXML]',IWEDITNOME.Text)>0 then
     begin
       wchave   := IWEDITID.Text;
       wpagina  := copy(IWEDITNOME.Text,pos('[RetornaXML]',IWEDITNOME.Text)+12,10);
//       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNFeAutorizadas(20);');
       if RetornaXML(wchave) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            MostraArquivoXML(wchave);
          end;
     end
  else if pos('[RetornaPDF]',IWEDITNOME.Text)>0 then
     begin
       wchave   := IWEDITID.Text;
       MostraArquivoPDF(wchave);
{       wpagina  := copy(IWEDITNOME.Text,pos('[RetornaPDF]',IWEDITNOME.Text)+12,10);
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaNotas(25);');
       if RetornaPDF(wchave) then
          begin
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            MostraArquivoPDF(wchave);
          end;}
     end
  else if pos('[AutorizaNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       widnotafiscal := strtointdef(IWEDITIDNOTAFISCAL.Text,0);
       wpagina    := copy(IWEDITNOME.Text,pos('[AutorizaNotaFiscal]',IWEDITNOME.Text)+20,10);
       if AutorizaNFe(widnotafiscal) then
         begin
           WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
           PopulaCamposNotaFiscal(widnotafiscal);
         end
       else
         begin
           WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
           WebApplication.ShowMessage('Problema na autorização da Nota Fiscal!');
         end;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
     end
  else if pos('[LimpaNotaFiscal]',IWEDITNOME.Text)>0 then
     LimpaCampos
  else if pos('[CalculaTotal]',IWEDITNOME.Text)>0 then
     begin
       if UserSession.FIdNotaItem>0 then
          CalculaTotal('item')
       else
          CalculaTotal('produto');
     end
  else if pos('[CarregaNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       widnotafiscal  := strtointdef(IWEDITID.Text,0);
       PopulaCamposNotaFiscal(widnotafiscal);
     end
  else if pos('[AlteraNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       IWEDITDATAEMISSAO.SetFocus;
     end
  else if pos('[CancelaNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       widnotafiscal  := strtointdef(IWEDITIDNOTAFISCAL.Text,0);
       if widnotafiscal>0 then
          PopulaCamposNotaFiscal(widnotafiscal)
       else
          LimpaCampos;
     end
  else if pos('[ConfirmaNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       widnotafiscal := strtointdef(IWEDITIDNOTAFISCAL.Text,0);
       wpagina    := copy(IWEDITNOME.Text,pos('[ConfirmaNotaFiscal]',IWEDITNOME.Text)+20,10);
       if widnotafiscal>0 then
          begin
            if ConfirmaNotaFiscal(widnotafiscal) then
               begin
                 PopulaCamposNotaFiscal(widnotafiscal);
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiNotaFiscal then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[IncluiNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       LimpaCampos;
       UserSession.FIdNotaFiscal := 0;
//       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(10);');
       PopulaCamposNotaFiscal(0);
       IWEDITDATAEMISSAO.Text := FormatDateTime('dd/mm/yyyy',date);
       IWEDITORIGEM.Text      := 'TS-Fature';
       IWEDITDATAEMISSAO.SetFocus;
     end
  else if pos('[ExcluiNotaFiscal]',IWEDITNOME.Text)>0 then
     begin
       widnotafiscal := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiNotaFiscal]',IWEDITNOME.Text)+18,10);
       if ExcluiNotaFiscal(widnotafiscal) then
          begin
            LimpaCampos;
            PopulaCamposNotaFiscal(0);
            WebApplication.CallBackResponse.AddJavaScriptToExecute('desabilitaEdicao();');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[HelpCliente]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTipoHelpCliente := copy(IWEDITNOME.Text,pos('[HelpCliente]',IWEDITNOME.Text)+13,100);
       if UserSession.FTipoHelpCliente = 'cliente' then
          UserSession.FClienteNota := ''
       else
          UserSession.FAlvoNota := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClientes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCliente'').modal(''show'');');
     end
  else if pos('[SelecionaCliente]',IWEDITNOME.Text)>0 then
     begin
       widcliente := strtointdef(IWEDITIDCLIENTE.Text,0);
       wcliente   := copy(IWEDITNOME.Text,pos('[SelecionaCliente]',IWEDITNOME.Text)+18,100);
       if UserSession.FTipoHelpCliente='cliente' then
          begin
            IWEDITNOMECLIENTE.Text    := wcliente;
            IWEDITNOMECLIENTE.Tag     := widcliente;
            UserSession.FClienteNota  := wcliente;
          end
       else
          begin
            IWEDITNOMEALVO.Text    := wcliente;
            IWEDITNOMEALVO.Tag     := widcliente;
            UserSession.FAlvoNota  := wcliente;
          end;
     end
  else if pos('[HelpVendedor]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FVendedorNota := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaVendedores(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalVendedor'').modal(''show'');');
     end
  else if pos('[HelpProduto]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTipoHelpProduto := copy(IWEDITNOME.Text,pos('[HelpProduto]',IWEDITNOME.Text)+13,100);
       if UserSession.FTipoHelpProduto='codigo' then
          UserSession.FCodProdutoNotaItem := ''
       else if UserSession.FTipoHelpProduto='descricao' then
          UserSession.FDescProdutoNotaItem := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaProdutos(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalProduto'').modal(''show'');');
     end
  else if pos('[HelpValidacao]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTipoHelpValidacao := copy(IWEDITNOME.Text,pos('[HelpValidacao]',IWEDITNOME.Text)+15,100);
       if UserSession.FTipoHelpValidacao='especie' then
          UserSession.FEspecieNota := ''
       else if UserSession.FTipoHelpProduto='serie' then
          UserSession.FSerieNota := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaValidacoes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalValidacao'').modal(''show'');');
     end
  else if pos('[SelecionaRepresentante]',IWEDITNOME.Text)>0 then
     begin
       widvendedor := strtointdef(IWEDITIDREPRESENTANTE.Text,0);
       wvendedor   := copy(IWEDITNOME.Text,pos('[SelecionaRepresentante]',IWEDITNOME.Text)+24,100);
       IWEDITNOMEVENDEDOR.Text   := wvendedor;
       IWEDITNOMEVENDEDOR.Tag    := widvendedor;
       UserSession.FVendedorNota := wvendedor;
     end
  else if pos('[SelecionaValidacao]',IWEDITNOME.Text)>0 then
     begin
       if UserSession.FTipoHelpValidacao='especie' then
          begin
            widespecie := strtointdef(IWEDITIDVALIDACAO.Text,0);
            wespecie   := copy(IWEDITNOME.Text,pos('[SelecionaValidacao]',IWEDITNOME.Text)+20,100);
            IWEDITESPECIE.Text   := wespecie;
            IWEDITESPECIE.Tag    := widespecie;
            UserSession.FEspecieNota := wespecie;
          end
       else if UserSession.FTipoHelpValidacao='serie' then
          begin
            widserie := strtointdef(IWEDITIDVALIDACAO.Text,0);
            wserie   := copy(IWEDITNOME.Text,pos('[SelecionaValidacao]',IWEDITNOME.Text)+20,100);
            IWEDITSERIE.Text   := wserie;
            IWEDITSERIE.Tag    := widserie;
            UserSession.FSerieNota := wserie;
          end;
     end
  else if pos('[SelecionaProduto]',IWEDITNOME.Text)>0 then
     begin
       widproduto := strtointdef(IWEDITIDPRODUTO.Text,0);
       CarregaCamposProduto(widproduto);
     end
  else if pos('[HelpCondicao]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCondicaoNota := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCondicoes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCondicao'').modal(''show'');');
     end
  else if pos('[SelecionaCondicao]',IWEDITNOME.Text)>0 then
     begin
       widcondicao := strtointdef(IWEDITIDCONDICAO.Text,0);
       wcondicao   := copy(IWEDITNOME.Text,pos('[SelecionaCondicao]',IWEDITNOME.Text)+19,100);
       IWEDITCONDICAOPAGAMENTO.Text   := wcondicao;
       IWEDITCONDICAOPAGAMENTO.Tag    := widcondicao;
       UserSession.FCondicaoNota      := wcondicao;
     end
  else if pos('[HelpCobranca]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCobrancaNota := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCobrancas(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCobranca'').modal(''show'');');
     end
  else if pos('[SelecionaCobranca]',IWEDITNOME.Text)>0 then
     begin
       widcobranca := strtointdef(IWEDITIDCOBRANCA.Text,0);
       wcobranca   := copy(IWEDITNOME.Text,pos('[SelecionaCobranca]',IWEDITNOME.Text)+19,100);
       IWEDITDOCUMENTOCOBRANCA.Text   := wcobranca;
       IWEDITDOCUMENTOCOBRANCA.Tag    := widcobranca;
       UserSession.FCobrancaNota      := wcobranca;
     end
  else if pos('[HelpClassificacao]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FClassificacaoNota := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClassificacoes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalClassificacao'').modal(''show'');');
     end
  else if pos('[SelecionaClassificacao]',IWEDITNOME.Text)>0 then
     begin
       widclassificacao := strtointdef(IWEDITIDCLASSIFICACAO.Text,0);
       wclassificacao   := copy(IWEDITNOME.Text,pos('[SelecionaClassificacao]',IWEDITNOME.Text)+24,100);
       IWEDITCLASSIFICACAO.Text   := wclassificacao;
       IWEDITCLASSIFICACAO.Tag    := widclassificacao;
       UserSession.FClassificacaoNota := wclassificacao;
     end
  else if pos('[AlteraItem]',IWEDITNOME.Text)>0 then
     begin
       widitem := strtointdef(IWEDITID.Text,0);
       PopulaCamposItem(widitem);
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#itensNota'').hide();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#itemNota'').show();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCODIGO'').focus();');
     end
  else if pos('[ExcluiItem]',IWEDITNOME.Text)>0 then
     begin
       widitem  := strtointdef(IWEDITID.Text,0);
       wpagina  := copy(IWEDITNOME.Text,pos('[ExcluiItem]',IWEDITNOME.Text)+12,10);
       if ExcluiNotaItem(widitem) then
          begin
            LimpaCamposItens;
            PopulaCamposNotaFiscal(UserSession.FIdNotaFiscal);
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina2('+wpagina+');');
          end;
     end
  else if pos('[ConfirmaItem]',IWEDITNOME.Text)>0 then
     begin
       if (UserSession.FIdNotaItem>0) and (ConfirmaNotaItem(UserSession.FIdNotaItem)) then
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');')
//       else if (UserSession.FIdNotaItem=0) and (IncluiNotaItem) then
//          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');')
       else
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
     end;
end;

procedure TF_NotaFiscal.IWEDITCONDICAOPAGAMENTOAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCondicao: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCondicaoNota<>IWEDITCONDICAOPAGAMENTO.Text then
     begin
       UserSession.FCondicaoNota := IWEDITCONDICAOPAGAMENTO.Text;
       wmtCondicao := RetornaRegistros('condicoes','descricao',IWEDITCONDICAOPAGAMENTO.Text);
       if wmtCondicao.RecordCount=1 then
          begin
            IWEDITCONDICAOPAGAMENTO.Text := wmtCondicao.FieldByName('descricao').AsString;
            IWEDITCONDICAOPAGAMENTO.Tag  := wmtCondicao.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCondicao.RecordCount=0 then
               UserSession.FCondicaoNota := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCondicoes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCondicao'').modal(''show'');');
          end;
     end;
end;

procedure TF_NotaFiscal.IWEDITDOCUMENTOCOBRANCAAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCobranca: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCobrancaNota<>IWEDITDOCUMENTOCOBRANCA.Text then
     begin
       UserSession.FCobrancaNota := IWEDITDOCUMENTOCOBRANCA.Text;
       wmtCobranca := RetornaRegistros('cobrancas','nome',IWEDITDOCUMENTOCOBRANCA.Text);
       if wmtCobranca.RecordCount=1 then
          begin
            IWEDITDOCUMENTOCOBRANCA.Text := wmtCobranca.FieldByName('nome').AsString;
            IWEDITDOCUMENTOCOBRANCA.Tag  := wmtCobranca.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCobranca.RecordCount=0 then
               UserSession.FCobrancaNota := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCobrancas(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCobranca'').modal(''show'');');
          end;
     end;
end;

procedure TF_NotaFiscal.IWEDITNOMECLIENTEAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCliente: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FClienteNota<>IWEDITNOMECLIENTE.Text then
     begin
       UserSession.FClienteNota := IWEDITNOMECLIENTE.Text;
       wmtCliente := RetornaRegistros('pessoas','nome',IWEDITNOMECLIENTE.Text);
       if wmtCliente.RecordCount=1 then
          begin
            IWEDITNOMECLIENTE.Text := wmtCliente.FieldByName('nome').AsString;
            IWEDITNOMECLIENTE.Tag  := wmtCliente.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCliente.RecordCount=0 then
               UserSession.FClienteNota := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClientes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCliente'').modal(''show'');');
          end;
     end;
//  IWEDITCEPPESSOA.SetFocus;
end;

procedure TF_NotaFiscal.IWEDITNOMEVENDEDORAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtVendedor: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FVendedorNota<>IWEDITNOMEVENDEDOR.Text then
     begin
       UserSession.FVendedorNota := IWEDITNOMEVENDEDOR.Text;
       wmtVendedor := RetornaRegistros('pessoas','nome',IWEDITNOMEVENDEDOR.Text);
       if wmtVendedor.RecordCount=1 then
          begin
            IWEDITNOMEVENDEDOR.Text := wmtVendedor.FieldByName('nome').AsString;
            IWEDITNOMEVENDEDOR.Tag  := wmtVendedor.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtVendedor.RecordCount=0 then
               UserSession.FVendedorNota := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaVendedores(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalVendedor'').modal(''show'');');
          end;
     end;
end;

procedure TF_NotaFiscal.IWEDITPEDIDOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_NotaFiscal.IWEDITQUANTIDADEAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  IWEDITCODIGO.SetFocus;
end;

procedure TF_NotaFiscal.IWEDITUNITARIOAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar: string;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  IWEDITQUANTIDADE.SetFocus;
end;

procedure TF_NotaFiscal.PopulaCamposNotaFiscal(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wTag: TIWHTMLTag;
begin
  try
    WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaModelo();');
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
          URL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(XId);
          wretjson := wIdHTTP.Get(URL);
          wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
          UserSession.FJSONNotaFiscal := wjson;

          IWEDITIDNOTAFISCAL.Text           := wjson.GetValue('id').Value;
          IWEDITPEDIDO.Text                 := wjson.GetValue('pedido').Value;
          IWEDITPEDIDO.Tag                  := strtointdef(wjson.GetValue('id').Value,0);
          IWEDITNUMERODOCUMENTO.Text        := ifthen(wjson.GetValue('numerodocumento').Value='null','',wjson.GetValue('numerodocumento').Value);
          IWEDITORIGEM.Text                 := ifthen(wjson.GetValue('moduloorigem').Value='null','',wjson.GetValue('moduloorigem').Value);
          IWEDITDATAEMISSAO.Text            := ifthen(wjson.GetValue('dataemissao').Value='null','',formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('dataemissao').Value)));
          IWEDITESPECIE.Text                := ifthen(wjson.GetValue('xespecie').Value='null','',wjson.GetValue('xespecie').Value);
          IWEDITESPECIE.Tag                 := strtoint(ifthen(wjson.GetValue('xespecie').Value='null','0',wjson.GetValue('idespecie').Value));
          IWEDITSERIE.Text                  := ifthen(wjson.GetValue('xserie').Value='null','',wjson.GetValue('xserie').Value);
          IWEDITSERIE.Tag                   := strtoint(ifthen(wjson.GetValue('xserie').Value='null','0',wjson.GetValue('idseriesubserie').Value));
          IWEDITORDEMSERVICO.Text           := ifthen(wjson.GetValue('ordemservico').Value='null','',wjson.GetValue('ordemservico').Value);
          IWEDITORDEMCOMPRA.Text            := ifthen(wjson.GetValue('ordemcompracliente').Value='null','',wjson.GetValue('ordemcompracliente').Value);
          IWEDITDATASAIDA.Text              := ifthen(wjson.GetValue('datasaida').Value='null','',formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datasaida').Value)));
          IWEDITHORASAIDA.Text              := ifthen(wjson.GetValue('horasaida').Value='null','',wjson.GetValue('horasaida').Value);
          IWEDITCHAVENFE.Text               := ifthen(wjson.GetValue('chavenfe').Value='null','',wjson.GetValue('chavenfe').Value);
          IWEDITMODELO.Text                 := ifthen(wjson.GetValue('modelodocumentofiscal').Value='null','',wjson.GetValue('modelodocumentofiscal').Value);

          if (wjson.GetValue('totalnota').Value='0') or (wjson.GetValue('totalnota').Value='null') then
             IWEDITTOTAL.Text               := '0.00'
          else
             IWEDITTOTAL.Text               := formatfloat('#,0.00',strtofloat(wjson.GetValue('totalnota').Value));

          IWEDITNOMECLIENTE.Text            := ifthen(wjson.GetValue('xcliente').Value='null','',wjson.GetValue('xcliente').Value);
          IWEDITNOMECLIENTE.Tag             := strtoint(ifthen(wjson.GetValue('xcliente').Value='null','0',wjson.GetValue('idcliente').Value));
          IWEDITNOMEALVO.Text               := ifthen(wjson.GetValue('xalvo').Value='null','',wjson.GetValue('xalvo').Value);
          IWEDITNOMEALVO.Tag                := strtoint(ifthen(wjson.GetValue('xalvo').Value='null','0',wjson.GetValue('idalvo').Value));
          IWEDITNOMEVENDEDOR.Text           := ifthen(wjson.GetValue('xvendedor').Value='null','',wjson.GetValue('xvendedor').Value);
          IWEDITNOMEVENDEDOR.Tag            := strtoint(ifthen(wjson.GetValue('xvendedor').Value='null','0',wjson.GetValue('idvendedor').Value));
          IWEDITCONDICAOPAGAMENTO.Text      := ifthen(wjson.GetValue('xcondicao').Value='null','',wjson.GetValue('xcondicao').Value);
          IWEDITCONDICAOPAGAMENTO.Tag       := strtoint(ifthen(wjson.GetValue('xcondicao').Value='null','0',wjson.GetValue('idcondicao').Value));
          IWEDITDOCUMENTOCOBRANCA.Text      := ifthen(wjson.GetValue('xcobranca').Value='null','',wjson.GetValue('xcobranca').Value);
          IWEDITDOCUMENTOCOBRANCA.Tag       := strtoint(ifthen(wjson.GetValue('xcobranca').Value='null','0',wjson.GetValue('iddocumentocobranca').Value));
          IWEDITCLASSIFICACAO.Text          := ifthen(wjson.GetValue('xclassificacao').Value='null','',wjson.GetValue('xclassificacao').Value);
          IWEDITCLASSIFICACAO.Tag           := strtoint(ifthen(wjson.GetValue('xclassificacao').Value='null','0',wjson.GetValue('idclassificacaoreceitadespesa').Value));
          CarregaObservacao(wjson);
          CarregaSelect(wjson);
          AcertaCorFonteElemento(wjson.GetValue('situacao').Value);

          if wjson.GetValue('situacao').Value='A' then
             begin
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#situacaonota'').show();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONALTERA'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONEXCLUI'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONNOVOITEM'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONPARCELA'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONOUTROS'').hide();');
             end
          else if length(trim(wjson.GetValue('chavenfe').Value))>0 then // Nota autorizada
             begin
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONALTERA'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONNOVOITEM'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONPARCELA'').show();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONOUTROS'').show();');
             end
          else
             begin
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#situacaonota'').hide();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONALTERA'').show();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONEXCLUI'').show();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONNOVOITEM'').show();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONPARCELA'').show();');
               WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWBUTTONOUTROS'').show();');
             end;

          UserSession.FIdNotaFiscal         := strtoint(wjson.GetValue('id').Value);
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(10);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(10);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#divBotoes'').css(''display'',''block'');');
       end
    else
       begin
          UserSession.FIdNotaFiscal          := 0;
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCFOPS(0);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaItens(0);');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('montaObservacao('+QuotedStr('')+');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#divBotoes'').css(''display'',''none'');');
          WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectmodelo").val('+QuotedStr('99')+');');

       end;
//    CarregaGeral(wjson);
//    CarregaClassificacao(wjson);
//    CarregaOutros(wjson);
    IWEDITDATAEMISSAO.SetFocus;
  except
    on E: Exception do
    begin
      if XId>0 then
         WebApplication.ShowMessage('Problema ao popular campos da nota fiscal'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_NotaFiscal.CarregaObservacao(XJSON: TJSONObject);
var wobs: string;
begin
  try
    wobs     := ifthen(XJSON.GetValue('observacao').Value='null','',XJSON.GetValue('observacao').Value);
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaObservacao('+QuotedStr(wobs)+');');
  finally
  end;
end;

procedure TF_NotaFiscal.LimpaCampos;
begin
  try
    UserSession.FIdNotaFiscal        := 0;
    UserSession.FClienteNota         := '';
    UserSession.FVendedorNota        := '';
    UserSession.FCondicaoNota        := '';
    UserSession.FCobrancaNota        := '';
    UserSession.FCodProdutoNotaItem  := '';
    UserSession.FDescProdutoNotaItem := '';
    IWEDITIDNOTAFISCAL.Text          := '';
    IWEDITPEDIDO.Text                := '';
    IWEDITNUMERODOCUMENTO.Text       := '';
    IWEDITTOTAL.Text                 := '';
    IWEDITDATAEMISSAO.Text           := '';
    IWEDITNOMECLIENTE.Text           := '';
    IWEDITNOMECLIENTE.Tag            := 0;
    IWEDITCONDICAOPAGAMENTO.Text     := '';
    IWEDITCONDICAOPAGAMENTO.Tag      := 0;
    IWEDITDOCUMENTOCOBRANCA.Text     := '';
    IWEDITDOCUMENTOCOBRANCA.Tag      := 0;
    IWEDITNOMEVENDEDOR.Text          := '';
    IWEDITNOMEVENDEDOR.Tag           := 0;
    IWEDITNOMEALVO.Text              := '';
    IWEDITNOMEALVO.Tag               := 0;
    IWEDITCLASSIFICACAO.Text         := '';
    IWEDITCLASSIFICACAO.Tag          := 0;
    IWEDITORIGEM.Text                := '';
    IWEDITDATASAIDA.Text             := '';
    IWEDITHORASAIDA.Text             := '';
    IWEDITORDEMCOMPRA.Text           := '';
    IWEDITORDEMSERVICO.Text          := '';
    IWEDITCHAVENFE.Text              := '';
    IWEDITESPECIE.Text               := '';
    IWEDITSERIE.Text                 := '';
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaObservacao('+QuotedStr('')+');');
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#selectmodelo'').empty();');
    AcertaCorFonteElemento('');
  finally

  end;
end;

function TF_NotaFiscal.ConfirmaNotaFiscal(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno,wuf,wregiao: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wnota: TJSONObject;
begin
  try
    wnota := TJSONObject.Create;
    wnota.AddPair('dataemissao',ifthen(Length(trim(IWEDITDATAEMISSAO.Text))>0,IWEDITDATAEMISSAO.Text,FormatDateTime('dd/mm/yyyy',date)));
    wnota.AddPair('datasaida',ifthen(Length(trim(IWEDITDATASAIDA.Text))>0,IWEDITDATASAIDA.Text,FormatDateTime('dd/mm/yyyy',date)));
    wnota.AddPair('horasaida',ifthen(Length(trim(IWEDITHORASAIDA.Text))>0,IWEDITHORASAIDA.Text,'null'));
    wnota.AddPair('modelodocumentofiscal',ifthen(Length(trim(IWEDITMODELO.Text))>0,IWEDITMODELO.Text,'null'));
    wnota.AddPair('idcliente',ifthen(Length(trim(IWEDITNOMECLIENTE.Text))>0,inttostr(IWEDITNOMECLIENTE.Tag),'0'));
    wnota.AddPair('idalvo',ifthen(Length(trim(IWEDITNOMEALVO.Text))>0,inttostr(IWEDITNOMEALVO.Tag),'0'));
    wnota.AddPair('idcondicao',ifthen(Length(trim(IWEDITCONDICAOPAGAMENTO.Text))>0,inttostr(IWEDITCONDICAOPAGAMENTO.Tag),'0'));
    wnota.AddPair('idvendedor',ifthen(Length(trim(IWEDITNOMEVENDEDOR.Text))>0,inttostr(IWEDITNOMEVENDEDOR.Tag),'0'));
    wnota.AddPair('idcobranca',ifthen(Length(trim(IWEDITDOCUMENTOCOBRANCA.Text))>0,inttostr(IWEDITDOCUMENTOCOBRANCA.Tag),'0'));
    wnota.AddPair('idclassificacaoreceitadespesa',ifthen(Length(trim(IWEDITCLASSIFICACAO.Text))>0,inttostr(IWEDITCLASSIFICACAO.Tag),'0'));
    wnota.AddPair('idespecie',ifthen(Length(trim(IWEDITESPECIE.Text))>0,inttostr(IWEDITESPECIE.Tag),'0'));
    wnota.AddPair('idseriesubserie',ifthen(Length(trim(IWEDITSERIE.Text))>0,inttostr(IWEDITSERIE.Tag),'0'));
    wnota.AddPair('observacao',ifthen(Length(trim(IWEDITOBSERVACAO.Text))>0,IWEDITOBSERVACAO.Text,'null'));
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

    wJsonToSend := TStringStream.Create(wnota.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);

    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao alterar nota fiscal'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_NotaFiscal.ExcluiNotaFiscal(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao excluir nota fiscal'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_NotaFiscal.RetornaRegistros(XRecurso,XCampo,XValor: string): TFDMemTable;
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

function TF_NotaFiscal.IncluiNotaFiscal: boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wnota,JObj: TJSONObject;
begin
  try
    wnota := TJSONObject.Create;
    wnota.AddPair('dataemissao',ifthen(Length(trim(IWEDITDATAEMISSAO.Text))>0,IWEDITDATAEMISSAO.Text,FormatDateTime('dd/mm/yyyy',date)));
    wnota.AddPair('idcliente',ifthen(Length(trim(IWEDITNOMECLIENTE.Text))>0,inttostr(IWEDITNOMECLIENTE.Tag),'0'));
    wnota.AddPair('idalvo',ifthen(Length(trim(IWEDITNOMEALVO.Text))>0,inttostr(IWEDITNOMEALVO.Tag),'0'));
    wnota.AddPair('idclassificacaoreceitadespesa',ifthen(Length(trim(IWEDITCLASSIFICACAO.Text))>0,inttostr(IWEDITCLASSIFICACAO.Tag),'0'));
    wnota.AddPair('idcondicao',ifthen(Length(trim(IWEDITCONDICAOPAGAMENTO.Text))>0,inttostr(IWEDITCONDICAOPAGAMENTO.Tag),'0'));
    wnota.AddPair('idvendedor',ifthen(Length(trim(IWEDITNOMEVENDEDOR.Text))>0,inttostr(IWEDITNOMEVENDEDOR.Tag),'0'));
    wnota.AddPair('iddocumentocobranca',ifthen(Length(trim(IWEDITDOCUMENTOCOBRANCA.Text))>0,inttostr(IWEDITDOCUMENTOCOBRANCA.Tag),'0'));
    wnota.AddPair('observacao',ifthen(Length(trim(IWEDITOBSERVACAO.Text))>0,IWEDITOBSERVACAO.Text,'null'));
    wnota.AddPair('moduloorigem','TS-Fature');

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

    wJsonToSend := TStringStream.Create(wnota.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    JObj        := TJSONObject.ParseJSONValue(wretorno) as TJSONObject;
    if strtointdef(JObj.GetValue('id').Value,0)>0 then
       begin
         wret   := true;
         PopulaCamposNotaFiscal(strtointdef(JObj.GetValue('id').Value,0));
       end
    else
       wret     := false;

//    WebApplication.ShowMessage('Código Fiscal incluído com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao incluir nota fiscal'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_NotaFiscal.PopulaCamposItem(XIdItem: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
    warqini: TIniFile;
    wjson: TJSONObject;
begin
  try
    UserSession.FMemTableNotaItem.Filtered := false;
    UserSession.FMemTableNotaItem.Filter   := 'id = '+inttostr(XIdItem);
    UserSession.FMemTableNotaItem.Filtered := true;
    UserSession.FIdNotaItem := UserSession.FMemTableNotaItem.FieldByName('id').AsInteger;

    IWEDITCODIGO.Text    := UserSession.FMemTableNotaItem.FieldByName('xcodproduto').AsString;
    IWEDITCODIGO.Tag     := UserSession.FMemTableNotaItem.FieldByName('idproduto').AsInteger;
    IWEDITDESCRICAO.Text := UserSession.FMemTableNotaItem.FieldByName('xdescproduto').AsString;
    IWEDITDESCRICAO.Tag  := UserSession.FMemTableNotaItem.FieldByName('idproduto').AsInteger;

    IWEDITUNIDADE.Text     := UserSession.FMemTableNotaItem.FieldByName('xunidadeproduto').AsString;
    if UserSession.FMemTableNotaItem.FieldByName('valorunitario').IsNull then
       IWEDITUNITARIO.Text := '0.00'
    else
       IWEDITUNITARIO.Text := formatfloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('valorunitario').AsFloat);
    IWEDITCSTICMS.Text    := UserSession.FMemTableNotaItem.FieldByName('xsituacaotributaria').AsString;
    IWEDITCSTICMS.Tag     := UserSession.FMemTableNotaItem.FieldByName('idsituacaotributaria').AsInteger;
    IWEDITCEAN.Text       := UserSession.FMemTableNotaItem.FieldByName('xceanproduto').AsString;
    IWEDITCFOP.Text       := UserSession.FMemTableNotaItem.FieldByName('xcodigofiscal').AsString;
    IWEDITCFOP.Tag        := UserSession.FMemTableNotaItem.FieldByName('idcodigofiscal').AsInteger;

    IWEDITCODALIQICMS.Text  := UserSession.FMemTableNotaItem.FieldByName('xcodaliquota').AsString;
    IWEDITCODALIQICMS.Tag   := UserSession.FMemTableNotaItem.FieldByName('idaliquotaicms').AsInteger;
    if UserSession.FMemTableNotaItem.FieldByName('percentualicms').IsNull then
       IWEDITALIQICMS.Text  := '0.00%'
    else
       IWEDITALIQICMS.Text  := formatfloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('percentualicms').AsFloat);
    IWEDITALIQICMS.Tag      := UserSession.FMemTableNotaItem.FieldByName('idaliquotaicms').AsInteger;
    IWEDITCSTPIS.Text       := UserSession.FMemTableNotaItem.FieldByName('codigocstpis').AsString;
    IWEDITCSTCOFINS.Text    := UserSession.FMemTableNotaItem.FieldByName('codigocstcofins').AsString;
    if UserSession.FMemTableNotaItem.FieldByName('percentualdesconto').IsNull then
       IWEDITPERCDESCONTO.Text := '0.00%'
    else
       IWEDITPERCDESCONTO.Text := FormatFloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('percentualdesconto').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('percentualbaseicms').IsNull then
       IWEDITBASEICMS.Text     := '0.00%'
    else
       IWEDITBASEICMS.Text     := formatfloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('percentualbaseicms').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('xpercpis').IsNull then
       IWEDITALIQPIS.Text      := '0.00%'
    else
       IWEDITALIQPIS.Text      := formatfloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('xpercpis').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('xperccofins').IsNull then
       IWEDITALIQCOFINS.Text   := '0.00%'
    else
       IWEDITALIQCOFINS.Text   := formatfloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('xperccofins').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('percentualbasepis').IsNull then
       IWEDITBASEPIS.Text   := '0.00%'
    else
       IWEDITBASEPIS.Text   := formatfloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('percentualbasepis').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('percentualbasecofins').IsNull then
       IWEDITBASECOFINS.Text:= '0.00%'
    else
       IWEDITBASECOFINS.Text:= formatfloat('#,0.00%',UserSession.FMemTableNotaItem.FieldByName('percentualbasecofins').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('quantidade').IsNull then
       IWEDITQUANTIDADE.Text   := '0.000'
    else
       IWEDITQUANTIDADE.Text   := formatfloat('#,0.000',UserSession.FMemTableNotaItem.FieldByName('quantidade').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('valordesconto').IsNull then
       IWEDITVALORDESCONTO.Text := '0.00'
    else
       IWEDITVALORDESCONTO.Text := FormatFloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('valordesconto').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('percentualbaseicms').IsNull then
       IWEDITBASEICMS.Text      := '0.00'
    else
       IWEDITBASEICMS.Text      := FormatFloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('percentualbaseicms').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('valoricms').IsNull then
       IWEDITVALORICMS.Text     := '0.00'
    else
       IWEDITVALORICMS.Text     := FormatFloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('valoricms').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('valorpiscreditado').IsNull then
       IWEDITVALORPIS.Text      := '0.00'
    else
       IWEDITVALORPIS.Text      := FormatFloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('valorpiscreditado').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('valorcofinscreditado').IsNull then
       IWEDITVALORCOFINS.Text   := '0.00'
    else
       IWEDITVALORCOFINS.Text   := FormatFloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('valorcofinscreditado').AsFloat);
    if UserSession.FMemTableNotaItem.FieldByName('valortotal').IsNull then
       IWEDITVALORTOTAL.Text    := '0.00'
    else
       IWEDITVALORTOTAL.Text    := FormatFloat('#,0.00',UserSession.FMemTableNotaItem.FieldByName('valortotal').AsFloat);
  except

  end;
end;

procedure TF_NotaFiscal.LimpaCamposItens;
begin
  try
    UserSession.FIdNotaItem := 0;
    UserSession.FCodProdutoNotaItem  := '';
    UserSession.FDescProdutoNotaItem := '';
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

function TF_NotaFiscal.ExcluiNotaItem(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens/'+inttostr(XId);
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

function TF_NotaFiscal.ConfirmaNotaItem(XId: integer): boolean;
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
    witem.AddPair('quantidade',ifthen(Length(trim(wquantidade))>0,wquantidade,'0'));
    witem.AddPair('valorunitario',ifthen(Length(trim(wunitario))>0,wunitario,'0'));
    witem.AddPair('valortotal',ifthen(Length(trim(wtotalitem))>0,wtotalitem,'0'));
    witem.AddPair('percentualdesconto',ifthen(Length(trim(wpercdesconto))>0,wpercdesconto,'0'));
    witem.AddPair('valordesconto',ifthen(Length(trim(wvaldesconto))>0,wvaldesconto,'0'));
    witem.AddPair('valorbaseicms',ifthen(Length(trim(wbaseicms))>0,wbaseicms,'0'));
    witem.AddPair('valoricms',ifthen(Length(trim(wvalicms))>0,wvalicms,'0'));
    witem.AddPair('percentualpis',ifthen(Length(trim(wpercpis))>0,wpercpis,'0'));
    witem.AddPair('percentualcofins',ifthen(Length(trim(wperccofins))>0,wperccofins,'0'));
    witem.AddPair('valorpis',ifthen(Length(trim(wvalpis))>0,wvalpis,'0'));
    witem.AddPair('valorcofins',ifthen(Length(trim(wvalcofins))>0,wvalcofins,'0'));
    witem.AddPair('percentualbasepis',ifthen(Length(trim(wpercbasepis))>0,wpercbasepis,'0'));
    witem.AddPair('percentualbasecofins',ifthen(Length(trim(wpercbasecofins))>0,wpercbasecofins,'0'));
    witem.AddPair('idaliquotaicms',ifthen(Length(trim(IWEDITALIQICMS.Text))>0,inttostr(IWEDITALIQICMS.Tag),'0'));
    witem.AddPair('idcodigofiscal',ifthen(Length(trim(IWEDITCFOP.Text))>0,inttostr(IWEDITCFOP.Tag),'0'));
    witem.AddPair('idsituacaotributaria',ifthen(Length(trim(IWEDITCSTICMS.Text))>0,inttostr(IWEDITCSTICMS.Tag),'0'));
    witem.AddPair('codigocstpis',ifthen(Length(trim(IWEDITCSTPIS.Text))>0,IWEDITCSTPIS.Text,'null'));
    witem.AddPair('codigocstcofins',ifthen(Length(trim(IWEDITCSTCOFINS.Text))>0,IWEDITCSTCOFINS.Text,'null'));

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
    URL         := warqini.ReadString('Geral','URL','')+'/movimentos/notasfiscais/'+inttostr(UserSession.FIdNotaFiscal)+'/itens/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);

    PopulaCamposNotaFiscal(UserSession.FIdNotaFiscal);
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

procedure TF_NotaFiscal.CalculaTotal(XTipo: string);
var wvaltotal,wvalunitario,wqtde,wvaldesconto,wpercdesconto,wpercbaseicm,wvalbaseicm,wpercicm,wvalicm,wpercbasepis,wpercbasecofins,wvalbasepis,wvalbasecofins,wvalpis,wvalcofins,wpercpis,wperccofins: double;
    werro: string;
begin
  try
    wqtde         := strtofloatdef(IWEDITQUANTIDADE.Text,0);
    wpercdesconto := StrToFloatDef(UserSession.FJSONNotaFiscal.GetValue('xdesccondicao').Value,0);
    wvaldesconto  := ((wvalunitario * wqtde) * wpercdesconto)/100;

    if XTipo='item' then
       begin
         if UserSession.FMemTableNotaItem.FieldByName('valorunitario').IsNull then
            wvalunitario  := strtofloatdef(IWEDITUNITARIO.Text,0)
         else
            wvalunitario  := UserSession.FMemTableNotaItem.FieldByName('valorunitario').AsFloat;
         if UserSession.FMemTableNotaItem.FieldByName('valorbaseicms').IsNull then
            wvalbaseicm  := 0
         else
            wvalbaseicm   := UserSession.FMemTableNotaItem.FieldByName('valorbaseicms').AsFloat;
         if UserSession.FMemTableNotaItem.FieldByName('percentualicms').IsNull then
            wpercicm      := 0
         else
            wpercicm      := UserSession.FMemTableNotaItem.FieldByName('percentualicms').AsFloat;
         if UserSession.FMemTableNotaItem.FieldByName('percentualbasepis').IsNull then
            wpercbasepis  := 0
         else
            wpercbasepis  := UserSession.FMemTableNotaItem.FieldByName('percentualbasepis').AsFloat;
         wvalbasepis   := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasepis)/100;

         if UserSession.FMemTableNotaItem.FieldByName('xpercpis').IsNull then
            wpercpis      := 0
         else
            wpercpis      := UserSession.FMemTableNotaItem.FieldByName('xpercpis').AsFloat;

         if UserSession.FMemTableNotaItem.FieldByName('percentualbasecofins').IsNull then
            wpercbasecofins := 0
         else
            wpercbasecofins := UserSession.FMemTableNotaItem.FieldByName('percentualbasecofins').AsFloat;
         wvalbasecofins  := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasecofins)/100;

         if UserSession.FMemTableNotaItem.FieldByName('xperccofins').IsNull then
            wperccofins     := 0
         else
            wperccofins     := UserSession.FMemTableNotaItem.FieldByName('xperccofins').AsFloat;
       end
    else
       begin
         if UserSession.FMemTableProdutoHelp.FieldByName('preco1').IsNull then
            wvalunitario  := strtofloatdef(IWEDITUNITARIO.Text,0)
         else
            wvalunitario  := UserSession.FMemTableProdutoHelp.FieldByName('preco1').AsFloat;
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

procedure TF_NotaFiscal.CarregaCamposProduto(XIdProduto: integer);
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
          IWEDITCFOP.Text    := UserSession.FJSONNotaFiscal.GetValue('xcfopstcondicao').Value;
          IWEDITCFOP.Tag     := strtointdef(UserSession.FJSONNotaFiscal.GetValue('xidcfopstcondicao').Value,0);
        end
     else
        begin
          IWEDITCFOP.Text    := UserSession.FJSONNotaFiscal.GetValue('xcfopcondicao').Value;
          IWEDITCFOP.Tag     := strtointdef(UserSession.FJSONNotaFiscal.GetValue('xidcfopcondicao').Value,0);
        end;
     IWEDITCODALIQICMS.Text  := UserSession.FMemTableProdutoHelp.FieldByName('xcodaliquotaicm').AsString;
     IWEDITCODALIQICMS.Tag   := UserSession.FMemTableProdutoHelp.FieldByName('idaliquota').AsInteger;
     IWEDITALIQICMS.Text     := formatfloat('#,0.00%',ifthen(UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').IsNull,0,UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').AsFloat));
     IWEDITALIQICMS.Tag      := UserSession.FMemTableProdutoHelp.FieldByName('idaliquota').AsInteger;
     IWEDITCSTPIS.Text       := UserSession.FMemTableProdutoHelp.FieldByName('cstpissaida').AsString;
     IWEDITCSTCOFINS.Text    := UserSession.FMemTableProdutoHelp.FieldByName('cstcofinssaida').AsString;
     IWEDITPERCDESCONTO.Text := FormatFloat('#,0.00%',strtofloat(UserSession.FJSONNotaFiscal.GetValue('xdesccondicao').Value));
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

procedure TF_NotaFiscal.CarregaSelect(XJSON: TJSONObject);
var wmodelo: string;
begin
  try
     wmodelo := XJSON.GetValue('modelodocumentofiscal').Value;
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectmodelo").val('+QuotedStr(wmodelo)+');');
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao carregar campos de select'+slinebreak+E.Message);
    end;
  end;
end;

// Autoriza NFe
function TF_NotaFiscal.AutorizaNFe(XIdNota: integer): boolean;
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wURL,wretorno,wresult,wchave: string;
    wstatus: integer;
    wjsontosend: TStringStream;
    warqini: TIniFile;
begin
  try
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
    // transforma string em stringstream
    wJsonToSend := TStringStream.Create('', TEncoding.UTF8);
    wURL      := warqini.ReadString('Geral','URL','')+'/servicos/nfe/'+inttostr(XIdNota);

//    wURL     := 'http://192.168.1.32:9000/trabinapi/servicos/nfe/'+inttostr(XIdNota);
//    wIdHTTP.Post(wURL,wjsontosend);
    wresult  := wIdHTTP.Post(wURL,wjsontosend);
    wstatus  := wIdHTTP.ResponseCode;
    wretorno := wIdHTTP.ResponseText;

    if wstatus=201 then // Autorizou NFe
       begin
         wchave := ConsultaNotaAutorizada(XIdNota);
         wret   := RetornaXML(wchave);
         wret   := RetornaPDF(wchave);
       end
    else
       wret := false;
  except
    On E: EIdHTTPProtocolException do
    begin
      wret := false;
      WebApplication.ShowMessage(E.ErrorMessage);
    end;
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Consulta NFe Autorizada pelo Id da Nota
function TF_NotaFiscal.ConsultaNotaAutorizada(XIdNota: integer): string;
var wret,wURL,wretjson,wchave: string;
    wjson: TJSONObject;
    warqini: TIniFile;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
begin
  try
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

    wURL     := warqini.ReadString('Geral','URL','')+'/movimentos/nfe_autorizadas/'+inttostr(XIdNota);
    wretjson := wIdHTTP.Get(wURL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    wret     := wjson.GetValue('chave').Value;

  except
    wret := '';
  end;
  Result := wret;
end;

// Retorna XML NFe
function TF_NotaFiscal.RetornaXML(XChave: string): boolean;
var wret: boolean;
    wURL,wretorno,wretjson: string;
    wstatus: integer;
    wstream: TMemoryStream;
    warqini: TIniFile;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
begin
  try
    wstream := TMemoryStream.Create;
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

    wURL     := warqini.ReadString('Geral','URL','')+'/arquivos/nfe_xml/'+XChave;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/arquivos/nfe_xml/'+XChave;
    wIdHTTP.Get(wURL,wstream);
    wstream.Position := 0;

    wstatus  := wIdHTTP.ResponseCode;
    wretorno := wIdHTTP.ResponseText;
    if wstatus=200 then
       begin
         SalvaArquivoXML(XChave,wstream);
         wret := true;
       end
    else
       wret := false;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Salvar Arquivo XML
procedure TF_NotaFiscal.SalvaArquivoXML(XChave: string; XStream: TMemoryStream);
var wcaminho,wmes,wano,warquivo: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);
  warquivo := wcaminho+'\'+XChave+'-nfe.xml';
  XStream.SaveToFile(warquivo);
end;

// Retorna PDF NFe
function TF_NotaFiscal.RetornaPDF(XChave: string): boolean;
var wret: boolean;
    wURL,wretorno,wretjson: string;
    wstatus: integer;
    wstream: TMemoryStream;
    warqini: TIniFile;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
begin
  try
    wstream := TMemoryStream.Create;
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

    wURL     := warqini.ReadString('Geral','URL','')+'/arquivos/nfe_pdf/'+XChave;
//    wURL     := 'http://192.168.1.32:9000/trabinapi/arquivos/nfe_pdf/'+XChave;
    wIdHTTP.Get(wURL,wstream);
    wstream.Position := 0;

    wstatus  := wIdHTTP.ResponseCode;
    wretorno := wIdHTTP.ResponseText;
    if wstatus=200 then
       begin
         SalvaArquivoPDF(XChave,wstream);
         wret := true;
       end
    else
       wret := false;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

// Salvar Arquivo PDF
procedure TF_NotaFiscal.SalvaArquivoPDF(XChave: string; XStream: TMemoryStream);
var wcaminho,wmes,wano,warquivo: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);
  warquivo := wcaminho+'\'+XChave+'-nfe.pdf';
  XStream.SaveToFile(warquivo);
end;

// Mostra Arquivo XML
procedure TF_NotaFiscal.MostraArquivoXML(XChave: string);
var wcaminho,wcaminho2,wmes,wano,warquivo,warquivo2: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := '/notas/'+wano+'/'+wmes;
  wcaminho2 := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho2) then
     ForceDirectories(wcaminho2);
  warquivo  := wcaminho+'/'+XChave+'-nfe.xml';
  warquivo2 := wcaminho2+'\'+XChave+'-nfe.xml';
  if FileExists(warquivo2) then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalArquivoXML'').modal(''show'');');
       IWLabelArquivoXML.Text := ' <iframe src="'+warquivo+'" width="100%" style="height:80vh;"></iframe> ';
     end
  else
     WebApplication.ShowMessage('Arquivo xml não encontrado');
end;

// Mostra Arquivo PDF
procedure TF_NotaFiscal.MostraArquivoPDF(XChave: string);
var wcaminho,wcaminho2,wmes,wano,warquivo,warquivo2: string;
    wdata: tdate;
begin
  wano      := '20'+copy(XChave,3,2);
  wmes      := copy(XChave,5,2);
  wdata     := strtodate('01/'+wmes+'/'+wano);
  wmes      := formatdatetime('mmmm',wdata);
  wcaminho  := '/notas/'+wano+'/'+wmes;
  wcaminho2 := GetCurrentDir+'\wwwroot\notas\'+wano+'\'+wmes;
  if not DirectoryExists(wcaminho2) then
     ForceDirectories(wcaminho2);
  warquivo  := wcaminho+'/'+XChave+'-nfe.pdf';
  warquivo2 := wcaminho2+'\'+XChave+'-nfe.pdf';
  if FileExists(warquivo2) then
     begin
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalArquivoPDF'').modal(''show'');');
       IWLabelArquivoPDF.Text := ' <iframe src="'+warquivo+'" width="100%" style="height:80vh;"></iframe> ';
     end
  else
     WebApplication.ShowMessage('Arquivo pdf não encontrado');
end;

// Cancela NFe
function TF_NotaFiscal.CancelaNFe(XIdNota: integer): boolean;
var wret: boolean;
    wURL,wretorno: string;
    wstatus: integer;
    warqini: TIniFile;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
begin
  try
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

    wURL     := warqini.ReadString('Geral','URL','')+'/servicos/nfe/'+inttostr(XIdNota);
    wIdHTTP.Delete(wURL);
    wstatus  := wIdHTTP.ResponseCode;
    wretorno := wIdHTTP.ResponseText;
    wret     := true;
  except
    On E: Exception do
    begin
      wret := false;
      WebApplication.ShowMessage(E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_NotaFiscal.AcertaCorFonteElemento(XSituacao: string);
begin
  if XSituacao='A' then
     begin
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITPEDIDO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNUMERODOCUMENTO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITORIGEM'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITDATAEMISSAO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITESPECIE'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITSERIE'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITORDEMSERVICO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITORDEMCOMPRA'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITDATASAIDA'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITHORASAIDA'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCHAVENFE'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITMODELO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITTOTAL'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNOMECLIENTE'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNOMEALVO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNOMEVENDEDOR'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCONDICAOPAGAMENTO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITDOCUMENTOCOBRANCA'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCLASSIFICACAO'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#obsnota'').css(''color'', ''red'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#selectmodelo'').css(''color'', ''red'');');
     end
  else
     begin
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITPEDIDO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNUMERODOCUMENTO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITORIGEM'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITDATAEMISSAO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITESPECIE'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITSERIE'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITORDEMSERVICO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITORDEMCOMPRA'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITDATASAIDA'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITHORASAIDA'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCHAVENFE'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITMODELO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITTOTAL'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNOMECLIENTE'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNOMEALVO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITNOMEVENDEDOR'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCONDICAOPAGAMENTO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITDOCUMENTOCOBRANCA'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#IWEDITCLASSIFICACAO'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#obsnota'').css(''color'', ''#00bfff'');');
        WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#selectmodelo'').css(''color'', ''#00bfff'');');
     end;
end;
end.
