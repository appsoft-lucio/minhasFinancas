object DmUsuario: TDmUsuario
  Height = 179
  Width = 373
  object ConnUsuario: TFDConnection
    Params.Strings = (
      'Database=E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Port=3050'
      'Server=127.0.0.1'
      'DriverID=FB')
    LoginPrompt = False
    Left = 72
    Top = 24
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 240
    Top = 24
  end
end
