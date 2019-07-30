# Package

version     = "1.72.0"
author      = "Leonardo Mariscal"
description = "ImGui bindings for Nim"
license     = "MIT"
srcDir      = "src"
skipDirs    = @["tests"]

# Dependencies

requires "nim >= 0.20.0"

task gen, "Generate bindings from source":
  exec("nim c -r tools/generator.nim")

task test, "Create window with imgui demo":
  requires "nimgl@#1.0" # Please https://github.com/nim-lang/nimble/issues/482
  exec("nim c -r test/timgui.nim") # requires cimgui.dll
  exec("nim cpp -d:imguiSrc -r test/timgui.nim")
