# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

const srcHeader* = """
# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

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
else:
  {.compile: "private/cimgui/cimgui.cpp",
    compile: "private/cimgui/imgui/imgui.cpp",
    compile: "private/cimgui/imgui/imgui_draw.cpp",
    compile: "private/cimgui/imgui/imgui_demo.cpp",
    compile: "private/cimgui/imgui/imgui_widgets.cpp".}
  {.pragma: imgui_header, header: "../ncimgui.h".}
"""

const notDefinedStructs* = """
  ImVector*[T] = object # Should I importc a generic?
    size*: int32
    capacity*: int32
    data*: UncheckedArray[T]
  ImPairData* {.union.} = object
    val_i*: int32 # Breaking naming convetion to denote "low level"
    val_f*: float32
    val_p*: pointer
  ImPair* {.importc: "Pair", imgui_header.} = object
    key*: ImGuiID
    data*: ImPairData
  ImDrawListSharedData* {.importc: "ImDrawListSharedData", imgui_header.} = object
  ImGuiContext* {.importc: "ImGuiContext", imgui_header.} = object
"""

const preProcs* = """
# Procs
when not defined(imguiSrc):
  {.push dynlib: imgui_dll, cdecl, discardable.}
else:
  {.push nodecl, discardable.}
"""

let reservedWordsDictionary* = [
"end", "type", "out"
]

let blackListProc* = [
"ImVector_back", "ImVector_begin", "ImVector_ImWchar_back",
"ImVector_ImWchar_begin", "ImVector_ImWchar_capacity", "ImVector_ImWchar_clear",
"ImVector_ImWchar_contains", "ImVector_ImWchar_destroy",
"ImVector_ImWchar_empty", "ImVector_ImWchar_end", "ImVector_ImWchar_erase",
"ImVector_ImWchar_erase_unsorted", "ImVector_ImWchar_front",
"ImVector_ImWchar_index_from_ptr", "ImVector_ImWchar_insert",
"ImVector_ImWchar_pop_back", "ImVector_ImWchar_push_back",
"ImVector_ImWchar_push_front", "ImVector_ImWchar_reserve",
"ImVector_ImWchar_reserve", "ImVector_ImWchar_resize", "ImVector_ImWchar_size",
"ImVector_ImWchar_size_in_bytes", "ImVector_ImWchar_swap",
"ImVector_ImWchar__grow_capacity"
]
