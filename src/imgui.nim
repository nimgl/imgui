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
else:
  {.compile: "private/cimgui/cimgui.cpp",
    compile: "private/cimgui/imgui/imgui.cpp",
    compile: "private/cimgui/imgui/imgui_draw.cpp",
    compile: "private/cimgui/imgui/imgui_demo.cpp",
    compile: "private/cimgui/imgui/imgui_widgets.cpp".}
  {.pragma: imgui_header, header: "../ncimgui.h".}

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

# Procs
when not defined(imguiSrc):
  {.push dynlib: imgui_dll, cdecl, discardable.}
else:
  {.push nodecl, discardable.}

proc newCustomRect*(): void {.importc: "CustomRect_CustomRect".}
proc isPacked*(self: ptr CustomRect): bool {.importc: "CustomRect_IsPacked".}
proc destroy*(self: ptr CustomRect): void {.importc: "CustomRect_destroy".}
proc hsv*(self: ptr ImColor, h: float32, s: float32, v: float32, a: float32): ImColor {.importc: "ImColor_HSV".}
proc newImColor*(): void {.importc: "ImColor_ImColor".}
proc newImColor*(r: int32, g: int32, b: int32, a: int32): void {.importc: "ImColor_ImColor".}
proc newImColor*(rgba: uint32): void {.importc: "ImColor_ImColor".}
proc newImColor*(r: float32, g: float32, b: float32, a: float32): void {.importc: "ImColor_ImColor".}
proc newImColor*(col: ImVec4): void {.importc: "ImColor_ImColor".}
proc setHSV*(self: ptr ImColor, h: float32, s: float32, v: float32, a: float32): void {.importc: "ImColor_SetHSV".}
proc destroy*(self: ptr ImColor): void {.importc: "ImColor_destroy".}
proc newImDrawCmd*(): void {.importc: "ImDrawCmd_ImDrawCmd".}
proc destroy*(self: ptr ImDrawCmd): void {.importc: "ImDrawCmd_destroy".}
proc clear*(self: ptr ImDrawData): void {.importc: "ImDrawData_Clear".}
proc deIndexAllBuffers*(self: ptr ImDrawData): void {.importc: "ImDrawData_DeIndexAllBuffers".}
proc newImDrawData*(): void {.importc: "ImDrawData_ImDrawData".}
proc scaleClipRects*(self: ptr ImDrawData, fb_scale: ImVec2): void {.importc: "ImDrawData_ScaleClipRects".}
proc destroy*(self: ptr ImDrawData): void {.importc: "ImDrawData_destroy".}
proc clear*(self: ptr ImDrawListSplitter): void {.importc: "ImDrawListSplitter_Clear".}
proc clearFreeMemory*(self: ptr ImDrawListSplitter): void {.importc: "ImDrawListSplitter_ClearFreeMemory".}
proc newImDrawListSplitter*(): void {.importc: "ImDrawListSplitter_ImDrawListSplitter".}
proc merge*(self: ptr ImDrawListSplitter, draw_list: ptr ImDrawList): void {.importc: "ImDrawListSplitter_Merge".}
proc setCurrentChannel*(self: ptr ImDrawListSplitter, draw_list: ptr ImDrawList, channel_idx: int32): void {.importc: "ImDrawListSplitter_SetCurrentChannel".}
proc split*(self: ptr ImDrawListSplitter, draw_list: ptr ImDrawList, count: int32): void {.importc: "ImDrawListSplitter_Split".}
proc destroy*(self: ptr ImDrawListSplitter): void {.importc: "ImDrawListSplitter_destroy".}
proc addBezierCurve*(self: ptr ImDrawList, pos0: ImVec2, cp0: ImVec2, cp1: ImVec2, pos1: ImVec2, col: uint32, thickness: float32, num_segments: int32): void {.importc: "ImDrawList_AddBezierCurve".}
proc addCallback*(self: ptr ImDrawList, callback: ImDrawCallback, callback_data: pointer): void {.importc: "ImDrawList_AddCallback".}
proc addCircle*(self: ptr ImDrawList, centre: ImVec2, radius: float32, col: uint32, num_segments: int32, thickness: float32): void {.importc: "ImDrawList_AddCircle".}
proc addCircleFilled*(self: ptr ImDrawList, centre: ImVec2, radius: float32, col: uint32, num_segments: int32): void {.importc: "ImDrawList_AddCircleFilled".}
proc addConvexPolyFilled*(self: ptr ImDrawList, points: ptr ImVec2, num_points: int32, col: uint32): void {.importc: "ImDrawList_AddConvexPolyFilled".}
proc addDrawCmd*(self: ptr ImDrawList): void {.importc: "ImDrawList_AddDrawCmd".}
proc addImage*(self: ptr ImDrawList, user_texture_id: ImTextureID, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: uint32): void {.importc: "ImDrawList_AddImage".}
proc addImageQuad*(self: ptr ImDrawList, user_texture_id: ImTextureID, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: uint32): void {.importc: "ImDrawList_AddImageQuad".}
proc addImageRounded*(self: ptr ImDrawList, user_texture_id: ImTextureID, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: uint32, rounding: float32, rounding_corners: int32): void {.importc: "ImDrawList_AddImageRounded".}
proc addLine*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, col: uint32, thickness: float32): void {.importc: "ImDrawList_AddLine".}
proc addPolyline*(self: ptr ImDrawList, points: ptr ImVec2, num_points: int32, col: uint32, closed: bool, thickness: float32): void {.importc: "ImDrawList_AddPolyline".}
proc addQuad*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, col: uint32, thickness: float32): void {.importc: "ImDrawList_AddQuad".}
proc addQuadFilled*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, col: uint32): void {.importc: "ImDrawList_AddQuadFilled".}
proc addRect*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, col: uint32, rounding: float32, rounding_corners_flags: int32, thickness: float32): void {.importc: "ImDrawList_AddRect".}
proc addRectFilled*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, col: uint32, rounding: float32, rounding_corners_flags: int32): void {.importc: "ImDrawList_AddRectFilled".}
proc addRectFilledMultiColor*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, col_upr_left: uint32, col_upr_right: uint32, col_bot_right: uint32, col_bot_left: uint32): void {.importc: "ImDrawList_AddRectFilledMultiColor".}
proc addText*(self: ptr ImDrawList, pos: ImVec2, col: uint32, text_begin: ptr int8, text_end: ptr int8): void {.importc: "ImDrawList_AddText".}
proc addText*(self: ptr ImDrawList, font: ptr ImFont, font_size: float32, pos: ImVec2, col: uint32, text_begin: ptr int8, text_end: ptr int8, wrap_width: float32, cpu_fine_clip_rect: ptr ImVec4): void {.importc: "ImDrawList_AddText".}
proc addTriangle*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, col: uint32, thickness: float32): void {.importc: "ImDrawList_AddTriangle".}
proc addTriangleFilled*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, col: uint32): void {.importc: "ImDrawList_AddTriangleFilled".}
proc channelsMerge*(self: ptr ImDrawList): void {.importc: "ImDrawList_ChannelsMerge".}
proc channelsSetCurrent*(self: ptr ImDrawList, n: int32): void {.importc: "ImDrawList_ChannelsSetCurrent".}
proc channelsSplit*(self: ptr ImDrawList, count: int32): void {.importc: "ImDrawList_ChannelsSplit".}
proc clear*(self: ptr ImDrawList): void {.importc: "ImDrawList_Clear".}
proc clearFreeMemory*(self: ptr ImDrawList): void {.importc: "ImDrawList_ClearFreeMemory".}
proc cloneOutput*(self: ptr ImDrawList): ptr ImDrawList {.importc: "ImDrawList_CloneOutput".}
proc getClipRectMax*(self: ptr ImDrawList): ImVec2 {.importc: "ImDrawList_GetClipRectMax".}
proc getClipRectMin*(self: ptr ImDrawList): ImVec2 {.importc: "ImDrawList_GetClipRectMin".}
proc newImDrawList*(shared_data: ptr ImDrawListSharedData): void {.importc: "ImDrawList_ImDrawList".}
proc pathArcTo*(self: ptr ImDrawList, centre: ImVec2, radius: float32, a_min: float32, a_max: float32, num_segments: int32): void {.importc: "ImDrawList_PathArcTo".}
proc pathArcToFast*(self: ptr ImDrawList, centre: ImVec2, radius: float32, a_min_of_12: int32, a_max_of_12: int32): void {.importc: "ImDrawList_PathArcToFast".}
proc pathBezierCurveTo*(self: ptr ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, num_segments: int32): void {.importc: "ImDrawList_PathBezierCurveTo".}
proc pathClear*(self: ptr ImDrawList): void {.importc: "ImDrawList_PathClear".}
proc pathFillConvex*(self: ptr ImDrawList, col: uint32): void {.importc: "ImDrawList_PathFillConvex".}
proc pathLineTo*(self: ptr ImDrawList, pos: ImVec2): void {.importc: "ImDrawList_PathLineTo".}
proc pathLineToMergeDuplicate*(self: ptr ImDrawList, pos: ImVec2): void {.importc: "ImDrawList_PathLineToMergeDuplicate".}
proc pathRect*(self: ptr ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: float32, rounding_corners_flags: int32): void {.importc: "ImDrawList_PathRect".}
proc pathStroke*(self: ptr ImDrawList, col: uint32, closed: bool, thickness: float32): void {.importc: "ImDrawList_PathStroke".}
proc popClipRect*(self: ptr ImDrawList): void {.importc: "ImDrawList_PopClipRect".}
proc popTextureID*(self: ptr ImDrawList): void {.importc: "ImDrawList_PopTextureID".}
proc primQuadUV*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimQuadUV".}
proc primRect*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimRect".}
proc primRectUV*(self: ptr ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimRectUV".}
proc primReserve*(self: ptr ImDrawList, idx_count: int32, vtx_count: int32): void {.importc: "ImDrawList_PrimReserve".}
proc primVtx*(self: ptr ImDrawList, pos: ImVec2, uv: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimVtx".}
proc primWriteIdx*(self: ptr ImDrawList, idx: ImDrawIdx): void {.importc: "ImDrawList_PrimWriteIdx".}
proc primWriteVtx*(self: ptr ImDrawList, pos: ImVec2, uv: ImVec2, col: uint32): void {.importc: "ImDrawList_PrimWriteVtx".}
proc pushClipRect*(self: ptr ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool): void {.importc: "ImDrawList_PushClipRect".}
proc pushClipRectFullScreen*(self: ptr ImDrawList): void {.importc: "ImDrawList_PushClipRectFullScreen".}
proc pushTextureID*(self: ptr ImDrawList, texture_id: ImTextureID): void {.importc: "ImDrawList_PushTextureID".}
proc updateClipRect*(self: ptr ImDrawList): void {.importc: "ImDrawList_UpdateClipRect".}
proc updateTextureID*(self: ptr ImDrawList): void {.importc: "ImDrawList_UpdateTextureID".}
proc destroy*(self: ptr ImDrawList): void {.importc: "ImDrawList_destroy".}
proc addCustomRectFontGlyph*(self: ptr ImFontAtlas, font: ptr ImFont, id: ImWchar, width: int32, height: int32, advance_x: float32, offset: ImVec2): int32 {.importc: "ImFontAtlas_AddCustomRectFontGlyph".}
proc addCustomRectRegular*(self: ptr ImFontAtlas, id: uint32, width: int32, height: int32): int32 {.importc: "ImFontAtlas_AddCustomRectRegular".}
proc addFont*(self: ptr ImFontAtlas, font_cfg: ptr ImFontConfig): ptr ImFont {.importc: "ImFontAtlas_AddFont".}
proc addFontDefault*(self: ptr ImFontAtlas, font_cfg: ptr ImFontConfig): ptr ImFont {.importc: "ImFontAtlas_AddFontDefault".}
proc addFontFromFileTTF*(self: ptr ImFontAtlas, filename: ptr int8, size_pixels: float32, font_cfg: ptr ImFontConfig, glyph_ranges: ptr ImWchar): ptr ImFont {.importc: "ImFontAtlas_AddFontFromFileTTF".}
proc addFontFromMemoryCompressedBase85TTF*(self: ptr ImFontAtlas, compressed_font_data_base85: ptr int8, size_pixels: float32, font_cfg: ptr ImFontConfig, glyph_ranges: ptr ImWchar): ptr ImFont {.importc: "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF".}
proc addFontFromMemoryCompressedTTF*(self: ptr ImFontAtlas, compressed_font_data: pointer, compressed_font_size: int32, size_pixels: float32, font_cfg: ptr ImFontConfig, glyph_ranges: ptr ImWchar): ptr ImFont {.importc: "ImFontAtlas_AddFontFromMemoryCompressedTTF".}
proc addFontFromMemoryTTF*(self: ptr ImFontAtlas, font_data: pointer, font_size: int32, size_pixels: float32, font_cfg: ptr ImFontConfig, glyph_ranges: ptr ImWchar): ptr ImFont {.importc: "ImFontAtlas_AddFontFromMemoryTTF".}
proc build*(self: ptr ImFontAtlas): bool {.importc: "ImFontAtlas_Build".}
proc calcCustomRectUV*(self: ptr ImFontAtlas, rect: ptr CustomRect, out_uv_min: ptr ImVec2, out_uv_max: ptr ImVec2): void {.importc: "ImFontAtlas_CalcCustomRectUV".}
proc clear*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_Clear".}
proc clearFonts*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_ClearFonts".}
proc clearInputData*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_ClearInputData".}
proc clearTexData*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_ClearTexData".}
proc getCustomRectByIndex*(self: ptr ImFontAtlas, index: int32): ptr CustomRect {.importc: "ImFontAtlas_GetCustomRectByIndex".}
proc getGlyphRangesChineseFull*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesChineseFull".}
proc getGlyphRangesChineseSimplifiedCommon*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon".}
proc getGlyphRangesCyrillic*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesCyrillic".}
proc getGlyphRangesDefault*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesDefault".}
proc getGlyphRangesJapanese*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesJapanese".}
proc getGlyphRangesKorean*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesKorean".}
proc getGlyphRangesThai*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesThai".}
proc getGlyphRangesVietnamese*(self: ptr ImFontAtlas): ptr ImWchar {.importc: "ImFontAtlas_GetGlyphRangesVietnamese".}
proc getMouseCursorTexData*(self: ptr ImFontAtlas, cursor: ImGuiMouseCursor, out_offset: ptr ImVec2, out_size: ptr ImVec2, out_uv_border: array[2, ImVec2], out_uv_fill: array[2, ImVec2]): bool {.importc: "ImFontAtlas_GetMouseCursorTexData".}
proc getTexDataAsAlpha8*(self: ptr ImFontAtlas, out_pixels: ptr ptr uint8, out_width: ptr int32, out_height: ptr int32, out_bytes_per_pixel: ptr int32): void {.importc: "ImFontAtlas_GetTexDataAsAlpha8".}
proc getTexDataAsRGBA32*(self: ptr ImFontAtlas, out_pixels: ptr ptr uint8, out_width: ptr int32, out_height: ptr int32, out_bytes_per_pixel: ptr int32): void {.importc: "ImFontAtlas_GetTexDataAsRGBA32".}
proc newImFontAtlas*(): void {.importc: "ImFontAtlas_ImFontAtlas".}
proc isBuilt*(self: ptr ImFontAtlas): bool {.importc: "ImFontAtlas_IsBuilt".}
proc setTexID*(self: ptr ImFontAtlas, id: ImTextureID): void {.importc: "ImFontAtlas_SetTexID".}
proc destroy*(self: ptr ImFontAtlas): void {.importc: "ImFontAtlas_destroy".}
proc newImFontConfig*(): void {.importc: "ImFontConfig_ImFontConfig".}
proc destroy*(self: ptr ImFontConfig): void {.importc: "ImFontConfig_destroy".}
proc addChar*(self: ptr ImFontGlyphRangesBuilder, c: ImWchar): void {.importc: "ImFontGlyphRangesBuilder_AddChar".}
proc addRanges*(self: ptr ImFontGlyphRangesBuilder, ranges: ptr ImWchar): void {.importc: "ImFontGlyphRangesBuilder_AddRanges".}
proc addText*(self: ptr ImFontGlyphRangesBuilder, text: ptr int8, text_end: ptr int8): void {.importc: "ImFontGlyphRangesBuilder_AddText".}
proc buildRanges*(self: ptr ImFontGlyphRangesBuilder, out_ranges: ptr ImVector[ImWchar]): void {.importc: "ImFontGlyphRangesBuilder_BuildRanges".}
proc clear*(self: ptr ImFontGlyphRangesBuilder): void {.importc: "ImFontGlyphRangesBuilder_Clear".}
proc getBit*(self: ptr ImFontGlyphRangesBuilder, n: int32): bool {.importc: "ImFontGlyphRangesBuilder_GetBit".}
proc newImFontGlyphRangesBuilder*(): void {.importc: "ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder".}
proc setBit*(self: ptr ImFontGlyphRangesBuilder, n: int32): void {.importc: "ImFontGlyphRangesBuilder_SetBit".}
proc destroy*(self: ptr ImFontGlyphRangesBuilder): void {.importc: "ImFontGlyphRangesBuilder_destroy".}
proc addGlyph*(self: ptr ImFont, c: ImWchar, x0: float32, y0: float32, x1: float32, y1: float32, u0: float32, v0: float32, u1: float32, v1: float32, advance_x: float32): void {.importc: "ImFont_AddGlyph".}
proc addRemapChar*(self: ptr ImFont, dst: ImWchar, src: ImWchar, overwrite_dst: bool): void {.importc: "ImFont_AddRemapChar".}
proc buildLookupTable*(self: ptr ImFont): void {.importc: "ImFont_BuildLookupTable".}
proc calcTextSizeA*(self: ptr ImFont, size: float32, max_width: float32, wrap_width: float32, text_begin: ptr int8, text_end: ptr int8, remaining: ptr ptr int8): ImVec2 {.importc: "ImFont_CalcTextSizeA".}
proc calcWordWrapPositionA*(self: ptr ImFont, scale: float32, text: ptr int8, text_end: ptr int8, wrap_width: float32): ptr int8 {.importc: "ImFont_CalcWordWrapPositionA".}
proc clearOutputData*(self: ptr ImFont): void {.importc: "ImFont_ClearOutputData".}
proc findGlyph*(self: ptr ImFont, c: ImWchar): ptr ImFontGlyph {.importc: "ImFont_FindGlyph".}
proc findGlyphNoFallback*(self: ptr ImFont, c: ImWchar): ptr ImFontGlyph {.importc: "ImFont_FindGlyphNoFallback".}
proc getCharAdvance*(self: ptr ImFont, c: ImWchar): float32 {.importc: "ImFont_GetCharAdvance".}
proc getDebugName*(self: ptr ImFont): ptr int8 {.importc: "ImFont_GetDebugName".}
proc growIndex*(self: ptr ImFont, new_size: int32): void {.importc: "ImFont_GrowIndex".}
proc newImFont*(): void {.importc: "ImFont_ImFont".}
proc isLoaded*(self: ptr ImFont): bool {.importc: "ImFont_IsLoaded".}
proc renderChar*(self: ptr ImFont, draw_list: ptr ImDrawList, size: float32, pos: ImVec2, col: uint32, c: ImWchar): void {.importc: "ImFont_RenderChar".}
proc renderText*(self: ptr ImFont, draw_list: ptr ImDrawList, size: float32, pos: ImVec2, col: uint32, clip_rect: ImVec4, text_begin: ptr int8, text_end: ptr int8, wrap_width: float32, cpu_fine_clip: bool): void {.importc: "ImFont_RenderText".}
proc setFallbackChar*(self: ptr ImFont, c: ImWchar): void {.importc: "ImFont_SetFallbackChar".}
proc destroy*(self: ptr ImFont): void {.importc: "ImFont_destroy".}
proc addInputCharacter*(self: ptr ImGuiIO, c: uint32): void {.importc: "ImGuiIO_AddInputCharacter".}
proc addInputCharactersUTF8*(self: ptr ImGuiIO, str: ptr int8): void {.importc: "ImGuiIO_AddInputCharactersUTF8".}
proc clearInputCharacters*(self: ptr ImGuiIO): void {.importc: "ImGuiIO_ClearInputCharacters".}
proc newImGuiIO*(): void {.importc: "ImGuiIO_ImGuiIO".}
proc destroy*(self: ptr ImGuiIO): void {.importc: "ImGuiIO_destroy".}
proc deleteChars*(self: ptr ImGuiInputTextCallbackData, pos: int32, bytes_count: int32): void {.importc: "ImGuiInputTextCallbackData_DeleteChars".}
proc hasSelection*(self: ptr ImGuiInputTextCallbackData): bool {.importc: "ImGuiInputTextCallbackData_HasSelection".}
proc newImGuiInputTextCallbackData*(): void {.importc: "ImGuiInputTextCallbackData_ImGuiInputTextCallbackData".}
proc insertChars*(self: ptr ImGuiInputTextCallbackData, pos: int32, text: ptr int8, text_end: ptr int8): void {.importc: "ImGuiInputTextCallbackData_InsertChars".}
proc destroy*(self: ptr ImGuiInputTextCallbackData): void {.importc: "ImGuiInputTextCallbackData_destroy".}
proc begin*(self: ptr ImGuiListClipper, items_count: int32, items_height: float32): void {.importc: "ImGuiListClipper_Begin".}
proc `end`*(self: ptr ImGuiListClipper): void {.importc: "ImGuiListClipper_End".}
proc newImGuiListClipper*(items_count: int32, items_height: float32): void {.importc: "ImGuiListClipper_ImGuiListClipper".}
proc step*(self: ptr ImGuiListClipper): bool {.importc: "ImGuiListClipper_Step".}
proc destroy*(self: ptr ImGuiListClipper): void {.importc: "ImGuiListClipper_destroy".}
proc newImGuiOnceUponAFrame*(): void {.importc: "ImGuiOnceUponAFrame_ImGuiOnceUponAFrame".}
proc destroy*(self: ptr ImGuiOnceUponAFrame): void {.importc: "ImGuiOnceUponAFrame_destroy".}
proc clear*(self: ptr ImGuiPayload): void {.importc: "ImGuiPayload_Clear".}
proc newImGuiPayload*(): void {.importc: "ImGuiPayload_ImGuiPayload".}
proc isDataType*(self: ptr ImGuiPayload, `type`: ptr int8): bool {.importc: "ImGuiPayload_IsDataType".}
proc isDelivery*(self: ptr ImGuiPayload): bool {.importc: "ImGuiPayload_IsDelivery".}
proc isPreview*(self: ptr ImGuiPayload): bool {.importc: "ImGuiPayload_IsPreview".}
proc destroy*(self: ptr ImGuiPayload): void {.importc: "ImGuiPayload_destroy".}
proc buildSortByKey*(self: ptr ImGuiStorage): void {.importc: "ImGuiStorage_BuildSortByKey".}
proc clear*(self: ptr ImGuiStorage): void {.importc: "ImGuiStorage_Clear".}
proc getBool*(self: ptr ImGuiStorage, key: ImGuiID, default_val: bool): bool {.importc: "ImGuiStorage_GetBool".}
proc getBoolRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: bool): ptr bool {.importc: "ImGuiStorage_GetBoolRef".}
proc getFloat*(self: ptr ImGuiStorage, key: ImGuiID, default_val: float32): float32 {.importc: "ImGuiStorage_GetFloat".}
proc getFloatRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: float32): ptr float32 {.importc: "ImGuiStorage_GetFloatRef".}
proc getInt*(self: ptr ImGuiStorage, key: ImGuiID, default_val: int32): int32 {.importc: "ImGuiStorage_GetInt".}
proc getIntRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: int32): ptr int32 {.importc: "ImGuiStorage_GetIntRef".}
proc getVoidPtr*(self: ptr ImGuiStorage, key: ImGuiID): pointer {.importc: "ImGuiStorage_GetVoidPtr".}
proc getVoidPtrRef*(self: ptr ImGuiStorage, key: ImGuiID, default_val: pointer): ptr pointer {.importc: "ImGuiStorage_GetVoidPtrRef".}
proc setAllInt*(self: ptr ImGuiStorage, val: int32): void {.importc: "ImGuiStorage_SetAllInt".}
proc setBool*(self: ptr ImGuiStorage, key: ImGuiID, val: bool): void {.importc: "ImGuiStorage_SetBool".}
proc setFloat*(self: ptr ImGuiStorage, key: ImGuiID, val: float32): void {.importc: "ImGuiStorage_SetFloat".}
proc setInt*(self: ptr ImGuiStorage, key: ImGuiID, val: int32): void {.importc: "ImGuiStorage_SetInt".}
proc setVoidPtr*(self: ptr ImGuiStorage, key: ImGuiID, val: pointer): void {.importc: "ImGuiStorage_SetVoidPtr".}
proc newImGuiStyle*(): void {.importc: "ImGuiStyle_ImGuiStyle".}
proc scaleAllSizes*(self: ptr ImGuiStyle, scale_factor: float32): void {.importc: "ImGuiStyle_ScaleAllSizes".}
proc destroy*(self: ptr ImGuiStyle): void {.importc: "ImGuiStyle_destroy".}
proc newImGuiTextBuffer*(): void {.importc: "ImGuiTextBuffer_ImGuiTextBuffer".}
proc append*(self: ptr ImGuiTextBuffer, str: ptr int8, str_end: ptr int8): void {.importc: "ImGuiTextBuffer_append".}
proc appendf*(self: ptr ImGuiTextBuffer, fmt: ptr int8): void {.importc: "ImGuiTextBuffer_appendf", varargs.}
proc appendfv*(self: ptr ImGuiTextBuffer, fmt: ptr int8): void {.importc: "ImGuiTextBuffer_appendfv", varargs.}
proc begin*(self: ptr ImGuiTextBuffer): ptr int8 {.importc: "ImGuiTextBuffer_begin".}
proc c_str*(self: ptr ImGuiTextBuffer): ptr int8 {.importc: "ImGuiTextBuffer_c_str".}
proc clear*(self: ptr ImGuiTextBuffer): void {.importc: "ImGuiTextBuffer_clear".}
proc destroy*(self: ptr ImGuiTextBuffer): void {.importc: "ImGuiTextBuffer_destroy".}
proc empty*(self: ptr ImGuiTextBuffer): bool {.importc: "ImGuiTextBuffer_empty".}
proc `end`*(self: ptr ImGuiTextBuffer): ptr int8 {.importc: "ImGuiTextBuffer_end".}
proc reserve*(self: ptr ImGuiTextBuffer, capacity: int32): void {.importc: "ImGuiTextBuffer_reserve".}
proc size*(self: ptr ImGuiTextBuffer): int32 {.importc: "ImGuiTextBuffer_size".}
proc build*(self: ptr ImGuiTextFilter): void {.importc: "ImGuiTextFilter_Build".}
proc clear*(self: ptr ImGuiTextFilter): void {.importc: "ImGuiTextFilter_Clear".}
proc draw*(self: ptr ImGuiTextFilter, label: ptr int8, width: float32): bool {.importc: "ImGuiTextFilter_Draw".}
proc newImGuiTextFilter*(default_filter: ptr int8): void {.importc: "ImGuiTextFilter_ImGuiTextFilter".}
proc isActive*(self: ptr ImGuiTextFilter): bool {.importc: "ImGuiTextFilter_IsActive".}
proc passFilter*(self: ptr ImGuiTextFilter, text: ptr int8, text_end: ptr int8): bool {.importc: "ImGuiTextFilter_PassFilter".}
proc destroy*(self: ptr ImGuiTextFilter): void {.importc: "ImGuiTextFilter_destroy".}
proc newImVec2*(): void {.importc: "ImVec2_ImVec2".}
proc newImVec2*(x: float32, y: float32): void {.importc: "ImVec2_ImVec2".}
proc destroy*(self: ptr ImVec2): void {.importc: "ImVec2_destroy".}
proc newImVec4*(): void {.importc: "ImVec4_ImVec4".}
proc newImVec4*(x: float32, y: float32, z: float32, w: float32): void {.importc: "ImVec4_ImVec4".}
proc destroy*(self: ptr ImVec4): void {.importc: "ImVec4_destroy".}
proc grow_capacity*(self: ptr ImVector[CustomRect], sz: int32): int32 {.importc: "ImVector_CustomRect__grow_capacity".}
proc back*(self: ptr ImVector[CustomRect]): ptr CustomRect {.importc: "ImVector_CustomRect_back".}
proc begin*(self: ptr ImVector[CustomRect]): ptr CustomRect {.importc: "ImVector_CustomRect_begin".}
proc capacity*(self: ptr ImVector[CustomRect]): int32 {.importc: "ImVector_CustomRect_capacity".}
proc clear*(self: ptr ImVector[CustomRect]): void {.importc: "ImVector_CustomRect_clear".}
proc destroy*(self: ptr ImVector[CustomRect]): void {.importc: "ImVector_CustomRect_destroy".}
proc empty*(self: ptr ImVector[CustomRect]): bool {.importc: "ImVector_CustomRect_empty".}
proc `end`*(self: ptr ImVector[CustomRect]): ptr CustomRect {.importc: "ImVector_CustomRect_end".}
proc erase*(self: ptr ImVector[CustomRect], it: ptr CustomRect): ptr CustomRect {.importc: "ImVector_CustomRect_erase".}
proc erase*(self: ptr ImVector[CustomRect], it: ptr CustomRect, it_last: ptr CustomRect): ptr CustomRect {.importc: "ImVector_CustomRect_erase".}
proc erase_unsorted*(self: ptr ImVector[CustomRect], it: ptr CustomRect): ptr CustomRect {.importc: "ImVector_CustomRect_erase_unsorted".}
proc front*(self: ptr ImVector[CustomRect]): ptr CustomRect {.importc: "ImVector_CustomRect_front".}
proc index_from_ptr*(self: ptr ImVector[CustomRect], it: ptr CustomRect): int32 {.importc: "ImVector_CustomRect_index_from_ptr".}
proc insert*(self: ptr ImVector[CustomRect], it: ptr CustomRect, v: CustomRect): ptr CustomRect {.importc: "ImVector_CustomRect_insert".}
proc pop_back*(self: ptr ImVector[CustomRect]): void {.importc: "ImVector_CustomRect_pop_back".}
proc push_back*(self: ptr ImVector[CustomRect], v: CustomRect): void {.importc: "ImVector_CustomRect_push_back".}
proc push_front*(self: ptr ImVector[CustomRect], v: CustomRect): void {.importc: "ImVector_CustomRect_push_front".}
proc reserve*(self: ptr ImVector[CustomRect], new_capacity: int32): void {.importc: "ImVector_CustomRect_reserve".}
proc resize*(self: ptr ImVector[CustomRect], new_size: int32): void {.importc: "ImVector_CustomRect_resize".}
proc resize*(self: ptr ImVector[CustomRect], new_size: int32, v: CustomRect): void {.importc: "ImVector_CustomRect_resize".}
proc size*(self: ptr ImVector[CustomRect]): int32 {.importc: "ImVector_CustomRect_size".}
proc size_in_bytes*(self: ptr ImVector[CustomRect]): int32 {.importc: "ImVector_CustomRect_size_in_bytes".}
proc swap*(self: ptr ImVector[CustomRect], rhs: ImVector[CustomRect]): void {.importc: "ImVector_CustomRect_swap".}
proc grow_capacity*(self: ptr ImVector[ImDrawChannel], sz: int32): int32 {.importc: "ImVector_ImDrawChannel__grow_capacity".}
proc back*(self: ptr ImVector[ImDrawChannel]): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_back".}
proc begin*(self: ptr ImVector[ImDrawChannel]): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_begin".}
proc capacity*(self: ptr ImVector[ImDrawChannel]): int32 {.importc: "ImVector_ImDrawChannel_capacity".}
proc clear*(self: ptr ImVector[ImDrawChannel]): void {.importc: "ImVector_ImDrawChannel_clear".}
proc destroy*(self: ptr ImVector[ImDrawChannel]): void {.importc: "ImVector_ImDrawChannel_destroy".}
proc empty*(self: ptr ImVector[ImDrawChannel]): bool {.importc: "ImVector_ImDrawChannel_empty".}
proc `end`*(self: ptr ImVector[ImDrawChannel]): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_end".}
proc erase*(self: ptr ImVector[ImDrawChannel], it: ptr ImDrawChannel): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_erase".}
proc erase*(self: ptr ImVector[ImDrawChannel], it: ptr ImDrawChannel, it_last: ptr ImDrawChannel): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_erase".}
proc erase_unsorted*(self: ptr ImVector[ImDrawChannel], it: ptr ImDrawChannel): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_erase_unsorted".}
proc front*(self: ptr ImVector[ImDrawChannel]): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_front".}
proc index_from_ptr*(self: ptr ImVector[ImDrawChannel], it: ptr ImDrawChannel): int32 {.importc: "ImVector_ImDrawChannel_index_from_ptr".}
proc insert*(self: ptr ImVector[ImDrawChannel], it: ptr ImDrawChannel, v: ImDrawChannel): ptr ImDrawChannel {.importc: "ImVector_ImDrawChannel_insert".}
proc pop_back*(self: ptr ImVector[ImDrawChannel]): void {.importc: "ImVector_ImDrawChannel_pop_back".}
proc push_back*(self: ptr ImVector[ImDrawChannel], v: ImDrawChannel): void {.importc: "ImVector_ImDrawChannel_push_back".}
proc push_front*(self: ptr ImVector[ImDrawChannel], v: ImDrawChannel): void {.importc: "ImVector_ImDrawChannel_push_front".}
proc reserve*(self: ptr ImVector[ImDrawChannel], new_capacity: int32): void {.importc: "ImVector_ImDrawChannel_reserve".}
proc resize*(self: ptr ImVector[ImDrawChannel], new_size: int32): void {.importc: "ImVector_ImDrawChannel_resize".}
proc resize*(self: ptr ImVector[ImDrawChannel], new_size: int32, v: ImDrawChannel): void {.importc: "ImVector_ImDrawChannel_resize".}
proc size*(self: ptr ImVector[ImDrawChannel]): int32 {.importc: "ImVector_ImDrawChannel_size".}
proc size_in_bytes*(self: ptr ImVector[ImDrawChannel]): int32 {.importc: "ImVector_ImDrawChannel_size_in_bytes".}
proc swap*(self: ptr ImVector[ImDrawChannel], rhs: ImVector[ImDrawChannel]): void {.importc: "ImVector_ImDrawChannel_swap".}
proc grow_capacity*(self: ptr ImVector[ImDrawCmd], sz: int32): int32 {.importc: "ImVector_ImDrawCmd__grow_capacity".}
proc back*(self: ptr ImVector[ImDrawCmd]): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_back".}
proc begin*(self: ptr ImVector[ImDrawCmd]): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_begin".}
proc capacity*(self: ptr ImVector[ImDrawCmd]): int32 {.importc: "ImVector_ImDrawCmd_capacity".}
proc clear*(self: ptr ImVector[ImDrawCmd]): void {.importc: "ImVector_ImDrawCmd_clear".}
proc destroy*(self: ptr ImVector[ImDrawCmd]): void {.importc: "ImVector_ImDrawCmd_destroy".}
proc empty*(self: ptr ImVector[ImDrawCmd]): bool {.importc: "ImVector_ImDrawCmd_empty".}
proc `end`*(self: ptr ImVector[ImDrawCmd]): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_end".}
proc erase*(self: ptr ImVector[ImDrawCmd], it: ptr ImDrawCmd): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_erase".}
proc erase*(self: ptr ImVector[ImDrawCmd], it: ptr ImDrawCmd, it_last: ptr ImDrawCmd): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_erase".}
proc erase_unsorted*(self: ptr ImVector[ImDrawCmd], it: ptr ImDrawCmd): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_erase_unsorted".}
proc front*(self: ptr ImVector[ImDrawCmd]): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_front".}
proc index_from_ptr*(self: ptr ImVector[ImDrawCmd], it: ptr ImDrawCmd): int32 {.importc: "ImVector_ImDrawCmd_index_from_ptr".}
proc insert*(self: ptr ImVector[ImDrawCmd], it: ptr ImDrawCmd, v: ImDrawCmd): ptr ImDrawCmd {.importc: "ImVector_ImDrawCmd_insert".}
proc pop_back*(self: ptr ImVector[ImDrawCmd]): void {.importc: "ImVector_ImDrawCmd_pop_back".}
proc push_back*(self: ptr ImVector[ImDrawCmd], v: ImDrawCmd): void {.importc: "ImVector_ImDrawCmd_push_back".}
proc push_front*(self: ptr ImVector[ImDrawCmd], v: ImDrawCmd): void {.importc: "ImVector_ImDrawCmd_push_front".}
proc reserve*(self: ptr ImVector[ImDrawCmd], new_capacity: int32): void {.importc: "ImVector_ImDrawCmd_reserve".}
proc resize*(self: ptr ImVector[ImDrawCmd], new_size: int32): void {.importc: "ImVector_ImDrawCmd_resize".}
proc resize*(self: ptr ImVector[ImDrawCmd], new_size: int32, v: ImDrawCmd): void {.importc: "ImVector_ImDrawCmd_resize".}
proc size*(self: ptr ImVector[ImDrawCmd]): int32 {.importc: "ImVector_ImDrawCmd_size".}
proc size_in_bytes*(self: ptr ImVector[ImDrawCmd]): int32 {.importc: "ImVector_ImDrawCmd_size_in_bytes".}
proc swap*(self: ptr ImVector[ImDrawCmd], rhs: ImVector[ImDrawCmd]): void {.importc: "ImVector_ImDrawCmd_swap".}
proc grow_capacity*(self: ptr ImVector[ImDrawIdx], sz: int32): int32 {.importc: "ImVector_ImDrawIdx__grow_capacity".}
proc back*(self: ptr ImVector[ImDrawIdx]): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_back".}
proc begin*(self: ptr ImVector[ImDrawIdx]): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_begin".}
proc capacity*(self: ptr ImVector[ImDrawIdx]): int32 {.importc: "ImVector_ImDrawIdx_capacity".}
proc clear*(self: ptr ImVector[ImDrawIdx]): void {.importc: "ImVector_ImDrawIdx_clear".}
proc destroy*(self: ptr ImVector[ImDrawIdx]): void {.importc: "ImVector_ImDrawIdx_destroy".}
proc empty*(self: ptr ImVector[ImDrawIdx]): bool {.importc: "ImVector_ImDrawIdx_empty".}
proc `end`*(self: ptr ImVector[ImDrawIdx]): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_end".}
proc erase*(self: ptr ImVector[ImDrawIdx], it: ptr ImDrawIdx): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_erase".}
proc erase*(self: ptr ImVector[ImDrawIdx], it: ptr ImDrawIdx, it_last: ptr ImDrawIdx): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_erase".}
proc erase_unsorted*(self: ptr ImVector[ImDrawIdx], it: ptr ImDrawIdx): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_erase_unsorted".}
proc front*(self: ptr ImVector[ImDrawIdx]): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_front".}
proc index_from_ptr*(self: ptr ImVector[ImDrawIdx], it: ptr ImDrawIdx): int32 {.importc: "ImVector_ImDrawIdx_index_from_ptr".}
proc insert*(self: ptr ImVector[ImDrawIdx], it: ptr ImDrawIdx, v: ImDrawIdx): ptr ImDrawIdx {.importc: "ImVector_ImDrawIdx_insert".}
proc pop_back*(self: ptr ImVector[ImDrawIdx]): void {.importc: "ImVector_ImDrawIdx_pop_back".}
proc push_back*(self: ptr ImVector[ImDrawIdx], v: ImDrawIdx): void {.importc: "ImVector_ImDrawIdx_push_back".}
proc push_front*(self: ptr ImVector[ImDrawIdx], v: ImDrawIdx): void {.importc: "ImVector_ImDrawIdx_push_front".}
proc reserve*(self: ptr ImVector[ImDrawIdx], new_capacity: int32): void {.importc: "ImVector_ImDrawIdx_reserve".}
proc resize*(self: ptr ImVector[ImDrawIdx], new_size: int32): void {.importc: "ImVector_ImDrawIdx_resize".}
proc resize*(self: ptr ImVector[ImDrawIdx], new_size: int32, v: ImDrawIdx): void {.importc: "ImVector_ImDrawIdx_resize".}
proc size*(self: ptr ImVector[ImDrawIdx]): int32 {.importc: "ImVector_ImDrawIdx_size".}
proc size_in_bytes*(self: ptr ImVector[ImDrawIdx]): int32 {.importc: "ImVector_ImDrawIdx_size_in_bytes".}
proc swap*(self: ptr ImVector[ImDrawIdx], rhs: ImVector[ImDrawIdx]): void {.importc: "ImVector_ImDrawIdx_swap".}
proc grow_capacity*(self: ptr ImVector[ImDrawVert], sz: int32): int32 {.importc: "ImVector_ImDrawVert__grow_capacity".}
proc back*(self: ptr ImVector[ImDrawVert]): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_back".}
proc begin*(self: ptr ImVector[ImDrawVert]): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_begin".}
proc capacity*(self: ptr ImVector[ImDrawVert]): int32 {.importc: "ImVector_ImDrawVert_capacity".}
proc clear*(self: ptr ImVector[ImDrawVert]): void {.importc: "ImVector_ImDrawVert_clear".}
proc destroy*(self: ptr ImVector[ImDrawVert]): void {.importc: "ImVector_ImDrawVert_destroy".}
proc empty*(self: ptr ImVector[ImDrawVert]): bool {.importc: "ImVector_ImDrawVert_empty".}
proc `end`*(self: ptr ImVector[ImDrawVert]): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_end".}
proc erase*(self: ptr ImVector[ImDrawVert], it: ptr ImDrawVert): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_erase".}
proc erase*(self: ptr ImVector[ImDrawVert], it: ptr ImDrawVert, it_last: ptr ImDrawVert): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_erase".}
proc erase_unsorted*(self: ptr ImVector[ImDrawVert], it: ptr ImDrawVert): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_erase_unsorted".}
proc front*(self: ptr ImVector[ImDrawVert]): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_front".}
proc index_from_ptr*(self: ptr ImVector[ImDrawVert], it: ptr ImDrawVert): int32 {.importc: "ImVector_ImDrawVert_index_from_ptr".}
proc insert*(self: ptr ImVector[ImDrawVert], it: ptr ImDrawVert, v: ImDrawVert): ptr ImDrawVert {.importc: "ImVector_ImDrawVert_insert".}
proc pop_back*(self: ptr ImVector[ImDrawVert]): void {.importc: "ImVector_ImDrawVert_pop_back".}
proc push_back*(self: ptr ImVector[ImDrawVert], v: ImDrawVert): void {.importc: "ImVector_ImDrawVert_push_back".}
proc push_front*(self: ptr ImVector[ImDrawVert], v: ImDrawVert): void {.importc: "ImVector_ImDrawVert_push_front".}
proc reserve*(self: ptr ImVector[ImDrawVert], new_capacity: int32): void {.importc: "ImVector_ImDrawVert_reserve".}
proc resize*(self: ptr ImVector[ImDrawVert], new_size: int32): void {.importc: "ImVector_ImDrawVert_resize".}
proc resize*(self: ptr ImVector[ImDrawVert], new_size: int32, v: ImDrawVert): void {.importc: "ImVector_ImDrawVert_resize".}
proc size*(self: ptr ImVector[ImDrawVert]): int32 {.importc: "ImVector_ImDrawVert_size".}
proc size_in_bytes*(self: ptr ImVector[ImDrawVert]): int32 {.importc: "ImVector_ImDrawVert_size_in_bytes".}
proc swap*(self: ptr ImVector[ImDrawVert], rhs: ImVector[ImDrawVert]): void {.importc: "ImVector_ImDrawVert_swap".}
proc grow_capacity*(self: ptr ImVector[ImFontConfig], sz: int32): int32 {.importc: "ImVector_ImFontConfig__grow_capacity".}
proc back*(self: ptr ImVector[ImFontConfig]): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_back".}
proc begin*(self: ptr ImVector[ImFontConfig]): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_begin".}
proc capacity*(self: ptr ImVector[ImFontConfig]): int32 {.importc: "ImVector_ImFontConfig_capacity".}
proc clear*(self: ptr ImVector[ImFontConfig]): void {.importc: "ImVector_ImFontConfig_clear".}
proc destroy*(self: ptr ImVector[ImFontConfig]): void {.importc: "ImVector_ImFontConfig_destroy".}
proc empty*(self: ptr ImVector[ImFontConfig]): bool {.importc: "ImVector_ImFontConfig_empty".}
proc `end`*(self: ptr ImVector[ImFontConfig]): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_end".}
proc erase*(self: ptr ImVector[ImFontConfig], it: ptr ImFontConfig): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_erase".}
proc erase*(self: ptr ImVector[ImFontConfig], it: ptr ImFontConfig, it_last: ptr ImFontConfig): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_erase".}
proc erase_unsorted*(self: ptr ImVector[ImFontConfig], it: ptr ImFontConfig): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_erase_unsorted".}
proc front*(self: ptr ImVector[ImFontConfig]): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_front".}
proc index_from_ptr*(self: ptr ImVector[ImFontConfig], it: ptr ImFontConfig): int32 {.importc: "ImVector_ImFontConfig_index_from_ptr".}
proc insert*(self: ptr ImVector[ImFontConfig], it: ptr ImFontConfig, v: ImFontConfig): ptr ImFontConfig {.importc: "ImVector_ImFontConfig_insert".}
proc pop_back*(self: ptr ImVector[ImFontConfig]): void {.importc: "ImVector_ImFontConfig_pop_back".}
proc push_back*(self: ptr ImVector[ImFontConfig], v: ImFontConfig): void {.importc: "ImVector_ImFontConfig_push_back".}
proc push_front*(self: ptr ImVector[ImFontConfig], v: ImFontConfig): void {.importc: "ImVector_ImFontConfig_push_front".}
proc reserve*(self: ptr ImVector[ImFontConfig], new_capacity: int32): void {.importc: "ImVector_ImFontConfig_reserve".}
proc resize*(self: ptr ImVector[ImFontConfig], new_size: int32): void {.importc: "ImVector_ImFontConfig_resize".}
proc resize*(self: ptr ImVector[ImFontConfig], new_size: int32, v: ImFontConfig): void {.importc: "ImVector_ImFontConfig_resize".}
proc size*(self: ptr ImVector[ImFontConfig]): int32 {.importc: "ImVector_ImFontConfig_size".}
proc size_in_bytes*(self: ptr ImVector[ImFontConfig]): int32 {.importc: "ImVector_ImFontConfig_size_in_bytes".}
proc swap*(self: ptr ImVector[ImFontConfig], rhs: ImVector[ImFontConfig]): void {.importc: "ImVector_ImFontConfig_swap".}
proc grow_capacity*(self: ptr ImVector[ImFontGlyph], sz: int32): int32 {.importc: "ImVector_ImFontGlyph__grow_capacity".}
proc back*(self: ptr ImVector[ImFontGlyph]): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_back".}
proc begin*(self: ptr ImVector[ImFontGlyph]): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_begin".}
proc capacity*(self: ptr ImVector[ImFontGlyph]): int32 {.importc: "ImVector_ImFontGlyph_capacity".}
proc clear*(self: ptr ImVector[ImFontGlyph]): void {.importc: "ImVector_ImFontGlyph_clear".}
proc destroy*(self: ptr ImVector[ImFontGlyph]): void {.importc: "ImVector_ImFontGlyph_destroy".}
proc empty*(self: ptr ImVector[ImFontGlyph]): bool {.importc: "ImVector_ImFontGlyph_empty".}
proc `end`*(self: ptr ImVector[ImFontGlyph]): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_end".}
proc erase*(self: ptr ImVector[ImFontGlyph], it: ptr ImFontGlyph): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_erase".}
proc erase*(self: ptr ImVector[ImFontGlyph], it: ptr ImFontGlyph, it_last: ptr ImFontGlyph): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_erase".}
proc erase_unsorted*(self: ptr ImVector[ImFontGlyph], it: ptr ImFontGlyph): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_erase_unsorted".}
proc front*(self: ptr ImVector[ImFontGlyph]): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_front".}
proc index_from_ptr*(self: ptr ImVector[ImFontGlyph], it: ptr ImFontGlyph): int32 {.importc: "ImVector_ImFontGlyph_index_from_ptr".}
proc insert*(self: ptr ImVector[ImFontGlyph], it: ptr ImFontGlyph, v: ImFontGlyph): ptr ImFontGlyph {.importc: "ImVector_ImFontGlyph_insert".}
proc pop_back*(self: ptr ImVector[ImFontGlyph]): void {.importc: "ImVector_ImFontGlyph_pop_back".}
proc push_back*(self: ptr ImVector[ImFontGlyph], v: ImFontGlyph): void {.importc: "ImVector_ImFontGlyph_push_back".}
proc push_front*(self: ptr ImVector[ImFontGlyph], v: ImFontGlyph): void {.importc: "ImVector_ImFontGlyph_push_front".}
proc reserve*(self: ptr ImVector[ImFontGlyph], new_capacity: int32): void {.importc: "ImVector_ImFontGlyph_reserve".}
proc resize*(self: ptr ImVector[ImFontGlyph], new_size: int32): void {.importc: "ImVector_ImFontGlyph_resize".}
proc resize*(self: ptr ImVector[ImFontGlyph], new_size: int32, v: ImFontGlyph): void {.importc: "ImVector_ImFontGlyph_resize".}
proc size*(self: ptr ImVector[ImFontGlyph]): int32 {.importc: "ImVector_ImFontGlyph_size".}
proc size_in_bytes*(self: ptr ImVector[ImFontGlyph]): int32 {.importc: "ImVector_ImFontGlyph_size_in_bytes".}
proc swap*(self: ptr ImVector[ImFontGlyph], rhs: ImVector[ImFontGlyph]): void {.importc: "ImVector_ImFontGlyph_swap".}
proc grow_capacity*(self: ptr ImVector[ptr ImFont], sz: int32): int32 {.importc: "ImVector_ImFontPtr__grow_capacity".}
proc back*(self: ptr ImVector[ptr ImFont]): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_back".}
proc begin*(self: ptr ImVector[ptr ImFont]): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_begin".}
proc capacity*(self: ptr ImVector[ptr ImFont]): int32 {.importc: "ImVector_ImFontPtr_capacity".}
proc clear*(self: ptr ImVector[ptr ImFont]): void {.importc: "ImVector_ImFontPtr_clear".}
proc destroy*(self: ptr ImVector[ptr ImFont]): void {.importc: "ImVector_ImFontPtr_destroy".}
proc empty*(self: ptr ImVector[ptr ImFont]): bool {.importc: "ImVector_ImFontPtr_empty".}
proc `end`*(self: ptr ImVector[ptr ImFont]): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_end".}
proc erase*(self: ptr ImVector[ptr ImFont], it: ptr ptr ImFont): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_erase".}
proc erase*(self: ptr ImVector[ptr ImFont], it: ptr ptr ImFont, it_last: ptr ptr ImFont): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_erase".}
proc erase_unsorted*(self: ptr ImVector[ptr ImFont], it: ptr ptr ImFont): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_erase_unsorted".}
proc front*(self: ptr ImVector[ptr ImFont]): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_front".}
proc index_from_ptr*(self: ptr ImVector[ptr ImFont], it: ptr ptr ImFont): int32 {.importc: "ImVector_ImFontPtr_index_from_ptr".}
proc insert*(self: ptr ImVector[ptr ImFont], it: ptr ptr ImFont, v: ptr ImFont): ptr ptr ImFont {.importc: "ImVector_ImFontPtr_insert".}
proc pop_back*(self: ptr ImVector[ptr ImFont]): void {.importc: "ImVector_ImFontPtr_pop_back".}
proc push_back*(self: ptr ImVector[ptr ImFont], v: ptr ImFont): void {.importc: "ImVector_ImFontPtr_push_back".}
proc push_front*(self: ptr ImVector[ptr ImFont], v: ptr ImFont): void {.importc: "ImVector_ImFontPtr_push_front".}
proc reserve*(self: ptr ImVector[ptr ImFont], new_capacity: int32): void {.importc: "ImVector_ImFontPtr_reserve".}
proc resize*(self: ptr ImVector[ptr ImFont], new_size: int32): void {.importc: "ImVector_ImFontPtr_resize".}
proc resize*(self: ptr ImVector[ptr ImFont], new_size: int32, v: ptr ImFont): void {.importc: "ImVector_ImFontPtr_resize".}
proc size*(self: ptr ImVector[ptr ImFont]): int32 {.importc: "ImVector_ImFontPtr_size".}
proc size_in_bytes*(self: ptr ImVector[ptr ImFont]): int32 {.importc: "ImVector_ImFontPtr_size_in_bytes".}
proc swap*(self: ptr ImVector[ptr ImFont], rhs: ImVector[ptr ImFont]): void {.importc: "ImVector_ImFontPtr_swap".}
proc grow_capacity*(self: ptr ImVector[ImTextureID], sz: int32): int32 {.importc: "ImVector_ImTextureID__grow_capacity".}
proc back*(self: ptr ImVector[ImTextureID]): ptr ImTextureID {.importc: "ImVector_ImTextureID_back".}
proc begin*(self: ptr ImVector[ImTextureID]): ptr ImTextureID {.importc: "ImVector_ImTextureID_begin".}
proc capacity*(self: ptr ImVector[ImTextureID]): int32 {.importc: "ImVector_ImTextureID_capacity".}
proc clear*(self: ptr ImVector[ImTextureID]): void {.importc: "ImVector_ImTextureID_clear".}
proc destroy*(self: ptr ImVector[ImTextureID]): void {.importc: "ImVector_ImTextureID_destroy".}
proc empty*(self: ptr ImVector[ImTextureID]): bool {.importc: "ImVector_ImTextureID_empty".}
proc `end`*(self: ptr ImVector[ImTextureID]): ptr ImTextureID {.importc: "ImVector_ImTextureID_end".}
proc erase*(self: ptr ImVector[ImTextureID], it: ptr ImTextureID): ptr ImTextureID {.importc: "ImVector_ImTextureID_erase".}
proc erase*(self: ptr ImVector[ImTextureID], it: ptr ImTextureID, it_last: ptr ImTextureID): ptr ImTextureID {.importc: "ImVector_ImTextureID_erase".}
proc erase_unsorted*(self: ptr ImVector[ImTextureID], it: ptr ImTextureID): ptr ImTextureID {.importc: "ImVector_ImTextureID_erase_unsorted".}
proc front*(self: ptr ImVector[ImTextureID]): ptr ImTextureID {.importc: "ImVector_ImTextureID_front".}
proc index_from_ptr*(self: ptr ImVector[ImTextureID], it: ptr ImTextureID): int32 {.importc: "ImVector_ImTextureID_index_from_ptr".}
proc insert*(self: ptr ImVector[ImTextureID], it: ptr ImTextureID, v: ImTextureID): ptr ImTextureID {.importc: "ImVector_ImTextureID_insert".}
proc pop_back*(self: ptr ImVector[ImTextureID]): void {.importc: "ImVector_ImTextureID_pop_back".}
proc push_back*(self: ptr ImVector[ImTextureID], v: ImTextureID): void {.importc: "ImVector_ImTextureID_push_back".}
proc push_front*(self: ptr ImVector[ImTextureID], v: ImTextureID): void {.importc: "ImVector_ImTextureID_push_front".}
proc reserve*(self: ptr ImVector[ImTextureID], new_capacity: int32): void {.importc: "ImVector_ImTextureID_reserve".}
proc resize*(self: ptr ImVector[ImTextureID], new_size: int32): void {.importc: "ImVector_ImTextureID_resize".}
proc resize*(self: ptr ImVector[ImTextureID], new_size: int32, v: ImTextureID): void {.importc: "ImVector_ImTextureID_resize".}
proc size*(self: ptr ImVector[ImTextureID]): int32 {.importc: "ImVector_ImTextureID_size".}
proc size_in_bytes*(self: ptr ImVector[ImTextureID]): int32 {.importc: "ImVector_ImTextureID_size_in_bytes".}
proc swap*(self: ptr ImVector[ImTextureID], rhs: ImVector[ImTextureID]): void {.importc: "ImVector_ImTextureID_swap".}
proc grow_capacity*(self: ptr ImVector[uint32], sz: int32): int32 {.importc: "ImVector_ImU32__grow_capacity".}
proc back*(self: ptr ImVector[uint32]): ptr uint32 {.importc: "ImVector_ImU32_back".}
proc begin*(self: ptr ImVector[uint32]): ptr uint32 {.importc: "ImVector_ImU32_begin".}
proc capacity*(self: ptr ImVector[uint32]): int32 {.importc: "ImVector_ImU32_capacity".}
proc clear*(self: ptr ImVector[uint32]): void {.importc: "ImVector_ImU32_clear".}
proc destroy*(self: ptr ImVector[uint32]): void {.importc: "ImVector_ImU32_destroy".}
proc empty*(self: ptr ImVector[uint32]): bool {.importc: "ImVector_ImU32_empty".}
proc `end`*(self: ptr ImVector[uint32]): ptr uint32 {.importc: "ImVector_ImU32_end".}
proc erase*(self: ptr ImVector[uint32], it: ptr uint32): ptr uint32 {.importc: "ImVector_ImU32_erase".}
proc erase*(self: ptr ImVector[uint32], it: ptr uint32, it_last: ptr uint32): ptr uint32 {.importc: "ImVector_ImU32_erase".}
proc erase_unsorted*(self: ptr ImVector[uint32], it: ptr uint32): ptr uint32 {.importc: "ImVector_ImU32_erase_unsorted".}
proc front*(self: ptr ImVector[uint32]): ptr uint32 {.importc: "ImVector_ImU32_front".}
proc index_from_ptr*(self: ptr ImVector[uint32], it: ptr uint32): int32 {.importc: "ImVector_ImU32_index_from_ptr".}
proc insert*(self: ptr ImVector[uint32], it: ptr uint32, v: uint32): ptr uint32 {.importc: "ImVector_ImU32_insert".}
proc pop_back*(self: ptr ImVector[uint32]): void {.importc: "ImVector_ImU32_pop_back".}
proc push_back*(self: ptr ImVector[uint32], v: uint32): void {.importc: "ImVector_ImU32_push_back".}
proc push_front*(self: ptr ImVector[uint32], v: uint32): void {.importc: "ImVector_ImU32_push_front".}
proc reserve*(self: ptr ImVector[uint32], new_capacity: int32): void {.importc: "ImVector_ImU32_reserve".}
proc resize*(self: ptr ImVector[uint32], new_size: int32): void {.importc: "ImVector_ImU32_resize".}
proc resize*(self: ptr ImVector[uint32], new_size: int32, v: uint32): void {.importc: "ImVector_ImU32_resize".}
proc size*(self: ptr ImVector[uint32]): int32 {.importc: "ImVector_ImU32_size".}
proc size_in_bytes*(self: ptr ImVector[uint32]): int32 {.importc: "ImVector_ImU32_size_in_bytes".}
proc swap*(self: ptr ImVector[uint32], rhs: ImVector[uint32]): void {.importc: "ImVector_ImU32_swap".}
proc grow_capacity*(self: ptr ImVector[ImVec2], sz: int32): int32 {.importc: "ImVector_ImVec2__grow_capacity".}
proc back*(self: ptr ImVector[ImVec2]): ptr ImVec2 {.importc: "ImVector_ImVec2_back".}
proc begin*(self: ptr ImVector[ImVec2]): ptr ImVec2 {.importc: "ImVector_ImVec2_begin".}
proc capacity*(self: ptr ImVector[ImVec2]): int32 {.importc: "ImVector_ImVec2_capacity".}
proc clear*(self: ptr ImVector[ImVec2]): void {.importc: "ImVector_ImVec2_clear".}
proc destroy*(self: ptr ImVector[ImVec2]): void {.importc: "ImVector_ImVec2_destroy".}
proc empty*(self: ptr ImVector[ImVec2]): bool {.importc: "ImVector_ImVec2_empty".}
proc `end`*(self: ptr ImVector[ImVec2]): ptr ImVec2 {.importc: "ImVector_ImVec2_end".}
proc erase*(self: ptr ImVector[ImVec2], it: ptr ImVec2): ptr ImVec2 {.importc: "ImVector_ImVec2_erase".}
proc erase*(self: ptr ImVector[ImVec2], it: ptr ImVec2, it_last: ptr ImVec2): ptr ImVec2 {.importc: "ImVector_ImVec2_erase".}
proc erase_unsorted*(self: ptr ImVector[ImVec2], it: ptr ImVec2): ptr ImVec2 {.importc: "ImVector_ImVec2_erase_unsorted".}
proc front*(self: ptr ImVector[ImVec2]): ptr ImVec2 {.importc: "ImVector_ImVec2_front".}
proc index_from_ptr*(self: ptr ImVector[ImVec2], it: ptr ImVec2): int32 {.importc: "ImVector_ImVec2_index_from_ptr".}
proc insert*(self: ptr ImVector[ImVec2], it: ptr ImVec2, v: ImVec2): ptr ImVec2 {.importc: "ImVector_ImVec2_insert".}
proc pop_back*(self: ptr ImVector[ImVec2]): void {.importc: "ImVector_ImVec2_pop_back".}
proc push_back*(self: ptr ImVector[ImVec2], v: ImVec2): void {.importc: "ImVector_ImVec2_push_back".}
proc push_front*(self: ptr ImVector[ImVec2], v: ImVec2): void {.importc: "ImVector_ImVec2_push_front".}
proc reserve*(self: ptr ImVector[ImVec2], new_capacity: int32): void {.importc: "ImVector_ImVec2_reserve".}
proc resize*(self: ptr ImVector[ImVec2], new_size: int32): void {.importc: "ImVector_ImVec2_resize".}
proc resize*(self: ptr ImVector[ImVec2], new_size: int32, v: ImVec2): void {.importc: "ImVector_ImVec2_resize".}
proc size*(self: ptr ImVector[ImVec2]): int32 {.importc: "ImVector_ImVec2_size".}
proc size_in_bytes*(self: ptr ImVector[ImVec2]): int32 {.importc: "ImVector_ImVec2_size_in_bytes".}
proc swap*(self: ptr ImVector[ImVec2], rhs: ImVector[ImVec2]): void {.importc: "ImVector_ImVec2_swap".}
proc grow_capacity*(self: ptr ImVector[ImVec4], sz: int32): int32 {.importc: "ImVector_ImVec4__grow_capacity".}
proc back*(self: ptr ImVector[ImVec4]): ptr ImVec4 {.importc: "ImVector_ImVec4_back".}
proc begin*(self: ptr ImVector[ImVec4]): ptr ImVec4 {.importc: "ImVector_ImVec4_begin".}
proc capacity*(self: ptr ImVector[ImVec4]): int32 {.importc: "ImVector_ImVec4_capacity".}
proc clear*(self: ptr ImVector[ImVec4]): void {.importc: "ImVector_ImVec4_clear".}
proc destroy*(self: ptr ImVector[ImVec4]): void {.importc: "ImVector_ImVec4_destroy".}
proc empty*(self: ptr ImVector[ImVec4]): bool {.importc: "ImVector_ImVec4_empty".}
proc `end`*(self: ptr ImVector[ImVec4]): ptr ImVec4 {.importc: "ImVector_ImVec4_end".}
proc erase*(self: ptr ImVector[ImVec4], it: ptr ImVec4): ptr ImVec4 {.importc: "ImVector_ImVec4_erase".}
proc erase*(self: ptr ImVector[ImVec4], it: ptr ImVec4, it_last: ptr ImVec4): ptr ImVec4 {.importc: "ImVector_ImVec4_erase".}
proc erase_unsorted*(self: ptr ImVector[ImVec4], it: ptr ImVec4): ptr ImVec4 {.importc: "ImVector_ImVec4_erase_unsorted".}
proc front*(self: ptr ImVector[ImVec4]): ptr ImVec4 {.importc: "ImVector_ImVec4_front".}
proc index_from_ptr*(self: ptr ImVector[ImVec4], it: ptr ImVec4): int32 {.importc: "ImVector_ImVec4_index_from_ptr".}
proc insert*(self: ptr ImVector[ImVec4], it: ptr ImVec4, v: ImVec4): ptr ImVec4 {.importc: "ImVector_ImVec4_insert".}
proc pop_back*(self: ptr ImVector[ImVec4]): void {.importc: "ImVector_ImVec4_pop_back".}
proc push_back*(self: ptr ImVector[ImVec4], v: ImVec4): void {.importc: "ImVector_ImVec4_push_back".}
proc push_front*(self: ptr ImVector[ImVec4], v: ImVec4): void {.importc: "ImVector_ImVec4_push_front".}
proc reserve*(self: ptr ImVector[ImVec4], new_capacity: int32): void {.importc: "ImVector_ImVec4_reserve".}
proc resize*(self: ptr ImVector[ImVec4], new_size: int32): void {.importc: "ImVector_ImVec4_resize".}
proc resize*(self: ptr ImVector[ImVec4], new_size: int32, v: ImVec4): void {.importc: "ImVector_ImVec4_resize".}
proc size*(self: ptr ImVector[ImVec4]): int32 {.importc: "ImVector_ImVec4_size".}
proc size_in_bytes*(self: ptr ImVector[ImVec4]): int32 {.importc: "ImVector_ImVec4_size_in_bytes".}
proc swap*(self: ptr ImVector[ImVec4], rhs: ImVector[ImVec4]): void {.importc: "ImVector_ImVec4_swap".}
proc grow_capacity*(self: ptr ImVector[ImPair], sz: int32): int32 {.importc: "ImVector_Pair__grow_capacity".}
proc back*(self: ptr ImVector[ImPair]): ptr ImPair {.importc: "ImVector_Pair_back".}
proc begin*(self: ptr ImVector[ImPair]): ptr ImPair {.importc: "ImVector_Pair_begin".}
proc capacity*(self: ptr ImVector[ImPair]): int32 {.importc: "ImVector_Pair_capacity".}
proc clear*(self: ptr ImVector[ImPair]): void {.importc: "ImVector_Pair_clear".}
proc destroy*(self: ptr ImVector[ImPair]): void {.importc: "ImVector_Pair_destroy".}
proc empty*(self: ptr ImVector[ImPair]): bool {.importc: "ImVector_Pair_empty".}
proc `end`*(self: ptr ImVector[ImPair]): ptr ImPair {.importc: "ImVector_Pair_end".}
proc erase*(self: ptr ImVector[ImPair], it: ptr ImPair): ptr ImPair {.importc: "ImVector_Pair_erase".}
proc erase*(self: ptr ImVector[ImPair], it: ptr ImPair, it_last: ptr ImPair): ptr ImPair {.importc: "ImVector_Pair_erase".}
proc erase_unsorted*(self: ptr ImVector[ImPair], it: ptr ImPair): ptr ImPair {.importc: "ImVector_Pair_erase_unsorted".}
proc front*(self: ptr ImVector[ImPair]): ptr ImPair {.importc: "ImVector_Pair_front".}
proc index_from_ptr*(self: ptr ImVector[ImPair], it: ptr ImPair): int32 {.importc: "ImVector_Pair_index_from_ptr".}
proc insert*(self: ptr ImVector[ImPair], it: ptr ImPair, v: ImPair): ptr ImPair {.importc: "ImVector_Pair_insert".}
proc pop_back*(self: ptr ImVector[ImPair]): void {.importc: "ImVector_Pair_pop_back".}
proc push_back*(self: ptr ImVector[ImPair], v: ImPair): void {.importc: "ImVector_Pair_push_back".}
proc push_front*(self: ptr ImVector[ImPair], v: ImPair): void {.importc: "ImVector_Pair_push_front".}
proc reserve*(self: ptr ImVector[ImPair], new_capacity: int32): void {.importc: "ImVector_Pair_reserve".}
proc resize*(self: ptr ImVector[ImPair], new_size: int32): void {.importc: "ImVector_Pair_resize".}
proc resize*(self: ptr ImVector[ImPair], new_size: int32, v: ImPair): void {.importc: "ImVector_Pair_resize".}
proc size*(self: ptr ImVector[ImPair]): int32 {.importc: "ImVector_Pair_size".}
proc size_in_bytes*(self: ptr ImVector[ImPair]): int32 {.importc: "ImVector_Pair_size_in_bytes".}
proc swap*(self: ptr ImVector[ImPair], rhs: ImVector[ImPair]): void {.importc: "ImVector_Pair_swap".}
proc grow_capacity*(self: ptr ImVector[TextRange], sz: int32): int32 {.importc: "ImVector_TextRange__grow_capacity".}
proc back*(self: ptr ImVector[TextRange]): ptr TextRange {.importc: "ImVector_TextRange_back".}
proc begin*(self: ptr ImVector[TextRange]): ptr TextRange {.importc: "ImVector_TextRange_begin".}
proc capacity*(self: ptr ImVector[TextRange]): int32 {.importc: "ImVector_TextRange_capacity".}
proc clear*(self: ptr ImVector[TextRange]): void {.importc: "ImVector_TextRange_clear".}
proc destroy*(self: ptr ImVector[TextRange]): void {.importc: "ImVector_TextRange_destroy".}
proc empty*(self: ptr ImVector[TextRange]): bool {.importc: "ImVector_TextRange_empty".}
proc `end`*(self: ptr ImVector[TextRange]): ptr TextRange {.importc: "ImVector_TextRange_end".}
proc erase*(self: ptr ImVector[TextRange], it: ptr TextRange): ptr TextRange {.importc: "ImVector_TextRange_erase".}
proc erase*(self: ptr ImVector[TextRange], it: ptr TextRange, it_last: ptr TextRange): ptr TextRange {.importc: "ImVector_TextRange_erase".}
proc erase_unsorted*(self: ptr ImVector[TextRange], it: ptr TextRange): ptr TextRange {.importc: "ImVector_TextRange_erase_unsorted".}
proc front*(self: ptr ImVector[TextRange]): ptr TextRange {.importc: "ImVector_TextRange_front".}
proc index_from_ptr*(self: ptr ImVector[TextRange], it: ptr TextRange): int32 {.importc: "ImVector_TextRange_index_from_ptr".}
proc insert*(self: ptr ImVector[TextRange], it: ptr TextRange, v: TextRange): ptr TextRange {.importc: "ImVector_TextRange_insert".}
proc pop_back*(self: ptr ImVector[TextRange]): void {.importc: "ImVector_TextRange_pop_back".}
proc push_back*(self: ptr ImVector[TextRange], v: TextRange): void {.importc: "ImVector_TextRange_push_back".}
proc push_front*(self: ptr ImVector[TextRange], v: TextRange): void {.importc: "ImVector_TextRange_push_front".}
proc reserve*(self: ptr ImVector[TextRange], new_capacity: int32): void {.importc: "ImVector_TextRange_reserve".}
proc resize*(self: ptr ImVector[TextRange], new_size: int32): void {.importc: "ImVector_TextRange_resize".}
proc resize*(self: ptr ImVector[TextRange], new_size: int32, v: TextRange): void {.importc: "ImVector_TextRange_resize".}
proc size*(self: ptr ImVector[TextRange]): int32 {.importc: "ImVector_TextRange_size".}
proc size_in_bytes*(self: ptr ImVector[TextRange]): int32 {.importc: "ImVector_TextRange_size_in_bytes".}
proc swap*(self: ptr ImVector[TextRange], rhs: ImVector[TextRange]): void {.importc: "ImVector_TextRange_swap".}
proc grow_capacity*(self: ptr ImVector, sz: int32): int32 {.importc: "ImVector__grow_capacity".}
proc capacity*(self: ptr ImVector): int32 {.importc: "ImVector_capacity".}
proc grow_capacity*(self: ptr ImVector[int8], sz: int32): int32 {.importc: "ImVector_char__grow_capacity".}
proc back*(self: ptr ImVector[int8]): ptr int8 {.importc: "ImVector_char_back".}
proc begin*(self: ptr ImVector[int8]): ptr int8 {.importc: "ImVector_char_begin".}
proc capacity*(self: ptr ImVector[int8]): int32 {.importc: "ImVector_char_capacity".}
proc clear*(self: ptr ImVector[int8]): void {.importc: "ImVector_char_clear".}
proc contains*(self: ptr ImVector[int8], v: int8): bool {.importc: "ImVector_char_contains".}
proc destroy*(self: ptr ImVector[int8]): void {.importc: "ImVector_char_destroy".}
proc empty*(self: ptr ImVector[int8]): bool {.importc: "ImVector_char_empty".}
proc `end`*(self: ptr ImVector[int8]): ptr int8 {.importc: "ImVector_char_end".}
proc erase*(self: ptr ImVector[int8], it: ptr int8): ptr int8 {.importc: "ImVector_char_erase".}
proc erase*(self: ptr ImVector[int8], it: ptr int8, it_last: ptr int8): ptr int8 {.importc: "ImVector_char_erase".}
proc erase_unsorted*(self: ptr ImVector[int8], it: ptr int8): ptr int8 {.importc: "ImVector_char_erase_unsorted".}
proc front*(self: ptr ImVector[int8]): ptr int8 {.importc: "ImVector_char_front".}
proc index_from_ptr*(self: ptr ImVector[int8], it: ptr int8): int32 {.importc: "ImVector_char_index_from_ptr".}
proc insert*(self: ptr ImVector[int8], it: ptr int8, v: int8): ptr int8 {.importc: "ImVector_char_insert".}
proc pop_back*(self: ptr ImVector[int8]): void {.importc: "ImVector_char_pop_back".}
proc push_back*(self: ptr ImVector[int8], v: int8): void {.importc: "ImVector_char_push_back".}
proc push_front*(self: ptr ImVector[int8], v: int8): void {.importc: "ImVector_char_push_front".}
proc reserve*(self: ptr ImVector[int8], new_capacity: int32): void {.importc: "ImVector_char_reserve".}
proc resize*(self: ptr ImVector[int8], new_size: int32): void {.importc: "ImVector_char_resize".}
proc resize*(self: ptr ImVector[int8], new_size: int32, v: int8): void {.importc: "ImVector_char_resize".}
proc size*(self: ptr ImVector[int8]): int32 {.importc: "ImVector_char_size".}
proc size_in_bytes*(self: ptr ImVector[int8]): int32 {.importc: "ImVector_char_size_in_bytes".}
proc swap*(self: ptr ImVector[int8], rhs: ImVector[int8]): void {.importc: "ImVector_char_swap".}
proc clear*(self: ptr ImVector): void {.importc: "ImVector_clear".}
proc destroy*(self: ptr ImVector): void {.importc: "ImVector_destroy".}
proc empty*(self: ptr ImVector): bool {.importc: "ImVector_empty".}
proc `end`*(self: ptr ImVector): ptr T {.importc: "ImVector_end".}
proc erase*(self: ptr ImVector, it: ptr T): ptr T {.importc: "ImVector_erase".}
proc erase*(self: ptr ImVector, it: ptr T, it_last: ptr T): ptr T {.importc: "ImVector_erase".}
proc erase_unsorted*(self: ptr ImVector, it: ptr T): ptr T {.importc: "ImVector_erase_unsorted".}
proc grow_capacity*(self: ptr ImVector[float32], sz: int32): int32 {.importc: "ImVector_float__grow_capacity".}
proc back*(self: ptr ImVector[float32]): ptr float32 {.importc: "ImVector_float_back".}
proc begin*(self: ptr ImVector[float32]): ptr float32 {.importc: "ImVector_float_begin".}
proc capacity*(self: ptr ImVector[float32]): int32 {.importc: "ImVector_float_capacity".}
proc clear*(self: ptr ImVector[float32]): void {.importc: "ImVector_float_clear".}
proc contains*(self: ptr ImVector[float32], v: float32): bool {.importc: "ImVector_float_contains".}
proc destroy*(self: ptr ImVector[float32]): void {.importc: "ImVector_float_destroy".}
proc empty*(self: ptr ImVector[float32]): bool {.importc: "ImVector_float_empty".}
proc `end`*(self: ptr ImVector[float32]): ptr float32 {.importc: "ImVector_float_end".}
proc erase*(self: ptr ImVector[float32], it: ptr float32): ptr float32 {.importc: "ImVector_float_erase".}
proc erase*(self: ptr ImVector[float32], it: ptr float32, it_last: ptr float32): ptr float32 {.importc: "ImVector_float_erase".}
proc erase_unsorted*(self: ptr ImVector[float32], it: ptr float32): ptr float32 {.importc: "ImVector_float_erase_unsorted".}
proc front*(self: ptr ImVector[float32]): ptr float32 {.importc: "ImVector_float_front".}
proc index_from_ptr*(self: ptr ImVector[float32], it: ptr float32): int32 {.importc: "ImVector_float_index_from_ptr".}
proc insert*(self: ptr ImVector[float32], it: ptr float32, v: float32): ptr float32 {.importc: "ImVector_float_insert".}
proc pop_back*(self: ptr ImVector[float32]): void {.importc: "ImVector_float_pop_back".}
proc push_back*(self: ptr ImVector[float32], v: float32): void {.importc: "ImVector_float_push_back".}
proc push_front*(self: ptr ImVector[float32], v: float32): void {.importc: "ImVector_float_push_front".}
proc reserve*(self: ptr ImVector[float32], new_capacity: int32): void {.importc: "ImVector_float_reserve".}
proc resize*(self: ptr ImVector[float32], new_size: int32): void {.importc: "ImVector_float_resize".}
proc resize*(self: ptr ImVector[float32], new_size: int32, v: float32): void {.importc: "ImVector_float_resize".}
proc size*(self: ptr ImVector[float32]): int32 {.importc: "ImVector_float_size".}
proc size_in_bytes*(self: ptr ImVector[float32]): int32 {.importc: "ImVector_float_size_in_bytes".}
proc swap*(self: ptr ImVector[float32], rhs: ImVector[float32]): void {.importc: "ImVector_float_swap".}
proc front*(self: ptr ImVector): ptr T {.importc: "ImVector_front".}
proc index_from_ptr*(self: ptr ImVector, it: ptr T): int32 {.importc: "ImVector_index_from_ptr".}
proc insert*(self: ptr ImVector, it: ptr T, v: T): ptr T {.importc: "ImVector_insert".}
proc pop_back*(self: ptr ImVector): void {.importc: "ImVector_pop_back".}
proc push_back*(self: ptr ImVector, v: T): void {.importc: "ImVector_push_back".}
proc push_front*(self: ptr ImVector, v: T): void {.importc: "ImVector_push_front".}
proc reserve*(self: ptr ImVector, new_capacity: int32): void {.importc: "ImVector_reserve".}
proc resize*(self: ptr ImVector, new_size: int32): void {.importc: "ImVector_resize".}
proc resize*(self: ptr ImVector, new_size: int32, v: T): void {.importc: "ImVector_resize".}
proc size*(self: ptr ImVector): int32 {.importc: "ImVector_size".}
proc size_in_bytes*(self: ptr ImVector): int32 {.importc: "ImVector_size_in_bytes".}
proc swap*(self: ptr ImVector, rhs: ImVector): void {.importc: "ImVector_swap".}
proc newPair*(key: ImGuiID, val_i: int32): void {.importc: "Pair_Pair".}
proc newPair*(key: ImGuiID, val_f: float32): void {.importc: "Pair_Pair".}
proc newPair*(key: ImGuiID, val_p: pointer): void {.importc: "Pair_Pair".}
proc destroy*(self: ptr ImPair): void {.importc: "Pair_destroy".}
proc newTextRange*(): void {.importc: "TextRange_TextRange".}
proc newTextRange*(b: ptr int8, e: ptr int8): void {.importc: "TextRange_TextRange".}
proc begin*(self: ptr TextRange): ptr int8 {.importc: "TextRange_begin".}
proc destroy*(self: ptr TextRange): void {.importc: "TextRange_destroy".}
proc empty*(self: ptr TextRange): bool {.importc: "TextRange_empty".}
proc `end`*(self: ptr TextRange): ptr int8 {.importc: "TextRange_end".}
proc split*(self: ptr TextRange, separator: int8, `out`: ptr ImVector[TextRange]): void {.importc: "TextRange_split".}
proc igAcceptDragDropPayload*(`type`: ptr int8, flags: ImGuiDragDropFlags): ptr ImGuiPayload {.importc: "igAcceptDragDropPayload".}
proc igAlignTextToFramePadding*(): void {.importc: "igAlignTextToFramePadding".}
proc igArrowButton*(str_id: ptr int8, dir: ImGuiDir): bool {.importc: "igArrowButton".}
proc igBegin*(name: ptr int8, p_open: ptr bool, flags: ImGuiWindowFlags): bool {.importc: "igBegin".}
proc igBeginChild*(str_id: ptr int8, size: ImVec2, border: bool, flags: ImGuiWindowFlags): bool {.importc: "igBeginChild".}
proc igBeginChild*(id: ImGuiID, size: ImVec2, border: bool, flags: ImGuiWindowFlags): bool {.importc: "igBeginChild".}
proc igBeginChildFrame*(id: ImGuiID, size: ImVec2, flags: ImGuiWindowFlags): bool {.importc: "igBeginChildFrame".}
proc igBeginCombo*(label: ptr int8, preview_value: ptr int8, flags: ImGuiComboFlags): bool {.importc: "igBeginCombo".}
proc igBeginDragDropSource*(flags: ImGuiDragDropFlags): bool {.importc: "igBeginDragDropSource".}
proc igBeginDragDropTarget*(): bool {.importc: "igBeginDragDropTarget".}
proc igBeginGroup*(): void {.importc: "igBeginGroup".}
proc igBeginMainMenuBar*(): bool {.importc: "igBeginMainMenuBar".}
proc igBeginMenu*(label: ptr int8, enabled: bool): bool {.importc: "igBeginMenu".}
proc igBeginMenuBar*(): bool {.importc: "igBeginMenuBar".}
proc igBeginPopup*(str_id: ptr int8, flags: ImGuiWindowFlags): bool {.importc: "igBeginPopup".}
proc igBeginPopupContextItem*(str_id: ptr int8, mouse_button: int32): bool {.importc: "igBeginPopupContextItem".}
proc igBeginPopupContextVoid*(str_id: ptr int8, mouse_button: int32): bool {.importc: "igBeginPopupContextVoid".}
proc igBeginPopupContextWindow*(str_id: ptr int8, mouse_button: int32, also_over_items: bool): bool {.importc: "igBeginPopupContextWindow".}
proc igBeginPopupModal*(name: ptr int8, p_open: ptr bool, flags: ImGuiWindowFlags): bool {.importc: "igBeginPopupModal".}
proc igBeginTabBar*(str_id: ptr int8, flags: ImGuiTabBarFlags): bool {.importc: "igBeginTabBar".}
proc igBeginTabItem*(label: ptr int8, p_open: ptr bool, flags: ImGuiTabItemFlags): bool {.importc: "igBeginTabItem".}
proc igBeginTooltip*(): void {.importc: "igBeginTooltip".}
proc igBullet*(): void {.importc: "igBullet".}
proc igBulletText*(fmt: ptr int8): void {.importc: "igBulletText", varargs.}
proc igBulletTextV*(fmt: ptr int8): void {.importc: "igBulletTextV", varargs.}
proc igButton*(label: ptr int8, size: ImVec2): bool {.importc: "igButton".}
proc igCalcItemWidth*(): float32 {.importc: "igCalcItemWidth".}
proc igCalcListClipping*(items_count: int32, items_height: float32, out_items_display_start: ptr int32, out_items_display_end: ptr int32): void {.importc: "igCalcListClipping".}
proc igCalcTextSize*(text: ptr int8, text_end: ptr int8, hide_text_after_double_hash: bool, wrap_width: float32): ImVec2 {.importc: "igCalcTextSize".}
proc igCaptureKeyboardFromApp*(want_capture_keyboard_value: bool): void {.importc: "igCaptureKeyboardFromApp".}
proc igCaptureMouseFromApp*(want_capture_mouse_value: bool): void {.importc: "igCaptureMouseFromApp".}
proc igCheckbox*(label: ptr int8, v: ptr bool): bool {.importc: "igCheckbox".}
proc igCheckboxFlags*(label: ptr int8, flags: ptr uint32, flags_value: uint32): bool {.importc: "igCheckboxFlags".}
proc igCloseCurrentPopup*(): void {.importc: "igCloseCurrentPopup".}
proc igCollapsingHeader*(label: ptr int8, flags: ImGuiTreeNodeFlags): bool {.importc: "igCollapsingHeader".}
proc igCollapsingHeader*(label: ptr int8, p_open: ptr bool, flags: ImGuiTreeNodeFlags): bool {.importc: "igCollapsingHeader".}
proc igColorButton*(desc_id: ptr int8, col: ImVec4, flags: ImGuiColorEditFlags, size: ImVec2): bool {.importc: "igColorButton".}
proc igColorConvertFloat4ToU32*(in: ImVec4): uint32 {.importc: "igColorConvertFloat4ToU32".}
proc igColorConvertHSVtoRGB*(h: float32, s: float32, v: float32, out_r: float32, out_g: float32, out_b: float32): void {.importc: "igColorConvertHSVtoRGB".}
proc igColorConvertRGBtoHSV*(r: float32, g: float32, b: float32, out_h: float32, out_s: float32, out_v: float32): void {.importc: "igColorConvertRGBtoHSV".}
proc igColorConvertU32ToFloat4*(in: uint32): ImVec4 {.importc: "igColorConvertU32ToFloat4".}
proc igColorEdit3*(label: ptr int8, col: array[3, float32], flags: ImGuiColorEditFlags): bool {.importc: "igColorEdit3".}
proc igColorEdit4*(label: ptr int8, col: array[4, float32], flags: ImGuiColorEditFlags): bool {.importc: "igColorEdit4".}
proc igColorPicker3*(label: ptr int8, col: array[3, float32], flags: ImGuiColorEditFlags): bool {.importc: "igColorPicker3".}
proc igColorPicker4*(label: ptr int8, col: array[4, float32], flags: ImGuiColorEditFlags, ref_col: ptr float32): bool {.importc: "igColorPicker4".}
proc igColumns*(count: int32, id: ptr int8, border: bool): void {.importc: "igColumns".}
proc igCombo*(label: ptr int8, current_item: ptr int32, items: array[, ptr int8const], items_count: int32, popup_max_height_in_items: int32): bool {.importc: "igCombo".}
proc igCombo*(label: ptr int8, current_item: ptr int32, items_separated_by_zeros: ptr int8, popup_max_height_in_items: int32): bool {.importc: "igCombo".}
proc igCombo*(label: ptr int8, current_item: ptr int32, items_getter: int32, data: pointer, items_count: int32, popup_max_height_in_items: int32): bool {.importc: "igCombo".}
proc igCreateContext*(shared_font_atlas: ptr ImFontAtlas): ptr ImGuiContext {.importc: "igCreateContext".}
proc igDebugCheckVersionAndDataLayout*(version_str: ptr int8, sz_io: size_t, sz_style: size_t, sz_vec2: size_t, sz_vec4: size_t, sz_drawvert: size_t, sz_drawidx: size_t): bool {.importc: "igDebugCheckVersionAndDataLayout".}
proc igDestroyContext*(ctx: ptr ImGuiContext): void {.importc: "igDestroyContext".}
proc igDragFloat*(label: ptr int8, v: ptr float32, v_speed: float32, v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igDragFloat".}
proc igDragFloat2*(label: ptr int8, v: array[2, float32], v_speed: float32, v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igDragFloat2".}
proc igDragFloat3*(label: ptr int8, v: array[3, float32], v_speed: float32, v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igDragFloat3".}
proc igDragFloat4*(label: ptr int8, v: array[4, float32], v_speed: float32, v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igDragFloat4".}
proc igDragFloatRange2*(label: ptr int8, v_current_min: ptr float32, v_current_max: ptr float32, v_speed: float32, v_min: float32, v_max: float32, format: ptr int8, format_max: ptr int8, power: float32): bool {.importc: "igDragFloatRange2".}
proc igDragInt*(label: ptr int8, v: ptr int32, v_speed: float32, v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igDragInt".}
proc igDragInt2*(label: ptr int8, v: array[2, int32], v_speed: float32, v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igDragInt2".}
proc igDragInt3*(label: ptr int8, v: array[3, int32], v_speed: float32, v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igDragInt3".}
proc igDragInt4*(label: ptr int8, v: array[4, int32], v_speed: float32, v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igDragInt4".}
proc igDragIntRange2*(label: ptr int8, v_current_min: ptr int32, v_current_max: ptr int32, v_speed: float32, v_min: int32, v_max: int32, format: ptr int8, format_max: ptr int8): bool {.importc: "igDragIntRange2".}
proc igDragScalar*(label: ptr int8, data_type: ImGuiDataType, v: pointer, v_speed: float32, v_min: pointer, v_max: pointer, format: ptr int8, power: float32): bool {.importc: "igDragScalar".}
proc igDragScalarN*(label: ptr int8, data_type: ImGuiDataType, v: pointer, components: int32, v_speed: float32, v_min: pointer, v_max: pointer, format: ptr int8, power: float32): bool {.importc: "igDragScalarN".}
proc igDummy*(size: ImVec2): void {.importc: "igDummy".}
proc igEnd*(): void {.importc: "igEnd".}
proc igEndChild*(): void {.importc: "igEndChild".}
proc igEndChildFrame*(): void {.importc: "igEndChildFrame".}
proc igEndCombo*(): void {.importc: "igEndCombo".}
proc igEndDragDropSource*(): void {.importc: "igEndDragDropSource".}
proc igEndDragDropTarget*(): void {.importc: "igEndDragDropTarget".}
proc igEndFrame*(): void {.importc: "igEndFrame".}
proc igEndGroup*(): void {.importc: "igEndGroup".}
proc igEndMainMenuBar*(): void {.importc: "igEndMainMenuBar".}
proc igEndMenu*(): void {.importc: "igEndMenu".}
proc igEndMenuBar*(): void {.importc: "igEndMenuBar".}
proc igEndPopup*(): void {.importc: "igEndPopup".}
proc igEndTabBar*(): void {.importc: "igEndTabBar".}
proc igEndTabItem*(): void {.importc: "igEndTabItem".}
proc igEndTooltip*(): void {.importc: "igEndTooltip".}
proc igGetBackgroundDrawList*(): ptr ImDrawList {.importc: "igGetBackgroundDrawList".}
proc igGetClipboardText*(): ptr int8 {.importc: "igGetClipboardText".}
proc igGetColorU32*(idx: ImGuiCol, alpha_mul: float32): uint32 {.importc: "igGetColorU32".}
proc igGetColorU32*(col: ImVec4): uint32 {.importc: "igGetColorU32".}
proc igGetColorU32*(col: uint32): uint32 {.importc: "igGetColorU32".}
proc igGetColumnIndex*(): int32 {.importc: "igGetColumnIndex".}
proc igGetColumnOffset*(column_index: int32): float32 {.importc: "igGetColumnOffset".}
proc igGetColumnWidth*(column_index: int32): float32 {.importc: "igGetColumnWidth".}
proc igGetColumnsCount*(): int32 {.importc: "igGetColumnsCount".}
proc igGetContentRegionAvail*(): ImVec2 {.importc: "igGetContentRegionAvail".}
proc igGetContentRegionMax*(): ImVec2 {.importc: "igGetContentRegionMax".}
proc igGetCurrentContext*(): ptr ImGuiContext {.importc: "igGetCurrentContext".}
proc igGetCursorPos*(): ImVec2 {.importc: "igGetCursorPos".}
proc igGetCursorPosX*(): float32 {.importc: "igGetCursorPosX".}
proc igGetCursorPosY*(): float32 {.importc: "igGetCursorPosY".}
proc igGetCursorScreenPos*(): ImVec2 {.importc: "igGetCursorScreenPos".}
proc igGetCursorStartPos*(): ImVec2 {.importc: "igGetCursorStartPos".}
proc igGetDragDropPayload*(): ptr ImGuiPayload {.importc: "igGetDragDropPayload".}
proc igGetDrawData*(): ptr ImDrawData {.importc: "igGetDrawData".}
proc igGetDrawListSharedData*(): ptr ImDrawListSharedData {.importc: "igGetDrawListSharedData".}
proc igGetFont*(): ptr ImFont {.importc: "igGetFont".}
proc igGetFontSize*(): float32 {.importc: "igGetFontSize".}
proc igGetFontTexUvWhitePixel*(): ImVec2 {.importc: "igGetFontTexUvWhitePixel".}
proc igGetForegroundDrawList*(): ptr ImDrawList {.importc: "igGetForegroundDrawList".}
proc igGetFrameCount*(): int32 {.importc: "igGetFrameCount".}
proc igGetFrameHeight*(): float32 {.importc: "igGetFrameHeight".}
proc igGetFrameHeightWithSpacing*(): float32 {.importc: "igGetFrameHeightWithSpacing".}
proc igGetID*(str_id: ptr int8): ImGuiID {.importc: "igGetID".}
proc igGetID*(str_id_begin: ptr int8, str_id_end: ptr int8): ImGuiID {.importc: "igGetID".}
proc igGetID*(ptr_id: pointer): ImGuiID {.importc: "igGetID".}
proc igGetIO*(): ptr ImGuiIO {.importc: "igGetIO".}
proc igGetItemRectMax*(): ImVec2 {.importc: "igGetItemRectMax".}
proc igGetItemRectMin*(): ImVec2 {.importc: "igGetItemRectMin".}
proc igGetItemRectSize*(): ImVec2 {.importc: "igGetItemRectSize".}
proc igGetKeyIndex*(imgui_key: ImGuiKey): int32 {.importc: "igGetKeyIndex".}
proc igGetKeyPressedAmount*(key_index: int32, repeat_delay: float32, rate: float32): int32 {.importc: "igGetKeyPressedAmount".}
proc igGetMouseCursor*(): ImGuiMouseCursor {.importc: "igGetMouseCursor".}
proc igGetMouseDragDelta*(button: int32, lock_threshold: float32): ImVec2 {.importc: "igGetMouseDragDelta".}
proc igGetMousePos*(): ImVec2 {.importc: "igGetMousePos".}
proc igGetMousePosOnOpeningCurrentPopup*(): ImVec2 {.importc: "igGetMousePosOnOpeningCurrentPopup".}
proc igGetScrollMaxX*(): float32 {.importc: "igGetScrollMaxX".}
proc igGetScrollMaxY*(): float32 {.importc: "igGetScrollMaxY".}
proc igGetScrollX*(): float32 {.importc: "igGetScrollX".}
proc igGetScrollY*(): float32 {.importc: "igGetScrollY".}
proc igGetStateStorage*(): ptr ImGuiStorage {.importc: "igGetStateStorage".}
proc igGetStyle*(): ptr ImGuiStyle {.importc: "igGetStyle".}
proc igGetStyleColorName*(idx: ImGuiCol): ptr int8 {.importc: "igGetStyleColorName".}
proc igGetStyleColorVec4*(idx: ImGuiCol): ptr ImVec4 {.importc: "igGetStyleColorVec4".}
proc igGetTextLineHeight*(): float32 {.importc: "igGetTextLineHeight".}
proc igGetTextLineHeightWithSpacing*(): float32 {.importc: "igGetTextLineHeightWithSpacing".}
proc igGetTime*(): float64 {.importc: "igGetTime".}
proc igGetTreeNodeToLabelSpacing*(): float32 {.importc: "igGetTreeNodeToLabelSpacing".}
proc igGetVersion*(): ptr int8 {.importc: "igGetVersion".}
proc igGetWindowContentRegionMax*(): ImVec2 {.importc: "igGetWindowContentRegionMax".}
proc igGetWindowContentRegionMin*(): ImVec2 {.importc: "igGetWindowContentRegionMin".}
proc igGetWindowContentRegionWidth*(): float32 {.importc: "igGetWindowContentRegionWidth".}
proc igGetWindowDrawList*(): ptr ImDrawList {.importc: "igGetWindowDrawList".}
proc igGetWindowHeight*(): float32 {.importc: "igGetWindowHeight".}
proc igGetWindowPos*(): ImVec2 {.importc: "igGetWindowPos".}
proc igGetWindowSize*(): ImVec2 {.importc: "igGetWindowSize".}
proc igGetWindowWidth*(): float32 {.importc: "igGetWindowWidth".}
proc igImage*(user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2, uv1: ImVec2, tint_col: ImVec4, border_col: ImVec4): void {.importc: "igImage".}
proc igImageButton*(user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2, uv1: ImVec2, frame_padding: int32, bg_col: ImVec4, tint_col: ImVec4): bool {.importc: "igImageButton".}
proc igIndent*(indent_w: float32): void {.importc: "igIndent".}
proc igInputDouble*(label: ptr int8, v: ptr float64, step: float64, step_fast: float64, format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputDouble".}
proc igInputFloat*(label: ptr int8, v: ptr float32, step: float32, step_fast: float32, format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputFloat".}
proc igInputFloat2*(label: ptr int8, v: array[2, float32], format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputFloat2".}
proc igInputFloat3*(label: ptr int8, v: array[3, float32], format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputFloat3".}
proc igInputFloat4*(label: ptr int8, v: array[4, float32], format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputFloat4".}
proc igInputInt*(label: ptr int8, v: ptr int32, step: int32, step_fast: int32, flags: ImGuiInputTextFlags): bool {.importc: "igInputInt".}
proc igInputInt2*(label: ptr int8, v: array[2, int32], flags: ImGuiInputTextFlags): bool {.importc: "igInputInt2".}
proc igInputInt3*(label: ptr int8, v: array[3, int32], flags: ImGuiInputTextFlags): bool {.importc: "igInputInt3".}
proc igInputInt4*(label: ptr int8, v: array[4, int32], flags: ImGuiInputTextFlags): bool {.importc: "igInputInt4".}
proc igInputScalar*(label: ptr int8, data_type: ImGuiDataType, v: pointer, step: pointer, step_fast: pointer, format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputScalar".}
proc igInputScalarN*(label: ptr int8, data_type: ImGuiDataType, v: pointer, components: int32, step: pointer, step_fast: pointer, format: ptr int8, flags: ImGuiInputTextFlags): bool {.importc: "igInputScalarN".}
proc igInputText*(label: ptr int8, buf: ptr int8, buf_size: size_t, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback, user_data: pointer): bool {.importc: "igInputText".}
proc igInputTextMultiline*(label: ptr int8, buf: ptr int8, buf_size: size_t, size: ImVec2, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback, user_data: pointer): bool {.importc: "igInputTextMultiline".}
proc igInputTextWithHint*(label: ptr int8, hint: ptr int8, buf: ptr int8, buf_size: size_t, flags: ImGuiInputTextFlags, callback: ImGuiInputTextCallback, user_data: pointer): bool {.importc: "igInputTextWithHint".}
proc igInvisibleButton*(str_id: ptr int8, size: ImVec2): bool {.importc: "igInvisibleButton".}
proc igIsAnyItemActive*(): bool {.importc: "igIsAnyItemActive".}
proc igIsAnyItemFocused*(): bool {.importc: "igIsAnyItemFocused".}
proc igIsAnyItemHovered*(): bool {.importc: "igIsAnyItemHovered".}
proc igIsAnyMouseDown*(): bool {.importc: "igIsAnyMouseDown".}
proc igIsItemActivated*(): bool {.importc: "igIsItemActivated".}
proc igIsItemActive*(): bool {.importc: "igIsItemActive".}
proc igIsItemClicked*(mouse_button: int32): bool {.importc: "igIsItemClicked".}
proc igIsItemDeactivated*(): bool {.importc: "igIsItemDeactivated".}
proc igIsItemDeactivatedAfterEdit*(): bool {.importc: "igIsItemDeactivatedAfterEdit".}
proc igIsItemEdited*(): bool {.importc: "igIsItemEdited".}
proc igIsItemFocused*(): bool {.importc: "igIsItemFocused".}
proc igIsItemHovered*(flags: ImGuiHoveredFlags): bool {.importc: "igIsItemHovered".}
proc igIsItemVisible*(): bool {.importc: "igIsItemVisible".}
proc igIsKeyDown*(user_key_index: int32): bool {.importc: "igIsKeyDown".}
proc igIsKeyPressed*(user_key_index: int32, repeat: bool): bool {.importc: "igIsKeyPressed".}
proc igIsKeyReleased*(user_key_index: int32): bool {.importc: "igIsKeyReleased".}
proc igIsMouseClicked*(button: int32, repeat: bool): bool {.importc: "igIsMouseClicked".}
proc igIsMouseDoubleClicked*(button: int32): bool {.importc: "igIsMouseDoubleClicked".}
proc igIsMouseDown*(button: int32): bool {.importc: "igIsMouseDown".}
proc igIsMouseDragging*(button: int32, lock_threshold: float32): bool {.importc: "igIsMouseDragging".}
proc igIsMouseHoveringRect*(r_min: ImVec2, r_max: ImVec2, clip: bool): bool {.importc: "igIsMouseHoveringRect".}
proc igIsMousePosValid*(mouse_pos: ptr ImVec2): bool {.importc: "igIsMousePosValid".}
proc igIsMouseReleased*(button: int32): bool {.importc: "igIsMouseReleased".}
proc igIsPopupOpen*(str_id: ptr int8): bool {.importc: "igIsPopupOpen".}
proc igIsRectVisible*(size: ImVec2): bool {.importc: "igIsRectVisible".}
proc igIsRectVisible*(rect_min: ImVec2, rect_max: ImVec2): bool {.importc: "igIsRectVisible".}
proc igIsWindowAppearing*(): bool {.importc: "igIsWindowAppearing".}
proc igIsWindowCollapsed*(): bool {.importc: "igIsWindowCollapsed".}
proc igIsWindowFocused*(flags: ImGuiFocusedFlags): bool {.importc: "igIsWindowFocused".}
proc igIsWindowHovered*(flags: ImGuiHoveredFlags): bool {.importc: "igIsWindowHovered".}
proc igLabelText*(label: ptr int8, fmt: ptr int8): void {.importc: "igLabelText", varargs.}
proc igLabelTextV*(label: ptr int8, fmt: ptr int8): void {.importc: "igLabelTextV", varargs.}
proc igListBox*(label: ptr int8, current_item: ptr int32, items: array[, ptr int8const], items_count: int32, height_in_items: int32): bool {.importc: "igListBox".}
proc igListBox*(label: ptr int8, current_item: ptr int32, items_getter: int32, data: pointer, items_count: int32, height_in_items: int32): bool {.importc: "igListBox".}
proc igListBoxFooter*(): void {.importc: "igListBoxFooter".}
proc igListBoxHeader*(label: ptr int8, size: ImVec2): bool {.importc: "igListBoxHeader".}
proc igListBoxHeader*(label: ptr int8, items_count: int32, height_in_items: int32): bool {.importc: "igListBoxHeader".}
proc igLoadIniSettingsFromDisk*(ini_filename: ptr int8): void {.importc: "igLoadIniSettingsFromDisk".}
proc igLoadIniSettingsFromMemory*(ini_data: ptr int8, ini_size: size_t): void {.importc: "igLoadIniSettingsFromMemory".}
proc igLogButtons*(): void {.importc: "igLogButtons".}
proc igLogFinish*(): void {.importc: "igLogFinish".}
proc igLogText*(fmt: ptr int8): void {.importc: "igLogText", varargs.}
proc igLogToClipboard*(auto_open_depth: int32): void {.importc: "igLogToClipboard".}
proc igLogToFile*(auto_open_depth: int32, filename: ptr int8): void {.importc: "igLogToFile".}
proc igLogToTTY*(auto_open_depth: int32): void {.importc: "igLogToTTY".}
proc igMemAlloc*(size: size_t): pointer {.importc: "igMemAlloc".}
proc igMemFree*(ptr: pointer): void {.importc: "igMemFree".}
proc igMenuItem*(label: ptr int8, shortcut: ptr int8, selected: bool, enabled: bool): bool {.importc: "igMenuItem".}
proc igMenuItem*(label: ptr int8, shortcut: ptr int8, p_selected: ptr bool, enabled: bool): bool {.importc: "igMenuItem".}
proc igNewFrame*(): void {.importc: "igNewFrame".}
proc igNewLine*(): void {.importc: "igNewLine".}
proc igNextColumn*(): void {.importc: "igNextColumn".}
proc igOpenPopup*(str_id: ptr int8): void {.importc: "igOpenPopup".}
proc igOpenPopupOnItemClick*(str_id: ptr int8, mouse_button: int32): bool {.importc: "igOpenPopupOnItemClick".}
proc igPlotHistogram*(label: ptr int8, values: ptr float32, values_count: int32, values_offset: int32, overlay_text: ptr int8, scale_min: float32, scale_max: float32, graph_size: ImVec2, stride: int32): void {.importc: "igPlotHistogram".}
proc igPlotHistogram*(label: ptr int8, values_getter: int32, data: pointer, values_count: int32, values_offset: int32, overlay_text: ptr int8, scale_min: float32, scale_max: float32, graph_size: ImVec2): void {.importc: "igPlotHistogram".}
proc igPlotLines*(label: ptr int8, values: ptr float32, values_count: int32, values_offset: int32, overlay_text: ptr int8, scale_min: float32, scale_max: float32, graph_size: ImVec2, stride: int32): void {.importc: "igPlotLines".}
proc igPlotLines*(label: ptr int8, values_getter: int32, data: pointer, values_count: int32, values_offset: int32, overlay_text: ptr int8, scale_min: float32, scale_max: float32, graph_size: ImVec2): void {.importc: "igPlotLines".}
proc igPopAllowKeyboardFocus*(): void {.importc: "igPopAllowKeyboardFocus".}
proc igPopButtonRepeat*(): void {.importc: "igPopButtonRepeat".}
proc igPopClipRect*(): void {.importc: "igPopClipRect".}
proc igPopFont*(): void {.importc: "igPopFont".}
proc igPopID*(): void {.importc: "igPopID".}
proc igPopItemWidth*(): void {.importc: "igPopItemWidth".}
proc igPopStyleColor*(count: int32): void {.importc: "igPopStyleColor".}
proc igPopStyleVar*(count: int32): void {.importc: "igPopStyleVar".}
proc igPopTextWrapPos*(): void {.importc: "igPopTextWrapPos".}
proc igProgressBar*(fraction: float32, size_arg: ImVec2, overlay: ptr int8): void {.importc: "igProgressBar".}
proc igPushAllowKeyboardFocus*(allow_keyboard_focus: bool): void {.importc: "igPushAllowKeyboardFocus".}
proc igPushButtonRepeat*(repeat: bool): void {.importc: "igPushButtonRepeat".}
proc igPushClipRect*(clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool): void {.importc: "igPushClipRect".}
proc igPushFont*(font: ptr ImFont): void {.importc: "igPushFont".}
proc igPushID*(str_id: ptr int8): void {.importc: "igPushID".}
proc igPushID*(str_id_begin: ptr int8, str_id_end: ptr int8): void {.importc: "igPushID".}
proc igPushID*(ptr_id: pointer): void {.importc: "igPushID".}
proc igPushID*(int_id: int32): void {.importc: "igPushID".}
proc igPushItemWidth*(item_width: float32): void {.importc: "igPushItemWidth".}
proc igPushStyleColor*(idx: ImGuiCol, col: uint32): void {.importc: "igPushStyleColor".}
proc igPushStyleColor*(idx: ImGuiCol, col: ImVec4): void {.importc: "igPushStyleColor".}
proc igPushStyleVar*(idx: ImGuiStyleVar, val: float32): void {.importc: "igPushStyleVar".}
proc igPushStyleVar*(idx: ImGuiStyleVar, val: ImVec2): void {.importc: "igPushStyleVar".}
proc igPushTextWrapPos*(wrap_local_pos_x: float32): void {.importc: "igPushTextWrapPos".}
proc igRadioButton*(label: ptr int8, active: bool): bool {.importc: "igRadioButton".}
proc igRadioButton*(label: ptr int8, v: ptr int32, v_button: int32): bool {.importc: "igRadioButton".}
proc igRender*(): void {.importc: "igRender".}
proc igResetMouseDragDelta*(button: int32): void {.importc: "igResetMouseDragDelta".}
proc igSameLine*(offset_from_start_x: float32, spacing: float32): void {.importc: "igSameLine".}
proc igSaveIniSettingsToDisk*(ini_filename: ptr int8): void {.importc: "igSaveIniSettingsToDisk".}
proc igSaveIniSettingsToMemory*(out_ini_size: ptr size_t): ptr int8 {.importc: "igSaveIniSettingsToMemory".}
proc igSelectable*(label: ptr int8, selected: bool, flags: ImGuiSelectableFlags, size: ImVec2): bool {.importc: "igSelectable".}
proc igSelectable*(label: ptr int8, p_selected: ptr bool, flags: ImGuiSelectableFlags, size: ImVec2): bool {.importc: "igSelectable".}
proc igSeparator*(): void {.importc: "igSeparator".}
proc igSetAllocatorFunctions*(alloc_func: int32, free_func: int32, user_data: pointer): void {.importc: "igSetAllocatorFunctions".}
proc igSetClipboardText*(text: ptr int8): void {.importc: "igSetClipboardText".}
proc igSetColorEditOptions*(flags: ImGuiColorEditFlags): void {.importc: "igSetColorEditOptions".}
proc igSetColumnOffset*(column_index: int32, offset_x: float32): void {.importc: "igSetColumnOffset".}
proc igSetColumnWidth*(column_index: int32, width: float32): void {.importc: "igSetColumnWidth".}
proc igSetCurrentContext*(ctx: ptr ImGuiContext): void {.importc: "igSetCurrentContext".}
proc igSetCursorPos*(local_pos: ImVec2): void {.importc: "igSetCursorPos".}
proc igSetCursorPosX*(local_x: float32): void {.importc: "igSetCursorPosX".}
proc igSetCursorPosY*(local_y: float32): void {.importc: "igSetCursorPosY".}
proc igSetCursorScreenPos*(pos: ImVec2): void {.importc: "igSetCursorScreenPos".}
proc igSetDragDropPayload*(`type`: ptr int8, data: pointer, sz: size_t, cond: ImGuiCond): bool {.importc: "igSetDragDropPayload".}
proc igSetItemAllowOverlap*(): void {.importc: "igSetItemAllowOverlap".}
proc igSetItemDefaultFocus*(): void {.importc: "igSetItemDefaultFocus".}
proc igSetKeyboardFocusHere*(offset: int32): void {.importc: "igSetKeyboardFocusHere".}
proc igSetMouseCursor*(`type`: ImGuiMouseCursor): void {.importc: "igSetMouseCursor".}
proc igSetNextItemOpen*(is_open: bool, cond: ImGuiCond): void {.importc: "igSetNextItemOpen".}
proc igSetNextItemWidth*(item_width: float32): void {.importc: "igSetNextItemWidth".}
proc igSetNextWindowBgAlpha*(alpha: float32): void {.importc: "igSetNextWindowBgAlpha".}
proc igSetNextWindowCollapsed*(collapsed: bool, cond: ImGuiCond): void {.importc: "igSetNextWindowCollapsed".}
proc igSetNextWindowContentSize*(size: ImVec2): void {.importc: "igSetNextWindowContentSize".}
proc igSetNextWindowFocus*(): void {.importc: "igSetNextWindowFocus".}
proc igSetNextWindowPos*(pos: ImVec2, cond: ImGuiCond, pivot: ImVec2): void {.importc: "igSetNextWindowPos".}
proc igSetNextWindowSize*(size: ImVec2, cond: ImGuiCond): void {.importc: "igSetNextWindowSize".}
proc igSetNextWindowSizeConstraints*(size_min: ImVec2, size_max: ImVec2, custom_callback: ImGuiSizeCallback, custom_callback_data: pointer): void {.importc: "igSetNextWindowSizeConstraints".}
proc igSetScrollFromPosY*(local_y: float32, center_y_ratio: float32): void {.importc: "igSetScrollFromPosY".}
proc igSetScrollHereY*(center_y_ratio: float32): void {.importc: "igSetScrollHereY".}
proc igSetScrollX*(scroll_x: float32): void {.importc: "igSetScrollX".}
proc igSetScrollY*(scroll_y: float32): void {.importc: "igSetScrollY".}
proc igSetStateStorage*(storage: ptr ImGuiStorage): void {.importc: "igSetStateStorage".}
proc igSetTabItemClosed*(tab_or_docked_window_label: ptr int8): void {.importc: "igSetTabItemClosed".}
proc igSetTooltip*(fmt: ptr int8): void {.importc: "igSetTooltip", varargs.}
proc igSetTooltipV*(fmt: ptr int8): void {.importc: "igSetTooltipV", varargs.}
proc igSetWindowCollapsed*(collapsed: bool, cond: ImGuiCond): void {.importc: "igSetWindowCollapsed".}
proc igSetWindowCollapsed*(name: ptr int8, collapsed: bool, cond: ImGuiCond): void {.importc: "igSetWindowCollapsed".}
proc igSetWindowFocus*(): void {.importc: "igSetWindowFocus".}
proc igSetWindowFocus*(name: ptr int8): void {.importc: "igSetWindowFocus".}
proc igSetWindowFontScale*(scale: float32): void {.importc: "igSetWindowFontScale".}
proc igSetWindowPos*(pos: ImVec2, cond: ImGuiCond): void {.importc: "igSetWindowPos".}
proc igSetWindowPos*(name: ptr int8, pos: ImVec2, cond: ImGuiCond): void {.importc: "igSetWindowPos".}
proc igSetWindowSize*(size: ImVec2, cond: ImGuiCond): void {.importc: "igSetWindowSize".}
proc igSetWindowSize*(name: ptr int8, size: ImVec2, cond: ImGuiCond): void {.importc: "igSetWindowSize".}
proc igShowAboutWindow*(p_open: ptr bool): void {.importc: "igShowAboutWindow".}
proc igShowDemoWindow*(p_open: ptr bool): void {.importc: "igShowDemoWindow".}
proc igShowFontSelector*(label: ptr int8): void {.importc: "igShowFontSelector".}
proc igShowMetricsWindow*(p_open: ptr bool): void {.importc: "igShowMetricsWindow".}
proc igShowStyleEditor*(ref: ptr ImGuiStyle): void {.importc: "igShowStyleEditor".}
proc igShowStyleSelector*(label: ptr int8): bool {.importc: "igShowStyleSelector".}
proc igShowUserGuide*(): void {.importc: "igShowUserGuide".}
proc igSliderAngle*(label: ptr int8, v_rad: ptr float32, v_degrees_min: float32, v_degrees_max: float32, format: ptr int8): bool {.importc: "igSliderAngle".}
proc igSliderFloat*(label: ptr int8, v: ptr float32, v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igSliderFloat".}
proc igSliderFloat2*(label: ptr int8, v: array[2, float32], v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igSliderFloat2".}
proc igSliderFloat3*(label: ptr int8, v: array[3, float32], v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igSliderFloat3".}
proc igSliderFloat4*(label: ptr int8, v: array[4, float32], v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igSliderFloat4".}
proc igSliderInt*(label: ptr int8, v: ptr int32, v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igSliderInt".}
proc igSliderInt2*(label: ptr int8, v: array[2, int32], v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igSliderInt2".}
proc igSliderInt3*(label: ptr int8, v: array[3, int32], v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igSliderInt3".}
proc igSliderInt4*(label: ptr int8, v: array[4, int32], v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igSliderInt4".}
proc igSliderScalar*(label: ptr int8, data_type: ImGuiDataType, v: pointer, v_min: pointer, v_max: pointer, format: ptr int8, power: float32): bool {.importc: "igSliderScalar".}
proc igSliderScalarN*(label: ptr int8, data_type: ImGuiDataType, v: pointer, components: int32, v_min: pointer, v_max: pointer, format: ptr int8, power: float32): bool {.importc: "igSliderScalarN".}
proc igSmallButton*(label: ptr int8): bool {.importc: "igSmallButton".}
proc igSpacing*(): void {.importc: "igSpacing".}
proc igStyleColorsClassic*(dst: ptr ImGuiStyle): void {.importc: "igStyleColorsClassic".}
proc igStyleColorsDark*(dst: ptr ImGuiStyle): void {.importc: "igStyleColorsDark".}
proc igStyleColorsLight*(dst: ptr ImGuiStyle): void {.importc: "igStyleColorsLight".}
proc igText*(fmt: ptr int8): void {.importc: "igText", varargs.}
proc igTextColored*(col: ImVec4, fmt: ptr int8): void {.importc: "igTextColored", varargs.}
proc igTextColoredV*(col: ImVec4, fmt: ptr int8): void {.importc: "igTextColoredV", varargs.}
proc igTextDisabled*(fmt: ptr int8): void {.importc: "igTextDisabled", varargs.}
proc igTextDisabledV*(fmt: ptr int8): void {.importc: "igTextDisabledV", varargs.}
proc igTextUnformatted*(text: ptr int8, text_end: ptr int8): void {.importc: "igTextUnformatted".}
proc igTextV*(fmt: ptr int8): void {.importc: "igTextV", varargs.}
proc igTextWrapped*(fmt: ptr int8): void {.importc: "igTextWrapped", varargs.}
proc igTextWrappedV*(fmt: ptr int8): void {.importc: "igTextWrappedV", varargs.}
proc igTreeAdvanceToLabelPos*(): void {.importc: "igTreeAdvanceToLabelPos".}
proc igTreeNode*(label: ptr int8): bool {.importc: "igTreeNode".}
proc igTreeNode*(str_id: ptr int8, fmt: ptr int8): bool {.importc: "igTreeNode", varargs.}
proc igTreeNode*(ptr_id: pointer, fmt: ptr int8): bool {.importc: "igTreeNode", varargs.}
proc igTreeNodeEx*(label: ptr int8, flags: ImGuiTreeNodeFlags): bool {.importc: "igTreeNodeEx".}
proc igTreeNodeEx*(str_id: ptr int8, flags: ImGuiTreeNodeFlags, fmt: ptr int8): bool {.importc: "igTreeNodeEx", varargs.}
proc igTreeNodeEx*(ptr_id: pointer, flags: ImGuiTreeNodeFlags, fmt: ptr int8): bool {.importc: "igTreeNodeEx", varargs.}
proc igTreeNodeExV*(str_id: ptr int8, flags: ImGuiTreeNodeFlags, fmt: ptr int8): bool {.importc: "igTreeNodeExV", varargs.}
proc igTreeNodeExV*(ptr_id: pointer, flags: ImGuiTreeNodeFlags, fmt: ptr int8): bool {.importc: "igTreeNodeExV", varargs.}
proc igTreeNodeV*(str_id: ptr int8, fmt: ptr int8): bool {.importc: "igTreeNodeV", varargs.}
proc igTreeNodeV*(ptr_id: pointer, fmt: ptr int8): bool {.importc: "igTreeNodeV", varargs.}
proc igTreePop*(): void {.importc: "igTreePop".}
proc igTreePush*(str_id: ptr int8): void {.importc: "igTreePush".}
proc igTreePush*(ptr_id: pointer): void {.importc: "igTreePush".}
proc igUnindent*(indent_w: float32): void {.importc: "igUnindent".}
proc igVSliderFloat*(label: ptr int8, size: ImVec2, v: ptr float32, v_min: float32, v_max: float32, format: ptr int8, power: float32): bool {.importc: "igVSliderFloat".}
proc igVSliderInt*(label: ptr int8, size: ImVec2, v: ptr int32, v_min: int32, v_max: int32, format: ptr int8): bool {.importc: "igVSliderInt".}
proc igVSliderScalar*(label: ptr int8, size: ImVec2, data_type: ImGuiDataType, v: pointer, v_min: pointer, v_max: pointer, format: ptr int8, power: float32): bool {.importc: "igVSliderScalar".}
proc igValue*(prefix: ptr int8, b: bool): void {.importc: "igValue".}
proc igValue*(prefix: ptr int8, v: int32): void {.importc: "igValue".}
proc igValue*(prefix: ptr int8, v: uint32): void {.importc: "igValue".}
proc igValue*(prefix: ptr int8, v: float32, float_format: ptr int8): void {.importc: "igValue".}

{.pop.}
