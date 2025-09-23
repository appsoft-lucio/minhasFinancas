object DM: TDM
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object Conn: TFDConnection
    Params.Strings = (
      'Database=E:\git_hub\minhasFinancas\backand\BANCO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 112
    Top = 32
  end
end
