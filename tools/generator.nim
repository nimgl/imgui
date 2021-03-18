# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

import strutils, json, strformat, tables,
       algorithm, sets, ./utils

var enums: HashSet[string]
var enumsCount: Table[string, int]

proc translateType(name: string): string # translateProc needs this

proc uncapitalize(str: string): string =
  if str.len < 1:
    result = ""
  else:
    result = toLowerAscii(str[0]) & str[1 ..< str.len]

proc isUpper(str: string): bool =
  for c in str:
    if not c.isUpperAscii():
      return false
  return true

proc translateProc(name: string): string =
  var nameSplit = name.replace(";", "").split("(*)", 1)
  let procType = nameSplit[0].translateType()

  nameSplit[1] = nameSplit[1][1 ..< nameSplit[1].len - 1]
  var isVarArgs = false
  var argsSplit = nameSplit[1].split(',')
  var argSeq: seq[tuple[name: string, kind: string]]
  for arg in argsSplit:
    let argPieces = arg.rsplit(' ', 1)
    if argPieces[0] == "...":
      isVarArgs = true
      continue
    var argName = argPieces[1]
    var argType = argPieces[0]
    if argName.contains('*'):
      argType.add('*')
      argName = argName.replace("*", "")
    if reservedWordsDictionary.contains(argName):
      argName = "`{argName}`".fmt
    argType = argType.translateType()
    argSeq.add((name: argName, kind: argType))

  result = "proc("
  for arg in argSeq:
    result.add("{arg.name}: {arg.kind}, ".fmt)
  if argSeq.len > 0:
    result = result[0 ..< result.len - 2]
  if isVarArgs:
    result.add("): {procType} {{.cdecl.}}".fmt)
  else:
    result.add("): {procType} {{.cdecl, varargs.}}".fmt)

proc translateArray(name: string): tuple[size: string, name: string] =
  let nameSplit = name.rsplit('[', 1)
  var arraySize = nameSplit[1]
  arraySize = arraySize[0 ..< arraySize.len - 1]
  if arraySize.contains("COUNT"):
    arraySize = $enumsCount[arraySize]
  if arraySize == "(0xFFFF+1)/4096/8": # If more continue to appear automate it
    arraySize = "2"
  result.size = arraySize
  result.name = nameSplit[0]

proc translateType(name: string): string =
  if name.contains("(") and name.contains(")"):
    return name.translateProc()
  if name == "const char* const[]":
    return "ptr cstring"

  result = name.replace("const ", "")
  result = result.replace("unsigned ", "u")
  result = result.replace("signed ", "")

  var depth = result.count('*')
  result = result.replace(" ", "")
  result = result.replace("*", "")
  result = result.replace("&", "")

  result = result.replace("int", "int32")
  result = result.replace("size_t", "uint") # uint matches pointer size just like size_t
  result = result.replace("int3264_t", "int64")
  result = result.replace("float", "float32")
  result = result.replace("double", "float64")
  result = result.replace("short", "int16")
  result = result.replace("_Simple", "")
  if result.contains("char") and not result.contains("Wchar"):
    if result.contains("uchar"):
      result = "cuchar"
    elif depth > 0:
      result = result.replace("char", "cstring")
      depth.dec
      if result.startsWith("u"):
        result = result[1 ..< result.len]
    else:
      result = result.replace("char", "int8")
  if depth > 0 and result.contains("void"):
    result = result.replace("void", "pointer")
    depth.dec

  result = result.replace("ImBitArray", "ImU32")
  result = result.replace("ImGuiWindowPtr", "ptr ImGuiWindow")
  result = result.replace("ImS8", "int8") # Doing it a little verbose to avoid issues in the future.
  result = result.replace("ImS16", "int16")
  result = result.replace("ImS32", "int32")
  result = result.replace("ImS64", "int64")
  result = result.replace("ImU8", "uint8")
  result = result.replace("ImU16", "uint16")
  result = result.replace("ImU32", "uint32")
  result = result.replace("ImU64", "uint64")
  result = result.replace("Pair", "ImPair")
  result = result.replace("ImFontPtr", "ptr ImFont")

  if result.startsWith("ImVector_"):
    result = result["ImVector_".len ..< result.len]
    result = "ImVector[{result}]".fmt

  result = result.replace("ImGuiStorageImPair", "ImGuiStoragePair")

  for d in 0 ..< depth:
    result = "ptr " & result
    if result == "ptr ptr ImDrawList":
      result = "UncheckedArray[ptr ImDrawList]"

proc genEnums(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("\n# Enums\ntype\n")

  for name, obj in data["enums"].pairs:
    var enumName = name
    if enumName.endsWith("_"):
      enumName = name[0 ..< name.len - 1]
    output.add("  {enumName}* {{.pure, size: int32.sizeof.}} = enum\n".fmt)
    enums.incl(enumName)
    var table: Table[int, string]
    for data in obj:
      var dataName = data["name"].getStr()
      dataName = dataName.replace("__", "_")
      dataName = dataName.split("_")[1]
      if dataName.endsWith("_"):
        dataName = dataName[0 ..< dataName.len - 1]
      if dataName == "COUNT":
        enumsCount[data["name"].getStr()] = data["calc_value"].getInt()
        continue
      let dataValue = data["calc_value"].getInt()
      if table.hasKey(dataValue):
        echo "Enum {enumName}.{dataName} already exists as {enumName}.{table[dataValue]} with value {dataValue} skipping...".fmt
        continue
      table[dataValue] = dataName

    var tableOrder: OrderedTable[int, string] # Weird error where data is erased if used directly
    for k, v in table.pairs:
      tableOrder[k] = v
    tableOrder.sort(system.cmp)

    for k, v in tableOrder.pairs:
      output.add("    {v} = {k}\n".fmt)

proc genTypeDefs(output: var string) =
  # Must be run after genEnums
  let file = readFile("src/imgui/private/cimgui/generator/output/typedefs_dict.json")
  let data = file.parseJson()

  output.add("\n# TypeDefs\ntype\n")

  for name, obj in data.pairs:
    let ignorable = ["const_iterator", "iterator", "value_type", "ImS8",
                     "ImS16", "ImS32", "ImS64", "ImU8", "ImU16", "ImU32",
                     "ImU64"]
    if obj.getStr().startsWith("struct") or enums.contains(name) or ignorable.contains(name):
      continue
    output.add("  {name}* = {obj.getStr().translateType()}\n".fmt)

proc genTypes(output: var string) =
  # Does not add a `type` keyword
  # Must be run after genEnums
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("\n")
  output.add(notDefinedStructs)

  for name, obj in data["structs"].pairs:
    if name == "Pair" or name == "ImGuiStoragePair" or name == "ImGuiStyleMod":
      continue

    if name == "ImDrawChannel":
      output.add("  ImDrawChannel* {.importc: \"ImDrawChannel\", imgui_header.} = ptr object\n")
      continue

    output.add("  {name}* {{.importc: \"{name}\", imgui_header.}} = object\n".fmt)
    for member in obj:
      var memberName = member["name"].getStr()
      if memberName == "Ptr":
        memberName = "`ptr`"
      if memberName == "Type":
        memberName = "`type`"
      var memberImGuiName = "{{.importc: \"{memberName}\".}}".fmt
      if memberName.startsWith("_"):
        memberName = memberName[1 ..< memberName.len]
      if memberName.isUpper():
        memberName = memberName.normalize()
      memberName = memberName.uncapitalize()

      if memberImGuiName.contains('['):
        memberImGuiName = memberImGuiName[0 ..< memberImGuiName.find('[')] & "\".}"

      if not memberName.contains("["):
        if not member.contains("template_type"):
          output.add("    {memberName}* {memberImGuiName}: {member[\"type\"].getStr().translateType()}\n".fmt)
        else:
          # Assuming all template_type containers are ImVectors
          var templateType = member["template_type"].getStr()
          if templateType == "ImGui*OrIndex":
            templateType = "ImGuiPtrOrIndex"
          templateType = templateType.translateType()

          if templateType == "ImGuiTabBar": # Hope I don't regret this hardocoded if
            output.add("    {memberName}* {memberImGuiName}: ptr ImPool\n".fmt)
          elif templateType == "ImGuiColumns":
            output.add("    {memberName}* {memberImGuiName}: ImVectorImGuiColumns\n".fmt)
          else:
            output.add("    {memberName}* {memberImGuiName}: ImVector[{templateType}]\n".fmt)
        continue

      let arrayData = memberName.translateArray()
      output.add("    {arrayData[1]}* {memberImGuiName}: array[{arrayData[0]}, {member[\"type\"].getStr().translateType()}]\n".fmt)

proc genProcs(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/definitions.json")
  let data = file.parseJson()

  output.add("\n{preProcs}\n".fmt)

  for name, obj in data.pairs:
    var isNonUDT = false
    var nonUDTNumber = 0
    for variation in obj:
      if variation.contains("nonUDT"):
        nonUDTNumber.inc
        isNonUDT = true
      if blackListProc.contains(variation["cimguiname"].getStr()):
        continue

      # Name
      var funcname = ""
      if variation.contains("stname") and variation["stname"].getStr() != "":
        if variation.contains("destructor"):
          funcname = "destroy"
        else:
          funcname = variation["funcname"].getStr()
      else:
        funcname = variation["cimguiname"].getStr()
        #funcname = funcname.rsplit("_", 1)[1]

      if isNonUDT:
        funcname = funcname & "NonUDT"
        if nonUDTNumber != 1:
          funcname = funcname & $nonUDTNumber

      if variation.contains("constructor"):
        if funcname.startsWith("ImVector"):
          continue
        funcname = "new" & funcname.capitalizeAscii()

      if funcname.isUpper():
        funcname = funcname.normalize()
      funcname = funcname.uncapitalize()

      if funcname.startsWith("_"):
        funcname = funcname[1 ..< funcname.len]

      if reservedWordsDictionary.contains(funcname):
        funcname = "`{funcname}`".fmt

      output.add("proc {funcname}*".fmt)

      var isGeneric = false
      var isVarArgs = variation.contains("isvararg") and variation["isvararg"].getBool()
      var argsOutput = ""
      # Args
      for arg in variation["argsT"]:
        var argName = arg["name"].getStr()
        var argType = arg["type"].getStr().translateType()
        var argDefault = ""
        if variation.contains("defaults") and variation["defaults"].kind == JObject and
           variation["defaults"].contains(argName):
          argDefault = variation["defaults"][argName].getStr()
          argDefault = argDefault.replace("4294967295", "high(uint32)")
          argDefault = argDefault.replace("(((ImU32)(255)<<24)|((ImU32)(255)<<16)|((ImU32)(255)<<8)|((ImU32)(255)<<0))", "high(uint32)")
          argDefault = argDefault.replace("(((ImU32)(255)<<24)|((ImU32)(0)<<16)|((ImU32)(0)<<8)|((ImU32)(255)<<0))", "4278190335")
          argDefault = argDefault.replace("4278190335", "4278190335'u32")
          argDefault = argDefault.replace("FLT_MAX", "high(float32)")
          argDefault = argDefault.replace("((void*)0)", "nil")
          argDefault = argDefault.replace("NULL", "nil")
          argDefault = argDefault.replace("-FLT_MIN", "0")
          argDefault = argDefault.replace("~0", "-1")
          argDefault = argDefault.replace("sizeof(float)", "sizeof(float32).int32")
          argDefault = argDefault.replace("ImDrawCornerFlags_All", "ImDrawCornerFlags.All")
          argDefault = argDefault.replace("ImGuiPopupPositionPolicy_Default", "ImGuiPopupPositionPolicy.Default")
          argDefault = argDefault.replace("ImGuiPopupFlags_None", "ImGuiPopupFlags.None")
          argDefault = argDefault.replace("ImGuiNavHighlightFlags_TypeDefault", "ImGuiNavHighlightFlags.TypeDefault")

          if argDefault.startsWith("ImVec"):
            let letters = ['x', 'y', 'z', 'w']
            var argPices = argDefault[7 ..< argDefault.len - 1].split(',')
            argDefault = argDefault[0 ..< 7]
            for p in 0 ..< argPices.len:
              argDefault.add("{letters[p]}: {argPices[p]}, ".fmt)
            argDefault = argDefault[0 ..< argDefault.len - 2] & ")"

          if (argType.startsWith("ImGui") or argType.startsWith("Im")) and not argType.contains("Callback"):
            argDefault.add(".{argType}".fmt)

        if argName.startsWith("_"):
          argName = argName[1 ..< argName.len]
        if argName.isUpper():
          argName = argName.normalize()
        argName = argName.uncapitalize()

        if reservedWordsDictionary.contains(argName):
          argName = "`{argName}`".fmt

        if argType.contains('[') and not argType.contains("ImVector[") and not argType.contains("UncheckedArray["):
          let arrayData = argType.translateArray()
          if arrayData[1].contains("cstringconst"):
            echo "{name}\n{obj.pretty}".fmt
          argType = "var array[{arrayData[0]}, {arrayData[1]}]".fmt
        argType = argType.replace(" {.cdecl.}", "")

        if argName == "..." or argType == "..." or argType == "va_list":
          isVarArgs = true
          continue
        if argType == "T" or argType == "ptr T":
          isGeneric = true

        if argDefault == "":
          argsOutput.add("{argName}: {argType}, ".fmt)
        else:
          argsOutput.add("{argName}: {argType} = {argDefault}, ".fmt)
      if variation["argsT"].len > 0:
        argsOutput = argsOutput[0 ..< argsOutput.len - 2]

      # Ret
      var argRet = "void"
      if variation.contains("ret"):
        argRet = variation["ret"].getStr().translateType()
      if argRet == "T" or argRet == "ptr T":
        isGeneric = true
      if argRet == "explicit":
        argRet = "ptr ImVec2ih" # Ugly solution for a temporal problem

      output.add(if isGeneric: "[T](" else: "(")
      output.add(argsOutput)
      output.add("): ")
      output.add(argRet)

      # Pragmas
      var pragmaName = variation["cimguiname"].getStr()
      if variation.contains("ov_cimguiname"):
        pragmaName = variation["ov_cimguiname"].getStr()
      output.add(" {" & ".importc: \"{pragmaName}\"".fmt)
      if isVarArgs:
        output.add(", varargs")
      output.add(".}")

      output.add("\n")

      # Checking if it doesn't exist already
      let outSplit = output.rsplit("\n", 3)
      if outSplit[1] == outSplit[2] or outSplit[1].split('{')[0] == outSplit[2].split('{')[0]:
        output = "{outSplit[0]}\n{outSplit[1]}\n".fmt

  output.add("\n{.pop.}\n")

proc igGenerate*() =
  var output = srcHeader

  output.genEnums()
  output.genTypeDefs()
  output.genTypes()
  output.genProcs()
  output.add("\n" & cherryTheme)

  writeFile("src/imgui.nim", output)

when isMainModule:
  igGenerate()
