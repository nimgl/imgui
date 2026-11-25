import ../../imgui
import winim/lean

var
  gHwnd: HWND
  gMouseHwnd: HWND
  gMouseTrackedArea: int        # 0 none, 1 client, 2 non-client
  gMouseButtonsDown: int32
  gTime: int64
  gTicksPerSecond: int64
  gLastMouseCursor = ImGuiMouseCursor.COUNT

proc loword(x: int): int {.inline.} = x and 0xFFFF
proc hiword(x: int): int {.inline.} = (x shr 16) and 0xFFFF
proc getXLParam(lp: LPARAM): int32 {.inline.} = int32(cast[int16](loword(lp)))
proc getYLParam(lp: LPARAM): int32 {.inline.} = int32(cast[int16](hiword(lp)))

proc isVkDown(vk: int32): bool {.inline.} = (GetKeyState(vk) and 0x8000'i16) != 0

proc igWin32VirtualKeyToImGuiKey(wParam: WPARAM, lParam: LPARAM): ImGuiKey =
  if wParam == VK_RETURN and (hiword(lParam) and KF_EXTENDED) != 0:
    return ImGuiKey.KeypadEnter
  case int(wParam)
  of VK_TAB: ImGuiKey(ImGuiKey_Tab)
  of VK_LEFT: ImGuiKey.LeftArrow
  of VK_RIGHT: ImGuiKey.RightArrow
  of VK_UP: ImGuiKey.UpArrow
  of VK_DOWN: ImGuiKey.DownArrow
  of VK_PRIOR: ImGuiKey.PageUp
  of VK_NEXT: ImGuiKey.PageDown
  of VK_HOME: ImGuiKey.Home
  of VK_END: ImGuiKey.End
  of VK_INSERT: ImGuiKey.Insert
  of VK_DELETE: ImGuiKey.Delete
  of VK_BACK: ImGuiKey.Backspace
  of VK_SPACE: ImGuiKey.Space
  of VK_RETURN: ImGuiKey.Enter
  of VK_ESCAPE: ImGuiKey.Escape
  of VK_OEM_7: ImGuiKey.Apostrophe
  of VK_OEM_COMMA: ImGuiKey.Comma
  of VK_OEM_MINUS: ImGuiKey.Minus
  of VK_OEM_PERIOD: ImGuiKey.Period
  of VK_OEM_2: ImGuiKey.Slash
  of VK_OEM_1: ImGuiKey.Semicolon
  of VK_OEM_PLUS: ImGuiKey.Equal
  of VK_OEM_4: ImGuiKey.LeftBracket
  of VK_OEM_5: ImGuiKey.Backslash
  of VK_OEM_6: ImGuiKey.RightBracket
  of VK_OEM_3: ImGuiKey.GraveAccent
  of VK_CAPITAL: ImGuiKey.CapsLock
  of VK_SCROLL: ImGuiKey.ScrollLock
  of VK_NUMLOCK: ImGuiKey.NumLock
  of VK_SNAPSHOT: ImGuiKey.PrintScreen
  of VK_PAUSE: ImGuiKey.Pause
  of VK_NUMPAD0 .. VK_NUMPAD9: ImGuiKey(ImGuiKey.Keypad0.int32 + int32(wParam - VK_NUMPAD0))
  of VK_DECIMAL: ImGuiKey.KeypadDecimal
  of VK_DIVIDE: ImGuiKey.KeypadDivide
  of VK_MULTIPLY: ImGuiKey.KeypadMultiply
  of VK_SUBTRACT: ImGuiKey.KeypadSubtract
  of VK_ADD: ImGuiKey.KeypadAdd
  of VK_LSHIFT: ImGuiKey.LeftShift
  of VK_LCONTROL: ImGuiKey.LeftCtrl
  of VK_LMENU: ImGuiKey.LeftAlt
  of VK_LWIN: ImGuiKey.LeftSuper
  of VK_RSHIFT: ImGuiKey.RightShift
  of VK_RCONTROL: ImGuiKey.RightCtrl
  of VK_RMENU: ImGuiKey.RightAlt
  of VK_RWIN: ImGuiKey.RightSuper
  of VK_APPS: ImGuiKey.Menu
  of ord('0') .. ord('9'): ImGuiKey(536'i32 + int32(wParam - ord('0')))   # ImGuiKey_0 .. ImGuiKey_9
  of ord('A') .. ord('Z'): ImGuiKey(ImGuiKey.A.int32 + int32(wParam - ord('A')))
  of VK_F1 .. VK_F24: ImGuiKey(ImGuiKey.F1.int32 + int32(wParam - VK_F1))
  of VK_BROWSER_BACK: ImGuiKey.AppBack
  of VK_BROWSER_FORWARD: ImGuiKey.AppForward
  else: ImGuiKey.None

proc igWin32AddKeyEvent(io: ptr ImGuiIO, key: ImGuiKey, down: bool, vk: int32, scancode: int32 = -1) =
  io.addKeyEvent(key, down)
  io.setKeyEventNativeData(key, vk, scancode)

proc igWin32UpdateKeyModifiers(io: ptr ImGuiIO) =
  io.addKeyEvent(ImGuiKey.Ctrl, isVkDown(VK_CONTROL))
  io.addKeyEvent(ImGuiKey.Shift, isVkDown(VK_SHIFT))
  io.addKeyEvent(ImGuiKey.Alt, isVkDown(VK_MENU))
  io.addKeyEvent(ImGuiKey.Super, isVkDown(VK_LWIN) or isVkDown(VK_RWIN))

proc igWin32ProcessKeyEventsWorkarounds(io: ptr ImGuiIO) =
  # Windows doesn't always send key up for a shift key when both are held,
  # and never sends key down for the Windows keys, so check them each frame.
  if igIsKeyDown(ImGuiKey.LeftShift) and not isVkDown(VK_LSHIFT):
    igWin32AddKeyEvent(io, ImGuiKey.LeftShift, false, VK_LSHIFT)
  if igIsKeyDown(ImGuiKey.RightShift) and not isVkDown(VK_RSHIFT):
    igWin32AddKeyEvent(io, ImGuiKey.RightShift, false, VK_RSHIFT)
  if igIsKeyDown(ImGuiKey.LeftSuper) and not isVkDown(VK_LWIN):
    igWin32AddKeyEvent(io, ImGuiKey.LeftSuper, false, VK_LWIN)
  if igIsKeyDown(ImGuiKey.RightSuper) and not isVkDown(VK_RWIN):
    igWin32AddKeyEvent(io, ImGuiKey.RightSuper, false, VK_RWIN)

proc igWin32UpdateMouseCursor(io: ptr ImGuiIO, cursor: ImGuiMouseCursor): bool =
  if (io.configFlags.int32 and ImGuiConfigFlags.NoMouseCursorChange.int32) != 0:
    return false
  if cursor == ImGuiMouseCursor.None or io.mouseDrawCursor:
    SetCursor(0)
  else:
    let name = case cursor
      of ImGuiMouseCursor.TextInput: IDC_IBEAM
      of ImGuiMouseCursor.ResizeAll: IDC_SIZEALL
      of ImGuiMouseCursor.ResizeEW: IDC_SIZEWE
      of ImGuiMouseCursor.ResizeNS: IDC_SIZENS
      of ImGuiMouseCursor.ResizeNESW: IDC_SIZENESW
      of ImGuiMouseCursor.ResizeNWSE: IDC_SIZENWSE
      of ImGuiMouseCursor.Hand: IDC_HAND
      of ImGuiMouseCursor.Wait: IDC_WAIT
      of ImGuiMouseCursor.Progress: IDC_APPSTARTING
      of ImGuiMouseCursor.NotAllowed: IDC_NO
      else: IDC_ARROW
    SetCursor(LoadCursor(0, name))
  true

proc igWin32UpdateMouseData(io: ptr ImGuiIO) =
  let focused = GetForegroundWindow()
  if focused != 0 and (focused == gHwnd or IsChild(focused, gHwnd) != 0):
    if io.wantSetMousePos:
      var pos = POINT(x: LONG(io.mousePos.x), y: LONG(io.mousePos.y))
      if ClientToScreen(gHwnd, addr pos) != 0:
        SetCursorPos(pos.x, pos.y)
    elif gMouseTrackedArea == 0:
      # mouse is outside the client area, e.g. while dragging
      var pos: POINT
      if GetCursorPos(addr pos) != 0 and ScreenToClient(gHwnd, addr pos) != 0:
        io.addMousePosEvent(float32(pos.x), float32(pos.y))

proc igWin32Init*(hwnd: pointer | SomeInteger): bool {.discardable.} =
  let io = igGetIO()
  if QueryPerformanceFrequency(cast[ptr LARGE_INTEGER](addr gTicksPerSecond)) == 0:
    return false
  if QueryPerformanceCounter(cast[ptr LARGE_INTEGER](addr gTime)) == 0:
    return false
  gHwnd = cast[HWND](hwnd)
  io.backendPlatformName = "imgui_impl_win32"
  io.backendFlags = (io.backendFlags.int32 or ImGuiBackendFlags.HasMouseCursors.int32 or
                     ImGuiBackendFlags.HasSetMousePos.int32).ImGuiBackendFlags
  let vp = igGetMainViewport()
  vp.platformHandle = cast[pointer](gHwnd)
  vp.platformHandleRaw = cast[pointer](gHwnd)
  true

proc igWin32InitForOpenGL*(hwnd: pointer | SomeInteger): bool {.discardable.} =
  igWin32Init(hwnd)

proc igWin32Shutdown*() =
  let io = igGetIO()
  io.backendPlatformName = nil
  io.backendFlags = (io.backendFlags.int32 and not (ImGuiBackendFlags.HasMouseCursors.int32 or
                     ImGuiBackendFlags.HasSetMousePos.int32)).ImGuiBackendFlags
  # igDestroyContext asserts that the main viewport handle was cleared
  let vp = igGetMainViewport()
  vp.platformHandle = nil
  vp.platformHandleRaw = nil
  gHwnd = 0
  gMouseHwnd = 0

proc igWin32NewFrame*() =
  let io = igGetIO()
  var rect: RECT
  GetClientRect(gHwnd, addr rect)
  io.displaySize = ImVec2(x: float32(rect.right - rect.left), y: float32(rect.bottom - rect.top))

  var now: int64
  QueryPerformanceCounter(cast[ptr LARGE_INTEGER](addr now))
  io.deltaTime = float32(now - gTime) / float32(gTicksPerSecond)
  if io.deltaTime <= 0: io.deltaTime = 1'f32 / 60
  gTime = now

  igWin32UpdateMouseData(io)
  igWin32ProcessKeyEventsWorkarounds(io)

  let cursor = if io.mouseDrawCursor: ImGuiMouseCursor.None else: igGetMouseCursor()
  if gLastMouseCursor != cursor:
    gLastMouseCursor = cursor
    discard igWin32UpdateMouseCursor(io, cursor)

proc igWin32HandleMessage(hwnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT =
  if igGetCurrentContext() == nil:
    return 0
  let io = igGetIO()
  case msg
  of WM_MOUSEMOVE, WM_NCMOUSEMOVE:
    let area = if msg == WM_MOUSEMOVE: 1 else: 2
    gMouseHwnd = hwnd
    if gMouseTrackedArea != area:
      var cancel = TTRACKMOUSEEVENT(cbSize: DWORD(sizeof(TTRACKMOUSEEVENT)), dwFlags: TME_CANCEL, hwndTrack: hwnd)
      var track = TTRACKMOUSEEVENT(cbSize: DWORD(sizeof(TTRACKMOUSEEVENT)),
                                  dwFlags: if area == 1: TME_LEAVE else: TME_LEAVE or TME_NONCLIENT,
                                  hwndTrack: hwnd)
      if gMouseTrackedArea != 0: TrackMouseEvent(addr cancel)
      TrackMouseEvent(addr track)
      gMouseTrackedArea = area
    var pos = POINT(x: getXLParam(lParam), y: getYLParam(lParam))
    if msg == WM_NCMOUSEMOVE and ScreenToClient(hwnd, addr pos) == 0:
      return 0
    io.addMousePosEvent(float32(pos.x), float32(pos.y))
  of WM_MOUSELEAVE, WM_NCMOUSELEAVE:
    let area = if msg == WM_MOUSELEAVE: 1 else: 2
    if gMouseTrackedArea == area:
      if gMouseHwnd == hwnd: gMouseHwnd = 0
      gMouseTrackedArea = 0
      io.addMousePosEvent(-3.402823466e+38'f32, -3.402823466e+38'f32)
  of WM_LBUTTONDOWN, WM_LBUTTONDBLCLK, WM_RBUTTONDOWN, WM_RBUTTONDBLCLK,
     WM_MBUTTONDOWN, WM_MBUTTONDBLCLK, WM_XBUTTONDOWN, WM_XBUTTONDBLCLK:
    var button = 0'i32
    if msg == WM_RBUTTONDOWN or msg == WM_RBUTTONDBLCLK: button = 1
    elif msg == WM_MBUTTONDOWN or msg == WM_MBUTTONDBLCLK: button = 2
    elif msg == WM_XBUTTONDOWN or msg == WM_XBUTTONDBLCLK:
      button = if hiword(int(wParam)) == XBUTTON1: 3 else: 4
    if gMouseButtonsDown == 0 and GetCapture() == 0:
      SetCapture(hwnd)
    gMouseButtonsDown = gMouseButtonsDown or (1'i32 shl button)
    io.addMouseButtonEvent(button, true)
  of WM_LBUTTONUP, WM_RBUTTONUP, WM_MBUTTONUP, WM_XBUTTONUP:
    var button = 0'i32
    if msg == WM_RBUTTONUP: button = 1
    elif msg == WM_MBUTTONUP: button = 2
    elif msg == WM_XBUTTONUP:
      button = if hiword(int(wParam)) == XBUTTON1: 3 else: 4
    gMouseButtonsDown = gMouseButtonsDown and not (1'i32 shl button)
    if gMouseButtonsDown == 0 and GetCapture() == hwnd:
      ReleaseCapture()
    io.addMouseButtonEvent(button, false)
  of WM_MOUSEWHEEL:
    io.addMouseWheelEvent(0, float32(cast[int16](hiword(int(wParam)))) / float32(WHEEL_DELTA))
  of WM_MOUSEHWHEEL:
    io.addMouseWheelEvent(-float32(cast[int16](hiword(int(wParam)))) / float32(WHEEL_DELTA), 0)
  of WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, WM_SYSKEYUP:
    let down = msg == WM_KEYDOWN or msg == WM_SYSKEYDOWN
    if wParam < 256:
      igWin32UpdateKeyModifiers(io)
      var vk = int32(wParam)
      if wParam == VK_RETURN and (hiword(lParam) and KF_EXTENDED) != 0:
        vk = VK_RETURN + 256   # same as imgui_impl_win32.cpp: IM_VK_KEYPAD_ENTER
      let key = igWin32VirtualKeyToImGuiKey(wParam, lParam)
      let scancode = int32((hiword(lParam) and 0xFF))
      if key != ImGuiKey.None:
        igWin32AddKeyEvent(io, key, down, vk, scancode)
      # left and right Shift/Ctrl/Alt come as one VK, look at the real keys
      if vk == VK_SHIFT:
        if isVkDown(VK_LSHIFT) == down: igWin32AddKeyEvent(io, ImGuiKey.LeftShift, down, VK_LSHIFT, scancode)
        if isVkDown(VK_RSHIFT) == down: igWin32AddKeyEvent(io, ImGuiKey.RightShift, down, VK_RSHIFT, scancode)
      elif vk == VK_CONTROL:
        if isVkDown(VK_LCONTROL) == down: igWin32AddKeyEvent(io, ImGuiKey.LeftCtrl, down, VK_LCONTROL, scancode)
        if isVkDown(VK_RCONTROL) == down: igWin32AddKeyEvent(io, ImGuiKey.RightCtrl, down, VK_RCONTROL, scancode)
      elif vk == VK_MENU:
        if isVkDown(VK_LMENU) == down: igWin32AddKeyEvent(io, ImGuiKey.LeftAlt, down, VK_LMENU, scancode)
        if isVkDown(VK_RMENU) == down: igWin32AddKeyEvent(io, ImGuiKey.RightAlt, down, VK_RMENU, scancode)
  of WM_SETFOCUS, WM_KILLFOCUS:
    io.addFocusEvent(msg == WM_SETFOCUS)
  of WM_CHAR:
    if IsWindowUnicode(hwnd) != 0:
      if wParam > 0 and wParam < 0x10000:
        io.addInputCharacterUTF16(ImWchar16(wParam))
    else:
      var wch: WCHAR
      var ch = char(wParam)
      MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, cast[LPCCH](addr ch), 1, addr wch, 1)
      io.addInputCharacter(uint32(wch))
  of WM_SETCURSOR:
    if loword(int(lParam)) == HTCLIENT and igWin32UpdateMouseCursor(io, igGetMouseCursor()):
      return 1
  else: discard
  0

proc igWin32WndProcHandler*[H: pointer | SomeInteger; M, W, L: SomeInteger](hwnd: H, msg: M, wParam: W, lParam: L): int =
  ## Returns non-zero when ImGui used the message.
  int(igWin32HandleMessage(cast[HWND](hwnd), UINT(msg), cast[WPARAM](wParam), cast[LPARAM](lParam)))

proc igWin32EnableDpiAwareness*() =
  SetProcessDPIAware()

proc igWin32GetDpiScaleForMonitor*(monitor: pointer): float32 =
  type GetDpiForMonitorFn = proc (m: HMONITOR, kind: int32, x, y: ptr UINT): HRESULT {.stdcall.}
  let shcore = LoadLibraryA("shcore.dll")
  if shcore != 0:
    let fn = cast[GetDpiForMonitorFn](GetProcAddress(shcore, "GetDpiForMonitor"))
    if fn != nil:
      var x, y: UINT
      if fn(cast[HMONITOR](monitor), 0, addr x, addr y) == S_OK:
        return float32(x) / 96
  let dc = GetDC(0)
  result = float32(GetDeviceCaps(dc, LOGPIXELSX)) / 96
  ReleaseDC(0, dc)

proc igWin32GetDpiScaleForHwnd*(hwnd: pointer | SomeInteger): float32 =
  igWin32GetDpiScaleForMonitor(cast[pointer](MonitorFromWindow(cast[HWND](hwnd), MONITOR_DEFAULTTONEAREST)))
