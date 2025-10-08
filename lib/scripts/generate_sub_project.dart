/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-10-08 10:37:49
 */
import 'dart:io';

import './utils.dart';

/// 扫描 packages 并生成 Route 字符串（带 projectName 和注释）
Future<List<String>> loadAllRoutesWithProjectName(String packagesPath) async {
  final packagesDir = Directory(packagesPath);
  if (!await packagesDir.exists()) throw Exception('目录不存在: $packagesPath');

  final List<String> allRoutes = [];

  await for (final project in packagesDir.list()) {
    if (project is! Directory) continue;

    // 读取 config.dart 获取 projectName
    final configFile = File('${project.path}/lib/config/config.dart');
    if (!await configFile.exists()) continue;

    final configContent = await configFile.readAsString();
    final configMatch = RegExp(
      r'''static\s+String\s+projectName\s*=\s*["']([^"']+)["'];''',
    ).firstMatch(configContent);
    if (configMatch == null) continue;
    final projectName = configMatch.group(1)!;
    final projectCamel = Utils.toCamelCase(projectName);

    // 读取 routes.dart
    final routesFile = File('${project.path}/lib/router/routes.dart');
    if (!await routesFile.exists()) continue;

    final routesContent = await routesFile.readAsLines();

    String? currentComment;
    final routeRegex = RegExp(
      r'''static\s+Route\s+(\w+)\s*=\s*const\s+Route\s*\(\s*name\s*:\s*["']([^"']+)["']\s*,\s*path\s*:\s*["']([^"']+)["']\s*\)''',
    );

    for (final line in routesContent) {
      final trimmed = line.trim();
      // 捕获注释
      if (trimmed.startsWith('/// ')) {
        currentComment = trimmed.replaceAll('/// ', '/// $projectName ');
        continue;
      }

      final match = routeRegex.firstMatch(trimmed);
      if (match != null) {
        final varName = match.group(1)!;
        final name = match.group(2)!;
        final path = match.group(3)!;

        final newVarName =
            '${projectCamel}${varName[0].toUpperCase()}${varName.substring(1)}';

        // 添加缩进 2 个空格
        if (currentComment != null) {
          allRoutes.add('  $currentComment');
          currentComment = null;
        }

        allRoutes.add(
          '  static Route $newVarName = const Route('
          "name: '$projectName.$name',"
          "path: '/$projectName$path'"
          ');\n',
        );
      }
    }
  }

  return allRoutes;
}

/// 更新 routes.dart 文件
Future<void> updateRoutesFile(
  String routesFilePath,
  List<String> newRoutes,
) async {
  try {
    final file = File(routesFilePath);
    if (!await file.exists()) throw Exception('文件不存在: $routesFilePath');

    final content = await file.readAsString();

    // 找到 /// generate 注释的位置
    final generateIndex = content.indexOf('/// generate');
    if (generateIndex == -1) throw Exception('❌ 未找到 /// generate 注释');

    // 保留 /// generate 及其上方内容
    final head = content.substring(0, generateIndex + '/// generate \\'.length);

    // 拼接新的 Route 内容
    final newContent = [head, '', ...newRoutes, '', '}'].join('\n');

    await file.writeAsString(newContent);
    print('✅ project routes.dart 已更新');
  } catch (e) {
    print(e);
  }
}

Future<void> main() async {
  final newRoutes = await loadAllRoutesWithProjectName('lib/packages');
  await updateRoutesFile('lib/router/routes.dart', newRoutes);
}
