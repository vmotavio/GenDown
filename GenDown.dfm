object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Gerenciador de Downloads'
  ClientHeight = 233
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 480
    Top = 79
    Width = 17
    Height = 13
    Caption = '0%'
  end
  object Label1: TLabel
    Left = 24
    Top = 79
    Width = 3
    Height = 13
  end
  object Edit1: TEdit
    Left = 24
    Top = 24
    Width = 473
    Height = 21
    TabOrder = 0
    Text = 'Digite a URL do arquivo'
  end
  object Button1: TButton
    Left = 512
    Top = 22
    Width = 89
    Height = 25
    Caption = 'Iniciar Download'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 24
    Top = 51
    Width = 473
    Height = 17
    TabOrder = 2
  end
  object Button2: TButton
    Left = 512
    Top = 74
    Width = 89
    Height = 25
    Caption = 'Parar Download'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 167
    Top = 101
    Width = 154
    Height = 25
    Caption = 'Exibir Hist'#243'rico de Download'
    TabOrder = 4
    OnClick = Button3Click
  end
  object IdHTTP1: TIdHTTP
    OnWork = IdHTTP1Work
    OnWorkBegin = IdHTTP1WorkBegin
    OnWorkEnd = IdHTTP1WorkEnd
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 24
    Top = 104
  end
  object SaveDialog1: TSaveDialog
    Left = 80
    Top = 104
  end
  object DataSource1: TDataSource
    Left = 168
    Top = 136
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Users\otavio\Desktop\GenDown\banco.db'
      'LockingMode=Normal'
      'DriverID=sQLite')
    Left = 288
    Top = 136
  end
  object FDTable1: TFDTable
    IndexFieldNames = 'CODIGO'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'LOGDOWNLOAD'
    TableName = 'LOGDOWNLOAD'
    Left = 224
    Top = 136
  end
end
