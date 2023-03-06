object ProviderDataModuleConexao: TProviderDataModuleConexao
  OldCreateOrder = False
  Height = 271
  Width = 288
  object FDConnectionApi: TFDConnection
    Params.Strings = (
      'Server='
      'User_Name=postgres'
      'Password=postgres'
      'Port='
      'DriverID=PG')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 128
    Top = 24
  end
end
