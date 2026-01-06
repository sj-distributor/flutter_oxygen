/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06 10:01:00
 */

import '../services/lru_cache.dart';

/// LRU 缓存 Mixin
///
/// 为任何 Notifier 添加 LRU 缓存能力。
/// 可以与 riverpod_generator 生成的 Notifier 配合使用。
///
/// 使用示例：
/// ```dart
/// @riverpod
/// class AsyncUserNotifier extends _$AsyncUserNotifier
///     with LruCacheMixin<UserEntity> {
///   @override
///   String getItemKey(UserEntity item) => item.id;
///
///   @override
///   FutureOr<List<UserEntity>> build() async {
///     final data = await _fetchData();
///     cacheAll(data);
///     return data;
///   }
/// }
/// ```
mixin LruCacheMixin<T> {
  LruCacheServiceCore<String, T>? _cache;

  /// 获取缓存实例（懒加载）
  LruCacheServiceCore<String, T> get cache {
    _cache ??= LruCacheServiceCore<String, T>(maxSize: maxCacheSize);
    return _cache!;
  }

  /// 最大缓存数量（子类可覆盖，默认 100）
  int get maxCacheSize => 100;

  /// 获取缓存 key（子类必须实现）
  String getItemKey(T item);

  /// 从缓存获取
  T? getFromCache(String key) => cache.get(key);

  /// 添加到缓存
  void addToCache(T item) => cache.put(getItemKey(item), item);

  /// 批量添加到缓存
  void cacheAll(List<T> items) {
    for (final item in items) {
      cache.put(getItemKey(item), item);
    }
  }

  /// 从缓存移除
  T? removeFromCache(String key) => cache.remove(key);

  /// 清空缓存
  void clearCache() => cache.clear();

  /// 当前缓存大小
  int get cacheSize => cache.length;

  /// 淘汰到指定大小
  void evictCacheToSize(int targetSize) => cache.evictToSize(targetSize);

  /// 检查缓存是否包含 key
  bool cacheContains(String key) => cache.containsKey(key);
}
