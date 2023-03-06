unit ctl.seqUltimoPedidoVenda;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation

uses models.seqUltimoPedidoVenda, dat.seqUltimoPedidoVenda;

procedure RetornaSequenceUltimoPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var widnfe: integer;
    wret: TJSONObject;
    wval: string;
begin
  try
    wret := dat.seqUltimoPedidoVenda.RetornaUltimoPedidoVenda;
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONObject>(wret).Status(500)
    else
       Res.Send<TJSONObject>(wret).Status(200);
  except
  end;
end;

procedure Registry;
begin
// M�todo Get
  THorse.Get('/trabinapi/sequencias/ultimopedidovenda',RetornaSequenceUltimoPedido);
end;

initialization

// defini��o da documenta��o
  Swagger
    .BasePath('trabinapi')
    .Path('sequencias/ultimopedidovenda')
      .Tag('Sequencias')
      .GET('Obter a �ltima sequence de venda')
        .AddParamQuery('ultped', '�ltimo Pedido').&End
        .AddResponse(200, 'Sequence Pedido Venda').Schema(TSequenceUltimoPedidoVenda).IsArray(True).&End
      .&End
    .&End
  .&End;

end.
