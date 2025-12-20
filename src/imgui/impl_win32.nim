import winim/lean
import nimgl/imgui

var
  g_hWnd: HWND = 0
  g_Time: int64 = 0
  g_TicksPerSecond: int64 = 0
  g_MouseJustPressed: array[5, bool]  # 0..4
  g_MouseCursors: array[32, HCURSOR]
  g_LastMouseCursor: int32 = -1

const
  DBT_DEVNODES_CHANGED* = 0x0007

proc igWin32Init*(hwnd: HWND; installImeHandle: bool = true): bool {.discardable.} =
  g_hWnd = hwnd

  if QueryPerformanceFrequency(cast[ptr LARGE_INTEGER](addr g_TicksPerSecond)) == 0:
    return false
  if QueryPerformanceCounter(cast[ptr LARGE_INTEGER](addr g_Time)) == 0:
    return false

  let io = igGetIO()
  io.backendPlatformName = "imgui_impl_win32_nim"

  # Backend flags (legacy style in NimGL)
  io.backendFlags = cast[ImGuiBackendFlags](
    io.backendFlags.int32 or
    ImGuiBackendFlags.HasMouseCursors.int32 or
    ImGuiBackendFlags.HasSetMousePos.int32
  )


  if installImeHandle:
    io.imeWindowHandle = cast[pointer](g_hWnd)

  # Legacy key mapping like the NimGL GLFW backend example
  io.keyMap[ImGuiKey.Tab.int32]        = VK_TAB
  io.keyMap[ImGuiKey.LeftArrow.int32]  = VK_LEFT
  io.keyMap[ImGuiKey.RightArrow.int32] = VK_RIGHT
  io.keyMap[ImGuiKey.UpArrow.int32]    = VK_UP
  io.keyMap[ImGuiKey.DownArrow.int32]  = VK_DOWN
  io.keyMap[ImGuiKey.PageUp.int32]     = VK_PRIOR
  io.keyMap[ImGuiKey.PageDown.int32]   = VK_NEXT
  io.keyMap[ImGuiKey.Home.int32]       = VK_HOME
  io.keyMap[ImGuiKey.End.int32]        = VK_END
  io.keyMap[ImGuiKey.Insert.int32]     = VK_INSERT
  io.keyMap[ImGuiKey.Delete.int32]     = VK_DELETE
  io.keyMap[ImGuiKey.Backspace.int32]  = VK_BACK
  io.keyMap[ImGuiKey.Space.int32]      = VK_SPACE
  io.keyMap[ImGuiKey.Enter.int32]      = VK_RETURN
  io.keyMap[ImGuiKey.Escape.int32]     = VK_ESCAPE
  io.keyMap[ImGuiKey.A.int32]          = 0x41
  io.keyMap[ImGuiKey.C.int32]          = 0x43
  io.keyMap[ImGuiKey.V.int32]          = 0x56
  io.keyMap[ImGuiKey.X.int32]          = 0x58
  io.keyMap[ImGuiKey.Y.int32]          = 0x59
  io.keyMap[ImGuiKey.Z.int32]          = 0x5A

  # Cursor handles (map common ones; anything missing will just fallback to arrow)
  g_MouseCursors[0] = LoadCursorW(0, IDC_ARROW)     # Arrow
  g_MouseCursors[1] = LoadCursorW(0, IDC_IBEAM)     # TextInput
  g_MouseCursors[2] = LoadCursorW(0, IDC_SIZEALL)   # ResizeAll
  g_MouseCursors[3] = LoadCursorW(0, IDC_SIZEWE)    # ResizeEW
  g_MouseCursors[4] = LoadCursorW(0, IDC_SIZENS)    # ResizeNS
  g_MouseCursors[5] = LoadCursorW(0, IDC_SIZENESW)  # ResizeNESW
  g_MouseCursors[6] = LoadCursorW(0, IDC_SIZENWSE)  # ResizeNWSE
  g_MouseCursors[7] = LoadCursorW(0, IDC_HAND)      # Hand
  g_MouseCursors[8] = LoadCursorW(0, IDC_NO)        # NotAllowed
  g_MouseCursors[9] = LoadCursorW(0, IDC_WAIT)      # Wait (if your enum uses it)
  g_MouseCursors[10] = LoadCursorW(0, IDC_APPSTARTING) # Progress (if your enum uses it)

  return true

proc igWin32Shutdown*() =
  g_hWnd = 0
  g_LastMouseCursor = -1

proc igWin32WndProcHandler*(hwnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
  if igGetCurrentContext() == nil:
    return 0

  let io = igGetIO()

  case msg
  of WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
    g_MouseJustPressed[0] = true
    if GetCapture() == 0: SetCapture(hwnd)
    return 0
  of WM_LBUTTONUP:
    io.mouseDown[0] = false
    if GetCapture() == hwnd: ReleaseCapture()
    return 0

  of WM_RBUTTONDOWN, WM_RBUTTONDBLCLK:
    g_MouseJustPressed[1] = true
    if GetCapture() == 0: SetCapture(hwnd)
    return 0
  of WM_RBUTTONUP:
    io.mouseDown[1] = false
    if GetCapture() == hwnd: ReleaseCapture()
    return 0

  of WM_MBUTTONDOWN, WM_MBUTTONDBLCLK:
    g_MouseJustPressed[2] = true
    if GetCapture() == 0: SetCapture(hwnd)
    return 0
  of WM_MBUTTONUP:
    io.mouseDown[2] = false
    if GetCapture() == hwnd: ReleaseCapture()
    return 0

  of WM_XBUTTONDOWN, WM_XBUTTONDBLCLK:
    let btn = int(GET_XBUTTON_WPARAM(wParam))
    if btn == XBUTTON1: g_MouseJustPressed[3] = true
    else: g_MouseJustPressed[4] = true
    if GetCapture() == 0: SetCapture(hwnd)
    return 0
  of WM_XBUTTONUP:
    let btn = int(GET_XBUTTON_WPARAM(wParam))
    if btn == XBUTTON1: io.mouseDown[3] = false
    else: io.mouseDown[4] = false
    if GetCapture() == hwnd: ReleaseCapture()
    return 0

  of WM_MOUSEWHEEL:
    io.mouseWheel += (float32(GET_WHEEL_DELTA_WPARAM(wParam)) / float32(WHEEL_DELTA))
    return 0
  of WM_MOUSEHWHEEL:
    io.mouseWheelH += (float32(GET_WHEEL_DELTA_WPARAM(wParam)) / float32(WHEEL_DELTA))
    return 0

  of WM_CHAR:
    # Legacy input path (works with NimGL bindings)
    let c = uint32(wParam)
    if c > 0'u32 and c < 0x10000'u32:
      io.addInputCharacter(cast[ImWchar](c))
    return 0

  of WM_SETCURSOR:
    # Let NewFrame handle cursor; we still return 0 so default proc can run too.
    return 0

  else:
    discard

  return 0

proc igWin32NewFrame*() =
  let io = igGetIO()
  assert g_hWnd != 0

  # Display size
  var rect: RECT
  GetClientRect(g_hWnd, addr rect)
  io.displaySize = ImVec2(
    x: float32(rect.right - rect.left),
    y: float32(rect.bottom - rect.top)
  )

  # Time step
  var currentTime: int64
  QueryPerformanceCounter(cast[ptr LARGE_INTEGER](addr currentTime))
  io.deltaTime = float32(currentTime - g_Time) / float32(g_TicksPerSecond)
  g_Time = currentTime

  # Mouse buttons (combine "just pressed" from WndProc with current key state)
  io.mouseDown[0] = g_MouseJustPressed[0] or ((GetKeyState(VK_LBUTTON) and 0x8000) != 0)
  io.mouseDown[1] = g_MouseJustPressed[1] or ((GetKeyState(VK_RBUTTON) and 0x8000) != 0)
  io.mouseDown[2] = g_MouseJustPressed[2] or ((GetKeyState(VK_MBUTTON) and 0x8000) != 0)
  io.mouseDown[3] = g_MouseJustPressed[3]
  io.mouseDown[4] = g_MouseJustPressed[4]
  for i in 0 ..< g_MouseJustPressed.len:
    g_MouseJustPressed[i] = false

  # Mouse pos
  var p: POINT
  if GetCursorPos(addr p) != 0 and ScreenToClient(g_hWnd, addr p) != 0:
    io.mousePos = ImVec2(x: float32(p.x), y: float32(p.y))
  else:
    io.mousePos = ImVec2(x: -1e10'f32, y: -1e10'f32)

  # Keys (legacy keysDown[0..255])
  for vk in 0 .. 255:
    io.keysDown[vk] = (GetKeyState(vk.int32) and 0x8000) != 0

  # Modifiers
  io.keyCtrl  = (GetKeyState(VK_CONTROL) and 0x8000) != 0
  io.keyShift = (GetKeyState(VK_SHIFT) and 0x8000) != 0
  io.keyAlt   = (GetKeyState(VK_MENU) and 0x8000) != 0
  io.keySuper = (GetKeyState(VK_LWIN) and 0x8000) != 0 or (GetKeyState(VK_RWIN) and 0x8000) != 0

  # Cursor update (safe indexing)
  if (io.configFlags.int32 and ImGuiConfigFlags.NoMouseCursorChange.int32) == 0:
    var c = igGetMouseCursor().int32
    if io.mouseDrawCursor:
      SetCursor(0)
    else:
      if c < 0: c = 0
      if c >= int32(g_MouseCursors.len): c = 0
      if c != g_LastMouseCursor:
        g_LastMouseCursor = c
        let hcur = g_MouseCursors[c]
        if hcur != 0: SetCursor(hcur) else: SetCursor(g_MouseCursors[0])
