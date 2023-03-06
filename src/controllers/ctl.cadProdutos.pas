unit ctl.cadProdutos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses models.cadProdutos, dat.cadProdutos;

procedure ListaTodosProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    wpagina: integer;
begin
  try
    if Req.Query.ContainsKey('pagina') then // número da pagina
       wpagina := Req.Query.Items['pagina'].ToInteger
    else
       wpagina := -1;
    wlista := TJSONArray.Create;
    wlista := dat.cadProdutos.RetornaListaProdutos(Req.Query,wpagina);
    wret   := wlista.Get(0) as TJSONObject;
    if wret.TryGetValue('status',wval) then
       Res.Send<TJSONArray>(wlista).Status(400)
    else
       Res.Send<TJSONArray>(wlista).Status(200);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;


procedure RetornaProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wproduto,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid      := Req.Params['id'].ToInteger; // recupera o id do produto
    wproduto := TJSONObject.Create;
    wproduto := dat.cadProdutos.RetornaProduto(wid);
    if wproduto.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wproduto).Status(400)
    else
       Res.Send<TJSONObject>(wproduto).Status(200);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;

procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/cadastros/produtos',ListaTodosProdutos);
  THorse.Get('/trabinapi/cadastros/produtos/:id',RetornaProduto);

// Método Post
//  THorse.Post('/trabinapi/cadastros/localidades',CriaLocalidade);

  // Método Put
//  THorse.Put('/trabinapi/cadastros/localidades/:id',AlteraLocalidade);

  // Método Delete
//  THorse.Delete('/trabinapi/cadastros/localidades/:id',ExcluiLocalidade);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/produtos')
      .Tag('Produtos')
      .GET('Listar produtos')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('unidade', 'Unidade').&End
        .AddParamQuery('cean', 'Código de Barras').&End
        .AddParamQuery('marca', 'Marca').&End
        .AddParamQuery('fabricante', 'Fabricante').&End
        .AddParamQuery('preco', 'Preço de Venda').&End
        .AddResponse(200, 'Lista de produtos').Schema(TProdutos).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/produtos/{id}')
      .Tag('Produtos')
      .GET('Obter os dados de um produto específico')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('unidade', 'Unidade').&End
        .AddParamQuery('cean', 'Código de Barras').&End
        .AddParamQuery('marca', 'Marca').&End
        .AddParamQuery('fabricante', 'Fabricante').&End
        .AddParamQuery('preco', 'Preço de Venda').&End
        .AddResponse(200, 'Dados do cliente').Schema(TProdutos).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
