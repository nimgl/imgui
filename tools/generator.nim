# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

import os, strutils, streams, json, strformat,
       tables, algorithm, sets, ./utils

var enums: HashSet[string]
var enumsCount: Table[string, int]

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
  "int32"

proc translateArray(name: string): (string, string) =
  let nameSplit = name.rsplit('[', 1)
  var arraySize = nameSplit[1]
  arraySize = arraySize[0 ..< arraySize.len - 1]
  if arraySize.contains("COUNT"):
    arraySize = $enumsCount[arraySize]
  result[0] = arraySize
  result[1] = nameSplit[0]

proc translateType(name: string): string =
  if name.contains("(") and name.contains(")"):
    return name.translateProc()

  result = name.replace("const ", "")
  result = result.replace("unsigned ", "u")
  result = result.replace("signed ", "")

  var depth = result.count('*')
  result = result.replace(" ", "")
  result = result.replace("*", "")
  result = result.replace("&", "")

  result = result.replace("int", "int32")
  result = result.replace("int3264_t", "int64")
  result = result.replace("float", "float32")
  result = result.replace("double", "float64")
  result = result.replace("short", "int16")
  result = result.replace("_Simple", "")
  if not name.contains("Wchar"):
    result = result.replace("char", "int8")
  if depth > 0 and result.contains("void"):
    result = result.replace("void", "pointer")
    depth.dec

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

  if depth < 1:
    return
  for d in 0 ..< depth:
    result = "ptr " & result

proc genEnums(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("\n# Enums\ntype\n")

  for name, obj in data["enums"].pairs:
    let enumName = name[0 ..< name.len - 1]
    output.add("  {enumName}* {{.pure, size: int32.sizeof.}} = enum\n".fmt)
    enums.incl(enumName)
    var table: OrderedTable[int, string]
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
    table.sort(system.cmp)
    for k, v in table.pairs:
      output.add("    {v} = {k}\n".fmt)

proc genTypeDefs(output: var string) =
  # This must run after genEnums
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
  # This must run after genEnums
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("\n# Types\ntype\n")
  output.add(notDefinedStructs)

  for name, obj in data["structs"].pairs:
    if name == "Pair":
      continue
    output.add("  {name}* {{.importc: \"{name}\", imgui_header.}} = object\n".fmt)
    for member in obj:
      var memberName = member["name"].getStr()
      if memberName.startsWith("_"):
        memberName = memberName[1 ..< memberName.len]
      memberName = memberName.uncapitalize()

      if not memberName.contains("["):
        if not member.contains("template_type"):
          output.add("    {memberName}*: {member[\"type\"].getStr().translateType()}\n".fmt)
        else:
          # Assuming all template_type containers are ImVectors
          output.add("    {memberName}*: ImVector[{member[\"template_type\"].getStr().translateType()}]\n".fmt)
        continue

      let arrayData = memberName.translateArray()
      output.add("    {arrayData[1]}*: array[{arrayData[0]}, {member[\"type\"].getStr().translateType()}]\n".fmt)

proc genProcs(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/definitions.json")
  let data = file.parseJson()

  output.add("\n{preProcs}\n".fmt)

  for name, obj in data.pairs:
    for variation in obj:
      if variation.contains("nonUDT"):
        # If you need UDT support please let me know, and some examples.
        continue
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
        if variation.contains("constructor"):
          echo "{name}\n{obj.pretty}".fmt
        funcname = variation["cimguiname"].getStr()
        #funcname = funcname.rsplit("_", 1)[1]

      if variation.contains("constructor"):
        if funcname.startsWith("ImVector"):
          continue
        funcname = "new" & funcname.capitalizeAscii()

      if funcname.isUpper():
        funcname = funcname.normalize()
      else:
        funcname = funcname.uncapitalize()

      if funcname.startsWith("_"):
        funcname = funcname[1 ..< funcname.len]
      funcname = funcname.uncapitalize()

      if reservedWordsDictionary.contains(funcname):
        funcname = "`{funcname}`".fmt

      output.add("proc {funcname}*(".fmt)

      var isVarArgs = variation.contains("isvararg") and variation["isvararg"].getBool()
      # Args
      for arg in variation["argsT"]:
        var argName = arg["name"].getStr()
        var argType = arg["type"].getStr().translateType()

        if argName.startsWith("_"):
          argName = argName[1 ..< argName.len]
        argName = argName.uncapitalize()

        if reservedWordsDictionary.contains(argName):
          argName = "`{argName}`".fmt

        if argType.contains('[') and not argType.contains("ImVector["):
          let arrayData = argType.translateArray()
          argType = "array[{arrayData[0]}, {arrayData[1]}]".fmt

        if argName == "..." or argType == "..." or argType == "va_list":
          isVarArgs = true
          continue
        output.add("{argName}: {argType}, ".fmt)
      if variation["argsT"].len > 0:
        output = output[0 ..< output.len - 2]
      output.add("): ")

      # Ret
      var argRet = "void"
      if variation.contains("ret"):
        argRet = variation["ret"].getStr().translateType()
      output.add(argRet)

      # Pragmas
      output.add(" {" & ".importc: \"{variation[\"cimguiname\"].getStr()}\"".fmt)
      if isVarArgs:
        output.add(", varargs")
      output.add(".}")

      output.add("\n")

      # Checking if it doesn't exist already
      let outSplit = output.rsplit("\n", 3)
      if outSplit[1] == outSplit[2]:
        output = "{outSplit[0]}\n{outSplit[1]}\n".fmt

  output.add("\n{.pop.}\n")

proc igGenerate*() =
  var output = srcHeader

  output.genEnums()
  output.genTypeDefs()
  output.genTypes()
  output.genProcs()

  writeFile("src/imgui.nim", output)

when isMainModule:
  igGenerate()
