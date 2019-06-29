# Package

version     = "0.3.6"
author      = "Leonardo Mariscal"
description = "ImGui bindings for Nim"
license     = "MIT"
srcDir      = "src"
skipDirs    = @["tests"]

# Dependencies

requires "nim >= 0.20.0"

task gen, "Generate bindings from source":
  exec("nim c -r tools/generator.nim")
