/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-05-24 13:16:49
 */
import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';

/// 根据assets/fonts/iconfont.json字体文件生成icon
void generateIcon() {
  String inputPath = "assets/fonts/iconfont.json";
  String outputPath = "lib/utils/icon_font.dart";

  // 读取JSON文件
  File jsonFile = File(inputPath);
  if (!jsonFile.existsSync()) {
    // ignore: avoid_print
    print("$inputPath not found");
    return;
  }

  // 读取JSON文件内容
  String jsonContent = jsonFile.readAsStringSync();

  // 解析JSON内容
  Map<String, dynamic> jsonData = json.decode(jsonContent);

  List<dynamic> glyphs = jsonData["glyphs"];
  // 对 iconsData 进行倒序
  glyphs = glyphs.reversed.toList();

  // 生成代码
  StringBuffer codeBuffer = StringBuffer();

  codeBuffer.writeln("import 'package:flutter/material.dart';\n");
  codeBuffer.writeln("/// generate from command: make icon");
  codeBuffer.writeln("class IconFont {");

  for (var glyph in glyphs) {
    ReCase name = ReCase(glyph["name"]);
    String unicode = glyph["unicode"];
    codeBuffer.writeln("  static const ${name.camelCase} = IconData(");
    codeBuffer.writeln("    0x$unicode,");
    codeBuffer.writeln("    fontFamily: \"IconFont\",");
    codeBuffer.writeln("    matchTextDirection: true,");
    codeBuffer.writeln("  );\n");
  }

  codeBuffer.writeln("  /// generate from command: make icon");
  codeBuffer.writeln("}");

  // 将生成的代码写入文件
  File(outputPath).writeAsStringSync(codeBuffer.toString());
  jsonFile.exists();
  // ignore: avoid_print
  print("icon write $outputPath");
}

void main() {
  generateIcon();
}
