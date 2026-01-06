/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06
 */

import 'cache_strategy.dart';

/// 缓存注册表
///
/// 提供统一的缓存管理入口，所有 [CacheStrategy] 实例可自动或手动注册到此处。
/// 支持批量初始化、清理过期数据、清空所有缓存等操作。
///
/// 使用示例：
/// ```dart
/// // 1. 创建缓存时自动注册
/// final userCache = CacheStrategy<UserEntity>(
///   mode: CacheMode.hybrid,
///   cacheKey: 'user_cache',
///   autoRegister: true,  // 自动注册到 CacheRegistry
///   ...
/// );
///
/// // 2. 或手动注册
/// CacheRegistry.register('user_cache', userCache);
///
/// // 3. App 启动时统一初始化和清理
/// await CacheRegistry.initAll();
/// await CacheRegistry.cleanExpiredAll();
///
/// // 4. 查看已注册的缓存
/// print(CacheRegistry.registeredKeys);
/// ```
class CacheRegistry {
  CacheRegistry._();

  /// 已注册的缓存实例
  static final Map<String, CacheStrategy<dynamic>> _caches = {};

  /// 注册缓存
  static void register(String key, CacheStrategy<dynamic> cache) {
    _caches[key] = cache;
  }

  /// 注销缓存
  static void unregister(String key) {
    _caches.remove(key);
  }

  /// 获取已注册的缓存 key 列表
  static Iterable<String> get registeredKeys => _caches.keys;

  /// 获取已注册的缓存数量
  static int get registeredCount => _caches.length;

  /// 获取指定缓存（带类型安全检查）
  static CacheStrategy<T>? get<T>(String key) {
    final cache = _caches[key];
    if (cache is CacheStrategy<T>) {
      return cache;
    }
    return null;
  }

  /// 初始化所有已注册的缓存
  static Future<void> initAll() async {
    for (final cache in _caches.values) {
      await cache.init();
    }
  }

  /// 清理所有已注册缓存的过期数据
  static Future<void> cleanExpiredAll() async {
    for (final cache in _caches.values) {
      await cache.cleanExpired();
    }
  }

  /// 清空所有已注册的缓存
  static Future<void> clearAll() async {
    for (final cache in _caches.values) {
      await cache.clear();
    }
  }

  /// 打印缓存统计信息
  static void printStats() {
    print('===== CacheRegistry Stats =====');
    print('Registered caches: ${_caches.length}');
    for (final entry in _caches.entries) {
      print('  - ${entry.key}: ${entry.value}');
    }
    print('================================');
  }

  /// 清空注册表（不清空缓存数据，仅移除注册）
  static void clearRegistry() {
    _caches.clear();
  }
}
