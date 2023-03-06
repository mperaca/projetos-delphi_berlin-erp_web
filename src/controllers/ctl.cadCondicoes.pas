unit ctl.cadCondicoes;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses dat.cadCondicoes, models.cadCondicoes;

procedure ListaTodasCondicoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.cadCondicoes.RetornaListaCondicoes(Req.Query);
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


procedure RetornaCondicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wcondicao,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do cliente
    wcondicao := TJSONObject.Create;
    wcondicao := dat.cadCondicoes.RetornaCondicao(wid);
    if wcondicao.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wcondicao).Status(400)
    else
       Res.Send<TJSONObject>(wcondicao).Status(200);
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
  THorse.Get('/trabinapi/cadastros/condicoes',ListaTodasCondicoes);
  THorse.Get('/trabinapi/cadastros/condicoes/:id',RetornaCondicao);

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
    .Path('cadastros/condicoes')
      .Tag('Condições de Pagamento')
      .GET('Listar condições')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'Número Pagamentos').&End
        .AddResponse(200, 'Lista de condições').Schema(TCondicoes).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/condicoes/{id}')
      .Tag('Condições de Pagamento')
      .GET('Obter os dados de uma condição específica')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'Número Pagamentos').&End
        .AddResponse(200, 'Dados da condicção').Schema(TCondicoes).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
