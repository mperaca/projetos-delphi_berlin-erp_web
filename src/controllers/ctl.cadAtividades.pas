unit ctl.cadAtividades;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.cadAtividades, models.cadAtividades;

procedure ListaTodasAtividades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.cadAtividades.RetornaListaAtividades(Req.Query);
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

procedure CriaAtividade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAtividade,wnewAtividade,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
begin
  try
    wAtividade    := TJSONObject.Create;
    wnewAtividade := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    wAtividade    := Req.Body<TJSONObject>;

    widempresa     := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadAtividades.VerificaRequisicao(wAtividade) then
       begin
         wnewAtividade := dat.cadAtividades.IncluiAtividade(wAtividade,widempresa);
         if wnewAtividade.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewAtividade).Status(400)
         else
            Res.Send<TJSONObject>(wnewAtividade).Status(201);
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

procedure AlteraAtividade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAtividade,wnewAtividade,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewAtividade := TJSONObject.Create;
    wAtividade    := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    wid            := Req.Params['id'].ToInteger; // recupera o id da Atividade
    wAtividade    := Req.Body<TJSONObject>;
    wnewAtividade := dat.cadAtividades.AlteraAtividade(wid,wAtividade);
    if wnewAtividade.TryGetValue('nome',wval) then
       begin
         wnewAtividade.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewAtividade).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Atividade não encontrada');
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

procedure ExcluiAtividade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Atividade
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadAtividades.ApagaAtividade(wid);
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


procedure RetornaAtividade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAtividade,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid         := Req.Params['id'].ToInteger; // recupera o id da Atividade
    wAtividade := TJSONObject.Create;
    wAtividade := Req.Body<TJSONObject>;
    wAtividade := dat.cadAtividades.RetornaAtividade(wid);
    if wAtividade.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wAtividade).Status(400)
    else
       Res.Send<TJSONObject>(wAtividade).Status(200);
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
  THorse.Get('/trabinapi/cadastros/atividades',ListaTodasAtividades);
  THorse.Get('/trabinapi/cadastros/atividades/:id',RetornaAtividade);

// Método Post
  THorse.Post('/trabinapi/cadastros/atividades',CriaAtividade);

  // Método Put
  THorse.Put('/trabinapi/cadastros/atividades/:id',AlteraAtividade);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/atividades/:id',ExcluiAtividade);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/atividades')
      .Tag('Atividades')
      .GET('Listar Atividades')
        .AddParamQuery('id', 'Código').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddResponse(200, 'Lista de Atividades').Schema(TAtividades).IsArray(True).&End
      .&End
      .POST('Criar uma nova Atividade')
        .AddParamBody('Dados da Atividade').Required(True).Schema(TAtividades).&End
        .AddResponse(201).Schema(TAtividades).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('cadastros/atividades/{id}')
      .Tag('Atividades')
      .GET('Obter os dados de uma Atividade específica')
        .AddParamPath('id', 'Código').&End
        .AddResponse(200, 'Dados da Atividade').Schema(TAtividades).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de uma Atividade específica')
        .AddParamPath('id', 'Código').&End
        .AddParamBody('Dados da Atividade').Required(True).Schema(TAtividades).&End
        .AddResponse(200).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir Atividade')
        .AddParamPath('id', 'Código').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
