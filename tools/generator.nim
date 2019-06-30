# Written by Leonardo Mariscal <leo@ldmd.mx>, 2019

import os, strutils, streams, json, strformat,
       tables, algorithm, sets, ./constants

var enums: HashSet[string]

proc translateProc(name: string): string =
  "int32"

proc translateType(name: string): string =
  if name.contains("(") and name.contains(")"):
    return name.translateProc()

  result = name
  result = result.replace("unsigned ", "u")
  result = result.replace("signed ", "")
  result = result.replace("int", "int32")
  result = result.replace("int3264_t", "int64")
  result = result.replace("short", "int16")
  result = result.replace("char", "int8")
  result = result.replace("void*", "pointer")

proc genEnums(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("\n# Enums\ntype\n")

  for name, obj in data["enums"].pairs:
    output.add("  {name[0 ..< name.len - 1]}* {{.pure, size: int32.sizeof.}} = enum\n".fmt)
    enums.incl(name[0 ..< name.len - 1])
    var table: OrderedTable[int, string]
    for data in obj:
      var dataName = data["name"].getStr()
      dataName = dataName.replace("__", "_")
      dataName = dataName.split("_")[1]
      if dataName.endsWith("_"):
        dataName = dataName[0 ..< dataName.len - 1]
      if dataName == "COUNT":
        continue
      var dataValue = data["calc_value"].getInt()
      if table.hasKey(dataValue):
        echo "Enum {name[0 ..< name.len - 1]}.{dataName} already exists as {name[0 ..< name.len - 1]}.{table[dataValue]} with value {dataValue} skipping...".fmt
        continue
      table[dataValue] = dataName
    table.sort(system.cmp)
    for k, v in pairs(table):
      output.add("    {v} = {k}\n".fmt)

proc genTypeDefs(output: var string) =
  # This must run after genEnums
  let file = readFile("src/imgui/private/cimgui/generator/output/typedefs_dict.json")
  let data = file.parseJson()

  output.add("\n# TypeDefs\ntype\n")

  for name, obj in data.pairs:
    let ignorable = ["const_iterator", "iterator", "value_type"]
    if obj.getStr().startsWith("struct") or enums.contains(name) or ignorable.contains(name):
      continue
    output.add("  {name}* = {obj.getStr().translateType()}\n".fmt)

proc genTypes(output: var string) =
  let file = readFile("src/imgui/private/cimgui/generator/output/structs_and_enums.json")
  let data = file.parseJson()

  output.add("\n# Types\ntype\n")

  for name, obj in data["structs"].pairs:
    output.add("  {name}* = object\n".fmt)
    for member in obj:
      var memberName = member["name"].getStr()
      if memberName.startsWith("_"):
        memberName = memberName[1 ..< memberName.len]
      output.add("    {memberName}*: {member[\"type\"].getStr().translateType()}\n".fmt)

proc igGenerate*() =
  var output = srcHeader

  output.genEnums()
  output.genTypeDefs()
  #output.genTypes()

  #output.add("{.pop.}")
  writeFile("src/imgui.nim", output)

when isMainModule:
  igGenerate()
