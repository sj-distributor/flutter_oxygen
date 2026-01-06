/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06 09:31:00
 */

/// LRU (Least Recently Used) 缓存实现
///
/// 用于限制内存中缓存的数据量，自动淘汰最久未使用的数据。
///
/// 使用示例：
/// ```dart
/// final cache = LruCacheServiceCore<String, UserEntity>(maxSize: 100);
/// cache.put('user_1', user);
/// final user = cache.get('user_1');
/// ```
class LruCacheServiceCore<K, V> {
  /// 最大缓存数量
  final int maxSize;

  /// 缓存数据存储（使用 LinkedHashMap 保持插入顺序）
  final Map<K, V> _cache = {};

  /// 访问顺序记录（最近访问的在末尾）
  final List<K> _accessOrder = [];

  LruCacheServiceCore({required this.maxSize}) : assert(maxSize > 0);

  /// 获取缓存数据，同时更新访问顺序
  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    // 更新访问顺序：移到末尾
    _accessOrder.remove(key);
    _accessOrder.add(key);

    return _cache[key];
  }

  /// 存入缓存数据
  void put(K key, V value) {
    // 如果 key 已存在，更新值和访问顺序
    if (_cache.containsKey(key)) {
      _cache[key] = value;
      _accessOrder.remove(key);
      _accessOrder.add(key);
      return;
    }

    // 如果达到最大容量，淘汰最久未使用的
    if (_cache.length >= maxSize) {
      _evict();
    }

    _cache[key] = value;
    _accessOrder.add(key);
  }

  /// 批量存入缓存数据
  void putAll(Map<K, V> entries) {
    for (final entry in entries.entries) {
      put(entry.key, entry.value);
    }
  }

  /// 检查是否包含 key
  bool containsKey(K key) => _cache.containsKey(key);

  /// 移除指定 key
  V? remove(K key) {
    _accessOrder.remove(key);
    return _cache.remove(key);
  }

  /// 清空缓存
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  /// 获取当前缓存大小
  int get length => _cache.length;

  /// 获取所有缓存的值
  Iterable<V> get values => _cache.values;

  /// 获取所有缓存的键
  Iterable<K> get keys => _cache.keys;

  /// 获取所有缓存条目
  Iterable<MapEntry<K, V>> get entries => _cache.entries;

  /// 淘汰最久未使用的数据
  void _evict() {
    if (_accessOrder.isEmpty) return;

    final oldestKey = _accessOrder.removeAt(0);
    _cache.remove(oldestKey);
  }

  /// 淘汰多个最久未使用的数据
  void evictCount(int count) {
    for (var i = 0; i < count && _accessOrder.isNotEmpty; i++) {
      _evict();
    }
  }

  /// 淘汰到指定大小
  void evictToSize(int targetSize) {
    while (_cache.length > targetSize && _accessOrder.isNotEmpty) {
      _evict();
    }
  }

  @override
  String toString() =>
      'LruCacheServiceCore(size: ${_cache.length}/$maxSize, keys: ${_accessOrder.join(", ")})';
}

/// 带过期时间的 LRU 缓存
///
/// 缓存项在指定时间后自动过期。
class TimedLruCacheServiceCore<K, V> {
  final int maxSize;
  final Duration expiration;

  final Map<K, _TimedEntry<V>> _cache = {};
  final List<K> _accessOrder = [];

  TimedLruCacheServiceCore({required this.maxSize, required this.expiration})
    : assert(maxSize > 0);

  /// 获取缓存数据（过期数据返回 null）
  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // 检查是否过期
    if (entry.isExpired) {
      remove(key);
      return null;
    }

    // 更新访问顺序
    _accessOrder.remove(key);
    _accessOrder.add(key);

    return entry.value;
  }

  /// 存入缓存数据
  void put(K key, V value) {
    // 如果 key 已存在，更新
    if (_cache.containsKey(key)) {
      _cache[key] = _TimedEntry(value, expiration);
      _accessOrder.remove(key);
      _accessOrder.add(key);
      return;
    }

    // 清理过期数据
    _cleanupExpired();

    // 如果达到最大容量，淘汰最久未使用的
    if (_cache.length >= maxSize) {
      _evict();
    }

    _cache[key] = _TimedEntry(value, expiration);
    _accessOrder.add(key);
  }

  /// 移除指定 key
  V? remove(K key) {
    _accessOrder.remove(key);
    return _cache.remove(key)?.value;
  }

  /// 清空缓存
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  /// 获取当前缓存大小
  int get length => _cache.length;

  /// 清理过期数据
  void _cleanupExpired() {
    final expiredKeys = <K>[];
    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      }
    }
    for (final key in expiredKeys) {
      remove(key);
    }
  }

  void _evict() {
    if (_accessOrder.isEmpty) return;
    final oldestKey = _accessOrder.removeAt(0);
    _cache.remove(oldestKey);
  }
}

/// 带过期时间的缓存条目
class _TimedEntry<V> {
  final V value;
  final DateTime expiresAt;

  _TimedEntry(this.value, Duration expiration)
    : expiresAt = DateTime.now().add(expiration);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
