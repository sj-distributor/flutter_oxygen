/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-30 15:12:03
 */

import 'dart:convert';
import 'dart:io';

// import '../../../../lib/config/nginx_config.dart';

import '../generator/vhosts.dart';
import 'params.dart';
import 'utils.dart';

const _print = print;

/// 生成vhosts文件
void generateVHosts({required Map<String, dynamic> config}) {
  // 输出路径
  Directory currentDirectory = Directory.current;
  final webBuildDir = "${currentDirectory.path}/build/web";

  // 改变配置
  if (config['servers'] != null) {
    for (var item in config['servers']) {
      item["cdn"] = false;
      item["host"] = false;
      item["proxy"] = false;
      item[item['type']] = true;
      item["root"] = webBuildDir;
    }
  }

  // 删除文件夹
  Utils.deleteDirectory("$webBuildDir/vhosts");
  final outputDir = Utils.checkAndCreateDirectory("$webBuildDir/vhosts");

  // 生成nginx配置文件
  final isOk = Vhosts.generate(
    data: config,
    template:
        "${currentDirectory.path}/packages/flutter_oxygen/lib/generator/templates/vhosts/nginx.conf.hbs",
    output: "$outputDir/nginx.conf",
  );

  if (isOk) _print("output: $outputDir/nginx.conf");
}

Future<Map<String, dynamic>> readNginxConfig(String filePath) async {
  try {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: \$filePath');
    }

    final jsonString = await file.readAsString();
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    return jsonData;
  } catch (e) {
    print('Error reading JSON file: \$e');
    return {};
  }
}

void main(List<String> arguments) async {
  final params = Params().get(arguments);
  final path = params["path"];
  if (path == null) return;
  final config = await readNginxConfig(path);
  generateVHosts(config: config);
}
