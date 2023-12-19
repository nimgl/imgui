# Modified: Added docking and transparent viewport options by audin (2023/10)
# Copyright 2019, NimGL contributors.

import imgui, imgui/[impl_opengl, impl_glfw]
import nimgl/[opengl, glfw]

#--------------
# Configration
#--------------

#  .--------------------------------------------..---------.-----------------------.------------
#  |         Combination of flags               ||         |     Viewport          |
#  |--------------------------------------------||---------|-----------------------|------------
#  | fViewport | fDocking | TransparentViewport || Docking | Transparent | Outside | Description
#  |:---------:|:--------:|:-------------------:||:-------:|:-----------:|:-------:| -----------
#  |  false    | false    |     false           ||    -    |     -       |   -     |
#  |  false    | true     |     false           ||    v    |     -       |   -     | (Default): Only docking
#  |  true     | -        |     false           ||    v    |     -       |   v     | Doncking and outside of viewport
#  |    -      | -        |     true            ||    v    |     v       |   -     | Transparent Viewport and docking
#  `-----------'----------'---------------------'`---------'-------------'---------'-------------
var
 fDocking = true
 fViewport = false
 TransparentViewport = false
 #
block:
  if TransparentViewport:
    fViewport = true
  if fViewport:
    fDocking = true

proc main() =
  doAssert glfwInit()

  glfwWindowHint(GLFWContextVersionMajor, 3)
  glfwWindowHint(GLFWContextVersionMinor, 3)
  glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE)
  glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
  glfwWindowHint(GLFWResizable, GLFW_TRUE)
  if TransparentViewport:
    glfwWindowHint(GLFWVisible, GLFW_FALSE)

  var w: GLFWWindow = glfwCreateWindow(1080, 720)
  if w == nil:
    quit(-1)

  w.makeContextCurrent()
  glfwSwapInterval(1) # Enable Vsync

  doAssert glInit()

  let context = igCreateContext()
  var pio = igGetIO()
  if fDocking:
    pio.configFlags = (pio.configFlags.cint or DockingEnable.cint).ImGuiConfigFlags
    if fViewport:
      pio.configFlags = (pio.configFlags.cint or ViewportsEnable.cint).ImGuiConfigFlags
      pio.configViewports_NoAutomerge = true

  doAssert igGlfwInitForOpenGL(w, true)
  doAssert igOpenGL3Init() # default: glsl_version = "#version 130"

  var clearColor:ImVec4
  if TransparentViewport:
    clearColor = ImVec4(x:0f, y:0f, z:0f, w:0.0f) # Transparent
  else:
    clearColor = ImVec4(x:0.25f, y:0.65f, z:0.85f, w:1.0f)

  igStyleColorsCherry()

  var show_demo: bool = true
  var showFirstWindow = true
  var somefloat: float32 = 0.0f
  var counter: int32 = 0

  while not w.windowShouldClose:
    glfwPollEvents()

    igOpenGL3NewFrame()
    igGlfwNewFrame()
    igNewFrame()

    if show_demo:
      igShowDemoWindow(show_demo.addr)

    if showFirstWindow:
      # Simple window
      igBegin("Hello, world!",showFirstWindow.addr)

      igText("This is some useful text.")
      igCheckbox("Demo Window", show_demo.addr)

      igSliderFloat("float", somefloat.addr, 0.0f, 1.0f)

      if igButton("Button", ImVec2(x: 0, y: 0)):
        counter.inc
      igSameLine()
      igText("counter = %d", counter)

      igText("Application average %.3f ms/frame (%.1f FPS)", 1000.0f / igGetIO().framerate, igGetIO().framerate)
      igEnd()
      # End simple window

    igRender()

    glClearColor(clearColor.x,clearColor.y,clearColor.z,clearColor.w)
    glClear(GL_COLOR_BUFFER_BIT)
    igOpenGL3RenderDrawData(igGetDrawData())

    if 0 != (pio.configFlags.cint and ViewportsEnable.cint):
      var backup_current_window = glfwGetCurrentContext()
      igUpdatePlatformWindows()
      igRenderPlatformWindowsDefault(nil, nil)
      backup_current_window.makeContextCurrent()

    w.swapBuffers()
    if not showFirstWindow and not show_demo:
      w.setWindowShouldClose(true) # End program

  igOpenGL3Shutdown()
  igGlfwShutdown()
  context.igDestroyContext()

  w.destroyWindow()
  glfwTerminate()

main()
