object DM: TDM
  OldCreateOrder = False
  Left = 517
  Top = 185
  Height = 254
  Width = 364
  object OS: TOraSession
    Username = 'askue'
    Password = 'askue'
    Server = 'orcl'
    Schema = 'ASKUE'
  end
  object OSQL: TOraSQL
    Session = OS
    Left = 40
  end
  object OQ: TOraQuery
    Session = OS
    Left = 80
  end
end
