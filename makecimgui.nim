import std/[os, strutils]
#import system
# import system/io

var (dir, name, ext) = splitFile(currentSourcePath())
dir = dir.joinPath("./src/imgui/private/cimgui")
#echo dir
setCurrentDir(dir)


proc exec(s: string) =
    assert 0 == os.execShellCmd(s)

if fileExists("libcimgui.a"):
  echo("Warning: libcimgui.a already built. Skipping.")
  quit()

if "-fno-threadsafe-statics" notin open("Makefile").readAll():
  exec("git apply ../0001-Remove-threadsafe.patch")

exec("make clean")
exec("make static")
