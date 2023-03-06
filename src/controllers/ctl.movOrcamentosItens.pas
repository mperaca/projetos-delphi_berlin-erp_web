unit ctl.movOrcamentosItens;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.movOrcamentosItens, models.movOrcamentosItens;


procedure RetornaOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    wid,widorcamento: integer;
    wval: string;
begin
  try
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id da nfe
    wid            := Req.Params['id'].ToInteger; // recupera o id do item
    worcamentoitem := TJSONObject.Create;
    worcamentoitem := dat.movOrcamentosItens.RetornaOrcamentoItem(widorcamento,wid);
    if worcamentoitem.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(worcamentoitem).Status(400)
    else
       Res.Send<TJSONObject>(worcamentoitem).Status(200);
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

procedure RetornaIdOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    widproduto,widorcamento,widitem: integer;
    wval: string;
begin
  try
    worcamentoitem := TJSONObject.Create;
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id do pedido
    widproduto     := Req.Params['idproduto'].ToInteger; // recupera o id do produto
    worcamentoitem := dat.movOrcamentosItens.RetornaIdOrcamentoItem(widorcamento,widproduto);
    Res.Send<TJSONObject>(worcamentoitem).Status(200);
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

procedure RetornaIdOrcamentoItemGrade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    widproduto,widorcamento,widitem,wtamanho,wcor: integer;
    wval: string;
begin
  try
    worcamentoitem := TJSONObject.Create;
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id do pedido
    widproduto     := Req.Params['idproduto'].ToInteger; // recupera o id do produto
    wtamanho       := Req.Params['tamanho'].ToInteger; // recupera o id do produto
    wcor           := Req.Params['cor'].ToInteger; // recupera o id do produto
    worcamentoitem := dat.movOrcamentosItens.RetornaIdOrcamentoItemGrade(widorcamento,widproduto,wtamanho,wcor);
    Res.Send<TJSONObject>(worcamentoitem).Status(200);
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


procedure RetornaOrcamentoItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem: TJSONArray;
    werro: TJSONObject;
    widorcamento: integer;
    wval: string;
begin
  try
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id da nfe
    worcamentoitem := TJSONArray.Create;
    worcamentoitem := dat.movOrcamentosItens.RetornaOrcamentoItens(widorcamento);
    werro    := worcamentoitem.Get(0) as TJSONObject;
    if werro.TryGetValue('status',wval) then
       begin
         Res.Send<TJSONArray>(worcamentoitem).Status(400);
       end
    else
       begin
         Res.Send<TJSONArray>(worcamentoitem).Status(200);
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


procedure ExcluiOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    widorcamento,wid: integer;
    wval: string;
begin
  try
    widorcamento     := Req.Params['orcamento'].ToInteger; // recupera o id do or�amento
    wid      := Req.Params['id'].ToInteger; // recupera o id do item
    worcamentoitem := TJSONObject.Create;
    worcamentoitem := Req.Body<TJSONObject>;
    worcamentoitem := dat.movOrcamentosItens.ApagaOrcamentoItem(widorcamento,wid);
    if worcamentoitem.GetValue('status').Value='200' then
       Res.Send<TJSONObject>(worcamentoitem).Status(200)
    else
       Res.Send<TJSONObject>(worcamentoitem).Status(400);
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

procedure CriaOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoItem,wneworcamentoItem,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widorcamento: integer;
begin
  try
    worcamentoItem     := TJSONObject.Create;
    wneworcamentoItem  := TJSONObject.Create;
    wresp              := TJSONObject.Create;
    worcamentoItem     := Req.Body<TJSONObject>;
    widorcamento       := Req.Params['orcamento'].ToInteger; // recupera o id do or�amento

    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa n�o definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.movOrcamentosItens.VerificaRequisicao(worcamentoitem) then
       begin
         wneworcamentoItem := dat.movOrcamentosItens.IncluiOrcamentoItem(worcamentoItem,widorcamento,widempresa);
         if wneworcamentoItem.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wneworcamentoItem).Status(400)
         else
            Res.Send<TJSONObject>(wneworcamentoItem).Status(201);
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

procedure AlteraOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoItem,wneworcamentoItem,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widorcamento,widitem: integer;
begin
  try
    worcamentoItem     := TJSONObject.Create;
    wneworcamentoItem  := TJSONObject.Create;
    wresp              := TJSONObject.Create;
    worcamentoItem     := Req.Body<TJSONObject>;
    widorcamento       := Req.Params['orcamento'].ToInteger; // recupera o id do or�amento
    widitem            := Req.Params['id'].ToInteger; // recupera o id do item

    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa n�o definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
         exit;
       end;

    wneworcamentoItem := dat.movOrcamentosItens.AlteraOrcamentoItem(widitem,worcamentoitem);
    if wneworcamentoItem.TryGetValue('idproduto',wval) then
       begin
         wneworcamentoItem.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wneworcamentoItem).Status(200)
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
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens',RetornaOrcamentoItens);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/:id',RetornaOrcamentoItem);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/produto/:idproduto',RetornaIdOrcamentoItem);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/produto/:idproduto/tamanho/:tamanho/cor/:cor',RetornaIdOrcamentoItemGrade);

// M�todo Post
  THorse.Post('/trabinapi/movimentos/orcamentos/:orcamento/itens',CriaOrcamentoItem);

// M�todo Put
  THorse.Put('/trabinapi/movimentos/orcamentos/:orcamento/itens/:id',AlteraOrcamentoItem);


// M�todo Delete
  THorse.Delete('/trabinapi/movimentos/orcamentos/:orcamento/itens/:id',ExcluiOrcamentoItem);
end;

initialization

// defini��o da documenta��o
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/orcamentos/{orcamento}/itens')
      .Tag('Or�amento �tens')
      .GET('Listar or�amentos �tens')
        .AddParamQuery('id', 'Id').&End
        .AddParamQuery('codproduto', 'C�digo Produto').&End
        .AddParamQuery('descproduto', 'Descri��o Produto').&End
        .AddResponse(200, 'Lista de �tens de or�amento').Schema(TOrcamentosItens).IsArray(True).&End
      .&End
      .POST('Criar um novo �tem de or�amento')
        .AddParamBody('Dados do �tem de or�amento').Required(True).Schema(TOrcamentosItensCria).&End
        .AddResponse(201).Schema(TOrcamentosItens).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('movimentos/orcamentos/{orcamento}/itens/{id}')
      .Tag('Or�amento �tens')
      .GET('Obter os dados de um �tem de or�amento espec�fico')
        .AddParamPath('id', 'Id').&End
        .AddResponse(200, 'Dados da or�amento').Schema(TOrcamentosItens).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de um or�amento �tem')
        .AddParamPath('id', 'C�digo').&End
        .AddParamBody('Dados do �tem').Required(True).Schema(TOrcamentosItensCria).&End
        .AddResponse(201).Schema(TOrcamentosItens).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir or�amento �tem')
        .AddParamPath('id', 'Id').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
