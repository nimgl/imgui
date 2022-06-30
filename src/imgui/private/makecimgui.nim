import std/[os, strutils]
import system
# import system/io

var (dir, name, ext) = splitFile(currentSourcePath())
dir = dir.joinPath("cimgui")
echo dir
cd(dir)
if fileExists("libcimgui.a"):
  echo("Warning: libcimgui.a already built. Rebuilding")

if "-fno-threadsafe-statics" notin open("Makefile").readAll():
  exec("git apply ../0001-Remove-threadsafe.patch")

exec("make clean")
exec("make static")
