import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/payment/payment_service.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';

part 'payment_provider.g.dart';

/// 支付Provider - 处理订单支付流程
/// 对应小程序的支付逻辑
@riverpod
class Payment extends _$Payment {
  @override
  FutureOr<PaymentState> build() {
    return const PaymentState.initial();
  }

  /// 创建订单
  /// 对应小程序 getOrderV2 接口
  Future<Map<String, String>?> createOrder({
    required String goodsId,
    required String goodsMonthsPriceId,
    required int months,
    required double payableAmount,
  }) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';

      final response = await ref.read(dioClientProvider).post(
        '/c/order/v2',
        data: {
          'business_scene': 1,
          'goods': [
            {
              'goods_id': goodsId,
              'goods_months_price_id': goodsMonthsPriceId,
              'months': months,
              'class_campus_id': '',
              'class_city_id': '',
              'goods_num': '1',
            }
          ],
          'deposit_amount': payableAmount,
          'payable_amount': payableAmount,
          'real_amount': payableAmount,
          'remark': '',
          'student_adddatas_id': '',
          'student_id': studentId,
          'total_amount': payableAmount,
          'pay_method': '',
          'order_type': 10,
          'discount_amount': 0,
          'coupons_ids': [],
          'delivery_type': 1,
        },
      );

      if (response.data['code'] == 100000) {
        final orderId = response.data['data']['order_id']?.toString() ?? '';
        final flowId = response.data['data']['flow_id']?.toString() ?? '';
        
        return {
          'order_id': orderId,
          'flow_id': flowId,
        };
      } else {
        throw Exception(response.data['msg']?.toString() ?? '创建订单失败');
      }
    } catch (e) {
      print('💳 创建订单失败: $e');
      rethrow;
    }
  }

  /// 获取支付方式列表
  /// 对应小程序 payModeListNew 接口
  Future<String?> getPaymentAccount({
    required String goodsId,
    required String orderId,
  }) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      
      // Mock模式下使用默认商户信息
      String merchantId = '408559575579495187';
      String brandId = '408559632588540691';
      
      // 如果有用户信息,优先使用用户的商户信息
      if (userInfo != null) {
        final merchant = userInfo['merchant'] as List?;
        if (merchant != null && merchant.isNotEmpty) {
          merchantId = merchant[0]['merchant_id']?.toString() ?? merchantId;
          brandId = merchant[0]['brand_id']?.toString() ?? brandId;
        }
      }

      final response = await ref.read(dioClientProvider).get(
        '/c/config/finance/account',
        queryParameters: {
          'account_use': 1,
          'is_match': 1,
          'is_usable': 1,
          'page': 1,
          'size': 100,
          'account_type': 1,
          'order_id': orderId,
          'goods_ids': goodsId,
          'merchant_id': merchantId,
          'brand_id': brandId,
          'collection_scene': 1,
          'collection_terminal': 8,
        },
      );

      if (response.data['code'] == 100000) {
        final list = response.data['data']['list'] as List?;
        if (list != null && list.isNotEmpty) {
          // 找到微信支付方式 (pay_method == '6')
          Map<String, dynamic>? wechatAccount;
          try {
            wechatAccount = list.firstWhere(
              (item) => item['pay_method'] == '6',
            ) as Map<String, dynamic>?;
          } catch (e) {
            // 如果没找到微信支付,使用第一个
            wechatAccount = list.first as Map<String, dynamic>?;
          }
          
          return wechatAccount?['id']?.toString();
        }
      }
      
      return null;
    } catch (e) {
      print('💳 获取支付账户失败: $e');
      return null;
    }
  }

  /// 获取支付参数
  /// 对应小程序 wechatapplet 接口
  /// 注意: 小程序返回JSAPI支付参数, APP需要APP支付参数
  Future<Map<String, dynamic>?> getWechatPayParams({
    required String flowId,
    required String financeBodyId,
  }) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final weixinInfo = storage.getJson('weixin_info');
      final openid = weixinInfo?['openid']?.toString() ?? '';

      final response = await ref.read(dioClientProvider).post(
        '/c/pay/wechatpay/jsapi',
        data: {
          'flow_id': flowId,
          'wechat_app_id': '',
          'open_id': openid,
          'finance_body_id': financeBodyId,
        },
      );

      if (response.data['code'] == 100000) {
        final data = response.data['data'];
        // 映射为APP支付参数
        return {
          'appId': data['app_id']?.toString() ?? '',
          'partnerId': data['partner_id']?.toString() ?? '', // APP支付必需
          'prepayId': data['prepay_id']?.toString() ?? '', // APP支付必需
          'package': data['package']?.toString() ?? 'Sign=WXPay',
          'nonceStr': data['nonce_str']?.toString() ?? '',
          'timeStamp': data['time_stamp']?.toString() ?? '',
          'sign': data['sign']?.toString() ?? '', // APP支付签名
        };
      }
      
      return null;
    } catch (e) {
      print('💳 获取支付参数失败: $e');
      return null;
    }
  }

  /// 完整支付流程
  /// 对应小程序的完整支付逻辑
  Future<bool> processPayment({
    required String goodsId,
    required String goodsMonthsPriceId,
    required int months,
    required double payableAmount,
  }) async {
    try {
      print('💳 开始支付流程...');
      
      // 设置loading状态
      state = const AsyncValue.loading();
      
      // 1. 创建订单
      final orderResult = await createOrder(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: payableAmount,
      );
      
      if (orderResult == null) {
        throw Exception('创建订单失败');
      }
      
      final flowId = orderResult['flow_id'] ?? '';
      final orderId = orderResult['order_id'] ?? '';

      // 如果金额为0,直接跳过支付
      if (payableAmount <= 0) {
        state = const AsyncValue.data(PaymentState.success());
        return true;
      }

      // 2. 获取支付账户ID
      final financeBodyId = await getPaymentAccount(
        goodsId: goodsId,
        orderId: orderId,
      );
      
      if (financeBodyId == null) {
        throw Exception('获取支付账户失败');
      }

      // 3. 获取微信支付参数
      final payParams = await getWechatPayParams(
        flowId: flowId,
        financeBodyId: financeBodyId,
      );
      
      if (payParams == null) {
        throw Exception('获取支付参数失败');
      }

      // 4. 调起微信支付
      final result = await PaymentService.requestWechatPayment(
        appId: payParams['appId'] ?? '',
        partnerId: payParams['partnerId'] ?? '',
        prepayId: payParams['prepayId'] ?? '',
        packageValue: payParams['package'] ?? '',
        nonceStr: payParams['nonceStr'] ?? '',
        timeStamp: payParams['timeStamp']?.toString() ?? '',
        sign: payParams['sign'] ?? '',
      );

      if (result.success) {
        print('💳 支付成功!');
        state = const AsyncValue.data(PaymentState.success());
        return true;
      } else {
        print('💳 支付失败: ${result.errorMessage}');
        throw Exception(result.errorMessage ?? '支付失败');
      }
    } catch (e, stack) {
      print('💳 支付流程异常: $e');
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// 支付状态
class PaymentState {
  final String? orderId;
  final String? flowId;
  final bool isSuccess;

  const PaymentState({
    this.orderId,
    this.flowId,
    this.isSuccess = false,
  });

  const PaymentState.initial() : this();
  
  const PaymentState.orderCreated({
    required String orderId,
    required String flowId,
  }) : this(orderId: orderId, flowId: flowId);
  
  const PaymentState.success() : this(isSuccess: true);
}
