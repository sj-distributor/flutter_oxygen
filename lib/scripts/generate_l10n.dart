/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-05-24 13:16:49
 */
import 'dart:convert';
import 'dart:io';

/// 根据lib/common/l10n/language.json生成国际化配置文件
void generatel10n() {
  // 读取JSON文件
  String path = "lib/common/l10n";
  String inputPath = "$path/language.json";

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

  // 遍历JSON数据的每个键值对
  jsonData.forEach((key, value) {
    // 遍历每个键值对中的语言键值对
    value.forEach((language, text) {
      // 构造文件名
      String fileName = '$path/app_$language.arb';

      // 检查文件是否存在，如果不存在则创建新文件
      File file = File(fileName);
      if (!file.existsSync()) {
        file.createSync();
      }
      // 读取language文件内容
      String childJsonContent = file.readAsStringSync();
      Map<String, dynamic> childJsonData = {};
      if (childJsonContent.isNotEmpty) {
        childJsonData = json.decode(childJsonContent);
      }

      childJsonData[key] = text;
      file.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(childJsonData));
      file.exists();
    });
  });
  jsonFile.exists();

  // ignore: avoid_print
  print("output success");
}

void main() {
  generatel10n();
}
