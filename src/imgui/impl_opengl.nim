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

  when defined(useFuthark):
    const ClangIncludePath = "c:/drvDx/msys32/mingw32/opt/llvm-15/lib/clang/15.0.7/include"
    import futhark
    importc:
      syspath ClangIncludePath
      path CImguiRootPath
      define "CIMGUI_USE_OPENGL3"
      # Important definition CIMGUI_API for Futhark 0.9.3
      define "CIMGUI_API"
      "generator/output/cimgui_impl.h"
      outputPath "imgui_impl_opengl_defs.nim"
  else:
    {.push discardable,hint[XDeclaredButNotUsed]:off,hint[User]:off.}
    include "imgui_impl_opengl_defs.nim"
    {.pop.}
    {.passC:"-I" & CImguiRootPath.}
    {.passC:"-I" & ImguiRootPath.}
    {.passC:"-DCIMGUI_USE_OPENGL3".}
    #{.passC:"-DCIMGUI_API=\"extern \"C\"\" ".}
    {.passC:"""  -DIMGUI_IMPL_API="extern \"C\" __declspec(dllexport)"  """.}
    {.compile:joinPath(ImguiRootPath,"backends","imgui_impl_opengl3.cpp").}

    {.push discardable.}
    proc igOpenGL3Init*(glslVersion:string): bool =
      if 0 != Imguiimplopengl3init(glslVersion.cstring):
        result = true
    proc igOpenGL3Init*(): bool =
      const glsl_version = "#version 130" # Default is OpenGL 3.3
      igOpenGl3Init(glsl_version)
    proc igOpenGL3Shutdown*() = Imguiimplopengl3destroydeviceobjects()
    proc igOpenGL3NewFrame*() = Imguiimplopengl3newframe()
    proc igOpenGL3RenderDrawData*(data: pointer): cint = Imguiimplopengl3renderdrawdata(cast[ptr cint](data))
    proc igOpengl3DestroyFontsTexture*(): cint = Imguiimplopengl3destroyfontstexture()
    proc igOpengl3DestroyDeviceObjects*(): cint = Imguiimplopengl3destroydeviceobjects()
    {.pop.}

