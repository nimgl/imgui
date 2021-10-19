import imgui, strformat

let version = igGetVersion()

igDebugCheckVersionAndDataLayout(version, ImGuiIO.sizeof().uint32,
                                 ImGuiStyle.sizeof().uint32, ImVec2.sizeof().uint32,
                                 ImVec4.sizeof().uint32, ImDrawVert.sizeof().uint32,
                                 ImDrawIdx.sizeof().uint32).assert()

echo "CreateContext() - {version}".fmt
igCreateContext(nil)
let io = igGetIO()

var text_pixels: ptr uint8 = nil
var text_w: int32
var text_h: int32
io.fonts.getTexDataAsRGBA32(text_pixels.addr, text_w.addr, text_h.addr, nil)

for i in 0 ..< 20:
  echo "NewFrame() {i}".fmt

  var display_size: ImVec2
  display_size.x = 1920
  display_size.y = 1080
  io.displaySize = display_size
  io.deltaTime = 1.0f / 60.0f
  igNewFrame()

  var f = 0.0f
  igText("Hello World!")
  igSliderFloat("float", f.addr, 0.0f, 1.0f, "%.3f")
  igText("Applicaton average %.3f ms/frame (%.1f FPS)", 1000.0f / io.framerate, io.framerate)
  igShowDemoWindow(nil)

  igRender()

echo "DestroyContext()"
igDestroyContext(nil)
