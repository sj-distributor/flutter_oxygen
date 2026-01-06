/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2026-01-06 10:01:00
 */

/// 分页 Mixin
///
/// 为列表 Notifier 添加分页能力。
///
/// 使用示例：
/// ```dart
/// @riverpod
/// class UserListNotifier extends _$UserListNotifier
///     with LruCacheMixin<UserEntity>, PaginationMixin {
///
///   @override
///   String getItemKey(UserEntity item) => item.id.toString();
///
///   @override
///   FutureOr<List<UserEntity>> build() async {
///     resetPagination();
///     return await loadFirstPage();
///   }
///
///   Future<List<UserEntity>> loadFirstPage() async {
///     final data = await _fetchPage(currentPage, pageSize);
///     updatePagination(data.length);
///     cacheAll(data);
///     return data;
///   }
///
///   Future<void> loadMore() async {
///     await safeLoadMore(
///       fetch: () => _fetchPage(currentPage, pageSize),
///       onSuccess: (newData) {
///         cacheAll(newData);
///         final current = state.value ?? [];
///         state = AsyncValue.data([...current, ...newData]);
///       },
///     );
///   }
/// }
/// ```
mixin PaginationMixin {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  /// 每页数量（子类可覆盖）
  int get pageSize => 10;

  /// 当前页码
  int get currentPage => _page;

  /// 是否有更多数据
  bool get hasMore => _hasMore;

  /// 是否正在加载更多
  bool get isLoadingMore => _isLoadingMore;

  /// 是否可以加载更多
  bool get canLoadMore => _hasMore && !_isLoadingMore;

  /// 重置分页
  void resetPagination() {
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
  }

  /// 设置页码
  void setPage(int page) => _page = page;

  /// 下一页
  void nextPage() => _page++;

  /// 上一页（最小为1）
  void previousPage() {
    if (_page > 1) _page--;
  }

  /// 开始加载更多
  void startLoadingMore() => _isLoadingMore = true;

  /// 结束加载更多
  void stopLoadingMore() => _isLoadingMore = false;

  /// 根据返回数据量更新分页状态
  void updatePagination(int dataLength) {
    _hasMore = dataLength >= pageSize;
  }

  /// 设置是否有更多
  void setHasMore(bool value) => _hasMore = value;

  /// 安全的加载更多（自动处理页码回退）
  ///
  /// [fetch] 获取数据的函数
  /// [onSuccess] 成功时的回调
  /// [onError] 失败时的回调（可选）
  Future<void> safeLoadMore<T>({
    required Future<List<T>> Function() fetch,
    required void Function(List<T> data) onSuccess,
    void Function(Object error)? onError,
  }) async {
    if (!canLoadMore) return;

    startLoadingMore();
    final previousPage = currentPage;

    try {
      nextPage();
      final data = await fetch();
      updatePagination(data.length);
      onSuccess(data);
    } catch (e) {
      setPage(previousPage);
      onError?.call(e);
    } finally {
      stopLoadingMore();
    }
  }
}
