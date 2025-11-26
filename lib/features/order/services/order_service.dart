import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/order_model.dart';

/// 订单服务
/// 对应小程序: src/modules/jintiku/api/index.js orderList接口
class OrderService {
  final DioClient _dioClient;

  OrderService(this._dioClient);

  /// 获取订单列表
  /// GET /c/order/my/list
  /// 参数:
  ///   - page: 页码
  ///   - size: 每页数量
  ///   - status: 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
  Future<OrderListResponse> getOrderList({
    required int page,
    required int size,
    String status = '0',
  }) async {
    final response = await _dioClient.get(
      '/c/order/my/list',
      queryParameters: {
        'page': page,
        'size': size,
        'status': status,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final list = (data['list'] as List<dynamic>?)
            ?.map((item) => _processOrderItem(item as Map<String, dynamic>))
            .toList() ??
        [];

    return OrderListResponse(
      list: list,
      total: data['total'] as int? ?? 0,
    );
  }

  /// 处理订单项数据
  /// 对应小程序: order-list.vue getList方法中的数据处理逻辑
  OrderModel _processOrderItem(Map<String, dynamic> json) {
    final order = OrderModel.fromJson(json);
    final tikuGoodsDetails = order.tikuGoodsDetails ?? {};
    final teachingSystem = order.teachingSystem ?? {};
    final goodsType = order.goodsType;

    // 计算题数/份数/轮数文本
    String numText = '';
    if (goodsType == '8') {
      final paperNum = tikuGoodsDetails['paper_num'];
      numText = '共${paperNum ?? 0}份';
    } else if (goodsType == '10') {
      final examRoundNum = tikuGoodsDetails['exam_round_num'];
      numText = '共${examRoundNum ?? 0}轮';
    } else {
      final questionNum = tikuGoodsDetails['question_num'];
      numText = '共${questionNum ?? 0}题';
    }

    // 计算月数文本
    String monthText = '';
    if (order.months == 0) {
      monthText = '永久';
    } else {
      monthText = '${order.months}个月';
    }

    // 计算提示文本
    String tips = '';
    if (goodsType == '10') {
      final examTime = tikuGoodsDetails['exam_time'];
      tips = '开考时间:${examTime ?? ''}';
    } else {
      final systemIdName = teachingSystem['system_id_name'];
      tips = systemIdName?.toString() ?? '';
    }

    return order.copyWith(
      numText: numText,
      monthText: monthText,
      tips: tips,
    );
  }
}

/// OrderService Provider
final orderServiceProvider = Provider<OrderService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return OrderService(dioClient);
});
