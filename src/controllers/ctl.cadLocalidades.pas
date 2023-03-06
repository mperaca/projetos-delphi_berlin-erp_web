unit ctl.cadLocalidades;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.cadLocalidades,
     models.cadLocalidades;

procedure ListaTodasLocalidades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.cadLocalidades.RetornaListaLocalidades(Req.Query);
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

procedure CriaLocalidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlocalidade,wnewlocalidade,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
begin
  try
    wlocalidade    := TJSONObject.Create;
    wnewlocalidade := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    wlocalidade    := Req.Body<TJSONObject>;

    widempresa     := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa n�o definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadLocalidades.VerificaRequisicao(wlocalidade) then
       begin
         wnewlocalidade := dat.cadLocalidades.IncluiLocalidade(wlocalidade,widempresa);
         if wnewlocalidade.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewlocalidade).Status(400)
         else
            Res.Send<TJSONObject>(wnewlocalidade).Status(201);
       end
    else
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','JSON preenchido incorretamente');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end;
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

procedure AlteraLocalidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlocalidade,wnewlocalidade,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewlocalidade := TJSONObject.Create;
    wlocalidade    := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    wid            := Req.Params['id'].ToInteger; // recupera o id da localidade
    wlocalidade    := Req.Body<TJSONObject>;
    wnewlocalidade := dat.cadLocalidades.AlteraLocalidade(wid,wlocalidade);
    if wnewlocalidade.TryGetValue('nome',wval) then
       begin
         wnewlocalidade.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewlocalidade).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Localidade n�o encontrada');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(400);
       end;
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

procedure ExcluiLocalidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da localidade
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadLocalidades.ApagaLocalidade(wid);
         if wret.GetValue('status').Value='200' then
            Res.Send<TJSONObject>(wret).Status(200)
         else
            Res.Send<TJSONObject>(wret).Status(400);
       end;
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


procedure RetornaLocalidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlocalidade,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid         := Req.Params['id'].ToInteger; // recupera o id da localidade
    wlocalidade := TJSONObject.Create;
    wlocalidade := Req.Body<TJSONObject>;
    wlocalidade := dat.cadLocalidades.RetornaLocalidade(wid);
    if wlocalidade.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wlocalidade).Status(400)
    else
       Res.Send<TJSONObject>(wlocalidade).Status(200);
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
  THorse.Get('/trabinapi/cadastros/localidades',ListaTodasLocalidades);
  THorse.Get('/trabinapi/cadastros/localidades/:id',RetornaLocalidade);

// M�todo Post
  THorse.Post('/trabinapi/cadastros/localidades',CriaLocalidade);

  // M�todo Put
  THorse.Put('/trabinapi/cadastros/localidades/:id',AlteraLocalidade);

  // M�todo Delete
  THorse.Delete('/trabinapi/cadastros/localidades/:id',ExcluiLocalidade);
end;

initialization

// defini��o da documenta��o
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/localidades')
      .Tag('Localidades')
      .GET('Listar localidades')
        .AddParamQuery('id', 'C�digo').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('uf', 'UF').&End
        .AddParamQuery('regiao', 'Regi�o').&End
        .AddParamQuery('codibge', 'C�digo IBGE').&End
        .AddResponse(200, 'Lista de localidades').Schema(TLocalidades).IsArray(True).&End
      .&End
      .POST('Criar uma nova localidade')
        .AddParamBody('Dados da localidade').Required(True).Schema(TLocalidades).&End
        .AddResponse(201).Schema(TLocalidades).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('cadastros/localidades/{id}')
      .Tag('Localidades')
      .GET('Obter os dados de uma localidade espec�fica')
        .AddParamPath('id', 'C�digo').&End
        .AddResponse(200, 'Dados da localidade').Schema(TLocalidades).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de uma localidade espec�fica')
        .AddParamPath('id', 'C�digo').&End
        .AddParamBody('Dados da localidade').Required(True).Schema(TLocalidades).&End
        .AddResponse(200).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir localidade')
        .AddParamPath('id', 'C�digo').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
