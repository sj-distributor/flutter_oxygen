import 'dart:io';

Future<void> main() async {
  final packagesDir = Directory('lib/packages');

  if (!await packagesDir.exists()) {
    print('❌ 目录不存在: ${packagesDir.path}');
    return;
  }

  final results = <String, String>{};

  await for (final entity in packagesDir.list()) {
    if (entity is Directory) {
      final projectName = entity.path.split(Platform.pathSeparator).last;
      final configFile = File('${entity.path}/lib/config/config.dart');

      if (await configFile.exists()) {
        final content = await configFile.readAsString();

        // ✅ 使用原始字符串 r'''...''' 避免转义问题
        final regex = RegExp(
          r'''static\s+String\s+projectName\s*=\s*["']([^"']+)["'];''',
        );

        final match = regex.firstMatch(content);

        if (match != null) {
          results[projectName] = match.group(1)!;
          print('✅ $projectName => ${match.group(1)}');
        } else {
          print('⚠️  $projectName 未找到 projectName');
        }
      } else {
        print('⚠️  $projectName 缺少 config.dart 文件');
      }
    }
  }

  print('\n📦 所有结果: $results');
}
