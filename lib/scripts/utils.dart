/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-30 16:20:36
 */
import 'dart:io';

const _print = print;

class Utils {
  /// 将项目名转成驼峰命名，例如 rf_online → rfOnline
  static String toCamelCase(String projectName) {
    final parts = projectName.split(RegExp(r'[_\s]+'));
    if (parts.isEmpty) return projectName;
    return parts.first.toLowerCase() +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  /// 递归创建文件夹
  static String checkAndCreateDirectory(String path) {
    final directory = Directory(path);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return path;
  }

  /// 删除文件
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);

    if (file.existsSync()) file.deleteSync();
  }

  /// 删除文件夹
  static Future<void> deleteDirectory(String path) async {
    final directory = Directory(path);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  }

  /// 获取静态变量的值
  static String? getStaticMpa(String? content, String key) {
    if (content == null) return null;
    final regex = RegExp(r'static (\w+) (\w+) = (.*?);');
    final matches = regex.allMatches(content);

    for (var match in matches) {
      final variable = match.group(2);
      final value = match.group(3);

      if (variable == key) {
        if (value!.startsWith('"') && value.endsWith('"')) {
          return value.substring(1, value.length - 1);
        } else if (value.startsWith("'") && value.endsWith("'")) {
          return value.substring(1, value.length - 1);
        }
        return value;
      }
    }
    return null;
  }

  /// 复制文件
  static Future<void> copyFiles({
    required String inputDir,
    required String outputDir,
  }) async {
    final inputDirectory = Directory(inputDir);
    final outputDirectory = Directory(outputDir);

    if (!await inputDirectory.exists()) {
      _print('copy files input directory does not exist');
      return;
    }

    if (!await outputDirectory.exists()) {
      await outputDirectory.create(recursive: true);
    }

    await for (var entity in inputDirectory.list(recursive: false)) {
      if (entity is File) {
        final newPath =
            '${outputDirectory.path}/${entity.uri.pathSegments.last}';
        await entity.copy(newPath);
      }
    }
  }
}
