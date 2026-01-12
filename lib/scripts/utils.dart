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

    // 1. 如果一开始就不存在，直接返回，省事
    if (!directory.existsSync()) return;

    try {
      // 2. 尝试递归删除
      directory.deleteSync(recursive: true);
    } catch (e) {
      // 3. 核心修复在这里：
      // 如果报错是因为“找不到文件(PathNotFoundException)”或者“系统错误码 2 (ENOENT)”，
      // 这意味着在我们想删除它的时候，它已经把自己“删没了”（或者软链接失效了）。
      // 既然我们的目的是让它消失，那么这种情况应当被视为“成功”。
      if (e is PathNotFoundException ||
          (e is FileSystemException && e.osError?.errorCode == 2)) {
        print(
          "Warning: Directory '$path' disappeared during deletion or contained broken symlinks. Ignoring.",
        );
      } else {
        // 如果是权限不足(Access Denied)等其他严重错误，才抛出异常
        print("Error deleting '$path': $e");
        rethrow;
      }
    }
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
      _print('copy files input directory does not exist: $inputDir');
      return;
    }

    await outputDirectory.create(recursive: true);

    await for (final entity in inputDirectory.list(recursive: true)) {
      if (entity is File) {
        final relativePath = entity.path.substring(
          inputDirectory.path.length + 1,
        );
        final newPath = '${outputDirectory.path}/$relativePath';

        await File(newPath).parent.create(recursive: true);
        await entity.copy(newPath);
      }
    }
  }
}
