# Package

version     = "1.91.9.0"
author      = "Leonardo Mariscal"
description = "Dear ImGui bindings for Nim"
license     = "MIT"
srcDir      = "src"
skipDirs    = @["tests"]

# Dependencies

requires "nim >= 1.0.0" # 1.0.0 promises that it will have backward compatibility

#const cimguiBuildDir = "src/imgui/private/cimgui/build"
#proc copyDll() =
#  var dllName:string
#  when defined(windows):
#    dllName = "/cimgui.dll"
#  else:
#    dllName = "/cimgui.so"
#  cpFile(cimguiBuildDir & dllName , "tests" & dllName)

#task cimgui, "Compiles cimgui":
#  var cmakeOpt:string
#  cmakeOpt &= " -DCMAKE_BUILD_TYPE=Release"
#  cmakeOpt &= " -DCMAKE_CXX_FLAGS_RELEASE=\"-DIMGUI_ENABLE_WIN32_DEFAULT_IME_FUNCTIONS\""
#  cmakeOpt &= " -DIMGUI_STATIC=no"
#  when defined(windows):
#    cmakeOpt &= " -DCMAKE_SHARED_LINKER_FLAGS=\"-static -static-libgcc -static-libstdc++\""
#    cmakeOpt &= " -G\"MSYS Makefiles\""
#  rmDir(cimguiBuildDir)
#  exec("cmake -S src/imgui/private/cimgui -B " & cimguiBuildDir  & cmakeOpt)
#  exec("cmake --build " & cimguiBuildDir)
#  copyDll()
#
#before install:
#  cimguiTask()

task gen, "Generate bindings from source":
  exec("nim c -r tools/generator.nim")

task test, "Create window with imgui demo":
  requires "nimgl@#1.0" # Please https://github.com/nim-lang/nimble/issues/482
  withDir "tests":
    exec("nim cpp -r test.nim")

task ci, "Create window with imgui null demo":
  requires "nimgl@#1.0" # Please https://github.com/nim-lang/nimble/issues/482
  withDir "tests":
    exec("nim cpp -r tnull.nim")
