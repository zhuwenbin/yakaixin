import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/create_order_request.dart';
import '../models/order_model.dart';

/// 订单服务
/// 对应小程序: getOrderV2, orderList, payModeListNew, wechatapplet
/// 职责: 封装订单相关API调用
class OrderService {
  final DioClient _dioClient;

  OrderService(this._dioClient);

  /// 创建订单
  /// 对应小程序: getOrderV2 (api/index.js Line 898-907)
  /// 接口: POST /c/order/v2
  /// ✅ Content-Type: application/json (对应小程序Line 904)
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      final response = await _dioClient.post(
        '/c/order/v2',
        data: request.toJson(),
        // ✅ 对应小程序: header: { 'Content-Type': 'application/json' }
        options: Options(
          contentType: 'application/json',
          

        ),
      );

      // ✅ 统一处理响应码
      // 对应记忆: 小程序使用 code: 100000 表示成功
      if (response.data['code'] != 100000 && response.data['code'] != 0) {
        // ✅ msg 可能是字符串或数组
        final msg = response.data['msg'];
        final errorMsg = msg is List ? msg.first : msg?.toString();
        throw Exception(errorMsg ?? '创建订单失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('订单数据为空');
      }

      return CreateOrderResponse.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('创建订单失败: $e');
    }
  }

  /// 获取订单列表
  /// 对应小程序: orderList (api/index.js Line 908-914)
  /// 接口: GET /c/order/my/list
  /// 参数:
  ///   - status: 订单状态 (0:全部 1:待支付 2:已支付 4:已取消)
  ///   - page: 页码
  ///   - size: 每页数量
  Future<OrderListResponse> getOrderList({
    String? status, // ✅ status='0' 时不传参（获取全部）
    required int page,
    required int size,
  }) async {
    try {
      // ✅ 构造查询参数，对应小程序 Line 123-128
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };
      
      // ✅ 只有当 status 不为 '0' 时才传递 status 参数
      if (status != null && status != '0') {
        queryParams['status'] = status;
      }
      
      print('✅ [订单列表] 请求参数: $queryParams');
      
      final response = await _dioClient.get(
        '/c/order/my/list',
        queryParameters: queryParams,
      );
      
      print('📦 [订单列表] 响应: ${response.data}');
      
      // ✅ 统一处理响应码
      if (response.data['code'] != 100000 && response.data['code'] != 0) {
        final msg = response.data['msg'];
        final errorMsg = msg is List ? msg.first : msg?.toString();
        throw Exception(errorMsg ?? '获取订单列表失败');
      }
      
      final data = response.data['data'];
      if (data == null) {
        return const OrderListResponse(list: [], total: 0);
      }
      
      // ✅ 解析订单列表，对应小程序 Line 129-160
      final list = (data['list'] as List?)?.map((item) {
        final orderItem = item as Map<String, dynamic>;
        
        // ✅ 计算显示字段，对应小程序 Line 131-154
        String? numText;
        String? monthText;
        String? tips;
        
        // 处理 num_text
        final tikuDetails = orderItem['tiku_goods_details'] as Map<String, dynamic>?;
        final goodsType = orderItem['goods_type']?.toString();
        
        if (tikuDetails != null) {
          if (goodsType == '8') {
            // 试卷类型
            final paperNum = tikuDetails['paper_num']?.toString() ?? '0';
            numText = '共${paperNum}份';
          } else if (goodsType == '10') {
            // 模考类型
            final examRoundNum = tikuDetails['exam_round_num']?.toString() ?? '0';
            numText = '共${examRoundNum}轮';
          } else {
            // 默认题目类型
            final questionNum = tikuDetails['question_num']?.toString() ?? '0';
            numText = '共${questionNum}题';
          }
        }
        
        // 处理 month_text
        final months = orderItem['months'];
        if (months != null) {
          if (months == 0 || months == '0') {
            monthText = '永久';
          } else {
            monthText = '${months}个月';
          }
        }
        
        // 处理 tips
        final teachingSystem = orderItem['teaching_system'] as Map<String, dynamic>?;
        if (goodsType == '10') {
          // 模考显示开考时间
          tips = '开考时间:${tikuDetails?['exam_time'] ?? ''}';
        } else {
          tips = teachingSystem?['system_id_name']?.toString() ?? '';
        }
        
        // ✅ 添加计算字段到 orderItem
        orderItem['num_text'] = numText;
        orderItem['month_text'] = monthText;
        orderItem['tips'] = tips;
        
        return OrderModel.fromJson(orderItem);
      }).toList() ?? [];
      
      final total = data['total'] as int? ?? 0;
      
      print('✅ [订单列表] 解析成功: ${list.length} 条记录');
      
      return OrderListResponse(list: list, total: total);
    } catch (e) {
      print('❌ [订单列表] 失败: $e');
      throw Exception('获取订单列表失败: $e');
    }
  }
  /// 对应小程序: payModeListNew (courseDetail.vue Line 254-281)
  /// 接口: GET /c/config/finance/account
  Future<List<Map<String, dynamic>>> getPayModeList({
    required int accountUse,
    required int isMatch,
    required int isUsable,
    required int page,
    required int size,
    required int accountType,
    required String orderId,
    required String goodsIds,
    required String merchantId,
    required String brandId,
    required int collectionScene,
    required int collectionTerminal,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/config/finance/account',
        queryParameters: {
          'account_use': accountUse,
          'is_match': isMatch,
          'is_usable': isUsable,
          'page': page,
          'size': size,
          'account_type': accountType,
          'order_id': orderId,
          'goods_ids': goodsIds,
          'merchant_id': merchantId,
          'brand_id': brandId,
          'collection_scene': collectionScene,
          'collection_terminal': collectionTerminal,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取支付方式失败');
      }

      final list = response.data['data']?['list'] as List?;
      if (list == null) {
        return [];
      }

      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('获取支付方式失败: $e');
    }
  }

  /// 获取支付方式详情
  /// 对应小程序: payModeListNewDetail (courseDetail.vue Line 274-278)
  /// 接口: GET /c/config/finance/account/detail
  Future<Map<String, dynamic>> getPayModeDetail(String id) async {
    try {
      final response = await _dioClient.get(
        '/c/config/finance/account/detail',
        queryParameters: {'id': id},
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取支付详情失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('支付详情数据为空');
      }

      return data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('获取支付详情失败: $e');
    }
  }

  /// 调用微信支付
  /// 对应小程序: wechatapplet (api/index.js Line 916-926)
  /// 接口: POST /c/pay/wechatpay/jsapi
  /// ✅ Content-Type: application/json (对应小程序Line 923)
  Future<Map<String, dynamic>> callWechatPay({
    required String flowId,
    required String wechatAppId,
    required String openId,
    required String financeBodyId,
  }) async {
    try {
      final response = await _dioClient.post(
        '/c/pay/wechatpay/jsapi',
        data: {
          'flow_id': flowId,
          'wechat_app_id': wechatAppId,
          'open_id': openId,
          'finance_body_id': financeBodyId,
        },
        // ✅ 对应小程序: header: { 'Content-Type': 'application/json' }
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.data['code'] != 100000 && response.data['code'] != 0) {
        final msg = response.data['msg'];
        final errorMsg = msg is List ? msg.first : msg?.toString();
        throw Exception(errorMsg ?? '调用支付失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('支付数据为空');
      }

      return data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('调用支付失败: $e');
    }
  }
}

/// OrderService Provider
final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(ref.read(dioClientProvider));
});
