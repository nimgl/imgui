# Set source path
when not defined(cpp) or defined(cimguiDLL):
  include "private/impl_glfw.nim"
else:
  import std/[os,strutils]
  import nimgl/[glfw]

  proc currentSourceDir(): string {.compileTime.} =
    result = currentSourcePath().replace("\\", "/")
    result = result[0 ..< result.rfind("/")]

  const CImguiRootPath      = joinpath(currentSourceDir() ,"private/cimgui")
  const ImguiRootPath       = joinPath(CImguiRootPath,"imgui")
  {.passC:"-I" & CImguiRootPath.}
  {.passC:"-I" & ImguiRootPath.}
  {.passC:"-DCIMGUI_USE_OPENGL3".}
  {.passC:"""-DCIMGUI_API="extern \"C\" " """.}
  {.passC:"""-DIMGUI_IMPL_API="extern \"C\" " """.}
  #{.passC:"""-DIMGUI_IMPL_API="extern \"C\" __declspec(dllexport)"  """.}
  {.compile:joinPath(ImguiRootPath,"backends","imgui_impl_glfw.cpp").}

  #--------------
  # Public procs
  #--------------
  proc igGlfwInitForOpenGL*(window: Glfwwindow; installcallbacks: bool): bool {.cdecl, importc: "ImGui_ImplGlfw_InitForOpenGL".}
  proc igGlfwNewFrame*(): void {.cdecl, importc: "ImGui_ImplGlfw_NewFrame".}
  proc igGlfwShutDown*(): void {.cdecl, importc: "ImGui_ImplGlfw_Shutdown".}
