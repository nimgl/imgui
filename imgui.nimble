# Package

version     = "1.81.0"
author      = "Leonardo Mariscal"
description = "ImGui bindings for Nim"
license     = "MIT"
srcDir      = "src"
skipDirs    = @["tests"]

# Dependencies

requires "nim >= 1.0.0" # 1.0.0 promises that it will have backward compatibility

task gen, "Generate bindings from source":
  exec("nim c -r tools/generator.nim")

task test, "Create window with imgui demo":
  requires "nimgl@#1.0" # Please https://github.com/nim-lang/nimble/issues/482
  exec("nim c -r tests/test.nim") # requires cimgui.dll
  exec("nim cpp -r tests/test.nim")

task ci, "Create window with imgui null demo":
  requires "nimgl@#1.0" # Please https://github.com/nim-lang/nimble/issues/482
  exec("nim c -r tests/tnull.nim") # requires cimgui.dll
  exec("nim cpp -r tests/tnull.nim")
