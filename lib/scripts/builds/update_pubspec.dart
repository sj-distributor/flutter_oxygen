/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-10 14:17:03
 */
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

const _print = print;

/// 修改pubspec.yaml里面flutter_launcher_icons图标路径
// void updatePubspec(String? name, String? version) {
void updatePubspec({
  required Map<String, dynamic> params,
  required String inputPath,
}) {
  const filePath = 'pubspec.yaml';

  // 读取 pubspec.yaml 文件
  final file = File(filePath);
  if (!file.existsSync()) {
    _print("$filePath not found");
    return;
  }

  bool isChange = false;
  final content = file.readAsStringSync();
  final yamlEditor = YamlEditor(content);

  // 解析 YAML 内容
  final yamlDoc = loadYaml(content);

  params.forEach((key, value) {
    if (yamlDoc[key] != null && value != null) {
      yamlEditor.update([key], value);
      if (!isChange) isChange = true;
    }
  });

  // 写回更新后的内容
  if (isChange) {
    try {
      file.writeAsStringSync(yamlEditor.toString());
    } catch (e) {
      _print("Failed to write to file: $e");
    }
  }
  file.exists();
}
