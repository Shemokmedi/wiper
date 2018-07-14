object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Wiper v.1.3'
  ClientHeight = 395
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grbDropBox: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 97
    Caption = ' DropBox '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      385
      97)
    object Label1: TLabel
      Left = 11
      Top = 18
      Width = 40
      Height = 13
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label2: TLabel
      Left = 11
      Top = 45
      Width = 34
      Height = 13
      Caption = 'Uninst:'
    end
    object Label3: TLabel
      Left = 11
      Top = 72
      Width = 44
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1077':'
    end
    object edtDropBoxStatus: TEdit
      Left = 57
      Top = 15
      Width = 320
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 0
      Text = '?'
    end
    object edtDropBoxUninstaller: TEdit
      Left = 57
      Top = 42
      Width = 288
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '?'
    end
    object edtDropBoxDataDir: TEdit
      Left = 57
      Top = 69
      Width = 288
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '?'
    end
    object btnOpenUninstaller: TButton
      Left = 348
      Top = 42
      Width = 29
      Height = 21
      Caption = #61489
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TabStop = False
      OnClick = btnOpenUninstallerClick
    end
    object Button2: TButton
      Left = 348
      Top = 69
      Width = 29
      Height = 21
      Caption = #61489
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      TabStop = False
      OnClick = Button2Click
    end
  end
  object grb1C: TGroupBox
    Left = 8
    Top = 111
    Width = 385
    Height = 99
    Caption = ' 1'#1057' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      385
      99)
    object Label4: TLabel
      Left = 11
      Top = 18
      Width = 40
      Height = 13
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label6: TLabel
      Left = 11
      Top = 73
      Width = 44
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1077':'
    end
    object Label10: TLabel
      Left = 11
      Top = 45
      Width = 45
      Height = 13
      Caption = #1055#1088#1086#1094#1077#1089#1089':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edt1CStatus: TEdit
      Left = 57
      Top = 15
      Width = 320
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 0
      Text = '?'
    end
    object edt1CDataDir: TEdit
      Left = 57
      Top = 70
      Width = 288
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '?'
    end
    object Button3: TButton
      Left = 348
      Top = 70
      Width = 29
      Height = 21
      Caption = #61489
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = False
      OnClick = Button3Click
    end
    object edt1CExeName: TEdit
      Left = 57
      Top = 42
      Width = 288
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '?'
    end
    object btnOpen1CExe: TButton
      Left = 348
      Top = 42
      Width = 29
      Height = 21
      Caption = #61489
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      TabStop = False
      OnClick = btnOpen1CExeClick
    end
  end
  object grbFiles: TGroupBox
    Left = 8
    Top = 215
    Width = 385
    Height = 171
    Caption = ' '#1060#1072#1081#1083#1099'  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    DesignSize = (
      385
      171)
    object Label5: TLabel
      Left = 11
      Top = 18
      Width = 40
      Height = 13
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label8: TLabel
      Left = 11
      Top = 45
      Width = 44
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtFilesStatus: TEdit
      Left = 57
      Top = 15
      Width = 320
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 0
      Text = '?'
    end
    object lbxDirList: TListBox
      Left = 57
      Top = 42
      Width = 320
      Height = 95
      TabStop = False
      Color = clInfoBk
      Ctl3D = False
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 1
    end
    object Button4: TButton
      Left = 57
      Top = 140
      Width = 21
      Height = 21
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = False
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 80
      Top = 140
      Width = 21
      Height = 21
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TabStop = False
      OnClick = Button5Click
    end
  end
  object grbKey: TGroupBox
    Left = 399
    Top = 111
    Width = 249
    Height = 99
    Caption = ' Flash Key '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    DesignSize = (
      249
      99)
    object Label7: TLabel
      Left = 11
      Top = 18
      Width = 40
      Height = 13
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label9: TLabel
      Left = 11
      Top = 45
      Width = 32
      Height = 13
      Caption = #1050#1083#1102#1095':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtKeyFileStatus: TEdit
      Left = 57
      Top = 15
      Width = 184
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 0
      Text = '?'
    end
    object edtKeyFileName: TEdit
      Left = 57
      Top = 42
      Width = 184
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '?'
      OnKeyPress = edtKeyFileNameKeyPress
    end
    object Button6: TButton
      Left = 57
      Top = 69
      Width = 184
      Height = 21
      Caption = #1055#1091#1089#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = False
      OnClick = Button6Click
    end
  end
  object grbOptions: TGroupBox
    Left = 399
    Top = 215
    Width = 249
    Height = 130
    Caption = ' '#1054#1087#1094#1080#1080' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    DesignSize = (
      249
      130)
    object Label11: TLabel
      Left = 12
      Top = 82
      Width = 133
      Height = 13
      Caption = #1047#1074#1091#1082' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1088#1072#1073#1086#1090#1099':'
    end
    object chbAutoload: TCheckBox
      Left = 12
      Top = 16
      Width = 224
      Height = 17
      Caption = ' '#1040#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080' '#1074#1082#1083#1102#1095#1077#1085#1080#1080' Windows'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnMouseActivate = chbAutoloadMouseActivate
    end
    object chbAutokill: TCheckBox
      Left = 12
      Top = 39
      Width = 224
      Height = 17
      Caption = ' '#1057#1072#1084#1086#1091#1076#1072#1083#1077#1085#1080#1077' '#1087#1086#1089#1083#1077' '#1072#1082#1090#1080#1074#1072#1094#1080#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnMouseActivate = chbAutokillMouseActivate
    end
    object edtFinalWave: TEdit
      Left = 11
      Top = 101
      Width = 202
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 2
      Text = '?'
    end
    object Button7: TButton
      Left = 215
      Top = 101
      Width = 29
      Height = 21
      Caption = #61489
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TabStop = False
      OnClick = Button7Click
    end
    object chbLog: TCheckBox
      Left = 12
      Top = 60
      Width = 224
      Height = 17
      Caption = ' '#1051#1086#1075#1080#1088#1086#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnMouseActivate = chbLogMouseActivate
    end
  end
  object btnClose: TButton
    Left = 399
    Top = 350
    Width = 45
    Height = 36
    Caption = #61560
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -30
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object btnSave: TButton
    Left = 602
    Top = 350
    Width = 45
    Height = 36
    Caption = #61500
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -30
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnSaveClick
  end
  object GroupBox1: TGroupBox
    Left = 399
    Top = 8
    Width = 248
    Height = 97
    Caption = ' SDelete '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 7
    DesignSize = (
      248
      97)
    object Label12: TLabel
      Left = 11
      Top = 18
      Width = 40
      Height = 13
      Caption = #1057#1090#1072#1090#1091#1089':'
    end
    object Label13: TLabel
      Left = 11
      Top = 45
      Width = 40
      Height = 13
      Caption = #1056#1072#1079#1088#1103#1076':'
    end
    object Label14: TLabel
      Left = 11
      Top = 72
      Width = 30
      Height = 13
      Caption = #1060#1072#1081#1083':'
    end
    object edtSDeleteStatus: TEdit
      Left = 57
      Top = 15
      Width = 183
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 0
      Text = '?'
    end
    object edtSDeleteWoW: TEdit
      Left = 57
      Top = 42
      Width = 183
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '?'
    end
    object edtSDeleteFileName: TEdit
      Left = 57
      Top = 69
      Width = 183
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '?'
    end
  end
  object opdMain: TOpenDialog
    Left = 24
    Top = 296
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 168
    Top = 296
  end
  object TrayIcon1: TTrayIcon
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      000000000000330077000000000000000000000000003B077070000000000000
      000000000000BB807007000000000000000000000300B0007000700000000000
      00000000330070070700070000000000000000003B0700700070007000000000
      00000000BB800700000700070000000000000300B00070000000700070000000
      0000330070070000000007000700000000003B07007000000000007007000000
      0000BB800700000000000007070000000300B000700000000070000077000000
      330070070000000007000000803300003B070070000000000000000800330000
      BB8007000000000000000080BBBB0300B000700000000070000008000BB03300
      70070000000707000000803300003B070070000000707000000800330000BB80
      07000000070700000080BBBB0000B000700000000070000008000BB000007007
      0000000007000000803300000000707000007770000000080033000000008700
      0007070700000080BBBB00000000080000077777000008000BB0000000000080
      0007070700008033000000000000000800007770000800330000000000000000
      800000000080BBBB00000000000000000800000008000BB00000000000000000
      0080000080330000000000000000000000080008003300000000000000000000
      00008080BBBB00000000000000000000000008000BB00000000000000000FFFF
      33FFFFFF21FFFFFF00FFFFFB007FFFF3003FFFF2001FFFF0000FFFB00007FF30
      0003FF200003FF000003FB000003F3000000F2000000F0000010B00000393000
      000F2000000F0000010F0000039F000000FF000000FF000010FF800039FFC000
      0FFFE0000FFFF0010FFFF8039FFFFC00FFFFFE00FFFFFF10FFFFFFB9FFFF}
    OnClick = TrayIcon1Click
    Left = 96
    Top = 296
  end
end
