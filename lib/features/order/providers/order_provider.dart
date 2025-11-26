import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

part 'order_provider.g.dart';

/// 订单列表 Provider
/// 对应小程序: order-list.vue 的订单列表状态管理
@riverpod
class OrderList extends _$OrderList {
  int _page = 1;
  final int _size = 20;
  bool _hasMore = true;
  String _currentStatus = '0';

  @override
  Future<List<OrderModel>> build(String status) async {
    _currentStatus = status;
    _page = 1;
    _hasMore = true;
    return await _loadOrders();
  }

  /// 加载订单列表
  Future<List<OrderModel>> _loadOrders() async {
    final service = ref.read(orderServiceProvider);
    final response = await service.getOrderList(
      page: _page,
      size: _size,
      status: _currentStatus,
    );

    if (response.list.isEmpty || response.list.length < _size) {
      _hasMore = false;
    }

    return response.list;
  }

  /// 加载更多订单
  Future<void> loadMore() async {
    if (!_hasMore) return;

    final currentState = await future;
    _page++;

    final newOrders = await _loadOrders();
    state = AsyncValue.data([...currentState, ...newOrders]);
  }

  /// 刷新订单列表
  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    ref.invalidateSelf();
  }

  /// 是否还有更多数据
  bool get hasMore => _hasMore;
}
