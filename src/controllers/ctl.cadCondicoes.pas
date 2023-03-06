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
// M�todo Get
  THorse.Get('/trabinapi/cadastros/condicoes',ListaTodasCondicoes);
  THorse.Get('/trabinapi/cadastros/condicoes/:id',RetornaCondicao);

// M�todo Post
//  THorse.Post('/trabinapi/cadastros/localidades',CriaLocalidade);

  // M�todo Put
//  THorse.Put('/trabinapi/cadastros/localidades/:id',AlteraLocalidade);

  // M�todo Delete
//  THorse.Delete('/trabinapi/cadastros/localidades/:id',ExcluiLocalidade);
end;

initialization

// defini��o da documenta��o
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/condicoes')
      .Tag('Condi��es de Pagamento')
      .GET('Listar condi��es')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descri��o').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'N�mero Pagamentos').&End
        .AddResponse(200, 'Lista de condi��es').Schema(TCondicoes).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/condicoes/{id}')
      .Tag('Condi��es de Pagamento')
      .GET('Obter os dados de uma condi��o espec�fica')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descri��o').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'N�mero Pagamentos').&End
        .AddResponse(200, 'Dados da condic��o').Schema(TCondicoes).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
