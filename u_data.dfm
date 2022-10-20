object DM: TDM
  OldCreateOrder = False
  Left = 658
  Top = 86
  Height = 778
  Width = 581
  object OS: TOraSession
    Username = 'askue'
    Password = 'askue'
    Server = 'orcl'
    Connected = True
    Schema = 'ASKUE'
    Left = 16
    Top = 16
  end
  object OTAskueSrc: TOraTable
    TableName = 'ASKUE.ASKUE_SRC'
    ReadOnly = True
    KeyFields = 'ID'
    Session = OS
    Active = True
    AfterScroll = OTAskueSrcAfterScroll
    Left = 88
    Top = 16
  end
  object ODSAskueSrc: TOraDataSource
    DataSet = OTAskueSrc
    Left = 160
    Top = 16
  end
  object ODSSchVal: TOraDataSource
    DataSet = OQSchVal
    Left = 160
    Top = 112
  end
  object ODSRoll: TOraDataSource
    DataSet = OQRoll
    Left = 160
    Top = 64
  end
  object OQRoll: TOraQuery
    Session = OS
    SQL.Strings = (
      'SELECT *'
      'FROM askue.roll'
      'WHERE askue_src = :id'
      '  AND roll_date = :roll_date')
    MasterSource = ODSAskueSrc
    MasterFields = 'id'
    LockMode = lmLockImmediate
    Active = True
    Left = 88
    Top = 64
    ParamData = <
      item
        DataType = ftFloat
        Name = 'ID'
        ParamType = ptInput
        Value = 1.000000000000000000
      end
      item
        DataType = ftUnknown
        Name = 'roll_date'
        Value = Null
      end>
  end
  object OQSchVal: TOraQuery
    Session = OS
    SQL.Strings = (
      'SELECT sv.id,'
      '       ts.NAME,'
      '       sv.ser_num,'
      '       sv.val_date,'
      '       sv.SCH_VAL1,'
      '       sv.SCH_VAL2,'
      '       sv.SCH_VAL3,'
      '       sv.SCH_STAT_EXT,'
      
        '       askue.askue_proc.get_sch_num(ste.sch_type, sv.ser_num, sv' +
        '.val_date) sch_num,'
      
        '       askue.askue_proc.get_sch_ls(ste.sch_type, sv.ser_num, sv.' +
        'val_date) sch_ls,'
      
        '       askue.askue_proc.get_sch_addr(ste.sch_type, sv.ser_num, s' +
        'v.val_date) sch_addr,'
      '       sv.add_val_step,'
      '       sv.add_val_log,'
      
        '       (SELECT ts.zonn_sch FROM esbp.type_sch ts WHERE ts.type_s' +
        'ch = ste.SCH_TYPE) sch_zon,'
      '       ste.SCH_TYPE,'
      '       sv.val_num,'
      '       sv.askue_src,'
      '       sv.inter_type,'
      
        '       askue.askue_proc.get_sch_date(ste.sch_type, sv.ser_num, s' +
        'v.val_date) sch_date,'
      
        '       askue.askue_proc.get_sch_npok(ste.sch_type, sv.ser_num, s' +
        'v.val_date) sch_npok,'
      
        '       askue.askue_proc.get_sch_npokn(ste.sch_type, sv.ser_num, ' +
        'sv.val_date) sch_npokn'
      '     '
      'FROM askue.sch_val sv,'
      '     askue.sch_type_ext ste,'
      '     esbp.type_sch ts'
      
        'WHERE sv.askue_src = ste.askue_src AND sv.inter_type = ste.inter' +
        '_type'
      '  AND sv.roll = :id'
      '  AND ste.SCH_TYPE = ts.TYPE_SCH'
      'ORDER BY sv.ser_num, sv.val_date'
      '')
    MasterSource = ODSRoll
    MasterFields = 'id'
    FetchAll = True
    Active = True
    Filtered = True
    Filter = '(val_num = 0)'
    Left = 88
    Top = 112
    ParamData = <
      item
        DataType = ftFloat
        Name = 'ID'
        ParamType = ptInput
      end>
    object OQSchValNAME: TStringField
      DisplayWidth = 15
      FieldName = 'NAME'
      Required = True
      Size = 60
    end
    object OQSchValSER_NUM: TStringField
      DisplayWidth = 10
      FieldName = 'SER_NUM'
      Size = 50
    end
    object OQSchValVAL_DATE: TDateTimeField
      DisplayWidth = 10
      FieldName = 'VAL_DATE'
    end
    object OQSchValSCH_VAL1: TFloatField
      FieldName = 'SCH_VAL1'
    end
    object OQSchValSCH_VAL2: TFloatField
      FieldName = 'SCH_VAL2'
    end
    object OQSchValSCH_VAL3: TFloatField
      FieldName = 'SCH_VAL3'
    end
    object OQSchValSCH_STAT_EXT: TFloatField
      DisplayWidth = 5
      FieldName = 'SCH_STAT_EXT'
    end
    object OQSchValLS_SCH: TFloatField
      FieldName = 'SCH_LS'
    end
    object OQSchValADDR_SCH: TStringField
      FieldName = 'SCH_ADDR'
      Size = 4000
    end
    object OQSchValID: TFloatField
      FieldName = 'ID'
      Required = True
    end
    object OQSchValSCH_NUM: TFloatField
      FieldName = 'SCH_NUM'
    end
    object OQSchValADD_VAL_STEP: TFloatField
      FieldName = 'ADD_VAL_STEP'
    end
    object OQSchValSCH_ZON: TFloatField
      FieldName = 'SCH_ZON'
    end
    object OQSchValADD_VAL_LOG: TStringField
      FieldName = 'ADD_VAL_LOG'
      Size = 255
    end
    object OQSchValSCH_TYPE: TFloatField
      FieldName = 'SCH_TYPE'
    end
    object OQSchValVAL_NUM: TFloatField
      FieldName = 'VAL_NUM'
    end
    object OQSchValASKUE_SRC: TFloatField
      FieldName = 'ASKUE_SRC'
    end
    object OQSchValINTER_TYPE: TFloatField
      FieldName = 'INTER_TYPE'
    end
    object OQSchValSCH_DATE: TDateTimeField
      FieldName = 'SCH_DATE'
    end
    object OQSchValSCH_NPOK: TFloatField
      FieldName = 'SCH_NPOK'
    end
    object OQSchValSCH_NPOKN: TFloatField
      FieldName = 'SCH_NPOKN'
    end
  end
  object OSQLRoll: TOraSQL
    Session = OS
    Left = 248
    Top = 80
  end
  object OSPRoll: TOraStoredProc
    Session = OS
    Left = 320
    Top = 80
  end
  object OSPGetPoslPok: TOraStoredProc
    StoredProcName = 'esbp.ESBP_PROC.GET_POSL_POK_SCH'
    Session = OS
    SQL.Strings = (
      'begin'
      
        '  esbp.ESBP_PROC.GET_POSL_POK_SCH(:PLS, :PNSCHETCH, :PDAT_UST, :' +
        'PNPOK, :PNPOKN, :PDAT_PPOK, :PKPOK, :PCKPOK, :PKPOK_N, :PCKPOK_N' +
        ', :PKZ);'
      'end;')
    Left = 88
    Top = 320
    ParamData = <
      item
        DataType = ftFloat
        Name = 'PLS'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PNSCHETCH'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'PDAT_UST'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PNPOK'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PNPOKN'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'PDAT_PPOK'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PKPOK'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PCKPOK'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PKPOK_N'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PCKPOK_N'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PKZ'
        ParamType = ptOutput
      end>
  end
  object OSPProvPokaz: TOraStoredProc
    StoredProcName = 'esbp.ESBP_PROC.PROV_POKAZ'
    Session = OS
    SQL.Strings = (
      'begin'
      
        '  esbp.ESBP_PROC.PROV_POKAZ(:PLS, :PNSCHETCH, :PZONN, :PZNACHN, ' +
        ':PNDAT_POK, :PNPOK, :PCNPOK, :PNPOKN, :PCNPOKN, :PKDAT_POK, :PKP' +
        'OK, :PKPOKN, :PCKPOK, :PCKPOKN, :PSUT_POSL_INT, :PSUT_NOV_INT, :' +
        'POTKLON, :PSUT_POSL_INTN, :PSUT_NOV_INTN, :POTKLONN, :PKZ);'
      'end;')
    Left = 88
    Top = 368
    ParamData = <
      item
        DataType = ftFloat
        Name = 'PLS'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PNSCHETCH'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PZONN'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PZNACHN'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'PNDAT_POK'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PNPOK'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PCNPOK'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PNPOKN'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PCNPOKN'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'PKDAT_POK'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PKPOK'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PKPOKN'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'PCKPOK'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PCKPOKN'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PSUT_POSL_INT'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PSUT_NOV_INT'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'POTKLON'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PSUT_POSL_INTN'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PSUT_NOV_INTN'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'POTKLONN'
        ParamType = ptOutput
      end
      item
        DataType = ftFloat
        Name = 'PKZ'
        ParamType = ptOutput
      end>
  end
  object OSQLIns: TOraSQL
    Session = OS
    Left = 160
    Top = 320
  end
  object OSQLUpd: TOraSQL
    Session = OS
    Left = 88
    Top = 160
  end
  object OQNotLocate: TOraQuery
    Session = OS
    SQL.Strings = (
      'SELECT DISTINCT ts.NAME,'
      '       sv.ser_num,'
      '       sv.SCH_STAT_EXT'
      'FROM askue.sch_val sv,'
      '     askue.sch_type_ext ste,'
      '     esbp.type_sch ts'
      
        'WHERE sv.askue_src = ste.askue_src AND sv.inter_type = ste.inter' +
        '_type'
      '  AND sv.roll = :id'
      '  AND ste.SCH_TYPE = ts.TYPE_SCH'
      
        '  AND askue.askue_proc.get_sch_num(ste.sch_type, sv.ser_num, sv.' +
        'val_date) = -1'
      ''
      '')
    Active = True
    Left = 88
    Top = 208
    ParamData = <
      item
        DataType = ftInteger
        Name = 'id'
        ParamType = ptInput
        Value = 1
      end>
  end
  object OQSchTu: TOraQuery
    Session = OS
    SQL.Strings = (
      'SELECT s.NSCHETCH,'
      '       s.ls,'
      '       st.TYPE_STREET,'
      '       st.NAME_STREET,'
      '       l.DOM,'
      '       l.KORP,'
      '       l.FLAT,'
      '       s.ZAV_NOM,'
      '       s.DND,'
      '       s.DKD,'
      '       ts.NAME,'
      '       ts.ZNACHN,'
      '       s.type_sch'
      'FROM esbp.schetch s,'
      '     esbp.ls l,'
      '     esbp.street st,'
      '     esbp.type_sch ts'
      'WHERE l.ls = s.ls'
      '  AND l.STREET = st.STREET'
      '  AND s.TYPE_SCH = ts.TYPE_SCH '
      '  AND l.taun = st.taun')
    Active = True
    Left = 88
    Top = 416
    object OQSchTuNSCHETCH: TFloatField
      FieldName = 'NSCHETCH'
      Required = True
    end
    object OQSchTuLS: TIntegerField
      FieldName = 'LS'
      Required = True
    end
    object OQSchTuTYPE_STREET: TStringField
      FieldName = 'TYPE_STREET'
      Required = True
      Size = 6
    end
    object OQSchTuNAME_STREET: TStringField
      FieldName = 'NAME_STREET'
      Size = 30
    end
    object OQSchTuDOM: TIntegerField
      FieldName = 'DOM'
      Required = True
    end
    object OQSchTuKORP: TStringField
      FieldName = 'KORP'
      Required = True
      Size = 4
    end
    object OQSchTuFLAT: TStringField
      FieldName = 'FLAT'
      Required = True
      Size = 10
    end
    object OQSchTuZAV_NOM: TStringField
      FieldName = 'ZAV_NOM'
      Required = True
    end
    object OQSchTuDND: TDateTimeField
      DisplayWidth = 10
      FieldName = 'DND'
      Required = True
    end
    object OQSchTuDKD: TDateTimeField
      DisplayWidth = 10
      FieldName = 'DKD'
      Required = True
    end
    object OQSchTuNAME: TStringField
      FieldName = 'NAME'
      Required = True
      Size = 60
    end
    object OQSchTuZNACHN: TIntegerField
      FieldName = 'ZNACHN'
      Required = True
    end
    object OQSchTuTYPE_SCH: TIntegerField
      FieldName = 'TYPE_SCH'
      Required = True
    end
  end
  object ODSSchTu: TOraDataSource
    DataSet = OQSchTu
    Left = 160
    Top = 416
  end
  object OSQL: TOraSQL
    Session = OS
    Left = 88
    Top = 536
  end
  object OQ: TOraQuery
    Session = OS
    Left = 88
    Top = 584
  end
  object OQNoCheckPrint: TOraQuery
    Session = OS
    SQL.Strings = (
      
        'SELECT u.NAME, st.NAME_STREET, l.DOM || '#39'/'#39' || l.KORP dk, l.FLAT' +
        ','
      '       l.LS, s.ZAV_NOM, tps.NAME, s.KOMMENT, st.type_street'
      'FROM askue.sch_type_ext ste,'
      '     esbp.schetch s,'
      '             esbp.ls l,'
      '             esbp.street st,'
      '             esbp.type_sch tps,'
      '             esbp.bilds b,'
      '             esbp.uchastok u,'
      #9#9#9' esbp.ab a'
      ''
      'WHERE ste.SCH_TYPE = s.TYPE_SCH'
      '  AND l.TAUN = st.TAUN AND l.STREET = st.STREET'
      '  AND s.TYPE_SCH = tps.TYPE_SCH'
      '  AND s.DND <= :dnd'
      '  AND s.DKD >= :dkd'
      '  '
      '  and a.ls=l.ls and a.dkd>=sysdate'
      '  '
      '  and l.dkd>=sysdate'
      '  '
      '  AND l.LS = s.LS'
      '  AND b.otd = u.OTD AND b.UCHASTOK = u.UCHASTOK'
      
        '  AND b.OTD = :otd AND b.TAUN = l.TAUN AND b.STREET = l.STREET A' +
        'ND b.DOM = l.DOM AND b.KORP = l.KORP'
      '  AND b.UCHASTOK = :uchastok'
      '  AND ste.ASKUE_SRC = :askue_src'
      '  AND NOT EXISTS('
      '                                               SELECT p.nschetch'
      '                                               FROM esbp.pokaz p'
      
        '                                               WHERE s.NSCHETCH ' +
        '= p.NSCHETCH'
      
        '                                               AND p.DKD >= :dnd' +
        '  '
      '      )'
      ''
      #9'  '
      'AND NOT EXISTS(            SELECT bl.ls'
      '                           FROM esbp.blok_norm_ab bl'
      '                           WHERE bl.ab = a.ab'
      '                           AND bl.DKD >= sysdate)'
      #9#9#9#9#9#9'   '
      'ORDER BY u.NAME, st.NAME_STREET, l.DOM, l.KORP, l.FLAT')
    Active = True
    Left = 88
    Top = 648
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'dnd'
        Value = 39569d
      end
      item
        DataType = ftUnknown
        Name = 'dkd'
        Value = Null
      end
      item
        DataType = ftInteger
        Name = 'otd'
        Value = 1
      end
      item
        DataType = ftInteger
        Name = 'uchastok'
        Value = 3
      end
      item
        DataType = ftInteger
        Name = 'askue_src'
        Value = 1
      end>
    object OQNoCheckPrintNAME: TStringField
      FieldName = 'NAME'
      Required = True
      Size = 30
    end
    object OQNoCheckPrintNAME_STREET: TStringField
      FieldName = 'NAME_STREET'
      Size = 30
    end
    object OQNoCheckPrintDK: TStringField
      FieldName = 'DK'
      Size = 45
    end
    object OQNoCheckPrintFLAT: TStringField
      FieldName = 'FLAT'
      Required = True
      Size = 10
    end
    object OQNoCheckPrintLS: TIntegerField
      FieldName = 'LS'
      Required = True
    end
    object OQNoCheckPrintZAV_NOM: TStringField
      FieldName = 'ZAV_NOM'
      Required = True
    end
    object OQNoCheckPrintNAME_1: TStringField
      FieldName = 'NAME_1'
      Required = True
      Size = 60
    end
    object OQNoCheckPrintKOMMENT: TStringField
      FieldName = 'KOMMENT'
      Size = 60
    end
    object OQNoCheckPrintTYPE_STREET: TStringField
      FieldName = 'TYPE_STREET'
      Required = True
      Size = 6
    end
  end
  object OTUchastok: TOraTable
    TableName = 'esbp.uchastok'
    OrderFields = 'NAME'
    KeyFields = 'OTD;UCHASTOK'
    Session = OS
    Active = True
    Left = 312
    Top = 208
  end
  object ODSUchastok: TOraDataSource
    DataSet = OTUchastok
    Left = 400
    Top = 208
  end
  object ODSTypeSchList: TOraDataSource
    DataSet = OQTypeSchList
    Left = 328
    Top = 16
  end
  object OQTypeSchList: TOraQuery
    Session = OS
    SQL.Strings = (
      'SELECT ste.INTER_TYPE, ts.NAME, ts.Type_sch'
      'FROM askue.sch_type_ext ste, esbp.type_sch ts'
      'WHERE ste.SCH_TYPE = ts.TYPE_SCH'
      '  AND ste.askue_src = :id'
      'ORDER BY ts.NAME')
    MasterSource = ODSAskueSrc
    MasterFields = 'id'
    LockMode = lmLockImmediate
    Active = True
    Left = 248
    Top = 16
    ParamData = <
      item
        DataType = ftFloat
        Name = 'ID'
        ParamType = ptInput
        Value = 1.000000000000000000
      end>
  end
  object OQStatRayPrint: TOraQuery
    Session = OS
    SQL.Strings = (
      
        'SELECT u.NAME, st.NAME_STREET, l.DOM || '#39'/'#39' || l.KORP dk, l.FLAT' +
        ','
      '       l.LS, s.ZAV_NOM, tps.NAME, s.KOMMENT'
      'FROM askue.sch_type_ext ste,'
      '     esbp.schetch s,'
      #9' esbp.ls l,'
      #9' esbp.street st,'
      #9' esbp.type_sch tps,'
      #9' esbp.bilds b,'
      #9' esbp.uchastok u'
      'WHERE ste.SCH_TYPE = s.TYPE_SCH'
      '  AND l.TAUN = st.TAUN AND l.STREET = st.STREET'
      '  AND s.TYPE_SCH = tps.TYPE_SCH'
      '  AND s.DND <= :dnd'
      '  AND s.DKD >= :dkd'
      '  AND l.LS = s.LS'
      '  AND b.otd = u.OTD AND b.UCHASTOK = u.UCHASTOK'
      
        '  AND b.OTD = :otd AND b.TAUN = l.TAUN AND b.STREET = l.STREET A' +
        'ND b.DOM = l.DOM AND b.KORP = l.KORP'
      '  AND b.UCHASTOK = :uchastok'
      '  AND ste.ASKUE_SRC = :askue_src'
      '  AND NOT EXISTS('
      '  '#9'  '#9'  '#9#9' SELECT p.nschetch'
      #9#9#9#9' FROM esbp.pokaz p'
      #9#9#9#9' WHERE s.NSCHETCH = p.NSCHETCH'
      #9#9#9#9'   AND p.DKD >= :dnd  '
      '               )'
      'ORDER BY u.NAME, st.NAME_STREET, l.DOM, l.KORP, l.FLAT')
    Active = True
    Left = 88
    Top = 696
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'dnd'
        Value = 39569d
      end
      item
        DataType = ftUnknown
        Name = 'dkd'
        Value = Null
      end
      item
        DataType = ftInteger
        Name = 'otd'
        Value = 1
      end
      item
        DataType = ftInteger
        Name = 'uchastok'
        Value = 3
      end
      item
        DataType = ftInteger
        Name = 'askue_src'
        Value = 1
      end>
    object StringField1: TStringField
      FieldName = 'NAME'
      Required = True
      Size = 30
    end
    object StringField2: TStringField
      FieldName = 'NAME_STREET'
      Size = 30
    end
    object StringField3: TStringField
      FieldName = 'DK'
      Size = 45
    end
    object StringField4: TStringField
      FieldName = 'FLAT'
      Required = True
      Size = 10
    end
    object IntegerField1: TIntegerField
      FieldName = 'LS'
      Required = True
    end
    object StringField5: TStringField
      FieldName = 'ZAV_NOM'
      Required = True
    end
    object StringField6: TStringField
      FieldName = 'NAME_1'
      Required = True
      Size = 60
    end
    object StringField7: TStringField
      FieldName = 'KOMMENT'
      Size = 60
    end
  end
  object ODSRepStatUch: TDataSource
    DataSet = OQRepStatUch
    Left = 408
    Top = 416
  end
  object OQRepStatUch: TOraQuery
    Session = OS
    SQL.Strings = (
      
        'select distinct u.NAME, s.Type_Street, s.NAME_STREET, l.DOM, l.K' +
        'ORP, l.FLAT, ts.NAME, q.SER_NUM, d1.FAZA, d1.ZAV_NOM, asv.SCH_ST' +
        'AT_EXT'
      'from esbp.ls l'
      
        'left join (select d.LS, d.ZAV_NOM, d.FAZA from esbp.datch_m_ls d' +
        ' where d.DKD>sysdate) d1 on d1.ls=l.ls,'
      
        'esbp.street s, esbp.bilds b, esbp.uchastok u,  esbp.type_sch ts,' +
        ' esbp.schetch sch, askue.sch_type_ext ast, askue.sch_val asv'
      
        'right join (select asv.SER_NUM, max(asv.VAL_DATE)dat  from askue' +
        '.sch_val asv  group by asv.SER_NUM) q on asv.SER_NUM=q.ser_num a' +
        'nd asv.VAL_DATE=q.dat'
      'where l.TAUN=b.TAUN'
      'and l.STREET=b.STREET'
      'and l.DOM=b.DOM'
      'and l.KORP=b.KORP'
      'and b.UCHASTOK=u.UCHASTOK'
      'and b.TAUN=s.TAUN'
      'and b.STREET=s.STREET'
      'and l.LS=sch.LS'
      'and sch.TYPE_SCH=ts.TYPE_SCH'
      'and sch.ZAV_NOM=asv.SER_NUM'
      'and asv.INTER_TYPE=ast.INTER_TYPE'
      'and sch.TYPE_SCH=ast.SCH_TYPE'
      'and l.DKD>sysdate'
      'and sch.DKD>sysdate'
      'and ts.type_sch like :tsch'
      'and u.uchastok like :uch'
      'and s.street like :str'
      'and asv.SCH_STAT_EXT in ( :stat )'
      'ORDER BY u.NAME, s.NAME_STREET, l.DOM, l.KORP, l.FLAT'
      ''
      ''
      ''
      ''
      ''
      ''
      '')
    Active = True
    Left = 320
    Top = 416
    ParamData = <
      item
        DataType = ftString
        Name = 'tsch'
        Value = ''
      end
      item
        DataType = ftString
        Name = 'uch'
        Value = ''
      end
      item
        DataType = ftString
        Name = 'str'
        Value = ''
      end
      item
        DataType = ftString
        Name = 'stat'
        ParamType = ptInput
        Size = 10
      end>
    object OQRepStatUchNAME: TStringField
      DisplayWidth = 12
      FieldName = 'NAME'
      Required = True
      Size = 30
    end
    object OQRepStatUchNAME_STREET: TStringField
      DisplayWidth = 16
      FieldName = 'NAME_STREET'
      Size = 30
    end
    object OQRepStatUchDOM: TIntegerField
      DisplayWidth = 10
      FieldName = 'DOM'
      Required = True
    end
    object OQRepStatUchKORP: TStringField
      DisplayWidth = 4
      FieldName = 'KORP'
      Required = True
      Size = 4
    end
    object OQRepStatUchFLAT: TStringField
      DisplayWidth = 10
      FieldName = 'FLAT'
      Required = True
      Size = 10
    end
    object OQRepStatUchNAME_1: TStringField
      DisplayWidth = 17
      FieldName = 'NAME_1'
      Required = True
      Size = 60
    end
    object OQRepStatUchSER_NUM: TStringField
      DisplayWidth = 15
      FieldName = 'SER_NUM'
      Size = 50
    end
    object OQRepStatUchFAZA: TStringField
      DisplayWidth = 3
      FieldName = 'FAZA'
      Size = 3
    end
    object OQRepStatUchZAV_NOM: TStringField
      DisplayWidth = 11
      FieldName = 'ZAV_NOM'
      Required = True
    end
    object OQRepStatUchSCH_STAT_EXT: TFloatField
      DisplayWidth = 10
      FieldName = 'SCH_STAT_EXT'
    end
    object OQRepStatUchTYPE_STREET: TStringField
      FieldName = 'TYPE_STREET'
      Required = True
      Size = 6
    end
  end
  object OQStreet: TOraQuery
    Session = OS
    SQL.Strings = (
      'SELECT distinct s.name_street, b.street, u.uchastok '
      'FROM esbp.street s, esbp.bilds b, esbp.uchastok u'
      'WHERE s.street=b.street and b.uchastok=u.uchastok')
    Active = True
    Left = 312
    Top = 320
  end
  object DSStreet: TDataSource
    DataSet = OQStreet
    Left = 400
    Top = 320
  end
  object OTTypeSch: TOraTable
    TableName = 'ESBP.TYPE_SCH'
    OrderFields = 'Name'
    KeyFields = 'TYPE_SCH'
    Session = OS
    Active = True
    Left = 312
    Top = 256
  end
  object ODSTypeSch: TDataSource
    DataSet = OTTypeSch
    Left = 400
    Top = 256
  end
  object Get_BQRK_PROC: TOraStoredProc
    StoredProcName = 'askue.GET_BQRK'
    Session = OS
    SQL.Strings = (
      'begin'
      '  askue.GET_BQRK(:XFILTER);'
      'end;')
    Left = 320
    Top = 144
    ParamData = <
      item
        Name = 'XFILTER'
        ParamType = ptInput
        Value = ''
        ExtDataType = 107
      end>
  end
  object OQPar: TOraQuery
    Session = OS
    SQL.Strings = (
      
        'select a.account_id,a.date_m,a.W_,tid,numb from askue.metering a' +
        ' right join (select c.account_id,max(c.date_m) '
      
        'as dm from askue.metering c group by c.account_id) c1 on c1.acco' +
        'unt_id=a.account_id and c1.dm=a.date_m'
      
        'left join (select b.type_id as tid,b.unit_id,b.number_ as numb f' +
        'rom askue.unit b) c2'
      'on c2.unit_id=a.UNIT_ID')
    Left = 200
    Top = 544
    object OQParACCOUNT_ID: TFloatField
      FieldName = 'ACCOUNT_ID'
    end
    object OQParDATE_M: TDateTimeField
      FieldName = 'DATE_M'
    end
    object OQParW_: TFloatField
      FieldName = 'W_'
    end
    object OQParTID: TFloatField
      FieldName = 'TID'
    end
    object OQParNUMB: TFloatField
      FieldName = 'NUMB'
    end
  end
  object OQ2: TOraQuery
    Session = OS
    Left = 200
    Top = 592
  end
  object Get_RMS_PROC: TOraStoredProc
    StoredProcName = 'askue.UPDATE_RMS'
    Session = OS
    SQL.Strings = (
      'begin'
      '  askue.UPDATE_RMS(:PID_ROLL);'
      'end;')
    Left = 240
    Top = 128
    ParamData = <
      item
        DataType = ftFloat
        Name = 'PID_ROLL'
        ParamType = ptInput
      end>
  end
end
