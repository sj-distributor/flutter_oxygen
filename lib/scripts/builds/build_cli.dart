/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-02-12 20:22:32
 */
import "dart:io";

import "package:mustache_template/mustache_template.dart" as mustache;
import 'package:xml/xml.dart';

const _print = print;

/// build cli
class BuildCli {
  /// 生成文件
  /// [data] 模板数据
  /// [template] 模板文件路径
  /// [output] 生成文件路径
  /// return 是否生成成功
  bool generate({
    required Map<String, dynamic> data,
    required String template,
    required String output,
  }) {
    bool generateStatus = false;
    try {
      final templateFile = File(template);
      final templateContent = templateFile.readAsStringSync();
      final temp = mustache.Template(templateContent, htmlEscapeValues: false);

      final outputValue = temp.renderString(data);

      final outputFile = File(output);
      outputFile.writeAsStringSync(outputValue);

      generateStatus = true;
    } catch (e) {
      _print("error: generate ${e.toString()}");
    }

    return generateStatus;
  }

  /// 创建macos配置文件
  Future<void> runFlutterCreateMacOS({
    required String domain,
    required String platforms,
    required String projectName,
  }) async {
    await Process.run('flutter', [
      'create',
      '.',
      '--platforms=$platforms',
      '--org=$domain',
      '--project-name=$projectName'
    ]);
    await Process.run('flutter', ['pub', 'run', 'flutter_launcher_icons:main']);
  }

  /// 修改Xml值
  Future<void> updateXmlValue({
    required String filePath,
    required String key,
    required String value,
  }) async {
    // const filePath = 'macos/Runner/Info.plist';
    final file = File(filePath);

    if (!await file.exists()) {
      _print('Info.plist file does not exist');
      return;
    }

    final document = XmlDocument.parse(await file.readAsString());
    final dictElement = document.findAllElements('dict').first;

    bool keyFound = false;
    for (var element in dictElement.children) {
      if (element is XmlElement &&
          element.name.local == 'key' &&
          element.innerText == key) {
        keyFound = true;
      }
      if (keyFound && element is XmlElement && element.name.local == 'string') {
        element.innerText = value;
        break;
      }
    }

    if (!keyFound) {
      _print('Key not found');
      return;
    }

    await file.writeAsString(document.toXmlString(pretty: true, indent: '  '));
  }

  /// Replaces the bundle identifier in the given file.
  Future<void> replaceBundleIdentifier({
    required String filePath,
    required String newIdentifier,
  }) async {
    final content = await File(filePath).readAsString();

    // 改进后的正则表达式
    final pattern = RegExp(
      r'(PRODUCT_BUNDLE_IDENTIFIER = )([\w.]+?)(\.RunnerTests)?;',
      dotAll: true,
    );

    final newContent = content.replaceAllMapped(pattern, (match) {
      final prefix = match.group(1)!; // "PRODUCT_BUNDLE_IDENTIFIER = "
      final suffix = match.group(3); // 可能存在的 ".RunnerTests"
      return '$prefix$newIdentifier${suffix ?? ""};'; // 保留后缀
    });

    await File(filePath).writeAsString(newContent);
  }

  /// 生成web文件
  bool web({
    required Map<String, dynamic> data,
    required String template,
    required String output,
  }) {
    return generate(data: data, template: template, output: output);
  }

  /// 生成android文件
  bool android({
    required Map<String, dynamic> data,
    String template = "./templates/android/build.gradle.hbs",
    required String output,
  }) {
    // 环境
    String env = data["env"];
    bool isDev = env == "dev";
    bool isTest = env == "test";

    String projectName = data["projectName"];

    // signingConfigs
    data["signingConfigs"] = {
      "name": env,
      "keyAlias": data["namespace"],
      "keyPassword": data["password"],
      "storeFile": "../${projectName}_$env.jks",
      "storePassword": data["password"]
    };

    if (isDev) {
      data["signingConfigs"] = null;
    }

    data["buildTypes"] = {
      "name": isDev ? "debug" : "release",
      "isMinifyEnabled": false,
      "isShrinkResources": false,
      "resValue": 'resValue("string", "app_name", "${data["appName"]}")',
      "signingConfig": !isDev
          ? 'signingConfigs.getByName("$env")'
          : 'signingConfigs.getByName("debug")',
    };

    //  flavor
    data["productFlavors"] = {
      "name": isTest ? "uat" : env,
      "appName": data["appName"],
      "signingConfig": !isDev ? "signingConfigs.$env" : "signingConfigs.debug",
    };

    return generate(data: data, template: template, output: output);
  }

  /// 生成window文件
  bool window({
    required Map<String, dynamic> data,
    required String template,
    required String output,
  }) {
    return generate(data: data, template: template, output: output);
  }

  /// 生成mac文件
  bool macos({
    required Map<String, dynamic> data,
    required String template,
    required String output,
  }) {
    return generate(data: data, template: template, output: output);
  }
}
