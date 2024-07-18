object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Process Planning'
  ClientHeight = 439
  ClientWidth = 908
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = create
  PixelsPerInch = 96
  TextHeight = 15
  object title: TLabel
    Left = 392
    Top = 24
    Width = 153
    Height = 24
    Caption = 'Process Planning'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 506
    Top = 75
    Width = 125
    Height = 19
    Caption = 'Comparative Results'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object lbWinner: TLabel
    Left = 336
    Top = 312
    Width = 330
    Height = 19
    Alignment = taCenter
    Caption = 'El algoritmo mas eficiente para completar esta tarea es:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object winner: TLabel
    Left = 672
    Top = 312
    Width = 4
    Height = 19
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object gridData: TStringGrid
    Left = 33
    Top = 112
    Width = 255
    Height = 121
    ColCount = 2
    Ctl3D = True
    DefaultColWidth = 125
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goFixedRowDefAlign]
    ParentCtl3D = False
    TabOrder = 0
    OnSelectCell = selectCell
    RowHeights = (
      24
      24)
  end
  object Button1: TButton
    Left = 33
    Top = 73
    Width = 75
    Height = 25
    Caption = 'Add Row'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object calculator: TButton
    Left = 213
    Top = 73
    Width = 75
    Height = 25
    Caption = 'Calculate'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = calculatorClick
  end
  object gridResult: TStringGrid
    Left = 315
    Top = 112
    Width = 527
    Height = 129
    DefaultColWidth = 130
    ScrollBars = ssNone
    TabOrder = 3
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object delRow: TButton
    Left = 119
    Top = 73
    Width = 86
    Height = 25
    Caption = 'Delete Row'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = delRowClick
  end
end
