when not defined(cpp) or defined(cimguiDLL):
  include "private/impl_opengl.nim"
else:
  import std/[os,strutils]
  proc currentSourceDir(): string {.compileTime.} =
    result = currentSourcePath().replace("\\", "/")
    result = result[0 ..< result.rfind("/")]

  # Set source paths
  const CImguiRootPath  = joinpath(currentSourceDir() ,"private/cimgui")
  const ImguiRootPath   = joinPath(CImguiRootPath,"imgui")

  {.passC:"-I" & CImguiRootPath.}
  {.passC:"-I" & ImguiRootPath.}
  {.passC:"-DCIMGUI_USE_OPENGL3".}
  #{.passC:"-DCIMGUI_API=\"extern \"C\"\" ".}
  {.passC:"""  -DIMGUI_IMPL_API="extern \"C\" __declspec(dllexport)"  """.}
  {.compile:joinPath(ImguiRootPath,"backends","imgui_impl_opengl3.cpp").}

  {.push discardable.}
  proc ImGuiImplopengl3Init*(glslversion: cstring): cint         {.cdecl, importc: "ImGui_ImplOpenGL3_Init".}
  proc ImGuiImplopengl3RenderDrawData*(drawdata: ptr cint): void {.cdecl, importc: "ImGui_ImplOpenGL3_RenderDrawData".}
  #
  proc igOpenGL3Init*(glslVersion:string): bool =
    0 != ImGuiImplOpengl3Init(glslVersion.cstring)
  proc igOpenGL3Init*(): bool =
    const glsl_version = "#version 130" # Default is OpenGL 3.0
    igOpenGl3Init(glsl_version)
  proc igOpenGL3Shutdown*() : void {.cdecl, importc: "ImGui_ImplOpenGL3_Shutdown".}
  proc igOpenGL3NewFrame*() : void {.cdecl, importc: "ImGui_ImplOpenGL3_NewFrame".}
  proc igOpenGL3RenderDrawData*(data: pointer): cint =
    ImGuiImplOpengl3RenderDrawData(cast[ptr cint](data))
  proc igOpengl3CreateFontsTexture*():  cint {.cdecl, importc: "ImGui_ImplOpenGL3_CreateFontsTexture".}
  proc igOpengl3DestroyFontsTexture*(): void {.cdecl, importc: "ImGui_ImplOpenGL3_DestroyFontsTexture".}
  proc igOpengl3CreateDeviceObjects*(): cint {.cdecl, importc: "ImGui_ImplOpenGL3_CreateDeviceObjects".}
  proc igOpengl3DestroyDeviceObjects*():void {.cdecl, importc: "ImGui_ImplOpenGL3_DestroyDeviceObjects".}
  {.pop.}

#[ igOpenGl3Init(glsl_version)
//----------------------------------------
// OpenGL    GLSL      GLSL
// version   version   string
//----------------------------------------
//  2.0       110       "#version 110"
//  2.1       120       "#version 120"
//  3.0       130       "#version 130"
//  3.1       140       "#version 140"
//  3.2       150       "#version 150"
//  3.3       330       "#version 330 core"
//  4.0       400       "#version 400 core"
//  4.1       410       "#version 410 core"
//  4.2       420       "#version 410 core"
//  4.3       430       "#version 430 core"
//  ES 2.0    100       "#version 100"      = WebGL 1.0
//  ES 3.0    300       "#version 300 es"   = WebGL 2.0
//----------------------------------------
]#
