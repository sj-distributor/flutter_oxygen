/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-30 16:20:36
 */
import 'dart:io';

class Utils {
  /// 递归创建文件夹
  static String checkAndCreateDirectory(String path) {
    final directory = Directory(path);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return path;
  }

  /// 删除文件夹
  static void deleteDirectory(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  }
}
