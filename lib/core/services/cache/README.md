# 缓存使用指南

## 目录

1. [CacheStrategy（推荐）](#1-cachestrategy推荐)
2. [CacheRegistry 统一管理](#2-cacheregistry-统一管理)
3. [在 Repository 中使用](#3-在-repository-中使用)
4. [分页列表（Notifier + Repository）](#4-分页列表notifier--repository)
5. [底层缓存类](#5-底层缓存类)

---

## 1. CacheStrategy（推荐）

统一的缓存入口，支持三种模式：

| 模式 | 说明 | 重启后 |
|------|------|--------|
| `CacheMode.memory` | 纯内存 LRU | 数据丢失 |
| `CacheMode.persistent` | 仅磁盘 | 数据保留 |
| `CacheMode.hybrid` | 内存 + 磁盘 | 数据保留 ✅ |

### 基础用法

```dart
import 'package:flutter_template/common/index.dart';

// 创建缓存（自动注册到 CacheRegistry）
final userCache = CacheStrategy<UserEntity>(
  mode: CacheMode.hybrid,
  cacheKey: 'user_cache',
  maxSize: 100,
  expiration: Duration(hours: 1),
  fromJson: UserEntity.fromJson,
  toJson: (e) => e.toJson(),
);

// 初始化
await userCache.init();

// 存取
await userCache.put('user_1', user);
final user = userCache.get('user_1');

// 清理过期
await userCache.cleanExpired();
```

---

## 2. CacheRegistry 统一管理

所有 `CacheStrategy` 默认自动注册，可统一管理：

```dart
// App 启动时（在 bootstrap.dart 中）
await CacheRegistry.initAll();       // 初始化所有缓存
await CacheRegistry.cleanExpiredAll(); // 清理所有过期数据

// 查看已注册的缓存
print(CacheRegistry.registeredKeys);

// 清空所有缓存
await CacheRegistry.clearAll();
```

---

## 3. 在 Repository 中使用

> **推荐架构**：缓存放在 Repository 层，对 Notifier 透明。

### 3.1 创建 Provider（user_provider.dart）

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/common/index.dart';
import 'package:flutter_template/views/data/index.dart';

/// 列表缓存 Provider
final userListCacheProvider = Provider<CacheStrategy<List<UserEntity>>>((ref) {
  return CacheStrategy<List<UserEntity>>(
    mode: CacheMode.hybrid,
    cacheKey: 'user_list_cache',
    maxSize: 20,
    expiration: const Duration(minutes: 5),
    fromJson: (json) => (json['items'] as List)
        .map((e) => UserEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    toJson: (list) => {'items': list.map((e) => e.toJson()).toList()},
  );
});

/// 单用户缓存 Provider
final userCacheProvider = Provider<CacheStrategy<UserEntity>>((ref) {
  return CacheStrategy<UserEntity>(
    mode: CacheMode.hybrid,
    cacheKey: 'user_cache',
    maxSize: 100,
    expiration: const Duration(hours: 1),
    fromJson: UserEntity.fromJson,
    toJson: (e) => e.toJson(),
  );
});

/// Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.read(userApiProvider);
  final listCache = ref.read(userListCacheProvider);
  final userCache = ref.read(userCacheProvider);

  final repo = UserRepository(
    api,
    listCache: listCache,
    userCache: userCache,
  );
  repo.init();
  return repo;
});
```

### 3.2 Repository 实现

```dart
class UserRepository {
  final UserApiService _api;
  final CacheStrategy<List<UserEntity>>? _listCache;
  final CacheStrategy<UserEntity>? _userCache;

  UserRepository(this._api, {
    CacheStrategy<List<UserEntity>>? listCache,
    CacheStrategy<UserEntity>? userCache,
  })  : _listCache = listCache,
        _userCache = userCache;

  Future<void> init() async {
    await _listCache?.init();
    await _userCache?.init();
  }

  /// 获取用户列表（缓存优先）
  Future<List<UserEntity>> getUsers({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'page_$page';

    if (!forceRefresh) {
      final cached = _listCache?.get(cacheKey);
      if (cached != null) return cached;
    }

    final result = await _api.getUserList(page: page);
    final entities = result?.data ?? [];

    if (entities.isNotEmpty) {
      await _listCache?.put(cacheKey, entities);
      for (final user in entities) {
        await _userCache?.put(user.id, user);
      }
    }

    return entities;
  }

  /// 根据 ID 获取
  UserEntity? getUserById(String id) => _userCache?.get(id);
}
```

---

## 4. 分页列表（Notifier + Repository）

Notifier 只负责分页逻辑，缓存由 Repository 处理。

```dart
@riverpod
class AsyncUserNotifier extends _$AsyncUserNotifier with PaginationMixin {
  UserRepository get _repository => ref.watch(userRepositoryProvider);

  @override
  FutureOr<List<UserEntity>> build() async {
    resetPagination();
    return await _loadPage();
  }

  Future<List<UserEntity>> _loadPage() async {
    final data = await _repository.getUsers(page: currentPage);
    updatePagination(data.length);
    return data;
  }

  Future<void> loadMore() => safeLoadMore(
        fetch: () => _repository.getUsers(page: currentPage + 1),
        onSuccess: (newData) {
          final current = state.value ?? [];
          state = AsyncValue.data([...current, ...newData]);
        },
      );

  Future<void> refresh() async {
    resetPagination();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadPage);
  }

  UserEntity? getUserById(String id) => _repository.getUserById(id);
}
```

---

## 5. 底层缓存类

如需更底层控制，可直接使用：

| 类 | 说明 |
|----|------|
| `LruCache<K, V>` | 纯内存 LRU，O(1) 性能 |
| `TimedLruCache<K, V>` | 带过期时间的内存 LRU |
| `PersistentLruCache<V>` | 内存 + 磁盘持久化 |

---

## 架构总结

```
┌─────────────────────┐
│   Notifier (UI)     │  ← 只负责 UI 状态 + 分页
│   PaginationMixin   │
└──────────┬──────────┘
           │
┌──────────┴──────────┐
│    Repository       │  ← 缓存在这里
│    CacheStrategy    │
└──────────┬──────────┘
           │
┌──────────┴──────────┐
│    ApiService       │  ← 网络请求
└─────────────────────┘

App 启动时：
  await CacheRegistry.initAll();
  await CacheRegistry.cleanExpiredAll();
```

**好处**：
- 职责分离清晰
- 缓存集中管理（CacheRegistry）
- 三种模式灵活切换
- 自动注册，统一清理过期数据


