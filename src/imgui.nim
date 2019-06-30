# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

## ImGUI Bindings
## ====
## WARNING: This is a generated file. Do not edit
## Any edits will be overwritten by the genearator.
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

proc currentSourceDir(): string =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/../src/imgui/output/cimgui" & " -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1".}

when not defined(imguiSrc):
  when defined(windows):
    const imgui_dll* = "cimgui.dll"
  elif defined(macosx):
    const imgui_dll* = "cimgui.dylib"
  else:
    const imgui_dll* = "cimgui.so"
  {.passC: "-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS".}
  {.pragma: imgui_header, header: "cimgui.h".}
  {.pragma: imgui_lib, dynlib: imgui_dll, cdecl.}
else:
  {.compile: "private/cimgui/cimgui.cpp",
    compile: "private/cimgui/imgui/imgui.cpp",
    compile: "private/cimgui/imgui/imgui_draw.cpp",
    compile: "private/cimgui/imgui/imgui_demo.cpp",
    compile: "private/cimgui/imgui/imgui_widgets.cpp".}
  {.pragma: imgui_header, header: "../ncimgui.h".}
  {.pragma: imgui_lib, nodecl.}

# Enums
type
  ImDrawCornerFlags* {.pure, size: int32.sizeof.} = enum
    TopLeft = 1
    TopRight = 2
    Top = 3
    BotLeft = 4
    Left = 5
    BotRight = 8
    Right = 10
    Bot = 12
    All = 15
  ImDrawListFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    AntiAliasedLines = 1
    AntiAliasedFill = 2
    AllowVtxOffset = 4
  ImFontAtlasFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    NoPowerOfTwoHeight = 1
    NoMouseCursors = 2
  ImGuiBackendFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    HasGamepad = 1
    HasMouseCursors = 2
    HasSetMousePos = 4
    RendererHasVtxOffset = 8
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
    PlotLines = 38
    PlotLinesHovered = 39
    PlotHistogram = 40
    PlotHistogramHovered = 41
    TextSelectedBg = 42
    DragDropTarget = 43
    NavHighlight = 44
    NavWindowingHighlight = 45
    NavWindowingDimBg = 46
    ModalWindowDimBg = 47
  ImGuiColorEditFlags* {.pure, size: int32.sizeof.} = enum
    NoTooltip = 64
    NoLabel = 128
    NoSidePreview = 256
    NoDragDrop = 512
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
    OptionsDefault = 177209344
    InputHSV = 268435456
    InputMask = 402653184
  ImGuiComboFlags* {.pure, size: int32.sizeof.} = enum
    HeightMask = 30
    NoPreview = 64
  ImGuiCond* {.pure, size: int32.sizeof.} = enum
    Always = 1
    Once = 2
    FirstUseEver = 4
    Appearing = 8
  ImGuiConfigFlags* {.pure, size: int32.sizeof.} = enum
    IsSRGB = 1048576
    IsTouchScreen = 2097152
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
  ImGuiDir* {.pure, size: int32.sizeof.} = enum
    None = -1
    Left = 0
    Right = 1
    Up = 2
    Down = 3
  ImGuiDragDropFlags* {.pure, size: int32.sizeof.} = enum
    AcceptBeforeDelivery = 1024
    AcceptNoDrawDefaultRect = 2048
    AcceptPeekOnly = 3072
    AcceptNoPreviewTooltip = 4096
  ImGuiFocusedFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    ChildWindows = 1
    RootWindow = 2
    RootAndChildWindows = 3
    AnyWindow = 4
  ImGuiHoveredFlags* {.pure, size: int32.sizeof.} = enum
    RootAndChildWindows = 3
    AllowWhenOverlapped = 64
    RectOnly = 104
    AllowWhenDisabled = 128
  ImGuiInputTextFlags* {.pure, size: int32.sizeof.} = enum
    CallbackCompletion = 64
    CallbackHistory = 128
    CallbackAlways = 256
    CallbackCharFilter = 512
    AllowTabInput = 1024
    CtrlEnterForNewLine = 2048
    NoHorizontalScroll = 4096
    AlwaysInsertMode = 8192
    ReadOnly = 16384
    Password = 32768
    NoUndoRedo = 65536
    CharsScientific = 131072
    CallbackResize = 262144
    Multiline = 1048576
    NoMarkEdited = 2097152
  ImGuiKey* {.pure, size: int32.sizeof.} = enum
    Tab = 0
    LeftArrow = 1
    RightArrow = 2
    UpArrow = 3
    DownArrow = 4
    PageUp = 5
    PageDown = 6
    Home = 7
    End = 8
    Insert = 9
    Delete = 10
    Backspace = 11
    Space = 12
    Enter = 13
    Escape = 14
    A = 15
    C = 16
    V = 17
    X = 18
    Y = 19
    Z = 20
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
    KeyMenu = 16
    KeyTab = 17
    KeyLeft = 18
    KeyRight = 19
    KeyUp = 20
    KeyDown = 21
  ImGuiSelectableFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    DontClosePopups = 1
    SpanAllColumns = 2
    AllowDoubleClick = 4
    Disabled = 8
  ImGuiStyleVar* {.pure, size: int32.sizeof.} = enum
    Alpha = 0
    WindowPadding = 1
    WindowRounding = 2
    WindowBorderSize = 3
    WindowMinSize = 4
    WindowTitleAlign = 5
    ChildRounding = 6
    ChildBorderSize = 7
    PopupRounding = 8
    PopupBorderSize = 9
    FramePadding = 10
    FrameRounding = 11
    FrameBorderSize = 12
    ItemSpacing = 13
    ItemInnerSpacing = 14
    IndentSpacing = 15
    ScrollbarSize = 16
    ScrollbarRounding = 17
    GrabMinSize = 18
    GrabRounding = 19
    TabRounding = 20
    ButtonTextAlign = 21
    SelectableTextAlign = 22
  ImGuiTabBarFlags* {.pure, size: int32.sizeof.} = enum
    FittingPolicyResizeDown = 64
    FittingPolicyScroll = 128
    FittingPolicyMask = 192
  ImGuiTabItemFlags* {.pure, size: int32.sizeof.} = enum
    None = 0
    UnsavedDocument = 1
    SetSelected = 2
    NoCloseWithMiddleMouseButton = 4
    NoPushId = 8
  ImGuiTreeNodeFlags* {.pure, size: int32.sizeof.} = enum
    CollapsingHeader = 26
    OpenOnDoubleClick = 64
    OpenOnArrow = 128
    Leaf = 256
    Bullet = 512
    FramePadding = 1024
    NavLeftJumpsBackHere = 8192
  ImGuiWindowFlags* {.pure, size: int32.sizeof.} = enum
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
    NavFlattened = 8388608
    ChildWindow = 16777216
    Tooltip = 33554432
    Popup = 67108864
    Modal = 134217728
    ChildMenu = 268435456

# TypeDefs
type
  ImDrawCallback* = int32
  ImDrawIdx* = uint16
  ImGuiColumnsFlags* = int32
  ImGuiID* = uint32
  ImGuiInputTextCallback* = int32
  ImGuiSizeCallback* = int32
  ImTextureID* = pointer
  ImWchar* = uint16

# Types
type
  ImVector*[T] = object # Should I importc a generic?
    size*: int32
    capacity*: int32
    data*: UncheckedArray[T]
  ImPairData* {.union.} = object
    val_i*: int32 # Breaking naming convetion to denote "low level"
    val_f*: float32
    val_p*: pointer
  ImPair* {.importc: "Pair", imgui_header.} = object
    key*: ImGuiID
    data*: ImPairData
  ImDrawListSharedData* {.importc: "ImDrawListSharedData", imgui_header.} = object
  ImGuiContext* {.importc: "ImGuiContext", imgui_header.} = object
  CustomRect* {.importc: "CustomRect", imgui_header.} = object
    iD*: uint32
    width*: uint16
    height*: uint16
    x*: uint16
    y*: uint16
    glyphAdvanceX*: float32
    glyphOffset*: ImVec2
    font*: ptr ImFont
  ImColor* {.importc: "ImColor", imgui_header.} = object
    value*: ImVec4
  ImDrawChannel* {.importc: "ImDrawChannel", imgui_header.} = object
    cmdBuffer*: ImVector[ImDrawCmd]
    idxBuffer*: ImVector[ImDrawIdx]
  ImDrawCmd* {.importc: "ImDrawCmd", imgui_header.} = object
    elemCount*: uint32
    clipRect*: ImVec4
    textureId*: ImTextureID
    vtxOffset*: uint32
    idxOffset*: uint32
    userCallback*: ImDrawCallback
    userCallbackData*: pointer
  ImDrawData* {.importc: "ImDrawData", imgui_header.} = object
    valid*: bool
    cmdLists*: ptr ptr ImDrawList
    cmdListsCount*: int32
    totalIdxCount*: int32
    totalVtxCount*: int32
    displayPos*: ImVec2
    displaySize*: ImVec2
    framebufferScale*: ImVec2
  ImDrawList* {.importc: "ImDrawList", imgui_header.} = object
    cmdBuffer*: ImVector[ImDrawCmd]
    idxBuffer*: ImVector[ImDrawIdx]
    vtxBuffer*: ImVector[ImDrawVert]
    flags*: ImDrawListFlags
    data*: ptr ImDrawListSharedData
    ownerName*: ptr int8
    vtxCurrentOffset*: uint32
    vtxCurrentIdx*: uint32
    vtxWritePtr*: ptr ImDrawVert
    idxWritePtr*: ptr ImDrawIdx
    clipRectStack*: ImVector[ImVec4]
    textureIdStack*: ImVector[ImTextureID]
    path*: ImVector[ImVec2]
    splitter*: ImDrawListSplitter
  ImDrawListSplitter* {.importc: "ImDrawListSplitter", imgui_header.} = object
    current*: int32
    count*: int32
    channels*: ImVector[ImDrawChannel]
  ImDrawVert* {.importc: "ImDrawVert", imgui_header.} = object
    pos*: ImVec2
    uv*: ImVec2
    col*: uint32
  ImFont* {.importc: "ImFont", imgui_header.} = object
    indexAdvanceX*: ImVector[float32]
    fallbackAdvanceX*: float32
    fontSize*: float32
    indexLookup*: ImVector[ImWchar]
    glyphs*: ImVector[ImFontGlyph]
    fallbackGlyph*: ptr ImFontGlyph
    displayOffset*: ImVec2
    containerAtlas*: ptr ImFontAtlas
    configData*: ptr ImFontConfig
    configDataCount*: int16
    fallbackChar*: ImWchar
    scale*: float32
    ascent*: float32
    descent*: float32
    metricsTotalSurface*: int32
    dirtyLookupTables*: bool
  ImFontAtlas* {.importc: "ImFontAtlas", imgui_header.} = object
    locked*: bool
    flags*: ImFontAtlasFlags
    texID*: ImTextureID
    texDesiredWidth*: int32
    texGlyphPadding*: int32
    texPixelsAlpha8*: ptr uint8
    texPixelsRGBA32*: ptr uint32
    texWidth*: int32
    texHeight*: int32
    texUvScale*: ImVec2
    texUvWhitePixel*: ImVec2
    fonts*: ImVector[ptr ImFont]
    customRects*: ImVector[CustomRect]
    configData*: ImVector[ImFontConfig]
    customRectIds*: array[1, int32]
  ImFontConfig* {.importc: "ImFontConfig", imgui_header.} = object
    fontData*: pointer
    fontDataSize*: int32
    fontDataOwnedByAtlas*: bool
    fontNo*: int32
    sizePixels*: float32
    oversampleH*: int32
    oversampleV*: int32
    pixelSnapH*: bool
    glyphExtraSpacing*: ImVec2
    glyphOffset*: ImVec2
    glyphRanges*: ptr ImWchar
    glyphMinAdvanceX*: float32
    glyphMaxAdvanceX*: float32
    mergeMode*: bool
    rasterizerFlags*: uint32
    rasterizerMultiply*: float32
    name*: array[40, int8]
    dstFont*: ptr ImFont
  ImFontGlyph* {.importc: "ImFontGlyph", imgui_header.} = object
    codepoint*: ImWchar
    advanceX*: float32
    x0*: float32
    y0*: float32
    x1*: float32
    y1*: float32
    u0*: float32
    v0*: float32
    u1*: float32
    v1*: float32
  ImFontGlyphRangesBuilder* {.importc: "ImFontGlyphRangesBuilder", imgui_header.} = object
    usedChars*: ImVector[uint32]
  ImGuiIO* {.importc: "ImGuiIO", imgui_header.} = object
    configFlags*: ImGuiConfigFlags
    backendFlags*: ImGuiBackendFlags
    displaySize*: ImVec2
    deltaTime*: float32
    iniSavingRate*: float32
    iniFilename*: ptr int8
    logFilename*: ptr int8
    mouseDoubleClickTime*: float32
    mouseDoubleClickMaxDist*: float32
    mouseDragThreshold*: float32
    keyMap*: array[21, int32]
    keyRepeatDelay*: float32
    keyRepeatRate*: float32
    userData*: pointer
    fonts*: ptr ImFontAtlas
    fontGlobalScale*: float32
    fontAllowUserScaling*: bool
    fontDefault*: ptr ImFont
    displayFramebufferScale*: ImVec2
    mouseDrawCursor*: bool
    configMacOSXBehaviors*: bool
    configInputTextCursorBlink*: bool
    configWindowsResizeFromEdges*: bool
    configWindowsMoveFromTitleBarOnly*: bool
    backendPlatformName*: ptr int8
    backendRendererName*: ptr int8
    backendPlatformUserData*: pointer
    backendRendererUserData*: pointer
    backendLanguageUserData*: pointer
    getClipboardTextFn*: int32
    setClipboardTextFn*: int32
    clipboardUserData*: pointer
    imeSetInputScreenPosFn*: int32
    imeWindowHandle*: pointer
    renderDrawListsFnUnused*: pointer
    mousePos*: ImVec2
    mouseDown*: array[5, bool]
    mouseWheel*: float32
    mouseWheelH*: float32
    keyCtrl*: bool
    keyShift*: bool
    keyAlt*: bool
    keySuper*: bool
    keysDown*: array[512, bool]
    navInputs*: array[22, float32]
    wantCaptureMouse*: bool
    wantCaptureKeyboard*: bool
    wantTextInput*: bool
    wantSetMousePos*: bool
    wantSaveIniSettings*: bool
    navActive*: bool
    navVisible*: bool
    framerate*: float32
    metricsRenderVertices*: int32
    metricsRenderIndices*: int32
    metricsRenderWindows*: int32
    metricsActiveWindows*: int32
    metricsActiveAllocations*: int32
    mouseDelta*: ImVec2
    mousePosPrev*: ImVec2
    mouseClickedPos*: array[5, ImVec2]
    mouseClickedTime*: array[5, float64]
    mouseClicked*: array[5, bool]
    mouseDoubleClicked*: array[5, bool]
    mouseReleased*: array[5, bool]
    mouseDownOwned*: array[5, bool]
    mouseDownWasDoubleClick*: array[5, bool]
    mouseDownDuration*: array[5, float32]
    mouseDownDurationPrev*: array[5, float32]
    mouseDragMaxDistanceAbs*: array[5, ImVec2]
    mouseDragMaxDistanceSqr*: array[5, float32]
    keysDownDuration*: array[512, float32]
    keysDownDurationPrev*: array[512, float32]
    navInputsDownDuration*: array[22, float32]
    navInputsDownDurationPrev*: array[22, float32]
    inputQueueCharacters*: ImVector[ImWchar]
  ImGuiInputTextCallbackData* {.importc: "ImGuiInputTextCallbackData", imgui_header.} = object
    eventFlag*: ImGuiInputTextFlags
    flags*: ImGuiInputTextFlags
    userData*: pointer
    eventChar*: ImWchar
    eventKey*: ImGuiKey
    buf*: ptr int8
    bufTextLen*: int32
    bufSize*: int32
    bufDirty*: bool
    cursorPos*: int32
    selectionStart*: int32
    selectionEnd*: int32
  ImGuiListClipper* {.importc: "ImGuiListClipper", imgui_header.} = object
    startPosY*: float32
    itemsHeight*: float32
    itemsCount*: int32
    stepNo*: int32
    displayStart*: int32
    displayEnd*: int32
  ImGuiOnceUponAFrame* {.importc: "ImGuiOnceUponAFrame", imgui_header.} = object
    refFrame*: int32
  ImGuiPayload* {.importc: "ImGuiPayload", imgui_header.} = object
    data*: pointer
    dataSize*: int32
    sourceId*: ImGuiID
    sourceParentId*: ImGuiID
    dataFrameCount*: int32
    dataType*: array[32+1, int8]
    preview*: bool
    delivery*: bool
  ImGuiSizeCallbackData* {.importc: "ImGuiSizeCallbackData", imgui_header.} = object
    userData*: pointer
    pos*: ImVec2
    currentSize*: ImVec2
    desiredSize*: ImVec2
  ImGuiStorage* {.importc: "ImGuiStorage", imgui_header.} = object
    data*: ImVector[ImPair]
  ImGuiStyle* {.importc: "ImGuiStyle", imgui_header.} = object
    alpha*: float32
    windowPadding*: ImVec2
    windowRounding*: float32
    windowBorderSize*: float32
    windowMinSize*: ImVec2
    windowTitleAlign*: ImVec2
    windowMenuButtonPosition*: ImGuiDir
    childRounding*: float32
    childBorderSize*: float32
    popupRounding*: float32
    popupBorderSize*: float32
    framePadding*: ImVec2
    frameRounding*: float32
    frameBorderSize*: float32
    itemSpacing*: ImVec2
    itemInnerSpacing*: ImVec2
    touchExtraPadding*: ImVec2
    indentSpacing*: float32
    columnsMinSpacing*: float32
    scrollbarSize*: float32
    scrollbarRounding*: float32
    grabMinSize*: float32
    grabRounding*: float32
    tabRounding*: float32
    tabBorderSize*: float32
    buttonTextAlign*: ImVec2
    selectableTextAlign*: ImVec2
    displayWindowPadding*: ImVec2
    displaySafeAreaPadding*: ImVec2
    mouseCursorScale*: float32
    antiAliasedLines*: bool
    antiAliasedFill*: bool
    curveTessellationTol*: float32
    colors*: array[48, ImVec4]
  ImGuiTextBuffer* {.importc: "ImGuiTextBuffer", imgui_header.} = object
    buf*: ImVector[int8]
  ImGuiTextFilter* {.importc: "ImGuiTextFilter", imgui_header.} = object
    inputBuf*: array[256, int8]
    filters*: ImVector[TextRange]
    countGrep*: int32
  ImVec2* {.importc: "ImVec2", imgui_header.} = object
    x*: float32
    y*: float32
  ImVec4* {.importc: "ImVec4", imgui_header.} = object
    x*: float32
    y*: float32
    z*: float32
    w*: float32
  TextRange* {.importc: "TextRange", imgui_header.} = object
    b*: ptr int8
    e*: ptr int8
