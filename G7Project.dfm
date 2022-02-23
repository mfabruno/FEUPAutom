object FG7Project: TFG7Project
  Left = 268
  Height = 418
  Top = 205
  Width = 678
  Caption = 'Project'
  ClientHeight = 418
  ClientWidth = 678
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  OnCreate = FormCreate
  Position = poOwnerFormCenter
  LCLVersion = '1.2.4.0'
  object BOK: TButton
    Left = 592
    Height = 25
    Top = 360
    Width = 75
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object BCancel: TButton
    Left = 508
    Height = 25
    Top = 360
    Width = 75
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 0
    Height = 353
    Top = 0
    Width = 669
    ActivePage = TabVariables
    Anchors = [akTop, akLeft, akRight, akBottom]
    TabIndex = 2
    TabOrder = 2
    object TabConfig: TTabSheet
      Caption = 'Config'
    end
    object TabIOModules: TTabSheet
      Caption = 'I/O Modules'
      ImageIndex = 1
    end
    object TabVariables: TTabSheet
      Caption = 'Variables'
      ClientHeight = 327
      ClientWidth = 661
      ImageIndex = 2
      object CBVarType: TComboBox
        Left = 8
        Height = 21
        Top = 8
        Width = 145
        ItemHeight = 13
        ItemIndex = 0
        Items.Strings = (
          'All'
          'Boolean'
          'Integer'
          'Real'
          'Timer'
        )
        Style = csDropDownList
        TabOrder = 0
        Text = 'All'
      end
      object SGVariables: TStringGrid
        Left = 0
        Height = 19
        Top = 280
        Width = 653
        Anchors = [akTop, akLeft, akRight, akBottom]
        ColCount = 6
        DefaultColWidth = 128
        DefaultRowHeight = 16
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        RowCount = 128
        TabOrder = 1
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
      end
    end
  end
end
