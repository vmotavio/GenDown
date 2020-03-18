object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Hist'#243'rico de Downloads'
  ClientHeight = 264
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 24
    Top = 17
    Width = 617
    Height = 200
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 32
    Top = 216
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Users\otavio\Desktop\GenDown\banco.db'
      'DriverID=SQLite'
      'LockingMode=Normal')
    Connected = True
    Left = 96
    Top = 216
  end
  object FDTable1: TFDTable
    Active = True
    IndexFieldNames = 'CODIGO'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'LOGDOWNLOAD'
    TableName = 'LOGDOWNLOAD'
    Left = 152
    Top = 216
  end
end
