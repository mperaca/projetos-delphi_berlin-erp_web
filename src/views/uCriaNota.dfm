object F_CriaNota: TF_CriaNota
  Left = 0
  Top = 0
  Width = 706
  Height = 400
  RenderInvisibleControls = False
  AllowPageAccess = True
  ConnectionMode = cmAny
  OnCreate = IWAppFormCreate
  Background.Fixed = False
  LayoutMgr = IWTemplateProcessorHTML1
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  XPTheme = True
  DesignLeft = 8
  DesignTop = 8
  object IWEditNumeroPedido: TIWEdit
    Left = 16
    Top = 3
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditNumeroPedido'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 0
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditDataEmissao: TIWEdit
    Left = 143
    Top = 3
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditNumeroPedido'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 1
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditSubTotal: TIWEdit
    Left = 270
    Top = 3
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditNumeroPedido'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 2
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotal: TIWEdit
    Left = 397
    Top = 3
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditNumeroPedido'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 3
    Enabled = False
    PasswordPrompt = False
  end
  object IWBUTTONACAO: TIWButton
    Left = 535
    Top = 3
    Width = 154
    Height = 25
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = True
    StyleRenderOptions.RenderSize = True
    StyleRenderOptions.RenderPosition = True
    StyleRenderOptions.RenderFont = True
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = True
    Caption = 'IWBUTTONACAO'
    DoSubmitValidation = True
    Color = clBtnFace
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWBUTTONACAO'
    ScriptEvents = <>
    TabOrder = 4
    OnAsyncClick = IWBUTTONACAOAsyncClick
  end
  object IWEDITID: TIWEdit
    Left = 535
    Top = 32
    Width = 154
    Height = 21
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = True
    StyleRenderOptions.RenderSize = True
    StyleRenderOptions.RenderPosition = True
    StyleRenderOptions.RenderFont = True
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = True
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEDITID'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    SubmitOnAsyncEvent = True
    TabOrder = 5
    PasswordPrompt = False
    Text = '10'
  end
  object IWEDITNOME: TIWEdit
    Left = 535
    Top = 59
    Width = 154
    Height = 21
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = True
    StyleRenderOptions.RenderSize = True
    StyleRenderOptions.RenderPosition = True
    StyleRenderOptions.RenderFont = True
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = True
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEDITNOME'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <>
    SubmitOnAsyncEvent = True
    TabOrder = 6
    PasswordPrompt = False
    Text = 'IWEDITNOME'
  end
  object IWLabelListaClientes: TIWLabel
    Left = 535
    Top = 117
    Width = 128
    Height = 16
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 10
    Font.Style = []
    NoWrap = False
    ConvertSpaces = False
    HasTabOrder = False
    FriendlyName = 'IWLabelListaClientes'
    Caption = 'IWLabelListaClientes'
    RawText = True
  end
  object IWEditCliente: TIWEdit
    Left = 16
    Top = 87
    Width = 248
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditClienteHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditTrabinHostName'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 7
    OnAsyncKeyUp = IWEditClienteAsyncKeyPress
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditCondicao: TIWEdit
    Left = 270
    Top = 87
    Width = 248
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCondicaoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditTrabinHostName'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 8
    OnAsyncKeyUp = IWEditCondicaoAsyncKeyPress
    Enabled = False
    PasswordPrompt = False
  end
  object IWLabelListaCondicoes: TIWLabel
    Left = 535
    Top = 131
    Width = 143
    Height = 16
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 10
    Font.Style = []
    NoWrap = False
    ConvertSpaces = False
    HasTabOrder = False
    FriendlyName = 'IWLabelListaCondicoes'
    Caption = 'IWLabelListaCondicoes'
    RawText = True
  end
  object IWEditVendedor: TIWEdit
    Left = 16
    Top = 114
    Width = 248
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditVendedorHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditVendedor'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 9
    OnAsyncKeyUp = IWEditVendedorAsyncKeyPress
    Enabled = False
    PasswordPrompt = False
  end
  object IWLabelListaVendedores: TIWLabel
    Left = 533
    Top = 146
    Width = 154
    Height = 16
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 10
    Font.Style = []
    NoWrap = False
    ConvertSpaces = False
    HasTabOrder = False
    FriendlyName = 'IWLabelListaVendedores'
    Caption = 'IWLabelListaVendedores'
    RawText = True
  end
  object IWEditCobranca: TIWEdit
    Left = 270
    Top = 114
    Width = 248
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCobrancaHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditCobranca'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 10
    OnAsyncKeyUp = IWEditCobrancaAsyncKeyPress
    Enabled = False
    PasswordPrompt = False
  end
  object IWLabelListaCobrancas: TIWLabel
    Left = 535
    Top = 162
    Width = 145
    Height = 16
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 10
    Font.Style = []
    NoWrap = False
    ConvertSpaces = False
    HasTabOrder = False
    FriendlyName = 'IWLabelListaCobrancas'
    Caption = 'IWLabelListaCobrancas'
    RawText = True
  end
  object IWEditCodProduto: TIWEdit
    Left = 16
    Top = 162
    Width = 89
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCodProdutoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditCodProduto'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 11
    OnAsyncKeyUp = IWEditCodProdutoAsyncKeyPress
    PasswordPrompt = False
  end
  object IWEditDescProduto: TIWEdit
    Left = 111
    Top = 162
    Width = 407
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCodProdutoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditDescProduto'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 12
    OnAsyncKeyUp = IWEditDescProdutoAsyncKeyPress
    PasswordPrompt = False
  end
  object IWEditUnitario: TIWEdit
    Left = 16
    Top = 189
    Width = 161
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCodProdutoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditUnitario'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 13
    PasswordPrompt = False
  end
  object IWEditQuantidade: TIWEdit
    Left = 183
    Top = 189
    Width = 173
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCodProdutoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditUnitario'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 14
    PasswordPrompt = False
  end
  object IWEditTotalItem: TIWEdit
    Left = 362
    Top = 189
    Width = 156
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditCodProdutoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = True
    StyleRenderOptions.RenderVisibility = True
    StyleRenderOptions.RenderStatus = True
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditUnitario'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 15
    Enabled = False
    PasswordPrompt = False
  end
  object IWLabelListaProdutos: TIWLabel
    Left = 534
    Top = 178
    Width = 134
    Height = 16
    Cursor = crAuto
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 10
    Font.Style = []
    NoWrap = False
    ConvertSpaces = False
    HasTabOrder = False
    FriendlyName = 'IWLabelListaProdutos'
    Caption = 'IWLabelListaProdutos'
    RawText = True
  end
  object IWEditBaseICMS: TIWEdit
    Left = 16
    Top = 30
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseICMS'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 16
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotalICMS: TIWEdit
    Left = 143
    Top = 30
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditTotalICMS'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 17
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditBaseST: TIWEdit
    Left = 270
    Top = 30
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseST'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 18
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotalST: TIWEdit
    Left = 397
    Top = 30
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseST'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 19
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotalIPI: TIWEdit
    Left = 16
    Top = 60
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseST'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 20
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotalPIS: TIWEdit
    Left = 143
    Top = 60
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseST'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 21
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotalCOFINS: TIWEdit
    Left = 270
    Top = 60
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseST'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 22
    Enabled = False
    PasswordPrompt = False
  end
  object IWEditTotalDescontos: TIWEdit
    Left = 397
    Top = 60
    Width = 121
    Height = 21
    Cursor = crAuto
    ExtraTagParams.Strings = (
      'font-size: 20px;')
    OnHTMLTag = IWEditNumeroPedidoHTMLTag
    Css = 'form-control'
    ParentShowHint = False
    ShowHint = True
    ZIndex = 0
    RenderSize = False
    StyleRenderOptions.RenderSize = False
    StyleRenderOptions.RenderPosition = False
    StyleRenderOptions.RenderFont = False
    StyleRenderOptions.RenderZIndex = False
    StyleRenderOptions.RenderVisibility = False
    StyleRenderOptions.RenderStatus = False
    StyleRenderOptions.RenderAbsolute = False
    Alignment = taLeftJustify
    BGColor = clNone
    FocusColor = clNone
    DoSubmitValidation = True
    Editable = True
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Enabled = False
    Font.Size = 20
    Font.Style = []
    FriendlyName = 'IWEditBaseST'
    MaxLength = 0
    ReadOnly = False
    Required = False
    ScriptEvents = <
      item
        EventCode.Strings = (
          'this.select();')
        Event = 'onFocus'
      end>
    SubmitOnAsyncEvent = True
    TabOrder = 23
    Enabled = False
    PasswordPrompt = False
  end
  object IWTemplateProcessorHTML1: TIWTemplateProcessorHTML
    TagType = ttIntraWeb
    RenderStyles = False
    Left = 568
    Top = 192
  end
  object IdHTTP1: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
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
    Left = 583
    Top = 296
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 575
    Top = 240
  end
end