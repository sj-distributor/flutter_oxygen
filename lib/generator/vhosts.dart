/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-30 15:16:01
 */

import 'dart:io';
import 'package:mustache_template/mustache_template.dart' as mustache;

const _print = print;

class Vhosts {
  static bool generate({
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
}
