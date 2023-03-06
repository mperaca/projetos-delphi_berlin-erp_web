unit uConfiguracao;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompEdit, IWHTMLTag, IWCompButton,
  IPPeerClient, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  IWCompText, IWCompMemo, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, Rest.JSON, Data.DBXJSON, IWCompLabel, System.StrUtils,
  IWCompCheckbox, IniFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TF_Configuracao = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWEditTrabinHostName: TIWEdit;
    IWEditTrabinDataBase: TIWEdit;
    IWEditTrabinPort: TIWEdit;
    IWBUTTONTESTACONEXAO: TIWButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    IWEditURLAPI: TIWEdit;
    IWEditRecursoAPI: TIWEdit;
    IWBUTTONTESTAAPI: TIWButton;
    IWMemoContentAPI: TIWMemo;
    IWBUTTONCONFIRMA: TIWButton;
    IWBUTTONCANCELA: TIWButton;
    IWBUTTONALTERA: TIWButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWLabelEmpresa: TIWLabel;
    IWLabelUpload: TIWLabel;
    IWCheckBox1: TIWCheckBox;
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IWEditTokenAPI: TIWEdit;
    IWEditStoreIdAPI: TIWEdit;
    IWEditUserAgentAPI: TIWEdit;
    IWLabelSelect: TIWLabel;
    IWLabelSelect2: TIWLabel;
    IWEDITTIPO: TIWEdit;
    IWLabelSelect3: TIWLabel;
    IWLabelSelect4: TIWLabel;
    IWLabelSelect5: TIWLabel;
    IWLabelSelect6: TIWLabel;
    IWLabelModelo: TIWLabel;
    IWLabelEspecie: TIWLabel;
    IWLabelSerie: TIWLabel;
    IWLabelSelect7: TIWLabel;
    IWLabelVendedor: TIWLabel;
    IWLabelSelectSaldo: TIWLabel;
    IWLabelSelectEnvioFoto: TIWLabel;
    IWLabelVisualizaCategorias: TIWLabel;
    IWLabelVisualizaDadosLoja: TIWLabel;
    IWLabelVisualizaProdutos: TIWLabel;
    IWLabelVisualizaClientes: TIWLabel;
    IWLabelVisualizaFormas: TIWLabel;
    IWLabelVisualizaVendas: TIWLabel;
    IWLabelVisualizaConfiguracoes: TIWLabel;
    IWLabelSelectEnvioAutomatico: TIWLabel;
    IWEditAgendamentoProduto: TIWEdit;
    IWEditAgendamentoVenda: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWEditTrabinHostNameHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditTrabinDataBaseHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditTrabinPortHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWBUTTONTESTACONEXAOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditURLAPIHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditRecursoAPIHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWMemoContentAPIHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWAppFormShow(Sender: TObject);
    procedure IWBUTTONCANCELAAsyncClick(Sender: TObject;
      EventParams: TStringList);
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEditTokenAPIHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditStoreIdAPIHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditUserAgentAPIHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditAgendamentoProdutoHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWEditAgendamentoVendaHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure IWBUTTONALTERAAsyncClick(Sender: TObject;
      EventParams: TStringList);
  private
    procedure ControlaEdicaoCampos(XTipo: string);
  public
  end;

implementation

{$R *.dfm}

uses ServerController;


procedure TF_Configuracao.IWAppFormCreate(Sender: TObject);
begin
  IWLabelEmpresa.Text       := '';
  IWEditTrabinDataBase.Text := '';
  IWEditTrabinHostName.Text := '';
  IWEditTrabinPort.Text     := '';
  IWEditTokenAPI.Text       := '';
  IWEditStoreIdAPI.Text     := '';
  IWEditUserAgentAPI.Text   := '';
  IWEditAgendamentoProduto.Text := '';
  IWEditAgendamentoVenda.Text   := '';


  IWLabelVisualizaDadosLoja.Text     := '';
  IWLabelVisualizaCategorias.Text    := '';
  IWLabelVisualizaProdutos.Text      := '';
  IWLabelVisualizaClientes.Text      := '';
  IWLabelVisualizaFormas.Text        := '';
  IWLabelVisualizaVendas.Text        := '';
  IWLabelVisualizaConfiguracoes.Text := '';

  IWEditURLAPI.Text         := '';
  IWEditRecursoAPI.Text     := '';
end;

procedure TF_Configuracao.IWAppFormShow(Sender: TObject);
begin
  ControlaEdicaoCampos('B');
  IWMemoContentAPI.Lines.Clear;
  IWEDITTIPO.Text := '';
end;

procedure TF_Configuracao.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var wselecao,wselecao2,wselecao3,wselecao4,wselecao5,wselecao6,wselecao7: string;
    wmodelo,wespecie,wserie,wvendedor,wsaldo,wfoto,wenvioautomatico: string;
    wpos: integer;
begin
  ControlaEdicaoCampos('B'); // bloqueia
end;


procedure TF_Configuracao.IWBUTTONALTERAAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  ControlaEdicaoCampos('L'); // libera
end;

procedure TF_Configuracao.IWBUTTONCANCELAAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  ControlaEdicaoCampos('B'); // bloqueia
end;

procedure TF_Configuracao.IWBUTTONTESTACONEXAOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' style="margin-top: 25px" ');
end;

procedure TF_Configuracao.IWEditAgendamentoProdutoHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Hora Agendamento" ');
end;

procedure TF_Configuracao.IWEditAgendamentoVendaHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Hora Venda" ');
end;

procedure TF_Configuracao.IWEditRecursoAPIHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Recurso da API" ');
end;

procedure TF_Configuracao.IWEditStoreIdAPIHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="StoreId da API" ');
end;

procedure TF_Configuracao.IWEditTokenAPIHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Token da API" ');
end;

procedure TF_Configuracao.IWEditTrabinDataBaseHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Database" ');
end;

procedure TF_Configuracao.IWEditTrabinHostNameHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Hostname" ');
end;

procedure TF_Configuracao.IWEditTrabinPortHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="Port" ');
end;

procedure TF_Configuracao.IWEditURLAPIHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="URL base da API" ');
end;

procedure TF_Configuracao.IWEditUserAgentAPIHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 15px; font-weight: bold; color: #00bfff" required="true" autocomplete="off" placeholder="UserAgent da API" ');
end;

procedure TF_Configuracao.IWMemoContentAPIHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' style="height: 350px" ');
end;

procedure TF_Configuracao.ControlaEdicaoCampos(XTipo: string);
begin
  try
    AddToInitProc('$(''#IWEditRecursoAPI'').disabled=false;');
{    if XTipo='L' then // libera a edição de campos
       begin
         IWEditRecursoAPI.Enabled         := true;
         IWEditTrabinDataBase.Enabled     := true;
         IWEditTrabinHostName.Enabled     := true;
         IWEditTrabinPort.Enabled         := true;
         IWEditURLAPI.Enabled             := true;
         IWEditTokenAPI.Enabled           := true;
         IWEditStoreIdAPI.Enabled         := true;
         IWEditUserAgentAPI.Enabled       := true;
         IWEditAgendamentoProduto.Enabled := true;
         IWEditAgendamentoVenda.Enabled   := true;
         IWEditTrabinHostName.SetFocus;
       end
    else
       begin
         IWEditRecursoAPI.Enabled         := false;
         IWEditTrabinDataBase.Enabled     := false;
         IWEditTrabinHostName.Enabled     := false;
         IWEditTrabinPort.Enabled         := false;
         IWEditURLAPI.Enabled             := false;
         IWEditTokenAPI.Enabled           := false;
         IWEditStoreIdAPI.Enabled         := false;
         IWEditUserAgentAPI.Enabled       := false;
         IWEditAgendamentoProduto.Enabled := false;
         IWEditAgendamentoVenda.Enabled   := false;
       end;}
  except
    On E: Exception do
    begin
      WebApplication.ShowMessage('Erro ao liberar edição de campos da tabela Categoria'+slinebreak+E.Message);
    end;
  end;
end;

end.
