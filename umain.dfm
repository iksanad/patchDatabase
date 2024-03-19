object FPATCH: TFPATCH
  Left = 0
  Top = 0
  Caption = 'Patch Database'
  ClientHeight = 805
  ClientWidth = 947
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 140
  TextHeight = 25
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 947
    Height = 805
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Color = 16182204
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 937
    ExplicitHeight = 802
    object sLabel6: TsLabel
      Left = 710
      Top = 83
      Width = 134
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'PORT SERVER 2'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel5: TsLabel
      Left = 710
      Top = 13
      Width = 134
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'PORT SERVER 1'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel8: TsLabel
      Left = 480
      Top = 83
      Width = 186
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'PASSWORD SERVER 2'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel7: TsLabel
      Left = 480
      Top = 13
      Width = 186
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'PASSWORD SERVER 1'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel2: TsLabel
      Left = 249
      Top = 13
      Width = 172
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'DATABASE SUMBER'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel3: TsLabel
      Left = 249
      Top = 83
      Width = 170
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'DATABASE TUJUAN'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel1: TsLabel
      Left = 18
      Top = 13
      Width = 143
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'NAMA SERVER 1'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel4: TsLabel
      Left = 18
      Top = 83
      Width = 143
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'NAMA SERVER 2'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel9: TsLabel
      Left = 18
      Top = 169
      Width = 181
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OPSI PILIHAN PATCH'
      ParentFont = False
      Visible = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object cPortCheck: TsEdit
      Left = 710
      Top = 112
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 18
      Visible = False
      OnChange = cServer2Change
    end
    object cPortSource: TsEdit
      Left = 710
      Top = 42
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 17
      Visible = False
      OnChange = cServerChange
    end
    object cPassSource: TsEdit
      Left = 480
      Top = 42
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      PasswordChar = '*'
      TabOrder = 12
      Visible = False
      OnChange = cServerChange
    end
    object cPassCheck: TsEdit
      Left = 480
      Top = 112
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      PasswordChar = '*'
      TabOrder = 13
      Visible = False
      OnChange = cServer2Change
    end
    object cUserCheck: TsEdit
      Left = 249
      Top = 112
      Width = 220
      Height = 33
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      TabOrder = 15
      Visible = False
      OnChange = cServer2Change
    end
    object cUserSource: TsEdit
      Left = 249
      Top = 42
      Width = 220
      Height = 33
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      TabOrder = 16
      Visible = False
      OnChange = cServerChange
    end
    object cDBcheck: TComboBox
      Left = 249
      Top = 112
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
      OnEnter = cDBcheckEnter
    end
    object bCopy: TsButton
      Left = 626
      Top = 106
      Width = 70
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Copy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = bCopyClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = 13612943
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
    end
    object bSetting: TsButton
      Left = 784
      Top = 106
      Width = 142
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Open Setting'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = bSettingClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
    end
    object sMemo1: TsMemo
      Left = 18
      Top = 175
      Width = 911
      Height = 610
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object cDBsource: TComboBox
      Left = 249
      Top = 42
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 1
      OnEnter = cDBsourceEnter
    end
    object bStartPatch: TsButton
      Left = 480
      Top = 36
      Width = 250
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Create Patch'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = bStartPatchClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      SkinData.ColorTone = 1560658
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
    end
    object cServer: TsEdit
      Left = 18
      Top = 42
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 4
      OnChange = cServerChange
      OnExit = cServerExit
    end
    object cServer2: TsEdit
      Left = 18
      Top = 112
      Width = 220
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 6
      OnChange = cServer2Change
      OnExit = cServer2Exit
    end
    object bDelete: TsButton
      Left = 706
      Top = 106
      Width = 70
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = bDeleteClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
    end
    object sMemo2: TsMemo
      Left = 39
      Top = 195
      Width = 858
      Height = 610
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Enabled = False
      ScrollBars = ssBoth
      TabOrder = 8
      Visible = False
    end
    object cAutoPatch: TsCheckBox
      Left = 746
      Top = 41
      Width = 172
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Otomatis Patch'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnExit = cAutoPatchExit
    end
    object bExit: TsButton
      Left = 750
      Top = 202
      Width = 136
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Keluar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      Visible = False
      OnClick = bExitClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
    end
    object eDelimiter: TsEdit
      Left = 1
      Top = 768
      Width = 945
      Height = 36
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 14
      Text = '|'
      Visible = False
      OnChange = eDelimiterChange
      ExplicitTop = 765
      ExplicitWidth = 935
    end
    object bDefault: TsButton
      Left = 480
      Top = 106
      Width = 138
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Default Server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 19
      OnClick = bDefaultClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
    end
    object cPatchChoice: TComboBox
      Left = 208
      Top = 165
      Width = 261
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ItemIndex = 0
      ParentFont = False
      TabOrder = 20
      Text = 'Semua Patch'
      Visible = False
      Items.Strings = (
        'Semua Patch'
        'Hanya Patch Table'
        'Hanya Patch Trigger'
        'Patch Function dan Procedure'
        'Patch Field ERP Tertentu')
    end
  end
  object con1: TMyConnection
    Options.DisconnectedMode = True
    Options.LocalFailover = True
    Username = 'Fatra'
    Server = '192.168.0.38'
    Left = 37
    Top = 205
    EncryptedPassword = 'C8FFCCFF99FF9EFF91FF98FF99FF9EFF91FF98FF'
  end
  object con2: TMyConnection
    Options.DisconnectedMode = True
    Options.LocalFailover = True
    Username = 'Fatra'
    Server = '192.168.0.38'
    Left = 100
    Top = 205
    EncryptedPassword = 'C8FFCCFF99FF9EFF91FF98FF99FF9EFF91FF98FF'
  end
end
