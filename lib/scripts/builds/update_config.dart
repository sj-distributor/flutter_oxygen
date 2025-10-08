/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-02-12 21:47:28
 */
import 'dart:convert';
import 'dart:io';

const _print = print;

/// 新版本使用下面的
Future<String?> updateConfig({
  required Map<String, dynamic> params,
  required String inputPath,
}) async {
  try {
    // 读取JSON文件
    File jsonFile = File(inputPath);
    if (!jsonFile.existsSync()) {
      _print("$inputPath not found");
      return null;
    }

    // 读取JSON文件内容
    String configContent = jsonFile.readAsStringSync();

    // 根据传进来的参数进行遍历修改
    // final params = Params().get(arguments);
    params.forEach((key, value) {
      if (value is String) {
        final keyPattern = RegExp(r'(?<=\b' + key + r' = ")[^"]*(?=";)');
        configContent = configContent.replaceAllMapped(
          keyPattern,
          (match) => value,
        );
      } else if (value is Map<String, dynamic>) {
        // 处理 Map 类型值（projectJson = {...};）
        String jsonString = const JsonEncoder.withIndent("    ").convert(value);

        final keyPattern = RegExp(r'(?<=\b' + key + r' = )[^;]*(?=;)');
        configContent = configContent.replaceAllMapped(
          keyPattern,
          (match) => jsonString,
        );
      }
    });

    jsonFile.writeAsStringSync(configContent);

    return configContent;
  } catch (e) {
    return null;
  }
}

/// 只更新 config.dart 中 static String projectName 的值
Future<void> updateProjectNameInConfig({
  required String inputPath,
  required String projectName,
}) async {
  final file = File(inputPath);
  if (!file.existsSync()) {
    print('File not found: $inputPath');
    return;
  }

  String content = await file.readAsString();

  // 匹配 static String projectName = "xxx";
  final reg = RegExp(r'static\s+String\s+projectName\s*=\s*"[^"]*";');

  if (!reg.hasMatch(content)) {
    print('No projectName field found!');
    return;
  }

  // 替换为新的内容
  content = content.replaceAllMapped(
    reg,
    (match) => 'static String projectName = "$projectName";',
  );

  await file.writeAsString(content);
}
