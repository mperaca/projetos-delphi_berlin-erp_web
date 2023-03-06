unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase, SysUtils, Classes,System.JSON,
  FireDAC.Stan.Param,FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt;

type
  TIWUserSession = class(TIWUserSessionBase)
    procedure IWUserSessionBaseCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FBanco,FCobranca,FAtividade,FCargoConjuge,FLocalidade,FNomeLocalidade,FTipoHelpLocalidade,FLocalidadeCobranca,FNomeLocalidadeCobranca,FTipoHelpValidacao,FTipoHelpCliente: string;
    FCobrarDe,FTabela,FCondicao,FRepresentante,FNaturalidade,FNomeNaturalidade,FLocalidadeFiador,FNomeLocalidadeFiador,FTipoHelpAtividade,FAlvoNota: string;
    FIdNFePendente,FNumAtividades,FIdPessoa,FIdOrcamento,FIdProdutoItem,FIdOrcamentoItem,FIdNotaFiscal,FIdNotaItem: integer;
    FClienteOrcamento,FVendedorOrcamento,FCondicaoOrcamento,FCobrancaOrcamento,FCodProdutoItem,FDescProdutoItem,FTipoHelpProduto,FSerieNota,FEspecieNota: string;
    FClienteNota,FVendedorNota,FCondicaoNota,FCobrancaNota,FCodProdutoNotaItem,FDescProdutoNotaItem,FTipoHelpNotaProduto,FClassificacaoNota: string;
    FMemTableProdutoHelp,FMemTableOrcamentoItem,FMemTableNotaItem: TFDMemTable;
    FJSONOrcamento,FJSONNotaFiscal: TJSONObject;

    function RetornaData(XData: string): tdatetime;

    { Public declarations }
  end;

  var FIdNFePendente: integer;

implementation

{$R *.dfm}

procedure TIWUserSession.IWUserSessionBaseCreate(Sender: TObject);
begin
// Pessoa
  FAtividade      := '';
  FLocalidade     := '';
  FCobranca       := '';
  FNomeLocalidade := '';
  FNaturalidade   := '';
  FBanco          := '';
  FTabela         := '';
  FCobrarDe       := '';
  FCondicao       := '';
  FRepresentante  := '';
  FNomeNaturalidade := '';
  FLocalidadeFiador := '';
  FCargoConjuge     := '';
  FNomeLocalidadeFiador   := '';
  FLocalidadeCobranca     := '';
  FNomeLocalidadeCobranca := '';
  FTipoHelpAtividade      := '';
  FTipoHelpLocalidade     := '';
  FNumAtividades     := 0;
  FIdPessoa          := 0;
  FIdOrcamento       := 0;
  FIdNotaFiscal      := 0;
  FIdProdutoItem     := 0;
  FIdOrcamentoItem   := 0;
// Orçamento
  FClienteOrcamento    := '';
  FVendedorOrcamento   := '';
  FCondicaoOrcamento   := '';
  FCodProdutoItem      := '';
  FDescProdutoItem     := '';
  FClienteNota         := '';
  FVendedorNota        := '';
  FCondicaoNota        := '';
  FCobrancaNota        := '';
  FCodProdutoNotaItem  := '';
  FDescProdutoNotaItem := '';
  FTipoHelpNotaProduto := '';
  FTipoHelpValidacao   := '';
  FSerieNota           := '';
  FEspecieNota         := '';
  FAlvoNota            := '';
  FTipoHelpCliente     := '';
  FClassificacaoNota   := '';
end;

function TIWUserSession.RetornaData(XData: string): tdatetime;
var wret: tdatetime;
    wdia,wmes,wano: word;
begin
  try
    wano := strtoint(copy(XData,1,4));
    wmes := strtoint(copy(XData,6,2));
    wdia := strtoint(copy(XData,9,2));

    wret := EncodeDate(wano,wmes,wdia);

  except
    wret := 0;
  end;
  Result := wret;
end;


end.