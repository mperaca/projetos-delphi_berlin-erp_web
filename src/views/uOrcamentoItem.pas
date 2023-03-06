unit uOrcamentoItem;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout, IW.Content.Base,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompEdit, IWCompButton, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IniFiles, System.JSON, IWHTMLTag, IdAuthentication;

type
  TF_OrcamentoItem = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
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
    IWBUTTONACAO: TIWButton;
    IWEDITID: TIWEdit;
    IWEDITNOME: TIWEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IWEDITIDPRODUTO: TIWEdit;
    IWEDITCODALIQICMS: TIWEdit;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWEDITCODIGOHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
  private
    procedure LimpaCampos;
    procedure CarregaCamposProduto(XIdProduto: integer);
    procedure CalculaTotais;
  public
  end;

implementation

{$R *.dfm}

uses ServerController, uContent.ListaProdutosHelp, uOrcamento;


procedure TF_OrcamentoItem.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
var wContentBase: TContentBase;
    widproduto: integer;
begin
  if pos('[LimpaOrcamentoItem]',IWEDITNOME.Text)>0 then
     LimpaCampos
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
  else if pos('[SelecionaProduto]',IWEDITNOME.Text)>0 then
     begin
       widproduto := strtointdef(IWEDITIDPRODUTO.Text,0);
       CarregaCamposProduto(widproduto);
     end
  else if pos('[CancelaOrcamentoItem]',IWEDITNOME.Text)>0 then
     begin
       LimpaCampos;
     end;
end;

procedure TF_OrcamentoItem.CarregaCamposProduto(XIdProduto: integer);
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
     IWEDITUNITARIO.Text   := formatfloat('#,0.00',UserSession.FMemTableProdutoHelp.FieldByName('preco1').AsFloat);
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
     IWEDITALIQICMS.Text     := formatfloat('#,0.00%',UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').AsFloat);
     IWEDITALIQICMS.Tag      := UserSession.FMemTableProdutoHelp.FieldByName('idaliquota').AsInteger;
     IWEDITCSTPIS.Text       := UserSession.FMemTableProdutoHelp.FieldByName('cstpissaida').AsString;
     IWEDITCSTCOFINS.Text    := UserSession.FMemTableProdutoHelp.FieldByName('cstcofinssaida').AsString;
     IWEDITPERCDESCONTO.Text := FormatFloat('#,0.00%',strtofloat(UserSession.FJSONOrcamento.GetValue('xdesccondicao').Value));
     IWEDITBASEICMS.Text     := formatfloat('#,0.00%',UserSession.FMemTableProdutoHelp.FieldByName('xbaseicm').AsFloat);
     IWEDITALIQPIS.Text      := formatfloat('#,0.00%',UserSession.FMemTableProdutoHelp.FieldByName('xpercpis').AsFloat);
     IWEDITALIQCOFINS.Text   := formatfloat('#,0.00%',UserSession.FMemTableProdutoHelp.FieldByName('xperccofins').AsFloat);
     IWEDITBASEPIS.Text      := formatfloat('#,0.00%',UserSession.FMemTableProdutoHelp.FieldByName('basepissaida').AsFloat);
     IWEDITBASECOFINS.Text   := formatfloat('#,0.00%',UserSession.FMemTableProdutoHelp.FieldByName('basecofinssaida').AsFloat);
     IWEDITQUANTIDADE.Text   := '1,000';

     // Calcula Totais
     CalculaTotais;
  except

  end;
end;

procedure TF_OrcamentoItem.CalculaTotais;
var wvaltotal,wvalunitario,wqtde,wvaldesconto,wpercdesconto,wpercbaseicm,wvalbaseicm,wpercicm,wvalicm,wpercbasepis,wpercbasecofins,wvalbasepis,wvalbasecofins,wvalpis,wvalcofins,wpercpis,wperccofins: double;
begin
  try
    wvalunitario  := strtofloatdef(IWEDITUNITARIO.Text,0);
    wqtde         := strtofloatdef(IWEDITQUANTIDADE.Text,0);
    wpercdesconto := StrToFloatDef(UserSession.FJSONOrcamento.GetValue('xdesccondicao').Value,0);
    wvaldesconto  := ((wvalunitario * wqtde) * wpercdesconto)/100;

    wpercbaseicm  := UserSession.FMemTableProdutoHelp.FieldByName('xbaseicm').AsFloat;
    wvalbaseicm   := (((wvalunitario * wqtde) - wvaldesconto) * wpercbaseicm)/100;
    wpercicm      := UserSession.FMemTableProdutoHelp.FieldByName('xpercaliquotaicm').AsFloat;
    wvalicm       := (wvalbaseicm * wpercicm)/100;

    wpercbasepis  := UserSession.FMemTableProdutoHelp.FieldByName('basepissaida').AsFloat;
    wvalbasepis   := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasepis)/100;
    wpercpis      := UserSession.FMemTableProdutoHelp.FieldByName('xpercpis').AsFloat;
    wvalpis       := (wvalbasepis * wpercpis)/100;

    wpercbasecofins := UserSession.FMemTableProdutoHelp.FieldByName('basecofinssaida').AsFloat;
    wvalbasecofins  := (((wvalunitario * wqtde) - wvaldesconto) * wpercbasecofins)/100;
    wperccofins     := UserSession.FMemTableProdutoHelp.FieldByName('xperccofins').AsFloat;
    wvalcofins      := (wvalbasecofins * wperccofins)/100;

    wvaltotal       := (wvalunitario * wqtde) - wvaldesconto;

    IWEDITVALORDESCONTO.Text := FormatFloat('#,0.00',wvaldesconto);
    IWEDITBASEICMS.Text      := FormatFloat('#,0.00',wvalbaseicm);
    IWEDITVALORICMS.Text     := FormatFloat('#,0.00',wvalicm);
    IWEDITVALORPIS.Text      := FormatFloat('#,0.00',wvalpis);
    IWEDITVALORCOFINS.Text   := FormatFloat('#,0.00',wvalcofins);
    IWEDITVALORTOTAL.Text    := FormatFloat('#,0.00',wvaltotal);

  except

  end;
end;

procedure TF_OrcamentoItem.IWEDITCODIGOHTMLTag(ASender: TObject;
  ATag: TIWHTMLTag);
begin
  ATag.Add(' type="text" style="font-size: 20px; font-weight: bold; color: #00bfff" autocomplete="off" placeholder="" ');
end;

procedure TF_OrcamentoItem.LimpaCampos;
begin
  try
    UserSession.FCodProdutoItem      := '';
    UserSession.FDescProdutoItem     := '';
    UserSession.FIdProdutoItem       := 0;

    IWEDITCODIGO.Text                := '';
    IWEDITCODIGO.Tag                 := 0;
    IWEDITDESCRICAO.Text             := '';
    IWEDITDESCRICAO.Tag              := 0;
    IWEDITCFOP.Text                  := '';
    IWEDITCFOP.Tag                   := 0;
    IWEDITCEAN.Text                  := '';
    IWEDITUNIDADE.Text               := '';
    IWEDITUNITARIO.Text              := '';
    IWEDITQUANTIDADE.Text            := '';
    IWEDITPERCDESCONTO.Text          := '';
    IWEDITVALORDESCONTO.Text         := '';
    IWEDITVALORTOTAL.Text            := '';
    IWEDITCSTICMS.Text               := '';
    IWEDITCSTICMS.Tag                := 0;
    IWEDITALIQICMS.Text              := '';
    IWEDITALIQICMS.Tag               := 0;
    IWEDITBASEICMS.Text              := '';
    IWEDITVALORICMS.Text             := '';
    IWEDITCSTPIS.Text                := '';
    IWEDITCSTPIS.Tag                 := 0;
    IWEDITBASEPIS.Text               := '';
    IWEDITVALORPIS.Text              := '';
    IWEDITCSTCOFINS.Text             := '';
    IWEDITCSTCOFINS.Tag              := 0;
    IWEDITBASECOFINS.Text            := '';
    IWEDITVALORCOFINS.Text           := '';
  finally

  end;
end;

end.
