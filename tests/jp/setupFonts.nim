#import std/[os]

#--------------
# point2px
#--------------
proc point2px(point: float32): cfloat =
  ## Convert point to pixel

  ((point * 96) / 72).cfloat

#--------------
# setupFonts
#--------------
type
  TFontInfo = object
    fontDir,osRootDir:string
    fontTable:seq[(string  # fontName
                  ,string  # fontTitle
                  ,float)] # point
when defined(windows):
  const fontInfo = TFontInfo(
       osRootDir: os.getEnv("windir") # get OS root
       ,fontDir: "fonts"
       ,fontTable: @[ # 以下全て有効にすると起動が遅くなる
         ("meiryob.ttc","メイリオ B",14.0)
         ,("meiryo.ttc","メイリオ",14.0)
         ,("YuGothM.ttc","遊ゴシック M",11.0)
         ,("msgothic.ttc","MS ゴシック",11.0)
        # ,("myricam.ttc","MyricaM",11.0)
         ])
else: # For Debian/Ubuntu
  const fontInfo = TFontInfo(
        osRootDir: "/"
       ,fontDir: "usr/share/fonts"
       ,fontTable: @[
          ("opentype/ipafont-gothic/ipag.ttf","IPAゴシック",12.0)
         ,("opentype/ipafont-gothic/ipam.ttf","IPAゴシック M",12.0)])

proc setupFonts*(): (bool,string,string) =
  ## return font first file name

  result =  (false,"Default","ProggyClean.ttf") #
  let io = igGetIO()
  var seqFontNames: seq[(string,string)]
  for (fontName,fontTitle,point) in fontInfo.fontTable:
    let fontFullPath = os.joinPath(fontInfo.osRootDir, fontInfo.fontDir, fontName)
    if os.fileExists(fontFullPath):
      seqFontNames.add (fontName,fontTitle)
      # フォントを追加
      io.fonts.addFontFromFileTTF(fontFullPath.cstring, point.point2px,
          nil, io.fonts.getGlyphRangesJapanese());
  if seqFontNames.len > 0:
    result = (true,seqFontNames[0][0].extractFilename ,seqFontNames[0][1])

