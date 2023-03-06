unit ctl.movNFePendentes;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.movNFePendentes;


procedure ListaTodasNFePendentes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.movNFePendentes.RetornaListaNFePendentes(Req.Query);
    wret   := wlista.Items[0] as TJSONObject;
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


procedure RetornaNFePendente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wnfependente,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid          := Req.Params['id'].ToInteger; // recupera o id da localidade
    wnfependente := TJSONObject.Create;
    wnfependente := Req.Body<TJSONObject>;
    wnfependente := dat.movNFePendentes.RetornaNFePendente(wid);
    if wnfependente.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wnfependente).Status(400)
    else
       Res.Send<TJSONObject>(wnfependente).Status(200);
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

procedure ExcluiNFePendente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wnfependente,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid          := Req.Params['id'].ToInteger; // recupera o id da localidade
    wnfependente := TJSONObject.Create;
    wnfependente := Req.Body<TJSONObject>;
    wnfependente := dat.movNFePendentes.ApagaNFePendente(wid);
    if wnfependente.GetValue('status').Value='200' then
       Res.Send<TJSONObject>(wnfependente).Status(200)
    else
       Res.Send<TJSONObject>(wnfependente).Status(400);
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

procedure CriaNFePendente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wNFePendente,wnewNFePendente,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
begin
  try
    wNFePendente    := TJSONObject.Create;
    wnewNFePendente := TJSONObject.Create;
    wresp           := TJSONObject.Create;
    wNFePendente    := Req.Body<TJSONObject>;

    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa n�o definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.movNFePendentes.VerificaRequisicao(wNFePendente) then
       begin
         wnewNFePendente := dat.movNFePendentes.IncluiNFePendente(wNFePendente,widempresa);
         if wnewNFePendente.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewNFePendente).Status(400)
         else
            Res.Send<TJSONObject>(wnewNFePendente).Status(201);
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

procedure Registry;
begin
// M�todo Get
  THorse.Get('/trabinapi/movimentos/nfe_pendentes',ListaTodasNFePendentes);
  THorse.Get('/trabinapi/movimentos/nfe_pendentes/:id',RetornaNFePendente);

// M�todo Post
  THorse.Post('/trabinapi/movimentos/nfe_pendentes',CriaNFePendente);


// M�todo Delete
  THorse.Delete('/trabinapi/movimentos/nfe_pendentes/:id',ExcluiNFePendente);
end;

initialization

// defini��o da documenta��o
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/nfe_pendentes')
      .Tag('NFe pendentes')
      .GET('Listar nfe pendentes')
        .AddParamQuery('id', 'C�digo').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('uf', 'UF').&End
        .AddParamQuery('regiao', 'Regi�o').&End
        .AddParamQuery('codibge', 'C�digo IBGE').&End
//        .AddResponse(200, 'Lista de localidades').Schema(TLocalidades).IsArray(True).&End
      .&End
    .&End
    .Path('movimentos/nfe_pendentes/{id}')
      .Tag('NFe pendentes')
      .GET('Obter os dados de uma nfe espec�fica')
        .AddParamPath('id', 'C�digo').&End
//        .AddResponse(200, 'Dados da localidade').Schema(TLocalidades).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
