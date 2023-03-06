unit prv.dataModuleConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Comp.UI, VCL.Dialogs, IniFiles, Horse;

type
  TProviderDataModuleConexao = class(TDataModule)
    FDConnectionApi: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
  private
    { Private declarations }
  public
    function EstabeleceConexaoDB: boolean;
    function EncerraConexaoDB: boolean;
    { Public declarations }
  end;

var
  ProviderDataModuleConexao: TProviderDataModuleConexao;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProviderDataModuleConexao }

function TProviderDataModuleConexao.EstabeleceConexaoDB: boolean;
var wret: boolean;
    warqini: TIniFile;
begin
  try
    warqini := TIniFile.Create(GetCurrentDir+'\conexao.ini');
    FDConnectionApi.Connected     := false;
    FDConnectionApi.Params.Clear;
    FDConnectionApi.Params.Add('DataBase='+warqini.ReadString('Conexão','DataBase',''));
    FDConnectionApi.Params.Add('User_Name=postgres');
    FDConnectionApi.Params.Add('Password=postgres');
    FDConnectionApi.Params.Add('Server='+warqini.ReadString('Conexão','HostName',''));
    FDConnectionApi.Params.Add('Port='+warqini.ReadString('Conexão','Porta',''));
    FDConnectionApi.Params.Add('DriverID=PG');
    FDConnectionApi.Params.Add('ApplicationName=TrabinAPI');
//    if warqini.ReadInteger('Conexão','Versão',8)>8 then
       FDConnectionApi.Params.Add('CharacterSet=LATIN1');
    FDPhysPgDriverLink1.VendorLib := GetCurrentDir+'\libpq74.dll';
    FDConnectionApi.LoginPrompt   := false;
    FDConnectionApi.Connected     := true;
    wret := FDConnectionApi.Connected;


  except
    On E: Exception do
    begin
      wret := false;
      THorse.Listen(9000,
        procedure (Horse: THorse)
        begin
           writeln('Problema ao estabeler Conexão: '+warqini.ReadString('Conexão','DataBase','')+' Erro: '+E.Message);
        end
       );

//      messagedlg('Problema ao estabelecer conexão com banco de dados'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  Result := wret;
end;

function TProviderDataModuleConexao.EncerraConexaoDB: boolean;
var wret: boolean;
begin
  try
    FDConnectionApi.Connected := false;
    wret                      := true;
  except
//    On E: Exception do
//    begin
      wret := false;
//      messagedlg('Problema ao estabelecer conexão com banco de dados'+slinebreak+E.Message,mterror,[mbok],0);
//    end;
  end;
  Result := wret;
end;

end.
