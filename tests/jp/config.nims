switch("path", "$projectDir/../../src")

when (NimMajor, NimMinor, NimPatch) >= (1, 6, 10):
  # These lines should delete
  switch "warning","HoleEnumConv:off"
  switch "warning","CStringConv:off"
  switch "warning","PtrToCstringConv:off"
  switch "hint","XDeclaredButNotUsed:off"

when (NimMajor, NimMinor, NimPatch) < (1, 6, 10):
  echo "====================================================="
  echo "=== Error! Nim version: Use nim-1.6.10 or later ==="
  echo "====================================================="
  quit 1

# Enable IME implement for Asia region
import std/[pegs,os,strutils]
when defined(windows):
  var fBreak = false
  for val in ["LC_ALL","LANG", "LC_CTYPE", "LANGUAGE"]:
    const AsiaLocale = [" 'ja' / 'jp' "," 'ko' / 'lr' "," 'zh' / 'cn' "," 'zh' / 'tw' "]
    for locale in AsiaLocale:
      if getEnv(val).toLowerAscii =~ peg(locale):
          {.passC:"-DIMGUI_ENABLE_WIN32_DEFAULT_IME_FUNCTIONS".}
          {.passL:"-limm32".}
          echo "\n=== Enabled: Input Method, current locale is  [ ",locale," ] ===\n"
          fBreak = true
          break
    if fBreak:
      break


