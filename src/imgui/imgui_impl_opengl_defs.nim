
from macros import hint

when not declared(Imguiimplopengl3init):
  proc Imguiimplopengl3init*(glslversion: cstring): cint {.cdecl,
      importc: "ImGui_ImplOpenGL3_Init".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3init" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3shutdown):
  proc Imguiimplopengl3shutdown*(): void {.cdecl,
      importc: "ImGui_ImplOpenGL3_Shutdown".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3shutdown" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3newframe):
  proc Imguiimplopengl3newframe*(): void {.cdecl,
      importc: "ImGui_ImplOpenGL3_NewFrame".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3newframe" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3renderdrawdata):
  proc Imguiimplopengl3renderdrawdata*(drawdata: ptr cint): void {.cdecl,
      importc: "ImGui_ImplOpenGL3_RenderDrawData".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3renderdrawdata" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3createfontstexture):
  proc Imguiimplopengl3createfontstexture*(): cint {.cdecl,
      importc: "ImGui_ImplOpenGL3_CreateFontsTexture".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3createfontstexture" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3destroyfontstexture):
  proc Imguiimplopengl3destroyfontstexture*(): void {.cdecl,
      importc: "ImGui_ImplOpenGL3_DestroyFontsTexture".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3destroyfontstexture" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3createdeviceobjects):
  proc Imguiimplopengl3createdeviceobjects*(): cint {.cdecl,
      importc: "ImGui_ImplOpenGL3_CreateDeviceObjects".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3createdeviceobjects" &
        " already exists, not redeclaring")
when not declared(Imguiimplopengl3destroydeviceobjects):
  proc Imguiimplopengl3destroydeviceobjects*(): void {.cdecl,
      importc: "ImGui_ImplOpenGL3_DestroyDeviceObjects".}
else:
  static :
    hint("Declaration of " & "Imguiimplopengl3destroydeviceobjects" &
        " already exists, not redeclaring")