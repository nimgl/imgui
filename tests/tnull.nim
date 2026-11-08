import imgui, strformat

let version = igGetVersion()

igDebugCheckVersionAndDataLayout(version, ImGuiIO.sizeof().uint32,
                                 ImGuiStyle.sizeof().uint32, ImVec2.sizeof().uint32,
                                 ImVec4.sizeof().uint32, ImDrawVert.sizeof().uint32,
                                 ImDrawIdx.sizeof().uint32).assert()

echo "CreateContext() - {version}".fmt
let context = igCreateContext()
let io = igGetIO()
# No renderer backend in this headless test; declare texture support so the
# core does not demand a pre-built font atlas (ImGui 1.92+ texture API).
io.backendFlags = (io.backendFlags.int32 or ImGuiBackendFlags.RendererHasTextures.int32).ImGuiBackendFlags

for i in 0 ..< 20:
  echo "NewFrame() {i}".fmt

  io.displaySize.x = 1920
  io.displaySize.y = 1080
  io.deltaTime = 1.0f / 60.0f
  igNewFrame()

  var f = 0.0f
  igText("Hello World!")
  igSliderFloat("float", f.addr, 0.0f, 1.0f, "%.3f")
  igText("Applicaton average %.3f ms/frame (%.1f FPS)", 1000.0f / io.framerate, io.framerate)
  igShowDemoWindow(nil)

  igRender()

echo "DestroyContext()"
context.igDestroyContext()
