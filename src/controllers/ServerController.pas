unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm;

type
  TIWServerController = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication);
    procedure IWServerControllerBaseConfig(Sender: TObject);

  private
    
  public
  end;


  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;

implementation

{$R *.dfm}

uses
  IWInit, IWGlobal, uAtividade, uMain, IW.Content.Handlers, IW.Content.Form,
  uLocalidade, uContent.ListaAtividades, uContent.ListaLocalidades,
  uNFePendente, uNFeAutorizada, uContent.ListaNFePendentes,
  uContent.ListaNFeAutorizadas, uCriaNota, uConfiguracao,
  uContent.ListaNFePendentesItens, uContent.ListaNFePendentesParcelas,
  uCodigoFiscal, uContent.ListaCodigosFiscais, uPlanoEstoque,
  uContent.ListaPlanoEstoques, uCategoria, uContent.ListaCategorias,
  uContent.ListaPessoas, uPessoa, uContent.ListaAtividadesHelp,
  uContent.ListaLocalidadesHelp, uContent.ListaBancosHelp,
  uContent.ListaCobrancasHelp, uContent.ListaClientesHelp,
  uContent.ListaTabelasHelp, uContent.ListaCondicoesHelp,
  uContent.ListaRepresentantesHelp, uContent.ListaPessoasHistoricos,
  uContent.ListaPessoasParcelas, uContent.ListaPessoasObservacoes,
  uContent.ListaOrcamentos, uOrcamento, uContent.ListaOrcamentosCFOPS,
  uContent.ListaOrcamentosItens, uContent.ListaOrcamentosParcelas,
  uOrcamentoItem, uContent.ListaProdutosHelp, uContent.ListaNotasFiscais,
  uNotaFiscal, uContent.ListaNotasFiscaisCFOPS, uContent.ListaNotasFiscaisItens,
  uContent.ListaNotasFiscaisParcelas, uContent.ListaValidacoesHelp,
  uContent.ListaClassificacoesHelp;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

procedure TIWServerController.IWServerControllerBaseConfig(Sender: TObject);
begin
  THandlers.Add('','index.html',TContentForm.Create(TF_Main));
  THandlers.Add('','atividade.html',TContentForm.Create(TF_Atividade));
  THandlers.Add('','categoria.html',TContentForm.Create(TF_Categoria));
  THandlers.Add('','codigofiscal.html',TContentForm.Create(TF_CodigoFiscal));
  THandlers.Add('','localidade.html',TContentForm.Create(TF_Localidade));
  THandlers.Add('','pessoa.html',TContentForm.Create(TF_Pessoa));
  THandlers.Add('','planoestoque.html',TContentForm.Create(TF_PlanoEstoque));
  THandlers.Add('','nfependente.html',TContentForm.Create(TF_NFePendente));
  THandlers.Add('','nfeautorizada.html',TContentForm.Create(TF_NFeAutorizada));
  THandlers.Add('','crianota.html',TContentForm.Create(TF_CriaNota));
  THandlers.Add('','configuracao.html',TContentForm.Create(TF_Configuracao));
  THandlers.Add('','notafiscal.html',TContentForm.Create(TF_NotaFiscal));
  THandlers.Add('','orcamento.html',TContentForm.Create(TF_Orcamento));
  THandlers.Add('','orcamentoitem.html',TContentForm.Create(TF_OrcamentoItem));
end;

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication);
begin
  ASession.Data := TIWUserSession.Create(nil);
end;


initialization
  TIWServerController.SetServerControllerClass;

  THandlers.Add('','GetAtividades',TContentListaAtividades.Create);
  THandlers.Add('','GetAtividadesHelp',TContentListaAtividadesHelp.Create);
  THandlers.Add('','GetCategorias',TContentListaCategorias.Create);
  THandlers.Add('','GetCodigosFiscais',TContentListaCodigosFiscais.Create);
  THandlers.Add('','GetLocalidades',TContentListaLocalidades.Create);
  THandlers.Add('','GetLocalidadesHelp',TContentListaLocalidadesHelp.Create);
  THandlers.Add('','GetPlanoEstoques',TContentListaPlanoEstoques.Create);
  THandlers.Add('','GetPessoas',TContentListaPessoas.Create);
  THandlers.Add('','GetPessoasHistoricos',TContentListaPessoasHistoricos.Create);
  THandlers.Add('','GetPessoasObservacoes',TContentListaPessoasObservacoes.Create);
  THandlers.Add('','GetPessoasParcelas',TContentListaPessoasParcelas.Create);
  THandlers.Add('','GetNFePendentes',TContentListaNFePendentes.Create);
  THandlers.Add('','GetNFeAutorizadas',TContentListaNFeAutorizadas.Create);
  THandlers.Add('','GetNFePendentesItens',TContentListaNFePendentesItens.Create);
  THandlers.Add('','GetNFePendentesParcelas',TContentListaNFePendentesParcelas.Create);
  THandlers.Add('','GetBancosHelp',TContentListaBancosHelp.Create);
  THandlers.Add('','GetCobrancasHelp',TContentListaCobrancasHelp.Create);
  THandlers.Add('','GetClientesHelp',TContentListaClientesHelp.Create);
  THandlers.Add('','GetTabelasHelp',TContentListaTabelasHelp.Create);
  THandlers.Add('','GetCondicoesHelp',TContentListaCondicoesHelp.Create);
  THandlers.Add('','GetClassificacoesHelp',TContentListaClassificacoesHelp.Create);
  THandlers.Add('','GetRepresentantesHelp',TContentListaRepresentantesHelp.Create);
  THandlers.Add('','GetNotasFiscais',TContentListaNotasFiscais.Create);
  THandlers.Add('','GetNotasFiscaisCFOPS',TContentListaNotasFiscaisCFOPS.Create);
  THandlers.Add('','GetNotasFiscaisItens',TContentListaNotasFiscaisItens.Create);
  THandlers.Add('','GetNotasFiscaisParcelas',TContentListaNotasFiscaisParcelas.Create);
  THandlers.Add('','GetOrcamentos',TContentListaOrcamentos.Create);
  THandlers.Add('','GetOrcamentosCFOPS',TContentListaOrcamentosCFOPS.Create);
  THandlers.Add('','GetOrcamentosItens',TContentListaOrcamentosItens.Create);
  THandlers.Add('','GetOrcamentosParcelas',TContentListaOrcamentosParcelas.Create);
  THandlers.Add('','GetProdutosHelp',TContentListaProdutosHelp.Create);
  THandlers.Add('','GetValidacoesHelp',TContentListaValidacoesHelp.Create);
end.

