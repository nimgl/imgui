# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

import os, strutils, streams, json,
       strformat, tables, algorithm

const srcHeader = """
## ImGUI Bindings
## ====
## WARNING: This is a generated file. Do not edit
## Any edits will be overwritten by the genearator.
##
## The aim is to achieve as much compatibility with C as possible.
## Optional helper functions have been created as a submodule
## ``imgui/imgui_helpers`` to better bind this library to Nim.
##
## You can check the original documentation `here <https://github.com/ocornut/imgui/blob/master/imgui.cpp>`_.
##
## Source language of ImGui is C++, since Nim is able to compile both to C
## and C++ you can select which compile target you wish to use. Note that to use
## the C backend you must supply a `cimgui <https://github.com/cimgui/cimgui>`_
## dynamic library file.
##
## HACK: If you are targeting Windows, be sure to compile the cimgui dll with
## visual studio and not with mingw.

import strutils

proc currentSourceDir(): string =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/../src/imgui/output/cimgui" & " -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1".}

when not defined(imguiSrc):
  when defined(windows):
    const imgui_dll* = "cimgui.dll"
  elif defined(macosx):
    const imgui_dll* = "cimgui.dylib"
  else:
    const imgui_dll* = "cimgui.so"
  {.passC: "-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS".}
  {.pragma: imgui_header, header: "cimgui.h".}
  {.pragma: imgui_lib, dynlib: imgui_dll, cdecl.}
else:
  {.compile: "private/cimgui/cimgui.cpp",
    compile: "private/cimgui/imgui/imgui.cpp",
    compile: "private/cimgui/imgui/imgui_draw.cpp",
    compile: "private/cimgui/imgui/imgui_demo.cpp",
    compile: "private/cimgui/imgui/imgui_widgets.cpp".}
  {.pragma: imgui_header, header: "../ncimgui.h".}
  {.pragma: imgui_lib, nodecl.}

"""

proc genEnums(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("type\n")

  for name, obj in data["enums"].pairs:
    output.add("  {name[0 ..< name.len - 1]}* {{.pure, size: int32.sizeof.}} = enum\n".fmt)
    var table: OrderedTable[int, string]
    for data in obj:
      var dataName = data["name"].getStr()
      dataName = dataName.replace("__", "_")
      dataName = dataName.split("_")[1]
      if dataName.endsWith("_"):
        dataName = dataName[0 ..< dataName.len - 1]
      if dataName == "COUNT":
        continue
      var dataValue = data["calc_value"].getInt()
      if table.hasKey(dataValue):
        echo "Enum {name[0 ..< name.len - 1]}.{dataName} already exists as {name[0 ..< name.len - 1]}.{table[dataValue]} with value {dataValue} skipping...".fmt
        continue
      table[dataValue] = dataName
    table.sort(system.cmp)
    for k, v in pairs(table):
      output.add("    {v} = {k}\n".fmt)

proc igGenerate*() =
  var output = srcHeader

  output.genEnums()

  #output.add("{.pop.}")
  writeFile("src/imgui.nim", output)

when isMainModule:
  igGenerate()
