# Copyright 2018, NimGL contributors.

## ImGUI GLFW Implementation
## ====
## Implementation based on the imgui examples implementations.
## Feel free to use and modify this implementation.
## This needs to be used along with a Renderer.

import ../../imgui, nimgl/glfw

when defined(windows):
  import nimgl/glfw/native

type
  GlfwClientApi = enum
    igGlfwClientApiUnkown
    igGlfwClientApiOpenGl
    igGlfwClientApiVulkan

var
  gWindow: GLFWwindow
  gClientApi = igGlfwClientApiUnkown
  gTime: float64 = 0.0f
  gMouseJustPressed: array[5, bool]
  gMouseCursors: array[ImGuiMouseCursor.high.int32 + 1, GLFWCursor]

  # Store previous callbacks so they can be chained
  gPrevMouseButtonCallback: GLFWMousebuttonFun = nil
  gPrevScrollCallback: GLFWScrollFun = nil
  gPrevKeyCallback: GLFWKeyFun = nil
  gPrevCharCallback: GLFWCharFun = nil

proc igGlfwGetClipboardText(ctx: ptr ImGuiContext): cstringconst {.cdecl.} =
  return getClipboardString(nil)

proc igGlfwSetClipboardText(ctx: ptr ImGuiContext, text: cstringconst) {.cdecl.} =
  when not defined(emscripten):
    setClipboardString(nil, text)

proc igGlfwMouseCallback*(window: GLFWWindow, button: int32, action: int32, mods: int32) {.cdecl.} =
  if gPrevMouseButtonCallback != nil:
    gPrevMouseButtonCallback(window, button, action, mods)

  if action == GLFWPress and button.ord >= 0 and button.ord < gMouseJustPressed.len:
    gMouseJustPressed[button.ord] = true

proc igGlfwScrollCallback*(window: GLFWWindow, xoff: float64, yoff: float64) {.cdecl.} =
  if gPrevScrollCallback != nil:
    gPrevScrollCallback(window, xoff, yoff)

  let io = igGetIO()
  io.mouseWheelH += xoff.float32
  io.mouseWheel += yoff.float32

proc keyToImGuiKey(key: int32): ImGuiKey =
    return case key:
    of GlfwKey.TAB: ImGuiKey.Tab
    of GlfwKey.LEFT: ImGuiKey.LeftArrow
    of GlfwKey.RIGHT: ImGuiKey.RightArrow
    of GlfwKey.UP: ImGuiKey.UpArrow
    of GlfwKey.DOWN: ImGuiKey.DownArrow
    of GlfwKey.PAGE_UP: ImGuiKey.PageUp
    of GlfwKey.PAGE_DOWN: ImGuiKey.PageDown
    of GlfwKey.HOME: ImGuiKey.Home
    of GlfwKey.END: ImGuiKey.End
    of GlfwKey.INSERT: ImGuiKey.Insert
    of GlfwKey.DELETE: ImGuiKey.Delete
    of GlfwKey.BACKSPACE: ImGuiKey.Backspace
    of GlfwKey.SPACE: ImGuiKey.Space
    of GlfwKey.ENTER: ImGuiKey.Enter
    of GlfwKey.ESCAPE: ImGuiKey.Escape
    of GlfwKey.APOSTROPHE: ImGuiKey.Apostrophe
    of GlfwKey.COMMA: ImGuiKey.Comma
    of GlfwKey.MINUS: ImGuiKey.Minus
    of GlfwKey.PERIOD: ImGuiKey.Period
    of GlfwKey.SLASH: ImGuiKey.Slash
    of GlfwKey.SEMICOLON: ImGuiKey.Semicolon
    of GlfwKey.EQUAL: ImGuiKey.Equal
    of GlfwKey.LEFT_BRACKET: ImGuiKey.LeftBracket
    of GlfwKey.BACKSLASH: ImGuiKey.Backslash
    of GlfwKey.RIGHT_BRACKET: ImGuiKey.RightBracket
    of GlfwKey.GRAVE_ACCENT: ImGuiKey.GraveAccent
    of GlfwKey.CAPS_LOCK: ImGuiKey.CapsLock
    of GlfwKey.SCROLL_LOCK: ImGuiKey.ScrollLock
    of GlfwKey.NUM_LOCK: ImGuiKey.NumLock
    of GlfwKey.PRINT_SCREEN: ImGuiKey.PrintScreen
    of GlfwKey.PAUSE: ImGuiKey.Pause
    of GlfwKey.KP_0: ImGuiKey.Keypad0
    of GlfwKey.KP_1: ImGuiKey.Keypad1
    of GlfwKey.KP_2: ImGuiKey.Keypad2
    of GlfwKey.KP_3: ImGuiKey.Keypad3
    of GlfwKey.KP_4: ImGuiKey.Keypad4
    of GlfwKey.KP_5: ImGuiKey.Keypad5
    of GlfwKey.KP_6: ImGuiKey.Keypad6
    of GlfwKey.KP_7: ImGuiKey.Keypad7
    of GlfwKey.KP_8: ImGuiKey.Keypad8
    of GlfwKey.KP_9: ImGuiKey.Keypad9
    of GlfwKey.KP_DECIMAL: ImGuiKey.KeypadDecimal
    of GlfwKey.KP_DIVIDE: ImGuiKey.KeypadDivide
    of GlfwKey.KP_MULTIPLY: ImGuiKey.KeypadMultiply
    of GlfwKey.KP_SUBTRACT: ImGuiKey.KeypadSubtract
    of GlfwKey.KP_ADD: ImGuiKey.KeypadAdd
    of GlfwKey.KP_ENTER: ImGuiKey.KeypadEnter
    of GlfwKey.KP_EQUAL: ImGuiKey.KeypadEqual
    of GlfwKey.LEFT_SHIFT: ImGuiKey.LeftShift
    of GlfwKey.LEFT_CONTROL: ImGuiKey.LeftCtrl
    of GlfwKey.LEFT_ALT: ImGuiKey.LeftAlt
    of GlfwKey.LEFT_SUPER: ImGuiKey.LeftSuper
    of GlfwKey.RIGHT_SHIFT: ImGuiKey.RightShift
    of GlfwKey.RIGHT_CONTROL: ImGuiKey.RightCtrl
    of GlfwKey.RIGHT_ALT: ImGuiKey.RightAlt
    of GlfwKey.RIGHT_SUPER: ImGuiKey.RightSuper
    of GlfwKey.MENU: ImGuiKey.Menu
    of GlfwKey.K0: ImGuiKey.`0`
    of GlfwKey.K1: ImGuiKey.`1`
    of GlfwKey.K2: ImGuiKey.`2`
    of GlfwKey.K3: ImGuiKey.`3`
    of GlfwKey.K4: ImGuiKey.`4`
    of GlfwKey.K5: ImGuiKey.`5`
    of GlfwKey.K6: ImGuiKey.`6`
    of GlfwKey.K7: ImGuiKey.`7`
    of GlfwKey.K8: ImGuiKey.`8`
    of GlfwKey.K9: ImGuiKey.`9`
    of GlfwKey.A: ImGuiKey.A
    of GlfwKey.B: ImGuiKey.B
    of GlfwKey.C: ImGuiKey.C
    of GlfwKey.D: ImGuiKey.D
    of GlfwKey.E: ImGuiKey.E
    of GlfwKey.F: ImGuiKey.F
    of GlfwKey.G: ImGuiKey.G
    of GlfwKey.H: ImGuiKey.H
    of GlfwKey.I: ImGuiKey.I
    of GlfwKey.J: ImGuiKey.J
    of GlfwKey.K: ImGuiKey.K
    of GlfwKey.L: ImGuiKey.L
    of GlfwKey.M: ImGuiKey.M
    of GlfwKey.N: ImGuiKey.N
    of GlfwKey.O: ImGuiKey.O
    of GlfwKey.P: ImGuiKey.P
    of GlfwKey.Q: ImGuiKey.Q
    of GlfwKey.R: ImGuiKey.R
    of GlfwKey.S: ImGuiKey.S
    of GlfwKey.T: ImGuiKey.T
    of GlfwKey.U: ImGuiKey.U
    of GlfwKey.V: ImGuiKey.V
    of GlfwKey.W: ImGuiKey.W
    of GlfwKey.X: ImGuiKey.X
    of GlfwKey.Y: ImGuiKey.Y
    of GlfwKey.Z: ImGuiKey.Z
    of GlfwKey.F1: ImGuiKey.F1
    of GlfwKey.F2: ImGuiKey.F2
    of GlfwKey.F3: ImGuiKey.F3
    of GlfwKey.F4: ImGuiKey.F4
    of GlfwKey.F5: ImGuiKey.F5
    of GlfwKey.F6: ImGuiKey.F6
    of GlfwKey.F7: ImGuiKey.F7
    of GlfwKey.F8: ImGuiKey.F8
    of GlfwKey.F9: ImGuiKey.F9
    of GlfwKey.F10: ImGuiKey.F10
    of GlfwKey.F11: ImGuiKey.F11
    of GlfwKey.F12: ImGuiKey.F12
    of GlfwKey.F13: ImGuiKey.F13
    of GlfwKey.F14: ImGuiKey.F14
    of GlfwKey.F15: ImGuiKey.F15
    of GlfwKey.F16: ImGuiKey.F16
    of GlfwKey.F17: ImGuiKey.F17
    of GlfwKey.F18: ImGuiKey.F18
    of GlfwKey.F19: ImGuiKey.F19
    of GlfwKey.F20: ImGuiKey.F20
    of GlfwKey.F21: ImGuiKey.F21
    of GlfwKey.F22: ImGuiKey.F22
    of GlfwKey.F23: ImGuiKey.F23
    of GlfwKey.F24: ImGuiKey.F24
    else: ImGuiKey.None

proc updateKeyModifiers(window: GLFWWindow) =
  let io = igGetIO()
  when not defined(emscripten):
    io.addKeyEvent(ImGuiKey.Ctrl, window.getKey(GLFWKey.LeftControl) == GlfwPress or window.getKey(GLFWKey.RightControl) == GlfwPress)
    io.addKeyEvent(ImGuiKey.Shift, window.getKey(GLFWKey.LeftShift) == GlfwPress or window.getKey(GLFWKey.RightShift) == GlfwPress)
    io.addKeyEvent(ImGuiKey.Alt, window.getKey(GLFWKey.LeftAlt) == GlfwPress or window.getKey(GLFWKey.RightAlt) == GlfwPress)
    io.addKeyEvent(ImGuiKey.Super, window.getKey(GLFWKey.LeftSuper) == GlfwPress or window.getKey(GLFWKey.RightSuper) == GlfwPress)

proc translateUntranslatedKey(key: int32, scancode: int32): int32 =
  when declared(glfwGetKeyName):
    if key >= GLFWKey.Kp0.ord and key <= GLFWKey.KpEqual.ord:
      return key
    let prevErrorCallback = glfwSetErrorCallback(nil)
    let keyName = glfwGetKeyName(key, scancode)
    discard glfwSetErrorCallback(prevErrorCallback)
    when not defined(emscripten):
      discard glfwGetError(nil)
    if keyName.len == 1 and keyName[0] != '\0':
      var key = key
      const char_names = "`-=[]\\,;'./"
      const char_keys = [
        GlfwKey.GRAVE_ACCENT, GlfwKey.MINUS, GlfwKey.EQUAL, GlfwKey.LEFT_BRACKET,
        GlfwKey.RIGHT_BRACKET, GlfwKey.BACKSLASH, GlfwKey.COMMA, GlfwKey.SEMICOLON,
        GlfwKey.APOSTROPHE, GlfwKey.PERIOD, GlfwKey.SLASH
      ]
      static: doAssert char_names.len == char_keys.len
      if   keyName[0] >= '0' and keyName[0] <= '9':      key = int32 GlfwKey.K0.ord + (keyName[0].ord - '0'.ord)
      elif keyName[0] >= 'A' and keyName[0] <= 'Z':      key = int32 GlfwKey.A.ord + (keyName[0].ord - 'A'.ord)
      elif keyName[0] >= 'a' and keyName[0] <= 'z':      key = int32 GlfwKey.A.ord + (keyName[0].ord - 'a'.ord)
      elif (let p = char_names.find(keyName[0]); p != -1):    key = char_keys[p]

  return key


proc igGlfwKeyCallback*(window: GLFWWindow, keycode: int32, scancode: int32, action: int32, mods: int32) {.cdecl.} =
  if gPrevKeyCallback != nil:
    gPrevKeyCallback(window, keycode, scancode, action, mods)

  if action != GLFW_PRESS and action != GLFW_RELEASE:
    return

  window.updateKeyModifiers()

  let keycode = translateUntranslatedKey(keycode, scancode)

  let io = igGetIO()
  let imguiKey = keyToImguiKey(keycode)
  when not defined(emscripten):
    io.addKeyEvent(imguiKey, action == GLFW_PRESS)
    io.setKeyEventNativeData(imguiKey, keycode, scancode) # To support legacy indexing (<1.87 user code)

proc igGlfwCharCallback*(window: GLFWWindow, code: uint32) {.cdecl.} =
  if gPrevCharCallback != nil:
    gPrevCharCallback(window, code)

  let io = igGetIO()
  if code > 0'u32 and code < 0x10000'u32:
    io.addInputCharacter(cast[ImWchar](code))

proc igGlfwInstallCallbacks(window: GLFWwindow) =
  # The already set callback proc should be returned. Store these and and chain callbacks.
  gPrevMouseButtonCallback = gWindow.setMouseButtonCallback(igGlfwMouseCallback)
  gPrevScrollCallback = gWindow.setScrollCallback(igGlfwScrollCallback)
  gPrevKeyCallback = gWindow.setKeyCallback(igGlfwKeyCallback)
  gPrevCharCallback = gWindow.setCharCallback(igGlfwCharCallback)

proc igGlfwInit(window: GLFWwindow, installCallbacks: bool, clientApi: GlfwClientApi): bool =
  gWindow = window
  gTime = 0.0f

  let io = igGetIO()
  io.backendFlags = (io.backendFlags.int32 or ImGuiBackendFlags.HasMouseCursors.int32).ImGuiBackendFlags
  io.backendFlags = (io.backendFlags.int32 or ImGuiBackendFlags.HasSetMousePos.int32).ImGuiBackendFlags

  let platformIO = igGetPlatformIO()
  platformIO.platform_SetClipboardTextFn = igGlfwSetClipboardText
  platformIO.platform_GetClipboardTextFn = igGlfwGetClipboardText
  platformIO.platform_ClipboardUserData = gWindow
  # TODO: Use PlatformHandleRaw instead
  # when defined windows:
  #   io.imeWindowHandle = gWindow.getWin32Window()

  gMouseCursors[ImGuiMouseCursor.Arrow.int32] = glfwCreateStandardCursor(GLFWArrowCursor)
  gMouseCursors[ImGuiMouseCursor.TextInput.int32] = glfwCreateStandardCursor(GLFWIbeamCursor)
  gMouseCursors[ImGuiMouseCursor.ResizeAll.int32] = glfwCreateStandardCursor(GLFWArrowCursor)
  gMouseCursors[ImGuiMouseCursor.ResizeNS.int32] = glfwCreateStandardCursor(GLFWVresizeCursor)
  gMouseCursors[ImGuiMouseCursor.ResizeEW.int32] = glfwCreateStandardCursor(GLFWHresizeCursor)
  gMouseCursors[ImGuiMouseCursor.ResizeNESW.int32] = glfwCreateStandardCursor(GLFWArrowCursor)
  gMouseCursors[ImGuiMouseCursor.ResizeNWSE.int32] = glfwCreateStandardCursor(GLFWArrowCursor)
  gMouseCursors[ImGuiMouseCursor.Hand.int32] = glfwCreateStandardCursor(GLFWHandCursor)

  if installCallbacks:
    igGlfwInstallCallbacks(window)

  gClientApi = clientApi
  return true

proc igGlfwInitForOpenGL*(window: GLFWwindow, installCallbacks: bool): bool =
  igGlfwInit(window, installCallbacks, igGlfwClientApiOpenGL)

# @TODO: Vulkan support

proc igGlfwUpdateMousePosAndButtons() =
  let io = igGetIO()
  for i in 0 ..< io.mouseDown.len:
    io.mouseDown[i] = gMouseJustPressed[i] or gWindow.getMouseButton(i.int32) != 0
    gMouseJustPressed[i] = false

  let mousePosBackup = io.mousePos
  io.mousePos = ImVec2(x: -high(float32), y: -high(float32))

  when defined(emscripten): # TODO: actually add support for all the library with emscripten
    let focused = true
  else:
    let focused = gWindow.getWindowAttrib(GLFWFocused) != 0

  if focused:
    if io.wantSetMousePos:
      gWindow.setCursorPos(mousePosBackup.x, mousePosBackup.y)
    else:
      var mouseX: float64
      var mouseY: float64
      gWindow.getCursorPos(mouseX.addr, mouseY.addr)
      io.mousePos = ImVec2(x: mouseX.float32, y: mouseY.float32)

proc igGlfwUpdateMouseCursor() =
  let io = igGetIO()
  if ((io.configFlags.int32 and ImGuiConfigFlags.NoMouseCursorChange.int32) == 1) or (gWindow.getInputMode(GLFWCursorSpecial) == GLFWCursorDisabled):
    return

  var igCursor: ImGuiMouseCursor = igGetMouseCursor()
  if igCursor == ImGuiMouseCursor.None or io.mouseDrawCursor:
    gWindow.setInputMode(GLFWCursorSpecial, GLFWCursorHidden)
  else:
    gWindow.setCursor(gMouseCursors[igCursor.int32])
    gWindow.setInputMode(GLFWCursorSpecial, GLFWCursorNormal)

proc igGlfwNewFrame*() =
  let io = igGetIO()
  assert io.fonts.isBuilt()

  var w: int32
  var h: int32
  var displayW: int32
  var displayH: int32

  gWindow.getWindowSize(w.addr, h.addr)
  gWindow.getFramebufferSize(displayW.addr, displayH.addr)
  io.displaySize = ImVec2(x: w.float32, y: h.float32)
  io.displayFramebufferScale = ImVec2(x: if w > 0: displayW.float32 / w.float32 else: 0.0f, y: if h > 0: displayH.float32 / h.float32 else: 0.0f)

  let currentTime = glfwGetTime()
  io.deltaTime = if gTime > 0.0f: (currentTime - gTime).float32 else: (1.0f / 60.0f).float32
  gTime = currentTime

  igGlfwUpdateMousePosAndButtons()
  igGlfwUpdateMouseCursor()

  # @TODO: gamepad mapping

proc igGlfwShutdown*() =
  for i in 0 ..< ImGuiMouseCursor.high.int32 + 1:
    gMouseCursors[i].destroyCursor()
    gMouseCursors[i] = nil
  gClientApi = igGlfwClientApiUnkown
