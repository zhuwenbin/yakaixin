import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/order_service.dart';
import '../models/create_order_request.dart';
import '../models/order_model.dart';

part 'order_provider.freezed.dart';
part 'order_provider.g.dart';

/// 订单状态
/// 遵守 MVVM: ViewModel 管理所有业务状态
@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    @Default(false) bool isCreatingOrder, // 创建订单中
    @Default(false) bool isLoadingPayModes, // 加载支付方式中
    @Default(false) bool isPaying, // 支付中
    String? orderId,
    String? flowId,
    List<Map<String, dynamic>>? payModes,
    String? error,
  }) = _OrderState;
}

/// 订单 Provider
/// 职责: 
///   1. 创建订单业务逻辑
///   2. 获取支付方式业务逻辑
///   3. 调用支付业务逻辑
@riverpod
class OrderNotifier extends _$OrderNotifier {
  @override
  OrderState build() => const OrderState();

  /// 创建订单
  /// 对应小程序: getOrder (courseDetail.vue Line 417-476)
  /// 业务逻辑:
  ///   1. 创建订单
  ///   2. 判断金额 > 0: 获取支付方式
  ///   3. 判断金额 = 0: 直接返回成功
  Future<CreateOrderResult> createOrder({
    required String goodsId,
    required String goodsMonthsPriceId,
    required String months,
    required double payableAmount,
    required String studentId,
    required String employeeId,
  }) async {
    state = state.copyWith(isCreatingOrder: true, error: null);

    try {
      final service = ref.read(orderServiceProvider);

      // ✅ 构造订单请求 - 对应小程序 Line 422-453
      final request = CreateOrderRequest(
        businessScene: 1,
        goods: [
          OrderGoodsItem(
            goodsId: goodsId,
            goodsMonthsPriceId: goodsMonthsPriceId,
            months: months,
            classCampusId: '',
            classCityId: '',
            goodsNum: '1',
          ),
        ],
        depositAmount: payableAmount,
        payableAmount: payableAmount,
        realAmount: payableAmount,
        remark: '',
        studentAdddatasId: '',
        studentId: studentId,
        totalAmount: payableAmount,
        appId: '', // TODO: 获取微信AppID
        payMethod: '',
        orderType: 10,
        discountAmount: 0,
        couponsIds: [],
        employeeId: employeeId,
        deliveryType: 1,
      );

      // ✅ 调用Service创建订单
      final response = await service.createOrder(request);

      state = state.copyWith(
        isCreatingOrder: false,
        orderId: response.orderId,
        flowId: response.flowId,
      );

      // ✅ 业务逻辑: 判断金额
      if (payableAmount > 0) {
        return CreateOrderResult.needPayment(
          orderId: response.orderId,
          flowId: response.flowId,
        );
      } else {
        return CreateOrderResult.freeOrder(
          orderId: response.orderId,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isCreatingOrder: false,
        error: e.toString(),
      );
      return CreateOrderResult.error(e.toString());
    }
  }

  /// 获取支付方式列表
  /// 对应小程序: getPayModeListNew (courseDetail.vue Line 252-282)
  Future<String?> getWechatPayFinanceBodyId({
    required String orderId,
    required String goodsId,
    required String merchantId,
    required String brandId,
    required String wechatAppId,
  }) async {
    state = state.copyWith(isLoadingPayModes: true, error: null);

    try {
      final service = ref.read(orderServiceProvider);

      // ✅ 获取支付方式列表
      final payModes = await service.getPayModeList(
        accountUse: 1,
        isMatch: 1,
        isUsable: 1,
        page: 1,
        size: 100,
        accountType: 1,
        orderId: orderId,
        goodsIds: goodsId,
        merchantId: merchantId,
        brandId: brandId,
        collectionScene: 1,
        collectionTerminal: 8,
      );

      state = state.copyWith(
        isLoadingPayModes: false,
        payModes: payModes,
      );

      // ✅ 业务逻辑: 查找微信支付方式 (pay_method == '6')
      final wechatPayMode = payModes.cast<Map<String, dynamic>>().firstWhere(
            (item) => item['pay_method'] == '6' && item['wechat_pay_app_id'] == wechatAppId,
            orElse: () => <String, dynamic>{},
          );

      if (wechatPayMode.isEmpty) {
        state = state.copyWith(error: '暂无可用支付方式');
        return null;
      }

      // ✅ 获取支付方式详情
      final detail = await service.getPayModeDetail(wechatPayMode['id'] as String);

      return detail['id']?.toString();
    } catch (e) {
      state = state.copyWith(
        isLoadingPayModes: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// 调用微信支付
  /// 对应小程序: wechatapplet (courseDetail.vue Line 284-316)
  Future<Map<String, dynamic>?> callWechatPay({
    required String flowId,
    required String wechatAppId,
    required String openId,
    required String financeBodyId,
  }) async {
    state = state.copyWith(isPaying: true, error: null);

    try {
      final service = ref.read(orderServiceProvider);

      final payData = await service.callWechatPay(
        flowId: flowId,
        wechatAppId: wechatAppId,
        openId: openId,
        financeBodyId: financeBodyId,
      );

      state = state.copyWith(isPaying: false);

      return payData;
    } catch (e) {
      state = state.copyWith(
        isPaying: false,
        error: e.toString(),
      );
      return null;
    }
  }
}

/// 创建订单结果
@freezed
class CreateOrderResult with _$CreateOrderResult {
  /// 需要支付
  const factory CreateOrderResult.needPayment({
    required String orderId,
    required String flowId,
  }) = _NeedPayment;

  /// 免费订单
  const factory CreateOrderResult.freeOrder({
    required String orderId,
  }) = _FreeOrder;

  /// 错误
  const factory CreateOrderResult.error(String message) = _Error;
}

/// 订单列表 Provider
/// 职责: 获取订单列表并支持分页加载
/// 参数: status - 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
@riverpod
class OrderList extends _$OrderList {
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  Future<List<OrderModel>> build(String status) async {
    return await _loadOrders(page: 1);
  }

  /// 加载订单列表
  /// 对应小程序: getList (order-list.vue Line 119-160)
  Future<List<OrderModel>> _loadOrders({required int page}) async {
    try {
      final service = ref.read(orderServiceProvider);
      
      print('📝 [订单列表] 加载: status=$status, page=$page');
      
      // ✅ 调用真实API，对应小程序 Line 123-128
      final response = await service.getOrderList(
        status: status == '0' ? null : status, // 全部时不传status
        page: page,
        size: 20, // 对应小程序 Line 89: size: 20
      );
      
      print('✅ [订单列表] 加载成功: ${response.list.length} 条');
      
      // ✅ 如果返回空或数据少于20条，说明已到底
      if (response.list.isEmpty || response.list.length < 20) {
        _hasMore = false;
      }
      
      return response.list;
    } catch (e) {
      print('❌ [订单列表] 加载失败: $e');
      throw Exception('加载订单列表失败: $e');
    }
  }

  /// 刷新订单列表
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadOrders(page: 1));
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (!_hasMore) return;
    if (state.isLoading) return;

    final currentOrders = state.value ?? [];
    _currentPage++;

    final moreOrders = await _loadOrders(page: _currentPage);

    if (moreOrders.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncValue.data([...currentOrders, ...moreOrders]);
    }
  }

  /// 获取状态名称
  String _getStatusName(String status) {
    switch (status) {
      case '1':
        return '待支付';
      case '2':
        return '已支付';
      case '4':
        return '已取消';
      default:
        return '未知';
    }
  }
}
