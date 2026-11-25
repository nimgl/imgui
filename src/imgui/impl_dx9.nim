when not defined(cpp) or defined(cimguiDLL):
  include "private/impl_dx9.nim"
else:
  import std/[os,strutils]
  import ../imgui

  proc currentSourceDir(): string {.compileTime.} =
    result = currentSourcePath().replace("\\", "/")
    result = result[0 ..< result.rfind("/")]

  const CImguiRootPath = joinpath(currentSourceDir(), "private/cimgui")
  const ImguiRootPath  = joinPath(CImguiRootPath, "imgui")
  {.passC:"-I" & CImguiRootPath.}
  {.passC:"-I" & ImguiRootPath.}
  {.passC:"""-DCIMGUI_API="extern \"C\" " """.}
  {.passC:"""-DIMGUI_IMPL_API="extern \"C\" __declspec(dllexport)"  """.}
  {.compile:joinPath(ImguiRootPath, "backends", "imgui_impl_dx9.cpp").}

  proc ImGui_ImplDX9_Init(device: pointer): bool {.cdecl, importc: "ImGui_ImplDX9_Init".}

  proc igDX9Init*(device: pointer): bool {.discardable.} =
    ## `device` is an IDirect3DDevice9*. Any `ptr` type converts to it.
    ImGui_ImplDX9_Init(device)
  proc igDX9Shutdown*() {.cdecl, importc: "ImGui_ImplDX9_Shutdown".}
  proc igDX9NewFrame*() {.cdecl, importc: "ImGui_ImplDX9_NewFrame".}
  proc igDX9RenderDrawData*(drawData: ptr ImDrawData) {.cdecl, importc: "ImGui_ImplDX9_RenderDrawData".}
  proc igDX9CreateDeviceObjects*(): bool {.cdecl, importc: "ImGui_ImplDX9_CreateDeviceObjects", discardable.}
  proc igDX9InvalidateDeviceObjects*() {.cdecl, importc: "ImGui_ImplDX9_InvalidateDeviceObjects".}
  proc igDX9UpdateTexture*(tex: ptr ImTextureData) {.cdecl, importc: "ImGui_ImplDX9_UpdateTexture".}
