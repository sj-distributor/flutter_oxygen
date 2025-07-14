/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-10 10:00:37
 */
class Params {
  Map<String, String> get(List<String> paramsList) {
    final Map<String, String> paramsMap = {};

    for (final param in paramsList) {
      // 只分割第一个 '='
      final splitIndex = param.indexOf('=');
      if (splitIndex != -1) {
        final key = param.substring(0, splitIndex).trim();
        final value = param.substring(splitIndex + 1).trim();
        paramsMap[key] = value;
      }
    }

    return paramsMap;
  }
}
