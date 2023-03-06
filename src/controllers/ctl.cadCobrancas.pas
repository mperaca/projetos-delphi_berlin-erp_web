unit ctl.cadCobrancas;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses models.cadCobrancas, dat.cadCobrancas;


procedure ListaTodasCobrancas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.cadCobrancas.RetornaListaCobrancas(Req.Query);
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


procedure RetornaCobranca(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wcobranca,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id da cobrança
    wcobranca := TJSONObject.Create;
    wcobranca := dat.cadCobrancas.RetornaCobranca(wid);
    if wcobranca.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wcobranca).Status(400)
    else
       Res.Send<TJSONObject>(wcobranca).Status(200);
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
  THorse.Get('/trabinapi/cadastros/cobrancas',ListaTodasCobrancas);
  THorse.Get('/trabinapi/cadastros/cobrancas/:id',RetornaCobranca);

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
    .Path('cadastros/cobrancas')
      .Tag('Documentos de Cobranças')
      .GET('Listar cobranças')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddResponse(200, 'Lista de cobrancas').Schema(TCobrancas).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/cobrancas/{id}')
      .Tag('Documento de Cobrança')
      .GET('Obter os dados de uma cobrança específica')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddResponse(200, 'Dados da cobrnaça').Schema(TCobrancas).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
