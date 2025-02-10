/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-10 10:00:37
 */
class Params {
  Map<String, String> get(List<String> paramsList) {
    Map<String, String> paramsMap = {};

    for (var param in paramsList) {
      if (param.contains('=')) {
        var splitParam = param.split('=');
        if (splitParam.length == 2) {
          var key = splitParam[0].trim();
          var value = splitParam[1].trim();
          paramsMap[key] = value;
        }
      }
    }

    return paramsMap;
  }
}
