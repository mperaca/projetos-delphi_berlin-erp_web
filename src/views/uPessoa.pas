unit uPessoa;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWCompEdit,
  Vcl.Controls, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWCompButton, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IWVCLComponent, IWBaseLayoutComponent, IWBaseContainerLayout, System.StrUtils,
  IWContainerLayout, IWTemplateProcessorHTML, IniFiles, System.JSON, IWHTMLTag, IdAuthentication,
  IWCompLabel,
  FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt;


type
  TF_Pessoa = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP1: TIdHTTP;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IWEDITCODIGOPESSOA: TIWEdit;
    IWEDITNOMEPESSOA: TIWEdit;
    IWEDITCONTATOPESSOA: TIWEdit;
    IWEDITNOMEFANTASIAPESSOA: TIWEdit;
    IWEDITOBSERVACAOPESSOA: TIWEdit;
    IWEDITATIVIDADEPESSOA: TIWEdit;
    IWEDITPASTAPESSOA: TIWEdit;
    IWEDITCODBANCOPESSOA: TIWEdit;
    IWEDITCPFPESSOA: TIWEdit;
    IWEDITRGPESSOA: TIWEdit;
    IWEDITCNPJPESSOA: TIWEdit;
    IWEDITIEPESSOA: TIWEdit;
    IWEDITIMPESSOA: TIWEdit;
    IWEDITSUFRAMAPESSOA: TIWEdit;
    IWEDITIESUBSTITUTOPESSOA: TIWEdit;
    IWEDITLOGRADOUROPESSOA: TIWEdit;
    IWEDITCOMPLEMENTOPESSOA: TIWEdit;
    IWEDITBAIRROPESSOA: TIWEdit;
    IWEDITCIDADEPESSOA: TIWEdit;
    IWEDITCEPPESSOA: TIWEdit;
    IWEDITFONEPESSOA: TIWEdit;
    IWEDITCELULARPESSOA: TIWEdit;
    IWEDITCAIXAPOSTALPESSOA: TIWEdit;
    IWEDITSITEPESSOA: TIWEdit;
    IWEDITEMAILPESSOA: TIWEdit;
    IWLabelClassificacao: TIWLabel;
    IWEDITATIVO: TIWEdit;
    IWEDITPESSOAFISICA: TIWEdit;
    IWEDITVERIFICADEBITOS: TIWEdit;
    IWEDITEMITEETIQUETA: TIWEdit;
    IWEDITPRECADASTRO: TIWEdit;
    IWEDITACEITADEVOLUCAO: TIWEdit;
    IWEDITREIDI: TIWEdit;
    IWEDITCONTRIBUICAO: TIWEdit;
    IWEDITBANCO: TIWEdit;
    IWEDITCONVENIO: TIWEdit;
    IWEDITCLIENTE: TIWEdit;
    IWEDITFORNECEDOR: TIWEdit;
    IWEDITFUNCIONARIO: TIWEdit;
    IWEDITREPRESENTANTE: TIWEdit;
    IWEDITTRANSPORTADORA: TIWEdit;
    IWEDITMOBILE: TIWEdit;
    IWEDITOFTALMO: TIWEdit;
    IWEDITMEDICO: TIWEdit;
    IWEDITIDATIVIDADE: TIWEdit;
    IWEDITIDLOCALIDADE: TIWEdit;
    IWEDITIDPESSOA: TIWEdit;
    IWEDITENDERECOCOBRANCA: TIWEdit;
    IWEDITCOMPLEMENTOCOBRANCA: TIWEdit;
    IWEDITBAIRROCOBRANCA: TIWEdit;
    IWEDITCIDADECOBRANCA: TIWEdit;
    IWEDITCEPCOBRANCA: TIWEdit;
    IWEDITFONECOBRANCA: TIWEdit;
    IWEDITEMAILCOBRANCA: TIWEdit;
    IWEDITIDBANCO: TIWEdit;
    IWEDITBANCODIVERSOS: TIWEdit;
    IWEDITCONTADIVERSOS: TIWEdit;
    IWEDITCOBRANCADIVERSOS: TIWEdit;
    IWEDITIDCOBRANCA: TIWEdit;
    IWEDITCOMISSAODIVERSOS: TIWEdit;
    IWEDITCOBRARDEDIVERSOS: TIWEdit;
    IWEDITIDCLIENTE: TIWEdit;
    IWEDITTABELADIVERSOS: TIWEdit;
    IWEDITIDTABELA: TIWEdit;
    IWEDITCREDITODIVERSOS: TIWEdit;
    IWEDITCONDICAODIVERSOS: TIWEdit;
    IWEDITIDCONDICAO: TIWEdit;
    IWEDITPRAZODIVERSOS: TIWEdit;
    IWEDITREFERENCIA1DIVERSOS: TIWEdit;
    IWEDITLIMITEFATURARDIVERSOS: TIWEdit;
    IWEDITREFERENCIA2DIVERSOS: TIWEdit;
    IWEDITLIMITECOMPRADIVERSOS: TIWEdit;
    IWEDITREPRESENTANTEDIVERSOS: TIWEdit;
    IWEDITCADASTRAMENTODIVERSOS: TIWEdit;
    IWEDITIDREPRESENTANTE: TIWEdit;
    IWEDITRETENCOES: TIWEdit;
    IWEDITREMESSAS: TIWEdit;
    IWEDITREVENDEDOR: TIWEdit;
    IWEDITESTADOCIVIL: TIWEdit;
    IWEDITGENERO: TIWEdit;
    IWEDITDATANASCIMENTO: TIWEdit;
    IWEDITSALARIO: TIWEdit;
    IWEDITNATURALIDADE: TIWEdit;
    IWEDITNOMEPAI: TIWEdit;
    IWEDITNOMEMAE: TIWEdit;
    IWEDITNOMEEMPRESA: TIWEdit;
    IWEDITENDERECOEMPRESA: TIWEdit;
    IWEDITCEPEMPRESA: TIWEdit;
    IWEDITBAIRROEMPRESA: TIWEdit;
    IWEDITFONEEMPRESA: TIWEdit;
    IWEDITNOMEDIRETOR1EMPRESA: TIWEdit;
    IWEDITNOMEDIRETOR2EMPRESA: TIWEdit;
    IWEDITDATAFUNDACAOEMPRESA: TIWEdit;
    IWEDITNOMEFIADOR: TIWEdit;
    IWEDITCPFFIADOR: TIWEdit;
    IWEDITRGFIADOR: TIWEdit;
    IWEDITENDERECOFIADOR: TIWEdit;
    IWEDITBAIRROFIADOR: TIWEdit;
    IWEDITCIDADEFIADOR: TIWEdit;
    IWEDITCEPFIADOR: TIWEdit;
    IWEDITFONEFIADOR: TIWEdit;
    IWEDITNOMECONJUGE: TIWEdit;
    IWEDITDATANASCIMENTOCONJUGE: TIWEdit;
    IWEDITEMPRESACONJUGE: TIWEdit;
    IWEDITCARGOCONJUGE: TIWEdit;
    IWEDITSALARIOCONJUGE: TIWEdit;
    IWEDITDATAPRIMEIRACOMPRA: TIWEdit;
    IWEDITVALORPRIMEIRACOMPRA: TIWEdit;
    IWEDITDATAULTIMACOMPRA: TIWEdit;
    IWEDITVALORULTIMACOMPRA: TIWEdit;
    IWEDITDATAMAIORCOMPRA: TIWEdit;
    IWEDITVALORMAIORCOMPRA: TIWEdit;
    IWEDITVENCIDOSEMABERTO: TIWEdit;
    IWEDITAVENCEREMABERTO: TIWEdit;
    IWEDITATRASOMEDIO: TIWEdit;
    IWEDITMAIORATRASO: TIWEdit;
    IWEDITNUMEROCOMPRAS: TIWEdit;
    IWEDITTOTALCOMPRAS: TIWEdit;
    IWEDITQTDEMABERTO: TIWEdit;
    IWEDITVALOREMABERTO: TIWEdit;
    IWEDITQTDCANCELADO: TIWEdit;
    IWEDITVALORCANCELADO: TIWEdit;
    IWEDITQTDQUITADO: TIWEdit;
    IWEDITVALORQUITADO: TIWEdit;
    procedure IWEDITCODIGOPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITNOMEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCONTATOPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITNOMEFANTASIAPESSOAHTMLTag(ASender: TObject;
      ATag: TIWHTMLTag);
    procedure IWEDITOBSERVACAOPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITATIVIDADEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITPASTAPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCODBANCOPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCPFPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITRGPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCNPJPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITIEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITIMPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITSUFRAMAPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITIESUBSTITUTOPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITTIPOCONTRIBUICAOPESSOAHTMLTag(ASender: TObject;
      ATag: TIWHTMLTag);
    procedure IWEDITLOGRADOUROPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCOMPLEMENTOPESSOAHTMLTag(ASender: TObject;
      ATag: TIWHTMLTag);
    procedure IWEDITBAIRROPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCIDADEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCEPPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITFONEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCELULARPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCAIXAPOSTALPESSOAHTMLTag(ASender: TObject;
      ATag: TIWHTMLTag);
    procedure IWEDITSITEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITEMAILPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITATIVIDADEPESSOAAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCIDADEPESSOAAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITENDERECOCOBRANCAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEDITCOMPLEMENTOCOBRANCAHTMLTag(ASender: TObject;
      ATag: TIWHTMLTag);
    procedure IWEDITCIDADECOBRANCAAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITBANCODIVERSOSAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCOBRANCADIVERSOSAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCOBRARDEDIVERSOSAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITTABELADIVERSOSAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCONDICAODIVERSOSAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITREPRESENTANTEDIVERSOSAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITNATURALIDADEAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCIDADEFIADORAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITCARGOCONJUGEAsyncKeyUp(Sender: TObject;
      EventParams: TStringList);
    procedure IWEDITQTDEMABERTOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    FIdFiador: integer;
    procedure PopulaCamposPessoa(XId: integer);
    procedure CarregaClassificacao(XJSON: TJSONObject);
    procedure CarregaSelect(XJSON: TJSONObject);
    procedure CarregaGeral(XJSON: TJSONObject);
    procedure HabilitaDesabilitaEdicaoCampos(XHabilita: boolean);
    procedure LimpaCampos;
    function ConfirmaPessoa(XId: integer): boolean;
    function RetornaRegistros(XRecurso,XCampo,XValor: string): TFDMemTable;
    procedure ProximoControle(XControleAtual: integer);
    function IncluiPessoa: boolean;
    function ExcluiPessoa(XId: integer): boolean;
    procedure CarregaOutros(XJSON: TJSONObject);
    procedure PopulaCamposFiador(XIdPessoa: string);
    procedure IncluiFiador(XIdPessoa: integer);
    procedure AlteraFiador(XIdPessoa, XIdFiador: integer);
    procedure CarregaResumoHistorico;
    procedure CarregaResumoParcela;
  public
  end;

implementation

{$R *.dfm}

uses UserSessionUnit, ServerController, DataSet.Serialize;


procedure TF_Pessoa.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var widpessoa,widatividade,widlocalidade,widbanco,widcobranca,widcliente,widtabela,widcondicao,widrepresentante: integer;
    wpagina,watividade,wlocalidade,wbanco,wcobranca,wcliente,wtabela,wcondicao,wrepresentante: string;
begin
  if pos('[LimpaPessoa]',IWEDITNOME.Text)>0 then
     LimpaCampos
  else if pos('[ResumoHistorico]',IWEDITNOME.Text)>0 then
     CarregaResumoHistorico
  else if pos('[ResumoParcela]',IWEDITNOME.Text)>0 then
     CarregaResumoParcela
  else if pos('[ExcluiPessoa]',IWEDITNOME.Text)>0 then
     begin
       widpessoa  := strtointdef(IWEDITID.Text,0);
       wpagina       := copy(IWEDITNOME.Text,pos('[ExcluiPessoa]',IWEDITNOME.Text)+14,10);
       if ExcluiPessoa(widpessoa) then
          begin
            LimpaCampos;
            WebApplication.CallBackResponse.AddJavaScriptToExecute('limpaGeral();');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('limpaClassificacao();');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('limpaOutros();');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('desabilitaEdicao();');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
            WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
          end;
     end
  else if pos('[HelpAtividade]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTipoHelpAtividade := copy(IWEDITNOME.Text,pos('[HelpAtividade]',IWEDITNOME.Text)+15,100);
       if UserSession.FTipoHelpAtividade='pessoa' then
          UserSession.FAtividade := ''
       else if UserSession.FTipoHelpAtividade='conjuge' then
          UserSession.FCargoConjuge := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaAtividades(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAtividade'').modal(''show'');');
     end
  else if pos('[HelpBanco]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FBanco := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaBancos(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalBanco'').modal(''show'');');
     end
  else if pos('[HelpRepresentante]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FRepresentante := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaRepresentantes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalRepresentante'').modal(''show'');');
     end
  else if pos('[HelpCobranca]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCobranca := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCobrancas(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCobranca'').modal(''show'');');
     end
  else if pos('[HelpCliente]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCobrarDe := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClientes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCliente'').modal(''show'');');
     end
  else if pos('[HelpTabela]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTabela := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaTabelas(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalTabela'').modal(''show'');');
     end
  else if pos('[HelpCondicao]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FCondicao := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCondicoes(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCondicao'').modal(''show'');');
     end
  else if pos('[HelpLocalidade]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FTipoHelpLocalidade := copy(IWEDITNOME.Text,pos('[HelpLocalidade]',IWEDITNOME.Text)+16,100);
       if UserSession.FTipoHelpLocalidade='pessoa' then
          UserSession.FLocalidade := ''
       else if UserSession.FTipoHelpLocalidade='cobranca' then
          UserSession.FLocalidadeCobranca := ''
       else if UserSession.FTipoHelpLocalidade='naturalidade' then
          UserSession.FNaturalidade := ''
       else if UserSession.FTipoHelpLocalidade='fiador' then
          UserSession.FLocalidadeFiador := '';
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaLocalidades(10);');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalLocalidade'').modal(''show'');');
     end
  else if pos('[CarregaFichaPessoa]',IWEDITNOME.Text)>0 then
     begin
       widpessoa  := strtointdef(IWEDITID.Text,0);
       PopulaCamposPessoa(widpessoa);
     end
  else if pos('[AlteraPessoa]',IWEDITNOME.Text)>0 then
     begin
       HabilitaDesabilitaEdicaoCampos(true);
       IWEDITCODIGOPESSOA.SetFocus;
     end
  else if pos('[IncluiPessoa]',IWEDITNOME.Text)>0 then
     begin
       LimpaCampos;
       WebApplication.CallBackResponse.AddJavaScriptToExecute('limpaGeral();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('limpaClassificacao();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('limpaOutros();');
       WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaContribuicao();');
       IWEDITCODIGOPESSOA.SetFocus;
     end
  else if pos('[CancelaPessoa]',IWEDITNOME.Text)>0 then
     begin
       widpessoa  := strtointdef(IWEDITIDPESSOA.Text,0);
       if widpessoa>0 then
          PopulaCamposPessoa(widpessoa)
       else
          LimpaCampos;
     end
  else if pos('[ConfirmaPessoa]',IWEDITNOME.Text)>0 then
     begin
//       widpessoa  := strtointdef(IWEDITID.Text,0);
       widpessoa  := IWEDITCODIGOPESSOA.Tag;
       wpagina    := copy(IWEDITNOME.Text,pos('[ConfirmaPessoa]',IWEDITNOME.Text)+16,10);
       if widpessoa>0 then
          begin
            if ConfirmaPessoa(widpessoa) then
               begin
                 PopulaCamposPessoa(widpessoa);
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end
       else
          begin
            if IncluiPessoa then
               begin
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
                 WebApplication.CallBackResponse.AddJavaScriptToExecute('setPagina('+wpagina+');');
               end;
          end;
     end
  else if pos('[SelecionaAtividade]',IWEDITNOME.Text)>0 then
     begin
       widatividade := strtointdef(IWEDITIDATIVIDADE.Text,0);
       watividade   := copy(IWEDITNOME.Text,pos('[SelecionaAtividade]',IWEDITNOME.Text)+20,100);
       if UserSession.FTipoHelpAtividade='pessoa' then
          begin
            IWEDITATIVIDADEPESSOA.Text := watividade;
            IWEDITATIVIDADEPESSOA.Tag  := widatividade;
            UserSession.FAtividade     := watividade;
          end
       else if UserSession.FTipoHelpAtividade='conjuge' then
          begin
            IWEDITCARGOCONJUGE.Text   := watividade;
            IWEDITCARGOCONJUGE.Tag    := widatividade;
            UserSession.FCargoConjuge := watividade;
          end;
     end
  else if pos('[SelecionaBanco]',IWEDITNOME.Text)>0 then
     begin
       widbanco := strtointdef(IWEDITIDBANCO.Text,0);
       wbanco   := copy(IWEDITNOME.Text,pos('[SelecionaBanco]',IWEDITNOME.Text)+16,100);
       IWEDITBANCODIVERSOS.Text := wbanco;
       IWEDITBANCODIVERSOS.Tag  := widbanco;
       UserSession.FBanco       := wbanco;
     end
  else if pos('[SelecionaRepresentante]',IWEDITNOME.Text)>0 then
     begin
       widrepresentante := strtointdef(IWEDITIDREPRESENTANTE.Text,0);
       wrepresentante   := copy(IWEDITNOME.Text,pos('[SelecionaRepresentante]',IWEDITNOME.Text)+24,100);
       IWEDITREPRESENTANTEDIVERSOS.Text   := wrepresentante;
       IWEDITREPRESENTANTEDIVERSOS.Tag    := widrepresentante;
       UserSession.FRepresentante := wrepresentante;
     end
  else if pos('[SelecionaCliente]',IWEDITNOME.Text)>0 then
     begin
       widcliente := strtointdef(IWEDITIDCLIENTE.Text,0);
       wcliente   := copy(IWEDITNOME.Text,pos('[SelecionaCliente]',IWEDITNOME.Text)+18,100);
       IWEDITCOBRARDEDIVERSOS.Text := wcliente;
       IWEDITCOBRARDEDIVERSOS.Tag  := widcliente;
       UserSession.FCobrarDe       := wcliente;
     end
  else if pos('[SelecionaTabela]',IWEDITNOME.Text)>0 then
     begin
       widtabela := strtointdef(IWEDITIDTABELA.Text,0);
       wtabela   := copy(IWEDITNOME.Text,pos('[SelecionaTabela]',IWEDITNOME.Text)+17,100);
       IWEDITTABELADIVERSOS.Text := wtabela;
       IWEDITTABELADIVERSOS.Tag  := widtabela;
       UserSession.FTabela       := wtabela;
     end
  else if pos('[SelecionaCondicao]',IWEDITNOME.Text)>0 then
     begin
       widcondicao := strtointdef(IWEDITIDCONDICAO.Text,0);
       wcondicao   := copy(IWEDITNOME.Text,pos('[SelecionaCondicao]',IWEDITNOME.Text)+19,100);
       IWEDITCONDICAODIVERSOS.Text := wcondicao;
       IWEDITCONDICAODIVERSOS.Tag  := widcondicao;
       UserSession.FCondicao       := wcondicao;
     end
  else if pos('[SelecionaCobranca]',IWEDITNOME.Text)>0 then
     begin
       widcobranca := strtointdef(IWEDITIDCOBRANCA.Text,0);
       wcobranca   := copy(IWEDITNOME.Text,pos('[SelecionaCobranca]',IWEDITNOME.Text)+19,100);
       IWEDITCOBRANCADIVERSOS.Text := wcobranca;
       IWEDITCOBRANCADIVERSOS.Tag  := widcobranca;
       UserSession.FCobranca       := wcobranca;
     end
  else if pos('[SelecionaLocalidade]',IWEDITNOME.Text)>0 then
     begin
       widlocalidade := strtointdef(IWEDITIDLOCALIDADE.Text,0);
       wlocalidade   := copy(IWEDITNOME.Text,pos('[SelecionaLocalidade]',IWEDITNOME.Text)+21,100);
       if UserSession.FTipoHelpLocalidade='pessoa' then
          begin
           IWEDITCIDADEPESSOA.Text     := wlocalidade;
           IWEDITCIDADEPESSOA.Tag      := widlocalidade;
          end
       else  if UserSession.FTipoHelpLocalidade='cobranca' then
          begin
           IWEDITCIDADECOBRANCA.Text    := wlocalidade;
           IWEDITCIDADECOBRANCA.Tag     := widlocalidade;
          end
       else  if UserSession.FTipoHelpLocalidade='naturalidade' then
          begin
           IWEDITNATURALIDADE.Text    := wlocalidade;
           IWEDITNATURALIDADE.Tag     := widlocalidade;
          end
       else  if UserSession.FTipoHelpLocalidade='fiador' then
          begin
           IWEDITCIDADEFIADOR.Text    := wlocalidade;
           IWEDITCIDADEFIADOR.Tag     := widlocalidade;
          end;
       UserSession.FNomeLocalidade := wlocalidade;
//       UserSession.Localidade      := wlocalidade;
     end
  else if pos('[LimpaFiltroAtividade]',IWEDITNOME.Text)>0 then
     begin
       UserSession.FAtividade := '';
     end;
end;

procedure TF_Pessoa.LimpaCampos;
begin
  try
    UserSession.FIdPessoa            := 0;
    FIdFiador                        := 0;
    IWEDITCODIGOPESSOA.Text          := '';
    IWEDITCODIGOPESSOA.Tag           := 0;
    IWEDITNOMEPESSOA.Text            := '';
    IWEDITCONTATOPESSOA.Text         := '';
    IWEDITOBSERVACAOPESSOA.Text      := '';
    IWEDITATIVIDADEPESSOA.Text       := '';
    IWEDITATIVIDADEPESSOA.Tag        := 0;
    IWEDITNOMEFANTASIAPESSOA.Text    := '';
    IWEDITPASTAPESSOA.Text           := '';
    IWEDITCODBANCOPESSOA.Text        := '';
    IWEDITCPFPESSOA.Text             := '';
    IWEDITRGPESSOA.Text              := '';
    IWEDITCNPJPESSOA.Text            := '';
    IWEDITIEPESSOA.Text              := '';
    IWEDITSUFRAMAPESSOA.Text         := '';
    IWEDITIESUBSTITUTOPESSOA.Text    := '';
    IWEDITSITEPESSOA.Text            := '';
    IWEDITEMAILPESSOA.Text           := '';
    IWEDITLOGRADOUROPESSOA.Text      := '';
    IWEDITCOMPLEMENTOPESSOA.Text     := '';
    IWEDITBAIRROPESSOA.Text          := '';
    IWEDITCIDADEPESSOA.Text          := '';
    IWEDITCIDADEPESSOA.Tag           := 0;
    IWEDITCEPPESSOA.Text             := '';
    IWEDITFONEPESSOA.Text            := '';
    IWEDITCELULARPESSOA.Text         := '';
    IWEDITCAIXAPOSTALPESSOA.Text     := '';
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#selectcontribuicao'').empty();');
    //Cobrança
    IWEDITENDERECOCOBRANCA.Text      := '';
    IWEDITCOMPLEMENTOCOBRANCA.Text   := '';
    IWEDITBAIRROCOBRANCA.Text        := '';
    IWEDITCIDADECOBRANCA.Text        := '';
    IWEDITCIDADECOBRANCA.Tag         := 0;
    IWEDITCEPCOBRANCA.Text           := '';
    IWEDITFONECOBRANCA.Text          := '';
    IWEDITEMAILCOBRANCA.Text         := '';
// Diversos
    IWEDITBANCODIVERSOS.Text         := '';
    IWEDITBANCODIVERSOS.Tag          := 0;
    IWEDITCONTADIVERSOS.Text         := '';
    IWEDITCOBRANCADIVERSOS.Text      := '';
    IWEDITCOBRANCADIVERSOS.Tag       := 0;
    IWEDITCOMISSAODIVERSOS.Text      := '';
    IWEDITCOBRARDEDIVERSOS.Text      := '';
    IWEDITCOBRARDEDIVERSOS.Tag       := 0;
    IWEDITTABELADIVERSOS.Text        := '';
    IWEDITTABELADIVERSOS.Tag         := 0;
    IWEDITCREDITODIVERSOS.Text       := '';
    IWEDITCONDICAODIVERSOS.Text      := '';
    IWEDITCONDICAODIVERSOS.Tag       := 0;
    IWEDITPRAZODIVERSOS.Text         := '';
    IWEDITREFERENCIA1DIVERSOS.Text   := '';
    IWEDITREFERENCIA2DIVERSOS.Text   := '';
    IWEDITLIMITECOMPRADIVERSOS.Text  := '';
    IWEDITLIMITEFATURARDIVERSOS.Text := '';
    IWEDITREPRESENTANTEDIVERSOS.Text := '';
    IWEDITREPRESENTANTEDIVERSOS.Tag  := 0;
// Fisica/Juridica
    IWEDITDATANASCIMENTO.Text        := '';
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#selectestadocivil'').empty();');
    WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#selectgenero'').empty();');
    IWEDITSALARIO.Text               := '';
    IWEDITNATURALIDADE.Text          := '';
    IWEDITNATURALIDADE.Tag           := 0;
    IWEDITNOMEPAI.Text               := '';
    IWEDITNOMEMAE.Text               := '';
    IWEDITNOMEEMPRESA.Text           := '';
    IWEDITENDERECOEMPRESA.Text       := '';
    IWEDITCEPEMPRESA.Text            := '';
    IWEDITBAIRROEMPRESA.Text         := '';
    IWEDITFONEEMPRESA.Text           := '';
    IWEDITNOMEDIRETOR1EMPRESA.Text   := '';
    IWEDITNOMEDIRETOR2EMPRESA.Text   := '';
    IWEDITDATAFUNDACAOEMPRESA.Text   := '';
// Fiador
    IWEDITNOMEFIADOR.Text            := '';
    IWEDITCPFFIADOR.Text             := '';
    IWEDITRGFIADOR.Text              := '';
    IWEDITENDERECOFIADOR.Text        := '';
    IWEDITBAIRROFIADOR.Text          := '';
    IWEDITCIDADEFIADOR.Text          := '';
    IWEDITCIDADEFIADOR.Tag           := 0;
    IWEDITCEPFIADOR.Text             := '';
    IWEDITFONEFIADOR.Text            := '';
// CONJUGE
    IWEDITNOMECONJUGE.Text           := '';
    IWEDITDATANASCIMENTOCONJUGE.Text := '';
    IWEDITEMPRESACONJUGE.Text        := '';
    IWEDITCARGOCONJUGE.Text          := '';
    IWEDITCARGOCONJUGE.Tag           := 0;
    IWEDITSALARIOCONJUGE.Text        := '';
// Historico
    IWEDITDATAPRIMEIRACOMPRA.Text  := '';
    IWEDITVALORPRIMEIRACOMPRA.Text := '';
    IWEDITDATAULTIMACOMPRA.Text    := '';
    IWEDITVALORULTIMACOMPRA.Text   := '';
    IWEDITDATAMAIORCOMPRA.Text     := '';
    IWEDITVALORMAIORCOMPRA.Text    := '';
    IWEDITVENCIDOSEMABERTO.Text    := '';
    IWEDITAVENCEREMABERTO.Text     := '';
    IWEDITATRASOMEDIO.Text         := '';
    IWEDITMAIORATRASO.Text         := '';
    IWEDITNUMEROCOMPRAS.Text       := '';
    IWEDITTOTALCOMPRAS.Text        := '';
// PARCELAS
    IWEDITQTDEMABERTO.Text         := '';
    IWEDITVALOREMABERTO.Text       := '';
    IWEDITQTDCANCELADO.Text        := '';
    IWEDITVALORCANCELADO.Text      := '';
    IWEDITQTDQUITADO.Text          := '';
    IWEDITVALORQUITADO.Text        := '';

  finally

  end;
end;

procedure TF_Pessoa.HabilitaDesabilitaEdicaoCampos(XHabilita: boolean);
begin
  try
    IWEDITCODIGOPESSOA.Enabled       := XHabilita;
    IWEDITNOMEPESSOA.Enabled         := XHabilita;
    IWEDITCONTATOPESSOA.Enabled      := XHabilita;
    IWEDITOBSERVACAOPESSOA.Enabled   := XHabilita;
    IWEDITATIVIDADEPESSOA.Enabled    := XHabilita;
    IWEDITNOMEFANTASIAPESSOA.Enabled := XHabilita;
    IWEDITPASTAPESSOA.Enabled        := XHabilita;
    IWEDITCODBANCOPESSOA.Enabled     := XHabilita;
    IWEDITCPFPESSOA.Enabled          := XHabilita;
    IWEDITRGPESSOA.Enabled           := XHabilita;
    IWEDITCNPJPESSOA.Enabled         := XHabilita;
    IWEDITIEPESSOA.Enabled           := XHabilita;
    IWEDITSUFRAMAPESSOA.Enabled      := XHabilita;
    IWEDITIESUBSTITUTOPESSOA.Enabled := XHabilita;
    IWEDITSITEPESSOA.Enabled         := XHabilita;
    IWEDITEMAILPESSOA.Enabled        := XHabilita;
    IWEDITLOGRADOUROPESSOA.Enabled   := XHabilita;
    IWEDITCOMPLEMENTOPESSOA.Enabled  := XHabilita;
    IWEDITBAIRROPESSOA.Enabled       := XHabilita;
    IWEDITCEPPESSOA.Enabled          := XHabilita;
    IWEDITFONEPESSOA.Enabled         := XHabilita;
    IWEDITCELULARPESSOA.Enabled      := XHabilita;
    IWEDITCAIXAPOSTALPESSOA.Enabled  := XHabilita;

  finally

  end;
end;

procedure TF_Pessoa.IWEDITATIVIDADEPESSOAAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtAtividade: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FAtividade<>IWEDITATIVIDADEPESSOA.Text then
     begin
       UserSession.FTipoHelpAtividade := 'pessoa';
       UserSession.FAtividade := IWEDITATIVIDADEPESSOA.Text;
       wmtAtividade := RetornaRegistros('atividades','nome',IWEDITATIVIDADEPESSOA.Text);
       if wmtAtividade.RecordCount=1 then
          begin
            IWEDITATIVIDADEPESSOA.Text := wmtAtividade.FieldByName('nome').AsString;
            IWEDITATIVIDADEPESSOA.Tag  := wmtAtividade.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtAtividade.RecordCount=0 then
               UserSession.FAtividade := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaAtividades(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAtividade'').modal(''show'');');
          end;
     end;
  IWEDITPASTAPESSOA.SetFocus;
end;

procedure TF_Pessoa.ProximoControle(XControleAtual: integer);
var ix: integer;
    wedit: TIWEdit;
begin
  case XControleAtual of
    3: IWEDITNOMEPESSOA.SetFocus;
    4: IWEDITCONTATOPESSOA.SetFocus;
    5: IWEDITNOMEFANTASIAPESSOA.SetFocus;
    6: IWEDITOBSERVACAOPESSOA.SetFocus;
    7: IWEDITATIVIDADEPESSOA.SetFocus;
    8: IWEDITPASTAPESSOA.SetFocus;
    9: IWEDITCODBANCOPESSOA.SetFocus;
    10: IWEDITCPFPESSOA.SetFocus;
    11: IWEDITRGPESSOA.SetFocus;
    12: IWEDITIMPESSOA.SetFocus;
    13: IWEDITCNPJPESSOA.SetFocus;
    14: IWEDITIEPESSOA.SetFocus;
    15: IWEDITSUFRAMAPESSOA.SetFocus;
    16: IWEDITIESUBSTITUTOPESSOA.SetFocus;
    17: IWEDITSITEPESSOA.SetFocus;
    18: IWEDITEMAILPESSOA.SetFocus;
    19: IWEDITLOGRADOUROPESSOA.SetFocus;
    20: IWEDITCOMPLEMENTOPESSOA.SetFocus;
    21: IWEDITBAIRROPESSOA.SetFocus;
    22: IWEDITCIDADEPESSOA.SetFocus;
    23: IWEDITCEPPESSOA.SetFocus;
    24: IWEDITFONEPESSOA.SetFocus;
    25: IWEDITCELULARPESSOA.SetFocus;
    26: IWEDITCAIXAPOSTALPESSOA.SetFocus;
    27: IWEDITCODIGOPESSOA.SetFocus;
  end;
end;

procedure TF_Pessoa.IWEDITATIVIDADEPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITBAIRROPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITBANCODIVERSOSAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtBanco: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FBanco<>IWEDITBANCODIVERSOS.Text then
     begin
       UserSession.FBanco := IWEDITBANCODIVERSOS.Text;
       wmtBanco := RetornaRegistros('pessoas','nome',IWEDITBANCODIVERSOS.Text);
       if wmtBanco.RecordCount=1 then
          begin
            IWEDITBANCODIVERSOS.Text := wmtBanco.FieldByName('nome').AsString;
            IWEDITBANCODIVERSOS.Tag  := wmtBanco.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtBanco.RecordCount=0 then
               UserSession.FBanco := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaBancos(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalBanco'').modal(''show'');');
          end;
     end;
  IWEDITCONTADIVERSOS.SetFocus;
end;

procedure TF_Pessoa.IWEDITCAIXAPOSTALPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCARGOCONJUGEAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtAtividade: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCargoConjuge<>IWEDITCARGOCONJUGE.Text then
     begin
       UserSession.FTipoHelpAtividade := 'conjuge';
       UserSession.FCargoConjuge := IWEDITCARGOCONJUGE.Text;
       wmtAtividade := RetornaRegistros('atividades','nome',IWEDITCARGOCONJUGE.Text);
       if wmtAtividade.RecordCount=1 then
          begin
            IWEDITCARGOCONJUGE.Text := wmtAtividade.FieldByName('nome').AsString;
            IWEDITCARGOCONJUGE.Tag  := wmtAtividade.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtAtividade.RecordCount=0 then
               UserSession.FCargoConjuge := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaAtividades(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAtividade'').modal(''show'');');
          end;
     end;
  IWEDITSALARIOCONJUGE.SetFocus;
end;

procedure TF_Pessoa.IWEDITCELULARPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCEPPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCIDADECOBRANCAAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtLocalidade: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FNomeLocalidadeCobranca<>IWEDITCIDADECOBRANCA.Text then
     begin
       UserSession.FTipoHelpLocalidade := 'cobranca';
       UserSession.FLocalidadeCobranca := IWEDITCIDADECOBRANCA.Text;
       wmtLocalidade := RetornaRegistros('localidades','nome',IWEDITCIDADECOBRANCA.Text);
       if wmtLocalidade.RecordCount=1 then
          begin
            IWEDITCIDADECOBRANCA.Text := wmtLocalidade.FieldByName('nome').AsString+' - '+wmtLocalidade.FieldByName('uf').AsString;
            IWEDITCIDADECOBRANCA.Tag  := wmtLocalidade.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtLocalidade.RecordCount=0 then
               UserSession.FLocalidadeCobranca := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaLocalidades(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalLocalidade'').modal(''show'');');
          end;
     end;
  IWEDITCEPCOBRANCA.SetFocus;
end;

procedure TF_Pessoa.IWEDITCIDADEFIADORAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtLocalidade: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FNomeLocalidadeFiador<>IWEDITCIDADEFIADOR.Text then
     begin
       UserSession.FTipoHelpLocalidade := 'fiador';
       UserSession.FLocalidadeFiador   := IWEDITCIDADEFIADOR.Text;
       wmtLocalidade := RetornaRegistros('localidades','nome',IWEDITCIDADEFIADOR.Text);
       if wmtLocalidade.RecordCount=1 then
          begin
            IWEDITCIDADEFIADOR.Text := wmtLocalidade.FieldByName('nome').AsString+' - '+wmtLocalidade.FieldByName('uf').AsString;
            IWEDITCIDADEFIADOR.Tag  := wmtLocalidade.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtLocalidade.RecordCount=0 then
               UserSession.FLocalidadeFiador := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaLocalidades(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalLocalidade'').modal(''show'');');
          end;
     end;
  IWEDITCEPFIADOR.SetFocus;
end;

procedure TF_Pessoa.IWEDITCIDADEPESSOAAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtLocalidade: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FNomeLocalidade<>IWEDITCIDADEPESSOA.Text then
     begin
       UserSession.FTipoHelpLocalidade := 'pessoa';
       UserSession.FLocalidade := IWEDITCIDADEPESSOA.Text;
       wmtLocalidade := RetornaRegistros('localidades','nome',IWEDITCIDADEPESSOA.Text);
       if wmtLocalidade.RecordCount=1 then
          begin
            IWEDITCIDADEPESSOA.Text := wmtLocalidade.FieldByName('nome').AsString+' - '+wmtLocalidade.FieldByName('uf').AsString;
            IWEDITCIDADEPESSOA.Tag  := wmtLocalidade.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtLocalidade.RecordCount=0 then
               UserSession.FLocalidade := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaLocalidades(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalLocalidade'').modal(''show'');');
          end;
     end;
  IWEDITCEPPESSOA.SetFocus;
end;

procedure TF_Pessoa.IWEDITCIDADEPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCNPJPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCOBRANCADIVERSOSAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCobranca: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCobranca<>IWEDITCOBRANCADIVERSOS.Text then
     begin
       UserSession.FCobranca := IWEDITCOBRANCADIVERSOS.Text;
       wmtCobranca := RetornaRegistros('cobrancas','nome',IWEDITCOBRANCADIVERSOS.Text);
       if wmtCobranca.RecordCount=1 then
          begin
            IWEDITCOBRANCADIVERSOS.Text := wmtCobranca.FieldByName('nome').AsString;
            IWEDITCOBRANCADIVERSOS.Tag  := wmtCobranca.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCobranca.RecordCount=0 then
               UserSession.FCobranca := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCobrancas(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCobranca'').modal(''show'');');
          end;
     end;
  IWEDITCOMISSAODIVERSOS.SetFocus;
end;

procedure TF_Pessoa.IWEDITCOBRARDEDIVERSOSAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCliente: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCobrarDe<>IWEDITCOBRARDEDIVERSOS.Text then
     begin
       UserSession.FCobrarDe := IWEDITCOBRARDEDIVERSOS.Text;
       wmtCliente := RetornaRegistros('pessoas','nome',IWEDITCOBRARDEDIVERSOS.Text);
       if wmtCliente.RecordCount=1 then
          begin
            IWEDITCOBRARDEDIVERSOS.Text := wmtCliente.FieldByName('nome').AsString;
            IWEDITCOBRARDEDIVERSOS.Tag  := wmtCliente.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCliente.RecordCount=0 then
               UserSession.FCobrarDe := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaClientes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCliente'').modal(''show'');');
          end;
     end;
  IWEDITCOBRARDEDIVERSOS.SetFocus;
end;

procedure TF_Pessoa.IWEDITCODBANCOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCODIGOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCOMPLEMENTOCOBRANCAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCOMPLEMENTOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCONDICAODIVERSOSAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtCondicao: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FCondicao<>IWEDITCONDICAODIVERSOS.Text then
     begin
       UserSession.FCondicao := IWEDITCONDICAODIVERSOS.Text;
       wmtCondicao := RetornaRegistros('condicoes','descricao',IWEDITCONDICAODIVERSOS.Text);
       if wmtCondicao.RecordCount=1 then
          begin
            IWEDITCONDICAODIVERSOS.Text := wmtCondicao.FieldByName('descricao').AsString;
            IWEDITCONDICAODIVERSOS.Tag  := wmtCondicao.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtCondicao.RecordCount=0 then
               UserSession.FCondicao := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaCondicoes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalCondicao'').modal(''show'');');
          end;
     end;
  IWEDITPRAZODIVERSOS.SetFocus;
end;

procedure TF_Pessoa.IWEDITCONTATOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITCPFPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITEMAILPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITENDERECOCOBRANCAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITFONEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITIEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITIESUBSTITUTOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITIMPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITLOGRADOUROPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITNATURALIDADEAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtLocalidade: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FNomeNaturalidade<>IWEDITNATURALIDADE.Text then
     begin
       UserSession.FTipoHelpLocalidade := 'naturalidade';
       UserSession.FNaturalidade := IWEDITNATURALIDADE.Text;
       wmtLocalidade := RetornaRegistros('localidades','nome',IWEDITNATURALIDADE.Text);
       if wmtLocalidade.RecordCount=1 then
          begin
            IWEDITNATURALIDADE.Text := wmtLocalidade.FieldByName('nome').AsString+' - '+wmtLocalidade.FieldByName('uf').AsString;
            IWEDITNATURALIDADE.Tag  := wmtLocalidade.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtLocalidade.RecordCount=0 then
               UserSession.FNaturalidade := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaLocalidades(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalLocalidade'').modal(''show'');');
          end;
     end;
  IWEDITNOMEPAI.SetFocus;
end;

procedure TF_Pessoa.IWEDITNOMEFANTASIAPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITNOMEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITOBSERVACAOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITPASTAPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITQTDEMABERTOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITREPRESENTANTEDIVERSOSAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtRepresentante: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FRepresentante<>IWEDITREPRESENTANTEDIVERSOS.Text then
     begin
       UserSession.FRepresentante := IWEDITREPRESENTANTEDIVERSOS.Text;
       wmtRepresentante := RetornaRegistros('pessoas','nome',IWEDITREPRESENTANTEDIVERSOS.Text);
       if wmtRepresentante.RecordCount=1 then
          begin
            IWEDITREPRESENTANTEDIVERSOS.Text := wmtRepresentante.FieldByName('nome').AsString;
            IWEDITREPRESENTANTEDIVERSOS.Tag  := wmtRepresentante.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtRepresentante.RecordCount=0 then
               UserSession.FRepresentante := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaRepresentantes(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalRepresentante'').modal(''show'');');
          end;
     end;
  IWEDITREPRESENTANTEDIVERSOS.SetFocus;
end;

procedure TF_Pessoa.IWEDITRGPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITSITEPESSOAHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITSUFRAMAPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.IWEDITTABELADIVERSOSAsyncKeyUp(Sender: TObject;
  EventParams: TStringList);
var wchar,wparametro: string;
    ix: integer;
    wmtTabela: TFDMemTable;
begin
  wchar := EventParams.Strings[7];
  if not(wchar='which=13') then
     exit;
  if UserSession.FTabela<>IWEDITTABELADIVERSOS.Text then
     begin
       UserSession.FTabela := IWEDITTABELADIVERSOS.Text;
       wmtTabela := RetornaRegistros('tabelasprecos','descricao',IWEDITTABELADIVERSOS.Text);
       if wmtTabela.RecordCount=1 then
          begin
            IWEDITTABELADIVERSOS.Text := wmtTabela.FieldByName('descricao').AsString;
            IWEDITTABELADIVERSOS.Tag  := wmtTabela.FieldByName('id').AsInteger;
          end
       else
          begin
            if wmtTabela.RecordCount=0 then
               UserSession.FTabela := '';
            WebApplication.CallBackResponse.AddJavaScriptToExecute('carregaListaTabelas(10);'); // fecha lista
            WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalTabela'').modal(''show'');');
          end;
     end;
  IWEDITCREDITODIVERSOS.SetFocus;
end;

procedure TF_Pessoa.IWEDITTIPOCONTRIBUICAOPESSOAHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_Pessoa.PopulaCamposPessoa(XId: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(XId);
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;
    IWEDITNOMEPESSOA.Text             := wjson.GetValue('nome').Value;
    IWEDITCODIGOPESSOA.Text           := wjson.GetValue('codigo').Value;
    IWEDITCODIGOPESSOA.Tag            := strtointdef(wjson.GetValue('id').Value,0);
    IWEDITIDPESSOA.Text               := wjson.GetValue('id').Value;
    IWEDITCONTATOPESSOA.Text          := ifthen(wjson.GetValue('contato').Value='null','',wjson.GetValue('contato').Value);
    IWEDITNOMEFANTASIAPESSOA.Text     := ifthen(wjson.GetValue('nomefantasia').Value='null','',wjson.GetValue('nomefantasia').Value);
    IWEDITOBSERVACAOPESSOA.Text       := ifthen(wjson.GetValue('observacao').Value='null','',wjson.GetValue('observacao').Value);
    IWEDITATIVIDADEPESSOA.Text        := ifthen(wjson.GetValue('xatividade').Value='null','',wjson.GetValue('xatividade').Value);
    IWEDITATIVIDADEPESSOA.Tag         := strtoint(ifthen(wjson.GetValue('xatividade').Value='null','0',wjson.GetValue('idatividade').Value));
    IWEDITPASTAPESSOA.Text            := ifthen(wjson.GetValue('meurelatorioconfiguravel').Value='null','',wjson.GetValue('meurelatorioconfiguravel').Value);
    IWEDITCODBANCOPESSOA.Text         := ifthen(wjson.GetValue('agenciabanco').Value='null','',wjson.GetValue('agenciabanco').Value);
    IWEDITCPFPESSOA.Text              := ifthen(wjson.GetValue('cpf').Value='null','',wjson.GetValue('cpf').Value);
    IWEDITRGPESSOA.Text               := ifthen(wjson.GetValue('rg').Value='null','',wjson.GetValue('rg').Value);
    IWEDITCNPJPESSOA.Text             := ifthen(wjson.GetValue('cnpj').Value='null','',wjson.GetValue('cnpj').Value);
    IWEDITIEPESSOA.Text               := ifthen(wjson.GetValue('inscricaoestadual').Value='null','',wjson.GetValue('inscricaoestadual').Value);
    IWEDITIMPESSOA.Text               := ifthen(wjson.GetValue('inscricaomunicipal').Value='null','',wjson.GetValue('inscricaomunicipal').Value);
    IWEDITSUFRAMAPESSOA.Text          := ifthen(wjson.GetValue('suframa').Value='null','',wjson.GetValue('suframa').Value);
    IWEDITIESUBSTITUTOPESSOA.Text     := ifthen(wjson.GetValue('inscricaoestadualsubstituto').Value='null','',wjson.GetValue('inscricaoestadualsubstituto').Value);
//    IWEDITTIPOCONTRIBUICAOPESSOA.Text := ifthen(wjson.GetValue('identificadorinscricaoestadual').Value='null','',wjson.GetValue('identificadorinscricaoestadual').Value);
    IWEDITSITEPESSOA.Text             := ifthen(wjson.GetValue('site').Value='null','',wjson.GetValue('site').Value);
    IWEDITEMAILPESSOA.Text            := ifthen(wjson.GetValue('email').Value='null','',wjson.GetValue('email').Value);
    IWEDITLOGRADOUROPESSOA.Text       := ifthen(wjson.GetValue('endereco').Value='null','',wjson.GetValue('endereco').Value);
    IWEDITCOMPLEMENTOPESSOA.Text      := ifthen(wjson.GetValue('complemento').Value='null','',wjson.GetValue('complemento').Value);
    IWEDITBAIRROPESSOA.Text           := ifthen(wjson.GetValue('bairro').Value='null','',wjson.GetValue('bairro').Value);
    IWEDITCIDADEPESSOA.Text           := ifthen(wjson.GetValue('xnomelocalidade').Value='null','',wjson.GetValue('xnomelocalidade').Value);
    IWEDITCIDADEPESSOA.Tag            := strtoint(ifthen(wjson.GetValue('xnomelocalidade').Value='null','0',wjson.GetValue('idlocalidade').Value));
    IWEDITCEPPESSOA.Text              := ifthen(wjson.GetValue('cep').Value='null','',wjson.GetValue('cep').Value);
    IWEDITFONEPESSOA.Text             := ifthen(wjson.GetValue('telefone').Value='null','',wjson.GetValue('telefone').Value);
    IWEDITCELULARPESSOA.Text          := ifthen(wjson.GetValue('fax').Value='null','',wjson.GetValue('fax').Value);
    IWEDITCAIXAPOSTALPESSOA.Text      := ifthen(wjson.GetValue('caixapostal').Value='null','',wjson.GetValue('caixapostal').Value);
// COBRANÇA
    IWEDITENDERECOCOBRANCA.Text       := ifthen(wjson.GetValue('enderecocobranca').Value='null','',wjson.GetValue('enderecocobranca').Value);
    IWEDITCOMPLEMENTOCOBRANCA.Text    := ifthen(wjson.GetValue('complementocobranca').Value='null','',wjson.GetValue('complementocobranca').Value);
    IWEDITBAIRROCOBRANCA.Text         := ifthen(wjson.GetValue('bairrocobranca').Value='null','',wjson.GetValue('bairrocobranca').Value);
    IWEDITCIDADECOBRANCA.Text         := ifthen(wjson.GetValue('xnomelocalidadecobranca').Value='null','',wjson.GetValue('xnomelocalidadecobranca').Value);
    IWEDITCIDADECOBRANCA.Tag          := strtoint(ifthen(wjson.GetValue('xnomelocalidadecobranca').Value='null','0',wjson.GetValue('idlocalidadecobranca').Value));
    IWEDITCEPCOBRANCA.Text            := ifthen(wjson.GetValue('cepcobranca').Value='null','',wjson.GetValue('cepcobranca').Value);
    IWEDITFONECOBRANCA.Text           := ifthen(wjson.GetValue('telefonecobranca').Value='null','',wjson.GetValue('telefonecobranca').Value);
    IWEDITEMAILCOBRANCA.Text          := ifthen(wjson.GetValue('emailcobranca').Value='null','',wjson.GetValue('emailcobranca').Value);

// DIVERSOS
    IWEDITBANCODIVERSOS.Text          := ifthen(wjson.GetValue('xbanco').Value='null','',wjson.GetValue('xbanco').Value);
    IWEDITBANCODIVERSOS.Tag           := strtoint(ifthen(wjson.GetValue('xbanco').Value='null','0',wjson.GetValue('idbanco').Value));
    IWEDITCONTADIVERSOS.Text          := ifthen(wjson.GetValue('ctacorrente').Value='null','',wjson.GetValue('ctacorrente').Value);
    IWEDITCOBRANCADIVERSOS.Text       := ifthen(wjson.GetValue('xcobranca').Value='null','',wjson.GetValue('xcobranca').Value);
    IWEDITCOBRANCADIVERSOS.Tag        := strtoint(ifthen(wjson.GetValue('xcobranca').Value='null','0',wjson.GetValue('idcobranca').Value));
    IWEDITCOMISSAODIVERSOS.Text       := ifthen(wjson.GetValue('perccomissao').Value='0','',wjson.GetValue('perccomissao').Value);
    IWEDITCOBRARDEDIVERSOS.Text       := ifthen(wjson.GetValue('xcobrarde').Value='null','',wjson.GetValue('xcobrarde').Value);
    IWEDITCOBRARDEDIVERSOS.Tag        := strtoint(ifthen(wjson.GetValue('xcobrarde').Value='null','0',wjson.GetValue('idalvo').Value));
    IWEDITTABELADIVERSOS.Text         := ifthen(wjson.GetValue('xtabela').Value='null','',wjson.GetValue('xtabela').Value);
    IWEDITTABELADIVERSOS.Tag          := strtoint(ifthen(wjson.GetValue('xtabela').Value='null','0',wjson.GetValue('idtabelapreco').Value));
    IWEDITCONDICAODIVERSOS.Text       := ifthen(wjson.GetValue('xcondicao').Value='null','',wjson.GetValue('xcondicao').Value);
    IWEDITCONDICAODIVERSOS.Tag        := strtoint(ifthen(wjson.GetValue('xcondicao').Value='null','0',wjson.GetValue('idcondicao').Value));
    IWEDITPRAZODIVERSOS.Text          := ifthen(wjson.GetValue('prazocondicao').Value='0','',wjson.GetValue('prazocondicao').Value);
    IWEDITREFERENCIA1DIVERSOS.Text    := ifthen(wjson.GetValue('referenciacomercial1').Value='null','',wjson.GetValue('referenciacomercial1').Value);
    IWEDITREFERENCIA2DIVERSOS.Text    := ifthen(wjson.GetValue('referenciacomercial2').Value='null','',wjson.GetValue('referenciacomercial2').Value);
    IWEDITLIMITECOMPRADIVERSOS.Text   := ifthen(wjson.GetValue('limitecredito').Value='0','',wjson.GetValue('limitecredito').Value);
    IWEDITLIMITEFATURARDIVERSOS.Text  := ifthen(wjson.GetValue('valorfaturar').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('valorfaturar').Value,0)));
    IWEDITCADASTRAMENTODIVERSOS.Text  := ifthen(wjson.GetValue('datacadastramento').Value='null','',formatdatetime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datacadastramento').Value)));
    IWEDITREPRESENTANTEDIVERSOS.Text  := ifthen(wjson.GetValue('xrepresentante').Value='null','',wjson.GetValue('xrepresentante').Value);
    IWEDITREPRESENTANTEDIVERSOS.Tag   := strtoint(ifthen(wjson.GetValue('xrepresentante').Value='null','0',wjson.GetValue('idrepresentante').Value));

// Fisica/Juridica
    IWEDITDATANASCIMENTO.Text         := ifthen(wjson.GetValue('datanascimento').Value='null','',FormatDateTime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datanascimento').Value)));
    IWEDITSALARIO.Text                := ifthen(wjson.GetValue('salario').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('salario').Value,0)));
    IWEDITNATURALIDADE.Text           := ifthen(wjson.GetValue('xnomenaturalidade').Value='null','',wjson.GetValue('xnomenaturalidade').Value);
    IWEDITNATURALIDADE.Tag            := strtoint(ifthen(wjson.GetValue('xnomenaturalidade').Value='null','0',wjson.GetValue('idnaturalidade').Value));
    IWEDITNOMEPAI.Text                := ifthen(wjson.GetValue('nomepai').Value='null','',wjson.GetValue('nomepai').Value);
    IWEDITNOMEMAE.Text                := ifthen(wjson.GetValue('nomemae').Value='null','',wjson.GetValue('nomemae').Value);
    IWEDITNOMEEMPRESA.Text            := ifthen(wjson.GetValue('nomeempresa').Value='null','',wjson.GetValue('nomeempresa').Value);
    IWEDITENDERECOEMPRESA.Text        := ifthen(wjson.GetValue('enderecotrabalho').Value='null','',wjson.GetValue('enderecotrabalho').Value);
    IWEDITCEPEMPRESA.Text             := ifthen(wjson.GetValue('ceptrabalho').Value='null','',wjson.GetValue('ceptrabalho').Value);
    IWEDITBAIRROEMPRESA.Text          := ifthen(wjson.GetValue('bairrotrabalho').Value='null','',wjson.GetValue('bairrotrabalho').Value);
    IWEDITFONEEMPRESA.Text            := ifthen(wjson.GetValue('telefonetrabalho').Value='null','',wjson.GetValue('telefonetrabalho').Value);
    IWEDITNOMEDIRETOR1EMPRESA.Text    := ifthen(wjson.GetValue('nomediretor1empresa').Value='null','',wjson.GetValue('nomediretor1empresa').Value);
    IWEDITNOMEDIRETOR2EMPRESA.Text    := ifthen(wjson.GetValue('nomediretor2empresa').Value='null','',wjson.GetValue('nomediretor2empresa').Value);
    IWEDITDATAFUNDACAOEMPRESA.Text    := ifthen(wjson.GetValue('datafundacaoempresa').Value='null','',FormatDateTime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datafundacaoempresa').Value)));
// FIADOR
    PopulaCamposFiador(wjson.GetValue('id').Value);
// Conjuge
    IWEDITNOMECONJUGE.Text            := ifthen(wjson.GetValue('nomeconjuge').Value='null','',wjson.GetValue('nomeconjuge').Value);
    IWEDITDATANASCIMENTOCONJUGE.Text  := ifthen(wjson.GetValue('datanascimentoconjuge').Value='null','',FormatDateTime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datanascimentoconjuge').Value)));
    IWEDITEMPRESACONJUGE.Text         := ifthen(wjson.GetValue('nomeempresaconjuge').Value='null','',wjson.GetValue('nomeempresaconjuge').Value);
    IWEDITSALARIOCONJUGE.Text         := ifthen(wjson.GetValue('salarioconjuge').Value='null','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('salarioconjuge').Value,0)));
    IWEDITCARGOCONJUGE.Text           := ifthen(wjson.GetValue('xatividadeconjuge').Value='null','',wjson.GetValue('xatividadeconjuge').Value);
    IWEDITCARGOCONJUGE.Tag            := strtoint(ifthen(wjson.GetValue('xatividadeconjuge').Value='null','0',wjson.GetValue('idatividadeconjuge').Value));

    UserSession.FAtividade              := IWEDITATIVIDADEPESSOA.Text;
    UserSession.FLocalidade             := wjson.GetValue('xlocalidade').Value;
    UserSession.FNomeLocalidade         := IWEDITCIDADEPESSOA.Text;
    UserSession.FLocalidadeCobranca     := wjson.GetValue('xlocalidadecobranca').Value;
    UserSession.FNomeLocalidadeCobranca := IWEDITCIDADECOBRANCA.Text;
    UserSession.FBanco                  := IWEDITBANCODIVERSOS.Text;
    UserSession.FCobranca               := IWEDITCOBRANCADIVERSOS.Text;
    UserSession.FCobrarDe               := IWEDITCOBRARDEDIVERSOS.Text;
    UserSession.FTabela                 := IWEDITTABELADIVERSOS.Text;
    UserSession.FNaturalidade           := IWEDITNATURALIDADE.Text;
    UserSession.FCondicao               := IWEDITCONDICAODIVERSOS.Text;
    UserSession.FCargoConjuge           := IWEDITCARGOCONJUGE.Text;
    UserSession.FIdPessoa               := strtoint(wjson.GetValue('id').Value);
    CarregaGeral(wjson);
    CarregaClassificacao(wjson);
    CarregaOutros(wjson);
    CarregaSelect(wjson);
    IWEDITCODIGOPESSOA.SetFocus;
  except
    on E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao popular campos da pessoa'+slinebreak+E.Message);
    end;
  end;
end;

procedure TF_Pessoa.PopulaCamposFiador(XIdPessoa: string);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome,werro: string;
    warqini: TIniFile;
    wjsonarray: TJSONArray;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+XIdPessoa+'/fiadores';
    wretjson   := wIdHTTP.Get(URL);
    wjsonarray := TJSONObject.ParseJSONValue(wretjson) as TJSONArray;
    wjson      := wjsonarray.Items[0] as TJSONObject;
    FIdFiador                    := strtoint(wjson.GetValue('id').Value);
    IWEDITNOMEFIADOR.Text        := ifthen(wjson.GetValue('nome').Value='null','',wjson.GetValue('nome').Value);
    IWEDITCPFFIADOR.Text         := ifthen(wjson.GetValue('cpf').Value='null','',wjson.GetValue('cpf').Value);
    IWEDITRGFIADOR.Text          := ifthen(wjson.GetValue('rg').Value='null','',wjson.GetValue('rg').Value);
    IWEDITENDERECOFIADOR.Text    := ifthen(wjson.GetValue('endereco').Value='null','',wjson.GetValue('endereco').Value);
    IWEDITBAIRROFIADOR.Text      := ifthen(wjson.GetValue('bairro').Value='null','',wjson.GetValue('bairro').Value);
    IWEDITCIDADEFIADOR.Text      := ifthen(wjson.GetValue('xnomelocalidade').Value='null','',wjson.GetValue('xnomelocalidade').Value);
    IWEDITCIDADEFIADOR.Tag       := strtointdef(wjson.GetValue('idlocalidade').Value,0);
    IWEDITCEPFIADOR.Text         := ifthen(wjson.GetValue('cep').Value='null','',wjson.GetValue('cep').Value);
    IWEDITFONEFIADOR.Text        := ifthen(wjson.GetValue('telefone').Value='null','',wjson.GetValue('telefone').Value);
  except
    On E: Exception do
    begin
      werro := E.Message;
      FIdFiador                  := 0;
      IWEDITNOMEFIADOR.Text      := '';
      IWEDITCPFFIADOR.Text       := '';
      IWEDITRGFIADOR.Text        := '';
      IWEDITENDERECOFIADOR.Text  := '';
      IWEDITBAIRROFIADOR.Text    := '';
      IWEDITCIDADEFIADOR.Text    := '';
      IWEDITCIDADEFIADOR.Tag     := 0;
      IWEDITCEPFIADOR.Text       := '';
      IWEDITFONEFIADOR.Text      := '';
    end;
  end;
end;


procedure TF_Pessoa.CarregaClassificacao(XJSON: TJSONObject);
var wparametro,wehbanco,wehconvenio,wehcliente,wehfornecedor,wehfuncionario,wehrepresentante,wehtransportadora,wehmobile,wehoftalmogista,wehmedico: string;
begin
  try
    wehbanco         := ifthen(XJSON.GetValue('ehbanco').Value='true','1','0');
    wehconvenio      := ifthen(XJSON.GetValue('ehconvenio').Value='true','1','0');
    wehcliente       := ifthen(XJSON.GetValue('ehcliente').Value='true','1','0');
    wehfornecedor    := ifthen(XJSON.GetValue('ehfornecedor').Value='true','1','0');
    wehfuncionario   := ifthen(XJSON.GetValue('ehfuncionario').Value='true','1','0');
    wehrepresentante := ifthen(XJSON.GetValue('ehrepresentante').Value='true','1','0');
    wehtransportadora:= ifthen(XJSON.GetValue('ehtransportador').Value='true','1','0');
    wehmobile        := ifthen(XJSON.GetValue('ehrepresentantemobile').Value='true','1','0');
    wehoftalmogista  := ifthen(XJSON.GetValue('ehoftalmo').Value='true','1','0');
    wehmedico        := ifthen(XJSON.GetValue('ehmedico').Value='true','1','0');
    wparametro       := wehbanco+wehconvenio+wehcliente+wehfornecedor+wehfuncionario+wehrepresentante+wehtransportadora+wehmobile+wehoftalmogista+wehmedico;
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaClassificacao('+QuotedStr(wparametro)+');');
  finally
  end;
end;

procedure TF_Pessoa.CarregaGeral(XJSON: TJSONObject);
var wparametro,wativo,wpessoafisica,wverifica,wetiqueta,wprecadastro,wdevolucao,wreidi: string;
begin
  try
    wativo           := ifthen(XJSON.GetValue('ativo').Value='true','1','0');
    wpessoafisica    := ifthen(XJSON.GetValue('ehfisica').Value='true','1','0');
    wverifica        := ifthen(XJSON.GetValue('verificadebitos').Value='true','1','0');
    wetiqueta        := ifthen(XJSON.GetValue('emiteetiqueta').Value='true','1','0');
    wprecadastro     := ifthen(XJSON.GetValue('ehprecadastro').Value='true','1','0');
    wdevolucao       := ifthen(XJSON.GetValue('aceitadevolucao').Value='true','1','0');
    wreidi           := ifthen(XJSON.GetValue('participantereidi').Value='true','1','0');
    wparametro       := wativo+wpessoafisica+wverifica+wetiqueta+wprecadastro+wdevolucao+wreidi;
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaGeral('+QuotedStr(wparametro)+');');
  finally
  end;
end;

procedure TF_Pessoa.CarregaOutros(XJSON: TJSONObject);
var wparametro,wretencoes,wremessas,wehrevendedor: string;
begin
  try
    wretencoes       := ifthen(XJSON.GetValue('habilitarcalculoretencao').Value='true','1','0');
    wremessas        := ifthen(XJSON.GetValue('naogeraremessa').Value='true','1','0');
    wehrevendedor    := ifthen(XJSON.GetValue('ehclienterevenda').Value='true','1','0');
    wparametro       := wretencoes+wremessas+wehrevendedor;
    WebApplication.CallBackResponse.AddJavaScriptToExecute('montaOutros('+QuotedStr(wparametro)+');');
  finally
  end;
end;


procedure TF_Pessoa.CarregaSelect(XJSON: TJSONObject);
var wcontribuicao,westadocivil,wgenero: string;
begin
  try
     wcontribuicao := XJSON.GetValue('identificadorinscricaoestadual').Value;
     westadocivil  := XJSON.GetValue('estadocivil').Value;
     wgenero       := XJSON.GetValue('sexo').Value;
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectcontribuicao").val('+QuotedStr(wcontribuicao)+');');
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectestadocivil").val('+QuotedStr(westadocivil)+');');
     WebApplication.CallBackResponse.AddJavaScriptToExecute('$("#selectgenero").val('+QuotedStr(wgenero)+');');
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Problema ao carregar campos de select'+slinebreak+E.Message);
    end;
  end;
end;

function TF_Pessoa.ConfirmaPessoa(XId: integer): boolean;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno,wuf,wregiao: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wpessoa: TJSONObject;
begin
  try
    wpessoa := TJSONObject.Create;
    wpessoa.AddPair('codigo',IWEDITCODIGOPESSOA.Text);
    wpessoa.AddPair('nome',IWEDITNOMEPESSOA.Text);
    wpessoa.AddPair('ativo',BoolToStr(IWEDITATIVO.Text='SIM'));
    wpessoa.AddPair('ehfisica',BoolToStr(IWEDITPESSOAFISICA.Text='SIM'));
    wpessoa.AddPair('verificadebitos',BoolToStr(IWEDITVERIFICADEBITOS.Text='SIM'));
    wpessoa.AddPair('emiteetiqueta',BoolToStr(IWEDITEMITEETIQUETA.Text='SIM'));
    wpessoa.AddPair('ehprecadastro',BoolToStr(IWEDITPRECADASTRO.Text='SIM'));
    wpessoa.AddPair('aceitadevolucao',BoolToStr(IWEDITACEITADEVOLUCAO.Text='SIM'));
    wpessoa.AddPair('participantereidi',BoolToStr(IWEDITREIDI.Text='SIM'));
    wpessoa.AddPair('contato',ifthen(Length(trim(IWEDITCONTATOPESSOA.Text))>0,IWEDITCONTATOPESSOA.Text,'null'));
    wpessoa.AddPair('observacao',ifthen(Length(trim(IWEDITOBSERVACAOPESSOA.Text))>0,IWEDITOBSERVACAOPESSOA.Text,'null'));
    wpessoa.AddPair('nomefantasia',ifthen(Length(trim(IWEDITNOMEFANTASIAPESSOA.Text))>0,IWEDITNOMEFANTASIAPESSOA.Text,'null'));
    wpessoa.AddPair('idatividade',ifthen(Length(trim(IWEDITATIVIDADEPESSOA.Text))>0,inttostr(IWEDITATIVIDADEPESSOA.Tag),'0'));
    wpessoa.AddPair('meurelatorioconfiguravel',ifthen(Length(trim(IWEDITPASTAPESSOA.Text))>0,IWEDITPASTAPESSOA.Text,'null'));
    wpessoa.AddPair('agenciabanco',ifthen(Length(trim(IWEDITCODBANCOPESSOA.Text))>0,IWEDITCODBANCOPESSOA.Text,'null'));
    wpessoa.AddPair('cpf',ifthen(Length(trim(IWEDITCPFPESSOA.Text))>0,IWEDITCPFPESSOA.Text,'null'));
    wpessoa.AddPair('rg',ifthen(Length(trim(IWEDITRGPESSOA.Text))>0,IWEDITRGPESSOA.Text,'null'));
    wpessoa.AddPair('cnpj',ifthen(Length(trim(IWEDITCNPJPESSOA.Text))>0,IWEDITCNPJPESSOA.Text,'null'));
    wpessoa.AddPair('inscricaoestadual',ifthen(Length(trim(IWEDITIEPESSOA.Text))>0,IWEDITIEPESSOA.Text,'null'));
    wpessoa.AddPair('inscricaomunicipal',ifthen(Length(trim(IWEDITIMPESSOA.Text))>0,IWEDITIMPESSOA.Text,'null'));
    wpessoa.AddPair('suframa',ifthen(Length(trim(IWEDITSUFRAMAPESSOA.Text))>0,IWEDITSUFRAMAPESSOA.Text,'null'));
    wpessoa.AddPair('inscricaoestadualsubstituto',ifthen(Length(trim(IWEDITIESUBSTITUTOPESSOA.Text))>0,IWEDITIESUBSTITUTOPESSOA.Text,'null'));
    wpessoa.AddPair('identificadorinscricaoestadual',ifthen(Length(trim(IWEDITCONTRIBUICAO.Text))>0,IWEDITCONTRIBUICAO.Text,'null'));
    wpessoa.AddPair('site',ifthen(Length(trim(IWEDITSITEPESSOA.Text))>0,IWEDITSITEPESSOA.Text,'null'));
    wpessoa.AddPair('email',ifthen(Length(trim(IWEDITEMAILPESSOA.Text))>0,IWEDITEMAILPESSOA.Text,'null'));
    wpessoa.AddPair('endereco',ifthen(Length(trim(IWEDITLOGRADOUROPESSOA.Text))>0,IWEDITLOGRADOUROPESSOA.Text,'null'));
    wpessoa.AddPair('complemento',ifthen(Length(trim(IWEDITCOMPLEMENTOPESSOA.Text))>0,IWEDITCOMPLEMENTOPESSOA.Text,'null'));
    wpessoa.AddPair('bairro',ifthen(Length(trim(IWEDITBAIRROPESSOA.Text))>0,IWEDITBAIRROPESSOA.Text,'null'));
    wpessoa.AddPair('idlocalidade',ifthen(Length(trim(IWEDITCIDADEPESSOA.Text))>0,inttostr(IWEDITCIDADEPESSOA.Tag),'0'));
    wpessoa.AddPair('cep',ifthen(Length(trim(IWEDITCEPPESSOA.Text))>0,IWEDITCEPPESSOA.Text,'null'));
    wpessoa.AddPair('telefone',ifthen(Length(trim(IWEDITFONEPESSOA.Text))>0,IWEDITFONEPESSOA.Text,'null'));
    wpessoa.AddPair('fax',ifthen(Length(trim(IWEDITCELULARPESSOA.Text))>0,IWEDITCELULARPESSOA.Text,'null'));
    wpessoa.AddPair('caixapostal',ifthen(Length(trim(IWEDITCAIXAPOSTALPESSOA.Text))>0,IWEDITCAIXAPOSTALPESSOA.Text,'null'));

    wpessoa.AddPair('ehbanco',BoolToStr(IWEDITBANCO.Text='SIM'));
    wpessoa.AddPair('ehcliente',BoolToStr(IWEDITCLIENTE.Text='SIM'));
    wpessoa.AddPair('ehconvenio',BoolToStr(IWEDITCONVENIO.Text='SIM'));
    wpessoa.AddPair('ehfornecedor',BoolToStr(IWEDITFORNECEDOR.Text='SIM'));
    wpessoa.AddPair('ehfuncionario',BoolToStr(IWEDITFUNCIONARIO.Text='SIM'));
    wpessoa.AddPair('ehrepresentante',BoolToStr(IWEDITREPRESENTANTE.Text='SIM'));
    wpessoa.AddPair('ehtransportador',BoolToStr(IWEDITTRANSPORTADORA.Text='SIM'));
    wpessoa.AddPair('ehrepresentantemobile',BoolToStr(IWEDITMOBILE.Text='SIM'));
    wpessoa.AddPair('ehoftalmo',BoolToStr(IWEDITOFTALMO.Text='SIM'));
    wpessoa.AddPair('ehmedico',BoolToStr(IWEDITMEDICO.Text='SIM'));

// Cobrança
    wpessoa.AddPair('enderecocobranca',ifthen(Length(trim(IWEDITENDERECOCOBRANCA.Text))>0,IWEDITENDERECOCOBRANCA.Text,'null'));
    wpessoa.AddPair('complementocobranca',ifthen(Length(trim(IWEDITCOMPLEMENTOCOBRANCA.Text))>0,IWEDITCOMPLEMENTOCOBRANCA.Text,'null'));
    wpessoa.AddPair('bairrocobranca',ifthen(Length(trim(IWEDITBAIRROCOBRANCA.Text))>0,IWEDITBAIRROCOBRANCA.Text,'null'));
    wpessoa.AddPair('cepcobranca',ifthen(Length(trim(IWEDITCEPCOBRANCA.Text))>0,IWEDITCEPCOBRANCA.Text,'null'));
    wpessoa.AddPair('telefonecobranca',ifthen(Length(trim(IWEDITFONECOBRANCA.Text))>0,IWEDITFONECOBRANCA.Text,'null'));
    wpessoa.AddPair('emailcobranca',ifthen(Length(trim(IWEDITEMAILCOBRANCA.Text))>0,IWEDITEMAILCOBRANCA.Text,'null'));
    wpessoa.AddPair('idlocalidadecobranca',ifthen(Length(trim(IWEDITCIDADECOBRANCA.Text))>0,inttostr(IWEDITCIDADECOBRANCA.Tag),'0'));

// Diversos
    wpessoa.AddPair('habilitarcalculoretencao',BoolToStr(IWEDITRETENCOES.Text='SIM'));
    wpessoa.AddPair('naogeraremessa',BoolToStr(IWEDITREMESSAS.Text='SIM'));
    wpessoa.AddPair('ehclienterevenda',BoolToStr(IWEDITREVENDEDOR.Text='SIM'));
    wpessoa.AddPair('idbanco',ifthen(Length(trim(IWEDITBANCODIVERSOS.Text))>0,inttostr(IWEDITBANCODIVERSOS.Tag),'0'));
    wpessoa.AddPair('ctacorrente',ifthen(Length(trim(IWEDITCONTADIVERSOS.Text))>0,IWEDITCONTADIVERSOS.Text,'null'));
    wpessoa.AddPair('idcobranca',ifthen(Length(trim(IWEDITCOBRANCADIVERSOS.Text))>0,inttostr(IWEDITCOBRANCADIVERSOS.Tag),'0'));
    wpessoa.AddPair('idalvo',ifthen(Length(trim(IWEDITCOBRARDEDIVERSOS.Text))>0,inttostr(IWEDITCOBRARDEDIVERSOS.Tag),'0'));
    wpessoa.AddPair('perccomissao',ifthen(Length(trim(IWEDITCOMISSAODIVERSOS.Text))>0,IWEDITCOMISSAODIVERSOS.Text,'0'));
    wpessoa.AddPair('idtabelapreco',ifthen(Length(trim(IWEDITTABELADIVERSOS.Text))>0,inttostr(IWEDITTABELADIVERSOS.Tag),'0'));
    wpessoa.AddPair('idcondicao',ifthen(Length(trim(IWEDITCONDICAODIVERSOS.Text))>0,inttostr(IWEDITCONDICAODIVERSOS.Tag),'0'));
    wpessoa.AddPair('prazocondicao',ifthen(Length(trim(IWEDITPRAZODIVERSOS.Text))>0,IWEDITPRAZODIVERSOS.Text,'0'));
    wpessoa.AddPair('referenciacomercial1',ifthen(Length(trim(IWEDITREFERENCIA1DIVERSOS.Text))>0,IWEDITREFERENCIA1DIVERSOS.Text,'null'));
    wpessoa.AddPair('referenciacomercial2',ifthen(Length(trim(IWEDITREFERENCIA2DIVERSOS.Text))>0,IWEDITREFERENCIA2DIVERSOS.Text,'null'));
    wpessoa.AddPair('limitecredito',ifthen(Length(trim(IWEDITLIMITECOMPRADIVERSOS.Text))>0,IWEDITLIMITECOMPRADIVERSOS.Text,'0'));
    wpessoa.AddPair('valorfaturar',ifthen(Length(trim(IWEDITLIMITEFATURARDIVERSOS.Text))>0,IWEDITLIMITEFATURARDIVERSOS.Text,'0'));
    wpessoa.AddPair('idrepresentante',ifthen(Length(trim(IWEDITREPRESENTANTEDIVERSOS.Text))>0,inttostr(IWEDITREPRESENTANTEDIVERSOS.Tag),'0'));

// Fisica/Juridica
    wpessoa.AddPair('estadocivil',ifthen(Length(trim(IWEDITESTADOCIVIL.Text))>0,IWEDITESTADOCIVIL.Text,'null'));
    wpessoa.AddPair('sexo',ifthen(Length(trim(IWEDITGENERO.Text))>0,IWEDITGENERO.Text,'null'));
    wpessoa.AddPair('datanascimento',ifthen(Length(trim(IWEDITDATANASCIMENTO.Text))>0,IWEDITDATANASCIMENTO.Text,'null'));
    wpessoa.AddPair('salario',ifthen(Length(trim(IWEDITSALARIO.Text))>0,IWEDITSALARIO.Text,'0'));
    wpessoa.AddPair('idnaturalidade',ifthen(Length(trim(IWEDITNATURALIDADE.Text))>0,inttostr(IWEDITNATURALIDADE.Tag),'0'));
    wpessoa.AddPair('nomepai',ifthen(Length(trim(IWEDITNOMEPAI.Text))>0,IWEDITNOMEPAI.Text,'null'));
    wpessoa.AddPair('nomemae',ifthen(Length(trim(IWEDITNOMEMAE.Text))>0,IWEDITNOMEMAE.Text,'null'));
    wpessoa.AddPair('nomeempresa',ifthen(Length(trim(IWEDITNOMEEMPRESA.Text))>0,IWEDITNOMEEMPRESA.Text,'null'));
    wpessoa.AddPair('enderecotrabalho',ifthen(Length(trim(IWEDITENDERECOEMPRESA.Text))>0,IWEDITENDERECOEMPRESA.Text,'null'));
    wpessoa.AddPair('ceptrabalho',ifthen(Length(trim(IWEDITCEPEMPRESA.Text))>0,IWEDITCEPEMPRESA.Text,'null'));
    wpessoa.AddPair('bairrotrabalho',ifthen(Length(trim(IWEDITBAIRROEMPRESA.Text))>0,IWEDITBAIRROEMPRESA.Text,'null'));
    wpessoa.AddPair('telefonetrabalho',ifthen(Length(trim(IWEDITFONEEMPRESA.Text))>0,IWEDITFONEEMPRESA.Text,'null'));
    wpessoa.AddPair('nomediretor1empresa',ifthen(Length(trim(IWEDITNOMEDIRETOR1EMPRESA.Text))>0,IWEDITNOMEDIRETOR1EMPRESA.Text,'null'));
    wpessoa.AddPair('nomediretor2empresa',ifthen(Length(trim(IWEDITNOMEDIRETOR2EMPRESA.Text))>0,IWEDITNOMEDIRETOR2EMPRESA.Text,'null'));
    wpessoa.AddPair('datafundacaoempresa',ifthen(Length(trim(IWEDITDATAFUNDACAOEMPRESA.Text))>0,IWEDITDATAFUNDACAOEMPRESA.Text,'null'));

// Conjuge
    wpessoa.AddPair('nomeconjuge',ifthen(Length(trim(IWEDITNOMECONJUGE.Text))>0,IWEDITNOMECONJUGE.Text,'null'));
    wpessoa.AddPair('datanascimentoconjuge',ifthen(Length(trim(IWEDITDATANASCIMENTOCONJUGE.Text))>0,IWEDITDATANASCIMENTOCONJUGE.Text,'null'));
    wpessoa.AddPair('nomeempresaconjuge',ifthen(Length(trim(IWEDITEMPRESACONJUGE.Text))>0,IWEDITEMPRESACONJUGE.Text,'null'));
    wpessoa.AddPair('salarioconjuge',ifthen(Length(trim(IWEDITSALARIOCONJUGE.Text))>0,IWEDITSALARIOCONJUGE.Text,'0'));
    wpessoa.AddPair('idatividadeconjuge',ifthen(Length(trim(IWEDITCARGOCONJUGE.Text))>0,inttostr(IWEDITCARGOCONJUGE.Tag),'0'));

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
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(XId);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);

    if (FIdFiador>0) and (Length(trim(IWEDITNOMEFIADOR.Text))>0) then // altera Fiador
       AlteraFiador(XId,FIdFiador)
    else if (FIdFiador>0) and (Length(trim(IWEDITNOMEFIADOR.Text))=0) then // exclui Fiador
//       ExcluiFiador(XId,FIdFiador)
    else if (FIdFiador=0) and (Length(trim(IWEDITNOMEFIADOR.Text))>0) then // inclui Fiador
       IncluiFiador(XId);

    wret        := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao alterar pessoa'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_Pessoa.AlteraFiador(XIdPessoa,XIdFiador: integer);
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    wret: boolean;
    URL,wretorno,werro: string;
    warqini: TIniFile;
    wjsontosend: TStringStream;
    wfiador: TJSONObject;
begin
  try
    wfiador := TJSONObject.Create;
    wfiador.AddPair('nome',IWEDITNOMEFIADOR.Text);
    wfiador.AddPair('cpf',ifthen(Length(trim(IWEDITCPFFIADOR.Text))>0,IWEDITCPFFIADOR.Text,'null'));
    wfiador.AddPair('rg',ifthen(Length(trim(IWEDITRGFIADOR.Text))>0,IWEDITRGFIADOR.Text,'null'));
    wfiador.AddPair('endereco',ifthen(Length(trim(IWEDITENDERECOFIADOR.Text))>0,IWEDITENDERECOFIADOR.Text,'null'));
    wfiador.AddPair('bairro',ifthen(Length(trim(IWEDITBAIRROFIADOR.Text))>0,IWEDITBAIRROFIADOR.Text,'null'));
    wfiador.AddPair('idlocalidade',ifthen(Length(trim(IWEDITCIDADEFIADOR.Text))>0,inttostr(IWEDITCIDADEFIADOR.Tag),'0'));
    wfiador.AddPair('cep',ifthen(Length(trim(IWEDITCEPFIADOR.Text))>0,IWEDITCEPFIADOR.Text,'null'));
    wfiador.AddPair('telefone',ifthen(Length(trim(IWEDITFONEFIADOR.Text))>0,IWEDITFONEFIADOR.Text,'null'));

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

    wJsonToSend := TStringStream.Create(wfiador.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(XIdPessoa)+'/fiadores/'+inttostr(XIdFiador);
    // PUT
    wretorno    := wIdHTTP.Put(URL,wjsontosend);

{    if (FIdFiador>0) and (Length(trim(IWEDITNOMEFIADOR.Text))>0) then // altera Fiador
       AlteraFiador(XId,FIdFiador)
    else if (FIdFiador>0) and (Length(trim(IWEDITNOMEFIADOR.Text))=0) then // exclui Fiador
//       ExcluiFiador(XId,FIdFiador)
    else if (FIdFiador=0) and (Length(trim(IWEDITNOMEFIADOR.Text))>0) then // inclui Fiador
       IncluiFiador(XId);

    wret        := true;}
  except
    On E: Exception do
    begin
      werro := E.Message;
    end;
  end;
end;


procedure TF_Pessoa.IncluiFiador(XIdPessoa: integer);
var wret: boolean;
    wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wretorno: string;
    warqini: TIniFile;
    wjson: TJSONObject;
    wjsontosend: TStringStream;
    wfiador,JObj: TJSONObject;
begin
  try
    wfiador := TJSONObject.Create;
    wfiador.AddPair('nome',IWEDITNOMEFIADOR.Text);
    wfiador.AddPair('cpf',ifthen(Length(trim(IWEDITCPFFIADOR.Text))>0,IWEDITCPFFIADOR.Text,'null'));
    wfiador.AddPair('rg',ifthen(Length(trim(IWEDITRGFIADOR.Text))>0,IWEDITRGFIADOR.Text,'null'));
    wfiador.AddPair('endereco',ifthen(Length(trim(IWEDITENDERECOFIADOR.Text))>0,IWEDITENDERECOFIADOR.Text,'null'));
    wfiador.AddPair('bairro',ifthen(Length(trim(IWEDITBAIRROFIADOR.Text))>0,IWEDITBAIRROFIADOR.Text,'null'));
    wfiador.AddPair('idlocalidade',ifthen(Length(trim(IWEDITCIDADEFIADOR.Text))>0,inttostr(IWEDITCIDADEFIADOR.Tag),'0'));
    wfiador.AddPair('cep',ifthen(Length(trim(IWEDITCEPFIADOR.Text))>0,IWEDITCEPFIADOR.Text,'null'));
    wfiador.AddPair('telefone',ifthen(Length(trim(IWEDITFONEFIADOR.Text))>0,IWEDITFONEFIADOR.Text,'null'));

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

    wJsonToSend := TStringStream.Create(wfiador.ToString, TEncoding.UTF8);
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(XIdPessoa)+'/fiadores';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    JObj        := TJSONObject.ParseJSONValue(wretorno) as TJSONObject;
{    if strtointdef(JObj.GetValue('id').Value,0)>0 then
       begin
         wret   := true;
         PopulaCamposPessoa(strtointdef(JObj.GetValue('id').Value,0));
       end
    else
       wret     := false;}
  except

  end;
end;

function TF_Pessoa.RetornaRegistros(XRecurso,XCampo,XValor: string): TFDMemTable;
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

function TF_Pessoa.IncluiPessoa: boolean;
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
    wpessoa.AddPair('codigo',IWEDITCODIGOPESSOA.Text);
    wpessoa.AddPair('nome',IWEDITNOMEPESSOA.Text);
    wpessoa.AddPair('ativo',BoolToStr(IWEDITATIVO.Text='SIM'));
    wpessoa.AddPair('ehfisica',BoolToStr(IWEDITPESSOAFISICA.Text='SIM'));
    wpessoa.AddPair('verificadebitos',BoolToStr(IWEDITVERIFICADEBITOS.Text='SIM'));
    wpessoa.AddPair('emiteetiqueta',BoolToStr(IWEDITEMITEETIQUETA.Text='SIM'));
    wpessoa.AddPair('ehprecadastro',BoolToStr(IWEDITPRECADASTRO.Text='SIM'));
    wpessoa.AddPair('aceitadevolucao',BoolToStr(IWEDITACEITADEVOLUCAO.Text='SIM'));
    wpessoa.AddPair('participantereidi',BoolToStr(IWEDITREIDI.Text='SIM'));
    wpessoa.AddPair('contato',ifthen(Length(trim(IWEDITCONTATOPESSOA.Text))>0,IWEDITCONTATOPESSOA.Text,'null'));
    wpessoa.AddPair('observacao',ifthen(Length(trim(IWEDITOBSERVACAOPESSOA.Text))>0,IWEDITOBSERVACAOPESSOA.Text,'null'));
    wpessoa.AddPair('nomefantasia',ifthen(Length(trim(IWEDITNOMEFANTASIAPESSOA.Text))>0,IWEDITNOMEFANTASIAPESSOA.Text,'null'));
    wpessoa.AddPair('idatividade',ifthen(Length(trim(IWEDITATIVIDADEPESSOA.Text))>0,inttostr(IWEDITATIVIDADEPESSOA.Tag),'null'));
    wpessoa.AddPair('meurelatorioconfiguravel',ifthen(Length(trim(IWEDITPASTAPESSOA.Text))>0,IWEDITPASTAPESSOA.Text,'null'));
    wpessoa.AddPair('agenciabanco',ifthen(Length(trim(IWEDITCODBANCOPESSOA.Text))>0,IWEDITCODBANCOPESSOA.Text,'null'));
    wpessoa.AddPair('cpf',ifthen(Length(trim(IWEDITCPFPESSOA.Text))>0,IWEDITCPFPESSOA.Text,'null'));
    wpessoa.AddPair('rg',ifthen(Length(trim(IWEDITRGPESSOA.Text))>0,IWEDITRGPESSOA.Text,'null'));
    wpessoa.AddPair('cnpj',ifthen(Length(trim(IWEDITCNPJPESSOA.Text))>0,IWEDITCNPJPESSOA.Text,'null'));
    wpessoa.AddPair('inscricaoestadual',ifthen(Length(trim(IWEDITIEPESSOA.Text))>0,IWEDITIEPESSOA.Text,'null'));
    wpessoa.AddPair('inscricaomunicipal',ifthen(Length(trim(IWEDITIMPESSOA.Text))>0,IWEDITIMPESSOA.Text,'null'));
    wpessoa.AddPair('suframa',ifthen(Length(trim(IWEDITSUFRAMAPESSOA.Text))>0,IWEDITSUFRAMAPESSOA.Text,'null'));
    wpessoa.AddPair('inscricaoestadualsubstituto',ifthen(Length(trim(IWEDITIESUBSTITUTOPESSOA.Text))>0,IWEDITIESUBSTITUTOPESSOA.Text,'null'));
    wpessoa.AddPair('identificadorinscricaoestadual',ifthen(Length(trim(IWEDITCONTRIBUICAO.Text))>0,IWEDITCONTRIBUICAO.Text,'null'));
    wpessoa.AddPair('site',ifthen(Length(trim(IWEDITSITEPESSOA.Text))>0,IWEDITSITEPESSOA.Text,'null'));
    wpessoa.AddPair('email',ifthen(Length(trim(IWEDITEMAILPESSOA.Text))>0,IWEDITEMAILPESSOA.Text,'null'));
    wpessoa.AddPair('endereco',ifthen(Length(trim(IWEDITLOGRADOUROPESSOA.Text))>0,IWEDITLOGRADOUROPESSOA.Text,'null'));
    wpessoa.AddPair('complemento',ifthen(Length(trim(IWEDITCOMPLEMENTOPESSOA.Text))>0,IWEDITCOMPLEMENTOPESSOA.Text,'null'));
    wpessoa.AddPair('bairro',ifthen(Length(trim(IWEDITBAIRROPESSOA.Text))>0,IWEDITBAIRROPESSOA.Text,'null'));
    wpessoa.AddPair('idlocalidade',ifthen(Length(trim(IWEDITCIDADEPESSOA.Text))>0,inttostr(IWEDITCIDADEPESSOA.Tag),'null'));
    wpessoa.AddPair('cep',ifthen(Length(trim(IWEDITCEPPESSOA.Text))>0,IWEDITCEPPESSOA.Text,'null'));
    wpessoa.AddPair('telefone',ifthen(Length(trim(IWEDITFONEPESSOA.Text))>0,IWEDITFONEPESSOA.Text,'null'));
    wpessoa.AddPair('fax',ifthen(Length(trim(IWEDITCELULARPESSOA.Text))>0,IWEDITCELULARPESSOA.Text,'null'));
    wpessoa.AddPair('caixapostal',ifthen(Length(trim(IWEDITCAIXAPOSTALPESSOA.Text))>0,IWEDITCAIXAPOSTALPESSOA.Text,'null'));

    wpessoa.AddPair('ehbanco',BoolToStr(IWEDITBANCO.Text='SIM'));
    wpessoa.AddPair('ehcliente',BoolToStr(IWEDITCLIENTE.Text='SIM'));
    wpessoa.AddPair('ehconvenio',BoolToStr(IWEDITCONVENIO.Text='SIM'));
    wpessoa.AddPair('ehfornecedor',BoolToStr(IWEDITFORNECEDOR.Text='SIM'));
    wpessoa.AddPair('ehfuncionario',BoolToStr(IWEDITFUNCIONARIO.Text='SIM'));
    wpessoa.AddPair('ehrepresentante',BoolToStr(IWEDITREPRESENTANTE.Text='SIM'));
    wpessoa.AddPair('ehtransportador',BoolToStr(IWEDITTRANSPORTADORA.Text='SIM'));
    wpessoa.AddPair('ehrepresentantemobile',BoolToStr(IWEDITMOBILE.Text='SIM'));
    wpessoa.AddPair('ehoftalmo',BoolToStr(IWEDITOFTALMO.Text='SIM'));
    wpessoa.AddPair('ehmedico',BoolToStr(IWEDITMEDICO.Text='SIM'));

// Cobrança
    wpessoa.AddPair('enderecocobranca',ifthen(Length(trim(IWEDITENDERECOCOBRANCA.Text))>0,IWEDITENDERECOCOBRANCA.Text,'null'));
    wpessoa.AddPair('complementocobranca',ifthen(Length(trim(IWEDITCOMPLEMENTOCOBRANCA.Text))>0,IWEDITCOMPLEMENTOCOBRANCA.Text,'null'));
    wpessoa.AddPair('bairrocobranca',ifthen(Length(trim(IWEDITBAIRROCOBRANCA.Text))>0,IWEDITBAIRROCOBRANCA.Text,'null'));
    wpessoa.AddPair('cepcobranca',ifthen(Length(trim(IWEDITCEPCOBRANCA.Text))>0,IWEDITCEPCOBRANCA.Text,'null'));
    wpessoa.AddPair('telefonecobranca',ifthen(Length(trim(IWEDITFONECOBRANCA.Text))>0,IWEDITFONECOBRANCA.Text,'null'));
    wpessoa.AddPair('emailcobranca',ifthen(Length(trim(IWEDITEMAILCOBRANCA.Text))>0,IWEDITEMAILCOBRANCA.Text,'null'));
    wpessoa.AddPair('idlocalidadecobranca',ifthen(Length(trim(IWEDITCIDADECOBRANCA.Text))>0,inttostr(IWEDITCIDADECOBRANCA.Tag),'null'));

// Diversos
    wpessoa.AddPair('habilitarcalculoretencao',BoolToStr(IWEDITRETENCOES.Text='SIM'));
    wpessoa.AddPair('naogeraremessa',BoolToStr(IWEDITREMESSAS.Text='SIM'));
    wpessoa.AddPair('ehclienterevenda',BoolToStr(IWEDITREVENDEDOR.Text='SIM'));
    wpessoa.AddPair('idbanco',ifthen(Length(trim(IWEDITBANCODIVERSOS.Text))>0,inttostr(IWEDITBANCODIVERSOS.Tag),'null'));
    wpessoa.AddPair('ctacorrente',ifthen(Length(trim(IWEDITCONTADIVERSOS.Text))>0,IWEDITCONTADIVERSOS.Text,'null'));
    wpessoa.AddPair('idcobranca',ifthen(Length(trim(IWEDITCOBRANCADIVERSOS.Text))>0,inttostr(IWEDITCOBRANCADIVERSOS.Tag),'null'));
    wpessoa.AddPair('idalvo',ifthen(Length(trim(IWEDITCOBRARDEDIVERSOS.Text))>0,inttostr(IWEDITCOBRARDEDIVERSOS.Tag),'null'));
    wpessoa.AddPair('perccomissao',ifthen(Length(trim(IWEDITCOMISSAODIVERSOS.Text))>0,IWEDITCOMISSAODIVERSOS.Text,'0'));
    wpessoa.AddPair('idtabelapreco',ifthen(Length(trim(IWEDITTABELADIVERSOS.Text))>0,inttostr(IWEDITTABELADIVERSOS.Tag),'null'));
    wpessoa.AddPair('idcondicao',ifthen(Length(trim(IWEDITCONDICAODIVERSOS.Text))>0,inttostr(IWEDITCONDICAODIVERSOS.Tag),'null'));
    wpessoa.AddPair('prazocondicao',ifthen(Length(trim(IWEDITPRAZODIVERSOS.Text))>0,IWEDITPRAZODIVERSOS.Text,'0'));
    wpessoa.AddPair('referenciacomercial1',ifthen(Length(trim(IWEDITREFERENCIA1DIVERSOS.Text))>0,IWEDITREFERENCIA1DIVERSOS.Text,'null'));
    wpessoa.AddPair('referenciacomercial2',ifthen(Length(trim(IWEDITREFERENCIA2DIVERSOS.Text))>0,IWEDITREFERENCIA2DIVERSOS.Text,'null'));
    wpessoa.AddPair('limitecredito',ifthen(Length(trim(IWEDITLIMITECOMPRADIVERSOS.Text))>0,IWEDITLIMITECOMPRADIVERSOS.Text,'0'));
    wpessoa.AddPair('valorfaturar',ifthen(Length(trim(IWEDITLIMITEFATURARDIVERSOS.Text))>0,IWEDITLIMITEFATURARDIVERSOS.Text,'0'));
    wpessoa.AddPair('idrepresentante',ifthen(Length(trim(IWEDITREPRESENTANTEDIVERSOS.Text))>0,inttostr(IWEDITREPRESENTANTEDIVERSOS.Tag),'null'));

// Fisica/Juridica
    wpessoa.AddPair('estadocivil',ifthen(Length(trim(IWEDITESTADOCIVIL.Text))>0,IWEDITESTADOCIVIL.Text,'null'));
    wpessoa.AddPair('sexo',ifthen(Length(trim(IWEDITGENERO.Text))>0,IWEDITGENERO.Text,'null'));
    wpessoa.AddPair('datanascimento',ifthen(Length(trim(IWEDITDATANASCIMENTO.Text))>0,IWEDITDATANASCIMENTO.Text,'null'));
    wpessoa.AddPair('salario',ifthen(Length(trim(IWEDITSALARIO.Text))>0,IWEDITSALARIO.Text,'0'));
    wpessoa.AddPair('idnaturalidade',ifthen(Length(trim(IWEDITNATURALIDADE.Text))>0,inttostr(IWEDITNATURALIDADE.Tag),'null'));
    wpessoa.AddPair('nomepai',ifthen(Length(trim(IWEDITNOMEPAI.Text))>0,IWEDITNOMEPAI.Text,'null'));
    wpessoa.AddPair('nomemae',ifthen(Length(trim(IWEDITNOMEMAE.Text))>0,IWEDITNOMEMAE.Text,'null'));
    wpessoa.AddPair('nomeempresa',ifthen(Length(trim(IWEDITNOMEEMPRESA.Text))>0,IWEDITNOMEEMPRESA.Text,'null'));
    wpessoa.AddPair('enderecotrabalho',ifthen(Length(trim(IWEDITENDERECOEMPRESA.Text))>0,IWEDITENDERECOEMPRESA.Text,'null'));
    wpessoa.AddPair('ceptrabalho',ifthen(Length(trim(IWEDITCEPEMPRESA.Text))>0,IWEDITCEPEMPRESA.Text,'null'));
    wpessoa.AddPair('bairrotrabalho',ifthen(Length(trim(IWEDITBAIRROEMPRESA.Text))>0,IWEDITBAIRROEMPRESA.Text,'null'));
    wpessoa.AddPair('telefonetrabalho',ifthen(Length(trim(IWEDITFONEEMPRESA.Text))>0,IWEDITFONEEMPRESA.Text,'null'));
    wpessoa.AddPair('nomediretor1empresa',ifthen(Length(trim(IWEDITNOMEDIRETOR1EMPRESA.Text))>0,IWEDITNOMEDIRETOR1EMPRESA.Text,'null'));
    wpessoa.AddPair('nomediretor2empresa',ifthen(Length(trim(IWEDITNOMEDIRETOR2EMPRESA.Text))>0,IWEDITNOMEDIRETOR2EMPRESA.Text,'null'));
    wpessoa.AddPair('datafundacaoempresa',ifthen(Length(trim(IWEDITDATAFUNDACAOEMPRESA.Text))>0,IWEDITDATAFUNDACAOEMPRESA.Text,'null'));

// Conjuge
    wpessoa.AddPair('nomeconjuge',ifthen(Length(trim(IWEDITNOMECONJUGE.Text))>0,IWEDITNOMECONJUGE.Text,'null'));
    wpessoa.AddPair('datanascimentoconjuge',ifthen(Length(trim(IWEDITDATANASCIMENTOCONJUGE.Text))>0,IWEDITDATANASCIMENTOCONJUGE.Text,'null'));
    wpessoa.AddPair('nomeempresaconjuge',ifthen(Length(trim(IWEDITEMPRESACONJUGE.Text))>0,IWEDITEMPRESACONJUGE.Text,'null'));
    wpessoa.AddPair('salarioconjuge',ifthen(Length(trim(IWEDITSALARIOCONJUGE.Text))>0,IWEDITSALARIOCONJUGE.Text,'0'));
    wpessoa.AddPair('idatividadeconjuge',ifthen(Length(trim(IWEDITCARGOCONJUGE.Text))>0,inttostr(IWEDITCARGOCONJUGE.Tag),'0'));

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
    URL         := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas';
    // POST
    wretorno    := wIdHTTP.Post(URL,wjsontosend);
    JObj        := TJSONObject.ParseJSONValue(wretorno) as TJSONObject;
    if strtointdef(JObj.GetValue('id').Value,0)>0 then
       begin
         if (FIdFiador=0) and (Length(trim(IWEDITNOMEFIADOR.Text))>0) then // inclui Fiador
            IncluiFiador(strtointdef(JObj.GetValue('id').Value,0));
         wret   := true;
         PopulaCamposPessoa(strtointdef(JObj.GetValue('id').Value,0));
       end
    else
       wret     := false;

//    WebApplication.ShowMessage('Código Fiscal incluído com sucesso!');
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao incluir pessoa'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

function TF_Pessoa.ExcluiPessoa(XId: integer): boolean;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(XId);
    wIdHTTP.Delete(URL);
    wret := true;
  except
    on E: Exception do
    begin
      wret := false;
      WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalAcessaAPI'').modal(''hide'');');
      WebApplication.ShowMessage('Problema ao excluir pessoa'+slinebreak+E.Message);
    end;
  end;
  Result := wret;
end;

procedure TF_Pessoa.CarregaResumoHistorico;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/historicos/resumo';
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;

    IWEDITDATAPRIMEIRACOMPRA.Text  := ifthen(wjson.GetValue('dataprimeiracompra').Value='null','',FormatDateTime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('dataprimeiracompra').Value)));
    IWEDITVALORPRIMEIRACOMPRA.Text := ifthen(wjson.GetValue('valorprimeiracompra').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('valorprimeiracompra').Value,0)));
    IWEDITDATAULTIMACOMPRA.Text    := ifthen(wjson.GetValue('dataultimacompra').Value='null','',FormatDateTime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('dataultimacompra').Value)));
    IWEDITVALORULTIMACOMPRA.Text   := ifthen(wjson.GetValue('valorultimacompra').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('valorultimacompra').Value,0)));
    IWEDITDATAMAIORCOMPRA.Text     := ifthen(wjson.GetValue('datamaiorcompra').Value='null','',FormatDateTime('dd/mm/yyyy',UserSession.RetornaData(wjson.GetValue('datamaiorcompra').Value)));
    IWEDITVALORMAIORCOMPRA.Text    := ifthen(wjson.GetValue('valormaiorcompra').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('valormaiorcompra').Value,0)));
    IWEDITVENCIDOSEMABERTO.Text    := ifthen(wjson.GetValue('vencido').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('vencido').Value,0)));
    IWEDITAVENCEREMABERTO.Text     := ifthen(wjson.GetValue('avencer').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('avencer').Value,0)));
    IWEDITATRASOMEDIO.Text         := ifthen(wjson.GetValue('mediaatraso').Value='0','',wjson.GetValue('mediaatraso').Value);
    IWEDITMAIORATRASO.Text         := ifthen(wjson.GetValue('maioratraso').Value='0','',wjson.GetValue('maioratraso').Value);
    IWEDITNUMEROCOMPRAS.Text       := ifthen(wjson.GetValue('qtde').Value='0','',wjson.GetValue('qtde').Value);
    IWEDITTOTALCOMPRAS.Text        := ifthen(wjson.GetValue('total').Value='0','',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('total').Value,0)));
  except

  end;
end;

procedure TF_Pessoa.CarregaResumoParcela;
var wIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    wIdHTTP: TIdHTTP;
    URL,wretjson,wnome: string;
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
    URL := warqini.ReadString('Geral','URL','')+'/cadastros/pessoas/'+inttostr(UserSession.FIdPessoa)+'/parcelas/resumo';
    wretjson := wIdHTTP.Get(URL);
    wjson    := TJSONObject.ParseJSONValue(wretjson) as TJSONObject;

    IWEDITQTDEMABERTO.Text    := ifthen(wjson.GetValue('xqtdeemaberto').Value='null','0',wjson.GetValue('xqtdeemaberto').Value);
    IWEDITVALOREMABERTO.Text  := ifthen(wjson.GetValue('xtotalemaberto').Value='null','0',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('xtotalemaberto').Value,0)));
    IWEDITQTDCANCELADO.Text   := ifthen(wjson.GetValue('xqtdecancelado').Value='null','0',wjson.GetValue('xqtdecancelado').Value);
    IWEDITVALORCANCELADO.Text := ifthen(wjson.GetValue('xtotalcancelado').Value='null','0',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('xtotalcancelado').Value,0)));
    IWEDITQTDQUITADO.Text     := ifthen(wjson.GetValue('xqtdequitado').Value='null','0',wjson.GetValue('xqtdequitado').Value);
    IWEDITVALORQUITADO.Text   := ifthen(wjson.GetValue('xtotalquitado').Value='null','0',FormatFloat('#,0.00',strtofloatdef(wjson.GetValue('xtotalquitado').Value,0)));
  except

  end;
end;

end.
