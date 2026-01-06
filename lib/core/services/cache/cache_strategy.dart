/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06
 */

import 'cache_registry.dart';
import 'lru_cache.dart';
import 'persistent_cache.dart';

/// 缓存策略枚举
enum CacheMode {
  /// 仅内存缓存（App 重启后丢失）
  memory,

  /// 仅持久化缓存（SharedPreferences）
  persistent,

  /// 混合模式：内存 + 持久化
  /// - 读取：先查内存，miss 则查磁盘并加载到内存
  /// - 写入：同时写入内存和磁盘
  hybrid,
}

/// 统一缓存策略
///
/// 根据 [CacheMode] 选择不同的缓存实现：
/// - [CacheMode.memory]: 纯内存 LRU 缓存（使用 [LruCache]）
/// - [CacheMode.persistent]: 纯磁盘缓存（使用 [PersistentCache]）
/// - [CacheMode.hybrid]: 内存 + 磁盘组合（本类负责协调）
///
/// 使用示例：
/// ```dart
/// // 仅内存缓存
/// final memoryCache = CacheStrategy<UserEntity>(
///   mode: CacheMode.memory,
///   maxSize: 100,
/// );
///
/// // 持久化缓存
/// final persistentCache = CacheStrategy<UserEntity>(
///   mode: CacheMode.persistent,
///   cacheKey: 'user_cache',
///   maxSize: 100,
///   expiration: Duration(hours: 1),
///   fromJson: UserEntity.fromJson,
///   toJson: (e) => e.toJson(),
/// );
///
/// // 混合模式（推荐）
/// final hybridCache = CacheStrategy<UserEntity>(
///   mode: CacheMode.hybrid,
///   cacheKey: 'user_cache',
///   maxSize: 100,
///   expiration: Duration(hours: 1),
///   fromJson: UserEntity.fromJson,
///   toJson: (e) => e.toJson(),
/// );
/// ```
class CacheStrategy<V> {
  /// 缓存 key 前缀（persistent/hybrid 模式必填）
  final String? cacheKey;

  /// 最大缓存数量
  final int maxSize;

  /// 过期时间（可选，仅 persistent/hybrid 模式有效）
  final Duration? expiration;

  /// JSON 反序列化（persistent/hybrid 模式必填）
  final V Function(Map<String, dynamic> json)? fromJson;

  /// JSON 序列化（persistent/hybrid 模式必填）
  final Map<String, dynamic> Function(V value)? toJson;

  /// 缓存模式
  final CacheMode mode;

  /// 是否自动注册到 CacheRegistry
  final bool autoRegister;

  /// 内存缓存实例（memory/hybrid 模式使用）
  LruCache<String, V>? _memoryCache;

  /// 持久化缓存实例（persistent/hybrid 模式使用）
  PersistentCache<V>? _persistentCache;

  /// 是否已初始化
  bool _initialized = false;

  CacheStrategy({
    required this.maxSize,
    this.cacheKey,
    this.expiration,
    this.fromJson,
    this.toJson,
    this.mode = CacheMode.persistent,
    this.autoRegister = true,
  }) {
    _validateParams();
    _initCaches();
    _autoRegister();
  }

  /// 自动注册到 CacheRegistry
  void _autoRegister() {
    if (autoRegister && cacheKey != null) {
      CacheRegistry.register(cacheKey!, this);
    }
  }

  /// 验证参数
  void _validateParams() {
    if (mode != CacheMode.memory) {
      if (cacheKey == null || cacheKey!.isEmpty) {
        throw ArgumentError('cacheKey is required for persistent/hybrid mode');
      }
      if (fromJson == null || toJson == null) {
        throw ArgumentError(
          'fromJson and toJson are required for persistent/hybrid mode',
        );
      }
    }
  }

  /// 初始化缓存实例
  void _initCaches() {
    switch (mode) {
      case CacheMode.memory:
        _memoryCache = LruCache<String, V>(maxSize: maxSize);
        break;

      case CacheMode.persistent:
        _persistentCache = PersistentCache<V>(
          cacheKey: cacheKey!,
          maxSize: maxSize,
          expiration: expiration,
          fromJson: fromJson!,
          toJson: toJson!,
        );
        break;

      case CacheMode.hybrid:
        // hybrid 模式：独立的内存缓存 + 独立的磁盘缓存
        _memoryCache = LruCache<String, V>(maxSize: maxSize);
        _persistentCache = PersistentCache<V>(
          cacheKey: cacheKey!,
          maxSize: maxSize,
          expiration: expiration,
          fromJson: fromJson!,
          toJson: toJson!,
        );
        break;
    }
  }

  /// 初始化（从磁盘恢复数据）
  ///
  /// 仅 persistent/hybrid 模式需要调用
  Future<void> init() async {
    if (_initialized) return;

    if (_persistentCache != null) {
      await _persistentCache!.init();

      // hybrid 模式：预加载磁盘数据到内存
      if (mode == CacheMode.hybrid && _memoryCache != null) {
        for (final key in _persistentCache!.keys) {
          final value = _persistentCache!.get(key);
          if (value != null) {
            _memoryCache!.put(key, value);
          }
        }
      }
    }

    _initialized = true;
  }

  /// 获取缓存数据
  V? get(String key) {
    switch (mode) {
      case CacheMode.memory:
        return _memoryCache?.get(key);

      case CacheMode.persistent:
        return _persistentCache?.get(key);

      case CacheMode.hybrid:
        // 先查内存
        final memoryValue = _memoryCache?.get(key);
        if (memoryValue != null) return memoryValue;

        // 内存 miss，查磁盘
        final diskValue = _persistentCache?.get(key);
        if (diskValue != null) {
          // 加载到内存
          _memoryCache?.put(key, diskValue);
        }
        return diskValue;
    }
  }

  /// 存入缓存
  Future<void> put(String key, V value) async {
    switch (mode) {
      case CacheMode.memory:
        _memoryCache?.put(key, value);
        break;

      case CacheMode.persistent:
        await _persistentCache?.put(key, value);
        break;

      case CacheMode.hybrid:
        // 同时写入内存和磁盘
        _memoryCache?.put(key, value);
        await _persistentCache?.put(key, value);
        break;
    }
  }

  /// 批量存入
  Future<void> putAll(Map<String, V> entries) async {
    for (final entry in entries.entries) {
      await put(entry.key, entry.value);
    }
  }

  /// 移除指定 key
  Future<V?> remove(String key) async {
    V? value;

    switch (mode) {
      case CacheMode.memory:
        value = _memoryCache?.remove(key);
        break;

      case CacheMode.persistent:
        value = await _persistentCache?.remove(key);
        break;

      case CacheMode.hybrid:
        value = _memoryCache?.remove(key);
        await _persistentCache?.remove(key);
        break;
    }

    return value;
  }

  /// 清空所有缓存
  Future<void> clear() async {
    _memoryCache?.clear();
    await _persistentCache?.clear();
  }

  /// 检查是否包含 key
  bool containsKey(String key) {
    switch (mode) {
      case CacheMode.memory:
        return _memoryCache?.containsKey(key) ?? false;

      case CacheMode.persistent:
        return _persistentCache?.containsKey(key) ?? false;

      case CacheMode.hybrid:
        return (_memoryCache?.containsKey(key) ?? false) ||
            (_persistentCache?.containsKey(key) ?? false);
    }
  }

  /// 获取所有缓存的键
  Iterable<String> get keys {
    switch (mode) {
      case CacheMode.memory:
        return _memoryCache?.keys ?? [];

      case CacheMode.persistent:
      case CacheMode.hybrid:
        return _persistentCache?.keys ?? [];
    }
  }

  /// 获取缓存大小
  int get length {
    switch (mode) {
      case CacheMode.memory:
        return _memoryCache?.length ?? 0;

      case CacheMode.persistent:
      case CacheMode.hybrid:
        return _persistentCache?.length ?? 0;
    }
  }

  /// 获取内存缓存大小
  int get memorySize => _memoryCache?.length ?? 0;

  /// 获取磁盘缓存大小
  int get diskSize => _persistentCache?.length ?? 0;

  /// 清理过期数据（仅 persistent/hybrid 模式有效）
  Future<void> cleanExpired() async {
    await _persistentCache?.cleanExpired();

    // hybrid 模式：同步清理内存中的过期 key
    if (mode == CacheMode.hybrid && _memoryCache != null) {
      final validKeys = _persistentCache?.keys.toSet() ?? {};
      final memoryKeys = _memoryCache!.keys.toList();
      for (final key in memoryKeys) {
        if (!validKeys.contains(key)) {
          _memoryCache!.remove(key);
        }
      }
    }
  }

  /// 手动淘汰内存缓存到指定大小
  void evictMemoryToSize(int targetSize) {
    _memoryCache?.evictToSize(targetSize);
  }

  @override
  String toString() {
    switch (mode) {
      case CacheMode.memory:
        return 'CacheStrategy(mode: memory, size: ${_memoryCache?.length}/$maxSize)';

      case CacheMode.persistent:
        return 'CacheStrategy(mode: persistent, disk: ${_persistentCache?.length}/$maxSize)';

      case CacheMode.hybrid:
        return 'CacheStrategy(mode: hybrid, memory: ${_memoryCache?.length}, disk: ${_persistentCache?.length}/$maxSize)';
    }
  }
}
