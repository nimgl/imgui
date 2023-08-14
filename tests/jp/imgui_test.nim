# 2023/07 modified
# 2023/02 first
# written by audin.
#
# For Windows10.
# For Linux Debian 11 Bullseye,
#   $ sudo apt install xorg-dev libopengl-dev ibgl1-mesa-glx libgl1-mesa-dev

import imgui, imgui/[impl_opengl, impl_glfw]
import nimgl/[opengl, glfw]
#
import std/[os, strutils]
when defined(windows):
  import osDialog
include "setupFonts.nim"

# メインウインドウのサイズ
const MainWinWidth = 1080
const MainWinHeight = 800

# Global variables
var
  show_demo: bool = true # デモ表示 可否
  glfwWin: GLFWWindow
  sActiveFontName,sActiveFontTitle:string
  fExistMultbytesFonts = false

var sBuf{.global.}:string  = newString(200)

# Forward definition
proc winMain(hWin:GLFWWindow)
proc startSimpleWindow()

#--------------
# main
#--------------
proc main() =
  # GLFWの初期化 開始
  doAssert glfwInit()
  defer: glfwTerminate()

  glfwWindowHint(GLFWContextVersionMajor, 3)
  glfwWindowHint(GLFWContextVersionMinor, 3)
  glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE)
  glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
  glfwWindowHint(GLFWResizable, GLFW_TRUE)

  glfwWin = glfwCreateWindow(MainWinWidth, MainWinHeight)
  if glfwWin.isNil:
    quit(-1)
  glfwWin.makeContextCurrent()
  defer: glfwWin.destroyWindow()

  glfwSwapInterval(1) # Enable vsync 画面の更新頻度 CPU負荷を低減

  doAssert glInit()
  # ImGuiの初期化 開始
  let context = igCreateContext()
  defer: context.igDestroyContext()

  # バックエンドは  GLFW + OpenGL
  doAssert igGlfwInitForOpenGL(glfwWin, true)
  defer: igGlfwShutdown()
  doAssert igOpenGL3Init()
  defer: igOpenGL3Shutdown()
  #
  glfwWin.winMain()

#--------------
# winMain
#--------------
proc winMain(hWin:GLFWWindow)  =
  ## メイン

  # テーマの起動時配色 選択 theme
  #igStyleColorsLight()   # Windows風
  igStyleColorsDark()     # ダーク系1
  #igStyleColorsClassic() # ダーク系2
  #igStyleColorsCherry()  # ダーク系3
  #
  # 日本語フォントを追加
  (fExistMultbytesFonts,sActiveFontName,sActiveFontTitle) = setupFonts()
  # メインループ
  while not hWin.windowShouldClose:
    glfwPollEvents()
    # start imgui frame
    igOpenGL3NewFrame()
    igGlfwNewFrame()
    #
    # 動的にフォント変更するならここ
    #
    igNewFrame()

    if show_demo: # デモ画面の表示
      igShowDemoWindow(show_demo.addr)

    startSimpleWindow() # Simple window start

    igRender()
    glClearColor(0.45f, 0.55f, 0.60f, 1.00f) # 背景の色
    glClear(GL_COLOR_BUFFER_BIT)

    igOpenGL3RenderDrawData(igGetDrawData())
    hWin.swapBuffers()

#-------------------
# helpMaker
#-------------------
proc helpMarker(desc:string) =
  igTextDisabled("(?)")
  if (igIsItemHovered()):
      igBeginTooltip()
      igPushTextWrapPos(igGetFontSize() * 35.0f)
      igTextUnformatted(desc)
      igPopTextWrapPos()
      igEndTooltip()

#-------------------
# showStyleSelector
#-------------------
proc showStyleSelector(label:string) : bool =
  var style_idx {.global.}:int32  = -1
  if igCombo(label, addr style_idx, "Dark\0Light\0Classic\0"):
      case style_idx
      of 0: igStyleColorsDark()
      of 1: igStyleColorsLight()
      of 2: igStyleColorsClassic()
      else: discard
      return true
  return false

#-------------------
# startSimpleWindow
#-------------------
proc startSimpleWindow() =
  ## 画面左の小さいWindowを描画

  var
    somefloat {.global.} = 0.0'f32
    counter {.global.} = 0'i32
    sFnameSelected {.global.}: string
  var pio = igGetIO()

  ### Window開始
  let sTitle = "[ImGui: v$#] テスト by Nim-lang 2023/07" % [$igGetVersion()]
  igBegin(sTitle.cstring)
  defer: igEnd()
  ### テーマの選択
  discard showStyleSelector("テーマ色の選択")
  ### フォント選択 コンボボックス
  igSeparator()
  var fontCurrent = igGetfont()
  if igBeginCombo("フォント選択",fontCurrent.getDebugName()):
    defer: igEndCombo()
    for n in 0..<pio.fonts.fonts.size:
      let font = pio.fonts.fonts.data[n]
      igPushID(font)
      if igSelectable(font.getDebugName(),font == fontCurrent):
        pio.fontDefault = font
      igPopID()
  igSameLine()
  helpMarker("""
- フォントの追加は io.Fonts->AddFontFromFileTTF().
- フォントマップは io.Fonts->GetTexDataAsXXXX() 又は io.Fonts->Build()が実行された時に追加される.
- 詳細はFAQ と docs/FONTS.md を読んで下さいs.
- 実行時にフォントの追加と削除が必要なら(例:DPIの変更等) NewFrame()の呼び出し前に行って下さい."""
  )
  ###
  igSeparator()
  igText("これは日本語テキスト")
  igInputText("ここに日本語入力".cstring,sBuf.cstring,sBuf.len.csize_t,0.ImguiInputTextFlags,nil,nil)
  igText("出力: ")
  igSameLine()
  igText(sBuf.cstring)
  igSeparator()
  igSliderFloat("浮動小数", somefloat.addr, 0.0f, 1.0f)
  #
  igSeparator()
  when defined(windows):
    if igButton("ファイルを開く", ImVec2(x: 0, y: 0)):
      sFnameSelected = fileDialog(fdOpenFile, path = ".", filename = "*.*",
                            # filters = "Source[.nim, .nims, .nimble, .c, .cpp] : nim,nims,nimble,c,cpp,m;Header[.h]:h,hpp").cstring
                            filters="Source:c,cpp,m;Header:h,hpp")
    igSameLine()
  igText("選択ファイル名 = %s", sFnameSelected.cstring)
  #
  igSeparator()
  igText("描画フレームレート  %.3f ms/frame (%.1f FPS)"
    , 1000.0f / pio.framerate, pio.framerate)
  igText("経過時間 = %.1f [s]", counter.float32 / pio.framerate)
  counter.inc
  let delay = 600 * 3
  somefloat = (counter mod delay).float32 / delay.float32
  #
  igSeparator()
  igCheckbox("デモ・ウインドウ表示", show_demo.addr)

#--------------
# main
#--------------
main()



# proc igBeginCombo*(label: cstring, preview_value: cstring, flags: ImGuiComboFlags = 0.ImGuiComboFlags): bool {.importc: "igBeginCombo".}
# proc igSelectable*(label: cstring, selected: bool = false,
#                    flags: ImGuiSelectableFlags = 0.ImGuiSelectableFlags,
#                    size: ImVec2 = ImVec2(x: 0, y: 0).ImVec2): bool {.importc: "igSelectable_Bool".}
# proc igSelectable*(label: cstring, p_selected: ptr bool,
#                   flags: ImGuiSelectableFlags = 0.ImGuiSelectableFlags,
#                   size: ImVec2 = ImVec2(x: 0, y: 0).ImVec2): bool {.importc: "igSelectable_BoolPtr".}
