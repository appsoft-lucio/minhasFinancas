object DmCategoria: TDmCategoria
  OnCreate = DataModuleCreate
  Height = 168
  Width = 333
  object ConnCategoria: TFDConnection
    Params.Strings = (
      'Database=E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    LoginPrompt = False
    Left = 32
    Top = 16
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 160
    Top = 16
  end
end
