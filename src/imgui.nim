# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

## ImGUI Bindings
## ====
## WARNING: This is a generated file. Do not edit
## Any edits will be overwritten by the generator.
##
## The aim is to achieve as much compatibility with C as possible.
## Optional helper functions have been created as a submodule
## ``imgui/imgui_helpers`` to better bind this library to Nim.
##
## You can check the original documentation `here <https://github.com/ocornut/imgui/blob/master/imgui.cpp>`_.
##
## Source language of ImGui is C++, since Nim is able to compile both to C
## and C++ you can select which compile target you wish to use. Note that to use
## the C backend you must supply a `cimgui <https://github.com/cimgui/cimgui>`_
## dynamic library file.
##
## HACK: If you are targeting Windows, be sure to compile the cimgui dll with
## visual studio and not with mingw.

import strutils

## Tentative workaround [start]
type
  uint32Ptr* = ptr uint32
  Imguidockrequest* = distinct object
  ImGuiDockNodeSettings* = distinct object
  const_cstringPtr* {.pure, inheritable, bycopy.} = object
    Size*: cint
    Capacity*: cint
    Data*: ptr ptr cschar
when not defined(cpp) or defined(cimguiDLL):
  type ImDrawIdx* = uint16
else:
  type ImDrawIdx* = uint32
## Tentative workaround [end]

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/imgui/private/cimgui" & " -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1".}

when not defined(cpp) or defined(cimguiDLL):
  when defined(windows):
    const imgui_dll* = "cimgui.dll"
  elif defined(macosx):
    const imgui_dll* = "cimgui.dylib"
  else:
    const imgui_dll* = "cimgui.so"
    when defined(linux):
      {.passL: "-Xlinker -rpath .".}
  {.passC: "-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS".}
  {.pragma: imgui_header, header: "cimgui.h".}
else:
  {.passC:"-DImDrawIdx=\"unsigned int\"".}
  {.compile: "imgui/private/cimgui/cimgui.cpp",
    compile: "imgui/private/cimgui/imgui/imgui.cpp",
    compile: "imgui/private/cimgui/imgui/imgui_draw.cpp",
    compile: "imgui/private/cimgui/imgui/imgui_tables.cpp",
    compile: "imgui/private/cimgui/imgui/imgui_widgets.cpp",
    compile: "imgui/private/cimgui/imgui/imgui_demo.cpp".}
  {.pragma: imgui_header, header: currentSourceDir() & "/imgui/private/ncimgui.h".}

# Enums
type
  ImDrawFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Closed = 1
    RoundCornersTopLeft = 16
    RoundCornersTopRight = 32
    RoundCornersTop = 48
    RoundCornersBottomLeft = 64
    RoundCornersLeft = 80
    RoundCornersBottomRight = 128
    RoundCornersRight = 160
    RoundCornersBottom = 192
    RoundCornersAll = 240
    RoundCornersNone = 256
    RoundCornersMask = 496
  ImDrawListFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    AntiAliasedLines = 1
    AntiAliasedLinesUseTex = 2
    AntiAliasedFill = 4
    AllowVtxOffset = 8
  ImFontAtlasFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoPowerOfTwoHeight = 1
    NoMouseCursors = 2
    NoBakedLines = 4
  ImGuiActivateFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    PreferInput = 1
    PreferTweak = 2
    TryToPreserveState = 4
  ImGuiAxis* {.pure, size: int32.sizeof.} = enum
    None = -1
    X = 0
    Y = 1
  ImGuiBackendFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    HasGamepad = 1
    HasMouseCursors = 2
    HasSetMousePos = 4
    RendererHasVtxOffset = 8
    PlatformHasViewports = 1024
    HasMouseHoveredViewport = 2048
    RendererHasViewports = 4096
  ImGuiButtonFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    PressedOnClick = 16
    PressedOnClickRelease = 32
    PressedOnClickReleaseAnywhere = 64
    PressedOnRelease = 128
    PressedOnDoubleClick = 256
    PressedOnDragDropHold = 512
    PressedOnMask = 1008
    Repeat = 1024
    FlattenChildren = 2048
    AllowOverlap = 4096
    DontClosePopups = 8192
    AlignTextBaseLine = 32768
    NoKeyModifiers = 65536
    NoHoldingActiveId = 131072
    NoNavFocus = 262144
    NoHoveredOnFocus = 524288
    NoSetKeyOwner = 1048576
    NoTestKeyOwner = 2097152
  ImGuiButtonFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    MouseButtonLeft = 1
    MouseButtonRight = 2
    MouseButtonMiddle = 4
    MouseButtonMask = 7
  ImGuiCol* {.pure, size: int32.sizeof.} = enum
    Text = 0
    TextDisabled = 1
    WindowBg = 2
    ChildBg = 3
    PopupBg = 4
    Border = 5
    BorderShadow = 6
    FrameBg = 7
    FrameBgHovered = 8
    FrameBgActive = 9
    TitleBg = 10
    TitleBgActive = 11
    TitleBgCollapsed = 12
    MenuBarBg = 13
    ScrollbarBg = 14
    ScrollbarGrab = 15
    ScrollbarGrabHovered = 16
    ScrollbarGrabActive = 17
    CheckMark = 18
    SliderGrab = 19
    SliderGrabActive = 20
    Button = 21
    ButtonHovered = 22
    ButtonActive = 23
    Header = 24
    HeaderHovered = 25
    HeaderActive = 26
    Separator = 27
    SeparatorHovered = 28
    SeparatorActive = 29
    ResizeGrip = 30
    ResizeGripHovered = 31
    ResizeGripActive = 32
    Tab = 33
    TabHovered = 34
    TabActive = 35
    TabUnfocused = 36
    TabUnfocusedActive = 37
    DockingPreview = 38
    DockingEmptyBg = 39
    PlotLines = 40
    PlotLinesHovered = 41
    PlotHistogram = 42
    PlotHistogramHovered = 43
    TableHeaderBg = 44
    TableBorderStrong = 45
    TableBorderLight = 46
    TableRowBg = 47
    TableRowBgAlt = 48
    TextSelectedBg = 49
    DragDropTarget = 50
    NavHighlight = 51
    NavWindowingHighlight = 52
    NavWindowingDimBg = 53
    ModalWindowDimBg = 54
  ImGuiColorEditFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoAlpha = 2
    NoPicker = 4
    NoOptions = 8
    NoSmallPreview = 16
    NoInputs = 32
    NoTooltip = 64
    NoLabel = 128
    NoSidePreview = 256
    NoDragDrop = 512
    NoBorder = 1024
    AlphaBar = 65536
    AlphaPreview = 131072
    AlphaPreviewHalf = 262144
    HDR = 524288
    DisplayRGB = 1048576
    DisplayHSV = 2097152
    DisplayHex = 4194304
    DisplayMask = 7340032
    Uint8 = 8388608
    Float = 16777216
    DataTypeMask = 25165824
    PickerHueBar = 33554432
    PickerHueWheel = 67108864
    PickerMask = 100663296
    InputRGB = 134217728
    DefaultOptions = 177209344
    InputHSV = 268435456
    InputMask = 402653184
  ImGuiComboFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    CustomPreview = 1048576
  ImGuiComboFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    PopupAlignLeft = 1
    HeightSmall = 2
    HeightRegular = 4
    HeightLarge = 8
    HeightLargest = 16
    HeightMask = 30
    NoArrowButton = 32
    NoPreview = 64
  ImGuiCond* {.pure, size: int32.sizeof.} = enum
    None = 0
    Always = 1
    Once = 2
    FirstUseEver = 4
    Appearing = 8
  ImGuiConfigFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NavEnableKeyboard = 1
    NavEnableGamepad = 2
    NavEnableSetMousePos = 4
    NavNoCaptureKeyboard = 8
    NoMouse = 16
    NoMouseCursorChange = 32
    DockingEnable = 64
    ViewportsEnable = 1024
    DpiEnableScaleViewports = 16384
    DpiEnableScaleFonts = 32768
    IsSRGB = 1048576
    IsTouchScreen = 2097152
  ImGuiContextHookType* {.pure, size: int32.sizeof.} = enum
    NewFramePre = 0
    NewFramePost = 1
    EndFramePre = 2
    EndFramePost = 3
    RenderPre = 4
    RenderPost = 5
    Shutdown = 6
    PendingRemoval = 7
  ImGuiDataAuthority* {.pure, size: int32.sizeof.} = enum
    Auto = 0
    DockNode = 1
    Window = 2
  ImGuiDataTypePrivate* {.pure, size: int32.sizeof.} = enum
    String = 11
    Pointer = 12
    ID = 13
  ImGuiDataType* {.pure, size: int32.sizeof.} = enum
    S8 = 0
    U8 = 1
    S16 = 2
    U16 = 3
    S32 = 4
    U32 = 5
    S64 = 6
    U64 = 7
    Float = 8
    Double = 9
  ImGuiDebugLogFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    EventActiveId = 1
    EventFocus = 2
    EventPopup = 4
    EventNav = 8
    EventClipper = 16
    EventSelection = 32
    EventIO = 64
    EventDocking = 128
    EventViewport = 256
    EventMask = 511
    OutputToTTY = 1024
  ImGuiDir* {.pure, size: int32.sizeof.} = enum
    None = -1
    Left = 0
    Right = 1
    Up = 2
    Down = 3
  ImGuiDockNodeFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    SharedFlagsInheritMask = -1
    DockSpace = 1024
    CentralNode = 2048
    NoTabBar = 4096
    HiddenTabBar = 8192
    NoWindowMenuButton = 16384
    NoCloseButton = 32768
    NoDocking = 65536
    NoDockingSplitMe = 131072
    NoDockingSplitOther = 262144
    NoDockingOverMe = 524288
    NoDockingOverOther = 1048576
    NoDockingOverEmpty = 2097152
    NoResizeX = 4194304
    NoResizeY = 8388608
    NoResizeFlagsMask = 12582944
    LocalFlagsTransferMask = 12712048
    SavedFlagsMask = 12712992
    LocalFlagsMask = 12713072
  ImGuiDockNodeFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    KeepAliveOnly = 1
    NoDockingInCentralNode = 4
    PassthruCentralNode = 8
    NoSplit = 16
    NoResize = 32
    AutoHideTabBar = 64
  ImGuiDockNodeState* {.pure, size: int32.sizeof.} = enum
    Unknown = 0
    HostWindowHiddenBecauseSingleWindow = 1
    HostWindowHiddenBecauseWindowsAreResizing = 2
    HostWindowVisible = 3
  ImGuiDragDropFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    SourceNoPreviewTooltip = 1
    SourceNoDisableHover = 2
    SourceNoHoldToOpenOthers = 4
    SourceAllowNullID = 8
    SourceExtern = 16
    SourceAutoExpirePayload = 32
    AcceptBeforeDelivery = 1024
    AcceptNoDrawDefaultRect = 2048
    AcceptPeekOnly = 3072
    AcceptNoPreviewTooltip = 4096
  ImGuiFocusRequestFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    RestoreFocusedChild = 1
    UnlessBelowModal = 2
  ImGuiFocusedFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    ChildWindows = 1
    RootWindow = 2
    RootAndChildWindows = 3
    AnyWindow = 4
    NoPopupHierarchy = 8
    DockHierarchy = 16
  ImGuiHoveredFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    AllowedMaskForIsWindowHovered = 12479
    DelayMask = 245760
    AllowedMaskForIsItemHovered = 262048
  ImGuiHoveredFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    ChildWindows = 1
    RootWindow = 2
    RootAndChildWindows = 3
    AnyWindow = 4
    NoPopupHierarchy = 8
    DockHierarchy = 16
    AllowWhenBlockedByPopup = 32
    AllowWhenBlockedByActiveItem = 128
    AllowWhenOverlappedByItem = 256
    AllowWhenOverlappedByWindow = 512
    AllowWhenOverlapped = 768
    RectOnly = 928
    AllowWhenDisabled = 1024
    NoNavOverride = 2048
    ForTooltip = 4096
    Stationary = 8192
    DelayNone = 16384
    DelayShort = 32768
    DelayNormal = 65536
    NoSharedDelay = 131072
  ImGuiInputEventType* {.pure, size: int32.sizeof.} = enum
    None = 0
    MousePos = 1
    MouseWheel = 2
    MouseButton = 3
    MouseViewport = 4
    Key = 5
    Text = 6
    Focus = 7
  ImGuiInputFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Repeat = 1
    RepeatRateDefault = 2
    RepeatRateNavMove = 4
    RepeatRateNavTweak = 8
    RepeatRateMask = 14
    SupportedByIsKeyPressed = 15
    CondHovered = 16
    CondActive = 32
    CondDefault = 48
    LockThisFrame = 64
    LockUntilRelease = 128
    SupportedBySetKeyOwner = 192
    SupportedBySetItemKeyOwner = 240
    RouteFocused = 256
    RouteGlobalLow = 512
    RouteGlobal = 1024
    RouteGlobalHigh = 2048
    RouteMask = 3840
    RouteAlways = 4096
    RouteUnlessBgFocused = 8192
    RouteExtraMask = 12288
    SupportedByShortcut = 16143
  ImGuiInputSource* {.pure, size: int32.sizeof.} = enum
    None = 0
    Mouse = 1
    Keyboard = 2
    Gamepad = 3
    Clipboard = 4
  ImGuiInputTextFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    Multiline = 67108864
    NoMarkEdited = 134217728
    MergedItem = 268435456
  ImGuiInputTextFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    CharsDecimal = 1
    CharsHexadecimal = 2
    CharsUppercase = 4
    CharsNoBlank = 8
    AutoSelectAll = 16
    EnterReturnsTrue = 32
    CallbackCompletion = 64
    CallbackHistory = 128
    CallbackAlways = 256
    CallbackCharFilter = 512
    AllowTabInput = 1024
    CtrlEnterForNewLine = 2048
    NoHorizontalScroll = 4096
    AlwaysOverwrite = 8192
    ReadOnly = 16384
    Password = 32768
    NoUndoRedo = 65536
    CharsScientific = 131072
    CallbackResize = 262144
    CallbackEdit = 524288
    EscapeClearsAll = 1048576
  ImGuiItemFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoTabStop = 1
    ButtonRepeat = 2
    Disabled = 4
    NoNav = 8
    NoNavDefaultFocus = 16
    SelectableDontClosePopup = 32
    MixedValue = 64
    ReadOnly = 128
    NoWindowHoverableCheck = 256
    AllowOverlap = 512
    Inputable = 1024
  ImGuiItemStatusFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    HoveredRect = 1
    HasDisplayRect = 2
    Edited = 4
    ToggledSelection = 8
    ToggledOpen = 16
    HasDeactivated = 32
    Deactivated = 64
    HoveredWindow = 128
    FocusedByTabbing = 256
    Visible = 512
  ImGuiKey* {.pure, size: int32.sizeof.} = enum
    None = 0
    Tab = 512
    LeftArrow = 513
    RightArrow = 514
    UpArrow = 515
    DownArrow = 516
    PageUp = 517
    PageDown = 518
    Home = 519
    End = 520
    Insert = 521
    Delete = 522
    Backspace = 523
    Space = 524
    Enter = 525
    Escape = 526
    LeftCtrl = 527
    LeftShift = 528
    LeftAlt = 529
    LeftSuper = 530
    RightCtrl = 531
    RightShift = 532
    RightAlt = 533
    RightSuper = 534
    Menu = 535
    `"0"` = 536
    `"1"` = 537
    `"2"` = 538
    `"3"` = 539
    `"4"` = 540
    `"5"` = 541
    `"6"` = 542
    `"7"` = 543
    `"8"` = 544
    `"9"` = 545
    A = 546
    B = 547
    C = 548
    D = 549
    E = 550
    F = 551
    G = 552
    H = 553
    I = 554
    J = 555
    K = 556
    L = 557
    M = 558
    N = 559
    O = 560
    P = 561
    Q = 562
    R = 563
    S = 564
    T = 565
    U = 566
    V = 567
    W = 568
    X = 569
    Y = 570
    Z = 571
    F1 = 572
    F2 = 573
    F3 = 574
    F4 = 575
    F5 = 576
    F6 = 577
    F7 = 578
    F8 = 579
    F9 = 580
    F10 = 581
    F11 = 582
    F12 = 583
    Apostrophe = 584
    Comma = 585
    Minus = 586
    Period = 587
    Slash = 588
    Semicolon = 589
    Equal = 590
    LeftBracket = 591
    Backslash = 592
    RightBracket = 593
    GraveAccent = 594
    CapsLock = 595
    ScrollLock = 596
    NumLock = 597
    PrintScreen = 598
    Pause = 599
    Keypad0 = 600
    Keypad1 = 601
    Keypad2 = 602
    Keypad3 = 603
    Keypad4 = 604
    Keypad5 = 605
    Keypad6 = 606
    Keypad7 = 607
    Keypad8 = 608
    Keypad9 = 609
    KeypadDecimal = 610
    KeypadDivide = 611
    KeypadMultiply = 612
    KeypadSubtract = 613
    KeypadAdd = 614
    KeypadEnter = 615
    KeypadEqual = 616
    GamepadStart = 617
    GamepadBack = 618
    GamepadFaceLeft = 619
    GamepadFaceRight = 620
    GamepadFaceUp = 621
    GamepadFaceDown = 622
    GamepadDpadLeft = 623
    GamepadDpadRight = 624
    GamepadDpadUp = 625
    GamepadDpadDown = 626
    GamepadL1 = 627
    GamepadR1 = 628
    GamepadL2 = 629
    GamepadR2 = 630
    GamepadL3 = 631
    GamepadR3 = 632
    GamepadLStickLeft = 633
    GamepadLStickRight = 634
    GamepadLStickUp = 635
    GamepadLStickDown = 636
    GamepadRStickLeft = 637
    GamepadRStickRight = 638
    GamepadRStickUp = 639
    GamepadRStickDown = 640
    MouseLeft = 641
    MouseRight = 642
    MouseMiddle = 643
    MouseX1 = 644
    MouseX2 = 645
    MouseWheelX = 646
    MouseWheelY = 647
    ReservedForModCtrl = 648
    ReservedForModShift = 649
    ReservedForModAlt = 650
    ReservedForModSuper = 651
    NamedKey_END = 652
    Shortcut = 2048
    Ctrl = 4096
    Shift = 8192
    Alt = 16384
    Super = 32768
    Mask = 63488
  ImGuiLayoutType* {.pure, size: int32.sizeof.} = enum
    Horizontal = 0
    Vertical = 1
  ImGuiLocKey* {.pure, size: int32.sizeof.} = enum
    VersionStr = 0
    TableSizeOne = 1
    TableSizeAllFit = 2
    TableSizeAllDefault = 3
    TableResetOrder = 4
    WindowingMainMenuBar = 5
    WindowingPopup = 6
    WindowingUntitled = 7
    DockingHideTabBar = 8
    DockingHoldShiftToDock = 9
  ImGuiLogType* {.pure, size: int32.sizeof.} = enum
    None = 0
    TTY = 1
    File = 2
    Buffer = 3
    Clipboard = 4
  ImGuiMouseButton* {.pure, size: int32.sizeof.} = enum
    Left = 0
    Right = 1
    Middle = 2
  ImGuiMouseCursor* {.pure, size: int32.sizeof.} = enum
    None = -1
    Arrow = 0
    TextInput = 1
    ResizeAll = 2
    ResizeNS = 3
    ResizeEW = 4
    ResizeNESW = 5
    ResizeNWSE = 6
    Hand = 7
    NotAllowed = 8
  ImGuiMouseSource* {.pure, size: int32.sizeof.} = enum
    Mouse = 0
    TouchScreen = 1
    Pen = 2
  ImGuiNavHighlightFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    TypeDefault = 1
    TypeThin = 2
    AlwaysDraw = 4
    NoRounding = 8
  ImGuiNavInput* {.pure, size: int32.sizeof.} = enum
    Activate = 0
    Cancel = 1
    Input = 2
    Menu = 3
    DpadLeft = 4
    DpadRight = 5
    DpadUp = 6
    DpadDown = 7
    LStickLeft = 8
    LStickRight = 9
    LStickUp = 10
    LStickDown = 11
    FocusPrev = 12
    FocusNext = 13
    TweakSlow = 14
    TweakFast = 15
  ImGuiNavLayer* {.pure, size: int32.sizeof.} = enum
    Main = 0
    Menu = 1
  ImGuiNavMoveFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    LoopX = 1
    LoopY = 2
    WrapX = 4
    WrapY = 8
    WrapMask = 15
    AllowCurrentNavId = 16
    AlsoScoreVisibleSet = 32
    ScrollToEdgeY = 64
    Forwarded = 128
    DebugNoResult = 256
    FocusApi = 512
    IsTabbing = 1024
    IsPageMove = 2048
    Activate = 4096
    NoSelect = 8192
    NoSetNavHighlight = 16384
  ImGuiNextItemDataFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    HasWidth = 1
    HasOpen = 2
  ImGuiNextWindowDataFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    HasPos = 1
    HasSize = 2
    HasContentSize = 4
    HasCollapsed = 8
    HasSizeConstraint = 16
    HasFocus = 32
    HasBgAlpha = 64
    HasScroll = 128
    HasViewport = 256
    HasDock = 512
    HasWindowClass = 1024
  ImGuiOldColumnFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoBorder = 1
    NoResize = 2
    NoPreserveWidths = 4
    NoForceWithinWindow = 8
    GrowParentContentsSize = 16
  ImGuiPlotType* {.pure, size: int32.sizeof.} = enum
    Lines = 0
    Histogram = 1
  ImGuiPopupFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    MouseButtonRight = 1
    MouseButtonMiddle = 2
    MouseButtonMask = 31
    NoOpenOverExistingPopup = 32
    NoOpenOverItems = 64
    AnyPopupId = 128
    AnyPopupLevel = 256
    AnyPopup = 384
  ImGuiPopupPositionPolicy* {.pure, size: int32.sizeof.} = enum
    Default = 0
    ComboBox = 1
    Tooltip = 2
  ImGuiScrollFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    KeepVisibleEdgeX = 1
    KeepVisibleEdgeY = 2
    KeepVisibleCenterX = 4
    KeepVisibleCenterY = 8
    AlwaysCenterX = 16
    MaskX = 21
    AlwaysCenterY = 32
    MaskY = 42
    NoScrollParent = 64
  ImGuiSelectableFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    NoHoldingActiveID = 1048576
    SelectOnNav = 2097152
    SelectOnClick = 4194304
    SelectOnRelease = 8388608
    SpanAvailWidth = 16777216
    SetNavIdOnHover = 33554432
    NoPadWithHalfSpacing = 67108864
    NoSetKeyOwner = 134217728
  ImGuiSelectableFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    DontClosePopups = 1
    SpanAllColumns = 2
    AllowDoubleClick = 4
    Disabled = 8
    AllowOverlap = 16
  ImGuiSeparatorFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Horizontal = 1
    Vertical = 2
    SpanAllColumns = 4
  ImGuiSliderFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    Vertical = 1048576
    ReadOnly = 2097152
  ImGuiSliderFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    AlwaysClamp = 16
    Logarithmic = 32
    NoRoundToFormat = 64
    NoInput = 128
    InvalidMask = 1879048207
  ImGuiSortDirection* {.pure, size: int32.sizeof.} = enum
    None = 0
    Ascending = 1
    Descending = 2
  ImGuiStyleVar* {.pure, size: int32.sizeof.} = enum
    Alpha = 0
    DisabledAlpha = 1
    WindowPadding = 2
    WindowRounding = 3
    WindowBorderSize = 4
    WindowMinSize = 5
    WindowTitleAlign = 6
    ChildRounding = 7
    ChildBorderSize = 8
    PopupRounding = 9
    PopupBorderSize = 10
    FramePadding = 11
    FrameRounding = 12
    FrameBorderSize = 13
    ItemSpacing = 14
    ItemInnerSpacing = 15
    IndentSpacing = 16
    CellPadding = 17
    ScrollbarSize = 18
    ScrollbarRounding = 19
    GrabMinSize = 20
    GrabRounding = 21
    TabRounding = 22
    ButtonTextAlign = 23
    SelectableTextAlign = 24
    SeparatorTextBorderSize = 25
    SeparatorTextAlign = 26
    SeparatorTextPadding = 27
    DockingSeparatorSize = 28
  ImGuiTabBarFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    DockNode = 1048576
    IsFocused = 2097152
    SaveSettings = 4194304
  ImGuiTabBarFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Reorderable = 1
    AutoSelectNewTabs = 2
    TabListPopupButton = 4
    NoCloseWithMiddleMouseButton = 8
    NoTabListScrollingButtons = 16
    NoTooltip = 32
    FittingPolicyResizeDown = 64
    FittingPolicyScroll = 128
    FittingPolicyMask = 192
  ImGuiTabItemFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    SectionMask = 192
    NoCloseButton = 1048576
    Button = 2097152
    Unsorted = 4194304
    Preview = 8388608
  ImGuiTabItemFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    UnsavedDocument = 1
    SetSelected = 2
    NoCloseWithMiddleMouseButton = 4
    NoPushId = 8
    NoTooltip = 16
    NoReorder = 32
    Leading = 64
    Trailing = 128
  ImGuiTableBgTarget* {.pure, size: int32.sizeof.} = enum
    None = 0
    RowBg0 = 1
    RowBg1 = 2
    CellBg = 3
  ImGuiTableColumnFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Disabled = 1
    DefaultHide = 2
    DefaultSort = 4
    WidthStretch = 8
    WidthFixed = 16
    WidthMask = 24
    NoResize = 32
    NoReorder = 64
    NoHide = 128
    NoClip = 256
    NoSort = 512
    NoSortAscending = 1024
    NoSortDescending = 2048
    NoHeaderLabel = 4096
    NoHeaderWidth = 8192
    PreferSortAscending = 16384
    PreferSortDescending = 32768
    IndentEnable = 65536
    IndentDisable = 131072
    IndentMask = 196608
    IsEnabled = 16777216
    IsVisible = 33554432
    IsSorted = 67108864
    IsHovered = 134217728
    StatusMask = 251658240
    NoDirectResize = 1073741824
  ImGuiTableFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Resizable = 1
    Reorderable = 2
    Hideable = 4
    Sortable = 8
    NoSavedSettings = 16
    ContextMenuInBody = 32
    RowBg = 64
    BordersInnerH = 128
    BordersOuterH = 256
    BordersH = 384
    BordersInnerV = 512
    BordersInner = 640
    BordersOuterV = 1024
    BordersOuter = 1280
    BordersV = 1536
    Borders = 1920
    NoBordersInBody = 2048
    NoBordersInBodyUntilResize = 4096
    SizingFixedFit = 8192
    SizingFixedSame = 16384
    SizingStretchProp = 24576
    SizingStretchSame = 32768
    SizingMask = 57344
    NoHostExtendX = 65536
    NoHostExtendY = 131072
    NoKeepColumnsVisible = 262144
    PreciseWidths = 524288
    NoClip = 1048576
    PadOuterX = 2097152
    NoPadOuterX = 4194304
    NoPadInnerX = 8388608
    ScrollX = 16777216
    ScrollY = 33554432
    SortMulti = 67108864
    SortTristate = 134217728
  ImGuiTableRowFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Headers = 1
  ImGuiTextFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoWidthForLargeClippedText = 1
  ImGuiTooltipFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    OverridePrevious = 2
  ImGuiTreeNodeFlagsPrivate* {.pure, size: int32.sizeof.} = enum
    ClipLabelForTrailingButton = 1048576
    UpsideDownArrow = 2097152
  ImGuiTreeNodeFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    Selected = 1
    Framed = 2
    AllowOverlap = 4
    NoTreePushOnOpen = 8
    NoAutoOpenOnLog = 16
    CollapsingHeader = 26
    DefaultOpen = 32
    OpenOnDoubleClick = 64
    OpenOnArrow = 128
    Leaf = 256
    Bullet = 512
    FramePadding = 1024
    SpanAvailWidth = 2048
    SpanFullWidth = 4096
    NavLeftJumpsBackHere = 8192
  ImGuiViewportFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    IsPlatformWindow = 1
    IsPlatformMonitor = 2
    OwnedByApp = 4
    NoDecoration = 8
    NoTaskBarIcon = 16
    NoFocusOnAppearing = 32
    NoFocusOnClick = 64
    NoInputs = 128
    NoRendererClear = 256
    NoAutoMerge = 512
    TopMost = 1024
    CanHostOtherWindows = 2048
    IsMinimized = 4096
    IsFocused = 8192
  ImGuiWindowDockStyleCol* {.pure, size: int32.sizeof.} = enum
    Text = 0
    Tab = 1
    TabHovered = 2
    TabActive = 3
    TabUnfocused = 4
    TabUnfocusedActive = 5
  ImGuiWindowFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoTitleBar = 1
    NoResize = 2
    NoMove = 4
    NoScrollbar = 8
    NoScrollWithMouse = 16
    NoCollapse = 32
    NoDecoration = 43
    AlwaysAutoResize = 64
    NoBackground = 128
    NoSavedSettings = 256
    NoMouseInputs = 512
    MenuBar = 1024
    HorizontalScrollbar = 2048
    NoFocusOnAppearing = 4096
    NoBringToFrontOnFocus = 8192
    AlwaysVerticalScrollbar = 16384
    AlwaysHorizontalScrollbar = 32768
    AlwaysUseWindowPadding = 65536
    NoNavInputs = 262144
    NoNavFocus = 524288
    NoNav = 786432
    NoInputs = 786944
    UnsavedDocument = 1048576
    NoDocking = 2097152
    NavFlattened = 8388608
    ChildWindow = 16777216
    Tooltip = 33554432
    Popup = 67108864
    Modal = 134217728
    ChildMenu = 268435456
    DockNodeHost = 536870912

# Duplicate enums as consts
const ImGuiKey_None* = 0
const ImGuiTabBarFlags_FittingPolicyDefault* = 64
const ImGuiKey_KeysData_OFFSET* = 0
const ImDrawFlags_RoundCornersDefault* = 240
const ImGuiButtonFlags_MouseButtonDefault* = 1
const ImGuiKey_KeysData_SIZE* = 652
const ImGuiPopupFlags_MouseButtonLeft* = 0
const ImGuiPopupFlags_MouseButtonDefault* = 1
const ImGuiButtonFlagsPrivate_PressedOnDefault* = 32
const ImGuiInputFlags_CondMask* = 48
const ImGuiKey_NamedKey_BEGIN* = 512

# TypeDefs
type
  ImBitArrayPtr* = ptr uint32
  ImDrawCallback* = proc(parent_list: ptr ImDrawList, cmd: ptr ImDrawCmd): void {.cdecl, varargs.}
  ImFileHandle* = ptr FILE
  ImGuiContextHookCallback* = proc(ctx: ptr ImGuiContext, hook: ptr ImGuiContextHook): void {.cdecl, varargs.}
  ImGuiErrorLogCallback* = proc(user_data: pointer, fmt: cstring): void {.cdecl.}
  ImGuiID* = uint32
  ImGuiInputTextCallback* = proc(data: ptr ImGuiInputTextCallbackData): int32 {.cdecl, varargs.}
  ImGuiKeyChord* = int32
  ImGuiKeyRoutingIndex* = int16
  ImGuiMemAllocFunc* = proc(sz: uint, user_data: pointer): pointer {.cdecl, varargs.}
  ImGuiMemFreeFunc* = proc(`ptr`: pointer, user_data: pointer): void {.cdecl, varargs.}
  ImGuiSizeCallback* = proc(data: ptr ImGuiSizeCallbackData): void {.cdecl, varargs.}
  ImGuiTableColumnIdx* = int16
  ImGuiTableDrawChannelIdx* = uint16
  ImPoolIdx* = int32
  ImTextureID* = pointer
  ImWchar* = ImWchar16
  ImWchar16* = uint16
  ImWchar32* = uint32

  ImVector*[T] = object # Should I importc a generic?
    size* {.importc: "Size".}: int32
    capacity* {.importc: "Capacity".}: int32
    data* {.importc: "Data".}: ptr UncheckedArray[T]
  ImGuiStyleModBackup* {.union.} = object
    backup_int* {.importc: "BackupInt".}: int32 # Breaking naming convetion to denote "low level"
    backup_float* {.importc: "BackupFloat".}: float32
  ImGuiStyleMod* {.importc: "ImGuiStyleMod", imgui_header.} = object
    varIdx* {.importc: "VarIdx".}: ImGuiStyleVar
    backup*: ImGuiStyleModBackup
  ImGuiStoragePairData* {.union.} = object
    val_i* {.importc: "val_i".}: int32 # Breaking naming convetion to denote "low level"
    val_f* {.importc: "val_f".}: float32
    val_p* {.importc: "val_p".}: pointer
  ImGuiStoragePair* {.importc: "ImGuiStoragePair", imgui_header.} = object
    key* {.importc: "key".}: ImGuiID
    data*: ImGuiStoragePairData
  ImPairData* {.union.} = object
    val_i* {.importc: "val_i".}: int32 # Breaking naming convetion to denote "low level"
    val_f* {.importc: "val_f".}: float32
    val_p* {.importc: "val_p".}: pointer
  ImPair* {.importc: "Pair", imgui_header.} = object
    key* {.importc: "key".}: ImGuiID
    data*: ImPairData
  ImGuiInputEventData* {.union.} = object
    mousePos*: ImGuiInputEventMousePos
    mouseWheel*: ImGuiInputEventMouseWheel
    mouseButton*: ImGuiInputEventMouseButton
    key*: ImGuiInputEventKey
    text*: ImGuiInputEventText
    appFocused*: ImGuiInputEventAppFocused
  ImGuiInputEvent* {.importc: "ImGuiInputEvent", imgui_header.} = object
    `type`* {.importc: "`type`".}: ImGuiInputEventType
    source* {.importc: "Source".}: ImGuiInputSource
    data*: ImGuiInputEventData
    addedByTestEngine* {.importc: "AddedByTestEngine".}: bool

  # Undefined data types in cimgui

  ImDrawListPtr* = object
  ImChunkStream* = ptr object
  ImPool* = object
  ImSpanAllocator* = object # A little lost here. It is referenced in imgui_internal.h
  ImSpan* = object # ^^
  ImVectorImGuiColumns* {.importc: "ImVector_ImGuiColumns".} = object

  #
  ImBitVector* {.importc: "ImBitVector", imgui_header.} = object
    storage* {.importc: "Storage".}: ImVector[uint32]
  ImColor* {.importc: "ImColor", imgui_header.} = object
    value* {.importc: "Value".}: ImVec4
  ImDrawChannel* {.importc: "ImDrawChannel", imgui_header.} = ptr object
  ImDrawCmd* {.importc: "ImDrawCmd", imgui_header.} = object
    clipRect* {.importc: "ClipRect".}: ImVec4
    textureId* {.importc: "TextureId".}: ImTextureID
    vtxOffset* {.importc: "VtxOffset".}: uint32
    idxOffset* {.importc: "IdxOffset".}: uint32
    elemCount* {.importc: "ElemCount".}: uint32
    userCallback* {.importc: "UserCallback".}: ImDrawCallback
    userCallbackData* {.importc: "UserCallbackData".}: pointer
  ImDrawCmdHeader* {.importc: "ImDrawCmdHeader", imgui_header.} = object
    clipRect* {.importc: "ClipRect".}: ImVec4
    textureId* {.importc: "TextureId".}: ImTextureID
    vtxOffset* {.importc: "VtxOffset".}: uint32
  ImDrawData* {.importc: "ImDrawData", imgui_header.} = object
    valid* {.importc: "Valid".}: bool
    cmdListsCount* {.importc: "CmdListsCount".}: int32
    totalIdxCount* {.importc: "TotalIdxCount".}: int32
    totalVtxCount* {.importc: "TotalVtxCount".}: int32
    cmdLists* {.importc: "CmdLists".}: ImVector[ptr ImDrawList]
    displayPos* {.importc: "DisplayPos".}: ImVec2
    displaySize* {.importc: "DisplaySize".}: ImVec2
    framebufferScale* {.importc: "FramebufferScale".}: ImVec2
    ownerViewport* {.importc: "OwnerViewport".}: ptr ImGuiViewport
  ImDrawDataBuilder* {.importc: "ImDrawDataBuilder", imgui_header.} = object
    layers* {.importc: "Layers".}: array[2, ptr ImVector[ImDrawListPtr]]
    layerData1* {.importc: "LayerData1".}: ImVector[ptr ImDrawList]
  ImDrawList* {.importc: "ImDrawList", imgui_header.} = object
    cmdBuffer* {.importc: "CmdBuffer".}: ImVector[ImDrawCmd]
    idxBuffer* {.importc: "IdxBuffer".}: ImVector[ImDrawIdx]
    vtxBuffer* {.importc: "VtxBuffer".}: ImVector[ImDrawVert]
    flags* {.importc: "Flags".}: ImDrawListFlags
    vtxCurrentIdx* {.importc: "_VtxCurrentIdx".}: uint32
    data* {.importc: "_Data".}: ptr ImDrawListSharedData
    ownerName* {.importc: "_OwnerName".}: cstring
    vtxWritePtr* {.importc: "_VtxWritePtr".}: ptr ImDrawVert
    idxWritePtr* {.importc: "_IdxWritePtr".}: ptr ImDrawIdx
    clipRectStack* {.importc: "_ClipRectStack".}: ImVector[ImVec4]
    textureIdStack* {.importc: "_TextureIdStack".}: ImVector[ImTextureID]
    path* {.importc: "_Path".}: ImVector[ImVec2]
    cmdHeader* {.importc: "_CmdHeader".}: ImDrawCmdHeader
    splitter* {.importc: "_Splitter".}: ImDrawListSplitter
    fringeScale* {.importc: "_FringeScale".}: float32
  ImDrawListSharedData* {.importc: "ImDrawListSharedData", imgui_header.} = object
    texUvWhitePixel* {.importc: "TexUvWhitePixel".}: ImVec2
    font* {.importc: "Font".}: ptr ImFont
    fontSize* {.importc: "FontSize".}: float32
    curveTessellationTol* {.importc: "CurveTessellationTol".}: float32
    circleSegmentMaxError* {.importc: "CircleSegmentMaxError".}: float32
    clipRectFullscreen* {.importc: "ClipRectFullscreen".}: ImVec4
    initialFlags* {.importc: "InitialFlags".}: ImDrawListFlags
    tempBuffer* {.importc: "TempBuffer".}: ImVector[ImVec2]
    arcFastVtx* {.importc: "ArcFastVtx".}: array[48, ImVec2]
    arcFastRadiusCutoff* {.importc: "ArcFastRadiusCutoff".}: float32
    circleSegmentCounts* {.importc: "CircleSegmentCounts".}: array[64, uint8]
    texUvLines* {.importc: "TexUvLines".}: ptr ImVec4
  ImDrawListSplitter* {.importc: "ImDrawListSplitter", imgui_header.} = object
    current* {.importc: "_Current".}: int32
    count* {.importc: "_Count".}: int32
    channels* {.importc: "_Channels".}: ImVector[ImDrawChannel]
  ImDrawVert* {.importc: "ImDrawVert", imgui_header.} = object
    pos* {.importc: "pos".}: ImVec2
    uv* {.importc: "uv".}: ImVec2
    col* {.importc: "col".}: uint32
  ImFont* {.importc: "ImFont", imgui_header.} = object
    indexAdvanceX* {.importc: "IndexAdvanceX".}: ImVector[float32]
    fallbackAdvanceX* {.importc: "FallbackAdvanceX".}: float32
    fontSize* {.importc: "FontSize".}: float32
    indexLookup* {.importc: "IndexLookup".}: ImVector[ImWchar]
    glyphs* {.importc: "Glyphs".}: ImVector[ImFontGlyph]
    fallbackGlyph* {.importc: "FallbackGlyph".}: ptr ImFontGlyph
    containerAtlas* {.importc: "ContainerAtlas".}: ptr ImFontAtlas
    configData* {.importc: "ConfigData".}: ptr ImFontConfig
    configDataCount* {.importc: "ConfigDataCount".}: int16
    fallbackChar* {.importc: "FallbackChar".}: ImWchar
    ellipsisChar* {.importc: "EllipsisChar".}: ImWchar
    ellipsisCharCount* {.importc: "EllipsisCharCount".}: int16
    ellipsisWidth* {.importc: "EllipsisWidth".}: float32
    ellipsisCharStep* {.importc: "EllipsisCharStep".}: float32
    dirtyLookupTables* {.importc: "DirtyLookupTables".}: bool
    scale* {.importc: "Scale".}: float32
    ascent* {.importc: "Ascent".}: float32
    descent* {.importc: "Descent".}: float32
    metricsTotalSurface* {.importc: "MetricsTotalSurface".}: int32
    used4kPagesMap* {.importc: "Used4kPagesMap".}: array[2, uint8]
  ImFontAtlas* {.importc: "ImFontAtlas", imgui_header.} = object
    flags* {.importc: "Flags".}: ImFontAtlasFlags
    texID* {.importc: "TexID".}: ImTextureID
    texDesiredWidth* {.importc: "TexDesiredWidth".}: int32
    texGlyphPadding* {.importc: "TexGlyphPadding".}: int32
    locked* {.importc: "Locked".}: bool
    userData* {.importc: "UserData".}: pointer
    texReady* {.importc: "TexReady".}: bool
    texPixelsUseColors* {.importc: "TexPixelsUseColors".}: bool
    texPixelsAlpha8* {.importc: "TexPixelsAlpha8".}: ptr uint8
    texPixelsRGBA32* {.importc: "TexPixelsRGBA32".}: ptr uint32
    texWidth* {.importc: "TexWidth".}: int32
    texHeight* {.importc: "TexHeight".}: int32
    texUvScale* {.importc: "TexUvScale".}: ImVec2
    texUvWhitePixel* {.importc: "TexUvWhitePixel".}: ImVec2
    fonts* {.importc: "Fonts".}: ImVector[ptr ImFont]
    customRects* {.importc: "CustomRects".}: ImVector[ImFontAtlasCustomRect]
    configData* {.importc: "ConfigData".}: ImVector[ImFontConfig]
    texUvLines* {.importc: "TexUvLines".}: array[(63)+1, ImVec4]
    fontBuilderIO* {.importc: "FontBuilderIO".}: ptr ImFontBuilderIO
    fontBuilderFlags* {.importc: "FontBuilderFlags".}: uint32
    packIdMouseCursors* {.importc: "PackIdMouseCursors".}: int32
    packIdLines* {.importc: "PackIdLines".}: int32
  ImFontAtlasCustomRect* {.importc: "ImFontAtlasCustomRect", imgui_header.} = object
    width* {.importc: "Width".}: uint16
    height* {.importc: "Height".}: uint16
    x* {.importc: "X".}: uint16
    y* {.importc: "Y".}: uint16
    glyphID* {.importc: "GlyphID".}: uint32
    glyphAdvanceX* {.importc: "GlyphAdvanceX".}: float32
    glyphOffset* {.importc: "GlyphOffset".}: ImVec2
    font* {.importc: "Font".}: ptr ImFont
  ImFontBuilderIO* {.importc: "ImFontBuilderIO", imgui_header.} = object
    fontBuilder_Build* {.importc: "FontBuilder_Build".}: proc(atlas: ptr ImFontAtlas): bool {.cdecl, varargs.}
  ImFontConfig* {.importc: "ImFontConfig", imgui_header.} = object
    fontData* {.importc: "FontData".}: pointer
    fontDataSize* {.importc: "FontDataSize".}: int32
    fontDataOwnedByAtlas* {.importc: "FontDataOwnedByAtlas".}: bool
    fontNo* {.importc: "FontNo".}: int32
    sizePixels* {.importc: "SizePixels".}: float32
    oversampleH* {.importc: "OversampleH".}: int32
    oversampleV* {.importc: "OversampleV".}: int32
    pixelSnapH* {.importc: "PixelSnapH".}: bool
    glyphExtraSpacing* {.importc: "GlyphExtraSpacing".}: ImVec2
    glyphOffset* {.importc: "GlyphOffset".}: ImVec2
    glyphRanges* {.importc: "GlyphRanges".}: ptr ImWchar
    glyphMinAdvanceX* {.importc: "GlyphMinAdvanceX".}: float32
    glyphMaxAdvanceX* {.importc: "GlyphMaxAdvanceX".}: float32
    mergeMode* {.importc: "MergeMode".}: bool
    fontBuilderFlags* {.importc: "FontBuilderFlags".}: uint32
    rasterizerMultiply* {.importc: "RasterizerMultiply".}: float32
    ellipsisChar* {.importc: "EllipsisChar".}: ImWchar
    name* {.importc: "Name".}: array[40, int8]
    dstFont* {.importc: "DstFont".}: ptr ImFont
  ImFontGlyph* {.importc: "ImFontGlyph", imgui_header.} = object
    colored* {.importc: "Colored".}: uint32
    visible* {.importc: "Visible".}: uint32
    codepoint* {.importc: "Codepoint".}: uint32
    advanceX* {.importc: "AdvanceX".}: float32
    x0* {.importc: "X0".}: float32
    y0* {.importc: "Y0".}: float32
    x1* {.importc: "X1".}: float32
    y1* {.importc: "Y1".}: float32
    u0* {.importc: "U0".}: float32
    v0* {.importc: "V0".}: float32
    u1* {.importc: "U1".}: float32
    v1* {.importc: "V1".}: float32
  ImFontGlyphRangesBuilder* {.importc: "ImFontGlyphRangesBuilder", imgui_header.} = object
    usedChars* {.importc: "UsedChars".}: ImVector[uint32]
  ImGuiColorMod* {.importc: "ImGuiColorMod", imgui_header.} = object
    col* {.importc: "Col".}: ImGuiCol
    backupValue* {.importc: "BackupValue".}: ImVec4
  ImGuiComboPreviewData* {.importc: "ImGuiComboPreviewData", imgui_header.} = object
    previewRect* {.importc: "PreviewRect".}: ImRect
    backupCursorPos* {.importc: "BackupCursorPos".}: ImVec2
    backupCursorMaxPos* {.importc: "BackupCursorMaxPos".}: ImVec2
    backupCursorPosPrevLine* {.importc: "BackupCursorPosPrevLine".}: ImVec2
    backupPrevLineTextBaseOffset* {.importc: "BackupPrevLineTextBaseOffset".}: float32
    backupLayout* {.importc: "BackupLayout".}: ImGuiLayoutType
  ImGuiContext* {.importc: "ImGuiContext", imgui_header.} = object
    initialized* {.importc: "Initialized".}: bool
    fontAtlasOwnedByContext* {.importc: "FontAtlasOwnedByContext".}: bool
    io* {.importc: "IO".}: ImGuiIO
    platformIO* {.importc: "PlatformIO".}: ImGuiPlatformIO
    style* {.importc: "Style".}: ImGuiStyle
    configFlagsCurrFrame* {.importc: "ConfigFlagsCurrFrame".}: ImGuiConfigFlags
    configFlagsLastFrame* {.importc: "ConfigFlagsLastFrame".}: ImGuiConfigFlags
    font* {.importc: "Font".}: ptr ImFont
    fontSize* {.importc: "FontSize".}: float32
    fontBaseSize* {.importc: "FontBaseSize".}: float32
    drawListSharedData* {.importc: "DrawListSharedData".}: ImDrawListSharedData
    time* {.importc: "Time".}: float64
    frameCount* {.importc: "FrameCount".}: int32
    frameCountEnded* {.importc: "FrameCountEnded".}: int32
    frameCountPlatformEnded* {.importc: "FrameCountPlatformEnded".}: int32
    frameCountRendered* {.importc: "FrameCountRendered".}: int32
    withinFrameScope* {.importc: "WithinFrameScope".}: bool
    withinFrameScopeWithImplicitWindow* {.importc: "WithinFrameScopeWithImplicitWindow".}: bool
    withinEndChild* {.importc: "WithinEndChild".}: bool
    gcCompactAll* {.importc: "GcCompactAll".}: bool
    testEngineHookItems* {.importc: "TestEngineHookItems".}: bool
    testEngine* {.importc: "TestEngine".}: pointer
    inputEventsQueue* {.importc: "InputEventsQueue".}: ImVector[ImGuiInputEvent]
    inputEventsTrail* {.importc: "InputEventsTrail".}: ImVector[ImGuiInputEvent]
    inputEventsNextMouseSource* {.importc: "InputEventsNextMouseSource".}: ImGuiMouseSource
    inputEventsNextEventId* {.importc: "InputEventsNextEventId".}: uint32
    windows* {.importc: "Windows".}: ImVector[ptr ImGuiWindow]
    windowsFocusOrder* {.importc: "WindowsFocusOrder".}: ImVector[ptr ImGuiWindow]
    windowsTempSortBuffer* {.importc: "WindowsTempSortBuffer".}: ImVector[ptr ImGuiWindow]
    currentWindowStack* {.importc: "CurrentWindowStack".}: ImVector[ImGuiWindowStackData]
    windowsById* {.importc: "WindowsById".}: ImGuiStorage
    windowsActiveCount* {.importc: "WindowsActiveCount".}: int32
    windowsHoverPadding* {.importc: "WindowsHoverPadding".}: ImVec2
    currentWindow* {.importc: "CurrentWindow".}: ptr ImGuiWindow
    hoveredWindow* {.importc: "HoveredWindow".}: ptr ImGuiWindow
    hoveredWindowUnderMovingWindow* {.importc: "HoveredWindowUnderMovingWindow".}: ptr ImGuiWindow
    movingWindow* {.importc: "MovingWindow".}: ptr ImGuiWindow
    wheelingWindow* {.importc: "WheelingWindow".}: ptr ImGuiWindow
    wheelingWindowRefMousePos* {.importc: "WheelingWindowRefMousePos".}: ImVec2
    wheelingWindowStartFrame* {.importc: "WheelingWindowStartFrame".}: int32
    wheelingWindowReleaseTimer* {.importc: "WheelingWindowReleaseTimer".}: float32
    wheelingWindowWheelRemainder* {.importc: "WheelingWindowWheelRemainder".}: ImVec2
    wheelingAxisAvg* {.importc: "WheelingAxisAvg".}: ImVec2
    debugHookIdInfo* {.importc: "DebugHookIdInfo".}: ImGuiID
    hoveredId* {.importc: "HoveredId".}: ImGuiID
    hoveredIdPreviousFrame* {.importc: "HoveredIdPreviousFrame".}: ImGuiID
    hoveredIdAllowOverlap* {.importc: "HoveredIdAllowOverlap".}: bool
    hoveredIdDisabled* {.importc: "HoveredIdDisabled".}: bool
    hoveredIdTimer* {.importc: "HoveredIdTimer".}: float32
    hoveredIdNotActiveTimer* {.importc: "HoveredIdNotActiveTimer".}: float32
    activeId* {.importc: "ActiveId".}: ImGuiID
    activeIdIsAlive* {.importc: "ActiveIdIsAlive".}: ImGuiID
    activeIdTimer* {.importc: "ActiveIdTimer".}: float32
    activeIdIsJustActivated* {.importc: "ActiveIdIsJustActivated".}: bool
    activeIdAllowOverlap* {.importc: "ActiveIdAllowOverlap".}: bool
    activeIdNoClearOnFocusLoss* {.importc: "ActiveIdNoClearOnFocusLoss".}: bool
    activeIdHasBeenPressedBefore* {.importc: "ActiveIdHasBeenPressedBefore".}: bool
    activeIdHasBeenEditedBefore* {.importc: "ActiveIdHasBeenEditedBefore".}: bool
    activeIdHasBeenEditedThisFrame* {.importc: "ActiveIdHasBeenEditedThisFrame".}: bool
    activeIdClickOffset* {.importc: "ActiveIdClickOffset".}: ImVec2
    activeIdWindow* {.importc: "ActiveIdWindow".}: ptr ImGuiWindow
    activeIdSource* {.importc: "ActiveIdSource".}: ImGuiInputSource
    activeIdMouseButton* {.importc: "ActiveIdMouseButton".}: int32
    activeIdPreviousFrame* {.importc: "ActiveIdPreviousFrame".}: ImGuiID
    activeIdPreviousFrameIsAlive* {.importc: "ActiveIdPreviousFrameIsAlive".}: bool
    activeIdPreviousFrameHasBeenEditedBefore* {.importc: "ActiveIdPreviousFrameHasBeenEditedBefore".}: bool
    activeIdPreviousFrameWindow* {.importc: "ActiveIdPreviousFrameWindow".}: ptr ImGuiWindow
    lastActiveId* {.importc: "LastActiveId".}: ImGuiID
    lastActiveIdTimer* {.importc: "LastActiveIdTimer".}: float32
    keysOwnerData* {.importc: "KeysOwnerData".}: array[140, ImGuiKeyOwnerData]
    keysRoutingTable* {.importc: "KeysRoutingTable".}: ImGuiKeyRoutingTable
    activeIdUsingNavDirMask* {.importc: "ActiveIdUsingNavDirMask".}: uint32
    activeIdUsingAllKeyboardKeys* {.importc: "ActiveIdUsingAllKeyboardKeys".}: bool
    activeIdUsingNavInputMask* {.importc: "ActiveIdUsingNavInputMask".}: uint32
    currentFocusScopeId* {.importc: "CurrentFocusScopeId".}: ImGuiID
    currentItemFlags* {.importc: "CurrentItemFlags".}: ImGuiItemFlags
    debugLocateId* {.importc: "DebugLocateId".}: ImGuiID
    nextItemData* {.importc: "NextItemData".}: ImGuiNextItemData
    lastItemData* {.importc: "LastItemData".}: ImGuiLastItemData
    nextWindowData* {.importc: "NextWindowData".}: ImGuiNextWindowData
    colorStack* {.importc: "ColorStack".}: ImVector[ImGuiColorMod]
    styleVarStack* {.importc: "StyleVarStack".}: ImVector[ImGuiStyleMod]
    fontStack* {.importc: "FontStack".}: ImVector[ptr ImFont]
    focusScopeStack* {.importc: "FocusScopeStack".}: ImVector[ImGuiID]
    itemFlagsStack* {.importc: "ItemFlagsStack".}: ImVector[ImGuiItemFlags]
    groupStack* {.importc: "GroupStack".}: ImVector[ImGuiGroupData]
    openPopupStack* {.importc: "OpenPopupStack".}: ImVector[ImGuiPopupData]
    beginPopupStack* {.importc: "BeginPopupStack".}: ImVector[ImGuiPopupData]
    navTreeNodeStack* {.importc: "NavTreeNodeStack".}: ImVector[ImGuiNavTreeNodeData]
    beginMenuCount* {.importc: "BeginMenuCount".}: int32
    viewports* {.importc: "Viewports".}: ImVector[ptr ImGuiViewportP]
    currentDpiScale* {.importc: "CurrentDpiScale".}: float32
    currentViewport* {.importc: "CurrentViewport".}: ptr ImGuiViewportP
    mouseViewport* {.importc: "MouseViewport".}: ptr ImGuiViewportP
    mouseLastHoveredViewport* {.importc: "MouseLastHoveredViewport".}: ptr ImGuiViewportP
    platformLastFocusedViewportId* {.importc: "PlatformLastFocusedViewportId".}: ImGuiID
    fallbackMonitor* {.importc: "FallbackMonitor".}: ImGuiPlatformMonitor
    viewportCreatedCount* {.importc: "ViewportCreatedCount".}: int32
    platformWindowsCreatedCount* {.importc: "PlatformWindowsCreatedCount".}: int32
    viewportFocusedStampCount* {.importc: "ViewportFocusedStampCount".}: int32
    navWindow* {.importc: "NavWindow".}: ptr ImGuiWindow
    navId* {.importc: "NavId".}: ImGuiID
    navFocusScopeId* {.importc: "NavFocusScopeId".}: ImGuiID
    navActivateId* {.importc: "NavActivateId".}: ImGuiID
    navActivateDownId* {.importc: "NavActivateDownId".}: ImGuiID
    navActivatePressedId* {.importc: "NavActivatePressedId".}: ImGuiID
    navActivateFlags* {.importc: "NavActivateFlags".}: ImGuiActivateFlags
    navJustMovedToId* {.importc: "NavJustMovedToId".}: ImGuiID
    navJustMovedToFocusScopeId* {.importc: "NavJustMovedToFocusScopeId".}: ImGuiID
    navJustMovedToKeyMods* {.importc: "NavJustMovedToKeyMods".}: ImGuiKeyChord
    navNextActivateId* {.importc: "NavNextActivateId".}: ImGuiID
    navNextActivateFlags* {.importc: "NavNextActivateFlags".}: ImGuiActivateFlags
    navInputSource* {.importc: "NavInputSource".}: ImGuiInputSource
    navLayer* {.importc: "NavLayer".}: ImGuiNavLayer
    navIdIsAlive* {.importc: "NavIdIsAlive".}: bool
    navMousePosDirty* {.importc: "NavMousePosDirty".}: bool
    navDisableHighlight* {.importc: "NavDisableHighlight".}: bool
    navDisableMouseHover* {.importc: "NavDisableMouseHover".}: bool
    navAnyRequest* {.importc: "NavAnyRequest".}: bool
    navInitRequest* {.importc: "NavInitRequest".}: bool
    navInitRequestFromMove* {.importc: "NavInitRequestFromMove".}: bool
    navInitResult* {.importc: "NavInitResult".}: ImGuiNavItemData
    navMoveSubmitted* {.importc: "NavMoveSubmitted".}: bool
    navMoveScoringItems* {.importc: "NavMoveScoringItems".}: bool
    navMoveForwardToNextFrame* {.importc: "NavMoveForwardToNextFrame".}: bool
    navMoveFlags* {.importc: "NavMoveFlags".}: ImGuiNavMoveFlags
    navMoveScrollFlags* {.importc: "NavMoveScrollFlags".}: ImGuiScrollFlags
    navMoveKeyMods* {.importc: "NavMoveKeyMods".}: ImGuiKeyChord
    navMoveDir* {.importc: "NavMoveDir".}: ImGuiDir
    navMoveDirForDebug* {.importc: "NavMoveDirForDebug".}: ImGuiDir
    navMoveClipDir* {.importc: "NavMoveClipDir".}: ImGuiDir
    navScoringRect* {.importc: "NavScoringRect".}: ImRect
    navScoringNoClipRect* {.importc: "NavScoringNoClipRect".}: ImRect
    navScoringDebugCount* {.importc: "NavScoringDebugCount".}: int32
    navTabbingDir* {.importc: "NavTabbingDir".}: int32
    navTabbingCounter* {.importc: "NavTabbingCounter".}: int32
    navMoveResultLocal* {.importc: "NavMoveResultLocal".}: ImGuiNavItemData
    navMoveResultLocalVisible* {.importc: "NavMoveResultLocalVisible".}: ImGuiNavItemData
    navMoveResultOther* {.importc: "NavMoveResultOther".}: ImGuiNavItemData
    navTabbingResultFirst* {.importc: "NavTabbingResultFirst".}: ImGuiNavItemData
    configNavWindowingKeyNext* {.importc: "ConfigNavWindowingKeyNext".}: ImGuiKeyChord
    configNavWindowingKeyPrev* {.importc: "ConfigNavWindowingKeyPrev".}: ImGuiKeyChord
    navWindowingTarget* {.importc: "NavWindowingTarget".}: ptr ImGuiWindow
    navWindowingTargetAnim* {.importc: "NavWindowingTargetAnim".}: ptr ImGuiWindow
    navWindowingListWindow* {.importc: "NavWindowingListWindow".}: ptr ImGuiWindow
    navWindowingTimer* {.importc: "NavWindowingTimer".}: float32
    navWindowingHighlightAlpha* {.importc: "NavWindowingHighlightAlpha".}: float32
    navWindowingToggleLayer* {.importc: "NavWindowingToggleLayer".}: bool
    navWindowingAccumDeltaPos* {.importc: "NavWindowingAccumDeltaPos".}: ImVec2
    navWindowingAccumDeltaSize* {.importc: "NavWindowingAccumDeltaSize".}: ImVec2
    dimBgRatio* {.importc: "DimBgRatio".}: float32
    dragDropActive* {.importc: "DragDropActive".}: bool
    dragDropWithinSource* {.importc: "DragDropWithinSource".}: bool
    dragDropWithinTarget* {.importc: "DragDropWithinTarget".}: bool
    dragDropSourceFlags* {.importc: "DragDropSourceFlags".}: ImGuiDragDropFlags
    dragDropSourceFrameCount* {.importc: "DragDropSourceFrameCount".}: int32
    dragDropMouseButton* {.importc: "DragDropMouseButton".}: int32
    dragDropPayload* {.importc: "DragDropPayload".}: ImGuiPayload
    dragDropTargetRect* {.importc: "DragDropTargetRect".}: ImRect
    dragDropTargetId* {.importc: "DragDropTargetId".}: ImGuiID
    dragDropAcceptFlags* {.importc: "DragDropAcceptFlags".}: ImGuiDragDropFlags
    dragDropAcceptIdCurrRectSurface* {.importc: "DragDropAcceptIdCurrRectSurface".}: float32
    dragDropAcceptIdCurr* {.importc: "DragDropAcceptIdCurr".}: ImGuiID
    dragDropAcceptIdPrev* {.importc: "DragDropAcceptIdPrev".}: ImGuiID
    dragDropAcceptFrameCount* {.importc: "DragDropAcceptFrameCount".}: int32
    dragDropHoldJustPressedId* {.importc: "DragDropHoldJustPressedId".}: ImGuiID
    dragDropPayloadBufHeap* {.importc: "DragDropPayloadBufHeap".}: ImVector[uint8]
    dragDropPayloadBufLocal* {.importc: "DragDropPayloadBufLocal".}: array[16, uint8]
    clipperTempDataStacked* {.importc: "ClipperTempDataStacked".}: int32
    clipperTempData* {.importc: "ClipperTempData".}: ImVector[ImGuiListClipperData]
    currentTable* {.importc: "CurrentTable".}: ptr ImGuiTable
    tablesTempDataStacked* {.importc: "TablesTempDataStacked".}: int32
    tablesTempData* {.importc: "TablesTempData".}: ImVector[ImGuiTableTempData]
    tables* {.importc: "Tables".}: ImVector[ImGuiTable]
    tablesLastTimeActive* {.importc: "TablesLastTimeActive".}: ImVector[float32]
    drawChannelsTempMergeBuffer* {.importc: "DrawChannelsTempMergeBuffer".}: ImVector[ImDrawChannel]
    currentTabBar* {.importc: "CurrentTabBar".}: ptr ImGuiTabBar
    tabBars* {.importc: "TabBars".}: ptr ImPool
    currentTabBarStack* {.importc: "CurrentTabBarStack".}: ImVector[ImGuiPtrOrIndex]
    shrinkWidthBuffer* {.importc: "ShrinkWidthBuffer".}: ImVector[ImGuiShrinkWidthItem]
    hoverItemDelayId* {.importc: "HoverItemDelayId".}: ImGuiID
    hoverItemDelayIdPreviousFrame* {.importc: "HoverItemDelayIdPreviousFrame".}: ImGuiID
    hoverItemDelayTimer* {.importc: "HoverItemDelayTimer".}: float32
    hoverItemDelayClearTimer* {.importc: "HoverItemDelayClearTimer".}: float32
    hoverItemUnlockedStationaryId* {.importc: "HoverItemUnlockedStationaryId".}: ImGuiID
    hoverWindowUnlockedStationaryId* {.importc: "HoverWindowUnlockedStationaryId".}: ImGuiID
    mouseCursor* {.importc: "MouseCursor".}: ImGuiMouseCursor
    mouseStationaryTimer* {.importc: "MouseStationaryTimer".}: float32
    mouseLastValidPos* {.importc: "MouseLastValidPos".}: ImVec2
    inputTextState* {.importc: "InputTextState".}: ImGuiInputTextState
    inputTextDeactivatedState* {.importc: "InputTextDeactivatedState".}: ImGuiInputTextDeactivatedState
    inputTextPasswordFont* {.importc: "InputTextPasswordFont".}: ImFont
    tempInputId* {.importc: "TempInputId".}: ImGuiID
    colorEditOptions* {.importc: "ColorEditOptions".}: ImGuiColorEditFlags
    colorEditCurrentID* {.importc: "ColorEditCurrentID".}: ImGuiID
    colorEditSavedID* {.importc: "ColorEditSavedID".}: ImGuiID
    colorEditSavedHue* {.importc: "ColorEditSavedHue".}: float32
    colorEditSavedSat* {.importc: "ColorEditSavedSat".}: float32
    colorEditSavedColor* {.importc: "ColorEditSavedColor".}: uint32
    colorPickerRef* {.importc: "ColorPickerRef".}: ImVec4
    comboPreviewData* {.importc: "ComboPreviewData".}: ImGuiComboPreviewData
    sliderGrabClickOffset* {.importc: "SliderGrabClickOffset".}: float32
    sliderCurrentAccum* {.importc: "SliderCurrentAccum".}: float32
    sliderCurrentAccumDirty* {.importc: "SliderCurrentAccumDirty".}: bool
    dragCurrentAccumDirty* {.importc: "DragCurrentAccumDirty".}: bool
    dragCurrentAccum* {.importc: "DragCurrentAccum".}: float32
    dragSpeedDefaultRatio* {.importc: "DragSpeedDefaultRatio".}: float32
    scrollbarClickDeltaToGrabCenter* {.importc: "ScrollbarClickDeltaToGrabCenter".}: float32
    disabledAlphaBackup* {.importc: "DisabledAlphaBackup".}: float32
    disabledStackSize* {.importc: "DisabledStackSize".}: int16
    lockMarkEdited* {.importc: "LockMarkEdited".}: int16
    tooltipOverrideCount* {.importc: "TooltipOverrideCount".}: int16
    clipboardHandlerData* {.importc: "ClipboardHandlerData".}: ImVector[int8]
    menusIdSubmittedThisFrame* {.importc: "MenusIdSubmittedThisFrame".}: ImVector[ImGuiID]
    platformImeData* {.importc: "PlatformImeData".}: ImGuiPlatformImeData
    platformImeDataPrev* {.importc: "PlatformImeDataPrev".}: ImGuiPlatformImeData
    platformImeViewport* {.importc: "PlatformImeViewport".}: ImGuiID
    dockContext* {.importc: "DockContext".}: ImGuiDockContext
    dockNodeWindowMenuHandler* {.importc: "DockNodeWindowMenuHandler".}: proc(ctx: ptr ImGuiContext, node: ptr ImGuiDockNode, tab_bar: ptr ImGuiTabBar): void {.cdecl, varargs.}
    settingsLoaded* {.importc: "SettingsLoaded".}: bool
    settingsDirtyTimer* {.importc: "SettingsDirtyTimer".}: float32
    settingsIniData* {.importc: "SettingsIniData".}: ImGuiTextBuffer
    settingsHandlers* {.importc: "SettingsHandlers".}: ImVector[ImGuiSettingsHandler]
    settingsWindows* {.importc: "SettingsWindows".}: ImVector[ImGuiWindowSettings]
    settingsTables* {.importc: "SettingsTables".}: ImVector[ImGuiTableSettings]
    hooks* {.importc: "Hooks".}: ImVector[ImGuiContextHook]
    hookIdNext* {.importc: "HookIdNext".}: ImGuiID
    localizationTable* {.importc: "LocalizationTable".}: array[10, cstring]
    logEnabled* {.importc: "LogEnabled".}: bool
    logType* {.importc: "LogType".}: ImGuiLogType
    logFile* {.importc: "LogFile".}: ImFileHandle
    logBuffer* {.importc: "LogBuffer".}: ImGuiTextBuffer
    logNextPrefix* {.importc: "LogNextPrefix".}: cstring
    logNextSuffix* {.importc: "LogNextSuffix".}: cstring
    logLinePosY* {.importc: "LogLinePosY".}: float32
    logLineFirstItem* {.importc: "LogLineFirstItem".}: bool
    logDepthRef* {.importc: "LogDepthRef".}: int32
    logDepthToExpand* {.importc: "LogDepthToExpand".}: int32
    logDepthToExpandDefault* {.importc: "LogDepthToExpandDefault".}: int32
    debugLogFlags* {.importc: "DebugLogFlags".}: ImGuiDebugLogFlags
    debugLogBuf* {.importc: "DebugLogBuf".}: ImGuiTextBuffer
    debugLogIndex* {.importc: "DebugLogIndex".}: ImGuiTextIndex
    debugLogClipperAutoDisableFrames* {.importc: "DebugLogClipperAutoDisableFrames".}: uint8
    debugLocateFrames* {.importc: "DebugLocateFrames".}: uint8
    debugBeginReturnValueCullDepth* {.importc: "DebugBeginReturnValueCullDepth".}: int8
    debugItemPickerActive* {.importc: "DebugItemPickerActive".}: bool
    debugItemPickerMouseButton* {.importc: "DebugItemPickerMouseButton".}: uint8
    debugItemPickerBreakId* {.importc: "DebugItemPickerBreakId".}: ImGuiID
    debugMetricsConfig* {.importc: "DebugMetricsConfig".}: ImGuiMetricsConfig
    debugStackTool* {.importc: "DebugStackTool".}: ImGuiStackTool
    debugHoveredDockNode* {.importc: "DebugHoveredDockNode".}: ptr ImGuiDockNode
    framerateSecPerFrame* {.importc: "FramerateSecPerFrame".}: array[60, float32]
    framerateSecPerFrameIdx* {.importc: "FramerateSecPerFrameIdx".}: int32
    framerateSecPerFrameCount* {.importc: "FramerateSecPerFrameCount".}: int32
    framerateSecPerFrameAccum* {.importc: "FramerateSecPerFrameAccum".}: float32
    wantCaptureMouseNextFrame* {.importc: "WantCaptureMouseNextFrame".}: int32
    wantCaptureKeyboardNextFrame* {.importc: "WantCaptureKeyboardNextFrame".}: int32
    wantTextInputNextFrame* {.importc: "WantTextInputNextFrame".}: int32
    tempBuffer* {.importc: "TempBuffer".}: ImVector[int8]
  ImGuiContextHook* {.importc: "ImGuiContextHook", imgui_header.} = object
    hookId* {.importc: "HookId".}: ImGuiID
    `type`* {.importc: "`type`".}: ImGuiContextHookType
    owner* {.importc: "Owner".}: ImGuiID
    callback* {.importc: "Callback".}: ImGuiContextHookCallback
    userData* {.importc: "UserData".}: pointer
  ImGuiDataTypeInfo* {.importc: "ImGuiDataTypeInfo", imgui_header.} = object
    size* {.importc: "Size".}: uint
    name* {.importc: "Name".}: cstring
    printFmt* {.importc: "PrintFmt".}: cstring
    scanFmt* {.importc: "ScanFmt".}: cstring
  ImGuiDataTypeTempStorage* {.importc: "ImGuiDataTypeTempStorage", imgui_header.} = object
    data* {.importc: "Data".}: array[8, uint8]
  ImGuiDataVarInfo* {.importc: "ImGuiDataVarInfo", imgui_header.} = object
    `type`* {.importc: "`type`".}: ImGuiDataType
    count* {.importc: "Count".}: uint32
    offset* {.importc: "Offset".}: uint32
  ImGuiDockContext* {.importc: "ImGuiDockContext", imgui_header.} = object
    nodes* {.importc: "Nodes".}: ImGuiStorage
    requests* {.importc: "Requests".}: ImVector[ImGuiDockRequest]
    nodesSettings* {.importc: "NodesSettings".}: ImVector[ImGuiDockNodeSettings]
    wantFullRebuild* {.importc: "WantFullRebuild".}: bool
  ImGuiDockNode* {.importc: "ImGuiDockNode", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    sharedFlags* {.importc: "SharedFlags".}: ImGuiDockNodeFlags
    localFlags* {.importc: "LocalFlags".}: ImGuiDockNodeFlags
    localFlagsInWindows* {.importc: "LocalFlagsInWindows".}: ImGuiDockNodeFlags
    mergedFlags* {.importc: "MergedFlags".}: ImGuiDockNodeFlags
    state* {.importc: "State".}: ImGuiDockNodeState
    parentNode* {.importc: "ParentNode".}: ptr ImGuiDockNode
    childNodes* {.importc: "ChildNodes".}: array[2, ptr ImGuiDockNode]
    windows* {.importc: "Windows".}: ImVector[ptr ImGuiWindow]
    tabBar* {.importc: "TabBar".}: ptr ImGuiTabBar
    pos* {.importc: "Pos".}: ImVec2
    size* {.importc: "Size".}: ImVec2
    sizeRef* {.importc: "SizeRef".}: ImVec2
    splitAxis* {.importc: "SplitAxis".}: ImGuiAxis
    windowClass* {.importc: "WindowClass".}: ImGuiWindowClass
    lastBgColor* {.importc: "LastBgColor".}: uint32
    hostWindow* {.importc: "HostWindow".}: ptr ImGuiWindow
    visibleWindow* {.importc: "VisibleWindow".}: ptr ImGuiWindow
    centralNode* {.importc: "CentralNode".}: ptr ImGuiDockNode
    onlyNodeWithWindows* {.importc: "OnlyNodeWithWindows".}: ptr ImGuiDockNode
    countNodeWithWindows* {.importc: "CountNodeWithWindows".}: int32
    lastFrameAlive* {.importc: "LastFrameAlive".}: int32
    lastFrameActive* {.importc: "LastFrameActive".}: int32
    lastFrameFocused* {.importc: "LastFrameFocused".}: int32
    lastFocusedNodeId* {.importc: "LastFocusedNodeId".}: ImGuiID
    selectedTabId* {.importc: "SelectedTabId".}: ImGuiID
    wantCloseTabId* {.importc: "WantCloseTabId".}: ImGuiID
    refViewportId* {.importc: "RefViewportId".}: ImGuiID
    authorityForPos* {.importc: "AuthorityForPos".}: ImGuiDataAuthority
    authorityForSize* {.importc: "AuthorityForSize".}: ImGuiDataAuthority
    authorityForViewport* {.importc: "AuthorityForViewport".}: ImGuiDataAuthority
    isVisible* {.importc: "IsVisible".}: bool
    isFocused* {.importc: "IsFocused".}: bool
    isBgDrawnThisFrame* {.importc: "IsBgDrawnThisFrame".}: bool
    hasCloseButton* {.importc: "HasCloseButton".}: bool
    hasWindowMenuButton* {.importc: "HasWindowMenuButton".}: bool
    hasCentralNodeChild* {.importc: "HasCentralNodeChild".}: bool
    wantCloseAll* {.importc: "WantCloseAll".}: bool
    wantLockSizeOnce* {.importc: "WantLockSizeOnce".}: bool
    wantMouseMove* {.importc: "WantMouseMove".}: bool
    wantHiddenTabBarUpdate* {.importc: "WantHiddenTabBarUpdate".}: bool
    wantHiddenTabBarToggle* {.importc: "WantHiddenTabBarToggle".}: bool
  ImGuiGroupData* {.importc: "ImGuiGroupData", imgui_header.} = object
    windowID* {.importc: "WindowID".}: ImGuiID
    backupCursorPos* {.importc: "BackupCursorPos".}: ImVec2
    backupCursorMaxPos* {.importc: "BackupCursorMaxPos".}: ImVec2
    backupIndent* {.importc: "BackupIndent".}: ImVec1
    backupGroupOffset* {.importc: "BackupGroupOffset".}: ImVec1
    backupCurrLineSize* {.importc: "BackupCurrLineSize".}: ImVec2
    backupCurrLineTextBaseOffset* {.importc: "BackupCurrLineTextBaseOffset".}: float32
    backupActiveIdIsAlive* {.importc: "BackupActiveIdIsAlive".}: ImGuiID
    backupActiveIdPreviousFrameIsAlive* {.importc: "BackupActiveIdPreviousFrameIsAlive".}: bool
    backupHoveredIdIsAlive* {.importc: "BackupHoveredIdIsAlive".}: bool
    emitItem* {.importc: "EmitItem".}: bool
  ImGuiIO* {.importc: "ImGuiIO", imgui_header.} = object
    configFlags* {.importc: "ConfigFlags".}: ImGuiConfigFlags
    backendFlags* {.importc: "BackendFlags".}: ImGuiBackendFlags
    displaySize* {.importc: "DisplaySize".}: ImVec2
    deltaTime* {.importc: "DeltaTime".}: float32
    iniSavingRate* {.importc: "IniSavingRate".}: float32
    iniFilename* {.importc: "IniFilename".}: cstring
    logFilename* {.importc: "LogFilename".}: cstring
    userData* {.importc: "UserData".}: pointer
    fonts* {.importc: "Fonts".}: ptr ImFontAtlas
    fontGlobalScale* {.importc: "FontGlobalScale".}: float32
    fontAllowUserScaling* {.importc: "FontAllowUserScaling".}: bool
    fontDefault* {.importc: "FontDefault".}: ptr ImFont
    displayFramebufferScale* {.importc: "DisplayFramebufferScale".}: ImVec2
    configDockingNoSplit* {.importc: "ConfigDockingNoSplit".}: bool
    configDockingWithShift* {.importc: "ConfigDockingWithShift".}: bool
    configDockingAlwaysTabBar* {.importc: "ConfigDockingAlwaysTabBar".}: bool
    configDockingTransparentPayload* {.importc: "ConfigDockingTransparentPayload".}: bool
    configViewportsNoAutoMerge* {.importc: "ConfigViewportsNoAutoMerge".}: bool
    configViewportsNoTaskBarIcon* {.importc: "ConfigViewportsNoTaskBarIcon".}: bool
    configViewportsNoDecoration* {.importc: "ConfigViewportsNoDecoration".}: bool
    configViewportsNoDefaultParent* {.importc: "ConfigViewportsNoDefaultParent".}: bool
    mouseDrawCursor* {.importc: "MouseDrawCursor".}: bool
    configMacOSXBehaviors* {.importc: "ConfigMacOSXBehaviors".}: bool
    configInputTrickleEventQueue* {.importc: "ConfigInputTrickleEventQueue".}: bool
    configInputTextCursorBlink* {.importc: "ConfigInputTextCursorBlink".}: bool
    configInputTextEnterKeepActive* {.importc: "ConfigInputTextEnterKeepActive".}: bool
    configDragClickToInputText* {.importc: "ConfigDragClickToInputText".}: bool
    configWindowsResizeFromEdges* {.importc: "ConfigWindowsResizeFromEdges".}: bool
    configWindowsMoveFromTitleBarOnly* {.importc: "ConfigWindowsMoveFromTitleBarOnly".}: bool
    configMemoryCompactTimer* {.importc: "ConfigMemoryCompactTimer".}: float32
    mouseDoubleClickTime* {.importc: "MouseDoubleClickTime".}: float32
    mouseDoubleClickMaxDist* {.importc: "MouseDoubleClickMaxDist".}: float32
    mouseDragThreshold* {.importc: "MouseDragThreshold".}: float32
    keyRepeatDelay* {.importc: "KeyRepeatDelay".}: float32
    keyRepeatRate* {.importc: "KeyRepeatRate".}: float32
    configDebugBeginReturnValueOnce* {.importc: "ConfigDebugBeginReturnValueOnce".}: bool
    configDebugBeginReturnValueLoop* {.importc: "ConfigDebugBeginReturnValueLoop".}: bool
    configDebugIgnoreFocusLoss* {.importc: "ConfigDebugIgnoreFocusLoss".}: bool
    configDebugIniSettings* {.importc: "ConfigDebugIniSettings".}: bool
    backendPlatformName* {.importc: "BackendPlatformName".}: cstring
    backendRendererName* {.importc: "BackendRendererName".}: cstring
    backendPlatformUserData* {.importc: "BackendPlatformUserData".}: pointer
    backendRendererUserData* {.importc: "BackendRendererUserData".}: pointer
    backendLanguageUserData* {.importc: "BackendLanguageUserData".}: pointer
    getClipboardTextFn* {.importc: "GetClipboardTextFn".}: proc(user_data: pointer): cstring {.cdecl, varargs.}
    setClipboardTextFn* {.importc: "SetClipboardTextFn".}: proc(user_data: pointer, text: cstring): void {.cdecl, varargs.}
    clipboardUserData* {.importc: "ClipboardUserData".}: pointer
    setPlatformImeDataFn* {.importc: "SetPlatformImeDataFn".}: proc(viewport: ptr ImGuiViewport, data: ptr ImGuiPlatformImeData): void {.cdecl, varargs.}
    unusedPadding* {.importc: "_UnusedPadding".}: pointer
    platformLocaleDecimalPoint* {.importc: "PlatformLocaleDecimalPoint".}: ImWchar
    wantCaptureMouse* {.importc: "WantCaptureMouse".}: bool
    wantCaptureKeyboard* {.importc: "WantCaptureKeyboard".}: bool
    wantTextInput* {.importc: "WantTextInput".}: bool
    wantSetMousePos* {.importc: "WantSetMousePos".}: bool
    wantSaveIniSettings* {.importc: "WantSaveIniSettings".}: bool
    navActive* {.importc: "NavActive".}: bool
    navVisible* {.importc: "NavVisible".}: bool
    framerate* {.importc: "Framerate".}: float32
    metricsRenderVertices* {.importc: "MetricsRenderVertices".}: int32
    metricsRenderIndices* {.importc: "MetricsRenderIndices".}: int32
    metricsRenderWindows* {.importc: "MetricsRenderWindows".}: int32
    metricsActiveWindows* {.importc: "MetricsActiveWindows".}: int32
    metricsActiveAllocations* {.importc: "MetricsActiveAllocations".}: int32
    mouseDelta* {.importc: "MouseDelta".}: ImVec2
    keyMap* {.importc: "KeyMap".}: array[652, int32]
    keysDown* {.importc: "KeysDown".}: array[652, bool]
    navInputs* {.importc: "NavInputs".}: array[16, float32]
    ctx* {.importc: "Ctx".}: ptr ImGuiContext
    mousePos* {.importc: "MousePos".}: ImVec2
    mouseDown* {.importc: "MouseDown".}: array[5, bool]
    mouseWheel* {.importc: "MouseWheel".}: float32
    mouseWheelH* {.importc: "MouseWheelH".}: float32
    mouseSource* {.importc: "MouseSource".}: ImGuiMouseSource
    mouseHoveredViewport* {.importc: "MouseHoveredViewport".}: ImGuiID
    keyCtrl* {.importc: "KeyCtrl".}: bool
    keyShift* {.importc: "KeyShift".}: bool
    keyAlt* {.importc: "KeyAlt".}: bool
    keySuper* {.importc: "KeySuper".}: bool
    keyMods* {.importc: "KeyMods".}: ImGuiKeyChord
    keysData* {.importc: "KeysData".}: array[ImGuiKey_KeysData_SIZE, ImGuiKeyData]
    wantCaptureMouseUnlessPopupClose* {.importc: "WantCaptureMouseUnlessPopupClose".}: bool
    mousePosPrev* {.importc: "MousePosPrev".}: ImVec2
    mouseClickedPos* {.importc: "MouseClickedPos".}: array[5, ImVec2]
    mouseClickedTime* {.importc: "MouseClickedTime".}: array[5, float64]
    mouseClicked* {.importc: "MouseClicked".}: array[5, bool]
    mouseDoubleClicked* {.importc: "MouseDoubleClicked".}: array[5, bool]
    mouseClickedCount* {.importc: "MouseClickedCount".}: array[5, uint16]
    mouseClickedLastCount* {.importc: "MouseClickedLastCount".}: array[5, uint16]
    mouseReleased* {.importc: "MouseReleased".}: array[5, bool]
    mouseDownOwned* {.importc: "MouseDownOwned".}: array[5, bool]
    mouseDownOwnedUnlessPopupClose* {.importc: "MouseDownOwnedUnlessPopupClose".}: array[5, bool]
    mouseWheelRequestAxisSwap* {.importc: "MouseWheelRequestAxisSwap".}: bool
    mouseDownDuration* {.importc: "MouseDownDuration".}: array[5, float32]
    mouseDownDurationPrev* {.importc: "MouseDownDurationPrev".}: array[5, float32]
    mouseDragMaxDistanceAbs* {.importc: "MouseDragMaxDistanceAbs".}: array[5, ImVec2]
    mouseDragMaxDistanceSqr* {.importc: "MouseDragMaxDistanceSqr".}: array[5, float32]
    penPressure* {.importc: "PenPressure".}: float32
    appFocusLost* {.importc: "AppFocusLost".}: bool
    appAcceptingEvents* {.importc: "AppAcceptingEvents".}: bool
    backendUsingLegacyKeyArrays* {.importc: "BackendUsingLegacyKeyArrays".}: int8
    backendUsingLegacyNavInputArray* {.importc: "BackendUsingLegacyNavInputArray".}: bool
    inputQueueSurrogate* {.importc: "InputQueueSurrogate".}: ImWchar16
    inputQueueCharacters* {.importc: "InputQueueCharacters".}: ImVector[ImWchar]
  ImGuiInputEventAppFocused* {.importc: "ImGuiInputEventAppFocused", imgui_header.} = object
    focused* {.importc: "Focused".}: bool
  ImGuiInputEventKey* {.importc: "ImGuiInputEventKey", imgui_header.} = object
    key* {.importc: "Key".}: ImGuiKey
    down* {.importc: "Down".}: bool
    analogValue* {.importc: "AnalogValue".}: float32
  ImGuiInputEventMouseButton* {.importc: "ImGuiInputEventMouseButton", imgui_header.} = object
    button* {.importc: "Button".}: int32
    down* {.importc: "Down".}: bool
    mouseSource* {.importc: "MouseSource".}: ImGuiMouseSource
  ImGuiInputEventMousePos* {.importc: "ImGuiInputEventMousePos", imgui_header.} = object
    posX* {.importc: "PosX".}: float32
    posY* {.importc: "PosY".}: float32
    mouseSource* {.importc: "MouseSource".}: ImGuiMouseSource
  ImGuiInputEventMouseViewport* {.importc: "ImGuiInputEventMouseViewport", imgui_header.} = object
    hoveredViewportID* {.importc: "HoveredViewportID".}: ImGuiID
  ImGuiInputEventMouseWheel* {.importc: "ImGuiInputEventMouseWheel", imgui_header.} = object
    wheelX* {.importc: "WheelX".}: float32
    wheelY* {.importc: "WheelY".}: float32
    mouseSource* {.importc: "MouseSource".}: ImGuiMouseSource
  ImGuiInputEventText* {.importc: "ImGuiInputEventText", imgui_header.} = object
    char* {.importc: "Char".}: uint32
  ImGuiInputTextCallbackData* {.importc: "ImGuiInputTextCallbackData", imgui_header.} = object
    ctx* {.importc: "Ctx".}: ptr ImGuiContext
    eventFlag* {.importc: "EventFlag".}: ImGuiInputTextFlags
    flags* {.importc: "Flags".}: ImGuiInputTextFlags
    userData* {.importc: "UserData".}: pointer
    eventChar* {.importc: "EventChar".}: ImWchar
    eventKey* {.importc: "EventKey".}: ImGuiKey
    buf* {.importc: "Buf".}: cstring
    bufTextLen* {.importc: "BufTextLen".}: int32
    bufSize* {.importc: "BufSize".}: int32
    bufDirty* {.importc: "BufDirty".}: bool
    cursorPos* {.importc: "CursorPos".}: int32
    selectionStart* {.importc: "SelectionStart".}: int32
    selectionEnd* {.importc: "SelectionEnd".}: int32
  ImGuiInputTextDeactivatedState* {.importc: "ImGuiInputTextDeactivatedState", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    textA* {.importc: "TextA".}: ImVector[int8]
  ImGuiInputTextState* {.importc: "ImGuiInputTextState", imgui_header.} = object
    ctx* {.importc: "Ctx".}: ptr ImGuiContext
    id* {.importc: "ID".}: ImGuiID
    curLenW* {.importc: "CurLenW".}: int32
    curLenA* {.importc: "CurLenA".}: int32
    textW* {.importc: "TextW".}: ImVector[ImWchar]
    textA* {.importc: "TextA".}: ImVector[int8]
    initialTextA* {.importc: "InitialTextA".}: ImVector[int8]
    textAIsValid* {.importc: "TextAIsValid".}: bool
    bufCapacityA* {.importc: "BufCapacityA".}: int32
    scrollX* {.importc: "ScrollX".}: float32
    stb* {.importc: "Stb".}: STB_TexteditState
    cursorAnim* {.importc: "CursorAnim".}: float32
    cursorFollow* {.importc: "CursorFollow".}: bool
    selectedAllMouseLock* {.importc: "SelectedAllMouseLock".}: bool
    edited* {.importc: "Edited".}: bool
    flags* {.importc: "Flags".}: ImGuiInputTextFlags
  ImGuiKeyData* {.importc: "ImGuiKeyData", imgui_header.} = object
    down* {.importc: "Down".}: bool
    downDuration* {.importc: "DownDuration".}: float32
    downDurationPrev* {.importc: "DownDurationPrev".}: float32
    analogValue* {.importc: "AnalogValue".}: float32
  ImGuiKeyOwnerData* {.importc: "ImGuiKeyOwnerData", imgui_header.} = object
    ownerCurr* {.importc: "OwnerCurr".}: ImGuiID
    ownerNext* {.importc: "OwnerNext".}: ImGuiID
    lockThisFrame* {.importc: "LockThisFrame".}: bool
    lockUntilRelease* {.importc: "LockUntilRelease".}: bool
  ImGuiKeyRoutingData* {.importc: "ImGuiKeyRoutingData", imgui_header.} = object
    nextEntryIndex* {.importc: "NextEntryIndex".}: ImGuiKeyRoutingIndex
    mods* {.importc: "Mods".}: uint16
    routingNextScore* {.importc: "RoutingNextScore".}: uint8
    routingCurr* {.importc: "RoutingCurr".}: ImGuiID
    routingNext* {.importc: "RoutingNext".}: ImGuiID
  ImGuiKeyRoutingTable* {.importc: "ImGuiKeyRoutingTable", imgui_header.} = object
    index* {.importc: "Index".}: array[140, ImGuiKeyRoutingIndex]
    entries* {.importc: "Entries".}: ImVector[ImGuiKeyRoutingData]
    entriesNext* {.importc: "EntriesNext".}: ImVector[ImGuiKeyRoutingData]
  ImGuiLastItemData* {.importc: "ImGuiLastItemData", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    inFlags* {.importc: "InFlags".}: ImGuiItemFlags
    statusFlags* {.importc: "StatusFlags".}: ImGuiItemStatusFlags
    rect* {.importc: "Rect".}: ImRect
    navRect* {.importc: "NavRect".}: ImRect
    displayRect* {.importc: "DisplayRect".}: ImRect
  ImGuiListClipper* {.importc: "ImGuiListClipper", imgui_header.} = object
    ctx* {.importc: "Ctx".}: ptr ImGuiContext
    displayStart* {.importc: "DisplayStart".}: int32
    displayEnd* {.importc: "DisplayEnd".}: int32
    itemsCount* {.importc: "ItemsCount".}: int32
    itemsHeight* {.importc: "ItemsHeight".}: float32
    startPosY* {.importc: "StartPosY".}: float32
    tempData* {.importc: "TempData".}: pointer
  ImGuiListClipperData* {.importc: "ImGuiListClipperData", imgui_header.} = object
    listClipper* {.importc: "ListClipper".}: ptr ImGuiListClipper
    lossynessOffset* {.importc: "LossynessOffset".}: float32
    stepNo* {.importc: "StepNo".}: int32
    itemsFrozen* {.importc: "ItemsFrozen".}: int32
    ranges* {.importc: "Ranges".}: ImVector[ImGuiListClipperRange]
  ImGuiListClipperRange* {.importc: "ImGuiListClipperRange", imgui_header.} = object
    min* {.importc: "Min".}: int32
    max* {.importc: "Max".}: int32
    posToIndexConvert* {.importc: "PosToIndexConvert".}: bool
    posToIndexOffsetMin* {.importc: "PosToIndexOffsetMin".}: int8
    posToIndexOffsetMax* {.importc: "PosToIndexOffsetMax".}: int8
  ImGuiLocEntry* {.importc: "ImGuiLocEntry", imgui_header.} = object
    key* {.importc: "Key".}: ImGuiLocKey
    text* {.importc: "Text".}: cstring
  ImGuiMenuColumns* {.importc: "ImGuiMenuColumns", imgui_header.} = object
    totalWidth* {.importc: "TotalWidth".}: uint32
    nextTotalWidth* {.importc: "NextTotalWidth".}: uint32
    spacing* {.importc: "Spacing".}: uint16
    offsetIcon* {.importc: "OffsetIcon".}: uint16
    offsetLabel* {.importc: "OffsetLabel".}: uint16
    offsetShortcut* {.importc: "OffsetShortcut".}: uint16
    offsetMark* {.importc: "OffsetMark".}: uint16
    widths* {.importc: "Widths".}: array[4, uint16]
  ImGuiMetricsConfig* {.importc: "ImGuiMetricsConfig", imgui_header.} = object
    showDebugLog* {.importc: "ShowDebugLog".}: bool
    showStackTool* {.importc: "ShowStackTool".}: bool
    showWindowsRects* {.importc: "ShowWindowsRects".}: bool
    showWindowsBeginOrder* {.importc: "ShowWindowsBeginOrder".}: bool
    showTablesRects* {.importc: "ShowTablesRects".}: bool
    showDrawCmdMesh* {.importc: "ShowDrawCmdMesh".}: bool
    showDrawCmdBoundingBoxes* {.importc: "ShowDrawCmdBoundingBoxes".}: bool
    showAtlasTintedWithTextColor* {.importc: "ShowAtlasTintedWithTextColor".}: bool
    showDockingNodes* {.importc: "ShowDockingNodes".}: bool
    showWindowsRectsType* {.importc: "ShowWindowsRectsType".}: int32
    showTablesRectsType* {.importc: "ShowTablesRectsType".}: int32
  ImGuiNavItemData* {.importc: "ImGuiNavItemData", imgui_header.} = object
    window* {.importc: "Window".}: ptr ImGuiWindow
    id* {.importc: "ID".}: ImGuiID
    focusScopeId* {.importc: "FocusScopeId".}: ImGuiID
    rectRel* {.importc: "RectRel".}: ImRect
    inFlags* {.importc: "InFlags".}: ImGuiItemFlags
    distBox* {.importc: "DistBox".}: float32
    distCenter* {.importc: "DistCenter".}: float32
    distAxial* {.importc: "DistAxial".}: float32
  ImGuiNavTreeNodeData* {.importc: "ImGuiNavTreeNodeData", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    inFlags* {.importc: "InFlags".}: ImGuiItemFlags
    navRect* {.importc: "NavRect".}: ImRect
  ImGuiNextItemData* {.importc: "ImGuiNextItemData", imgui_header.} = object
    flags* {.importc: "Flags".}: ImGuiNextItemDataFlags
    itemFlags* {.importc: "ItemFlags".}: ImGuiItemFlags
    width* {.importc: "Width".}: float32
    focusScopeId* {.importc: "FocusScopeId".}: ImGuiID
    openCond* {.importc: "OpenCond".}: ImGuiCond
    openVal* {.importc: "OpenVal".}: bool
  ImGuiNextWindowData* {.importc: "ImGuiNextWindowData", imgui_header.} = object
    flags* {.importc: "Flags".}: ImGuiNextWindowDataFlags
    posCond* {.importc: "PosCond".}: ImGuiCond
    sizeCond* {.importc: "SizeCond".}: ImGuiCond
    collapsedCond* {.importc: "CollapsedCond".}: ImGuiCond
    dockCond* {.importc: "DockCond".}: ImGuiCond
    posVal* {.importc: "PosVal".}: ImVec2
    posPivotVal* {.importc: "PosPivotVal".}: ImVec2
    sizeVal* {.importc: "SizeVal".}: ImVec2
    contentSizeVal* {.importc: "ContentSizeVal".}: ImVec2
    scrollVal* {.importc: "ScrollVal".}: ImVec2
    posUndock* {.importc: "PosUndock".}: bool
    collapsedVal* {.importc: "CollapsedVal".}: bool
    sizeConstraintRect* {.importc: "SizeConstraintRect".}: ImRect
    sizeCallback* {.importc: "SizeCallback".}: ImGuiSizeCallback
    sizeCallbackUserData* {.importc: "SizeCallbackUserData".}: pointer
    bgAlphaVal* {.importc: "BgAlphaVal".}: float32
    viewportId* {.importc: "ViewportId".}: ImGuiID
    dockId* {.importc: "DockId".}: ImGuiID
    windowClass* {.importc: "WindowClass".}: ImGuiWindowClass
    menuBarOffsetMinVal* {.importc: "MenuBarOffsetMinVal".}: ImVec2
  ImGuiOldColumnData* {.importc: "ImGuiOldColumnData", imgui_header.} = object
    offsetNorm* {.importc: "OffsetNorm".}: float32
    offsetNormBeforeResize* {.importc: "OffsetNormBeforeResize".}: float32
    flags* {.importc: "Flags".}: ImGuiOldColumnFlags
    clipRect* {.importc: "ClipRect".}: ImRect
  ImGuiOldColumns* {.importc: "ImGuiOldColumns", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    flags* {.importc: "Flags".}: ImGuiOldColumnFlags
    isFirstFrame* {.importc: "IsFirstFrame".}: bool
    isBeingResized* {.importc: "IsBeingResized".}: bool
    current* {.importc: "Current".}: int32
    count* {.importc: "Count".}: int32
    offMinX* {.importc: "OffMinX".}: float32
    offMaxX* {.importc: "OffMaxX".}: float32
    lineMinY* {.importc: "LineMinY".}: float32
    lineMaxY* {.importc: "LineMaxY".}: float32
    hostCursorPosY* {.importc: "HostCursorPosY".}: float32
    hostCursorMaxPosX* {.importc: "HostCursorMaxPosX".}: float32
    hostInitialClipRect* {.importc: "HostInitialClipRect".}: ImRect
    hostBackupClipRect* {.importc: "HostBackupClipRect".}: ImRect
    hostBackupParentWorkRect* {.importc: "HostBackupParentWorkRect".}: ImRect
    columns* {.importc: "Columns".}: ImVector[ImGuiOldColumnData]
    splitter* {.importc: "Splitter".}: ImDrawListSplitter
  ImGuiOnceUponAFrame* {.importc: "ImGuiOnceUponAFrame", imgui_header.} = object
    refFrame* {.importc: "RefFrame".}: int32
  ImGuiPayload* {.importc: "ImGuiPayload", imgui_header.} = object
    data* {.importc: "Data".}: pointer
    dataSize* {.importc: "DataSize".}: int32
    sourceId* {.importc: "SourceId".}: ImGuiID
    sourceParentId* {.importc: "SourceParentId".}: ImGuiID
    dataFrameCount* {.importc: "DataFrameCount".}: int32
    dataType* {.importc: "DataType".}: array[32+1, int8]
    preview* {.importc: "Preview".}: bool
    delivery* {.importc: "Delivery".}: bool
  ImGuiPlatformIO* {.importc: "ImGuiPlatformIO", imgui_header.} = object
    platform_CreateWindow* {.importc: "Platform_CreateWindow".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    platform_DestroyWindow* {.importc: "Platform_DestroyWindow".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    platform_ShowWindow* {.importc: "Platform_ShowWindow".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    platform_SetWindowPos* {.importc: "Platform_SetWindowPos".}: proc(vp: ptr ImGuiViewport, pos: ImVec2): void {.cdecl, varargs.}
    platform_GetWindowPos* {.importc: "Platform_GetWindowPos".}: proc(vp: ptr ImGuiViewport): ImVec2 {.cdecl, varargs.}
    platform_SetWindowSize* {.importc: "Platform_SetWindowSize".}: proc(vp: ptr ImGuiViewport, size: ImVec2): void {.cdecl, varargs.}
    platform_GetWindowSize* {.importc: "Platform_GetWindowSize".}: proc(vp: ptr ImGuiViewport): ImVec2 {.cdecl, varargs.}
    platform_SetWindowFocus* {.importc: "Platform_SetWindowFocus".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    platform_GetWindowFocus* {.importc: "Platform_GetWindowFocus".}: proc(vp: ptr ImGuiViewport): bool {.cdecl, varargs.}
    platform_GetWindowMinimized* {.importc: "Platform_GetWindowMinimized".}: proc(vp: ptr ImGuiViewport): bool {.cdecl, varargs.}
    platform_SetWindowTitle* {.importc: "Platform_SetWindowTitle".}: proc(vp: ptr ImGuiViewport, str: cstring): void {.cdecl, varargs.}
    platform_SetWindowAlpha* {.importc: "Platform_SetWindowAlpha".}: proc(vp: ptr ImGuiViewport, alpha: float32): void {.cdecl, varargs.}
    platform_UpdateWindow* {.importc: "Platform_UpdateWindow".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    platform_RenderWindow* {.importc: "Platform_RenderWindow".}: proc(vp: ptr ImGuiViewport, render_arg: pointer): void {.cdecl, varargs.}
    platform_SwapBuffers* {.importc: "Platform_SwapBuffers".}: proc(vp: ptr ImGuiViewport, render_arg: pointer): void {.cdecl, varargs.}
    platform_GetWindowDpiScale* {.importc: "Platform_GetWindowDpiScale".}: proc(vp: ptr ImGuiViewport): float32 {.cdecl, varargs.}
    platform_OnChangedViewport* {.importc: "Platform_OnChangedViewport".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    platform_CreateVkSurface* {.importc: "Platform_CreateVkSurface".}: proc(vp: ptr ImGuiViewport, vk_inst: uint64, vk_allocators: pointer, out_vk_surface: ptr uint64): int32 {.cdecl, varargs.}
    renderer_CreateWindow* {.importc: "Renderer_CreateWindow".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    renderer_DestroyWindow* {.importc: "Renderer_DestroyWindow".}: proc(vp: ptr ImGuiViewport): void {.cdecl, varargs.}
    renderer_SetWindowSize* {.importc: "Renderer_SetWindowSize".}: proc(vp: ptr ImGuiViewport, size: ImVec2): void {.cdecl, varargs.}
    renderer_RenderWindow* {.importc: "Renderer_RenderWindow".}: proc(vp: ptr ImGuiViewport, render_arg: pointer): void {.cdecl, varargs.}
    renderer_SwapBuffers* {.importc: "Renderer_SwapBuffers".}: proc(vp: ptr ImGuiViewport, render_arg: pointer): void {.cdecl, varargs.}
    monitors* {.importc: "Monitors".}: ImVector[ImGuiPlatformMonitor]
    viewports* {.importc: "Viewports".}: ImVector[ptr ImGuiViewport]
  ImGuiPlatformImeData* {.importc: "ImGuiPlatformImeData", imgui_header.} = object
    wantVisible* {.importc: "WantVisible".}: bool
    inputPos* {.importc: "InputPos".}: ImVec2
    inputLineHeight* {.importc: "InputLineHeight".}: float32
  ImGuiPlatformMonitor* {.importc: "ImGuiPlatformMonitor", imgui_header.} = object
    mainPos* {.importc: "MainPos".}: ImVec2
    mainSize* {.importc: "MainSize".}: ImVec2
    workPos* {.importc: "WorkPos".}: ImVec2
    workSize* {.importc: "WorkSize".}: ImVec2
    dpiScale* {.importc: "DpiScale".}: float32
    platformHandle* {.importc: "PlatformHandle".}: pointer
  ImGuiPopupData* {.importc: "ImGuiPopupData", imgui_header.} = object
    popupId* {.importc: "PopupId".}: ImGuiID
    window* {.importc: "Window".}: ptr ImGuiWindow
    backupNavWindow* {.importc: "BackupNavWindow".}: ptr ImGuiWindow
    parentNavLayer* {.importc: "ParentNavLayer".}: int32
    openFrameCount* {.importc: "OpenFrameCount".}: int32
    openParentId* {.importc: "OpenParentId".}: ImGuiID
    openPopupPos* {.importc: "OpenPopupPos".}: ImVec2
    openMousePos* {.importc: "OpenMousePos".}: ImVec2
  ImGuiPtrOrIndex* {.importc: "ImGuiPtrOrIndex", imgui_header.} = object
    `ptr`* {.importc: "`ptr`".}: pointer
    index* {.importc: "Index".}: int32
  ImGuiSettingsHandler* {.importc: "ImGuiSettingsHandler", imgui_header.} = object
    typeName* {.importc: "TypeName".}: cstring
    typeHash* {.importc: "TypeHash".}: ImGuiID
    clearAllFn* {.importc: "ClearAllFn".}: proc(ctx: ptr ImGuiContext, handler: ptr ImGuiSettingsHandler): void {.cdecl, varargs.}
    readInitFn* {.importc: "ReadInitFn".}: proc(ctx: ptr ImGuiContext, handler: ptr ImGuiSettingsHandler): void {.cdecl, varargs.}
    readOpenFn* {.importc: "ReadOpenFn".}: proc(ctx: ptr ImGuiContext, handler: ptr ImGuiSettingsHandler, name: cstring): pointer {.cdecl, varargs.}
    readLineFn* {.importc: "ReadLineFn".}: proc(ctx: ptr ImGuiContext, handler: ptr ImGuiSettingsHandler, entry: pointer, line: cstring): void {.cdecl, varargs.}
    applyAllFn* {.importc: "ApplyAllFn".}: proc(ctx: ptr ImGuiContext, handler: ptr ImGuiSettingsHandler): void {.cdecl, varargs.}
    writeAllFn* {.importc: "WriteAllFn".}: proc(ctx: ptr ImGuiContext, handler: ptr ImGuiSettingsHandler, out_buf: ptr ImGuiTextBuffer): void {.cdecl, varargs.}
    userData* {.importc: "UserData".}: pointer
  ImGuiShrinkWidthItem* {.importc: "ImGuiShrinkWidthItem", imgui_header.} = object
    index* {.importc: "Index".}: int32
    width* {.importc: "Width".}: float32
    initialWidth* {.importc: "InitialWidth".}: float32
  ImGuiSizeCallbackData* {.importc: "ImGuiSizeCallbackData", imgui_header.} = object
    userData* {.importc: "UserData".}: pointer
    pos* {.importc: "Pos".}: ImVec2
    currentSize* {.importc: "CurrentSize".}: ImVec2
    desiredSize* {.importc: "DesiredSize".}: ImVec2
  ImGuiStackLevelInfo* {.importc: "ImGuiStackLevelInfo", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    queryFrameCount* {.importc: "QueryFrameCount".}: int8
    querySuccess* {.importc: "QuerySuccess".}: bool
    dataType* {.importc: "DataType".}: ImGuiDataType
    desc* {.importc: "Desc".}: array[57, int8]
  ImGuiStackSizes* {.importc: "ImGuiStackSizes", imgui_header.} = object
    sizeOfIDStack* {.importc: "SizeOfIDStack".}: int16
    sizeOfColorStack* {.importc: "SizeOfColorStack".}: int16
    sizeOfStyleVarStack* {.importc: "SizeOfStyleVarStack".}: int16
    sizeOfFontStack* {.importc: "SizeOfFontStack".}: int16
    sizeOfFocusScopeStack* {.importc: "SizeOfFocusScopeStack".}: int16
    sizeOfGroupStack* {.importc: "SizeOfGroupStack".}: int16
    sizeOfItemFlagsStack* {.importc: "SizeOfItemFlagsStack".}: int16
    sizeOfBeginPopupStack* {.importc: "SizeOfBeginPopupStack".}: int16
    sizeOfDisabledStack* {.importc: "SizeOfDisabledStack".}: int16
  ImGuiStackTool* {.importc: "ImGuiStackTool", imgui_header.} = object
    lastActiveFrame* {.importc: "LastActiveFrame".}: int32
    stackLevel* {.importc: "StackLevel".}: int32
    queryId* {.importc: "QueryId".}: ImGuiID
    results* {.importc: "Results".}: ImVector[ImGuiStackLevelInfo]
    copyToClipboardOnCtrlC* {.importc: "CopyToClipboardOnCtrlC".}: bool
    copyToClipboardLastTime* {.importc: "CopyToClipboardLastTime".}: float32
  ImGuiStorage* {.importc: "ImGuiStorage", imgui_header.} = object
    data* {.importc: "Data".}: ImVector[ImGuiStoragePair]
  ImGuiStyle* {.importc: "ImGuiStyle", imgui_header.} = object
    alpha* {.importc: "Alpha".}: float32
    disabledAlpha* {.importc: "DisabledAlpha".}: float32
    windowPadding* {.importc: "WindowPadding".}: ImVec2
    windowRounding* {.importc: "WindowRounding".}: float32
    windowBorderSize* {.importc: "WindowBorderSize".}: float32
    windowMinSize* {.importc: "WindowMinSize".}: ImVec2
    windowTitleAlign* {.importc: "WindowTitleAlign".}: ImVec2
    windowMenuButtonPosition* {.importc: "WindowMenuButtonPosition".}: ImGuiDir
    childRounding* {.importc: "ChildRounding".}: float32
    childBorderSize* {.importc: "ChildBorderSize".}: float32
    popupRounding* {.importc: "PopupRounding".}: float32
    popupBorderSize* {.importc: "PopupBorderSize".}: float32
    framePadding* {.importc: "FramePadding".}: ImVec2
    frameRounding* {.importc: "FrameRounding".}: float32
    frameBorderSize* {.importc: "FrameBorderSize".}: float32
    itemSpacing* {.importc: "ItemSpacing".}: ImVec2
    itemInnerSpacing* {.importc: "ItemInnerSpacing".}: ImVec2
    cellPadding* {.importc: "CellPadding".}: ImVec2
    touchExtraPadding* {.importc: "TouchExtraPadding".}: ImVec2
    indentSpacing* {.importc: "IndentSpacing".}: float32
    columnsMinSpacing* {.importc: "ColumnsMinSpacing".}: float32
    scrollbarSize* {.importc: "ScrollbarSize".}: float32
    scrollbarRounding* {.importc: "ScrollbarRounding".}: float32
    grabMinSize* {.importc: "GrabMinSize".}: float32
    grabRounding* {.importc: "GrabRounding".}: float32
    logSliderDeadzone* {.importc: "LogSliderDeadzone".}: float32
    tabRounding* {.importc: "TabRounding".}: float32
    tabBorderSize* {.importc: "TabBorderSize".}: float32
    tabMinWidthForCloseButton* {.importc: "TabMinWidthForCloseButton".}: float32
    colorButtonPosition* {.importc: "ColorButtonPosition".}: ImGuiDir
    buttonTextAlign* {.importc: "ButtonTextAlign".}: ImVec2
    selectableTextAlign* {.importc: "SelectableTextAlign".}: ImVec2
    separatorTextBorderSize* {.importc: "SeparatorTextBorderSize".}: float32
    separatorTextAlign* {.importc: "SeparatorTextAlign".}: ImVec2
    separatorTextPadding* {.importc: "SeparatorTextPadding".}: ImVec2
    displayWindowPadding* {.importc: "DisplayWindowPadding".}: ImVec2
    displaySafeAreaPadding* {.importc: "DisplaySafeAreaPadding".}: ImVec2
    dockingSeparatorSize* {.importc: "DockingSeparatorSize".}: float32
    mouseCursorScale* {.importc: "MouseCursorScale".}: float32
    antiAliasedLines* {.importc: "AntiAliasedLines".}: bool
    antiAliasedLinesUseTex* {.importc: "AntiAliasedLinesUseTex".}: bool
    antiAliasedFill* {.importc: "AntiAliasedFill".}: bool
    curveTessellationTol* {.importc: "CurveTessellationTol".}: float32
    circleTessellationMaxError* {.importc: "CircleTessellationMaxError".}: float32
    colors* {.importc: "Colors".}: array[55, ImVec4]
    hoverStationaryDelay* {.importc: "HoverStationaryDelay".}: float32
    hoverDelayShort* {.importc: "HoverDelayShort".}: float32
    hoverDelayNormal* {.importc: "HoverDelayNormal".}: float32
    hoverFlagsForTooltipMouse* {.importc: "HoverFlagsForTooltipMouse".}: ImGuiHoveredFlags
    hoverFlagsForTooltipNav* {.importc: "HoverFlagsForTooltipNav".}: ImGuiHoveredFlags
  ImGuiTabBar* {.importc: "ImGuiTabBar", imgui_header.} = object
    tabs* {.importc: "Tabs".}: ImVector[ImGuiTabItem]
    flags* {.importc: "Flags".}: ImGuiTabBarFlags
    id* {.importc: "ID".}: ImGuiID
    selectedTabId* {.importc: "SelectedTabId".}: ImGuiID
    nextSelectedTabId* {.importc: "NextSelectedTabId".}: ImGuiID
    visibleTabId* {.importc: "VisibleTabId".}: ImGuiID
    currFrameVisible* {.importc: "CurrFrameVisible".}: int32
    prevFrameVisible* {.importc: "PrevFrameVisible".}: int32
    barRect* {.importc: "BarRect".}: ImRect
    currTabsContentsHeight* {.importc: "CurrTabsContentsHeight".}: float32
    prevTabsContentsHeight* {.importc: "PrevTabsContentsHeight".}: float32
    widthAllTabs* {.importc: "WidthAllTabs".}: float32
    widthAllTabsIdeal* {.importc: "WidthAllTabsIdeal".}: float32
    scrollingAnim* {.importc: "ScrollingAnim".}: float32
    scrollingTarget* {.importc: "ScrollingTarget".}: float32
    scrollingTargetDistToVisibility* {.importc: "ScrollingTargetDistToVisibility".}: float32
    scrollingSpeed* {.importc: "ScrollingSpeed".}: float32
    scrollingRectMinX* {.importc: "ScrollingRectMinX".}: float32
    scrollingRectMaxX* {.importc: "ScrollingRectMaxX".}: float32
    reorderRequestTabId* {.importc: "ReorderRequestTabId".}: ImGuiID
    reorderRequestOffset* {.importc: "ReorderRequestOffset".}: int16
    beginCount* {.importc: "BeginCount".}: int8
    wantLayout* {.importc: "WantLayout".}: bool
    visibleTabWasSubmitted* {.importc: "VisibleTabWasSubmitted".}: bool
    tabsAddedNew* {.importc: "TabsAddedNew".}: bool
    tabsActiveCount* {.importc: "TabsActiveCount".}: int16
    lastTabItemIdx* {.importc: "LastTabItemIdx".}: int16
    itemSpacingY* {.importc: "ItemSpacingY".}: float32
    framePadding* {.importc: "FramePadding".}: ImVec2
    backupCursorPos* {.importc: "BackupCursorPos".}: ImVec2
    tabsNames* {.importc: "TabsNames".}: ImGuiTextBuffer
  ImGuiTabItem* {.importc: "ImGuiTabItem", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    flags* {.importc: "Flags".}: ImGuiTabItemFlags
    window* {.importc: "Window".}: ptr ImGuiWindow
    lastFrameVisible* {.importc: "LastFrameVisible".}: int32
    lastFrameSelected* {.importc: "LastFrameSelected".}: int32
    offset* {.importc: "Offset".}: float32
    width* {.importc: "Width".}: float32
    contentWidth* {.importc: "ContentWidth".}: float32
    requestedWidth* {.importc: "RequestedWidth".}: float32
    nameOffset* {.importc: "NameOffset".}: int32
    beginOrder* {.importc: "BeginOrder".}: int16
    indexDuringLayout* {.importc: "IndexDuringLayout".}: int16
    wantClose* {.importc: "WantClose".}: bool
  ImGuiTable* {.importc: "ImGuiTable", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    flags* {.importc: "Flags".}: ImGuiTableFlags
    rawData* {.importc: "RawData".}: pointer
    tempData* {.importc: "TempData".}: ptr ImGuiTableTempData
    columns* {.importc: "Columns".}: ImVector[ImGuiTableColumn]
    displayOrderToIndex* {.importc: "DisplayOrderToIndex".}: ImVector[ImGuiTableColumnIdx]
    rowCellData* {.importc: "RowCellData".}: ImVector[ImGuiTableCellData]
    enabledMaskByDisplayOrder* {.importc: "EnabledMaskByDisplayOrder".}: uint32Ptr
    enabledMaskByIndex* {.importc: "EnabledMaskByIndex".}: uint32Ptr
    visibleMaskByIndex* {.importc: "VisibleMaskByIndex".}: uint32Ptr
    settingsLoadedFlags* {.importc: "SettingsLoadedFlags".}: ImGuiTableFlags
    settingsOffset* {.importc: "SettingsOffset".}: int32
    lastFrameActive* {.importc: "LastFrameActive".}: int32
    columnsCount* {.importc: "ColumnsCount".}: int32
    currentRow* {.importc: "CurrentRow".}: int32
    currentColumn* {.importc: "CurrentColumn".}: int32
    instanceCurrent* {.importc: "InstanceCurrent".}: int16
    instanceInteracted* {.importc: "InstanceInteracted".}: int16
    rowPosY1* {.importc: "RowPosY1".}: float32
    rowPosY2* {.importc: "RowPosY2".}: float32
    rowMinHeight* {.importc: "RowMinHeight".}: float32
    rowCellPaddingY* {.importc: "RowCellPaddingY".}: float32
    rowTextBaseline* {.importc: "RowTextBaseline".}: float32
    rowIndentOffsetX* {.importc: "RowIndentOffsetX".}: float32
    rowFlags* {.importc: "RowFlags".}: ImGuiTableRowFlags
    lastRowFlags* {.importc: "LastRowFlags".}: ImGuiTableRowFlags
    rowBgColorCounter* {.importc: "RowBgColorCounter".}: int32
    rowBgColor* {.importc: "RowBgColor".}: array[2, uint32]
    borderColorStrong* {.importc: "BorderColorStrong".}: uint32
    borderColorLight* {.importc: "BorderColorLight".}: uint32
    borderX1* {.importc: "BorderX1".}: float32
    borderX2* {.importc: "BorderX2".}: float32
    hostIndentX* {.importc: "HostIndentX".}: float32
    minColumnWidth* {.importc: "MinColumnWidth".}: float32
    outerPaddingX* {.importc: "OuterPaddingX".}: float32
    cellPaddingX* {.importc: "CellPaddingX".}: float32
    cellSpacingX1* {.importc: "CellSpacingX1".}: float32
    cellSpacingX2* {.importc: "CellSpacingX2".}: float32
    innerWidth* {.importc: "InnerWidth".}: float32
    columnsGivenWidth* {.importc: "ColumnsGivenWidth".}: float32
    columnsAutoFitWidth* {.importc: "ColumnsAutoFitWidth".}: float32
    columnsStretchSumWeights* {.importc: "ColumnsStretchSumWeights".}: float32
    resizedColumnNextWidth* {.importc: "ResizedColumnNextWidth".}: float32
    resizeLockMinContentsX2* {.importc: "ResizeLockMinContentsX2".}: float32
    refScale* {.importc: "RefScale".}: float32
    outerRect* {.importc: "OuterRect".}: ImRect
    innerRect* {.importc: "InnerRect".}: ImRect
    workRect* {.importc: "WorkRect".}: ImRect
    innerClipRect* {.importc: "InnerClipRect".}: ImRect
    bgClipRect* {.importc: "BgClipRect".}: ImRect
    bg0ClipRectForDrawCmd* {.importc: "Bg0ClipRectForDrawCmd".}: ImRect
    bg2ClipRectForDrawCmd* {.importc: "Bg2ClipRectForDrawCmd".}: ImRect
    hostClipRect* {.importc: "HostClipRect".}: ImRect
    hostBackupInnerClipRect* {.importc: "HostBackupInnerClipRect".}: ImRect
    outerWindow* {.importc: "OuterWindow".}: ptr ImGuiWindow
    innerWindow* {.importc: "InnerWindow".}: ptr ImGuiWindow
    columnsNames* {.importc: "ColumnsNames".}: ImGuiTextBuffer
    drawSplitter* {.importc: "DrawSplitter".}: ptr ImDrawListSplitter
    instanceDataFirst* {.importc: "InstanceDataFirst".}: ImGuiTableInstanceData
    instanceDataExtra* {.importc: "InstanceDataExtra".}: ImVector[ImGuiTableInstanceData]
    sortSpecsSingle* {.importc: "SortSpecsSingle".}: ImGuiTableColumnSortSpecs
    sortSpecsMulti* {.importc: "SortSpecsMulti".}: ImVector[ImGuiTableColumnSortSpecs]
    sortSpecs* {.importc: "SortSpecs".}: ImGuiTableSortSpecs
    sortSpecsCount* {.importc: "SortSpecsCount".}: ImGuiTableColumnIdx
    columnsEnabledCount* {.importc: "ColumnsEnabledCount".}: ImGuiTableColumnIdx
    columnsEnabledFixedCount* {.importc: "ColumnsEnabledFixedCount".}: ImGuiTableColumnIdx
    declColumnsCount* {.importc: "DeclColumnsCount".}: ImGuiTableColumnIdx
    hoveredColumnBody* {.importc: "HoveredColumnBody".}: ImGuiTableColumnIdx
    hoveredColumnBorder* {.importc: "HoveredColumnBorder".}: ImGuiTableColumnIdx
    autoFitSingleColumn* {.importc: "AutoFitSingleColumn".}: ImGuiTableColumnIdx
    resizedColumn* {.importc: "ResizedColumn".}: ImGuiTableColumnIdx
    lastResizedColumn* {.importc: "LastResizedColumn".}: ImGuiTableColumnIdx
    heldHeaderColumn* {.importc: "HeldHeaderColumn".}: ImGuiTableColumnIdx
    reorderColumn* {.importc: "ReorderColumn".}: ImGuiTableColumnIdx
    reorderColumnDir* {.importc: "ReorderColumnDir".}: ImGuiTableColumnIdx
    leftMostEnabledColumn* {.importc: "LeftMostEnabledColumn".}: ImGuiTableColumnIdx
    rightMostEnabledColumn* {.importc: "RightMostEnabledColumn".}: ImGuiTableColumnIdx
    leftMostStretchedColumn* {.importc: "LeftMostStretchedColumn".}: ImGuiTableColumnIdx
    rightMostStretchedColumn* {.importc: "RightMostStretchedColumn".}: ImGuiTableColumnIdx
    contextPopupColumn* {.importc: "ContextPopupColumn".}: ImGuiTableColumnIdx
    freezeRowsRequest* {.importc: "FreezeRowsRequest".}: ImGuiTableColumnIdx
    freezeRowsCount* {.importc: "FreezeRowsCount".}: ImGuiTableColumnIdx
    freezeColumnsRequest* {.importc: "FreezeColumnsRequest".}: ImGuiTableColumnIdx
    freezeColumnsCount* {.importc: "FreezeColumnsCount".}: ImGuiTableColumnIdx
    rowCellDataCurrent* {.importc: "RowCellDataCurrent".}: ImGuiTableColumnIdx
    dummyDrawChannel* {.importc: "DummyDrawChannel".}: ImGuiTableDrawChannelIdx
    bg2DrawChannelCurrent* {.importc: "Bg2DrawChannelCurrent".}: ImGuiTableDrawChannelIdx
    bg2DrawChannelUnfrozen* {.importc: "Bg2DrawChannelUnfrozen".}: ImGuiTableDrawChannelIdx
    isLayoutLocked* {.importc: "IsLayoutLocked".}: bool
    isInsideRow* {.importc: "IsInsideRow".}: bool
    isInitializing* {.importc: "IsInitializing".}: bool
    isSortSpecsDirty* {.importc: "IsSortSpecsDirty".}: bool
    isUsingHeaders* {.importc: "IsUsingHeaders".}: bool
    isContextPopupOpen* {.importc: "IsContextPopupOpen".}: bool
    isSettingsRequestLoad* {.importc: "IsSettingsRequestLoad".}: bool
    isSettingsDirty* {.importc: "IsSettingsDirty".}: bool
    isDefaultDisplayOrder* {.importc: "IsDefaultDisplayOrder".}: bool
    isResetAllRequest* {.importc: "IsResetAllRequest".}: bool
    isResetDisplayOrderRequest* {.importc: "IsResetDisplayOrderRequest".}: bool
    isUnfrozenRows* {.importc: "IsUnfrozenRows".}: bool
    isDefaultSizingPolicy* {.importc: "IsDefaultSizingPolicy".}: bool
    hasScrollbarYCurr* {.importc: "HasScrollbarYCurr".}: bool
    hasScrollbarYPrev* {.importc: "HasScrollbarYPrev".}: bool
    memoryCompacted* {.importc: "MemoryCompacted".}: bool
    hostSkipItems* {.importc: "HostSkipItems".}: bool
  ImGuiTableCellData* {.importc: "ImGuiTableCellData", imgui_header.} = object
    bgColor* {.importc: "BgColor".}: uint32
    column* {.importc: "Column".}: ImGuiTableColumnIdx
  ImGuiTableColumn* {.importc: "ImGuiTableColumn", imgui_header.} = object
    flags* {.importc: "Flags".}: ImGuiTableColumnFlags
    widthGiven* {.importc: "WidthGiven".}: float32
    minX* {.importc: "MinX".}: float32
    maxX* {.importc: "MaxX".}: float32
    widthRequest* {.importc: "WidthRequest".}: float32
    widthAuto* {.importc: "WidthAuto".}: float32
    stretchWeight* {.importc: "StretchWeight".}: float32
    initStretchWeightOrWidth* {.importc: "InitStretchWeightOrWidth".}: float32
    clipRect* {.importc: "ClipRect".}: ImRect
    userID* {.importc: "UserID".}: ImGuiID
    workMinX* {.importc: "WorkMinX".}: float32
    workMaxX* {.importc: "WorkMaxX".}: float32
    itemWidth* {.importc: "ItemWidth".}: float32
    contentMaxXFrozen* {.importc: "ContentMaxXFrozen".}: float32
    contentMaxXUnfrozen* {.importc: "ContentMaxXUnfrozen".}: float32
    contentMaxXHeadersUsed* {.importc: "ContentMaxXHeadersUsed".}: float32
    contentMaxXHeadersIdeal* {.importc: "ContentMaxXHeadersIdeal".}: float32
    nameOffset* {.importc: "NameOffset".}: int16
    displayOrder* {.importc: "DisplayOrder".}: ImGuiTableColumnIdx
    indexWithinEnabledSet* {.importc: "IndexWithinEnabledSet".}: ImGuiTableColumnIdx
    prevEnabledColumn* {.importc: "PrevEnabledColumn".}: ImGuiTableColumnIdx
    nextEnabledColumn* {.importc: "NextEnabledColumn".}: ImGuiTableColumnIdx
    sortOrder* {.importc: "SortOrder".}: ImGuiTableColumnIdx
    drawChannelCurrent* {.importc: "DrawChannelCurrent".}: ImGuiTableDrawChannelIdx
    drawChannelFrozen* {.importc: "DrawChannelFrozen".}: ImGuiTableDrawChannelIdx
    drawChannelUnfrozen* {.importc: "DrawChannelUnfrozen".}: ImGuiTableDrawChannelIdx
    isEnabled* {.importc: "IsEnabled".}: bool
    isUserEnabled* {.importc: "IsUserEnabled".}: bool
    isUserEnabledNextFrame* {.importc: "IsUserEnabledNextFrame".}: bool
    isVisibleX* {.importc: "IsVisibleX".}: bool
    isVisibleY* {.importc: "IsVisibleY".}: bool
    isRequestOutput* {.importc: "IsRequestOutput".}: bool
    isSkipItems* {.importc: "IsSkipItems".}: bool
    isPreserveWidthAuto* {.importc: "IsPreserveWidthAuto".}: bool
    navLayerCurrent* {.importc: "NavLayerCurrent".}: int8
    autoFitQueue* {.importc: "AutoFitQueue".}: uint8
    cannotSkipItemsQueue* {.importc: "CannotSkipItemsQueue".}: uint8
    sortDirection* {.importc: "SortDirection".}: uint8
    sortDirectionsAvailCount* {.importc: "SortDirectionsAvailCount".}: uint8
    sortDirectionsAvailMask* {.importc: "SortDirectionsAvailMask".}: uint8
    sortDirectionsAvailList* {.importc: "SortDirectionsAvailList".}: uint8
  ImGuiTableColumnSettings* {.importc: "ImGuiTableColumnSettings", imgui_header.} = object
    widthOrWeight* {.importc: "WidthOrWeight".}: float32
    userID* {.importc: "UserID".}: ImGuiID
    index* {.importc: "Index".}: ImGuiTableColumnIdx
    displayOrder* {.importc: "DisplayOrder".}: ImGuiTableColumnIdx
    sortOrder* {.importc: "SortOrder".}: ImGuiTableColumnIdx
    sortDirection* {.importc: "SortDirection".}: uint8
    isEnabled* {.importc: "IsEnabled".}: uint8
    isStretch* {.importc: "IsStretch".}: uint8
  ImGuiTableColumnSortSpecs* {.importc: "ImGuiTableColumnSortSpecs", imgui_header.} = object
    columnUserID* {.importc: "ColumnUserID".}: ImGuiID
    columnIndex* {.importc: "ColumnIndex".}: int16
    sortOrder* {.importc: "SortOrder".}: int16
    sortDirection* {.importc: "SortDirection".}: ImGuiSortDirection
  ImGuiTableInstanceData* {.importc: "ImGuiTableInstanceData", imgui_header.} = object
    tableInstanceID* {.importc: "TableInstanceID".}: ImGuiID
    lastOuterHeight* {.importc: "LastOuterHeight".}: float32
    lastFirstRowHeight* {.importc: "LastFirstRowHeight".}: float32
    lastFrozenHeight* {.importc: "LastFrozenHeight".}: float32
    hoveredRowLast* {.importc: "HoveredRowLast".}: int32
    hoveredRowNext* {.importc: "HoveredRowNext".}: int32
  ImGuiTableSettings* {.importc: "ImGuiTableSettings", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    saveFlags* {.importc: "SaveFlags".}: ImGuiTableFlags
    refScale* {.importc: "RefScale".}: float32
    columnsCount* {.importc: "ColumnsCount".}: ImGuiTableColumnIdx
    columnsCountMax* {.importc: "ColumnsCountMax".}: ImGuiTableColumnIdx
    wantApply* {.importc: "WantApply".}: bool
  ImGuiTableSortSpecs* {.importc: "ImGuiTableSortSpecs", imgui_header.} = object
    specs* {.importc: "Specs".}: ptr ImGuiTableColumnSortSpecs
    specsCount* {.importc: "SpecsCount".}: int32
    specsDirty* {.importc: "SpecsDirty".}: bool
  ImGuiTableTempData* {.importc: "ImGuiTableTempData", imgui_header.} = object
    tableIndex* {.importc: "TableIndex".}: int32
    lastTimeActive* {.importc: "LastTimeActive".}: float32
    userOuterSize* {.importc: "UserOuterSize".}: ImVec2
    drawSplitter* {.importc: "DrawSplitter".}: ImDrawListSplitter
    hostBackupWorkRect* {.importc: "HostBackupWorkRect".}: ImRect
    hostBackupParentWorkRect* {.importc: "HostBackupParentWorkRect".}: ImRect
    hostBackupPrevLineSize* {.importc: "HostBackupPrevLineSize".}: ImVec2
    hostBackupCurrLineSize* {.importc: "HostBackupCurrLineSize".}: ImVec2
    hostBackupCursorMaxPos* {.importc: "HostBackupCursorMaxPos".}: ImVec2
    hostBackupColumnsOffset* {.importc: "HostBackupColumnsOffset".}: ImVec1
    hostBackupItemWidth* {.importc: "HostBackupItemWidth".}: float32
    hostBackupItemWidthStackSize* {.importc: "HostBackupItemWidthStackSize".}: int32
  ImGuiTextBuffer* {.importc: "ImGuiTextBuffer", imgui_header.} = object
    buf* {.importc: "Buf".}: ImVector[int8]
  ImGuiTextFilter* {.importc: "ImGuiTextFilter", imgui_header.} = object
    inputBuf* {.importc: "InputBuf".}: array[256, int8]
    filters* {.importc: "Filters".}: ImVector[ImGuiTextRange]
    countGrep* {.importc: "CountGrep".}: int32
  ImGuiTextIndex* {.importc: "ImGuiTextIndex", imgui_header.} = object
    lineOffsets* {.importc: "LineOffsets".}: ImVector[int32]
    endOffset* {.importc: "EndOffset".}: int32
  ImGuiTextRange* {.importc: "ImGuiTextRange", imgui_header.} = object
    b* {.importc: "b".}: cstring
    e* {.importc: "e".}: cstring
  ImGuiViewport* {.importc: "ImGuiViewport", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    flags* {.importc: "Flags".}: ImGuiViewportFlags
    pos* {.importc: "Pos".}: ImVec2
    size* {.importc: "Size".}: ImVec2
    workPos* {.importc: "WorkPos".}: ImVec2
    workSize* {.importc: "WorkSize".}: ImVec2
    dpiScale* {.importc: "DpiScale".}: float32
    parentViewportId* {.importc: "ParentViewportId".}: ImGuiID
    drawData* {.importc: "DrawData".}: ptr ImDrawData
    rendererUserData* {.importc: "RendererUserData".}: pointer
    platformUserData* {.importc: "PlatformUserData".}: pointer
    platformHandle* {.importc: "PlatformHandle".}: pointer
    platformHandleRaw* {.importc: "PlatformHandleRaw".}: pointer
    platformWindowCreated* {.importc: "PlatformWindowCreated".}: bool
    platformRequestMove* {.importc: "PlatformRequestMove".}: bool
    platformRequestResize* {.importc: "PlatformRequestResize".}: bool
    platformRequestClose* {.importc: "PlatformRequestClose".}: bool
  ImGuiViewportP* {.importc: "ImGuiViewportP", imgui_header.} = object
    imGuiViewport* {.importc: "_ImGuiViewport".}: ImGuiViewport
    window* {.importc: "Window".}: ptr ImGuiWindow
    idx* {.importc: "Idx".}: int32
    lastFrameActive* {.importc: "LastFrameActive".}: int32
    lastFocusedStampCount* {.importc: "LastFocusedStampCount".}: int32
    lastNameHash* {.importc: "LastNameHash".}: ImGuiID
    lastPos* {.importc: "LastPos".}: ImVec2
    alpha* {.importc: "Alpha".}: float32
    lastAlpha* {.importc: "LastAlpha".}: float32
    lastFocusedHadNavWindow* {.importc: "LastFocusedHadNavWindow".}: bool
    platformMonitor* {.importc: "PlatformMonitor".}: int16
    bgFgDrawListsLastFrame* {.importc: "BgFgDrawListsLastFrame".}: array[2, int32]
    bgFgDrawLists* {.importc: "BgFgDrawLists".}: array[2, ptr ImDrawList]
    drawDataP* {.importc: "DrawDataP".}: ImDrawData
    drawDataBuilder* {.importc: "DrawDataBuilder".}: ImDrawDataBuilder
    lastPlatformPos* {.importc: "LastPlatformPos".}: ImVec2
    lastPlatformSize* {.importc: "LastPlatformSize".}: ImVec2
    lastRendererSize* {.importc: "LastRendererSize".}: ImVec2
    workOffsetMin* {.importc: "WorkOffsetMin".}: ImVec2
    workOffsetMax* {.importc: "WorkOffsetMax".}: ImVec2
    buildWorkOffsetMin* {.importc: "BuildWorkOffsetMin".}: ImVec2
    buildWorkOffsetMax* {.importc: "BuildWorkOffsetMax".}: ImVec2
  ImGuiWindow* {.importc: "ImGuiWindow", imgui_header.} = object
    ctx* {.importc: "Ctx".}: ptr ImGuiContext
    name* {.importc: "Name".}: cstring
    id* {.importc: "ID".}: ImGuiID
    flags* {.importc: "Flags".}: ImGuiWindowFlags
    flagsPreviousFrame* {.importc: "FlagsPreviousFrame".}: ImGuiWindowFlags
    windowClass* {.importc: "WindowClass".}: ImGuiWindowClass
    viewport* {.importc: "Viewport".}: ptr ImGuiViewportP
    viewportId* {.importc: "ViewportId".}: ImGuiID
    viewportPos* {.importc: "ViewportPos".}: ImVec2
    viewportAllowPlatformMonitorExtend* {.importc: "ViewportAllowPlatformMonitorExtend".}: int32
    pos* {.importc: "Pos".}: ImVec2
    size* {.importc: "Size".}: ImVec2
    sizeFull* {.importc: "SizeFull".}: ImVec2
    contentSize* {.importc: "ContentSize".}: ImVec2
    contentSizeIdeal* {.importc: "ContentSizeIdeal".}: ImVec2
    contentSizeExplicit* {.importc: "ContentSizeExplicit".}: ImVec2
    windowPadding* {.importc: "WindowPadding".}: ImVec2
    windowRounding* {.importc: "WindowRounding".}: float32
    windowBorderSize* {.importc: "WindowBorderSize".}: float32
    decoOuterSizeX1* {.importc: "DecoOuterSizeX1".}: float32
    decoOuterSizeY1* {.importc: "DecoOuterSizeY1".}: float32
    decoOuterSizeX2* {.importc: "DecoOuterSizeX2".}: float32
    decoOuterSizeY2* {.importc: "DecoOuterSizeY2".}: float32
    decoInnerSizeX1* {.importc: "DecoInnerSizeX1".}: float32
    decoInnerSizeY1* {.importc: "DecoInnerSizeY1".}: float32
    nameBufLen* {.importc: "NameBufLen".}: int32
    moveId* {.importc: "MoveId".}: ImGuiID
    tabId* {.importc: "TabId".}: ImGuiID
    childId* {.importc: "ChildId".}: ImGuiID
    scroll* {.importc: "Scroll".}: ImVec2
    scrollMax* {.importc: "ScrollMax".}: ImVec2
    scrollTarget* {.importc: "ScrollTarget".}: ImVec2
    scrollTargetCenterRatio* {.importc: "ScrollTargetCenterRatio".}: ImVec2
    scrollTargetEdgeSnapDist* {.importc: "ScrollTargetEdgeSnapDist".}: ImVec2
    scrollbarSizes* {.importc: "ScrollbarSizes".}: ImVec2
    scrollbarX* {.importc: "ScrollbarX".}: bool
    scrollbarY* {.importc: "ScrollbarY".}: bool
    viewportOwned* {.importc: "ViewportOwned".}: bool
    active* {.importc: "Active".}: bool
    wasActive* {.importc: "WasActive".}: bool
    writeAccessed* {.importc: "WriteAccessed".}: bool
    collapsed* {.importc: "Collapsed".}: bool
    wantCollapseToggle* {.importc: "WantCollapseToggle".}: bool
    skipItems* {.importc: "SkipItems".}: bool
    appearing* {.importc: "Appearing".}: bool
    hidden* {.importc: "Hidden".}: bool
    isFallbackWindow* {.importc: "IsFallbackWindow".}: bool
    isExplicitChild* {.importc: "IsExplicitChild".}: bool
    hasCloseButton* {.importc: "HasCloseButton".}: bool
    resizeBorderHeld* {.importc: "ResizeBorderHeld".}: int8
    beginCount* {.importc: "BeginCount".}: int16
    beginCountPreviousFrame* {.importc: "BeginCountPreviousFrame".}: int16
    beginOrderWithinParent* {.importc: "BeginOrderWithinParent".}: int16
    beginOrderWithinContext* {.importc: "BeginOrderWithinContext".}: int16
    focusOrder* {.importc: "FocusOrder".}: int16
    popupId* {.importc: "PopupId".}: ImGuiID
    autoFitFramesX* {.importc: "AutoFitFramesX".}: int8
    autoFitFramesY* {.importc: "AutoFitFramesY".}: int8
    autoFitChildAxises* {.importc: "AutoFitChildAxises".}: int8
    autoFitOnlyGrows* {.importc: "AutoFitOnlyGrows".}: bool
    autoPosLastDirection* {.importc: "AutoPosLastDirection".}: ImGuiDir
    hiddenFramesCanSkipItems* {.importc: "HiddenFramesCanSkipItems".}: int8
    hiddenFramesCannotSkipItems* {.importc: "HiddenFramesCannotSkipItems".}: int8
    hiddenFramesForRenderOnly* {.importc: "HiddenFramesForRenderOnly".}: int8
    disableInputsFrames* {.importc: "DisableInputsFrames".}: int8
    setWindowPosAllowFlags* {.importc: "SetWindowPosAllowFlags".}: ImGuiCond
    setWindowSizeAllowFlags* {.importc: "SetWindowSizeAllowFlags".}: ImGuiCond
    setWindowCollapsedAllowFlags* {.importc: "SetWindowCollapsedAllowFlags".}: ImGuiCond
    setWindowDockAllowFlags* {.importc: "SetWindowDockAllowFlags".}: ImGuiCond
    setWindowPosVal* {.importc: "SetWindowPosVal".}: ImVec2
    setWindowPosPivot* {.importc: "SetWindowPosPivot".}: ImVec2
    iDStack* {.importc: "IDStack".}: ImVector[ImGuiID]
    dc* {.importc: "DC".}: ImGuiWindowTempData
    outerRectClipped* {.importc: "OuterRectClipped".}: ImRect
    innerRect* {.importc: "InnerRect".}: ImRect
    innerClipRect* {.importc: "InnerClipRect".}: ImRect
    workRect* {.importc: "WorkRect".}: ImRect
    parentWorkRect* {.importc: "ParentWorkRect".}: ImRect
    clipRect* {.importc: "ClipRect".}: ImRect
    contentRegionRect* {.importc: "ContentRegionRect".}: ImRect
    hitTestHoleSize* {.importc: "HitTestHoleSize".}: ImVec2ih
    hitTestHoleOffset* {.importc: "HitTestHoleOffset".}: ImVec2ih
    lastFrameActive* {.importc: "LastFrameActive".}: int32
    lastFrameJustFocused* {.importc: "LastFrameJustFocused".}: int32
    lastTimeActive* {.importc: "LastTimeActive".}: float32
    itemWidthDefault* {.importc: "ItemWidthDefault".}: float32
    stateStorage* {.importc: "StateStorage".}: ImGuiStorage
    columnsStorage* {.importc: "ColumnsStorage".}: ImVector[ImGuiOldColumns]
    fontWindowScale* {.importc: "FontWindowScale".}: float32
    fontDpiScale* {.importc: "FontDpiScale".}: float32
    settingsOffset* {.importc: "SettingsOffset".}: int32
    drawList* {.importc: "DrawList".}: ptr ImDrawList
    drawListInst* {.importc: "DrawListInst".}: ImDrawList
    parentWindow* {.importc: "ParentWindow".}: ptr ImGuiWindow
    parentWindowInBeginStack* {.importc: "ParentWindowInBeginStack".}: ptr ImGuiWindow
    rootWindow* {.importc: "RootWindow".}: ptr ImGuiWindow
    rootWindowPopupTree* {.importc: "RootWindowPopupTree".}: ptr ImGuiWindow
    rootWindowDockTree* {.importc: "RootWindowDockTree".}: ptr ImGuiWindow
    rootWindowForTitleBarHighlight* {.importc: "RootWindowForTitleBarHighlight".}: ptr ImGuiWindow
    rootWindowForNav* {.importc: "RootWindowForNav".}: ptr ImGuiWindow
    navLastChildNavWindow* {.importc: "NavLastChildNavWindow".}: ptr ImGuiWindow
    navLastIds* {.importc: "NavLastIds".}: array[2, ImGuiID]
    navRectRel* {.importc: "NavRectRel".}: array[2, ImRect]
    navPreferredScoringPosRel* {.importc: "NavPreferredScoringPosRel".}: array[2, ImVec2]
    navRootFocusScopeId* {.importc: "NavRootFocusScopeId".}: ImGuiID
    memoryDrawListIdxCapacity* {.importc: "MemoryDrawListIdxCapacity".}: int32
    memoryDrawListVtxCapacity* {.importc: "MemoryDrawListVtxCapacity".}: int32
    memoryCompacted* {.importc: "MemoryCompacted".}: bool
    dockIsActive* {.importc: "DockIsActive".}: bool
    dockNodeIsVisible* {.importc: "DockNodeIsVisible".}: bool
    dockTabIsVisible* {.importc: "DockTabIsVisible".}: bool
    dockTabWantClose* {.importc: "DockTabWantClose".}: bool
    dockOrder* {.importc: "DockOrder".}: int16
    dockStyle* {.importc: "DockStyle".}: ImGuiWindowDockStyle
    dockNode* {.importc: "DockNode".}: ptr ImGuiDockNode
    dockNodeAsHost* {.importc: "DockNodeAsHost".}: ptr ImGuiDockNode
    dockId* {.importc: "DockId".}: ImGuiID
    dockTabItemStatusFlags* {.importc: "DockTabItemStatusFlags".}: ImGuiItemStatusFlags
    dockTabItemRect* {.importc: "DockTabItemRect".}: ImRect
  ImGuiWindowClass* {.importc: "ImGuiWindowClass", imgui_header.} = object
    classId* {.importc: "ClassId".}: ImGuiID
    parentViewportId* {.importc: "ParentViewportId".}: ImGuiID
    viewportFlagsOverrideSet* {.importc: "ViewportFlagsOverrideSet".}: ImGuiViewportFlags
    viewportFlagsOverrideClear* {.importc: "ViewportFlagsOverrideClear".}: ImGuiViewportFlags
    tabItemFlagsOverrideSet* {.importc: "TabItemFlagsOverrideSet".}: ImGuiTabItemFlags
    dockNodeFlagsOverrideSet* {.importc: "DockNodeFlagsOverrideSet".}: ImGuiDockNodeFlags
    dockingAlwaysTabBar* {.importc: "DockingAlwaysTabBar".}: bool
    dockingAllowUnclassed* {.importc: "DockingAllowUnclassed".}: bool
  ImGuiWindowDockStyle* {.importc: "ImGuiWindowDockStyle", imgui_header.} = object
    colors* {.importc: "Colors".}: array[6, uint32]
  ImGuiWindowSettings* {.importc: "ImGuiWindowSettings", imgui_header.} = object
    id* {.importc: "ID".}: ImGuiID
    pos* {.importc: "Pos".}: ImVec2ih
    size* {.importc: "Size".}: ImVec2ih
    viewportPos* {.importc: "ViewportPos".}: ImVec2ih
    viewportId* {.importc: "ViewportId".}: ImGuiID
    dockId* {.importc: "DockId".}: ImGuiID
    classId* {.importc: "ClassId".}: ImGuiID
    dockOrder* {.importc: "DockOrder".}: int16
    collapsed* {.importc: "Collapsed".}: bool
    wantApply* {.importc: "WantApply".}: bool
    wantDelete* {.importc: "WantDelete".}: bool
  ImGuiWindowStackData* {.importc: "ImGuiWindowStackData", imgui_header.} = object
    window* {.importc: "Window".}: ptr ImGuiWindow
    parentLastItemDataBackup* {.importc: "ParentLastItemDataBackup".}: ImGuiLastItemData
    stackSizesOnBegin* {.importc: "StackSizesOnBegin".}: ImGuiStackSizes
  ImGuiWindowTempData* {.importc: "ImGuiWindowTempData", imgui_header.} = object
    cursorPos* {.importc: "CursorPos".}: ImVec2
    cursorPosPrevLine* {.importc: "CursorPosPrevLine".}: ImVec2
    cursorStartPos* {.importc: "CursorStartPos".}: ImVec2
    cursorMaxPos* {.importc: "CursorMaxPos".}: ImVec2
    idealMaxPos* {.importc: "IdealMaxPos".}: ImVec2
    currLineSize* {.importc: "CurrLineSize".}: ImVec2
    prevLineSize* {.importc: "PrevLineSize".}: ImVec2
    currLineTextBaseOffset* {.importc: "CurrLineTextBaseOffset".}: float32
    prevLineTextBaseOffset* {.importc: "PrevLineTextBaseOffset".}: float32
    isSameLine* {.importc: "IsSameLine".}: bool
    isSetPos* {.importc: "IsSetPos".}: bool
    indent* {.importc: "Indent".}: ImVec1
    columnsOffset* {.importc: "ColumnsOffset".}: ImVec1
    groupOffset* {.importc: "GroupOffset".}: ImVec1
    cursorStartPosLossyness* {.importc: "CursorStartPosLossyness".}: ImVec2
    navLayerCurrent* {.importc: "NavLayerCurrent".}: ImGuiNavLayer
    navLayersActiveMask* {.importc: "NavLayersActiveMask".}: int16
    navLayersActiveMaskNext* {.importc: "NavLayersActiveMaskNext".}: int16
    navIsScrollPushableX* {.importc: "NavIsScrollPushableX".}: bool
    navHideHighlightOneFrame* {.importc: "NavHideHighlightOneFrame".}: bool
    navWindowHasScrollY* {.importc: "NavWindowHasScrollY".}: bool
    menuBarAppending* {.importc: "MenuBarAppending".}: bool
    menuBarOffset* {.importc: "MenuBarOffset".}: ImVec2
    menuColumns* {.importc: "MenuColumns".}: ImGuiMenuColumns
    treeDepth* {.importc: "TreeDepth".}: int32
    treeJumpToParentOnPopMask* {.importc: "TreeJumpToParentOnPopMask".}: uint32
    childWindows* {.importc: "ChildWindows".}: ImVector[ptr ImGuiWindow]
    stateStorage* {.importc: "StateStorage".}: ptr ImGuiStorage
    currentColumns* {.importc: "CurrentColumns".}: ptr ImGuiOldColumns
    currentTableIdx* {.importc: "CurrentTableIdx".}: int32
    layoutType* {.importc: "LayoutType".}: ImGuiLayoutType
    parentLayoutType* {.importc: "ParentLayoutType".}: ImGuiLayoutType
    itemWidth* {.importc: "ItemWidth".}: float32
    textWrapPos* {.importc: "TextWrapPos".}: float32
    itemWidthStack* {.importc: "ItemWidthStack".}: ImVector[float32]
    textWrapPosStack* {.importc: "TextWrapPosStack".}: ImVector[float32]
  ImRect* {.importc: "ImRect", imgui_header.} = object
    min* {.importc: "Min".}: ImVec2
    max* {.importc: "Max".}: ImVec2
  ImVec1* {.importc: "ImVec1", imgui_header.} = object
    x* {.importc: "x".}: float32
  ImVec2* {.importc: "ImVec2", imgui_header.} = object
    x* {.importc: "x".}: float32
    y* {.importc: "y".}: float32
  ImVec2ih* {.importc: "ImVec2ih", imgui_header.} = object
    x* {.importc: "x".}: int16
    y* {.importc: "y".}: int16
  ImVec4* {.importc: "ImVec4", imgui_header.} = object
    x* {.importc: "x".}: float32
    y* {.importc: "y".}: float32
    z* {.importc: "z".}: float32
    w* {.importc: "w".}: float32
  STB_TexteditState* {.importc: "STB_TexteditState", imgui_header.} = object
    cursor* {.importc: "cursor".}: int32
    select_start* {.importc: "select_start".}: int32
    select_end* {.importc: "select_end".}: int32
    insert_mode* {.importc: "insert_mode".}: uint8
    row_count_per_page* {.importc: "row_count_per_page".}: int32
    cursor_at_end_of_line* {.importc: "cursor_at_end_of_line".}: uint8
    initialized* {.importc: "initialized".}: uint8
    has_preferred_x* {.importc: "has_preferred_x".}: uint8
    single_line* {.importc: "single_line".}: uint8
    padding1* {.importc: "padding1".}: uint8
    padding2* {.importc: "padding2".}: uint8
    padding3* {.importc: "padding3".}: uint8
    preferred_x* {.importc: "preferred_x".}: float32
    undostate* {.importc: "undostate".}: StbUndoState
  StbTexteditRow* {.importc: "StbTexteditRow", imgui_header.} = object
    x0* {.importc: "x0".}: float32
    x1* {.importc: "x1".}: float32
    baseline_y_delta* {.importc: "baseline_y_delta".}: float32
    ymin* {.importc: "ymin".}: float32
    ymax* {.importc: "ymax".}: float32
    num_chars* {.importc: "num_chars".}: int32
  StbUndoRecord* {.importc: "StbUndoRecord", imgui_header.} = object
    where* {.importc: "where".}: int32
    insert_length* {.importc: "insert_length".}: int32
    delete_length* {.importc: "delete_length".}: int32
    char_storage* {.importc: "char_storage".}: int32
  StbUndoState* {.importc: "StbUndoState", imgui_header.} = object
    undo_rec* {.importc: "undo_rec".}: array[99, StbUndoRecord]
    undo_char* {.importc: "undo_char".}: array[999, ImWchar]
    undo_point* {.importc: "undo_point".}: int16
    redo_point* {.importc: "redo_point".}: int16
    undo_char_point* {.importc: "undo_char_point".}: int32
    redo_char_point* {.importc: "redo_char_point".}: int32

# Procs
{.push warning[HoleEnumConv]: off.}
when not defined(cpp) or defined(cimguiDLL):
  {.push dynlib: imgui_dll, cdecl, discardable.}
else:
  {.push nodecl, discardable,header: currentSourceDir() & "/imgui/private/ncimgui.h".}

proc clearAllBits*(self: ptr uint32): void {.importc: "ImBitArray_ClearAllBits".}
proc clearBit*(self: ptr uint32, n: int32): void {.importc: "ImBitArray_ClearBit".}
proc newImBitArray*(): ptr ImBitArrayPtr {.importc: "ImBitArray_ImBitArray".}
proc setAllBits*(self: ptr uint32): void {.importc: "ImBitArray_SetAllBits".}
proc setBit*(self: ptr uint32, n: int32): void {.importc: "ImBitArray_SetBit".}
proc setBitRange*(self: ptr uint32, n: int32, n2: int32): void {.importc: "ImBitArray_SetBitRange".}
proc testBit*(self: ptr uint32, n: int32): bool {.importc: "ImBitArray_TestBit".}
proc destroy*(self: ptr uint32): void {.importc: "ImBitArray_destroy".}
proc clear*(self: ptr ImBitVector): void {.importc: "ImBitVector_Clear".}
proc clearBit*(self: ptr ImBitVector, n: int32): void {.importc: "ImBitVector_ClearBit".}
proc create*(self: ptr ImBitVector, sz: int32): void {.importc: "ImBitVector_Create".}
proc setBit*(self: ptr ImBitVector, n: int32): void {.importc: "ImBitVector_SetBit".}
proc testBit*(self: ptr ImBitVector, n: int32): bool {.importc: "ImBitVector_TestBit".}
proc alloc_chunk*[T](self: ptr ImChunkStream, sz: uint): ptr T {.importc: "ImChunkStream_alloc_chunk".}
proc begin*[T](self: ptr ImChunkStream): ptr T {.importc: "ImChunkStream_begin".}
proc chunk_size*[T](self: ptr ImChunkStream, p: ptr T): int32 {.importc: "ImChunkStream_chunk_size".}
proc clear*(self: ptr ImChunkStream): void {.importc: "ImChunkStream_clear".}
proc empty*(self: ptr ImChunkStream): bool {.importc: "ImChunkStream_empty".}
proc `end`*[T](self: ptr ImChunkStream): ptr T {.importc: "ImChunkStream_end".}
proc next_chunk*[T](self: ptr ImChunkStream, p: ptr T): ptr T {.importc: "ImChunkStream_next_chunk".}
proc offset_from_ptr*[T](self: ptr ImChunkStream, p: ptr T): int32 {.importc: "ImChunkStream_offset_from_ptr".}
proc ptr_from_offset*[T](self: ptr ImChunkStream, off: int32): ptr T {.importc: "ImChunkStream_ptr_from_offset".}
proc size*(self: ptr ImChunkStream): int32 {.importc: "ImChunkStream_size".}
proc swap*(self: ptr ImChunkStream, rhs: ptr ImChunkStream): void {.importc: "ImChunkStream_swap".}
proc hSVNonUDT*(pOut: ptr ImColor, h: float32, s: float32, v: float32, a: float32 = 1.0f): void {.importc: "ImColor_HSV".}
proc newImColor*(): ptr ImColor {.importc: "ImColor_ImColor_Nil".}
proc newImColor*(r: float32, g: float32, b: float32, a: float32 = 1.0f): ptr ImColor {.importc: "ImColor_ImColor_Float".}
proc newImColor*(col: ImVec4): ptr ImColor {.importc: "ImColor_ImColor_Vec4".}
proc newImColor*(r: int32, g: int32, b: int32, a: int32 = 255): ptr ImColor {.importc: "ImColor_ImColor_Int".}
proc newImColor*(rgba: uint32): ptr ImColor {.importc: "ImColor_ImColor_U32".}
proc setHSV*(self: ptr ImColor, h: float32, s: float32, v: float32, a: float32 = 1.0f): void {.importc: "ImColor_SetHSV".}
proc destroy*(self: ptr ImColor): void {.importc: "ImColor_destroy".}
proc getTexID*(self: ptr ImDrawCmd): ImTextureID {.importc: "ImDrawCmd_GetTexID".}
proc newImDrawCmd*(): ptr ImDrawCmd {.importc: "ImDrawCmd_ImDrawCmd".}
proc destroy*(self: ptr ImDrawCmd): void {.importc: "ImDrawCmd_destroy".}
proc newImDrawDataBuilder*(): ptr ImDrawDataBuilder {.importc: "ImDrawDataBuilder_ImDrawDataBuilder".}
proc destroy*(self: ptr ImDrawDataBuilder): void {.importc: "ImDrawDataBuilder_destroy".}
proc addDrawList*(self: ptr ImDrawData, draw_list: ptr ImDrawList): void {.importc: "ImDrawData_AddDrawList".}
proc clear*(self: ptr ImDrawData): void {.importc: "ImDrawData_Clear".}
proc deIndexAllBuffers*(self: ptr ImDrawData): void {.importc: "ImDrawData_DeIndexAllBuffers".}
proc newImDrawData*(): ptr ImDrawData {.importc: "ImDrawData_ImDrawData".}
proc scaleClipRects*(self: ptr ImDrawData, fb_scale: ImVec2): void {.importc: "ImDrawData_ScaleClipRects".}
proc destroy*(self: ptr ImDrawData): void {.importc: "ImDrawData_destroy".}
proc newImDrawListSharedData*(): ptr ImDrawListSharedData {.importc: "ImDrawListSharedData_ImDrawListSharedData".}
proc setCircleTessellationMaxError*(self: ptr ImDrawListSharedData, max_error: float32): void {.importc: "ImDrawListSharedData_SetCircleTessellationMaxError".}
proc destroy*(self: ptr ImDrawListSharedData): void {.importc: "ImDrawListSharedData_destroy".}
proc clear*(self: ptr ImDrawListSplitter): void {.importc: "ImDrawListSplitter_Clear".}
proc clearFreeMemory*(self: ptr ImDrawListSplitter): void {.importc: "ImDrawListSplitter_ClearFreeMemory".}
proc newImDrawListSplitter*(): ptr ImDrawListSplitter {.importc: "ImDrawListSplitter_ImDrawListSplitter".}
proc merge*(self: ptr ImDrawListSplitter, draw_list: ptr ImDrawList): void {.importc: "ImDrawListSplitter_Merge".}
proc setCurrentChannel*(self: ptr ImDrawListSplitter, draw_list: ptr ImDrawList, channel_idx: int32): void {.importc: "ImDrawListSplitter_SetCurrentChannel".}
proc split*(self: ptr ImDrawListSplitter, draw_list: ptr ImDrawList, count: int32): void {.importc: "ImDrawListSplitter_Split".}
proc destroy*(self: ptr ImDrawListSplitter): void {.importc: "ImDrawListSplitter_destroy".}
proc addBezierCubic*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: uint32, thickness: float32, num_segments: int32 = 0): void {.importc: "ImDrawList_AddBezierCubic".}
proc addBezierQuadratic*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: uint32, thickness: float32, num_segments: int32 = 0): void {.importc: "ImDrawList_AddBezierQuadratic".}
proc addCallback*(self: ptr ImDrawList, callback: ImDrawCallback, callback_data: pointer): void {.importc: "ImDrawList_AddCallback".}
proc addCircle*(self: ptr ImDrawList, center: ImVec2, radius: float32, col: uint32, num_segments: int32 = 0, thickness: float32 = 1.0f): void {.importc: "ImDrawList_AddCircle".}
proc addCircleFilled*(self: ptr ImDrawList, center: ImVec2, radius: float32, col: uint32, num_segments: int32 = 0): void {.importc: "ImDrawList_AddCircleFilled".}
proc addConvexPolyFilled*(self: ptr ImDrawList, points: ptr ImVec2, num_points: int32, col: uint32): void {.importc: "ImDrawList_AddConvexPolyFilled".}
proc addDrawCmd*(self: ptr ImDrawList): void {.importc: "ImDrawList_AddDrawCmd".}
proc addImage*(self: ptr ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2 = ImVec2(x: 0, y: 0), uv_max: ImVec2 = ImVec2(x: 1, y: 1), col: uint32 = high(uint32)): void {.importc: "ImDrawList_AddImage".}
proc addImageQuad*(self: ptr ImDrawList, user_texture_id: ImTextureID, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, uv1: ImVec2 = ImVec2(x: 0, y: 0), uv2: ImVec2 = ImVec2(x: 1, y: 0), uv3: ImVec2 = ImVec2(x: 1, y: 1), uv4: ImVec2 = ImVec2(x: 0, y: 1), col: uint32 = high(uint32)): void {.importc: "ImDrawList_AddImageQuad".}
proc addImageRounded*(self: ptr ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: uint32, rounding: float32, flags: ImDrawFlags = 0.ImDrawFlags): void {.importc: "ImDrawList_AddImageRounded".}
proc addLine*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, col: uint32, thickness: float32 = 1.0f): void {.importc: "ImDrawList_AddLine".}
proc addNgon*(self: ptr ImDrawList, center: ImVec2, radius: float32, col: uint32, num_segments: int32, thickness: float32 = 1.0f): void {.importc: "ImDrawList_AddNgon".}
proc addNgonFilled*(self: ptr ImDrawList, center: ImVec2, radius: float32, col: uint32, num_segments: int32): void {.importc: "ImDrawList_AddNgonFilled".}
proc addPolyline*(self: ptr ImDrawList, points: ptr ImVec2, num_points: int32, col: uint32, flags: ImDrawFlags, thickness: float32): void {.importc: "ImDrawList_AddPolyline".}
proc addQuad*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: uint32, thickness: float32 = 1.0f): void {.importc: "ImDrawList_AddQuad".}
proc addQuadFilled*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: uint32): void {.importc: "ImDrawList_AddQuadFilled".}
proc addRect*(self: ptr ImDrawList, p_min: ImVec2, p_max: ImVec2, col: uint32, rounding: float32 = 0.0f, flags: ImDrawFlags = 0.ImDrawFlags, thickness: float32 = 1.0f): void {.importc: "ImDrawList_AddRect".}
proc addRectFilled*(self: ptr ImDrawList, p_min: ImVec2, p_max: ImVec2, col: uint32, rounding: float32 = 0.0f, flags: ImDrawFlags = 0.ImDrawFlags): void {.importc: "ImDrawList_AddRectFilled".}
proc addRectFilledMultiColor*(self: ptr ImDrawList, p_min: ImVec2, p_max: ImVec2, col_upr_left: uint32, col_upr_right: uint32, col_bot_right: uint32, col_bot_left: uint32): void {.importc: "ImDrawList_AddRectFilledMultiColor".}
proc addText*(self: ptr ImDrawList, pos: ImVec2, col: uint32, text_begin: cstring, text_end: cstring = nil): void {.importc: "ImDrawList_AddText_Vec2".}
proc addText*(self: ptr ImDrawList, font: ptr ImFont, font_size: float32, pos: ImVec2, col: uint32, text_begin: cstring, text_end: cstring = nil, wrap_width: float32 = 0.0f, cpu_fine_clip_rect: ptr ImVec4 = nil): void {.importc: "ImDrawList_AddText_FontPtr".}
proc addTriangle*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: uint32, thickness: float32 = 1.0f): void {.importc: "ImDrawList_AddTriangle".}
proc addTriangleFilled*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: uint32): void {.importc: "ImDrawList_AddTriangleFilled".}
proc channelsMerge*(self: ptr ImDrawList): void {.importc: "ImDrawList_ChannelsMerge".}
proc channelsSetCurrent*(self: ptr ImDrawList, n: int32): void {.importc: "ImDrawList_ChannelsSetCurrent".}
proc channelsSplit*(self: ptr ImDrawList, count: int32): void {.importc: "ImDrawList_ChannelsSplit".}
proc cloneOutput*(self: ptr ImDrawList): ptr ImDrawList {.importc: "ImDrawList_CloneOutput".}
proc getClipRectMaxNonUDT*(pOut: ptr ImVec2, self: ptr ImDrawList): void {.importc: "ImDrawList_GetClipRectMax".}
proc getClipRectMinNonUDT*(pOut: ptr ImVec2, self: ptr ImDrawList): void {.importc: "ImDrawList_GetClipRectMin".}
proc newImDrawList*(shared_data: ptr ImDrawListSharedData): ptr ImDrawList {.importc: "ImDrawList_ImDrawList".}
proc pathArcTo*(self: ptr ImDrawList, center: ImVec2, radius: float32, a_min: float32, a_max: float32, num_segments: int32 = 0): void {.importc: "ImDrawList_PathArcTo".}
proc pathArcToFast*(self: ptr ImDrawList, center: ImVec2, radius: float32, a_min_of_12: int32, a_max_of_12: int32): void {.importc: "ImDrawList_PathArcToFast".}
proc pathBezierCubicCurveTo*(self: ptr ImDrawList, p2: ImVec2, p3: ImVec2, p4: ImVec2, num_segments: int32 = 0): void {.importc: "ImDrawList_PathBezierCubicCurveTo".}
proc pathBezierQuadraticCurveTo*(self: ptr ImDrawList, p2: ImVec2, p3: ImVec2, num_segments: int32 = 0): void {.importc: "ImDrawList_PathBezierQuadraticCurveTo".}
proc pathClear*(self: ptr ImDrawList): void {.importc: "ImDrawList_PathClear".}
proc pathFillConvex*(self: ptr ImDrawList, col: uint32): void {.importc: "ImDrawList_PathFillConvex".}
proc pathLineTo*(self: ptr ImDrawList, pos: ImVec2): void {.importc: "ImDrawList_PathLineTo".}
proc pathLineToMergeDuplicate*(self: ptr ImDrawList, pos: ImVec2): void {.importc: "ImDrawList_PathLineToMergeDuplicate".}
proc pathRect*(self: ptr ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: float32 = 0.0f, flags: ImDrawFlags = 0.ImDrawFlags): void {.importc: "ImDrawList_PathRect".}
proc pathStroke*(self: ptr ImDrawList, col: uint32, flags: ImDrawFlags = 0.ImDrawFlags, thickness: float32 = 1.0f): void {.importc: "ImDrawList_PathStroke".}
proc popClipRect*(self: ptr ImDrawList): void {.importc: "ImDrawList_PopClipRect".}
proc popTextureID*(self: ptr ImDrawList): void {.importc: "ImDrawList_PopTextureID".}
proc primQuadUV*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimQuadUV".}
proc primRect*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimRect".}
proc primRectUV*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimRectUV".}
proc primReserve*(self: ptr ImDrawList, idx_count: int32, vtx_count: int32): void {.importc: "ImDrawList_PrimReserve".}
proc primUnreserve*(self: ptr ImDrawList, idx_count: int32, vtx_count: int32): void {.importc: "ImDrawList_PrimUnreserve".}
proc primVtx*(self: ptr ImDrawList, pos: ImVec2, uv: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimVtx".}
proc primWriteIdx*(self: ptr ImDrawList, idx: ImDrawIdx): void {.importc: "ImDrawList_PrimWriteIdx".}
proc primWriteVtx*(self: ptr ImDrawList, pos: ImVec2, uv: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimWriteVtx".}
proc pushClipRect*(self: ptr ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool = false): void {.importc: "ImDrawList_PushClipRect".}
proc pushClipRectFullScreen*(self: ptr ImDrawList): void {.importc: "ImDrawList_PushClipRectFullScreen".}
proc pushTextureID*(self: ptr ImDrawList, texture_id: ImTextureID): void {.importc: "ImDrawList_PushTextureID".}
proc CalcCircleAutoSegmentCount*(self: ptr ImDrawList, radius: float32): int32 {.importc: "ImDrawList__CalcCircleAutoSegmentCount".}
proc ClearFreeMemory*(self: ptr ImDrawList): void {.importc: "ImDrawList__ClearFreeMemory".}
proc OnChangedClipRect*(self: ptr ImDrawList): void {.importc: "ImDrawList__OnChangedClipRect".}
proc OnChangedTextureID*(self: ptr ImDrawList): void {.importc: "ImDrawList__OnChangedTextureID".}
proc OnChangedVtxOffset*(self: ptr ImDrawList): void {.importc: "ImDrawList__OnChangedVtxOffset".}
proc PathArcToFastEx*(self: ptr ImDrawList, center: ImVec2, radius: float32, a_min_sample: int32, a_max_sample: int32, a_step: int32): void {.importc: "ImDrawList__PathArcToFastEx".}
proc PathArcToN*(self: ptr ImDrawList, center: ImVec2, radius: float32, a_min: float32, a_max: float32, num_segments: int32): void {.importc: "ImDrawList__PathArcToN".}
proc PopUnusedDrawCmd*(self: ptr ImDrawList): void {.importc: "ImDrawList__PopUnusedDrawCmd".}
proc ResetForNewFrame*(self: ptr ImDrawList): void {.importc: "ImDrawList__ResetForNewFrame".}
proc TryMergeDrawCmds*(self: ptr ImDrawList): void {.importc: "ImDrawList__TryMergeDrawCmds".}
proc destroy*(self: ptr ImDrawList): void {.importc: "ImDrawList_destroy".}
proc newImFontAtlasCustomRect*(): ptr ImFontAtlasCustomRect {.importc: "ImFontAtlasCustomRect_ImFontAtlasCustomRect".}
proc isPacked*(self: ptr ImFontAtlasCustomRect): bool {.importc: "ImFontAtlasCustomRect_IsPacked".}
proc destroy*(self: ptr ImFontAtlasCustomRect): void {.importc: "ImFontAtlasCustomRect_destroy".}
proc addCustomRectFontGlyph*(self: ptr ImFontAtlas, font: ptr ImFont, id: ImWchar, width: int32, height: int32, advance_x: float32, offset: ImVec2 = ImVec2(x: 0, y: 0)): int32 {.importc: "ImFontAtlas_AddCustomRectFontGlyph".}
proc addCustomRectRegular*(self: ptr ImFontAtlas, width: int32, height: int32): int32 {.importc: "ImFontAtlas_AddCustomRectRegular".}
proc addFont*(self: ptr ImFontAtlas, font_cfg: ptr ImFontConfig): ptr ImFont {.importc: "ImFontAtlas_AddFont".}
proc addFontDefault*(self: ptr ImFontAtlas, font_cfg: ptr ImFontConfig = nil): ptr ImFont {.importc: "ImFontAtlas_AddFontDefault".}
proc addFontFromFileTTF*(self: ptr ImFontAtlas, filename: cstring, size_pixels: float32, font_cfg: ptr ImFontConfig = nil, glyph_ranges: ptr ImWchar = nil): ptr ImFont {.importc: "ImFontAtlas_AddFontFromFileTTF".}
proc addFontFromMemoryCompressedBase85TTF*(self: ptr ImFontAtlas, compressed_font_data_base85: cstring, size_pixels: float32, font_cfg: ptr ImFontConfig = nil, glyph_ranges: ptr ImWchar = nil): ptr ImFont {.importc: "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF".}
proc addFontFromMemoryCompressedTTF*(self: ptr ImFontAtlas, compressed_font_data: pointer, compressed_font_size: int32, size_pixels: float32, font_cfg: ptr ImFontConfig = nil, glyph_ranges: ptr ImWchar = nil): ptr ImFont {.importc: "ImFontAtlas_AddFontFromMemoryCompressedTTF".}
proc addFontFromMemoryTTF*(self: ptr ImFontAtlas, font_data: pointer, font_size: int32, size_pixels: float32, font_cfg: ptr ImFontConfig = nil, glyph_ranges: ptr ImWchar = nil): ptr ImFont {.importc: "ImFontAtlas_AddFontFromMemoryTTF".}
proc build*(self: ptr ImFontAtlas): bool {.importc: "ImFontAtlas_Build".}
proc calcCustomRectUV*(self: ptr ImFontAtlas, rect: ptr ImFontAtlasCustomRect, out_uv_min: ptr ImVec2, out_uv_max: ptr ImVec2): void {.importc: "ImFontAtlas_CalcCustomRectUV".}
proc clear*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_Clear".}
proc clearFonts*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_ClearFonts".}
proc clearInputData*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_ClearInputData".}
proc clearTexData*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_ClearTexData".}
proc getCustomRectByIndex*(self: ptr ImFontAtlas, index: int32): ptr ImFontAtlasCustomRect {.importc: "ImFontAtlas_GetCustomRectByIndex".}
proc getGlyphRangesChineseFull*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesChineseFull".}
proc getGlyphRangesChineseSimplifiedCommon*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon".}
proc getGlyphRangesCyrillic*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesCyrillic".}
proc getGlyphRangesDefault*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesDefault".}
proc getGlyphRangesGreek*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesGreek".}
proc getGlyphRangesJapanese*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesJapanese".}
proc getGlyphRangesKorean*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesKorean".}
proc getGlyphRangesThai*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesThai".}
proc getGlyphRangesVietnamese*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesVietnamese".}
proc getMouseCursorTexData*(self: ptr ImFontAtlas, cursor: ImGuiMouseCursor, out_offset: ptr ImVec2, out_size: ptr ImVec2, out_uv_border: var array[2, ImVec2], out_uv_fill: var array[2, ImVec2]): bool {.importc: "ImFontAtlas_GetMouseCursorTexData".}
proc getTexDataAsAlpha8*(self: ptr ImFontAtlas, out_pixels: ptr ptr uint8, out_width: ptr int32, out_height: ptr int32, out_bytes_per_pixel: ptr int32 = nil): void {.importc: "ImFontAtlas_GetTexDataAsAlpha8".}
proc getTexDataAsRGBA32*(self: ptr ImFontAtlas, out_pixels: ptr ptr uint8, out_width: ptr int32, out_height: ptr int32, out_bytes_per_pixel: ptr int32 = nil): void {.importc: "ImFontAtlas_GetTexDataAsRGBA32".}
proc newImFontAtlas*(): ptr ImFontAtlas {.importc: "ImFontAtlas_ImFontAtlas".}
proc isBuilt*(self: ptr ImFontAtlas): bool {.importc: "ImFontAtlas_IsBuilt".}
proc setTexID*(self: ptr ImFontAtlas, id: ImTextureID): void {.importc: "ImFontAtlas_SetTexID".}
proc destroy*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_destroy".}
proc newImFontConfig*(): ptr ImFontConfig {.importc: "ImFontConfig_ImFontConfig".}
proc destroy*(self: ptr ImFontConfig): void {.importc: "ImFontConfig_destroy".}
proc addChar*(self: ptr ImFontGlyphRangesBuilder, c: ImWchar): void {.importc: "ImFontGlyphRangesBuilder_AddChar".}
proc addRanges*(self: ptr ImFontGlyphRangesBuilder, ranges: ptr ImWchar): void {.importc: "ImFontGlyphRangesBuilder_AddRanges".}
proc addText*(self: ptr ImFontGlyphRangesBuilder, text: cstring, text_end: cstring = nil): void {.importc: "ImFontGlyphRangesBuilder_AddText".}
proc buildRanges*(self: ptr ImFontGlyphRangesBuilder, out_ranges: ptr ImVector[ImWchar]): void {.importc: "ImFontGlyphRangesBuilder_BuildRanges".}
proc clear*(self: ptr ImFontGlyphRangesBuilder): void {.importc: "ImFontGlyphRangesBuilder_Clear".}
proc getBit*(self: ptr ImFontGlyphRangesBuilder, n: uint): bool {.importc: "ImFontGlyphRangesBuilder_GetBit".}
proc newImFontGlyphRangesBuilder*(): ptr ImFontGlyphRangesBuilder {.importc: "ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder".}
proc setBit*(self: ptr ImFontGlyphRangesBuilder, n: uint): void {.importc: "ImFontGlyphRangesBuilder_SetBit".}
proc destroy*(self: ptr ImFontGlyphRangesBuilder): void {.importc: "ImFontGlyphRangesBuilder_destroy".}
proc addGlyph*(self: ptr ImFont, src_cfg: ptr ImFontConfig, c: ImWchar, x0: float32, y0: float32, x1: float32, y1: float32, u0: float32, v0: float32, u1: float32, v1: float32, advance_x: float32): void {.importc: "ImFont_AddGlyph".}
proc addRemapChar*(self: ptr ImFont, dst: ImWchar, src: ImWchar, overwrite_dst: bool = true): void {.importc: "ImFont_AddRemapChar".}
proc buildLookupTable*(self: ptr ImFont): void {.importc: "ImFont_BuildLookupTable".}
proc calcTextSizeANonUDT*(pOut: ptr ImVec2, self: ptr ImFont, size: float32, max_width: float32, wrap_width: float32, text_begin: cstring, text_end: cstring = nil, remaining: ptr cstring = nil): void {.importc: "ImFont_CalcTextSizeA".}
proc calcWordWrapPositionA*(self: ptr ImFont, scale: float32, text: cstring, text_end: cstring, wrap_width: float32): cstring {.importc: "ImFont_CalcWordWrapPositionA".}
proc clearOutputData*(self: ptr ImFont): void {.importc: "ImFont_ClearOutputData".}
proc findGlyph*(self: ptr ImFont, c: ImWchar): ptr ImFontGlyph {.importc: "ImFont_FindGlyph".}
proc findGlyphNoFallback*(self: ptr ImFont, c: ImWchar): ptr ImFontGlyph {.importc: "ImFont_FindGlyphNoFallback".}
proc getCharAdvance*(self: ptr ImFont, c: ImWchar): float32 {.importc: "ImFont_GetCharAdvance".}
proc getDebugName*(self: ptr ImFont): cstring {.importc: "ImFont_GetDebugName".}
proc growIndex*(self: ptr ImFont, new_size: int32): void {.importc: "ImFont_GrowIndex".}
proc newImFont*(): ptr ImFont {.importc: "ImFont_ImFont".}
proc isGlyphRangeUnused*(self: ptr ImFont, c_begin: uint32, c_last: uint32): bool {.importc: "ImFont_IsGlyphRangeUnused".}
proc isLoaded*(self: ptr ImFont): bool {.importc: "ImFont_IsLoaded".}
proc renderChar*(self: ptr ImFont, draw_list: ptr ImDrawList, size: float32, pos: ImVec2, col: uint32, c: ImWchar): void {.importc: "ImFont_RenderChar".}
proc renderText*(self: ptr ImFont, draw_list: ptr ImDrawList, size: float32, pos: ImVec2, col: uint32, clip_rect: ImVec4, text_begin: cstring, text_end: cstring, wrap_width: float32 = 0.0f, cpu_fine_clip: bool = false): void {.importc: "ImFont_RenderText".}
proc setGlyphVisible*(self: ptr ImFont, c: ImWchar, visible: bool): void {.importc: "ImFont_SetGlyphVisible".}
proc destroy*(self: ptr ImFont): void {.importc: "ImFont_destroy".}
proc newImGuiComboPreviewData*(): ptr ImGuiComboPreviewData {.importc: "ImGuiComboPreviewData_ImGuiComboPreviewData".}
proc destroy*(self: ptr ImGuiComboPreviewData): void {.importc: "ImGuiComboPreviewData_destroy".}
proc newImGuiContextHook*(): ptr ImGuiContextHook {.importc: "ImGuiContextHook_ImGuiContextHook".}
proc destroy*(self: ptr ImGuiContextHook): void {.importc: "ImGuiContextHook_destroy".}
proc newImGuiContext*(shared_font_atlas: ptr ImFontAtlas): ptr ImGuiContext {.importc: "ImGuiContext_ImGuiContext".}
proc destroy*(self: ptr ImGuiContext): void {.importc: "ImGuiContext_destroy".}
proc getVarPtr*(self: ptr ImGuiDataVarInfo, parent: pointer): pointer {.importc: "ImGuiDataVarInfo_GetVarPtr".}
proc newImGuiDockContext*(): ptr ImGuiDockContext {.importc: "ImGuiDockContext_ImGuiDockContext".}
proc destroy*(self: ptr ImGuiDockContext): void {.importc: "ImGuiDockContext_destroy".}
proc newImGuiDockNode*(id: ImGuiID): ptr ImGuiDockNode {.importc: "ImGuiDockNode_ImGuiDockNode".}
proc isCentralNode*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsCentralNode".}
proc isDockSpace*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsDockSpace".}
proc isEmpty*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsEmpty".}
proc isFloatingNode*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsFloatingNode".}
proc isHiddenTabBar*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsHiddenTabBar".}
proc isLeafNode*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsLeafNode".}
proc isNoTabBar*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsNoTabBar".}
proc isRootNode*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsRootNode".}
proc isSplitNode*(self: ptr ImGuiDockNode): bool {.importc: "ImGuiDockNode_IsSplitNode".}
proc rectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiDockNode): void {.importc: "ImGuiDockNode_Rect".}
proc setLocalFlags*(self: ptr ImGuiDockNode, flags: ImGuiDockNodeFlags): void {.importc: "ImGuiDockNode_SetLocalFlags".}
proc updateMergedFlags*(self: ptr ImGuiDockNode): void {.importc: "ImGuiDockNode_UpdateMergedFlags".}
proc destroy*(self: ptr ImGuiDockNode): void {.importc: "ImGuiDockNode_destroy".}
proc addFocusEvent*(self: ptr ImGuiIO, focused: bool): void {.importc: "ImGuiIO_AddFocusEvent".}
proc addInputCharacter*(self: ptr ImGuiIO, c: uint32): void {.importc: "ImGuiIO_AddInputCharacter".}
proc addInputCharacterUTF16*(self: ptr ImGuiIO, c: ImWchar16): void {.importc: "ImGuiIO_AddInputCharacterUTF16".}
proc addInputCharactersUTF8*(self: ptr ImGuiIO, str: cstring): void {.importc: "ImGuiIO_AddInputCharactersUTF8".}
proc addKeyAnalogEvent*(self: ptr ImGuiIO, key: ImGuiKey, down: bool, v: float32): void {.importc: "ImGuiIO_AddKeyAnalogEvent".}
proc addKeyEvent*(self: ptr ImGuiIO, key: ImGuiKey, down: bool): void {.importc: "ImGuiIO_AddKeyEvent".}
proc addMouseButtonEvent*(self: ptr ImGuiIO, button: int32, down: bool): void {.importc: "ImGuiIO_AddMouseButtonEvent".}
proc addMousePosEvent*(self: ptr ImGuiIO, x: float32, y: float32): void {.importc: "ImGuiIO_AddMousePosEvent".}
proc addMouseSourceEvent*(self: ptr ImGuiIO, source: ImGuiMouseSource): void {.importc: "ImGuiIO_AddMouseSourceEvent".}
proc addMouseViewportEvent*(self: ptr ImGuiIO, id: ImGuiID): void {.importc: "ImGuiIO_AddMouseViewportEvent".}
proc addMouseWheelEvent*(self: ptr ImGuiIO, wheel_x: float32, wheel_y: float32): void {.importc: "ImGuiIO_AddMouseWheelEvent".}
proc clearEventsQueue*(self: ptr ImGuiIO): void {.importc: "ImGuiIO_ClearEventsQueue".}
proc clearInputKeys*(self: ptr ImGuiIO): void {.importc: "ImGuiIO_ClearInputKeys".}
proc newImGuiIO*(): ptr ImGuiIO {.importc: "ImGuiIO_ImGuiIO".}
proc setAppAcceptingEvents*(self: ptr ImGuiIO, accepting_events: bool): void {.importc: "ImGuiIO_SetAppAcceptingEvents".}
proc setKeyEventNativeData*(self: ptr ImGuiIO, key: ImGuiKey, native_keycode: int32, native_scancode: int32, native_legacy_index: int32 = -1): void {.importc: "ImGuiIO_SetKeyEventNativeData".}
proc destroy*(self: ptr ImGuiIO): void {.importc: "ImGuiIO_destroy".}
proc newImGuiInputEvent*(): ptr ImGuiInputEvent {.importc: "ImGuiInputEvent_ImGuiInputEvent".}
proc destroy*(self: ptr ImGuiInputEvent): void {.importc: "ImGuiInputEvent_destroy".}
proc clearSelection*(self: ptr ImGuiInputTextCallbackData): void {.importc: "ImGuiInputTextCallbackData_ClearSelection".}
proc deleteChars*(self: ptr ImGuiInputTextCallbackData, pos: int32, bytes_count: int32): void {.importc: "ImGuiInputTextCallbackData_DeleteChars".}
proc hasSelection*(self: ptr ImGuiInputTextCallbackData): bool {.importc: "ImGuiInputTextCallbackData_HasSelection".}
proc newImGuiInputTextCallbackData*(): ptr ImGuiInputTextCallbackData {.importc: "ImGuiInputTextCallbackData_ImGuiInputTextCallbackData".}
proc insertChars*(self: ptr ImGuiInputTextCallbackData, pos: int32, text: cstring, text_end: cstring = nil): void {.importc: "ImGuiInputTextCallbackData_InsertChars".}
proc selectAll*(self: ptr ImGuiInputTextCallbackData): void {.importc: "ImGuiInputTextCallbackData_SelectAll".}
proc destroy*(self: ptr ImGuiInputTextCallbackData): void {.importc: "ImGuiInputTextCallbackData_destroy".}
proc clearFreeMemory*(self: ptr ImGuiInputTextDeactivatedState): void {.importc: "ImGuiInputTextDeactivatedState_ClearFreeMemory".}
proc newImGuiInputTextDeactivatedState*(): ptr ImGuiInputTextDeactivatedState {.importc: "ImGuiInputTextDeactivatedState_ImGuiInputTextDeactivatedState".}
proc destroy*(self: ptr ImGuiInputTextDeactivatedState): void {.importc: "ImGuiInputTextDeactivatedState_destroy".}
proc clearFreeMemory*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_ClearFreeMemory".}
proc clearSelection*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_ClearSelection".}
proc clearText*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_ClearText".}
proc cursorAnimReset*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_CursorAnimReset".}
proc cursorClamp*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_CursorClamp".}
proc getCursorPos*(self: ptr ImGuiInputTextState): int32 {.importc: "ImGuiInputTextState_GetCursorPos".}
proc getRedoAvailCount*(self: ptr ImGuiInputTextState): int32 {.importc: "ImGuiInputTextState_GetRedoAvailCount".}
proc getSelectionEnd*(self: ptr ImGuiInputTextState): int32 {.importc: "ImGuiInputTextState_GetSelectionEnd".}
proc getSelectionStart*(self: ptr ImGuiInputTextState): int32 {.importc: "ImGuiInputTextState_GetSelectionStart".}
proc getUndoAvailCount*(self: ptr ImGuiInputTextState): int32 {.importc: "ImGuiInputTextState_GetUndoAvailCount".}
proc hasSelection*(self: ptr ImGuiInputTextState): bool {.importc: "ImGuiInputTextState_HasSelection".}
proc newImGuiInputTextState*(): ptr ImGuiInputTextState {.importc: "ImGuiInputTextState_ImGuiInputTextState".}
proc onKeyPressed*(self: ptr ImGuiInputTextState, key: int32): void {.importc: "ImGuiInputTextState_OnKeyPressed".}
proc selectAll*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_SelectAll".}
proc destroy*(self: ptr ImGuiInputTextState): void {.importc: "ImGuiInputTextState_destroy".}
proc newImGuiKeyOwnerData*(): ptr ImGuiKeyOwnerData {.importc: "ImGuiKeyOwnerData_ImGuiKeyOwnerData".}
proc destroy*(self: ptr ImGuiKeyOwnerData): void {.importc: "ImGuiKeyOwnerData_destroy".}
proc newImGuiKeyRoutingData*(): ptr ImGuiKeyRoutingData {.importc: "ImGuiKeyRoutingData_ImGuiKeyRoutingData".}
proc destroy*(self: ptr ImGuiKeyRoutingData): void {.importc: "ImGuiKeyRoutingData_destroy".}
proc clear*(self: ptr ImGuiKeyRoutingTable): void {.importc: "ImGuiKeyRoutingTable_Clear".}
proc newImGuiKeyRoutingTable*(): ptr ImGuiKeyRoutingTable {.importc: "ImGuiKeyRoutingTable_ImGuiKeyRoutingTable".}
proc destroy*(self: ptr ImGuiKeyRoutingTable): void {.importc: "ImGuiKeyRoutingTable_destroy".}
proc newImGuiLastItemData*(): ptr ImGuiLastItemData {.importc: "ImGuiLastItemData_ImGuiLastItemData".}
proc destroy*(self: ptr ImGuiLastItemData): void {.importc: "ImGuiLastItemData_destroy".}
proc newImGuiListClipperData*(): ptr ImGuiListClipperData {.importc: "ImGuiListClipperData_ImGuiListClipperData".}
proc reset*(self: ptr ImGuiListClipperData, clipper: ptr ImGuiListClipper): void {.importc: "ImGuiListClipperData_Reset".}
proc destroy*(self: ptr ImGuiListClipperData): void {.importc: "ImGuiListClipperData_destroy".}
proc fromIndices*(min: int32, max: int32): ImGuiListClipperRange {.importc: "ImGuiListClipperRange_FromIndices".}
proc fromPositions*(y1: float32, y2: float32, off_min: int32, off_max: int32): ImGuiListClipperRange {.importc: "ImGuiListClipperRange_FromPositions".}
proc begin*(self: ptr ImGuiListClipper, items_count: int32, items_height: float32 = -1.0f): void {.importc: "ImGuiListClipper_Begin".}
proc `end`*(self: ptr ImGuiListClipper): void {.importc: "ImGuiListClipper_End".}
proc newImGuiListClipper*(): ptr ImGuiListClipper {.importc: "ImGuiListClipper_ImGuiListClipper".}
proc includeItemByIndex*(self: ptr ImGuiListClipper, item_index: int32): void {.importc: "ImGuiListClipper_IncludeItemByIndex".}
proc includeItemsByIndex*(self: ptr ImGuiListClipper, item_begin: int32, item_end: int32): void {.importc: "ImGuiListClipper_IncludeItemsByIndex".}
proc step*(self: ptr ImGuiListClipper): bool {.importc: "ImGuiListClipper_Step".}
proc destroy*(self: ptr ImGuiListClipper): void {.importc: "ImGuiListClipper_destroy".}
proc calcNextTotalWidth*(self: ptr ImGuiMenuColumns, update_offsets: bool): void {.importc: "ImGuiMenuColumns_CalcNextTotalWidth".}
proc declColumns*(self: ptr ImGuiMenuColumns, w_icon: float32, w_label: float32, w_shortcut: float32, w_mark: float32): float32 {.importc: "ImGuiMenuColumns_DeclColumns".}
proc newImGuiMenuColumns*(): ptr ImGuiMenuColumns {.importc: "ImGuiMenuColumns_ImGuiMenuColumns".}
proc update*(self: ptr ImGuiMenuColumns, spacing: float32, window_reappearing: bool): void {.importc: "ImGuiMenuColumns_Update".}
proc destroy*(self: ptr ImGuiMenuColumns): void {.importc: "ImGuiMenuColumns_destroy".}
proc clear*(self: ptr ImGuiNavItemData): void {.importc: "ImGuiNavItemData_Clear".}
proc newImGuiNavItemData*(): ptr ImGuiNavItemData {.importc: "ImGuiNavItemData_ImGuiNavItemData".}
proc destroy*(self: ptr ImGuiNavItemData): void {.importc: "ImGuiNavItemData_destroy".}
proc clearFlags*(self: ptr ImGuiNextItemData): void {.importc: "ImGuiNextItemData_ClearFlags".}
proc newImGuiNextItemData*(): ptr ImGuiNextItemData {.importc: "ImGuiNextItemData_ImGuiNextItemData".}
proc destroy*(self: ptr ImGuiNextItemData): void {.importc: "ImGuiNextItemData_destroy".}
proc clearFlags*(self: ptr ImGuiNextWindowData): void {.importc: "ImGuiNextWindowData_ClearFlags".}
proc newImGuiNextWindowData*(): ptr ImGuiNextWindowData {.importc: "ImGuiNextWindowData_ImGuiNextWindowData".}
proc destroy*(self: ptr ImGuiNextWindowData): void {.importc: "ImGuiNextWindowData_destroy".}
proc newImGuiOldColumnData*(): ptr ImGuiOldColumnData {.importc: "ImGuiOldColumnData_ImGuiOldColumnData".}
proc destroy*(self: ptr ImGuiOldColumnData): void {.importc: "ImGuiOldColumnData_destroy".}
proc newImGuiOldColumns*(): ptr ImGuiOldColumns {.importc: "ImGuiOldColumns_ImGuiOldColumns".}
proc destroy*(self: ptr ImGuiOldColumns): void {.importc: "ImGuiOldColumns_destroy".}
proc newImGuiOnceUponAFrame*(): ptr ImGuiOnceUponAFrame {.importc: "ImGuiOnceUponAFrame_ImGuiOnceUponAFrame".}
proc destroy*(self: ptr ImGuiOnceUponAFrame): void {.importc: "ImGuiOnceUponAFrame_destroy".}
proc clear*(self: ptr ImGuiPayload): void {.importc: "ImGuiPayload_Clear".}
proc newImGuiPayload*(): ptr ImGuiPayload {.importc: "ImGuiPayload_ImGuiPayload".}
proc isDataType*(self: ptr ImGuiPayload, `type`: cstring): bool {.importc: "ImGuiPayload_IsDataType".}
proc isDelivery*(self: ptr ImGuiPayload): bool {.importc: "ImGuiPayload_IsDelivery".}
proc isPreview*(self: ptr ImGuiPayload): bool {.importc: "ImGuiPayload_IsPreview".}
proc destroy*(self: ptr ImGuiPayload): void {.importc: "ImGuiPayload_destroy".}
proc newImGuiPlatformIO*(): ptr ImGuiPlatformIO {.importc: "ImGuiPlatformIO_ImGuiPlatformIO".}
proc destroy*(self: ptr ImGuiPlatformIO): void {.importc: "ImGuiPlatformIO_destroy".}
proc newImGuiPlatformImeData*(): ptr ImGuiPlatformImeData {.importc: "ImGuiPlatformImeData_ImGuiPlatformImeData".}
proc destroy*(self: ptr ImGuiPlatformImeData): void {.importc: "ImGuiPlatformImeData_destroy".}
proc newImGuiPlatformMonitor*(): ptr ImGuiPlatformMonitor {.importc: "ImGuiPlatformMonitor_ImGuiPlatformMonitor".}
proc destroy*(self: ptr ImGuiPlatformMonitor): void {.importc: "ImGuiPlatformMonitor_destroy".}
proc newImGuiPopupData*(): ptr ImGuiPopupData {.importc: "ImGuiPopupData_ImGuiPopupData".}
proc destroy*(self: ptr ImGuiPopupData): void {.importc: "ImGuiPopupData_destroy".}
proc newImGuiPtrOrIndex*(`ptr`: pointer): ptr ImGuiPtrOrIndex {.importc: "ImGuiPtrOrIndex_ImGuiPtrOrIndex_Ptr".}
proc newImGuiPtrOrIndex*(index: int32): ptr ImGuiPtrOrIndex {.importc: "ImGuiPtrOrIndex_ImGuiPtrOrIndex_Int".}
proc destroy*(self: ptr ImGuiPtrOrIndex): void {.importc: "ImGuiPtrOrIndex_destroy".}
proc newImGuiSettingsHandler*(): ptr ImGuiSettingsHandler {.importc: "ImGuiSettingsHandler_ImGuiSettingsHandler".}
proc destroy*(self: ptr ImGuiSettingsHandler): void {.importc: "ImGuiSettingsHandler_destroy".}
proc newImGuiStackLevelInfo*(): ptr ImGuiStackLevelInfo {.importc: "ImGuiStackLevelInfo_ImGuiStackLevelInfo".}
proc destroy*(self: ptr ImGuiStackLevelInfo): void {.importc: "ImGuiStackLevelInfo_destroy".}
proc compareWithContextState*(self: ptr ImGuiStackSizes, ctx: ptr ImGuiContext): void {.importc: "ImGuiStackSizes_CompareWithContextState".}
proc newImGuiStackSizes*(): ptr ImGuiStackSizes {.importc: "ImGuiStackSizes_ImGuiStackSizes".}
proc setToContextState*(self: ptr ImGuiStackSizes, ctx: ptr ImGuiContext): void {.importc: "ImGuiStackSizes_SetToContextState".}
proc destroy*(self: ptr ImGuiStackSizes): void {.importc: "ImGuiStackSizes_destroy".}
proc newImGuiStackTool*(): ptr ImGuiStackTool {.importc: "ImGuiStackTool_ImGuiStackTool".}
proc destroy*(self: ptr ImGuiStackTool): void {.importc: "ImGuiStackTool_destroy".}
proc newImGuiStoragePair*(key: ImGuiID, val_i: int32): ptr ImGuiStoragePair {.importc: "ImGuiStoragePair_ImGuiStoragePair_Int".}
proc newImGuiStoragePair*(key: ImGuiID, val_f: float32): ptr ImGuiStoragePair {.importc: "ImGuiStoragePair_ImGuiStoragePair_Float".}
proc newImGuiStoragePair*(key: ImGuiID, val_p: pointer): ptr ImGuiStoragePair {.importc: "ImGuiStoragePair_ImGuiStoragePair_Ptr".}
proc destroy*(self: ptr ImGuiStoragePair): void {.importc: "ImGuiStoragePair_destroy".}
proc buildSortByKey*(self: ptr ImGuiStorage): void {.importc: "ImGuiStorage_BuildSortByKey".}
proc clear*(self: ptr ImGuiStorage): void {.importc: "ImGuiStorage_Clear".}
proc getBool*(self: ptr ImGuiStorage, key: ImGuiID, default_val: bool = false): bool {.importc: "ImGuiStorage_GetBool".}
proc getBoolRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: bool = false): ptr bool {.importc: "ImGuiStorage_GetBoolRef".}
proc getFloat*(self: ptr ImGuiStorage, key: ImGuiID, default_val: float32 = 0.0f): float32 {.importc: "ImGuiStorage_GetFloat".}
proc getFloatRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: float32 = 0.0f): ptr float32 {.importc: "ImGuiStorage_GetFloatRef".}
proc getInt*(self: ptr ImGuiStorage, key: ImGuiID, default_val: int32 = 0): int32 {.importc: "ImGuiStorage_GetInt".}
proc getIntRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: int32 = 0): ptr int32 {.importc: "ImGuiStorage_GetIntRef".}
proc getVoidPtr*(self: ptr ImGuiStorage, key: ImGuiID): pointer {.importc: "ImGuiStorage_GetVoidPtr".}
proc getVoidPtrRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: pointer = nil): ptr pointer {.importc: "ImGuiStorage_GetVoidPtrRef".}
proc setAllInt*(self: ptr ImGuiStorage, val: int32): void {.importc: "ImGuiStorage_SetAllInt".}
proc setBool*(self: ptr ImGuiStorage, key: ImGuiID, val: bool): void {.importc: "ImGuiStorage_SetBool".}
proc setFloat*(self: ptr ImGuiStorage, key: ImGuiID, val: float32): void {.importc: "ImGuiStorage_SetFloat".}
proc setInt*(self: ptr ImGuiStorage, key: ImGuiID, val: int32): void {.importc: "ImGuiStorage_SetInt".}
proc setVoidPtr*(self: ptr ImGuiStorage, key: ImGuiID, val: pointer): void {.importc: "ImGuiStorage_SetVoidPtr".}
proc newImGuiStyleMod*(idx: ImGuiStyleVar, v: int32): ptr ImGuiStyleMod {.importc: "ImGuiStyleMod_ImGuiStyleMod_Int".}
proc newImGuiStyleMod*(idx: ImGuiStyleVar, v: float32): ptr ImGuiStyleMod {.importc: "ImGuiStyleMod_ImGuiStyleMod_Float".}
proc newImGuiStyleMod*(idx: ImGuiStyleVar, v: ImVec2): ptr ImGuiStyleMod {.importc: "ImGuiStyleMod_ImGuiStyleMod_Vec2".}
proc destroy*(self: ptr ImGuiStyleMod): void {.importc: "ImGuiStyleMod_destroy".}
proc newImGuiStyle*(): ptr ImGuiStyle {.importc: "ImGuiStyle_ImGuiStyle".}
proc scaleAllSizes*(self: ptr ImGuiStyle, scale_factor: float32): void {.importc: "ImGuiStyle_ScaleAllSizes".}
proc destroy*(self: ptr ImGuiStyle): void {.importc: "ImGuiStyle_destroy".}
proc newImGuiTabBar*(): ptr ImGuiTabBar {.importc: "ImGuiTabBar_ImGuiTabBar".}
proc destroy*(self: ptr ImGuiTabBar): void {.importc: "ImGuiTabBar_destroy".}
proc newImGuiTabItem*(): ptr ImGuiTabItem {.importc: "ImGuiTabItem_ImGuiTabItem".}
proc destroy*(self: ptr ImGuiTabItem): void {.importc: "ImGuiTabItem_destroy".}
proc newImGuiTableColumnSettings*(): ptr ImGuiTableColumnSettings {.importc: "ImGuiTableColumnSettings_ImGuiTableColumnSettings".}
proc destroy*(self: ptr ImGuiTableColumnSettings): void {.importc: "ImGuiTableColumnSettings_destroy".}
proc newImGuiTableColumnSortSpecs*(): ptr ImGuiTableColumnSortSpecs {.importc: "ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs".}
proc destroy*(self: ptr ImGuiTableColumnSortSpecs): void {.importc: "ImGuiTableColumnSortSpecs_destroy".}
proc newImGuiTableColumn*(): ptr ImGuiTableColumn {.importc: "ImGuiTableColumn_ImGuiTableColumn".}
proc destroy*(self: ptr ImGuiTableColumn): void {.importc: "ImGuiTableColumn_destroy".}
proc newImGuiTableInstanceData*(): ptr ImGuiTableInstanceData {.importc: "ImGuiTableInstanceData_ImGuiTableInstanceData".}
proc destroy*(self: ptr ImGuiTableInstanceData): void {.importc: "ImGuiTableInstanceData_destroy".}
proc getColumnSettings*(self: ptr ImGuiTableSettings): ptr ImGuiTableColumnSettings {.importc: "ImGuiTableSettings_GetColumnSettings".}
proc newImGuiTableSettings*(): ptr ImGuiTableSettings {.importc: "ImGuiTableSettings_ImGuiTableSettings".}
proc destroy*(self: ptr ImGuiTableSettings): void {.importc: "ImGuiTableSettings_destroy".}
proc newImGuiTableSortSpecs*(): ptr ImGuiTableSortSpecs {.importc: "ImGuiTableSortSpecs_ImGuiTableSortSpecs".}
proc destroy*(self: ptr ImGuiTableSortSpecs): void {.importc: "ImGuiTableSortSpecs_destroy".}
proc newImGuiTableTempData*(): ptr ImGuiTableTempData {.importc: "ImGuiTableTempData_ImGuiTableTempData".}
proc destroy*(self: ptr ImGuiTableTempData): void {.importc: "ImGuiTableTempData_destroy".}
proc newImGuiTable*(): ptr ImGuiTable {.importc: "ImGuiTable_ImGuiTable".}
proc destroy*(self: ptr ImGuiTable): void {.importc: "ImGuiTable_destroy".}
proc newImGuiTextBuffer*(): ptr ImGuiTextBuffer {.importc: "ImGuiTextBuffer_ImGuiTextBuffer".}
proc append*(self: ptr ImGuiTextBuffer, str: cstring, str_end: cstring = nil): void {.importc: "ImGuiTextBuffer_append".}
proc appendf*(self: ptr ImGuiTextBuffer, fmt: cstring): void {.importc: "ImGuiTextBuffer_appendf", varargs.}
proc appendfv*(self: ptr ImGuiTextBuffer, fmt: cstring): void {.importc: "ImGuiTextBuffer_appendfv", varargs.}
proc begin*(self: ptr ImGuiTextBuffer): cstring {.importc: "ImGuiTextBuffer_begin".}
proc c_str*(self: ptr ImGuiTextBuffer): cstring {.importc: "ImGuiTextBuffer_c_str".}
proc clear*(self: ptr ImGuiTextBuffer): void {.importc: "ImGuiTextBuffer_clear".}
proc destroy*(self: ptr ImGuiTextBuffer): void {.importc: "ImGuiTextBuffer_destroy".}
proc empty*(self: ptr ImGuiTextBuffer): bool {.importc: "ImGuiTextBuffer_empty".}
proc `end`*(self: ptr ImGuiTextBuffer): cstring {.importc: "ImGuiTextBuffer_end".}
proc reserve*(self: ptr ImGuiTextBuffer, capacity: int32): void {.importc: "ImGuiTextBuffer_reserve".}
proc size*(self: ptr ImGuiTextBuffer): int32 {.importc: "ImGuiTextBuffer_size".}
proc build*(self: ptr ImGuiTextFilter): void {.importc: "ImGuiTextFilter_Build".}
proc clear*(self: ptr ImGuiTextFilter): void {.importc: "ImGuiTextFilter_Clear".}
proc draw*(self: ptr ImGuiTextFilter, label: cstring = "Filter(inc,-exc)", width: float32 = 0.0f): bool {.importc: "ImGuiTextFilter_Draw".}
proc newImGuiTextFilter*(default_filter: cstring = ""): ptr ImGuiTextFilter {.importc: "ImGuiTextFilter_ImGuiTextFilter".}
proc isActive*(self: ptr ImGuiTextFilter): bool {.importc: "ImGuiTextFilter_IsActive".}
proc passFilter*(self: ptr ImGuiTextFilter, text: cstring, text_end: cstring = nil): bool {.importc: "ImGuiTextFilter_PassFilter".}
proc destroy*(self: ptr ImGuiTextFilter): void {.importc: "ImGuiTextFilter_destroy".}
proc append*(self: ptr ImGuiTextIndex, base: cstring, old_size: int32, new_size: int32): void {.importc: "ImGuiTextIndex_append".}
proc clear*(self: ptr ImGuiTextIndex): void {.importc: "ImGuiTextIndex_clear".}
proc get_line_begin*(self: ptr ImGuiTextIndex, base: cstring, n: int32): cstring {.importc: "ImGuiTextIndex_get_line_begin".}
proc get_line_end*(self: ptr ImGuiTextIndex, base: cstring, n: int32): cstring {.importc: "ImGuiTextIndex_get_line_end".}
proc size*(self: ptr ImGuiTextIndex): int32 {.importc: "ImGuiTextIndex_size".}
proc newImGuiTextRange*(): ptr ImGuiTextRange {.importc: "ImGuiTextRange_ImGuiTextRange_Nil".}
proc newImGuiTextRange*(b: cstring, e: cstring): ptr ImGuiTextRange {.importc: "ImGuiTextRange_ImGuiTextRange_Str".}
proc destroy*(self: ptr ImGuiTextRange): void {.importc: "ImGuiTextRange_destroy".}
proc empty*(self: ptr ImGuiTextRange): bool {.importc: "ImGuiTextRange_empty".}
proc split*(self: ptr ImGuiTextRange, separator: int8, `out`: ptr ImVector[ImGuiTextRange]): void {.importc: "ImGuiTextRange_split".}
proc calcWorkRectPosNonUDT*(pOut: ptr ImVec2, self: ptr ImGuiViewportP, off_min: ImVec2): void {.importc: "ImGuiViewportP_CalcWorkRectPos".}
proc calcWorkRectSizeNonUDT*(pOut: ptr ImVec2, self: ptr ImGuiViewportP, off_min: ImVec2, off_max: ImVec2): void {.importc: "ImGuiViewportP_CalcWorkRectSize".}
proc clearRequestFlags*(self: ptr ImGuiViewportP): void {.importc: "ImGuiViewportP_ClearRequestFlags".}
proc getBuildWorkRectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiViewportP): void {.importc: "ImGuiViewportP_GetBuildWorkRect".}
proc getMainRectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiViewportP): void {.importc: "ImGuiViewportP_GetMainRect".}
proc getWorkRectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiViewportP): void {.importc: "ImGuiViewportP_GetWorkRect".}
proc newImGuiViewportP*(): ptr ImGuiViewportP {.importc: "ImGuiViewportP_ImGuiViewportP".}
proc updateWorkRect*(self: ptr ImGuiViewportP): void {.importc: "ImGuiViewportP_UpdateWorkRect".}
proc destroy*(self: ptr ImGuiViewportP): void {.importc: "ImGuiViewportP_destroy".}
proc getCenterNonUDT*(pOut: ptr ImVec2, self: ptr ImGuiViewport): void {.importc: "ImGuiViewport_GetCenter".}
proc getWorkCenterNonUDT*(pOut: ptr ImVec2, self: ptr ImGuiViewport): void {.importc: "ImGuiViewport_GetWorkCenter".}
proc newImGuiViewport*(): ptr ImGuiViewport {.importc: "ImGuiViewport_ImGuiViewport".}
proc destroy*(self: ptr ImGuiViewport): void {.importc: "ImGuiViewport_destroy".}
proc newImGuiWindowClass*(): ptr ImGuiWindowClass {.importc: "ImGuiWindowClass_ImGuiWindowClass".}
proc destroy*(self: ptr ImGuiWindowClass): void {.importc: "ImGuiWindowClass_destroy".}
proc getName*(self: ptr ImGuiWindowSettings): cstring {.importc: "ImGuiWindowSettings_GetName".}
proc newImGuiWindowSettings*(): ptr ImGuiWindowSettings {.importc: "ImGuiWindowSettings_ImGuiWindowSettings".}
proc destroy*(self: ptr ImGuiWindowSettings): void {.importc: "ImGuiWindowSettings_destroy".}
proc calcFontSize*(self: ptr ImGuiWindow): float32 {.importc: "ImGuiWindow_CalcFontSize".}
proc getID*(self: ptr ImGuiWindow, str: cstring, str_end: cstring = nil): ImGuiID {.importc: "ImGuiWindow_GetID_Str".}
proc getID*(self: ptr ImGuiWindow, `ptr`: pointer): ImGuiID {.importc: "ImGuiWindow_GetID_Ptr".}
proc getID*(self: ptr ImGuiWindow, n: int32): ImGuiID {.importc: "ImGuiWindow_GetID_Int".}
proc getIDFromRectangle*(self: ptr ImGuiWindow, r_abs: ImRect): ImGuiID {.importc: "ImGuiWindow_GetIDFromRectangle".}
proc newImGuiWindow*(context: ptr ImGuiContext, name: cstring): ptr ImGuiWindow {.importc: "ImGuiWindow_ImGuiWindow".}
proc menuBarHeight*(self: ptr ImGuiWindow): float32 {.importc: "ImGuiWindow_MenuBarHeight".}
proc menuBarRectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiWindow): void {.importc: "ImGuiWindow_MenuBarRect".}
proc rectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiWindow): void {.importc: "ImGuiWindow_Rect".}
proc titleBarHeight*(self: ptr ImGuiWindow): float32 {.importc: "ImGuiWindow_TitleBarHeight".}
proc titleBarRectNonUDT*(pOut: ptr ImRect, self: ptr ImGuiWindow): void {.importc: "ImGuiWindow_TitleBarRect".}
proc destroy*(self: ptr ImGuiWindow): void {.importc: "ImGuiWindow_destroy".}
proc add*[T](self: ptr ImPool): ptr T {.importc: "ImPool_Add".}
proc clear*(self: ptr ImPool): void {.importc: "ImPool_Clear".}
proc contains*[T](self: ptr ImPool, p: ptr T): bool {.importc: "ImPool_Contains".}
proc getAliveCount*(self: ptr ImPool): int32 {.importc: "ImPool_GetAliveCount".}
proc getBufSize*(self: ptr ImPool): int32 {.importc: "ImPool_GetBufSize".}
proc getByIndex*[T](self: ptr ImPool, n: ImPoolIdx): ptr T {.importc: "ImPool_GetByIndex".}
proc getByKey*[T](self: ptr ImPool, key: ImGuiID): ptr T {.importc: "ImPool_GetByKey".}
proc getIndex*[T](self: ptr ImPool, p: ptr T): ImPoolIdx {.importc: "ImPool_GetIndex".}
proc getMapSize*(self: ptr ImPool): int32 {.importc: "ImPool_GetMapSize".}
proc getOrAddByKey*[T](self: ptr ImPool, key: ImGuiID): ptr T {.importc: "ImPool_GetOrAddByKey".}
proc newImPool*(): ptr ImPool {.importc: "ImPool_ImPool".}
proc remove*[T](self: ptr ImPool, key: ImGuiID, p: ptr T): void {.importc: "ImPool_Remove_TPtr".}
proc remove*(self: ptr ImPool, key: ImGuiID, idx: ImPoolIdx): void {.importc: "ImPool_Remove_PoolIdx".}
proc reserve*(self: ptr ImPool, capacity: int32): void {.importc: "ImPool_Reserve".}
proc tryGetMapData*[T](self: ptr ImPool, n: ImPoolIdx): ptr T {.importc: "ImPool_TryGetMapData".}
proc destroy*(self: ptr ImPool): void {.importc: "ImPool_destroy".}
proc add*(self: ptr ImRect, p: ImVec2): void {.importc: "ImRect_Add_Vec2".}
proc add*(self: ptr ImRect, r: ImRect): void {.importc: "ImRect_Add_Rect".}
proc clipWith*(self: ptr ImRect, r: ImRect): void {.importc: "ImRect_ClipWith".}
proc clipWithFull*(self: ptr ImRect, r: ImRect): void {.importc: "ImRect_ClipWithFull".}
proc contains*(self: ptr ImRect, p: ImVec2): bool {.importc: "ImRect_Contains_Vec2".}
proc contains*(self: ptr ImRect, r: ImRect): bool {.importc: "ImRect_Contains_Rect".}
proc expand*(self: ptr ImRect, amount: float32): void {.importc: "ImRect_Expand_Float".}
proc expand*(self: ptr ImRect, amount: ImVec2): void {.importc: "ImRect_Expand_Vec2".}
proc floor*(self: ptr ImRect): void {.importc: "ImRect_Floor".}
proc getArea*(self: ptr ImRect): float32 {.importc: "ImRect_GetArea".}
proc getBLNonUDT*(pOut: ptr ImVec2, self: ptr ImRect): void {.importc: "ImRect_GetBL".}
proc getBRNonUDT*(pOut: ptr ImVec2, self: ptr ImRect): void {.importc: "ImRect_GetBR".}
proc getCenterNonUDT*(pOut: ptr ImVec2, self: ptr ImRect): void {.importc: "ImRect_GetCenter".}
proc getHeight*(self: ptr ImRect): float32 {.importc: "ImRect_GetHeight".}
proc getSizeNonUDT*(pOut: ptr ImVec2, self: ptr ImRect): void {.importc: "ImRect_GetSize".}
proc getTLNonUDT*(pOut: ptr ImVec2, self: ptr ImRect): void {.importc: "ImRect_GetTL".}
proc getTRNonUDT*(pOut: ptr ImVec2, self: ptr ImRect): void {.importc: "ImRect_GetTR".}
proc getWidth*(self: ptr ImRect): float32 {.importc: "ImRect_GetWidth".}
proc newImRect*(): ptr ImRect {.importc: "ImRect_ImRect_Nil".}
proc newImRect*(min: ImVec2, max: ImVec2): ptr ImRect {.importc: "ImRect_ImRect_Vec2".}
proc newImRect*(v: ImVec4): ptr ImRect {.importc: "ImRect_ImRect_Vec4".}
proc newImRect*(x1: float32, y1: float32, x2: float32, y2: float32): ptr ImRect {.importc: "ImRect_ImRect_Float".}
proc isInverted*(self: ptr ImRect): bool {.importc: "ImRect_IsInverted".}
proc overlaps*(self: ptr ImRect, r: ImRect): bool {.importc: "ImRect_Overlaps".}
proc toVec4NonUDT*(pOut: ptr ImVec4, self: ptr ImRect): void {.importc: "ImRect_ToVec4".}
proc translate*(self: ptr ImRect, d: ImVec2): void {.importc: "ImRect_Translate".}
proc translateX*(self: ptr ImRect, dx: float32): void {.importc: "ImRect_TranslateX".}
proc translateY*(self: ptr ImRect, dy: float32): void {.importc: "ImRect_TranslateY".}
proc destroy*(self: ptr ImRect): void {.importc: "ImRect_destroy".}
proc getArenaSizeInBytes*(self: ptr ImSpanAllocator): int32 {.importc: "ImSpanAllocator_GetArenaSizeInBytes".}
proc getSpanPtrBegin*(self: ptr ImSpanAllocator, n: int32): pointer {.importc: "ImSpanAllocator_GetSpanPtrBegin".}
proc getSpanPtrEnd*(self: ptr ImSpanAllocator, n: int32): pointer {.importc: "ImSpanAllocator_GetSpanPtrEnd".}
proc newImSpanAllocator*(): ptr ImSpanAllocator {.importc: "ImSpanAllocator_ImSpanAllocator".}
proc reserve*(self: ptr ImSpanAllocator, n: int32, sz: uint, a: int32 = 4): void {.importc: "ImSpanAllocator_Reserve".}
proc setArenaBasePtr*(self: ptr ImSpanAllocator, base_ptr: pointer): void {.importc: "ImSpanAllocator_SetArenaBasePtr".}
proc destroy*(self: ptr ImSpanAllocator): void {.importc: "ImSpanAllocator_destroy".}
proc newImSpan*(): ptr ImSpan {.importc: "ImSpan_ImSpan_Nil".}
proc newImSpan*[T](data: ptr T, size: int32): ptr ImSpan {.importc: "ImSpan_ImSpan_TPtrInt".}
proc newImSpan*[T](data: ptr T, data_end: ptr T): ptr ImSpan {.importc: "ImSpan_ImSpan_TPtrTPtr".}
proc begin*[T](self: ptr ImSpan): ptr T {.importc: "ImSpan_begin_Nil".}
proc destroy*(self: ptr ImSpan): void {.importc: "ImSpan_destroy".}
proc `end`*[T](self: ptr ImSpan): ptr T {.importc: "ImSpan_end_Nil".}
proc index_from_ptr*[T](self: ptr ImSpan, it: ptr T): int32 {.importc: "ImSpan_index_from_ptr".}
proc set*[T](self: ptr ImSpan, data: ptr T, size: int32): void {.importc: "ImSpan_set_Int".}
proc set*[T](self: ptr ImSpan, data: ptr T, data_end: ptr T): void {.importc: "ImSpan_set_TPtr".}
proc size*(self: ptr ImSpan): int32 {.importc: "ImSpan_size".}
proc size_in_bytes*(self: ptr ImSpan): int32 {.importc: "ImSpan_size_in_bytes".}
proc newImVec1*(): ptr ImVec1 {.importc: "ImVec1_ImVec1_Nil".}
proc newImVec1*(x: float32): ptr ImVec1 {.importc: "ImVec1_ImVec1_Float".}
proc destroy*(self: ptr ImVec1): void {.importc: "ImVec1_destroy".}
proc newImVec2*(): ptr ImVec2 {.importc: "ImVec2_ImVec2_Nil".}
proc newImVec2*(x: float32, y: float32): ptr ImVec2 {.importc: "ImVec2_ImVec2_Float".}
proc destroy*(self: ptr ImVec2): void {.importc: "ImVec2_destroy".}
proc newImVec2ih*(): ptr ImVec2ih {.importc: "ImVec2ih_ImVec2ih_Nil".}
proc newImVec2ih*(x: int16, y: int16): ptr ImVec2ih {.importc: "ImVec2ih_ImVec2ih_short".}
proc newImVec2ih*(rhs: ImVec2): ptr ImVec2ih {.importc: "ImVec2ih_ImVec2ih_Vec2".}
proc destroy*(self: ptr ImVec2ih): void {.importc: "ImVec2ih_destroy".}
proc newImVec4*(): ptr ImVec4 {.importc: "ImVec4_ImVec4_Nil".}
proc newImVec4*(x: float32, y: float32, z: float32, w: float32): ptr ImVec4 {.importc: "ImVec4_ImVec4_Float".}
proc destroy*(self: ptr ImVec4): void {.importc: "ImVec4_destroy".}
proc grow_capacity*(self: ptr ImVector, sz: int32): int32 {.importc: "ImVector__grow_capacity".}
proc back*[T](self: ptr ImVector): ptr T {.importc: "ImVector_back_Nil".}
proc begin*[T](self: ptr ImVector): ptr T {.importc: "ImVector_begin_Nil".}
proc capacity*(self: ptr ImVector): int32 {.importc: "ImVector_capacity".}
proc clear*(self: ptr ImVector): void {.importc: "ImVector_clear".}
proc clear_delete*(self: ptr ImVector): void {.importc: "ImVector_clear_delete".}
proc clear_destruct*(self: ptr ImVector): void {.importc: "ImVector_clear_destruct".}
proc contains*[T](self: ptr ImVector, v: T): bool {.importc: "ImVector_contains".}
proc destroy*(self: ptr ImVector): void {.importc: "ImVector_destroy".}
proc empty*(self: ptr ImVector): bool {.importc: "ImVector_empty".}
proc `end`*[T](self: ptr ImVector): ptr T {.importc: "ImVector_end_Nil".}
proc erase*[T](self: ptr ImVector, it: ptr T): ptr T {.importc: "ImVector_erase_Nil".}
proc erase*[T](self: ptr ImVector, it: ptr T, it_last: ptr T): ptr T {.importc: "ImVector_erase_TPtr".}
proc erase_unsorted*[T](self: ptr ImVector, it: ptr T): ptr T {.importc: "ImVector_erase_unsorted".}
proc find*[T](self: ptr ImVector, v: T): ptr T {.importc: "ImVector_find_Nil".}
proc find_erase*[T](self: ptr ImVector, v: T): bool {.importc: "ImVector_find_erase".}
proc find_erase_unsorted*[T](self: ptr ImVector, v: T): bool {.importc: "ImVector_find_erase_unsorted".}
proc front*[T](self: ptr ImVector): ptr T {.importc: "ImVector_front_Nil".}
proc index_from_ptr*[T](self: ptr ImVector, it: ptr T): int32 {.importc: "ImVector_index_from_ptr".}
proc insert*[T](self: ptr ImVector, it: ptr T, v: T): ptr T {.importc: "ImVector_insert".}
proc max_size*(self: ptr ImVector): int32 {.importc: "ImVector_max_size".}
proc pop_back*(self: ptr ImVector): void {.importc: "ImVector_pop_back".}
proc push_back*[T](self: ptr ImVector, v: T): void {.importc: "ImVector_push_back".}
proc push_front*[T](self: ptr ImVector, v: T): void {.importc: "ImVector_push_front".}
proc reserve*(self: ptr ImVector, new_capacity: int32): void {.importc: "ImVector_reserve".}
proc reserve_discard*(self: ptr ImVector, new_capacity: int32): void {.importc: "ImVector_reserve_discard".}
proc resize*(self: ptr ImVector, new_size: int32): void {.importc: "ImVector_resize_Nil".}
proc resize*[T](self: ptr ImVector, new_size: int32, v: T): void {.importc: "ImVector_resize_T".}
proc shrink*(self: ptr ImVector, new_size: int32): void {.importc: "ImVector_shrink".}
proc size*(self: ptr ImVector): int32 {.importc: "ImVector_size".}
proc size_in_bytes*(self: ptr ImVector): int32 {.importc: "ImVector_size_in_bytes".}
proc swap*(self: ptr ImVector, rhs: ptr ImVector[T]): void {.importc: "ImVector_swap".}
proc igAcceptDragDropPayload*(`type`: cstring, flags: ImGuiDragDropFlags = 0.ImGuiDragDropFlags): ptr ImGuiPayload {.importc: "igAcceptDragDropPayload".}
proc igActivateItemByID*(id: ImGuiID): void {.importc: "igActivateItemByID".}
proc igAddContextHook*(context: ptr ImGuiContext, hook: ptr ImGuiContextHook): ImGuiID {.importc: "igAddContextHook".}
proc igAddDrawListToDrawDataEx*(draw_data: ptr ImDrawData, out_list: ptr ImVector[ImDrawListPtr], draw_list: ptr ImDrawList): void {.importc: "igAddDrawListToDrawDataEx".}
proc igAddSettingsHandler*(handler: ptr ImGuiSettingsHandler): void {.importc: "igAddSettingsHandler".}
proc igAlignTextToFramePadding*(): void {.importc: "igAlignTextToFramePadding".}
proc igArrowButton*(str_id: cstring, dir: ImGuiDir): bool {.importc: "igArrowButton".}
proc igArrowButtonEx*(str_id: cstring, dir: ImGuiDir, size_arg: ImVec2, flags: ImGuiButtonFlags = 0.ImGuiButtonFlags): bool {.importc: "igArrowButtonEx".}
proc igBegin*(name: cstring, p_open: ptr bool = nil, flags: ImGuiWindowFlags = 0.ImGuiWindowFlags): bool {.importc: "igBegin".}
proc igBeginChild*(str_id: cstring, size: ImVec2 = ImVec2(x: 0, y: 0), border: bool = false, flags: ImGuiWindowFlags = 0.ImGuiWindowFlags): bool {.importc: "igBeginChild_Str".}
proc igBeginChild*(id: ImGuiID, size: ImVec2 = ImVec2(x: 0, y: 0), border: bool = false, flags: ImGuiWindowFlags = 0.ImGuiWindowFlags): bool {.importc: "igBeginChild_ID".}
proc igBeginChildEx*(name: cstring, id: ImGuiID, size_arg: ImVec2, border: bool, flags: ImGuiWindowFlags): bool {.importc: "igBeginChildEx".}
proc igBeginChildFrame*(id: ImGuiID, size: ImVec2, flags: ImGuiWindowFlags = 0.ImGuiWindowFlags): bool {.importc: "igBeginChildFrame".}
proc igBeginColumns*(str_id: cstring, count: int32, flags: ImGuiOldColumnFlags = 0.ImGuiOldColumnFlags): void {.importc: "igBeginColumns".}
proc igBeginCombo*(label: cstring, preview_value: cstring, flags: ImGuiComboFlags = 0.ImGuiComboFlags): bool {.importc: "igBeginCombo".}
proc igBeginComboPopup*(popup_id: ImGuiID, bb: ImRect, flags: ImGuiComboFlags): bool {.importc: "igBeginComboPopup".}
proc igBeginComboPreview*(): bool {.importc: "igBeginComboPreview".}
proc igBeginDisabled*(disabled: bool = true): void {.importc: "igBeginDisabled".}
proc igBeginDockableDragDropSource*(window: ptr ImGuiWindow): void {.importc: "igBeginDockableDragDropSource".}
proc igBeginDockableDragDropTarget*(window: ptr ImGuiWindow): void {.importc: "igBeginDockableDragDropTarget".}
proc igBeginDocked*(window: ptr ImGuiWindow, p_open: ptr bool): void {.importc: "igBeginDocked".}
proc igBeginDragDropSource*(flags: ImGuiDragDropFlags = 0.ImGuiDragDropFlags): bool {.importc: "igBeginDragDropSource".}
proc igBeginDragDropTarget*(): bool {.importc: "igBeginDragDropTarget".}
proc igBeginDragDropTargetCustom*(bb: ImRect, id: ImGuiID): bool {.importc: "igBeginDragDropTargetCustom".}
proc igBeginGroup*(): void {.importc: "igBeginGroup".}
proc igBeginItemTooltip*(): bool {.importc: "igBeginItemTooltip".}
proc igBeginListBox*(label: cstring, size: ImVec2 = ImVec2(x: 0, y: 0)): bool {.importc: "igBeginListBox".}
proc igBeginMainMenuBar*(): bool {.importc: "igBeginMainMenuBar".}
proc igBeginMenu*(label: cstring, enabled: bool = true): bool {.importc: "igBeginMenu".}
proc igBeginMenuBar*(): bool {.importc: "igBeginMenuBar".}
proc igBeginMenuEx*(label: cstring, icon: cstring, enabled: bool = true): bool {.importc: "igBeginMenuEx".}
proc igBeginPopup*(str_id: cstring, flags: ImGuiWindowFlags = 0.ImGuiWindowFlags): bool {.importc: "igBeginPopup".}
proc igBeginPopupContextItem*(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 1.ImGuiPopupFlags): bool {.importc: "igBeginPopupContextItem".}
proc igBeginPopupContextVoid*(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 1.ImGuiPopupFlags): bool {.importc: "igBeginPopupContextVoid".}
proc igBeginPopupContextWindow*(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 1.ImGuiPopupFlags): bool {.importc: "igBeginPopupContextWindow".}
proc igBeginPopupEx*(id: ImGuiID, extra_flags: ImGuiWindowFlags): bool {.importc: "igBeginPopupEx".}
proc igBeginPopupModal*(name: cstring, p_open: ptr bool = nil, flags: ImGuiWindowFlags = 0.ImGuiWindowFlags): bool {.importc: "igBeginPopupModal".}
proc igBeginTabBar*(str_id: cstring, flags: ImGuiTabBarFlags = 0.ImGuiTabBarFlags): bool {.importc: "igBeginTabBar".}
proc igBeginTabBarEx*(tab_bar: ptr ImGuiTabBar, bb: ImRect, flags: ImGuiTabBarFlags, dock_node: ptr ImGuiDockNode): bool {.importc: "igBeginTabBarEx".}
proc igBeginTabItem*(label: cstring, p_open: ptr bool = nil, flags: ImGuiTabItemFlags = 0.ImGuiTabItemFlags): bool {.importc: "igBeginTabItem".}
proc igBeginTable*(str_id: cstring, column: int32, flags: ImGuiTableFlags = 0.ImGuiTableFlags, outer_size: ImVec2 = ImVec2(x: 0.0f, y: 0.0f), inner_width: float32 = 0.0f): bool {.importc: "igBeginTable".}
proc igBeginTableEx*(name: cstring, id: ImGuiID, columns_count: int32, flags: ImGuiTableFlags = 0.ImGuiTableFlags, outer_size: ImVec2 = ImVec2(x: 0, y: 0), inner_width: float32 = 0.0f): bool {.importc: "igBeginTableEx".}
proc igBeginTooltip*(): bool {.importc: "igBeginTooltip".}
proc igBeginTooltipEx*(tooltip_flags: ImGuiTooltipFlags, extra_window_flags: ImGuiWindowFlags): bool {.importc: "igBeginTooltipEx".}
proc igBeginViewportSideBar*(name: cstring, viewport: ptr ImGuiViewport, dir: ImGuiDir, size: float32, window_flags: ImGuiWindowFlags): bool {.importc: "igBeginViewportSideBar".}
proc igBringWindowToDisplayBack*(window: ptr ImGuiWindow): void {.importc: "igBringWindowToDisplayBack".}
proc igBringWindowToDisplayBehind*(window: ptr ImGuiWindow, above_window: ptr ImGuiWindow): void {.importc: "igBringWindowToDisplayBehind".}
proc igBringWindowToDisplayFront*(window: ptr ImGuiWindow): void {.importc: "igBringWindowToDisplayFront".}
proc igBringWindowToFocusFront*(window: ptr ImGuiWindow): void {.importc: "igBringWindowToFocusFront".}
proc igBullet*(): void {.importc: "igBullet".}
proc igBulletText*(fmt: cstring): void {.importc: "igBulletText", varargs.}
proc igBulletTextV*(fmt: cstring): void {.importc: "igBulletTextV", varargs.}
proc igButton*(label: cstring, size: ImVec2 = ImVec2(x: 0, y: 0)): bool {.importc: "igButton".}
proc igButtonBehavior*(bb: ImRect, id: ImGuiID, out_hovered: ptr bool, out_held: ptr bool, flags: ImGuiButtonFlags = 0.ImGuiButtonFlags): bool {.importc: "igButtonBehavior".}
proc igButtonEx*(label: cstring, size_arg: ImVec2 = ImVec2(x: 0, y: 0), flags: ImGuiButtonFlags = 0.ImGuiButtonFlags): bool {.importc: "igButtonEx".}
proc igCalcItemSizeNonUDT*(pOut: ptr ImVec2, size: ImVec2, default_w: float32, default_h: float32): void {.importc: "igCalcItemSize".}
proc igCalcItemWidth*(): float32 {.importc: "igCalcItemWidth".}
proc igCalcRoundingFlagsForRectInRect*(r_in: ImRect, r_outer: ImRect, threshold: float32): ImDrawFlags {.importc: "igCalcRoundingFlagsForRectInRect".}
proc igCalcTextSizeNonUDT*(pOut: ptr ImVec2, text: cstring, text_end: cstring = nil, hide_text_after_double_hash: bool = false, wrap_width: float32 = -1.0f): void {.importc: "igCalcTextSize".}
proc igCalcTypematicRepeatAmount*(t0: float32, t1: float32, repeat_delay: float32, repeat_rate: float32): int32 {.importc: "igCalcTypematicRepeatAmount".}
proc igCalcWindowNextAutoFitSizeNonUDT*(pOut: ptr ImVec2, window: ptr ImGuiWindow): void {.importc: "igCalcWindowNextAutoFitSize".}
proc igCalcWrapWidthForPos*(pos: ImVec2, wrap_pos_x: float32): float32 {.importc: "igCalcWrapWidthForPos".}
proc igCallContextHooks*(context: ptr ImGuiContext, `type`: ImGuiContextHookType): void {.importc: "igCallContextHooks".}
proc igCheckbox*(label: cstring, v: ptr bool): bool {.importc: "igCheckbox".}
proc igCheckboxFlags*(label: cstring, flags: ptr int32, flags_value: int32): bool {.importc: "igCheckboxFlags_IntPtr".}
proc igCheckboxFlags*(label: cstring, flags: ptr uint32, flags_value: uint32): bool {.importc: "igCheckboxFlags_UintPtr".}
proc igCheckboxFlags*(label: cstring, flags: ptr int64, flags_value: int64): bool {.importc: "igCheckboxFlags_S64Ptr".}
proc igCheckboxFlags*(label: cstring, flags: ptr uint64, flags_value: uint64): bool {.importc: "igCheckboxFlags_U64Ptr".}
proc igClearActiveID*(): void {.importc: "igClearActiveID".}
proc igClearDragDrop*(): void {.importc: "igClearDragDrop".}
proc igClearIniSettings*(): void {.importc: "igClearIniSettings".}
proc igClearWindowSettings*(name: cstring): void {.importc: "igClearWindowSettings".}
proc igCloseButton*(id: ImGuiID, pos: ImVec2): bool {.importc: "igCloseButton".}
proc igCloseCurrentPopup*(): void {.importc: "igCloseCurrentPopup".}
proc igClosePopupToLevel*(remaining: int32, restore_focus_to_window_under_popup: bool): void {.importc: "igClosePopupToLevel".}
proc igClosePopupsExceptModals*(): void {.importc: "igClosePopupsExceptModals".}
proc igClosePopupsOverWindow*(ref_window: ptr ImGuiWindow, restore_focus_to_window_under_popup: bool): void {.importc: "igClosePopupsOverWindow".}
proc igCollapseButton*(id: ImGuiID, pos: ImVec2, dock_node: ptr ImGuiDockNode): bool {.importc: "igCollapseButton".}
proc igCollapsingHeader*(label: cstring, flags: ImGuiTreeNodeFlags = 0.ImGuiTreeNodeFlags): bool {.importc: "igCollapsingHeader_TreeNodeFlags".}
proc igCollapsingHeader*(label: cstring, p_visible: ptr bool, flags: ImGuiTreeNodeFlags = 0.ImGuiTreeNodeFlags): bool {.importc: "igCollapsingHeader_BoolPtr".}
proc igColorButton*(desc_id: cstring, col: ImVec4, flags: ImGuiColorEditFlags = 0.ImGuiColorEditFlags, size: ImVec2 = ImVec2(x: 0, y: 0)): bool {.importc: "igColorButton".}
proc igColorConvertFloat4ToU32*(`in`: ImVec4): uint32 {.importc: "igColorConvertFloat4ToU32".}
proc igColorConvertHSVtoRGB*(h: float32, s: float32, v: float32, out_r: ptr float32, out_g: ptr float32, out_b: ptr float32): void {.importc: "igColorConvertHSVtoRGB".}
proc igColorConvertRGBtoHSV*(r: float32, g: float32, b: float32, out_h: ptr float32, out_s: ptr float32, out_v: ptr float32): void {.importc: "igColorConvertRGBtoHSV".}
proc igColorConvertU32ToFloat4NonUDT*(pOut: ptr ImVec4, `in`: uint32): void {.importc: "igColorConvertU32ToFloat4".}
proc igColorEdit3*(label: cstring, col: var array[3, float32], flags: ImGuiColorEditFlags = 0.ImGuiColorEditFlags): bool {.importc: "igColorEdit3".}
proc igColorEdit4*(label: cstring, col: var array[4, float32], flags: ImGuiColorEditFlags = 0.ImGuiColorEditFlags): bool {.importc: "igColorEdit4".}
proc igColorEditOptionsPopup*(col: ptr float32, flags: ImGuiColorEditFlags): void {.importc: "igColorEditOptionsPopup".}
proc igColorPicker3*(label: cstring, col: var array[3, float32], flags: ImGuiColorEditFlags = 0.ImGuiColorEditFlags): bool {.importc: "igColorPicker3".}
proc igColorPicker4*(label: cstring, col: var array[4, float32], flags: ImGuiColorEditFlags = 0.ImGuiColorEditFlags, ref_col: ptr float32 = nil): bool {.importc: "igColorPicker4".}
proc igColorPickerOptionsPopup*(ref_col: ptr float32, flags: ImGuiColorEditFlags): void {.importc: "igColorPickerOptionsPopup".}
proc igColorTooltip*(text: cstring, col: ptr float32, flags: ImGuiColorEditFlags): void {.importc: "igColorTooltip".}
proc igColumns*(count: int32 = 1, id: cstring = nil, border: bool = true): void {.importc: "igColumns".}
proc igCombo*(label: cstring, current_item: ptr int32, items: ptr cstring, items_count: int32, popup_max_height_in_items: int32 = -1): bool {.importc: "igCombo_Str_arr".}
proc igCombo*(label: cstring, current_item: ptr int32, items_separated_by_zeros: cstring, popup_max_height_in_items: int32 = -1): bool {.importc: "igCombo_Str".}
proc igCombo*(label: cstring, current_item: ptr int32, items_getter: proc(data: pointer, idx: int32, out_text: ptr cstring): bool {.cdecl, varargs.}, data: pointer, items_count: int32, popup_max_height_in_items: int32 = -1): bool {.importc: "igCombo_FnBoolPtr".}
proc igConvertShortcutMod*(key_chord: ImGuiKeyChord): ImGuiKeyChord {.importc: "igConvertShortcutMod".}
proc igConvertSingleModFlagToKey*(ctx: ptr ImGuiContext, key: ImGuiKey): ImGuiKey {.importc: "igConvertSingleModFlagToKey".}
proc igCreateContext*(shared_font_atlas: ptr ImFontAtlas = nil): ptr ImGuiContext {.importc: "igCreateContext".}
proc igCreateNewWindowSettings*(name: cstring): ptr ImGuiWindowSettings {.importc: "igCreateNewWindowSettings".}
proc igDataTypeApplyFromText*(buf: cstring, data_type: ImGuiDataType, p_data: pointer, format: cstring): bool {.importc: "igDataTypeApplyFromText".}
proc igDataTypeApplyOp*(data_type: ImGuiDataType, op: int32, output: pointer, arg_1: pointer, arg_2: pointer): void {.importc: "igDataTypeApplyOp".}
proc igDataTypeClamp*(data_type: ImGuiDataType, p_data: pointer, p_min: pointer, p_max: pointer): bool {.importc: "igDataTypeClamp".}
proc igDataTypeCompare*(data_type: ImGuiDataType, arg_1: pointer, arg_2: pointer): int32 {.importc: "igDataTypeCompare".}
proc igDataTypeFormatString*(buf: cstring, buf_size: int32, data_type: ImGuiDataType, p_data: pointer, format: cstring): int32 {.importc: "igDataTypeFormatString".}
proc igDataTypeGetInfo*(data_type: ImGuiDataType): ptr ImGuiDataTypeInfo {.importc: "igDataTypeGetInfo".}
proc igDebugCheckVersionAndDataLayout*(version_str: cstring, sz_io: uint, sz_style: uint, sz_vec2: uint, sz_vec4: uint, sz_drawvert: uint, sz_drawidx: uint): bool {.importc: "igDebugCheckVersionAndDataLayout".}
proc igDebugDrawCursorPos*(col: uint32 = 4278190335'u32): void {.importc: "igDebugDrawCursorPos".}
proc igDebugDrawItemRect*(col: uint32 = 4278190335'u32): void {.importc: "igDebugDrawItemRect".}
proc igDebugDrawLineExtents*(col: uint32 = 4278190335'u32): void {.importc: "igDebugDrawLineExtents".}
proc igDebugHookIdInfo*(id: ImGuiID, data_type: ImGuiDataType, data_id: pointer, data_id_end: pointer): void {.importc: "igDebugHookIdInfo".}
proc igDebugLocateItem*(target_id: ImGuiID): void {.importc: "igDebugLocateItem".}
proc igDebugLocateItemOnHover*(target_id: ImGuiID): void {.importc: "igDebugLocateItemOnHover".}
proc igDebugLocateItemResolveWithLastItem*(): void {.importc: "igDebugLocateItemResolveWithLastItem".}
proc igDebugLog*(fmt: cstring): void {.importc: "igDebugLog", varargs.}
proc igDebugLogV*(fmt: cstring): void {.importc: "igDebugLogV", varargs.}
proc igDebugNodeColumns*(columns: ptr ImGuiOldColumns): void {.importc: "igDebugNodeColumns".}
proc igDebugNodeDockNode*(node: ptr ImGuiDockNode, label: cstring): void {.importc: "igDebugNodeDockNode".}
proc igDebugNodeDrawCmdShowMeshAndBoundingBox*(out_draw_list: ptr ImDrawList, draw_list: ptr ImDrawList, draw_cmd: ptr ImDrawCmd, show_mesh: bool, show_aabb: bool): void {.importc: "igDebugNodeDrawCmdShowMeshAndBoundingBox".}
proc igDebugNodeDrawList*(window: ptr ImGuiWindow, viewport: ptr ImGuiViewportP, draw_list: ptr ImDrawList, label: cstring): void {.importc: "igDebugNodeDrawList".}
proc igDebugNodeFont*(font: ptr ImFont): void {.importc: "igDebugNodeFont".}
proc igDebugNodeFontGlyph*(font: ptr ImFont, glyph: ptr ImFontGlyph): void {.importc: "igDebugNodeFontGlyph".}
proc igDebugNodeInputTextState*(state: ptr ImGuiInputTextState): void {.importc: "igDebugNodeInputTextState".}
proc igDebugNodeStorage*(storage: ptr ImGuiStorage, label: cstring): void {.importc: "igDebugNodeStorage".}
proc igDebugNodeTabBar*(tab_bar: ptr ImGuiTabBar, label: cstring): void {.importc: "igDebugNodeTabBar".}
proc igDebugNodeTable*(table: ptr ImGuiTable): void {.importc: "igDebugNodeTable".}
proc igDebugNodeTableSettings*(settings: ptr ImGuiTableSettings): void {.importc: "igDebugNodeTableSettings".}
proc igDebugNodeViewport*(viewport: ptr ImGuiViewportP): void {.importc: "igDebugNodeViewport".}
proc igDebugNodeWindow*(window: ptr ImGuiWindow, label: cstring): void {.importc: "igDebugNodeWindow".}
proc igDebugNodeWindowSettings*(settings: ptr ImGuiWindowSettings): void {.importc: "igDebugNodeWindowSettings".}
proc igDebugNodeWindowsList*(windows: ptr ImVector[ptr ImGuiWindow], label: cstring): void {.importc: "igDebugNodeWindowsList".}
proc igDebugNodeWindowsListByBeginStackParent*(windows: ptr ptr ImGuiWindow, windows_size: int32, parent_in_begin_stack: ptr ImGuiWindow): void {.importc: "igDebugNodeWindowsListByBeginStackParent".}
proc igDebugRenderKeyboardPreview*(draw_list: ptr ImDrawList): void {.importc: "igDebugRenderKeyboardPreview".}
proc igDebugRenderViewportThumbnail*(draw_list: ptr ImDrawList, viewport: ptr ImGuiViewportP, bb: ImRect): void {.importc: "igDebugRenderViewportThumbnail".}
proc igDebugStartItemPicker*(): void {.importc: "igDebugStartItemPicker".}
proc igDebugTextEncoding*(text: cstring): void {.importc: "igDebugTextEncoding".}
proc igDestroyContext*(ctx: ptr ImGuiContext = nil): void {.importc: "igDestroyContext".}
proc igDestroyPlatformWindow*(viewport: ptr ImGuiViewportP): void {.importc: "igDestroyPlatformWindow".}
proc igDestroyPlatformWindows*(): void {.importc: "igDestroyPlatformWindows".}
proc igDockBuilderAddNode*(node_id: ImGuiID = 0.ImGuiID, flags: ImGuiDockNodeFlags = 0.ImGuiDockNodeFlags): ImGuiID {.importc: "igDockBuilderAddNode".}
proc igDockBuilderCopyDockSpace*(src_dockspace_id: ImGuiID, dst_dockspace_id: ImGuiID, in_window_remap_pairs: ImVector[const_cstringPtr]): void {.importc: "igDockBuilderCopyDockSpace".}
proc igDockBuilderCopyNode*(src_node_id: ImGuiID, dst_node_id: ImGuiID, out_node_remap_pairs: ptr ImVector[ImGuiID]): void {.importc: "igDockBuilderCopyNode".}
proc igDockBuilderCopyWindowSettings*(src_name: cstring, dst_name: cstring): void {.importc: "igDockBuilderCopyWindowSettings".}
proc igDockBuilderDockWindow*(window_name: cstring, node_id: ImGuiID): void {.importc: "igDockBuilderDockWindow".}
proc igDockBuilderFinish*(node_id: ImGuiID): void {.importc: "igDockBuilderFinish".}
proc igDockBuilderGetCentralNode*(node_id: ImGuiID): ptr ImGuiDockNode {.importc: "igDockBuilderGetCentralNode".}
proc igDockBuilderGetNode*(node_id: ImGuiID): ptr ImGuiDockNode {.importc: "igDockBuilderGetNode".}
proc igDockBuilderRemoveNode*(node_id: ImGuiID): void {.importc: "igDockBuilderRemoveNode".}
proc igDockBuilderRemoveNodeChildNodes*(node_id: ImGuiID): void {.importc: "igDockBuilderRemoveNodeChildNodes".}
proc igDockBuilderRemoveNodeDockedWindows*(node_id: ImGuiID, clear_settings_refs: bool = true): void {.importc: "igDockBuilderRemoveNodeDockedWindows".}
proc igDockBuilderSetNodePos*(node_id: ImGuiID, pos: ImVec2): void {.importc: "igDockBuilderSetNodePos".}
proc igDockBuilderSetNodeSize*(node_id: ImGuiID, size: ImVec2): void {.importc: "igDockBuilderSetNodeSize".}
proc igDockBuilderSplitNode*(node_id: ImGuiID, split_dir: ImGuiDir, size_ratio_for_node_at_dir: float32, out_id_at_dir: ptr ImGuiID, out_id_at_opposite_dir: ptr ImGuiID): ImGuiID {.importc: "igDockBuilderSplitNode".}
proc igDockContextCalcDropPosForDocking*(target: ptr ImGuiWindow, target_node: ptr ImGuiDockNode, payload_window: ptr ImGuiWindow, payload_node: ptr ImGuiDockNode, split_dir: ImGuiDir, split_outer: bool, out_pos: ptr ImVec2): bool {.importc: "igDockContextCalcDropPosForDocking".}
proc igDockContextClearNodes*(ctx: ptr ImGuiContext, root_id: ImGuiID, clear_settings_refs: bool): void {.importc: "igDockContextClearNodes".}
proc igDockContextEndFrame*(ctx: ptr ImGuiContext): void {.importc: "igDockContextEndFrame".}
proc igDockContextFindNodeByID*(ctx: ptr ImGuiContext, id: ImGuiID): ptr ImGuiDockNode {.importc: "igDockContextFindNodeByID".}
proc igDockContextGenNodeID*(ctx: ptr ImGuiContext): ImGuiID {.importc: "igDockContextGenNodeID".}
proc igDockContextInitialize*(ctx: ptr ImGuiContext): void {.importc: "igDockContextInitialize".}
proc igDockContextNewFrameUpdateDocking*(ctx: ptr ImGuiContext): void {.importc: "igDockContextNewFrameUpdateDocking".}
proc igDockContextNewFrameUpdateUndocking*(ctx: ptr ImGuiContext): void {.importc: "igDockContextNewFrameUpdateUndocking".}
proc igDockContextProcessUndockNode*(ctx: ptr ImGuiContext, node: ptr ImGuiDockNode): void {.importc: "igDockContextProcessUndockNode".}
proc igDockContextProcessUndockWindow*(ctx: ptr ImGuiContext, window: ptr ImGuiWindow, clear_persistent_docking_ref: bool = true): void {.importc: "igDockContextProcessUndockWindow".}
proc igDockContextQueueDock*(ctx: ptr ImGuiContext, target: ptr ImGuiWindow, target_node: ptr ImGuiDockNode, payload: ptr ImGuiWindow, split_dir: ImGuiDir, split_ratio: float32, split_outer: bool): void {.importc: "igDockContextQueueDock".}
proc igDockContextQueueUndockNode*(ctx: ptr ImGuiContext, node: ptr ImGuiDockNode): void {.importc: "igDockContextQueueUndockNode".}
proc igDockContextQueueUndockWindow*(ctx: ptr ImGuiContext, window: ptr ImGuiWindow): void {.importc: "igDockContextQueueUndockWindow".}
proc igDockContextRebuildNodes*(ctx: ptr ImGuiContext): void {.importc: "igDockContextRebuildNodes".}
proc igDockContextShutdown*(ctx: ptr ImGuiContext): void {.importc: "igDockContextShutdown".}
proc igDockNodeBeginAmendTabBar*(node: ptr ImGuiDockNode): bool {.importc: "igDockNodeBeginAmendTabBar".}
proc igDockNodeEndAmendTabBar*(): void {.importc: "igDockNodeEndAmendTabBar".}
proc igDockNodeGetDepth*(node: ptr ImGuiDockNode): int32 {.importc: "igDockNodeGetDepth".}
proc igDockNodeGetRootNode*(node: ptr ImGuiDockNode): ptr ImGuiDockNode {.importc: "igDockNodeGetRootNode".}
proc igDockNodeGetWindowMenuButtonId*(node: ptr ImGuiDockNode): ImGuiID {.importc: "igDockNodeGetWindowMenuButtonId".}
proc igDockNodeIsInHierarchyOf*(node: ptr ImGuiDockNode, parent: ptr ImGuiDockNode): bool {.importc: "igDockNodeIsInHierarchyOf".}
proc igDockNodeWindowMenuHandler_Default*(ctx: ptr ImGuiContext, node: ptr ImGuiDockNode, tab_bar: ptr ImGuiTabBar): void {.importc: "igDockNodeWindowMenuHandler_Default".}
proc igDockSpace*(id: ImGuiID, size: ImVec2 = ImVec2(x: 0, y: 0), flags: ImGuiDockNodeFlags = 0.ImGuiDockNodeFlags, window_class: ptr ImGuiWindowClass = nil): ImGuiID {.importc: "igDockSpace".}
proc igDockSpaceOverViewport*(viewport: ptr ImGuiViewport = nil, flags: ImGuiDockNodeFlags = 0.ImGuiDockNodeFlags, window_class: ptr ImGuiWindowClass = nil): ImGuiID {.importc: "igDockSpaceOverViewport".}
proc igDragBehavior*(id: ImGuiID, data_type: ImGuiDataType, p_v: pointer, v_speed: float32, p_min: pointer, p_max: pointer, format: cstring, flags: ImGuiSliderFlags): bool {.importc: "igDragBehavior".}
proc igDragFloat*(label: cstring, v: ptr float32, v_speed: float32 = 1.0f, v_min: float32 = 0.0f, v_max: float32 = 0.0f, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragFloat".}
proc igDragFloat2*(label: cstring, v: var array[2, float32], v_speed: float32 = 1.0f, v_min: float32 = 0.0f, v_max: float32 = 0.0f, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragFloat2".}
proc igDragFloat3*(label: cstring, v: var array[3, float32], v_speed: float32 = 1.0f, v_min: float32 = 0.0f, v_max: float32 = 0.0f, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragFloat3".}
proc igDragFloat4*(label: cstring, v: var array[4, float32], v_speed: float32 = 1.0f, v_min: float32 = 0.0f, v_max: float32 = 0.0f, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragFloat4".}
proc igDragFloatRange2*(label: cstring, v_current_min: ptr float32, v_current_max: ptr float32, v_speed: float32 = 1.0f, v_min: float32 = 0.0f, v_max: float32 = 0.0f, format: cstring = "%.3f", format_max: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragFloatRange2".}
proc igDragInt*(label: cstring, v: ptr int32, v_speed: float32 = 1.0f, v_min: int32 = 0, v_max: int32 = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragInt".}
proc igDragInt2*(label: cstring, v: var array[2, int32], v_speed: float32 = 1.0f, v_min: int32 = 0, v_max: int32 = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragInt2".}
proc igDragInt3*(label: cstring, v: var array[3, int32], v_speed: float32 = 1.0f, v_min: int32 = 0, v_max: int32 = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragInt3".}
proc igDragInt4*(label: cstring, v: var array[4, int32], v_speed: float32 = 1.0f, v_min: int32 = 0, v_max: int32 = 0, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragInt4".}
proc igDragIntRange2*(label: cstring, v_current_min: ptr int32, v_current_max: ptr int32, v_speed: float32 = 1.0f, v_min: int32 = 0, v_max: int32 = 0, format: cstring = "%d", format_max: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragIntRange2".}
proc igDragScalar*(label: cstring, data_type: ImGuiDataType, p_data: pointer, v_speed: float32 = 1.0f, p_min: pointer = nil, p_max: pointer = nil, format: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragScalar".}
proc igDragScalarN*(label: cstring, data_type: ImGuiDataType, p_data: pointer, components: int32, v_speed: float32 = 1.0f, p_min: pointer = nil, p_max: pointer = nil, format: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igDragScalarN".}
proc igDummy*(size: ImVec2): void {.importc: "igDummy".}
proc igEnd*(): void {.importc: "igEnd".}
proc igEndChild*(): void {.importc: "igEndChild".}
proc igEndChildFrame*(): void {.importc: "igEndChildFrame".}
proc igEndColumns*(): void {.importc: "igEndColumns".}
proc igEndCombo*(): void {.importc: "igEndCombo".}
proc igEndComboPreview*(): void {.importc: "igEndComboPreview".}
proc igEndDisabled*(): void {.importc: "igEndDisabled".}
proc igEndDragDropSource*(): void {.importc: "igEndDragDropSource".}
proc igEndDragDropTarget*(): void {.importc: "igEndDragDropTarget".}
proc igEndFrame*(): void {.importc: "igEndFrame".}
proc igEndGroup*(): void {.importc: "igEndGroup".}
proc igEndListBox*(): void {.importc: "igEndListBox".}
proc igEndMainMenuBar*(): void {.importc: "igEndMainMenuBar".}
proc igEndMenu*(): void {.importc: "igEndMenu".}
proc igEndMenuBar*(): void {.importc: "igEndMenuBar".}
proc igEndPopup*(): void {.importc: "igEndPopup".}
proc igEndTabBar*(): void {.importc: "igEndTabBar".}
proc igEndTabItem*(): void {.importc: "igEndTabItem".}
proc igEndTable*(): void {.importc: "igEndTable".}
proc igEndTooltip*(): void {.importc: "igEndTooltip".}
proc igErrorCheckEndFrameRecover*(log_callback: ImGuiErrorLogCallback, user_data: pointer = nil): void {.importc: "igErrorCheckEndFrameRecover".}
proc igErrorCheckEndWindowRecover*(log_callback: ImGuiErrorLogCallback, user_data: pointer = nil): void {.importc: "igErrorCheckEndWindowRecover".}
proc igErrorCheckUsingSetCursorPosToExtendParentBoundaries*(): void {.importc: "igErrorCheckUsingSetCursorPosToExtendParentBoundaries".}
proc igFindBestWindowPosForPopupNonUDT*(pOut: ptr ImVec2, window: ptr ImGuiWindow): void {.importc: "igFindBestWindowPosForPopup".}
proc igFindBestWindowPosForPopupExNonUDT*(pOut: ptr ImVec2, ref_pos: ImVec2, size: ImVec2, last_dir: ptr ImGuiDir, r_outer: ImRect, r_avoid: ImRect, policy: ImGuiPopupPositionPolicy): void {.importc: "igFindBestWindowPosForPopupEx".}
proc igFindBlockingModal*(window: ptr ImGuiWindow): ptr ImGuiWindow {.importc: "igFindBlockingModal".}
proc igFindBottomMostVisibleWindowWithinBeginStack*(window: ptr ImGuiWindow): ptr ImGuiWindow {.importc: "igFindBottomMostVisibleWindowWithinBeginStack".}
proc igFindHoveredViewportFromPlatformWindowStack*(mouse_platform_pos: ImVec2): ptr ImGuiViewportP {.importc: "igFindHoveredViewportFromPlatformWindowStack".}
proc igFindOrCreateColumns*(window: ptr ImGuiWindow, id: ImGuiID): ptr ImGuiOldColumns {.importc: "igFindOrCreateColumns".}
proc igFindRenderedTextEnd*(text: cstring, text_end: cstring = nil): cstring {.importc: "igFindRenderedTextEnd".}
proc igFindSettingsHandler*(type_name: cstring): ptr ImGuiSettingsHandler {.importc: "igFindSettingsHandler".}
proc igFindViewportByID*(id: ImGuiID): ptr ImGuiViewport {.importc: "igFindViewportByID".}
proc igFindViewportByPlatformHandle*(platform_handle: pointer): ptr ImGuiViewport {.importc: "igFindViewportByPlatformHandle".}
proc igFindWindowByID*(id: ImGuiID): ptr ImGuiWindow {.importc: "igFindWindowByID".}
proc igFindWindowByName*(name: cstring): ptr ImGuiWindow {.importc: "igFindWindowByName".}
proc igFindWindowDisplayIndex*(window: ptr ImGuiWindow): int32 {.importc: "igFindWindowDisplayIndex".}
proc igFindWindowSettingsByID*(id: ImGuiID): ptr ImGuiWindowSettings {.importc: "igFindWindowSettingsByID".}
proc igFindWindowSettingsByWindow*(window: ptr ImGuiWindow): ptr ImGuiWindowSettings {.importc: "igFindWindowSettingsByWindow".}
proc igFocusItem*(): void {.importc: "igFocusItem".}
proc igFocusTopMostWindowUnderOne*(under_this_window: ptr ImGuiWindow, ignore_window: ptr ImGuiWindow, filter_viewport: ptr ImGuiViewport, flags: ImGuiFocusRequestFlags): void {.importc: "igFocusTopMostWindowUnderOne".}
proc igFocusWindow*(window: ptr ImGuiWindow, flags: ImGuiFocusRequestFlags = 0.ImGuiFocusRequestFlags): void {.importc: "igFocusWindow".}
proc igGcAwakeTransientWindowBuffers*(window: ptr ImGuiWindow): void {.importc: "igGcAwakeTransientWindowBuffers".}
proc igGcCompactTransientMiscBuffers*(): void {.importc: "igGcCompactTransientMiscBuffers".}
proc igGcCompactTransientWindowBuffers*(window: ptr ImGuiWindow): void {.importc: "igGcCompactTransientWindowBuffers".}
proc igGetActiveID*(): ImGuiID {.importc: "igGetActiveID".}
proc igGetAllocatorFunctions*(p_alloc_func: ptr ImGuiMemAllocFunc, p_free_func: ptr ImGuiMemFreeFunc, p_user_data: ptr pointer): void {.importc: "igGetAllocatorFunctions".}
proc igGetBackgroundDrawList*(): ptr ImDrawList {.importc: "igGetBackgroundDrawList_Nil".}
proc igGetBackgroundDrawList*(viewport: ptr ImGuiViewport): ptr ImDrawList {.importc: "igGetBackgroundDrawList_ViewportPtr".}
proc igGetClipboardText*(): cstring {.importc: "igGetClipboardText".}
proc igGetColorU32*(idx: ImGuiCol, alpha_mul: float32 = 1.0f): uint32 {.importc: "igGetColorU32_Col".}
proc igGetColorU32*(col: ImVec4): uint32 {.importc: "igGetColorU32_Vec4".}
proc igGetColorU32*(col: uint32): uint32 {.importc: "igGetColorU32_U32".}
proc igGetColumnIndex*(): int32 {.importc: "igGetColumnIndex".}
proc igGetColumnNormFromOffset*(columns: ptr ImGuiOldColumns, offset: float32): float32 {.importc: "igGetColumnNormFromOffset".}
proc igGetColumnOffset*(column_index: int32 = -1): float32 {.importc: "igGetColumnOffset".}
proc igGetColumnOffsetFromNorm*(columns: ptr ImGuiOldColumns, offset_norm: float32): float32 {.importc: "igGetColumnOffsetFromNorm".}
proc igGetColumnWidth*(column_index: int32 = -1): float32 {.importc: "igGetColumnWidth".}
proc igGetColumnsCount*(): int32 {.importc: "igGetColumnsCount".}
proc igGetColumnsID*(str_id: cstring, count: int32): ImGuiID {.importc: "igGetColumnsID".}
proc igGetContentRegionAvailNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetContentRegionAvail".}
proc igGetContentRegionMaxNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetContentRegionMax".}
proc igGetContentRegionMaxAbsNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetContentRegionMaxAbs".}
proc igGetCurrentContext*(): ptr ImGuiContext {.importc: "igGetCurrentContext".}
proc igGetCurrentFocusScope*(): ImGuiID {.importc: "igGetCurrentFocusScope".}
proc igGetCurrentTabBar*(): ptr ImGuiTabBar {.importc: "igGetCurrentTabBar".}
proc igGetCurrentTable*(): ptr ImGuiTable {.importc: "igGetCurrentTable".}
proc igGetCurrentWindow*(): ptr ImGuiWindow {.importc: "igGetCurrentWindow".}
proc igGetCurrentWindowRead*(): ptr ImGuiWindow {.importc: "igGetCurrentWindowRead".}
proc igGetCursorPosNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetCursorPos".}
proc igGetCursorPosX*(): float32 {.importc: "igGetCursorPosX".}
proc igGetCursorPosY*(): float32 {.importc: "igGetCursorPosY".}
proc igGetCursorScreenPosNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetCursorScreenPos".}
proc igGetCursorStartPosNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetCursorStartPos".}
proc igGetDefaultFont*(): ptr ImFont {.importc: "igGetDefaultFont".}
proc igGetDragDropPayload*(): ptr ImGuiPayload {.importc: "igGetDragDropPayload".}
proc igGetDrawData*(): ptr ImDrawData {.importc: "igGetDrawData".}
proc igGetDrawListSharedData*(): ptr ImDrawListSharedData {.importc: "igGetDrawListSharedData".}
proc igGetFocusID*(): ImGuiID {.importc: "igGetFocusID".}
proc igGetFont*(): ptr ImFont {.importc: "igGetFont".}
proc igGetFontSize*(): float32 {.importc: "igGetFontSize".}
proc igGetFontTexUvWhitePixelNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetFontTexUvWhitePixel".}
proc igGetForegroundDrawList*(): ptr ImDrawList {.importc: "igGetForegroundDrawList_Nil".}
proc igGetForegroundDrawList*(viewport: ptr ImGuiViewport): ptr ImDrawList {.importc: "igGetForegroundDrawList_ViewportPtr".}
proc igGetForegroundDrawList*(window: ptr ImGuiWindow): ptr ImDrawList {.importc: "igGetForegroundDrawList_WindowPtr".}
proc igGetFrameCount*(): int32 {.importc: "igGetFrameCount".}
proc igGetFrameHeight*(): float32 {.importc: "igGetFrameHeight".}
proc igGetFrameHeightWithSpacing*(): float32 {.importc: "igGetFrameHeightWithSpacing".}
proc igGetHoveredID*(): ImGuiID {.importc: "igGetHoveredID".}
proc igGetID*(str_id: cstring): ImGuiID {.importc: "igGetID_Str".}
proc igGetID*(str_id_begin: cstring, str_id_end: cstring): ImGuiID {.importc: "igGetID_StrStr".}
proc igGetID*(ptr_id: pointer): ImGuiID {.importc: "igGetID_Ptr".}
proc igGetIDWithSeed*(str_id_begin: cstring, str_id_end: cstring, seed: ImGuiID): ImGuiID {.importc: "igGetIDWithSeed_Str".}
proc igGetIDWithSeed*(n: int32, seed: ImGuiID): ImGuiID {.importc: "igGetIDWithSeed_Int".}
proc igGetIO*(): ptr ImGuiIO {.importc: "igGetIO".}
proc igGetInputTextState*(id: ImGuiID): ptr ImGuiInputTextState {.importc: "igGetInputTextState".}
proc igGetItemFlags*(): ImGuiItemFlags {.importc: "igGetItemFlags".}
proc igGetItemID*(): ImGuiID {.importc: "igGetItemID".}
proc igGetItemRectMaxNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetItemRectMax".}
proc igGetItemRectMinNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetItemRectMin".}
proc igGetItemRectSizeNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetItemRectSize".}
proc igGetItemStatusFlags*(): ImGuiItemStatusFlags {.importc: "igGetItemStatusFlags".}
proc igGetKeyChordName*(key_chord: ImGuiKeyChord, out_buf: cstring, out_buf_size: int32): void {.importc: "igGetKeyChordName".}
proc igGetKeyData*(ctx: ptr ImGuiContext, key: ImGuiKey): ptr ImGuiKeyData {.importc: "igGetKeyData_ContextPtr".}
proc igGetKeyData*(key: ImGuiKey): ptr ImGuiKeyData {.importc: "igGetKeyData_Key".}
proc igGetKeyIndex*(key: ImGuiKey): ImGuiKey {.importc: "igGetKeyIndex".}
proc igGetKeyMagnitude2dNonUDT*(pOut: ptr ImVec2, key_left: ImGuiKey, key_right: ImGuiKey, key_up: ImGuiKey, key_down: ImGuiKey): void {.importc: "igGetKeyMagnitude2d".}
proc igGetKeyName*(key: ImGuiKey): cstring {.importc: "igGetKeyName".}
proc igGetKeyOwner*(key: ImGuiKey): ImGuiID {.importc: "igGetKeyOwner".}
proc igGetKeyOwnerData*(ctx: ptr ImGuiContext, key: ImGuiKey): ptr ImGuiKeyOwnerData {.importc: "igGetKeyOwnerData".}
proc igGetKeyPressedAmount*(key: ImGuiKey, repeat_delay: float32, rate: float32): int32 {.importc: "igGetKeyPressedAmount".}
proc igGetMainViewport*(): ptr ImGuiViewport {.importc: "igGetMainViewport".}
proc igGetMouseClickedCount*(button: ImGuiMouseButton): int32 {.importc: "igGetMouseClickedCount".}
proc igGetMouseCursor*(): ImGuiMouseCursor {.importc: "igGetMouseCursor".}
proc igGetMouseDragDeltaNonUDT*(pOut: ptr ImVec2, button: ImGuiMouseButton = 0.ImGuiMouseButton, lock_threshold: float32 = -1.0f): void {.importc: "igGetMouseDragDelta".}
proc igGetMousePosNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetMousePos".}
proc igGetMousePosOnOpeningCurrentPopupNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetMousePosOnOpeningCurrentPopup".}
proc igGetNavTweakPressedAmount*(axis: ImGuiAxis): float32 {.importc: "igGetNavTweakPressedAmount".}
proc igGetPlatformIO*(): ptr ImGuiPlatformIO {.importc: "igGetPlatformIO".}
proc igGetPopupAllowedExtentRectNonUDT*(pOut: ptr ImRect, window: ptr ImGuiWindow): void {.importc: "igGetPopupAllowedExtentRect".}
proc igGetScrollMaxX*(): float32 {.importc: "igGetScrollMaxX".}
proc igGetScrollMaxY*(): float32 {.importc: "igGetScrollMaxY".}
proc igGetScrollX*(): float32 {.importc: "igGetScrollX".}
proc igGetScrollY*(): float32 {.importc: "igGetScrollY".}
proc igGetShortcutRoutingData*(key_chord: ImGuiKeyChord): ptr ImGuiKeyRoutingData {.importc: "igGetShortcutRoutingData".}
proc igGetStateStorage*(): ptr ImGuiStorage {.importc: "igGetStateStorage".}
proc igGetStyle*(): ptr ImGuiStyle {.importc: "igGetStyle".}
proc igGetStyleColorName*(idx: ImGuiCol): cstring {.importc: "igGetStyleColorName".}
proc igGetStyleColorVec4*(idx: ImGuiCol): ptr ImVec4 {.importc: "igGetStyleColorVec4".}
proc igGetStyleVarInfo*(idx: ImGuiStyleVar): ptr ImGuiDataVarInfo {.importc: "igGetStyleVarInfo".}
proc igGetTextLineHeight*(): float32 {.importc: "igGetTextLineHeight".}
proc igGetTextLineHeightWithSpacing*(): float32 {.importc: "igGetTextLineHeightWithSpacing".}
proc igGetTime*(): float64 {.importc: "igGetTime".}
proc igGetTopMostAndVisiblePopupModal*(): ptr ImGuiWindow {.importc: "igGetTopMostAndVisiblePopupModal".}
proc igGetTopMostPopupModal*(): ptr ImGuiWindow {.importc: "igGetTopMostPopupModal".}
proc igGetTreeNodeToLabelSpacing*(): float32 {.importc: "igGetTreeNodeToLabelSpacing".}
proc igGetTypematicRepeatRate*(flags: ImGuiInputFlags, repeat_delay: ptr float32, repeat_rate: ptr float32): void {.importc: "igGetTypematicRepeatRate".}
proc igGetVersion*(): cstring {.importc: "igGetVersion".}
proc igGetViewportPlatformMonitor*(viewport: ptr ImGuiViewport): ptr ImGuiPlatformMonitor {.importc: "igGetViewportPlatformMonitor".}
proc igGetWindowAlwaysWantOwnTabBar*(window: ptr ImGuiWindow): bool {.importc: "igGetWindowAlwaysWantOwnTabBar".}
proc igGetWindowContentRegionMaxNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetWindowContentRegionMax".}
proc igGetWindowContentRegionMinNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetWindowContentRegionMin".}
proc igGetWindowDockID*(): ImGuiID {.importc: "igGetWindowDockID".}
proc igGetWindowDockNode*(): ptr ImGuiDockNode {.importc: "igGetWindowDockNode".}
proc igGetWindowDpiScale*(): float32 {.importc: "igGetWindowDpiScale".}
proc igGetWindowDrawList*(): ptr ImDrawList {.importc: "igGetWindowDrawList".}
proc igGetWindowHeight*(): float32 {.importc: "igGetWindowHeight".}
proc igGetWindowPosNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetWindowPos".}
proc igGetWindowResizeBorderID*(window: ptr ImGuiWindow, dir: ImGuiDir): ImGuiID {.importc: "igGetWindowResizeBorderID".}
proc igGetWindowResizeCornerID*(window: ptr ImGuiWindow, n: int32): ImGuiID {.importc: "igGetWindowResizeCornerID".}
proc igGetWindowScrollbarID*(window: ptr ImGuiWindow, axis: ImGuiAxis): ImGuiID {.importc: "igGetWindowScrollbarID".}
proc igGetWindowScrollbarRectNonUDT*(pOut: ptr ImRect, window: ptr ImGuiWindow, axis: ImGuiAxis): void {.importc: "igGetWindowScrollbarRect".}
proc igGetWindowSizeNonUDT*(pOut: ptr ImVec2): void {.importc: "igGetWindowSize".}
proc igGetWindowViewport*(): ptr ImGuiViewport {.importc: "igGetWindowViewport".}
proc igGetWindowWidth*(): float32 {.importc: "igGetWindowWidth".}
proc igImAbs*(x: int32): int32 {.importc: "igImAbs_Int".}
proc igImAbs*(x: float32): float32 {.importc: "igImAbs_Float".}
proc igImAbs*(x: float64): float64 {.importc: "igImAbs_double".}
proc igImAlphaBlendColors*(col_a: uint32, col_b: uint32): uint32 {.importc: "igImAlphaBlendColors".}
proc igImBezierCubicCalcNonUDT*(pOut: ptr ImVec2, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, t: float32): void {.importc: "igImBezierCubicCalc".}
proc igImBezierCubicClosestPointNonUDT*(pOut: ptr ImVec2, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, p: ImVec2, num_segments: int32): void {.importc: "igImBezierCubicClosestPoint".}
proc igImBezierCubicClosestPointCasteljauNonUDT*(pOut: ptr ImVec2, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, p: ImVec2, tess_tol: float32): void {.importc: "igImBezierCubicClosestPointCasteljau".}
proc igImBezierQuadraticCalcNonUDT*(pOut: ptr ImVec2, p1: ImVec2, p2: ImVec2, p3: ImVec2, t: float32): void {.importc: "igImBezierQuadraticCalc".}
proc igImBitArrayClearAllBits*(arr: ptr uint32, bitcount: int32): void {.importc: "igImBitArrayClearAllBits".}
proc igImBitArrayClearBit*(arr: ptr uint32, n: int32): void {.importc: "igImBitArrayClearBit".}
proc igImBitArrayGetStorageSizeInBytes*(bitcount: int32): uint {.importc: "igImBitArrayGetStorageSizeInBytes".}
proc igImBitArraySetBit*(arr: ptr uint32, n: int32): void {.importc: "igImBitArraySetBit".}
proc igImBitArraySetBitRange*(arr: ptr uint32, n: int32, n2: int32): void {.importc: "igImBitArraySetBitRange".}
proc igImBitArrayTestBit*(arr: ptr uint32, n: int32): bool {.importc: "igImBitArrayTestBit".}
proc igImCharIsBlankA*(c: int8): bool {.importc: "igImCharIsBlankA".}
proc igImCharIsBlankW*(c: uint32): bool {.importc: "igImCharIsBlankW".}
proc igImClampNonUDT*(pOut: ptr ImVec2, v: ImVec2, mn: ImVec2, mx: ImVec2): void {.importc: "igImClamp".}
proc igImDot*(a: ImVec2, b: ImVec2): float32 {.importc: "igImDot".}
proc igImExponentialMovingAverage*(avg: float32, sample: float32, n: int32): float32 {.importc: "igImExponentialMovingAverage".}
proc igImFileClose*(file: ImFileHandle): bool {.importc: "igImFileClose".}
proc igImFileGetSize*(file: ImFileHandle): uint64 {.importc: "igImFileGetSize".}
proc igImFileLoadToMemory*(filename: cstring, mode: cstring, out_file_size: ptr uint = nil, padding_bytes: int32 = 0): pointer {.importc: "igImFileLoadToMemory".}
proc igImFileOpen*(filename: cstring, mode: cstring): ImFileHandle {.importc: "igImFileOpen".}
proc igImFileRead*(data: pointer, size: uint64, count: uint64, file: ImFileHandle): uint64 {.importc: "igImFileRead".}
proc igImFileWrite*(data: pointer, size: uint64, count: uint64, file: ImFileHandle): uint64 {.importc: "igImFileWrite".}
proc igImFloor*(f: float32): float32 {.importc: "igImFloor_Float".}
proc igImFloorNonUDT*(pOut: ptr ImVec2, v: ImVec2): void {.importc: "igImFloor_Vec2".}
proc igImFloorSigned*(f: float32): float32 {.importc: "igImFloorSigned_Float".}
proc igImFloorSignedNonUDT*(pOut: ptr ImVec2, v: ImVec2): void {.importc: "igImFloorSigned_Vec2".}
proc igImFontAtlasBuildFinish*(atlas: ptr ImFontAtlas): void {.importc: "igImFontAtlasBuildFinish".}
proc igImFontAtlasBuildInit*(atlas: ptr ImFontAtlas): void {.importc: "igImFontAtlasBuildInit".}
proc igImFontAtlasBuildMultiplyCalcLookupTable*(out_table: uint8, in_multiply_factor: float32): void {.importc: "igImFontAtlasBuildMultiplyCalcLookupTable".}
proc igImFontAtlasBuildMultiplyRectAlpha8*(table: uint8, pixels: ptr uint8, x: int32, y: int32, w: int32, h: int32, stride: int32): void {.importc: "igImFontAtlasBuildMultiplyRectAlpha8".}
proc igImFontAtlasBuildPackCustomRects*(atlas: ptr ImFontAtlas, stbrp_context_opaque: pointer): void {.importc: "igImFontAtlasBuildPackCustomRects".}
proc igImFontAtlasBuildRender32bppRectFromString*(atlas: ptr ImFontAtlas, x: int32, y: int32, w: int32, h: int32, in_str: cstring, in_marker_char: int8, in_marker_pixel_value: uint32): void {.importc: "igImFontAtlasBuildRender32bppRectFromString".}
proc igImFontAtlasBuildRender8bppRectFromString*(atlas: ptr ImFontAtlas, x: int32, y: int32, w: int32, h: int32, in_str: cstring, in_marker_char: int8, in_marker_pixel_value: uint8): void {.importc: "igImFontAtlasBuildRender8bppRectFromString".}
proc igImFontAtlasBuildSetupFont*(atlas: ptr ImFontAtlas, font: ptr ImFont, font_config: ptr ImFontConfig, ascent: float32, descent: float32): void {.importc: "igImFontAtlasBuildSetupFont".}
proc igImFontAtlasGetBuilderForStbTruetype*(): ptr ImFontBuilderIO {.importc: "igImFontAtlasGetBuilderForStbTruetype".}
proc igImFormatString*(buf: cstring, buf_size: uint, fmt: cstring): int32 {.importc: "igImFormatString", varargs.}
proc igImFormatStringToTempBuffer*(out_buf: ptr cstring, out_buf_end: ptr cstring, fmt: cstring): void {.importc: "igImFormatStringToTempBuffer", varargs.}
proc igImFormatStringToTempBufferV*(out_buf: ptr cstring, out_buf_end: ptr cstring, fmt: cstring): void {.importc: "igImFormatStringToTempBufferV", varargs.}
proc igImFormatStringV*(buf: cstring, buf_size: uint, fmt: cstring): int32 {.importc: "igImFormatStringV", varargs.}
proc igImHashData*(data: pointer, data_size: uint, seed: ImGuiID = 0.ImGuiID): ImGuiID {.importc: "igImHashData".}
proc igImHashStr*(data: cstring, data_size: uint = 0, seed: ImGuiID = 0.ImGuiID): ImGuiID {.importc: "igImHashStr".}
proc igImInvLength*(lhs: ImVec2, fail_value: float32): float32 {.importc: "igImInvLength".}
proc igImIsFloatAboveGuaranteedIntegerPrecision*(f: float32): bool {.importc: "igImIsFloatAboveGuaranteedIntegerPrecision".}
proc igImIsPowerOfTwo*(v: int32): bool {.importc: "igImIsPowerOfTwo_Int".}
proc igImIsPowerOfTwo*(v: uint64): bool {.importc: "igImIsPowerOfTwo_U64".}
proc igImLengthSqr*(lhs: ImVec2): float32 {.importc: "igImLengthSqr_Vec2".}
proc igImLengthSqr*(lhs: ImVec4): float32 {.importc: "igImLengthSqr_Vec4".}
proc igImLerpNonUDT*(pOut: ptr ImVec2, a: ImVec2, b: ImVec2, t: float32): void {.importc: "igImLerp_Vec2Float".}
proc igImLerpNonUDT2*(pOut: ptr ImVec2, a: ImVec2, b: ImVec2, t: ImVec2): void {.importc: "igImLerp_Vec2Vec2".}
proc igImLerpNonUDT3*(pOut: ptr ImVec4, a: ImVec4, b: ImVec4, t: float32): void {.importc: "igImLerp_Vec4".}
proc igImLineClosestPointNonUDT*(pOut: ptr ImVec2, a: ImVec2, b: ImVec2, p: ImVec2): void {.importc: "igImLineClosestPoint".}
proc igImLinearSweep*(current: float32, target: float32, speed: float32): float32 {.importc: "igImLinearSweep".}
proc igImLog*(x: float32): float32 {.importc: "igImLog_Float".}
proc igImLog*(x: float64): float64 {.importc: "igImLog_double".}
proc igImMaxNonUDT*(pOut: ptr ImVec2, lhs: ImVec2, rhs: ImVec2): void {.importc: "igImMax".}
proc igImMinNonUDT*(pOut: ptr ImVec2, lhs: ImVec2, rhs: ImVec2): void {.importc: "igImMin".}
proc igImModPositive*(a: int32, b: int32): int32 {.importc: "igImModPositive".}
proc igImMulNonUDT*(pOut: ptr ImVec2, lhs: ImVec2, rhs: ImVec2): void {.importc: "igImMul".}
proc igImParseFormatFindEnd*(format: cstring): cstring {.importc: "igImParseFormatFindEnd".}
proc igImParseFormatFindStart*(format: cstring): cstring {.importc: "igImParseFormatFindStart".}
proc igImParseFormatPrecision*(format: cstring, default_value: int32): int32 {.importc: "igImParseFormatPrecision".}
proc igImParseFormatSanitizeForPrinting*(fmt_in: cstring, fmt_out: cstring, fmt_out_size: uint): void {.importc: "igImParseFormatSanitizeForPrinting".}
proc igImParseFormatSanitizeForScanning*(fmt_in: cstring, fmt_out: cstring, fmt_out_size: uint): cstring {.importc: "igImParseFormatSanitizeForScanning".}
proc igImParseFormatTrimDecorations*(format: cstring, buf: cstring, buf_size: uint): cstring {.importc: "igImParseFormatTrimDecorations".}
proc igImPow*(x: float32, y: float32): float32 {.importc: "igImPow_Float".}
proc igImPow*(x: float64, y: float64): float64 {.importc: "igImPow_double".}
proc igImQsort*(base: pointer, count: uint, size_of_element: uint, compare_func: proc(unamed_arg_1: pointer, unamed_arg_2: pointer): int32 {.cdecl, varargs.}): void {.importc: "igImQsort".}
proc igImRotateNonUDT*(pOut: ptr ImVec2, v: ImVec2, cos_a: float32, sin_a: float32): void {.importc: "igImRotate".}
proc igImRsqrt*(x: float32): float32 {.importc: "igImRsqrt_Float".}
proc igImRsqrt*(x: float64): float64 {.importc: "igImRsqrt_double".}
proc igImSaturate*(f: float32): float32 {.importc: "igImSaturate".}
proc igImSign*(x: float32): float32 {.importc: "igImSign_Float".}
proc igImSign*(x: float64): float64 {.importc: "igImSign_double".}
proc igImStrSkipBlank*(str: cstring): cstring {.importc: "igImStrSkipBlank".}
proc igImStrTrimBlanks*(str: cstring): void {.importc: "igImStrTrimBlanks".}
proc igImStrbolW*(buf_mid_line: ptr ImWchar, buf_begin: ptr ImWchar): ptr ImWchar {.importc: "igImStrbolW".}
proc igImStrchrRange*(str_begin: cstring, str_end: cstring, c: int8): cstring {.importc: "igImStrchrRange".}
proc igImStrdup*(str: cstring): cstring {.importc: "igImStrdup".}
proc igImStrdupcpy*(dst: cstring, p_dst_size: ptr uint, str: cstring): cstring {.importc: "igImStrdupcpy".}
proc igImStreolRange*(str: cstring, str_end: cstring): cstring {.importc: "igImStreolRange".}
proc igImStricmp*(str1: cstring, str2: cstring): int32 {.importc: "igImStricmp".}
proc igImStristr*(haystack: cstring, haystack_end: cstring, needle: cstring, needle_end: cstring): cstring {.importc: "igImStristr".}
proc igImStrlenW*(str: ptr ImWchar): int32 {.importc: "igImStrlenW".}
proc igImStrncpy*(dst: cstring, src: cstring, count: uint): void {.importc: "igImStrncpy".}
proc igImStrnicmp*(str1: cstring, str2: cstring, count: uint): int32 {.importc: "igImStrnicmp".}
proc igImTextCharFromUtf8*(out_char: ptr uint32, in_text: cstring, in_text_end: cstring): int32 {.importc: "igImTextCharFromUtf8".}
proc igImTextCharToUtf8*(out_buf: var array[5, int8], c: uint32): cstring {.importc: "igImTextCharToUtf8".}
proc igImTextCountCharsFromUtf8*(in_text: cstring, in_text_end: cstring): int32 {.importc: "igImTextCountCharsFromUtf8".}
proc igImTextCountUtf8BytesFromChar*(in_text: cstring, in_text_end: cstring): int32 {.importc: "igImTextCountUtf8BytesFromChar".}
proc igImTextCountUtf8BytesFromStr*(in_text: ptr ImWchar, in_text_end: ptr ImWchar): int32 {.importc: "igImTextCountUtf8BytesFromStr".}
proc igImTextStrFromUtf8*(out_buf: ptr ImWchar, out_buf_size: int32, in_text: cstring, in_text_end: cstring, in_remaining: ptr cstring = nil): int32 {.importc: "igImTextStrFromUtf8".}
proc igImTextStrToUtf8*(out_buf: cstring, out_buf_size: int32, in_text: ptr ImWchar, in_text_end: ptr ImWchar): int32 {.importc: "igImTextStrToUtf8".}
proc igImToUpper*(c: int8): int8 {.importc: "igImToUpper".}
proc igImTriangleArea*(a: ImVec2, b: ImVec2, c: ImVec2): float32 {.importc: "igImTriangleArea".}
proc igImTriangleBarycentricCoords*(a: ImVec2, b: ImVec2, c: ImVec2, p: ImVec2, out_u: ptr float32, out_v: ptr float32, out_w: ptr float32): void {.importc: "igImTriangleBarycentricCoords".}
proc igImTriangleClosestPointNonUDT*(pOut: ptr ImVec2, a: ImVec2, b: ImVec2, c: ImVec2, p: ImVec2): void {.importc: "igImTriangleClosestPoint".}
proc igImTriangleContainsPoint*(a: ImVec2, b: ImVec2, c: ImVec2, p: ImVec2): bool {.importc: "igImTriangleContainsPoint".}
proc igImUpperPowerOfTwo*(v: int32): int32 {.importc: "igImUpperPowerOfTwo".}
proc igImage*(user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2(x: 0, y: 0), uv1: ImVec2 = ImVec2(x: 1, y: 1), tint_col: ImVec4 = ImVec4(x: 1, y: 1, z: 1, w: 1), border_col: ImVec4 = ImVec4(x: 0, y: 0, z: 0, w: 0)): void {.importc: "igImage".}
proc igImageButton*(str_id: cstring, user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2(x: 0, y: 0), uv1: ImVec2 = ImVec2(x: 1, y: 1), bg_col: ImVec4 = ImVec4(x: 0, y: 0, z: 0, w: 0), tint_col: ImVec4 = ImVec4(x: 1, y: 1, z: 1, w: 1)): bool {.importc: "igImageButton".}
proc igImageButtonEx*(id: ImGuiID, texture_id: ImTextureID, size: ImVec2, uv0: ImVec2, uv1: ImVec2, bg_col: ImVec4, tint_col: ImVec4, flags: ImGuiButtonFlags = 0.ImGuiButtonFlags): bool {.importc: "igImageButtonEx".}
proc igIndent*(indent_w: float32 = 0.0f): void {.importc: "igIndent".}
proc igInitialize*(): void {.importc: "igInitialize".}
proc igInputDouble*(label: cstring, v: ptr float64, step: float64 = 0.0, step_fast: float64 = 0.0, format: cstring = "%.6f", flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputDouble".}
proc igInputFloat*(label: cstring, v: ptr float32, step: float32 = 0.0f, step_fast: float32 = 0.0f, format: cstring = "%.3f", flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputFloat".}
proc igInputFloat2*(label: cstring, v: var array[2, float32], format: cstring = "%.3f", flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputFloat2".}
proc igInputFloat3*(label: cstring, v: var array[3, float32], format: cstring = "%.3f", flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputFloat3".}
proc igInputFloat4*(label: cstring, v: var array[4, float32], format: cstring = "%.3f", flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputFloat4".}
proc igInputInt*(label: cstring, v: ptr int32, step: int32 = 1, step_fast: int32 = 100, flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputInt".}
proc igInputInt2*(label: cstring, v: var array[2, int32], flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputInt2".}
proc igInputInt3*(label: cstring, v: var array[3, int32], flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputInt3".}
proc igInputInt4*(label: cstring, v: var array[4, int32], flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputInt4".}
proc igInputScalar*(label: cstring, data_type: ImGuiDataType, p_data: pointer, p_step: pointer = nil, p_step_fast: pointer = nil, format: cstring = nil, flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputScalar".}
proc igInputScalarN*(label: cstring, data_type: ImGuiDataType, p_data: pointer, components: int32, p_step: pointer = nil, p_step_fast: pointer = nil, format: cstring = nil, flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags): bool {.importc: "igInputScalarN".}
proc igInputText*(label: cstring, buf: cstring, buf_size: uint, flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags, callback: ImGuiInputTextCallback = nil, user_data: pointer = nil): bool {.importc: "igInputText".}
proc igInputTextDeactivateHook*(id: ImGuiID): void {.importc: "igInputTextDeactivateHook".}
proc igInputTextEx*(label: cstring, hint: cstring, buf: cstring, buf_size: int32, size_arg: ImVec2, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback = nil, user_data: pointer = nil): bool {.importc: "igInputTextEx".}
proc igInputTextMultiline*(label: cstring, buf: cstring, buf_size: uint, size: ImVec2 = ImVec2(x: 0, y: 0), flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags, callback: ImGuiInputTextCallback = nil, user_data: pointer = nil): bool {.importc: "igInputTextMultiline".}
proc igInputTextWithHint*(label: cstring, hint: cstring, buf: cstring, buf_size: uint, flags: ImGuiInputTextFlags = 0.ImGuiInputTextFlags, callback: ImGuiInputTextCallback = nil, user_data: pointer = nil): bool {.importc: "igInputTextWithHint".}
proc igInvisibleButton*(str_id: cstring, size: ImVec2, flags: ImGuiButtonFlags = 0.ImGuiButtonFlags): bool {.importc: "igInvisibleButton".}
proc igIsActiveIdUsingNavDir*(dir: ImGuiDir): bool {.importc: "igIsActiveIdUsingNavDir".}
proc igIsAliasKey*(key: ImGuiKey): bool {.importc: "igIsAliasKey".}
proc igIsAnyItemActive*(): bool {.importc: "igIsAnyItemActive".}
proc igIsAnyItemFocused*(): bool {.importc: "igIsAnyItemFocused".}
proc igIsAnyItemHovered*(): bool {.importc: "igIsAnyItemHovered".}
proc igIsAnyMouseDown*(): bool {.importc: "igIsAnyMouseDown".}
proc igIsClippedEx*(bb: ImRect, id: ImGuiID): bool {.importc: "igIsClippedEx".}
proc igIsDragDropActive*(): bool {.importc: "igIsDragDropActive".}
proc igIsDragDropPayloadBeingAccepted*(): bool {.importc: "igIsDragDropPayloadBeingAccepted".}
proc igIsGamepadKey*(key: ImGuiKey): bool {.importc: "igIsGamepadKey".}
proc igIsItemActivated*(): bool {.importc: "igIsItemActivated".}
proc igIsItemActive*(): bool {.importc: "igIsItemActive".}
proc igIsItemClicked*(mouse_button: ImGuiMouseButton = 0.ImGuiMouseButton): bool {.importc: "igIsItemClicked".}
proc igIsItemDeactivated*(): bool {.importc: "igIsItemDeactivated".}
proc igIsItemDeactivatedAfterEdit*(): bool {.importc: "igIsItemDeactivatedAfterEdit".}
proc igIsItemEdited*(): bool {.importc: "igIsItemEdited".}
proc igIsItemFocused*(): bool {.importc: "igIsItemFocused".}
proc igIsItemHovered*(flags: ImGuiHoveredFlags = 0.ImGuiHoveredFlags): bool {.importc: "igIsItemHovered".}
proc igIsItemToggledOpen*(): bool {.importc: "igIsItemToggledOpen".}
proc igIsItemToggledSelection*(): bool {.importc: "igIsItemToggledSelection".}
proc igIsItemVisible*(): bool {.importc: "igIsItemVisible".}
proc igIsKeyDown*(key: ImGuiKey): bool {.importc: "igIsKeyDown_Nil".}
proc igIsKeyDown*(key: ImGuiKey, owner_id: ImGuiID): bool {.importc: "igIsKeyDown_ID".}
proc igIsKeyPressed*(key: ImGuiKey, repeat: bool = true): bool {.importc: "igIsKeyPressed_Bool".}
proc igIsKeyPressed*(key: ImGuiKey, owner_id: ImGuiID, flags: ImGuiInputFlags = 0.ImGuiInputFlags): bool {.importc: "igIsKeyPressed_ID".}
proc igIsKeyPressedMap*(key: ImGuiKey, repeat: bool = true): bool {.importc: "igIsKeyPressedMap".}
proc igIsKeyReleased*(key: ImGuiKey): bool {.importc: "igIsKeyReleased_Nil".}
proc igIsKeyReleased*(key: ImGuiKey, owner_id: ImGuiID): bool {.importc: "igIsKeyReleased_ID".}
proc igIsKeyboardKey*(key: ImGuiKey): bool {.importc: "igIsKeyboardKey".}
proc igIsLegacyKey*(key: ImGuiKey): bool {.importc: "igIsLegacyKey".}
proc igIsMouseClicked*(button: ImGuiMouseButton, repeat: bool = false): bool {.importc: "igIsMouseClicked_Bool".}
proc igIsMouseClicked*(button: ImGuiMouseButton, owner_id: ImGuiID, flags: ImGuiInputFlags = 0.ImGuiInputFlags): bool {.importc: "igIsMouseClicked_ID".}
proc igIsMouseDoubleClicked*(button: ImGuiMouseButton): bool {.importc: "igIsMouseDoubleClicked".}
proc igIsMouseDown*(button: ImGuiMouseButton): bool {.importc: "igIsMouseDown_Nil".}
proc igIsMouseDown*(button: ImGuiMouseButton, owner_id: ImGuiID): bool {.importc: "igIsMouseDown_ID".}
proc igIsMouseDragPastThreshold*(button: ImGuiMouseButton, lock_threshold: float32 = -1.0f): bool {.importc: "igIsMouseDragPastThreshold".}
proc igIsMouseDragging*(button: ImGuiMouseButton, lock_threshold: float32 = -1.0f): bool {.importc: "igIsMouseDragging".}
proc igIsMouseHoveringRect*(r_min: ImVec2, r_max: ImVec2, clip: bool = true): bool {.importc: "igIsMouseHoveringRect".}
proc igIsMouseKey*(key: ImGuiKey): bool {.importc: "igIsMouseKey".}
proc igIsMousePosValid*(mouse_pos: ptr ImVec2 = nil): bool {.importc: "igIsMousePosValid".}
proc igIsMouseReleased*(button: ImGuiMouseButton): bool {.importc: "igIsMouseReleased_Nil".}
proc igIsMouseReleased*(button: ImGuiMouseButton, owner_id: ImGuiID): bool {.importc: "igIsMouseReleased_ID".}
proc igIsNamedKey*(key: ImGuiKey): bool {.importc: "igIsNamedKey".}
proc igIsNamedKeyOrModKey*(key: ImGuiKey): bool {.importc: "igIsNamedKeyOrModKey".}
proc igIsPopupOpen*(str_id: cstring, flags: ImGuiPopupFlags = 0.ImGuiPopupFlags): bool {.importc: "igIsPopupOpen_Str".}
proc igIsPopupOpen*(id: ImGuiID, popup_flags: ImGuiPopupFlags): bool {.importc: "igIsPopupOpen_ID".}
proc igIsRectVisible*(size: ImVec2): bool {.importc: "igIsRectVisible_Nil".}
proc igIsRectVisible*(rect_min: ImVec2, rect_max: ImVec2): bool {.importc: "igIsRectVisible_Vec2".}
proc igIsWindowAbove*(potential_above: ptr ImGuiWindow, potential_below: ptr ImGuiWindow): bool {.importc: "igIsWindowAbove".}
proc igIsWindowAppearing*(): bool {.importc: "igIsWindowAppearing".}
proc igIsWindowChildOf*(window: ptr ImGuiWindow, potential_parent: ptr ImGuiWindow, popup_hierarchy: bool, dock_hierarchy: bool): bool {.importc: "igIsWindowChildOf".}
proc igIsWindowCollapsed*(): bool {.importc: "igIsWindowCollapsed".}
proc igIsWindowContentHoverable*(window: ptr ImGuiWindow, flags: ImGuiHoveredFlags = 0.ImGuiHoveredFlags): bool {.importc: "igIsWindowContentHoverable".}
proc igIsWindowDocked*(): bool {.importc: "igIsWindowDocked".}
proc igIsWindowFocused*(flags: ImGuiFocusedFlags = 0.ImGuiFocusedFlags): bool {.importc: "igIsWindowFocused".}
proc igIsWindowHovered*(flags: ImGuiHoveredFlags = 0.ImGuiHoveredFlags): bool {.importc: "igIsWindowHovered".}
proc igIsWindowNavFocusable*(window: ptr ImGuiWindow): bool {.importc: "igIsWindowNavFocusable".}
proc igIsWindowWithinBeginStackOf*(window: ptr ImGuiWindow, potential_parent: ptr ImGuiWindow): bool {.importc: "igIsWindowWithinBeginStackOf".}
proc igItemAdd*(bb: ImRect, id: ImGuiID, nav_bb: ptr ImRect = nil, extra_flags: ImGuiItemFlags = 0.ImGuiItemFlags): bool {.importc: "igItemAdd".}
proc igItemHoverable*(bb: ImRect, id: ImGuiID, item_flags: ImGuiItemFlags): bool {.importc: "igItemHoverable".}
proc igItemSize*(size: ImVec2, text_baseline_y: float32 = -1.0f): void {.importc: "igItemSize_Vec2".}
proc igItemSize*(bb: ImRect, text_baseline_y: float32 = -1.0f): void {.importc: "igItemSize_Rect".}
proc igKeepAliveID*(id: ImGuiID): void {.importc: "igKeepAliveID".}
proc igLabelText*(label: cstring, fmt: cstring): void {.importc: "igLabelText", varargs.}
proc igLabelTextV*(label: cstring, fmt: cstring): void {.importc: "igLabelTextV", varargs.}
proc igListBox*(label: cstring, current_item: ptr int32, items: ptr cstring, items_count: int32, height_in_items: int32 = -1): bool {.importc: "igListBox_Str_arr".}
proc igListBox*(label: cstring, current_item: ptr int32, items_getter: proc(data: pointer, idx: int32, out_text: ptr cstring): bool {.cdecl, varargs.}, data: pointer, items_count: int32, height_in_items: int32 = -1): bool {.importc: "igListBox_FnBoolPtr".}
proc igLoadIniSettingsFromDisk*(ini_filename: cstring): void {.importc: "igLoadIniSettingsFromDisk".}
proc igLoadIniSettingsFromMemory*(ini_data: cstring, ini_size: uint = 0): void {.importc: "igLoadIniSettingsFromMemory".}
proc igLocalizeGetMsg*(key: ImGuiLocKey): cstring {.importc: "igLocalizeGetMsg".}
proc igLocalizeRegisterEntries*(entries: ptr ImGuiLocEntry, count: int32): void {.importc: "igLocalizeRegisterEntries".}
proc igLogBegin*(`type`: ImGuiLogType, auto_open_depth: int32): void {.importc: "igLogBegin".}
proc igLogButtons*(): void {.importc: "igLogButtons".}
proc igLogFinish*(): void {.importc: "igLogFinish".}
proc igLogRenderedText*(ref_pos: ptr ImVec2, text: cstring, text_end: cstring = nil): void {.importc: "igLogRenderedText".}
proc igLogSetNextTextDecoration*(prefix: cstring, suffix: cstring): void {.importc: "igLogSetNextTextDecoration".}
proc igLogText*(fmt: cstring): void {.importc: "igLogText", varargs.}
proc igLogTextV*(fmt: cstring): void {.importc: "igLogTextV", varargs.}
proc igLogToBuffer*(auto_open_depth: int32 = -1): void {.importc: "igLogToBuffer".}
proc igLogToClipboard*(auto_open_depth: int32 = -1): void {.importc: "igLogToClipboard".}
proc igLogToFile*(auto_open_depth: int32 = -1, filename: cstring = nil): void {.importc: "igLogToFile".}
proc igLogToTTY*(auto_open_depth: int32 = -1): void {.importc: "igLogToTTY".}
proc igMarkIniSettingsDirty*(): void {.importc: "igMarkIniSettingsDirty_Nil".}
proc igMarkIniSettingsDirty*(window: ptr ImGuiWindow): void {.importc: "igMarkIniSettingsDirty_WindowPtr".}
proc igMarkItemEdited*(id: ImGuiID): void {.importc: "igMarkItemEdited".}
proc igMemAlloc*(size: uint): pointer {.importc: "igMemAlloc".}
proc igMemFree*(`ptr`: pointer): void {.importc: "igMemFree".}
proc igMenuItem*(label: cstring, shortcut: cstring = nil, selected: bool = false, enabled: bool = true): bool {.importc: "igMenuItem_Bool".}
proc igMenuItem*(label: cstring, shortcut: cstring, p_selected: ptr bool, enabled: bool = true): bool {.importc: "igMenuItem_BoolPtr".}
proc igMenuItemEx*(label: cstring, icon: cstring, shortcut: cstring = nil, selected: bool = false, enabled: bool = true): bool {.importc: "igMenuItemEx".}
proc igMouseButtonToKey*(button: ImGuiMouseButton): ImGuiKey {.importc: "igMouseButtonToKey".}
proc igNavClearPreferredPosForAxis*(axis: ImGuiAxis): void {.importc: "igNavClearPreferredPosForAxis".}
proc igNavInitRequestApplyResult*(): void {.importc: "igNavInitRequestApplyResult".}
proc igNavInitWindow*(window: ptr ImGuiWindow, force_reinit: bool): void {.importc: "igNavInitWindow".}
proc igNavMoveRequestApplyResult*(): void {.importc: "igNavMoveRequestApplyResult".}
proc igNavMoveRequestButNoResultYet*(): bool {.importc: "igNavMoveRequestButNoResultYet".}
proc igNavMoveRequestCancel*(): void {.importc: "igNavMoveRequestCancel".}
proc igNavMoveRequestForward*(move_dir: ImGuiDir, clip_dir: ImGuiDir, move_flags: ImGuiNavMoveFlags, scroll_flags: ImGuiScrollFlags): void {.importc: "igNavMoveRequestForward".}
proc igNavMoveRequestResolveWithLastItem*(result: ptr ImGuiNavItemData): void {.importc: "igNavMoveRequestResolveWithLastItem".}
proc igNavMoveRequestResolveWithPastTreeNode*(result: ptr ImGuiNavItemData, tree_node_data: ptr ImGuiNavTreeNodeData): void {.importc: "igNavMoveRequestResolveWithPastTreeNode".}
proc igNavMoveRequestSubmit*(move_dir: ImGuiDir, clip_dir: ImGuiDir, move_flags: ImGuiNavMoveFlags, scroll_flags: ImGuiScrollFlags): void {.importc: "igNavMoveRequestSubmit".}
proc igNavMoveRequestTryWrapping*(window: ptr ImGuiWindow, move_flags: ImGuiNavMoveFlags): void {.importc: "igNavMoveRequestTryWrapping".}
proc igNavUpdateCurrentWindowIsScrollPushableX*(): void {.importc: "igNavUpdateCurrentWindowIsScrollPushableX".}
proc igNewFrame*(): void {.importc: "igNewFrame".}
proc igNewLine*(): void {.importc: "igNewLine".}
proc igNextColumn*(): void {.importc: "igNextColumn".}
proc igOpenPopup*(str_id: cstring, popup_flags: ImGuiPopupFlags = 0.ImGuiPopupFlags): void {.importc: "igOpenPopup_Str".}
proc igOpenPopup*(id: ImGuiID, popup_flags: ImGuiPopupFlags = 0.ImGuiPopupFlags): void {.importc: "igOpenPopup_ID".}
proc igOpenPopupEx*(id: ImGuiID, popup_flags: ImGuiPopupFlags = ImGuiPopupFlags.None.ImGuiPopupFlags): void {.importc: "igOpenPopupEx".}
proc igOpenPopupOnItemClick*(str_id: cstring = nil, popup_flags: ImGuiPopupFlags = 1.ImGuiPopupFlags): void {.importc: "igOpenPopupOnItemClick".}
proc igPlotEx*(plot_type: ImGuiPlotType, label: cstring, values_getter: proc(data: pointer, idx: int32): float32 {.cdecl, varargs.}, data: pointer, values_count: int32, values_offset: int32, overlay_text: cstring, scale_min: float32, scale_max: float32, size_arg: ImVec2): int32 {.importc: "igPlotEx".}
proc igPlotHistogram*(label: cstring, values: ptr float32, values_count: int32, values_offset: int32 = 0, overlay_text: cstring = nil, scale_min: float32 = high(float32), scale_max: float32 = high(float32), graph_size: ImVec2 = ImVec2(x: 0, y: 0), stride: int32 = sizeof(float32).int32): void {.importc: "igPlotHistogram_FloatPtr".}
proc igPlotHistogram*(label: cstring, values_getter: proc(data: pointer, idx: int32): float32 {.cdecl, varargs.}, data: pointer, values_count: int32, values_offset: int32 = 0, overlay_text: cstring = nil, scale_min: float32 = high(float32), scale_max: float32 = high(float32), graph_size: ImVec2 = ImVec2(x: 0, y: 0)): void {.importc: "igPlotHistogram_FnFloatPtr".}
proc igPlotLines*(label: cstring, values: ptr float32, values_count: int32, values_offset: int32 = 0, overlay_text: cstring = nil, scale_min: float32 = high(float32), scale_max: float32 = high(float32), graph_size: ImVec2 = ImVec2(x: 0, y: 0), stride: int32 = sizeof(float32).int32): void {.importc: "igPlotLines_FloatPtr".}
proc igPlotLines*(label: cstring, values_getter: proc(data: pointer, idx: int32): float32 {.cdecl, varargs.}, data: pointer, values_count: int32, values_offset: int32 = 0, overlay_text: cstring = nil, scale_min: float32 = high(float32), scale_max: float32 = high(float32), graph_size: ImVec2 = ImVec2(x: 0, y: 0)): void {.importc: "igPlotLines_FnFloatPtr".}
proc igPopButtonRepeat*(): void {.importc: "igPopButtonRepeat".}
proc igPopClipRect*(): void {.importc: "igPopClipRect".}
proc igPopColumnsBackground*(): void {.importc: "igPopColumnsBackground".}
proc igPopFocusScope*(): void {.importc: "igPopFocusScope".}
proc igPopFont*(): void {.importc: "igPopFont".}
proc igPopID*(): void {.importc: "igPopID".}
proc igPopItemFlag*(): void {.importc: "igPopItemFlag".}
proc igPopItemWidth*(): void {.importc: "igPopItemWidth".}
proc igPopStyleColor*(count: int32 = 1): void {.importc: "igPopStyleColor".}
proc igPopStyleVar*(count: int32 = 1): void {.importc: "igPopStyleVar".}
proc igPopTabStop*(): void {.importc: "igPopTabStop".}
proc igPopTextWrapPos*(): void {.importc: "igPopTextWrapPos".}
proc igProgressBar*(fraction: float32, size_arg: ImVec2 = ImVec2(x: 0, y: 0), overlay: cstring = nil): void {.importc: "igProgressBar".}
proc igPushButtonRepeat*(repeat: bool): void {.importc: "igPushButtonRepeat".}
proc igPushClipRect*(clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool): void {.importc: "igPushClipRect".}
proc igPushColumnClipRect*(column_index: int32): void {.importc: "igPushColumnClipRect".}
proc igPushColumnsBackground*(): void {.importc: "igPushColumnsBackground".}
proc igPushFocusScope*(id: ImGuiID): void {.importc: "igPushFocusScope".}
proc igPushFont*(font: ptr ImFont): void {.importc: "igPushFont".}
proc igPushID*(str_id: cstring): void {.importc: "igPushID_Str".}
proc igPushID*(str_id_begin: cstring, str_id_end: cstring): void {.importc: "igPushID_StrStr".}
proc igPushID*(ptr_id: pointer): void {.importc: "igPushID_Ptr".}
proc igPushID*(int_id: int32): void {.importc: "igPushID_Int".}
proc igPushItemFlag*(option: ImGuiItemFlags, enabled: bool): void {.importc: "igPushItemFlag".}
proc igPushItemWidth*(item_width: float32): void {.importc: "igPushItemWidth".}
proc igPushMultiItemsWidths*(components: int32, width_full: float32): void {.importc: "igPushMultiItemsWidths".}
proc igPushOverrideID*(id: ImGuiID): void {.importc: "igPushOverrideID".}
proc igPushStyleColor*(idx: ImGuiCol, col: uint32): void {.importc: "igPushStyleColor_U32".}
proc igPushStyleColor*(idx: ImGuiCol, col: ImVec4): void {.importc: "igPushStyleColor_Vec4".}
proc igPushStyleVar*(idx: ImGuiStyleVar, val: float32): void {.importc: "igPushStyleVar_Float".}
proc igPushStyleVar*(idx: ImGuiStyleVar, val: ImVec2): void {.importc: "igPushStyleVar_Vec2".}
proc igPushTabStop*(tab_stop: bool): void {.importc: "igPushTabStop".}
proc igPushTextWrapPos*(wrap_local_pos_x: float32 = 0.0f): void {.importc: "igPushTextWrapPos".}
proc igRadioButton*(label: cstring, active: bool): bool {.importc: "igRadioButton_Bool".}
proc igRadioButton*(label: cstring, v: ptr int32, v_button: int32): bool {.importc: "igRadioButton_IntPtr".}
proc igRemoveContextHook*(context: ptr ImGuiContext, hook_to_remove: ImGuiID): void {.importc: "igRemoveContextHook".}
proc igRemoveSettingsHandler*(type_name: cstring): void {.importc: "igRemoveSettingsHandler".}
proc igRender*(): void {.importc: "igRender".}
proc igRenderArrow*(draw_list: ptr ImDrawList, pos: ImVec2, col: uint32, dir: ImGuiDir, scale: float32 = 1.0f): void {.importc: "igRenderArrow".}
proc igRenderArrowDockMenu*(draw_list: ptr ImDrawList, p_min: ImVec2, sz: float32, col: uint32): void {.importc: "igRenderArrowDockMenu".}
proc igRenderArrowPointingAt*(draw_list: ptr ImDrawList, pos: ImVec2, half_sz: ImVec2, direction: ImGuiDir, col: uint32): void {.importc: "igRenderArrowPointingAt".}
proc igRenderBullet*(draw_list: ptr ImDrawList, pos: ImVec2, col: uint32): void {.importc: "igRenderBullet".}
proc igRenderCheckMark*(draw_list: ptr ImDrawList, pos: ImVec2, col: uint32, sz: float32): void {.importc: "igRenderCheckMark".}
proc igRenderColorRectWithAlphaCheckerboard*(draw_list: ptr ImDrawList, p_min: ImVec2, p_max: ImVec2, fill_col: uint32, grid_step: float32, grid_off: ImVec2, rounding: float32 = 0.0f, flags: ImDrawFlags = 0.ImDrawFlags): void {.importc: "igRenderColorRectWithAlphaCheckerboard".}
proc igRenderDragDropTargetRect*(bb: ImRect): void {.importc: "igRenderDragDropTargetRect".}
proc igRenderFrame*(p_min: ImVec2, p_max: ImVec2, fill_col: uint32, border: bool = true, rounding: float32 = 0.0f): void {.importc: "igRenderFrame".}
proc igRenderFrameBorder*(p_min: ImVec2, p_max: ImVec2, rounding: float32 = 0.0f): void {.importc: "igRenderFrameBorder".}
proc igRenderMouseCursor*(pos: ImVec2, scale: float32, mouse_cursor: ImGuiMouseCursor, col_fill: uint32, col_border: uint32, col_shadow: uint32): void {.importc: "igRenderMouseCursor".}
proc igRenderNavHighlight*(bb: ImRect, id: ImGuiID, flags: ImGuiNavHighlightFlags = ImGuiNavHighlightFlags.TypeDefault.ImGuiNavHighlightFlags): void {.importc: "igRenderNavHighlight".}
proc igRenderPlatformWindowsDefault*(platform_render_arg: pointer = nil, renderer_render_arg: pointer = nil): void {.importc: "igRenderPlatformWindowsDefault".}
proc igRenderRectFilledRangeH*(draw_list: ptr ImDrawList, rect: ImRect, col: uint32, x_start_norm: float32, x_end_norm: float32, rounding: float32): void {.importc: "igRenderRectFilledRangeH".}
proc igRenderRectFilledWithHole*(draw_list: ptr ImDrawList, outer: ImRect, inner: ImRect, col: uint32, rounding: float32): void {.importc: "igRenderRectFilledWithHole".}
proc igRenderText*(pos: ImVec2, text: cstring, text_end: cstring = nil, hide_text_after_hash: bool = true): void {.importc: "igRenderText".}
proc igRenderTextClipped*(pos_min: ImVec2, pos_max: ImVec2, text: cstring, text_end: cstring, text_size_if_known: ptr ImVec2, align: ImVec2 = ImVec2(x: 0, y: 0), clip_rect: ptr ImRect = nil): void {.importc: "igRenderTextClipped".}
proc igRenderTextClippedEx*(draw_list: ptr ImDrawList, pos_min: ImVec2, pos_max: ImVec2, text: cstring, text_end: cstring, text_size_if_known: ptr ImVec2, align: ImVec2 = ImVec2(x: 0, y: 0), clip_rect: ptr ImRect = nil): void {.importc: "igRenderTextClippedEx".}
proc igRenderTextEllipsis*(draw_list: ptr ImDrawList, pos_min: ImVec2, pos_max: ImVec2, clip_max_x: float32, ellipsis_max_x: float32, text: cstring, text_end: cstring, text_size_if_known: ptr ImVec2): void {.importc: "igRenderTextEllipsis".}
proc igRenderTextWrapped*(pos: ImVec2, text: cstring, text_end: cstring, wrap_width: float32): void {.importc: "igRenderTextWrapped".}
proc igResetMouseDragDelta*(button: ImGuiMouseButton = 0.ImGuiMouseButton): void {.importc: "igResetMouseDragDelta".}
proc igSameLine*(offset_from_start_x: float32 = 0.0f, spacing: float32 = -1.0f): void {.importc: "igSameLine".}
proc igSaveIniSettingsToDisk*(ini_filename: cstring): void {.importc: "igSaveIniSettingsToDisk".}
proc igSaveIniSettingsToMemory*(out_ini_size: ptr uint = nil): cstring {.importc: "igSaveIniSettingsToMemory".}
proc igScaleWindowsInViewport*(viewport: ptr ImGuiViewportP, scale: float32): void {.importc: "igScaleWindowsInViewport".}
proc igScrollToBringRectIntoView*(window: ptr ImGuiWindow, rect: ImRect): void {.importc: "igScrollToBringRectIntoView".}
proc igScrollToItem*(flags: ImGuiScrollFlags = 0.ImGuiScrollFlags): void {.importc: "igScrollToItem".}
proc igScrollToRect*(window: ptr ImGuiWindow, rect: ImRect, flags: ImGuiScrollFlags = 0.ImGuiScrollFlags): void {.importc: "igScrollToRect".}
proc igScrollToRectExNonUDT*(pOut: ptr ImVec2, window: ptr ImGuiWindow, rect: ImRect, flags: ImGuiScrollFlags = 0.ImGuiScrollFlags): void {.importc: "igScrollToRectEx".}
proc igScrollbar*(axis: ImGuiAxis): void {.importc: "igScrollbar".}
proc igScrollbarEx*(bb: ImRect, id: ImGuiID, axis: ImGuiAxis, p_scroll_v: ptr int64, avail_v: int64, contents_v: int64, flags: ImDrawFlags): bool {.importc: "igScrollbarEx".}
proc igSelectable*(label: cstring, selected: bool = false, flags: ImGuiSelectableFlags = 0.ImGuiSelectableFlags, size: ImVec2 = ImVec2(x: 0, y: 0)): bool {.importc: "igSelectable_Bool".}
proc igSelectable*(label: cstring, p_selected: ptr bool, flags: ImGuiSelectableFlags = 0.ImGuiSelectableFlags, size: ImVec2 = ImVec2(x: 0, y: 0)): bool {.importc: "igSelectable_BoolPtr".}
proc igSeparator*(): void {.importc: "igSeparator".}
proc igSeparatorEx*(flags: ImGuiSeparatorFlags, thickness: float32 = 1.0f): void {.importc: "igSeparatorEx".}
proc igSeparatorText*(label: cstring): void {.importc: "igSeparatorText".}
proc igSeparatorTextEx*(id: ImGuiID, label: cstring, label_end: cstring, extra_width: float32): void {.importc: "igSeparatorTextEx".}
proc igSetActiveID*(id: ImGuiID, window: ptr ImGuiWindow): void {.importc: "igSetActiveID".}
proc igSetActiveIdUsingAllKeyboardKeys*(): void {.importc: "igSetActiveIdUsingAllKeyboardKeys".}
proc igSetAllocatorFunctions*(alloc_func: ImGuiMemAllocFunc, free_func: ImGuiMemFreeFunc, user_data: pointer = nil): void {.importc: "igSetAllocatorFunctions".}
proc igSetClipboardText*(text: cstring): void {.importc: "igSetClipboardText".}
proc igSetColorEditOptions*(flags: ImGuiColorEditFlags): void {.importc: "igSetColorEditOptions".}
proc igSetColumnOffset*(column_index: int32, offset_x: float32): void {.importc: "igSetColumnOffset".}
proc igSetColumnWidth*(column_index: int32, width: float32): void {.importc: "igSetColumnWidth".}
proc igSetCurrentContext*(ctx: ptr ImGuiContext): void {.importc: "igSetCurrentContext".}
proc igSetCurrentFont*(font: ptr ImFont): void {.importc: "igSetCurrentFont".}
proc igSetCurrentViewport*(window: ptr ImGuiWindow, viewport: ptr ImGuiViewportP): void {.importc: "igSetCurrentViewport".}
proc igSetCursorPos*(local_pos: ImVec2): void {.importc: "igSetCursorPos".}
proc igSetCursorPosX*(local_x: float32): void {.importc: "igSetCursorPosX".}
proc igSetCursorPosY*(local_y: float32): void {.importc: "igSetCursorPosY".}
proc igSetCursorScreenPos*(pos: ImVec2): void {.importc: "igSetCursorScreenPos".}
proc igSetDragDropPayload*(`type`: cstring, data: pointer, sz: uint, cond: ImGuiCond = 0.ImGuiCond): bool {.importc: "igSetDragDropPayload".}
proc igSetFocusID*(id: ImGuiID, window: ptr ImGuiWindow): void {.importc: "igSetFocusID".}
proc igSetHoveredID*(id: ImGuiID): void {.importc: "igSetHoveredID".}
proc igSetItemDefaultFocus*(): void {.importc: "igSetItemDefaultFocus".}
proc igSetItemKeyOwner*(key: ImGuiKey, flags: ImGuiInputFlags = 0.ImGuiInputFlags): void {.importc: "igSetItemKeyOwner".}
proc igSetItemTooltip*(fmt: cstring): void {.importc: "igSetItemTooltip", varargs.}
proc igSetItemTooltipV*(fmt: cstring): void {.importc: "igSetItemTooltipV", varargs.}
proc igSetKeyOwner*(key: ImGuiKey, owner_id: ImGuiID, flags: ImGuiInputFlags = 0.ImGuiInputFlags): void {.importc: "igSetKeyOwner".}
proc igSetKeyOwnersForKeyChord*(key: ImGuiKeyChord, owner_id: ImGuiID, flags: ImGuiInputFlags = 0.ImGuiInputFlags): void {.importc: "igSetKeyOwnersForKeyChord".}
proc igSetKeyboardFocusHere*(offset: int32 = 0): void {.importc: "igSetKeyboardFocusHere".}
proc igSetLastItemData*(item_id: ImGuiID, in_flags: ImGuiItemFlags, status_flags: ImGuiItemStatusFlags, item_rect: ImRect): void {.importc: "igSetLastItemData".}
proc igSetMouseCursor*(cursor_type: ImGuiMouseCursor): void {.importc: "igSetMouseCursor".}
proc igSetNavID*(id: ImGuiID, nav_layer: ImGuiNavLayer, focus_scope_id: ImGuiID, rect_rel: ImRect): void {.importc: "igSetNavID".}
proc igSetNavWindow*(window: ptr ImGuiWindow): void {.importc: "igSetNavWindow".}
proc igSetNextFrameWantCaptureKeyboard*(want_capture_keyboard: bool): void {.importc: "igSetNextFrameWantCaptureKeyboard".}
proc igSetNextFrameWantCaptureMouse*(want_capture_mouse: bool): void {.importc: "igSetNextFrameWantCaptureMouse".}
proc igSetNextItemAllowOverlap*(): void {.importc: "igSetNextItemAllowOverlap".}
proc igSetNextItemOpen*(is_open: bool, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetNextItemOpen".}
proc igSetNextItemWidth*(item_width: float32): void {.importc: "igSetNextItemWidth".}
proc igSetNextWindowBgAlpha*(alpha: float32): void {.importc: "igSetNextWindowBgAlpha".}
proc igSetNextWindowClass*(window_class: ptr ImGuiWindowClass): void {.importc: "igSetNextWindowClass".}
proc igSetNextWindowCollapsed*(collapsed: bool, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetNextWindowCollapsed".}
proc igSetNextWindowContentSize*(size: ImVec2): void {.importc: "igSetNextWindowContentSize".}
proc igSetNextWindowDockID*(dock_id: ImGuiID, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetNextWindowDockID".}
proc igSetNextWindowFocus*(): void {.importc: "igSetNextWindowFocus".}
proc igSetNextWindowPos*(pos: ImVec2, cond: ImGuiCond = 0.ImGuiCond, pivot: ImVec2 = ImVec2(x: 0, y: 0)): void {.importc: "igSetNextWindowPos".}
proc igSetNextWindowScroll*(scroll: ImVec2): void {.importc: "igSetNextWindowScroll".}
proc igSetNextWindowSize*(size: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetNextWindowSize".}
proc igSetNextWindowSizeConstraints*(size_min: ImVec2, size_max: ImVec2, custom_callback: ImGuiSizeCallback = nil, custom_callback_data: pointer = nil): void {.importc: "igSetNextWindowSizeConstraints".}
proc igSetNextWindowViewport*(viewport_id: ImGuiID): void {.importc: "igSetNextWindowViewport".}
proc igSetScrollFromPosX*(local_x: float32, center_x_ratio: float32 = 0.5f): void {.importc: "igSetScrollFromPosX_Float".}
proc igSetScrollFromPosX*(window: ptr ImGuiWindow, local_x: float32, center_x_ratio: float32): void {.importc: "igSetScrollFromPosX_WindowPtr".}
proc igSetScrollFromPosY*(local_y: float32, center_y_ratio: float32 = 0.5f): void {.importc: "igSetScrollFromPosY_Float".}
proc igSetScrollFromPosY*(window: ptr ImGuiWindow, local_y: float32, center_y_ratio: float32): void {.importc: "igSetScrollFromPosY_WindowPtr".}
proc igSetScrollHereX*(center_x_ratio: float32 = 0.5f): void {.importc: "igSetScrollHereX".}
proc igSetScrollHereY*(center_y_ratio: float32 = 0.5f): void {.importc: "igSetScrollHereY".}
proc igSetScrollX*(scroll_x: float32): void {.importc: "igSetScrollX_Float".}
proc igSetScrollX*(window: ptr ImGuiWindow, scroll_x: float32): void {.importc: "igSetScrollX_WindowPtr".}
proc igSetScrollY*(scroll_y: float32): void {.importc: "igSetScrollY_Float".}
proc igSetScrollY*(window: ptr ImGuiWindow, scroll_y: float32): void {.importc: "igSetScrollY_WindowPtr".}
proc igSetShortcutRouting*(key_chord: ImGuiKeyChord, owner_id: ImGuiID = 0.ImGuiID, flags: ImGuiInputFlags = 0.ImGuiInputFlags): bool {.importc: "igSetShortcutRouting".}
proc igSetStateStorage*(storage: ptr ImGuiStorage): void {.importc: "igSetStateStorage".}
proc igSetTabItemClosed*(tab_or_docked_window_label: cstring): void {.importc: "igSetTabItemClosed".}
proc igSetTooltip*(fmt: cstring): void {.importc: "igSetTooltip", varargs.}
proc igSetTooltipV*(fmt: cstring): void {.importc: "igSetTooltipV", varargs.}
proc igSetWindowClipRectBeforeSetChannel*(window: ptr ImGuiWindow, clip_rect: ImRect): void {.importc: "igSetWindowClipRectBeforeSetChannel".}
proc igSetWindowCollapsed*(collapsed: bool, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowCollapsed_Bool".}
proc igSetWindowCollapsed*(name: cstring, collapsed: bool, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowCollapsed_Str".}
proc igSetWindowCollapsed*(window: ptr ImGuiWindow, collapsed: bool, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowCollapsed_WindowPtr".}
proc igSetWindowDock*(window: ptr ImGuiWindow, dock_id: ImGuiID, cond: ImGuiCond): void {.importc: "igSetWindowDock".}
proc igSetWindowFocus*(): void {.importc: "igSetWindowFocus_Nil".}
proc igSetWindowFocus*(name: cstring): void {.importc: "igSetWindowFocus_Str".}
proc igSetWindowFontScale*(scale: float32): void {.importc: "igSetWindowFontScale".}
proc igSetWindowHiddendAndSkipItemsForCurrentFrame*(window: ptr ImGuiWindow): void {.importc: "igSetWindowHiddendAndSkipItemsForCurrentFrame".}
proc igSetWindowHitTestHole*(window: ptr ImGuiWindow, pos: ImVec2, size: ImVec2): void {.importc: "igSetWindowHitTestHole".}
proc igSetWindowPos*(pos: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowPos_Vec2".}
proc igSetWindowPos*(name: cstring, pos: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowPos_Str".}
proc igSetWindowPos*(window: ptr ImGuiWindow, pos: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowPos_WindowPtr".}
proc igSetWindowSize*(size: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowSize_Vec2".}
proc igSetWindowSize*(name: cstring, size: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowSize_Str".}
proc igSetWindowSize*(window: ptr ImGuiWindow, size: ImVec2, cond: ImGuiCond = 0.ImGuiCond): void {.importc: "igSetWindowSize_WindowPtr".}
proc igSetWindowViewport*(window: ptr ImGuiWindow, viewport: ptr ImGuiViewportP): void {.importc: "igSetWindowViewport".}
proc igShadeVertsLinearColorGradientKeepAlpha*(draw_list: ptr ImDrawList, vert_start_idx: int32, vert_end_idx: int32, gradient_p0: ImVec2, gradient_p1: ImVec2, col0: uint32, col1: uint32): void {.importc: "igShadeVertsLinearColorGradientKeepAlpha".}
proc igShadeVertsLinearUV*(draw_list: ptr ImDrawList, vert_start_idx: int32, vert_end_idx: int32, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, clamp: bool): void {.importc: "igShadeVertsLinearUV".}
proc igShortcut*(key_chord: ImGuiKeyChord, owner_id: ImGuiID = 0.ImGuiID, flags: ImGuiInputFlags = 0.ImGuiInputFlags): bool {.importc: "igShortcut".}
proc igShowAboutWindow*(p_open: ptr bool = nil): void {.importc: "igShowAboutWindow".}
proc igShowDebugLogWindow*(p_open: ptr bool = nil): void {.importc: "igShowDebugLogWindow".}
proc igShowDemoWindow*(p_open: ptr bool = nil): void {.importc: "igShowDemoWindow".}
proc igShowFontAtlas*(atlas: ptr ImFontAtlas): void {.importc: "igShowFontAtlas".}
proc igShowFontSelector*(label: cstring): void {.importc: "igShowFontSelector".}
proc igShowMetricsWindow*(p_open: ptr bool = nil): void {.importc: "igShowMetricsWindow".}
proc igShowStackToolWindow*(p_open: ptr bool = nil): void {.importc: "igShowStackToolWindow".}
proc igShowStyleEditor*(`ref`: ptr ImGuiStyle = nil): void {.importc: "igShowStyleEditor".}
proc igShowStyleSelector*(label: cstring): bool {.importc: "igShowStyleSelector".}
proc igShowUserGuide*(): void {.importc: "igShowUserGuide".}
proc igShrinkWidths*(items: ptr ImGuiShrinkWidthItem, count: int32, width_excess: float32): void {.importc: "igShrinkWidths".}
proc igShutdown*(): void {.importc: "igShutdown".}
proc igSliderAngle*(label: cstring, v_rad: ptr float32, v_degrees_min: float32 = -360.0f, v_degrees_max: float32 = +360.0f, format: cstring = "%.0f deg", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderAngle".}
proc igSliderBehavior*(bb: ImRect, id: ImGuiID, data_type: ImGuiDataType, p_v: pointer, p_min: pointer, p_max: pointer, format: cstring, flags: ImGuiSliderFlags, out_grab_bb: ptr ImRect): bool {.importc: "igSliderBehavior".}
proc igSliderFloat*(label: cstring, v: ptr float32, v_min: float32, v_max: float32, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderFloat".}
proc igSliderFloat2*(label: cstring, v: var array[2, float32], v_min: float32, v_max: float32, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderFloat2".}
proc igSliderFloat3*(label: cstring, v: var array[3, float32], v_min: float32, v_max: float32, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderFloat3".}
proc igSliderFloat4*(label: cstring, v: var array[4, float32], v_min: float32, v_max: float32, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderFloat4".}
proc igSliderInt*(label: cstring, v: ptr int32, v_min: int32, v_max: int32, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderInt".}
proc igSliderInt2*(label: cstring, v: var array[2, int32], v_min: int32, v_max: int32, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderInt2".}
proc igSliderInt3*(label: cstring, v: var array[3, int32], v_min: int32, v_max: int32, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderInt3".}
proc igSliderInt4*(label: cstring, v: var array[4, int32], v_min: int32, v_max: int32, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderInt4".}
proc igSliderScalar*(label: cstring, data_type: ImGuiDataType, p_data: pointer, p_min: pointer, p_max: pointer, format: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderScalar".}
proc igSliderScalarN*(label: cstring, data_type: ImGuiDataType, p_data: pointer, components: int32, p_min: pointer, p_max: pointer, format: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igSliderScalarN".}
proc igSmallButton*(label: cstring): bool {.importc: "igSmallButton".}
proc igSpacing*(): void {.importc: "igSpacing".}
proc igSplitterBehavior*(bb: ImRect, id: ImGuiID, axis: ImGuiAxis, size1: ptr float32, size2: ptr float32, min_size1: float32, min_size2: float32, hover_extend: float32 = 0.0f, hover_visibility_delay: float32 = 0.0f, bg_col: uint32 = 0): bool {.importc: "igSplitterBehavior".}
proc igStartMouseMovingWindow*(window: ptr ImGuiWindow): void {.importc: "igStartMouseMovingWindow".}
proc igStartMouseMovingWindowOrNode*(window: ptr ImGuiWindow, node: ptr ImGuiDockNode, undock_floating_node: bool): void {.importc: "igStartMouseMovingWindowOrNode".}
proc igStyleColorsClassic*(dst: ptr ImGuiStyle = nil): void {.importc: "igStyleColorsClassic".}
proc igStyleColorsDark*(dst: ptr ImGuiStyle = nil): void {.importc: "igStyleColorsDark".}
proc igStyleColorsLight*(dst: ptr ImGuiStyle = nil): void {.importc: "igStyleColorsLight".}
proc igTabBarAddTab*(tab_bar: ptr ImGuiTabBar, tab_flags: ImGuiTabItemFlags, window: ptr ImGuiWindow): void {.importc: "igTabBarAddTab".}
proc igTabBarCloseTab*(tab_bar: ptr ImGuiTabBar, tab: ptr ImGuiTabItem): void {.importc: "igTabBarCloseTab".}
proc igTabBarFindMostRecentlySelectedTabForActiveWindow*(tab_bar: ptr ImGuiTabBar): ptr ImGuiTabItem {.importc: "igTabBarFindMostRecentlySelectedTabForActiveWindow".}
proc igTabBarFindTabByID*(tab_bar: ptr ImGuiTabBar, tab_id: ImGuiID): ptr ImGuiTabItem {.importc: "igTabBarFindTabByID".}
proc igTabBarFindTabByOrder*(tab_bar: ptr ImGuiTabBar, order: int32): ptr ImGuiTabItem {.importc: "igTabBarFindTabByOrder".}
proc igTabBarGetCurrentTab*(tab_bar: ptr ImGuiTabBar): ptr ImGuiTabItem {.importc: "igTabBarGetCurrentTab".}
proc igTabBarGetTabName*(tab_bar: ptr ImGuiTabBar, tab: ptr ImGuiTabItem): cstring {.importc: "igTabBarGetTabName".}
proc igTabBarGetTabOrder*(tab_bar: ptr ImGuiTabBar, tab: ptr ImGuiTabItem): int32 {.importc: "igTabBarGetTabOrder".}
proc igTabBarProcessReorder*(tab_bar: ptr ImGuiTabBar): bool {.importc: "igTabBarProcessReorder".}
proc igTabBarQueueFocus*(tab_bar: ptr ImGuiTabBar, tab: ptr ImGuiTabItem): void {.importc: "igTabBarQueueFocus".}
proc igTabBarQueueReorder*(tab_bar: ptr ImGuiTabBar, tab: ptr ImGuiTabItem, offset: int32): void {.importc: "igTabBarQueueReorder".}
proc igTabBarQueueReorderFromMousePos*(tab_bar: ptr ImGuiTabBar, tab: ptr ImGuiTabItem, mouse_pos: ImVec2): void {.importc: "igTabBarQueueReorderFromMousePos".}
proc igTabBarRemoveTab*(tab_bar: ptr ImGuiTabBar, tab_id: ImGuiID): void {.importc: "igTabBarRemoveTab".}
proc igTabItemBackground*(draw_list: ptr ImDrawList, bb: ImRect, flags: ImGuiTabItemFlags, col: uint32): void {.importc: "igTabItemBackground".}
proc igTabItemButton*(label: cstring, flags: ImGuiTabItemFlags = 0.ImGuiTabItemFlags): bool {.importc: "igTabItemButton".}
proc igTabItemCalcSizeNonUDT*(pOut: ptr ImVec2, label: cstring, has_close_button_or_unsaved_marker: bool): void {.importc: "igTabItemCalcSize_Str".}
proc igTabItemCalcSizeNonUDT2*(pOut: ptr ImVec2, window: ptr ImGuiWindow): void {.importc: "igTabItemCalcSize_WindowPtr".}
proc igTabItemEx*(tab_bar: ptr ImGuiTabBar, label: cstring, p_open: ptr bool, flags: ImGuiTabItemFlags, docked_window: ptr ImGuiWindow): bool {.importc: "igTabItemEx".}
proc igTabItemLabelAndCloseButton*(draw_list: ptr ImDrawList, bb: ImRect, flags: ImGuiTabItemFlags, frame_padding: ImVec2, label: cstring, tab_id: ImGuiID, close_button_id: ImGuiID, is_contents_visible: bool, out_just_closed: ptr bool, out_text_clipped: ptr bool): void {.importc: "igTabItemLabelAndCloseButton".}
proc igTableBeginApplyRequests*(table: ptr ImGuiTable): void {.importc: "igTableBeginApplyRequests".}
proc igTableBeginCell*(table: ptr ImGuiTable, column_n: int32): void {.importc: "igTableBeginCell".}
proc igTableBeginContextMenuPopup*(table: ptr ImGuiTable): bool {.importc: "igTableBeginContextMenuPopup".}
proc igTableBeginInitMemory*(table: ptr ImGuiTable, columns_count: int32): void {.importc: "igTableBeginInitMemory".}
proc igTableBeginRow*(table: ptr ImGuiTable): void {.importc: "igTableBeginRow".}
proc igTableDrawBorders*(table: ptr ImGuiTable): void {.importc: "igTableDrawBorders".}
proc igTableDrawContextMenu*(table: ptr ImGuiTable): void {.importc: "igTableDrawContextMenu".}
proc igTableEndCell*(table: ptr ImGuiTable): void {.importc: "igTableEndCell".}
proc igTableEndRow*(table: ptr ImGuiTable): void {.importc: "igTableEndRow".}
proc igTableFindByID*(id: ImGuiID): ptr ImGuiTable {.importc: "igTableFindByID".}
proc igTableFixColumnSortDirection*(table: ptr ImGuiTable, column: ptr ImGuiTableColumn): void {.importc: "igTableFixColumnSortDirection".}
proc igTableGcCompactSettings*(): void {.importc: "igTableGcCompactSettings".}
proc igTableGcCompactTransientBuffers*(table: ptr ImGuiTable): void {.importc: "igTableGcCompactTransientBuffers_TablePtr".}
proc igTableGcCompactTransientBuffers*(table: ptr ImGuiTableTempData): void {.importc: "igTableGcCompactTransientBuffers_TableTempDataPtr".}
proc igTableGetBoundSettings*(table: ptr ImGuiTable): ptr ImGuiTableSettings {.importc: "igTableGetBoundSettings".}
proc igTableGetCellBgRectNonUDT*(pOut: ptr ImRect, table: ptr ImGuiTable, column_n: int32): void {.importc: "igTableGetCellBgRect".}
proc igTableGetColumnCount*(): int32 {.importc: "igTableGetColumnCount".}
proc igTableGetColumnFlags*(column_n: int32 = -1): ImGuiTableColumnFlags {.importc: "igTableGetColumnFlags".}
proc igTableGetColumnIndex*(): int32 {.importc: "igTableGetColumnIndex".}
proc igTableGetColumnName*(column_n: int32 = -1): cstring {.importc: "igTableGetColumnName_Int".}
proc igTableGetColumnName*(table: ptr ImGuiTable, column_n: int32): cstring {.importc: "igTableGetColumnName_TablePtr".}
proc igTableGetColumnNextSortDirection*(column: ptr ImGuiTableColumn): ImGuiSortDirection {.importc: "igTableGetColumnNextSortDirection".}
proc igTableGetColumnResizeID*(table: ptr ImGuiTable, column_n: int32, instance_no: int32 = 0): ImGuiID {.importc: "igTableGetColumnResizeID".}
proc igTableGetColumnWidthAuto*(table: ptr ImGuiTable, column: ptr ImGuiTableColumn): float32 {.importc: "igTableGetColumnWidthAuto".}
proc igTableGetHeaderRowHeight*(): float32 {.importc: "igTableGetHeaderRowHeight".}
proc igTableGetHoveredColumn*(): int32 {.importc: "igTableGetHoveredColumn".}
proc igTableGetHoveredRow*(): int32 {.importc: "igTableGetHoveredRow".}
proc igTableGetInstanceData*(table: ptr ImGuiTable, instance_no: int32): ptr ImGuiTableInstanceData {.importc: "igTableGetInstanceData".}
proc igTableGetInstanceID*(table: ptr ImGuiTable, instance_no: int32): ImGuiID {.importc: "igTableGetInstanceID".}
proc igTableGetMaxColumnWidth*(table: ptr ImGuiTable, column_n: int32): float32 {.importc: "igTableGetMaxColumnWidth".}
proc igTableGetRowIndex*(): int32 {.importc: "igTableGetRowIndex".}
proc igTableGetSortSpecs*(): ptr ImGuiTableSortSpecs {.importc: "igTableGetSortSpecs".}
proc igTableHeader*(label: cstring): void {.importc: "igTableHeader".}
proc igTableHeadersRow*(): void {.importc: "igTableHeadersRow".}
proc igTableLoadSettings*(table: ptr ImGuiTable): void {.importc: "igTableLoadSettings".}
proc igTableMergeDrawChannels*(table: ptr ImGuiTable): void {.importc: "igTableMergeDrawChannels".}
proc igTableNextColumn*(): bool {.importc: "igTableNextColumn".}
proc igTableNextRow*(row_flags: ImGuiTableRowFlags = 0.ImGuiTableRowFlags, min_row_height: float32 = 0.0f): void {.importc: "igTableNextRow".}
proc igTableOpenContextMenu*(column_n: int32 = -1): void {.importc: "igTableOpenContextMenu".}
proc igTablePopBackgroundChannel*(): void {.importc: "igTablePopBackgroundChannel".}
proc igTablePushBackgroundChannel*(): void {.importc: "igTablePushBackgroundChannel".}
proc igTableRemove*(table: ptr ImGuiTable): void {.importc: "igTableRemove".}
proc igTableResetSettings*(table: ptr ImGuiTable): void {.importc: "igTableResetSettings".}
proc igTableSaveSettings*(table: ptr ImGuiTable): void {.importc: "igTableSaveSettings".}
proc igTableSetBgColor*(target: ImGuiTableBgTarget, color: uint32, column_n: int32 = -1): void {.importc: "igTableSetBgColor".}
proc igTableSetColumnEnabled*(column_n: int32, v: bool): void {.importc: "igTableSetColumnEnabled".}
proc igTableSetColumnIndex*(column_n: int32): bool {.importc: "igTableSetColumnIndex".}
proc igTableSetColumnSortDirection*(column_n: int32, sort_direction: ImGuiSortDirection, append_to_sort_specs: bool): void {.importc: "igTableSetColumnSortDirection".}
proc igTableSetColumnWidth*(column_n: int32, width: float32): void {.importc: "igTableSetColumnWidth".}
proc igTableSetColumnWidthAutoAll*(table: ptr ImGuiTable): void {.importc: "igTableSetColumnWidthAutoAll".}
proc igTableSetColumnWidthAutoSingle*(table: ptr ImGuiTable, column_n: int32): void {.importc: "igTableSetColumnWidthAutoSingle".}
proc igTableSettingsAddSettingsHandler*(): void {.importc: "igTableSettingsAddSettingsHandler".}
proc igTableSettingsCreate*(id: ImGuiID, columns_count: int32): ptr ImGuiTableSettings {.importc: "igTableSettingsCreate".}
proc igTableSettingsFindByID*(id: ImGuiID): ptr ImGuiTableSettings {.importc: "igTableSettingsFindByID".}
proc igTableSetupColumn*(label: cstring, flags: ImGuiTableColumnFlags = 0.ImGuiTableColumnFlags, init_width_or_weight: float32 = 0.0f, user_id: ImGuiID = 0.ImGuiID): void {.importc: "igTableSetupColumn".}
proc igTableSetupDrawChannels*(table: ptr ImGuiTable): void {.importc: "igTableSetupDrawChannels".}
proc igTableSetupScrollFreeze*(cols: int32, rows: int32): void {.importc: "igTableSetupScrollFreeze".}
proc igTableSortSpecsBuild*(table: ptr ImGuiTable): void {.importc: "igTableSortSpecsBuild".}
proc igTableSortSpecsSanitize*(table: ptr ImGuiTable): void {.importc: "igTableSortSpecsSanitize".}
proc igTableUpdateBorders*(table: ptr ImGuiTable): void {.importc: "igTableUpdateBorders".}
proc igTableUpdateColumnsWeightFromWidth*(table: ptr ImGuiTable): void {.importc: "igTableUpdateColumnsWeightFromWidth".}
proc igTableUpdateLayout*(table: ptr ImGuiTable): void {.importc: "igTableUpdateLayout".}
proc igTempInputIsActive*(id: ImGuiID): bool {.importc: "igTempInputIsActive".}
proc igTempInputScalar*(bb: ImRect, id: ImGuiID, label: cstring, data_type: ImGuiDataType, p_data: pointer, format: cstring, p_clamp_min: pointer = nil, p_clamp_max: pointer = nil): bool {.importc: "igTempInputScalar".}
proc igTempInputText*(bb: ImRect, id: ImGuiID, label: cstring, buf: cstring, buf_size: int32, flags: ImGuiInputTextFlags): bool {.importc: "igTempInputText".}
proc igTestKeyOwner*(key: ImGuiKey, owner_id: ImGuiID): bool {.importc: "igTestKeyOwner".}
proc igTestShortcutRouting*(key_chord: ImGuiKeyChord, owner_id: ImGuiID): bool {.importc: "igTestShortcutRouting".}
proc igText*(fmt: cstring): void {.importc: "igText", varargs.}
proc igTextColored*(col: ImVec4, fmt: cstring): void {.importc: "igTextColored", varargs.}
proc igTextColoredV*(col: ImVec4, fmt: cstring): void {.importc: "igTextColoredV", varargs.}
proc igTextDisabled*(fmt: cstring): void {.importc: "igTextDisabled", varargs.}
proc igTextDisabledV*(fmt: cstring): void {.importc: "igTextDisabledV", varargs.}
proc igTextEx*(text: cstring, text_end: cstring = nil, flags: ImGuiTextFlags = 0.ImGuiTextFlags): void {.importc: "igTextEx".}
proc igTextUnformatted*(text: cstring, text_end: cstring = nil): void {.importc: "igTextUnformatted".}
proc igTextV*(fmt: cstring): void {.importc: "igTextV", varargs.}
proc igTextWrapped*(fmt: cstring): void {.importc: "igTextWrapped", varargs.}
proc igTextWrappedV*(fmt: cstring): void {.importc: "igTextWrappedV", varargs.}
proc igTranslateWindowsInViewport*(viewport: ptr ImGuiViewportP, old_pos: ImVec2, new_pos: ImVec2): void {.importc: "igTranslateWindowsInViewport".}
proc igTreeNode*(label: cstring): bool {.importc: "igTreeNode_Str".}
proc igTreeNode*(str_id: cstring, fmt: cstring): bool {.importc: "igTreeNode_StrStr", varargs.}
proc igTreeNode*(ptr_id: pointer, fmt: cstring): bool {.importc: "igTreeNode_Ptr", varargs.}
proc igTreeNodeBehavior*(id: ImGuiID, flags: ImGuiTreeNodeFlags, label: cstring, label_end: cstring = nil): bool {.importc: "igTreeNodeBehavior".}
proc igTreeNodeEx*(label: cstring, flags: ImGuiTreeNodeFlags = 0.ImGuiTreeNodeFlags): bool {.importc: "igTreeNodeEx_Str".}
proc igTreeNodeEx*(str_id: cstring, flags: ImGuiTreeNodeFlags, fmt: cstring): bool {.importc: "igTreeNodeEx_StrStr", varargs.}
proc igTreeNodeEx*(ptr_id: pointer, flags: ImGuiTreeNodeFlags, fmt: cstring): bool {.importc: "igTreeNodeEx_Ptr", varargs.}
proc igTreeNodeExV*(str_id: cstring, flags: ImGuiTreeNodeFlags, fmt: cstring): bool {.importc: "igTreeNodeExV_Str", varargs.}
proc igTreeNodeExV*(ptr_id: pointer, flags: ImGuiTreeNodeFlags, fmt: cstring): bool {.importc: "igTreeNodeExV_Ptr", varargs.}
proc igTreeNodeSetOpen*(id: ImGuiID, open: bool): void {.importc: "igTreeNodeSetOpen".}
proc igTreeNodeUpdateNextOpen*(id: ImGuiID, flags: ImGuiTreeNodeFlags): bool {.importc: "igTreeNodeUpdateNextOpen".}
proc igTreeNodeV*(str_id: cstring, fmt: cstring): bool {.importc: "igTreeNodeV_Str", varargs.}
proc igTreeNodeV*(ptr_id: pointer, fmt: cstring): bool {.importc: "igTreeNodeV_Ptr", varargs.}
proc igTreePop*(): void {.importc: "igTreePop".}
proc igTreePush*(str_id: cstring): void {.importc: "igTreePush_Str".}
proc igTreePush*(ptr_id: pointer): void {.importc: "igTreePush_Ptr".}
proc igTreePushOverrideID*(id: ImGuiID): void {.importc: "igTreePushOverrideID".}
proc igUnindent*(indent_w: float32 = 0.0f): void {.importc: "igUnindent".}
proc igUpdateHoveredWindowAndCaptureFlags*(): void {.importc: "igUpdateHoveredWindowAndCaptureFlags".}
proc igUpdateInputEvents*(trickle_fast_inputs: bool): void {.importc: "igUpdateInputEvents".}
proc igUpdateMouseMovingWindowEndFrame*(): void {.importc: "igUpdateMouseMovingWindowEndFrame".}
proc igUpdateMouseMovingWindowNewFrame*(): void {.importc: "igUpdateMouseMovingWindowNewFrame".}
proc igUpdatePlatformWindows*(): void {.importc: "igUpdatePlatformWindows".}
proc igUpdateWindowParentAndRootLinks*(window: ptr ImGuiWindow, flags: ImGuiWindowFlags, parent_window: ptr ImGuiWindow): void {.importc: "igUpdateWindowParentAndRootLinks".}
proc igVSliderFloat*(label: cstring, size: ImVec2, v: ptr float32, v_min: float32, v_max: float32, format: cstring = "%.3f", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igVSliderFloat".}
proc igVSliderInt*(label: cstring, size: ImVec2, v: ptr int32, v_min: int32, v_max: int32, format: cstring = "%d", flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igVSliderInt".}
proc igVSliderScalar*(label: cstring, size: ImVec2, data_type: ImGuiDataType, p_data: pointer, p_min: pointer, p_max: pointer, format: cstring = nil, flags: ImGuiSliderFlags = 0.ImGuiSliderFlags): bool {.importc: "igVSliderScalar".}
proc igValue*(prefix: cstring, b: bool): void {.importc: "igValue_Bool".}
proc igValue*(prefix: cstring, v: int32): void {.importc: "igValue_Int".}
proc igValue*(prefix: cstring, v: uint32): void {.importc: "igValue_Uint".}
proc igValue*(prefix: cstring, v: float32, float_format: cstring = nil): void {.importc: "igValue_Float".}
proc igWindowPosRelToAbsNonUDT*(pOut: ptr ImVec2, window: ptr ImGuiWindow, p: ImVec2): void {.importc: "igWindowPosRelToAbs".}
proc igWindowRectAbsToRelNonUDT*(pOut: ptr ImRect, window: ptr ImGuiWindow, r: ImRect): void {.importc: "igWindowRectAbsToRel".}
proc igWindowRectRelToAbsNonUDT*(pOut: ptr ImRect, window: ptr ImGuiWindow, r: ImRect): void {.importc: "igWindowRectRelToAbs".}

{.pop.} # push dynlib / nodecl, etc...
{.pop.} # push warning[HoleEnumConv]: off


proc igStyleColorsCherry*(dst: ptr ImGuiStyle = nil): void =
  ## To conmemorate this bindings this style is included as a default.
  ## Style created originally by r-lyeh
  var style = igGetStyle()
  if dst != nil:
    style = dst

  const ImVec4 = proc(x: float32, y: float32, z: float32, w: float32): ImVec4 = ImVec4(x: x, y: y, z: z, w: w)
  const igHI = proc(v: float32): ImVec4 = ImVec4(0.502f, 0.075f, 0.256f, v)
  const igMED = proc(v: float32): ImVec4 = ImVec4(0.455f, 0.198f, 0.301f, v)
  const igLOW = proc(v: float32): ImVec4 = ImVec4(0.232f, 0.201f, 0.271f, v)
  const igBG = proc(v: float32): ImVec4 = ImVec4(0.200f, 0.220f, 0.270f, v)
  const igTEXT = proc(v: float32): ImVec4 = ImVec4(0.860f, 0.930f, 0.890f, v)

  style.colors[ImGuiCol.Text.int32]                 = igTEXT(0.88f)
  style.colors[ImGuiCol.TextDisabled.int32]         = igTEXT(0.28f)
  style.colors[ImGuiCol.WindowBg.int32]             = ImVec4(0.13f, 0.14f, 0.17f, 1.00f)
  style.colors[ImGuiCol.PopupBg.int32]              = igBG(0.9f)
  style.colors[ImGuiCol.Border.int32]               = ImVec4(0.31f, 0.31f, 1.00f, 0.00f)
  style.colors[ImGuiCol.BorderShadow.int32]         = ImVec4(0.00f, 0.00f, 0.00f, 0.00f)
  style.colors[ImGuiCol.FrameBg.int32]              = igBG(1.00f)
  style.colors[ImGuiCol.FrameBgHovered.int32]       = igMED(0.78f)
  style.colors[ImGuiCol.FrameBgActive.int32]        = igMED(1.00f)
  style.colors[ImGuiCol.TitleBg.int32]              = igLOW(1.00f)
  style.colors[ImGuiCol.TitleBgActive.int32]        = igHI(1.00f)
  style.colors[ImGuiCol.TitleBgCollapsed.int32]     = igBG(0.75f)
  style.colors[ImGuiCol.MenuBarBg.int32]            = igBG(0.47f)
  style.colors[ImGuiCol.ScrollbarBg.int32]          = igBG(1.00f)
  style.colors[ImGuiCol.ScrollbarGrab.int32]        = ImVec4(0.09f, 0.15f, 0.16f, 1.00f)
  style.colors[ImGuiCol.ScrollbarGrabHovered.int32] = igMED(0.78f)
  style.colors[ImGuiCol.ScrollbarGrabActive.int32]  = igMED(1.00f)
  style.colors[ImGuiCol.CheckMark.int32]            = ImVec4(0.71f, 0.22f, 0.27f, 1.00f)
  style.colors[ImGuiCol.SliderGrab.int32]           = ImVec4(0.47f, 0.77f, 0.83f, 0.14f)
  style.colors[ImGuiCol.SliderGrabActive.int32]     = ImVec4(0.71f, 0.22f, 0.27f, 1.00f)
  style.colors[ImGuiCol.Button.int32]               = ImVec4(0.47f, 0.77f, 0.83f, 0.14f)
  style.colors[ImGuiCol.ButtonHovered.int32]        = igMED(0.86f)
  style.colors[ImGuiCol.ButtonActive.int32]         = igMED(1.00f)
  style.colors[ImGuiCol.Header.int32]               = igMED(0.76f)
  style.colors[ImGuiCol.HeaderHovered.int32]        = igMED(0.86f)
  style.colors[ImGuiCol.HeaderActive.int32]         = igHI(1.00f)
  style.colors[ImGuiCol.ResizeGrip.int32]           = ImVec4(0.47f, 0.77f, 0.83f, 0.04f)
  style.colors[ImGuiCol.ResizeGripHovered.int32]    = igMED(0.78f)
  style.colors[ImGuiCol.ResizeGripActive.int32]     = igMED(1.00f)
  style.colors[ImGuiCol.PlotLines.int32]            = igTEXT(0.63f)
  style.colors[ImGuiCol.PlotLinesHovered.int32]     = igMED(1.00f)
  style.colors[ImGuiCol.PlotHistogram.int32]        = igTEXT(0.63f)
  style.colors[ImGuiCol.PlotHistogramHovered.int32] = igMED(1.00f)
  style.colors[ImGuiCol.TextSelectedBg.int32]       = igMED(0.43f)

  style.windowPadding     = ImVec2(x: 6f, y: 4f)
  style.windowRounding    = 0.0f
  style.framePadding      = ImVec2(x: 5f, y: 2f)
  style.frameRounding     = 3.0f
  style.itemSpacing       = ImVec2(x: 7f, y: 1f)
  style.itemInnerSpacing  = ImVec2(x: 1f, y: 1f)
  style.touchExtraPadding = ImVec2(x: 0f, y: 0f)
  style.indentSpacing     = 6.0f
  style.scrollbarSize     = 12.0f
  style.scrollbarRounding = 16.0f
  style.grabMinSize       = 20.0f
  style.grabRounding      = 2.0f

  style.windowTitleAlign.x = 0.50f

  style.colors[ImGuiCol.Border.int32] = ImVec4(0.539f, 0.479f, 0.255f, 0.162f)
  style.frameBorderSize  = 0.0f
  style.windowBorderSize = 1.0f

  style.displaySafeAreaPadding.y = 0
  style.framePadding.y = 1
  style.itemSpacing.y = 1
  style.windowPadding.y = 3
  style.scrollbarSize = 13
  style.frameBorderSize = 1
  style.tabBorderSize = 1
