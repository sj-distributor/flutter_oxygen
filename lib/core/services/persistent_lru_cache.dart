/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06 09:48:00
 */

import 'cache_service.dart';
import 'lru_cache_service.dart';

/// 持久化 LRU 缓存
///
/// 结合内存 LRU 缓存和 SharedPreferences 持久化存储，实现两层缓存架构：
/// - 第一层：内存 LRU 缓存，快速访问，自动淘汰
/// - 第二层：SharedPreferences 持久化，App 重启后可恢复
///
/// 使用示例（无过期时间）：
/// ```dart
/// final cache = PersistentLruCache<UserEntity>(
///   cacheKey: 'user_cache',
///   maxSize: 100,
///   fromJson: (json) => UserEntity.fromJson(json),
///   toJson: (entity) => entity.toJson(),
/// );
///
/// await cache.init();
/// await cache.put('user_1', user);
/// final user = cache.get('user_1');
/// ```
///
/// 使用示例（带过期时间）：
/// ```dart
/// final cache = PersistentLruCache<ApiResponse>(
///   cacheKey: 'api_cache',
///   maxSize: 100,
///   expiration: Duration(hours: 1),  // 1 小时过期
///   fromJson: (json) => ApiResponse.fromJson(json),
///   toJson: (entity) => entity.toJson(),
/// );
/// ```
class PersistentLruCache<V> {
  /// 持久化存储的 key 前缀
  final String cacheKey;

  /// 最大缓存数量
  final int maxSize;

  /// 过期时间（可选，null 表示永不过期）
  final Duration? expiration;

  /// JSON 反序列化函数
  final V Function(Map<String, dynamic> json) fromJson;

  /// JSON 序列化函数
  final Map<String, dynamic> Function(V value) toJson;

  /// 是否在内存淘汰时也从磁盘删除
  final bool evictFromDisk;

  /// 内存 LRU 缓存
  late final LruCacheServiceCore<String, _CacheEntry<V>> _memoryCache;

  /// 缓存索引（用于持久化 keys）
  final Set<String> _keysIndex = {};

  /// 是否启用过期时间
  bool get hasExpiration => expiration != null;

  PersistentLruCache({
    required this.cacheKey,
    required this.maxSize,
    required this.fromJson,
    required this.toJson,
    this.expiration,
    this.evictFromDisk = false,
  });

  /// 初始化：从磁盘恢复缓存数据到内存
  Future<void> init() async {
    _memoryCache = LruCacheServiceCore<String, _CacheEntry<V>>(
      maxSize: maxSize,
    );

    // 从磁盘恢复索引
    final keysJson = CacheServiceCore.getList<String>(_indexKey);
    if (keysJson != null && keysJson.isNotEmpty) {
      _keysIndex.addAll(keysJson);

      // 恢复数据到内存（只恢复 maxSize 个）
      int count = 0;
      for (final key in keysJson) {
        if (count >= maxSize) break;

        final json = CacheServiceCore.getMap(_itemKey(key));
        if (json != null) {
          try {
            final entry = _parseFromDisk(json);
            if (entry == null) {
              // 数据已过期或无效
              await _removeFromDisk(key);
              continue;
            }
            _memoryCache.put(key, entry);
            count++;
          } catch (e) {
            // 反序列化失败，移除损坏的数据
            await _removeFromDisk(key);
          }
        }
      }
    }
  }

  /// 获取缓存数据
  V? get(String key) {
    // 先查内存
    final entry = _memoryCache.get(key);
    if (entry != null) {
      if (entry.isExpired) {
        remove(key);
        return null;
      }
      return entry.value;
    }

    // 内存 miss，查磁盘
    if (_keysIndex.contains(key)) {
      final json = CacheServiceCore.getMap(_itemKey(key));
      if (json != null) {
        try {
          final entry = _parseFromDisk(json);
          if (entry == null) {
            _removeFromDisk(key);
            return null;
          }
          // 加载到内存
          _memoryCache.put(key, entry);
          return entry.value;
        } catch (e) {
          // 反序列化失败
          _removeFromDisk(key);
        }
      }
    }

    return null;
  }

  /// 存入缓存数据（同时写入内存和磁盘）
  Future<void> put(String key, V value) async {
    final expiresAt = expiration != null
        ? DateTime.now().add(expiration!)
        : null;

    final entry = _CacheEntry(value, expiresAt);
    _memoryCache.put(key, entry);

    // 写入磁盘
    await _saveToDisk(key, entry);
  }

  /// 批量存入
  Future<void> putAll(Map<String, V> entries) async {
    for (final entry in entries.entries) {
      await put(entry.key, entry.value);
    }
  }

  /// 移除指定 key
  Future<V?> remove(String key) async {
    final entry = _memoryCache.remove(key);
    await _removeFromDisk(key);
    return entry?.value;
  }

  /// 清空所有缓存
  Future<void> clear() async {
    _memoryCache.clear();

    // 清空磁盘
    for (final key in _keysIndex.toList()) {
      await CacheServiceCore.remove(_itemKey(key));
    }
    _keysIndex.clear();
    await _saveIndex();
  }

  /// 检查是否包含 key
  bool containsKey(String key) {
    return _memoryCache.containsKey(key) || _keysIndex.contains(key);
  }

  /// 获取当前内存缓存大小
  int get memorySize => _memoryCache.length;

  /// 获取磁盘缓存大小
  int get diskSize => _keysIndex.length;

  /// 获取所有缓存的键
  Iterable<String> get keys => _keysIndex;

  /// 手动淘汰内存缓存到指定大小
  void evictMemoryToSize(int targetSize) {
    _memoryCache.evictToSize(targetSize);
  }

  /// 同步磁盘数据：将当前内存中的所有数据持久化
  Future<void> syncToDisk() async {
    for (final entry in _memoryCache.entries) {
      await _saveToDisk(entry.key, entry.value);
    }
  }

  /// 预加载数据到内存（从磁盘加载指定的 keys）
  Future<void> preload(List<String> keys) async {
    for (final key in keys) {
      get(key); // get 会自动从磁盘加载到内存
    }
  }

  /// 清理过期数据
  Future<void> cleanExpired() async {
    if (!hasExpiration) return;

    for (final key in _keysIndex.toList()) {
      final entry = _memoryCache.get(key);
      if (entry != null && entry.isExpired) {
        await remove(key);
      }
    }
  }

  // ========== 私有方法 ==========

  /// 索引存储 key
  String get _indexKey => '${cacheKey}_index';

  /// 单项数据存储 key
  String _itemKey(String key) => '${cacheKey}_item_$key';

  /// 解析磁盘数据
  _CacheEntry<V>? _parseFromDisk(Map<String, dynamic> json) {
    DateTime? expiresAt;
    Map<String, dynamic> valueJson;

    // 兼容带过期时间和不带过期时间的格式
    if (json.containsKey('_expiresAt')) {
      final expiresAtStr = json['_expiresAt'] as String?;
      if (expiresAtStr != null) {
        expiresAt = DateTime.parse(expiresAtStr);
        // 检查是否过期
        if (DateTime.now().isAfter(expiresAt)) {
          return null;
        }
      }
      valueJson = json['_value'] as Map<String, dynamic>;
    } else {
      valueJson = json;
    }

    final value = fromJson(valueJson);
    return _CacheEntry(value, expiresAt);
  }

  /// 保存到磁盘
  Future<void> _saveToDisk(String key, _CacheEntry<V> entry) async {
    Map<String, dynamic> json;

    if (entry.expiresAt != null) {
      // 带过期时间的格式
      json = {
        '_expiresAt': entry.expiresAt!.toIso8601String(),
        '_value': toJson(entry.value),
      };
    } else {
      // 不带过期时间的格式
      json = toJson(entry.value);
    }

    await CacheServiceCore.setMap(_itemKey(key), json);

    // 更新索引
    if (!_keysIndex.contains(key)) {
      _keysIndex.add(key);
      await _saveIndex();
    }
  }

  /// 从磁盘移除
  Future<void> _removeFromDisk(String key) async {
    await CacheServiceCore.remove(_itemKey(key));
    _keysIndex.remove(key);
    await _saveIndex();
  }

  /// 保存索引到磁盘
  Future<void> _saveIndex() async {
    await CacheServiceCore.setList(_indexKey, _keysIndex.toList());
  }

  @override
  String toString() {
    final expirationStr = expiration != null
        ? ', expiration: ${expiration!.inSeconds}s'
        : '';
    return 'PersistentLruCache(memory: ${_memoryCache.length}/$maxSize, disk: ${_keysIndex.length}$expirationStr)';
  }
}

/// 缓存条目（内部使用）
class _CacheEntry<V> {
  final V value;
  final DateTime? expiresAt;

  _CacheEntry(this.value, this.expiresAt);

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
