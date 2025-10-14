/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-09-18 15:49:54
 */
import 'dart:io';

import 'package:recase/recase.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'params.dart';
import 'utils.dart';

const _print = print;
String oldProjectName = "";

/// 删除目标文件夹
Future<void> deleteTargetDirectory() async {
  const directories = ['macos', 'windows', 'linux', 'android', 'ios'];

  for (var dir in directories) {
    Utils.deleteDirectory(dir);
  }
}

/// 创建项目
Future<void> createProject({required String projectName}) async {
  try {
    // 执行 'flutter create .' 命令
    final result = await Process.run('flutter', [
      'create',
      '.',
      '--project-name',
      projectName,
    ]);

    // 输出命令的执行结果
    if (result.exitCode == 0) {
      _print('Flutter project created successfully!');
    } else {
      _print('Error occurred while creating Flutter project.');
      _print(result.stderr);
    }
  } catch (e) {
    _print('Failed to run flutter create: $e');
  }
}

/// 修改pubspec.yaml文件
Future<bool> editPubspecFile({required String projectName}) async {
  const filePath = 'pubspec.yaml';
  // 读取 pubspec.yaml 文件
  final file = File(filePath);
  if (!file.existsSync()) {
    _print("$filePath not found");
    return false;
  }

  bool isChange = false;
  final content = file.readAsStringSync();
  final yamlEditor = YamlEditor(content);

  // 解析 YAML 内容
  final yamlDoc = loadYaml(content);

  // 更新版本号
  if (yamlDoc['name'] != null) {
    // 记录旧项目名称
    oldProjectName = yamlDoc['name'];

    yamlEditor.update(['name'], projectName);
    if (!isChange) isChange = true;
  }

  // 写回更新后的内容
  if (isChange) {
    try {
      file.writeAsStringSync(yamlEditor.toString());
      return true;
    } catch (e) {
      _print("Failed to write to file: $e");
    }
  }

  return false;
}

/// Info.plist
Future<void> addNewKeyValueToPlist(
  String filePath,
  String key,
  String value,
) async {
  // 读取 plist 文件
  final file = File(filePath);
  final document = XmlDocument.parse(file.readAsStringSync());

  // 查找 <dict> 标签
  final dictElement = document.findAllElements('dict').first;

  // 创建新的 key-value 元素
  final newKey = XmlElement(XmlName('key'), [], [XmlText(key)]);
  final newValue = XmlElement(XmlName('string'), [], [XmlText(value)]);

  // 将新的 key-value 添加到 dict
  dictElement.children.add(newKey);
  dictElement.children.add(newValue);

  // 将修改后的内容写回文件
  file.writeAsStringSync(document.toXmlString(pretty: true));
}

/// 遍历指定目录及其子目录，并替换文件中的指定文本。
Future<void> traverseAndReplaceText(
  String rootDir,
  String targetText,
  String replacementText,
) async {
  final directory = Directory(rootDir);

  // 如果传入的目录不存在，抛出异常
  if (!await directory.exists()) {
    throw Exception("目录不存在: $rootDir");
  }

  // 遍历目录下的所有文件和子目录
  await for (var entity in directory.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is File) {
      await _replaceTextInFile(entity, targetText, replacementText);
    }
  }
}

/// 在文件中查找并替换指定的文本
Future<void> _replaceTextInFile(
  File file,
  String targetText,
  String replacementText,
) async {
  try {
    // 跳过 .DS_Store 文件或其他非文本文件
    if (file.path.endsWith('.DS_Store')) {
      return;
    }

    // 读取文件内容
    String content = await file.readAsString();

    // 如果文件内容中包含目标文本，则进行替换
    if (content.contains(targetText)) {
      String updatedContent = content.replaceAll(targetText, replacementText);

      // 将替换后的内容写回文件
      await file.writeAsString(updatedContent);
    }
  } catch (e) {}
}

void main(List<String> arguments) async {
  final params = Params().get(arguments);
  final projectName = params["name"];
  final dirs = params["dir"] != null
      ? params["dir"]?.split(",")
      : ["lib", "scripts", "test", "integration_test"];
  if (projectName == null) return;

  String newProjectName = ReCase(projectName).snakeCase;

  // 删除项目文件夹
  await deleteTargetDirectory();

  final isOk = await editPubspecFile(projectName: newProjectName);
  if (!isOk) return;

  // 重新创建项目
  await createProject(projectName: newProjectName);

  // macos Info.plist
  await addNewKeyValueToPlist(
    "macos/Runner/Info.plist",
    "FLTEnableImpeller",
    "true",
  );

  // iOS Info.plist
  await addNewKeyValueToPlist(
    "ios/Runner/Info.plist",
    "FLTEnableImpeller",
    "true",
  );

  // 批量替换import项目名称
  // 批量替换import项目名称 - 并行方式
  if (dirs != null) {
    await Future.wait(
      dirs.map((dir) async {
        return traverseAndReplaceText("./$dir", oldProjectName, newProjectName);
      }),
    );
  }
}
