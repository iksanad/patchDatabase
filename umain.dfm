object FPATCH: TFPATCH
  Left = 0
  Top = 0
  Caption = 'Patch Database'
  ClientHeight = 808
  ClientWidth = 1018
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
    Width = 1018
    Height = 808
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1008
    ExplicitHeight = 805
    DesignSize = (
      1018
      808)
    object sLabel1: TsLabel
      Left = 18
      Top = 13
      Width = 128
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'NAMA SERVER'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel2: TsLabel
      Left = 265
      Top = 13
      Width = 150
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'DATABASE LAMA'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sLabel3: TsLabel
      Left = 265
      Top = 83
      Width = 148
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'DATABASE BARU'
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
    object sLabel5: TsLabel
      Left = 777
      Top = 42
      Width = 202
      Height = 28
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Delimiter Non-Tables'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
    object sMemo1: TsMemo
      Left = 18
      Top = 179
      Width = 980
      Height = 610
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object cDBsource: TComboBox
      Left = 265
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
    object cDBcheck: TComboBox
      Left = 265
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
    object bCreatePatch: TsButton
      Left = 519
      Top = 106
      Width = 130
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Create Patch'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = bCreatePatchClick
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
    object bCopy: TsButton
      Left = 657
      Top = 106
      Width = 130
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Copy Patch'
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
      Left = 795
      Top = 106
      Width = 130
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Hapus Patch'
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
    object eDelimiter: TsEdit
      Left = 730
      Top = 39
      Width = 39
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '|'
      OnChange = eDelimiterChange
      ExplicitWidth = 29
      ExplicitHeight = 36
    end
    object sMemo2: TsMemo
      Left = 39
      Top = 195
      Width = 938
      Height = 610
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ScrollBars = ssBoth
      TabOrder = 9
      Visible = False
    end
    object cAutoPatch: TsCheckBox
      Left = 519
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
      TabOrder = 10
      OnExit = cAutoPatchExit
    end
    object bInfo: TsButton
      Left = 933
      Top = 106
      Width = 65
      Height = 45
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Info'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = bInfoClick
      AnimatEvents = [aeMouseEnter, aeMouseLeave, aeClick, aeGlobalDef]
      SkinData.CustomColor = True
      SkinData.CustomFont = True
      CommandLinkFont.Charset = DEFAULT_CHARSET
      CommandLinkFont.Color = 3155860
      CommandLinkFont.Height = -18
      CommandLinkFont.Name = 'Segoe UI'
      CommandLinkFont.Style = []
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
