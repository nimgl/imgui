when not defined(cpp) or defined(cimguiDLL):
  include "private/impl_win32.nim"
else:
  import std/[os,strutils]

  proc currentSourceDir(): string {.compileTime.} =
    result = currentSourcePath().replace("\\", "/")
    result = result[0 ..< result.rfind("/")]

  const CImguiRootPath = joinpath(currentSourceDir(), "private/cimgui")
  const ImguiRootPath  = joinPath(CImguiRootPath, "imgui")
  {.passC:"-I" & CImguiRootPath.}
  {.passC:"-I" & ImguiRootPath.}
  {.passC:"""-DCIMGUI_API="extern \"C\" " """.}
  {.compile:joinPath(currentSourceDir(), "private", "imgui_impl_win32_c.cpp").}
  when not defined(vcc):
    {.passL: "-lgdi32 -ldwmapi".}

  proc ImGui_ImplWin32_Init(hwnd: pointer): bool {.cdecl, importc: "ImGui_ImplWin32_Init".}
  proc ImGui_ImplWin32_InitForOpenGL(hwnd: pointer): bool {.cdecl, importc: "ImGui_ImplWin32_InitForOpenGL".}
  proc ImGui_ImplWin32_WndProcHandler(hwnd: pointer, msg: uint32, wParam: uint, lParam: int): int {.cdecl, importc: "ImGui_ImplWin32_WndProcHandler".}
  proc ImGui_ImplWin32_GetDpiScaleForHwnd(hwnd: pointer): float32 {.cdecl, importc: "ImGui_ImplWin32_GetDpiScaleForHwnd".}

  proc igWin32Init*(hwnd: pointer | SomeInteger): bool {.discardable.} =
    ImGui_ImplWin32_Init(cast[pointer](hwnd))
  proc igWin32InitForOpenGL*(hwnd: pointer | SomeInteger): bool {.discardable.} =
    ImGui_ImplWin32_InitForOpenGL(cast[pointer](hwnd))
  proc igWin32Shutdown*() {.cdecl, importc: "ImGui_ImplWin32_Shutdown".}
  proc igWin32NewFrame*() {.cdecl, importc: "ImGui_ImplWin32_NewFrame".}

  proc igWin32WndProcHandler*[H: pointer | SomeInteger; M, W, L: SomeInteger](hwnd: H, msg: M, wParam: W, lParam: L): int =
    ## Returns non-zero when ImGui used the message.
    ImGui_ImplWin32_WndProcHandler(cast[pointer](hwnd), uint32(msg), cast[uint](wParam), cast[int](lParam))

  proc igWin32EnableDpiAwareness*() {.cdecl, importc: "ImGui_ImplWin32_EnableDpiAwareness".}
  proc igWin32GetDpiScaleForMonitor*(monitor: pointer): float32 {.cdecl, importc: "ImGui_ImplWin32_GetDpiScaleForMonitor".}
  proc igWin32GetDpiScaleForHwnd*(hwnd: pointer | SomeInteger): float32 =
    ImGui_ImplWin32_GetDpiScaleForHwnd(cast[pointer](hwnd))
