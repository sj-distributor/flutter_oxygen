/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06 09:48:00
 */

import 'cache_service.dart';

/// 纯持久化缓存（仅磁盘）
///
/// 专注于 SharedPreferences 持久化存储，不包含内存缓存。
/// 如需内存 + 磁盘组合，请使用 [CacheStrategy] 的 hybrid 模式。
///
/// 使用示例：
/// ```dart
/// final cache = PersistentCache<UserEntity>(
///   cacheKey: 'user_cache',
///   maxSize: 100,
///   expiration: Duration(hours: 1),
///   fromJson: UserEntity.fromJson,
///   toJson: (e) => e.toJson(),
/// );
///
/// await cache.init();
/// await cache.put('user_1', user);
/// final user = await cache.get('user_1');
/// ```
class PersistentCache<V> {
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

  /// 缓存索引（用于持久化 keys + 访问顺序）
  final List<String> _keysIndex = [];

  /// 是否启用过期时间
  bool get hasExpiration => expiration != null;

  /// 是否已初始化
  bool _initialized = false;

  PersistentCache({
    required this.cacheKey,
    required this.maxSize,
    required this.fromJson,
    required this.toJson,
    this.expiration,
  });

  /// 初始化：从磁盘恢复索引
  Future<void> init() async {
    if (_initialized) return;

    final keysJson = CacheServiceCore.getList<String>(_indexKey);
    if (keysJson != null && keysJson.isNotEmpty) {
      _keysIndex.addAll(keysJson);
    }

    _initialized = true;
  }

  /// 获取缓存数据（从磁盘读取）
  V? get(String key) {
    if (!_keysIndex.contains(key)) return null;

    final json = CacheServiceCore.getMap(_itemKey(key));
    if (json == null) {
      // 索引存在但数据不存在，清理索引
      _keysIndex.remove(key);
      _saveIndex();
      return null;
    }

    try {
      final entry = _parseFromDisk(json);
      if (entry == null) {
        // 数据已过期
        _removeFromDisk(key);
        return null;
      }

      // 更新访问顺序（LRU）
      _updateAccessOrder(key);

      return entry.value;
    } catch (e) {
      // 反序列化失败
      _removeFromDisk(key);
      return null;
    }
  }

  /// 存入缓存数据（写入磁盘）
  Future<void> put(String key, V value) async {
    final expiresAt = expiration != null
        ? DateTime.now().add(expiration!)
        : null;

    final entry = _CacheEntry(value, expiresAt);

    // 如果 key 已存在，更新访问顺序
    if (_keysIndex.contains(key)) {
      _updateAccessOrder(key);
    } else {
      // 新 key，检查容量
      if (_keysIndex.length >= maxSize) {
        // 淘汰最久未使用的（第一个）
        await _evictOldest();
      }
      _keysIndex.add(key);
    }

    // 写入磁盘
    await _saveToDisk(key, entry);
    await _saveIndex();
  }

  /// 批量存入
  Future<void> putAll(Map<String, V> entries) async {
    for (final entry in entries.entries) {
      await put(entry.key, entry.value);
    }
  }

  /// 移除指定 key
  Future<V?> remove(String key) async {
    if (!_keysIndex.contains(key)) return null;

    final value = get(key);
    await _removeFromDisk(key);
    return value;
  }

  /// 清空所有缓存
  Future<void> clear() async {
    for (final key in _keysIndex.toList()) {
      await CacheServiceCore.remove(_itemKey(key));
    }
    _keysIndex.clear();
    await _saveIndex();
  }

  /// 检查是否包含 key
  bool containsKey(String key) => _keysIndex.contains(key);

  /// 获取缓存大小
  int get length => _keysIndex.length;

  /// 获取所有缓存的键
  Iterable<String> get keys => _keysIndex;

  /// 清理过期数据
  Future<void> cleanExpired() async {
    if (!hasExpiration) return;

    for (final key in _keysIndex.toList()) {
      final json = CacheServiceCore.getMap(_itemKey(key));
      if (json != null) {
        final entry = _parseFromDisk(json);
        if (entry == null || entry.isExpired) {
          await _removeFromDisk(key);
        }
      } else {
        // 数据不存在，清理索引
        _keysIndex.remove(key);
      }
    }
    await _saveIndex();
  }

  // ========== 私有方法 ==========

  /// 索引存储 key
  String get _indexKey => '${cacheKey}_index';

  /// 单项数据存储 key
  String _itemKey(String key) => '${cacheKey}_item_$key';

  /// 更新访问顺序（移到末尾）
  void _updateAccessOrder(String key) {
    _keysIndex.remove(key);
    _keysIndex.add(key);
  }

  /// 淘汰最久未使用的数据
  Future<void> _evictOldest() async {
    if (_keysIndex.isEmpty) return;
    final oldestKey = _keysIndex.removeAt(0);
    await CacheServiceCore.remove(_itemKey(oldestKey));
  }

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
  }

  /// 从磁盘移除
  Future<void> _removeFromDisk(String key) async {
    await CacheServiceCore.remove(_itemKey(key));
    _keysIndex.remove(key);
    await _saveIndex();
  }

  /// 保存索引到磁盘
  Future<void> _saveIndex() async {
    await CacheServiceCore.setList(_indexKey, _keysIndex);
  }

  @override
  String toString() {
    final expirationStr = expiration != null
        ? ', expiration: ${expiration!.inSeconds}s'
        : '';
    return 'PersistentCache(size: ${_keysIndex.length}/$maxSize$expirationStr)';
  }
}

/// 缓存条目（内部使用）
class _CacheEntry<V> {
  final V value;
  final DateTime? expiresAt;

  _CacheEntry(this.value, this.expiresAt);

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
