/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-05-10 17:19:49
 */
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheServiceCore {
  // 私有构造函数
  CacheServiceCore._internal();

  static final CacheServiceCore _instance = CacheServiceCore._internal();

  static CacheServiceCore get instance {
    return _instance;
  }

  // 工厂构造函数，防止误调用
  factory CacheServiceCore() => _instance;

  SharedPreferences? _prefs;
  String? _prefix;

  static Future<void> init(String prefix) async {
    if (_instance._prefs == null) {
      _instance._prefix = prefix;
      _instance._prefs = await SharedPreferences.getInstance();
    }
  }

  /// 根据不同环境获取key
  static String getKey(String key) {
    final prefix = _instance._prefix ?? "dev";
    return "${prefix}_$key";
  }

  /// 存储一个字符串值
  static Future<void> setString(String key, String value) async {
    await _instance._prefs?.setString(getKey(key), value);
  }

  /// 获取一个字符串值，如果不存在返回默认值
  static String? getString(String key, {String? defaultValue}) {
    return _instance._prefs?.getString(getKey(key)) ?? defaultValue;
  }

  /// 存储一个整型值
  static Future<void> setInt(String key, int value) async {
    await _instance._prefs?.setInt(getKey(key), value);
  }

  /// 获取一个整型值，如果不存在返回默认值
  static int? getInt(String key, {int defaultValue = 0}) {
    return _instance._prefs?.getInt(getKey(key)) ?? defaultValue;
  }

  /// 存储一个布尔值
  static Future<void> setBool(String key, bool value) async {
    await _instance._prefs?.setBool(getKey(key), value);
  }

  /// 获取一个布尔值，如果不存在返回默认值
  static bool getBool(String key, {bool defaultValue = false}) {
    return _instance._prefs?.getBool(getKey(key)) ?? defaultValue;
  }

  /// 存储一个Map
  static Future<void> setMap(String key, Map<String, dynamic>? value) async {
    if (value != null) {
      String jsonString = jsonEncode(value);
      await _instance._prefs?.setString(getKey(key), jsonString);
    }
  }

  /// 获取一个Map，如果不存在返回空Map
  static Map<String, dynamic>? getMap(String key) {
    String? jsonString = _instance._prefs?.getString(getKey(key));

    if (jsonString != null) {
      try {
        return jsonDecode(jsonString);
      } catch (e) {
        remove(key);
        return null;
      }
    } else {
      return null;
    }
  }

  /// 存储一个数组
  static Future<void> setList<T>(String key, List<T> value) async {
    String jsonString = jsonEncode(value);
    await _instance._prefs?.setString(getKey(key), jsonString);
  }

  /// 获取一个数组，如果不存在返回空数组
  static List<T>? getList<T>(String key) {
    String? jsonString = _instance._prefs?.getString(getKey(key));
    if (jsonString != null) {
      return (jsonDecode(jsonString) as List).cast<T>();
    } else {
      return [];
    }
  }

  /// 删除指定键的值
  static Future<void> remove(String key) async {
    await _instance._prefs?.remove(getKey(key));
  }

  /// 清空所有存储的值
  static Future<void> clear() async {
    await _instance._prefs?.clear();
  }
}
