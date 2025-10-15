object DmLancamentos: TDmLancamentos
  Height = 227
  Width = 307
  object ConnLancamento: TFDConnection
    Params.Strings = (
      'Database=E:\git_hub\minhasFinancas\DataBase\MINHASFINANCAS.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 184
    Top = 16
  end
end
