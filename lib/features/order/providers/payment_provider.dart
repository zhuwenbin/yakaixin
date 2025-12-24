import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/utils/error_message_mapper.dart';
import '../../payment/models/wechat_pay_params_model.dart';

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
      print('\n📝 步骤1: 创建订单...');
      print('   goodsId: $goodsId');
      print('   payableAmount: $payableAmount');
      
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';
      
      // ✅ 获取 employee_id（对应小程序 Line 554）
      // 优先使用用户信息中的 employee_id，否则使用默认值
      String employeeId = '508948528815416786'; // 默认推广员ID
      if (userInfo != null) {
        final employeeInfo = userInfo['employee_info'] as Map<String, dynamic>?;
        if (employeeInfo != null && employeeInfo['employee_id'] != null) {
          final empId = employeeInfo['employee_id'].toString();
          if (empId != '0' && empId.isNotEmpty) {
            employeeId = empId;
          }
        }
      }

      // 构建请求数据
      final orderData = {
        // ⚠️ CRITICAL: 因为使用了 contentType: 'application/json',
        // Dio 会在拦截器之前序列化 data，所以拦截器无法添加参数！
        // 必须在这里手动添加所有必需参数（对应小程序 request.js Line 70-73）
        'user_id': studentId,
        'student_id': studentId,
        'merchant_id': '408559575579495187',
        'brand_id': '408559632588540691',
        
        // 订单业务参数
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
          'total_amount': payableAmount,
          'app_id': 'wxf787cf63760d80a0', // ✅ 关键修复：添加微信小程序 AppID（对应小程序 config.js Line 1）
          'pay_method': '',
          'order_type': 10,
          'discount_amount': 0,
          'coupons_ids': [],
        'employee_id': employeeId, // ✅ 关键修复：添加员工ID（对应小程序 Line 554）
        'delivery_type': 1,
      };

      print('\n📤 发送下订单请求:');
      print('   接口: /c/order/v2');
      print('   Content-Type: application/json');
      print('   请求数据: $orderData');
      print('   请求数据类型: ${orderData.runtimeType}');

      final response = await ref.read(dioClientProvider).post(
        '/c/order/v2',
        data: orderData,
        options: Options(
          contentType: 'application/json',
          headers: {
            'Content-Type': 'application/json',  // ✅ 显式设置
          },
        ),
      );

      print('\n📦 下订单响应:');
      print('   statusCode: ${response.statusCode}');
      print('   code: ${response.data['code']}');

      if (response.data['code'] == 100000) {
        final orderId = response.data['data']['order_id']?.toString() ?? '';
        final flowId = response.data['data']['flow_id']?.toString() ?? '';
        final financeBodyId = response.data['data']['finance_body_id']?.toString() ?? '';  // ✅ 获取财务主体ID
        
        print('\n✅ 订单创建成功:');
        print('   orderId: $orderId');
        print('   flowId: $flowId');
        print('   financeBodyId: $financeBodyId');  // ✅ 打印财务主体ID
        
        return {
          'order_id': orderId,
          'flow_id': flowId,
          'finance_body_id': financeBodyId,  // ✅ 返回财务主体ID
        };
      } else {
        final msg = response.data['msg'];
        final errorMsg = msg is List ? msg.first : msg?.toString();
        print('\n❌ 订单创建失败: $errorMsg');
        throw Exception(errorMsg ?? '创建订单失败');
      }
    } on DioException catch (e) {
      print('💳 网络请求失败:');
      print('   类型: ${e.type}');
      print('   消息: ${e.message}');
      print('   状态码: ${e.response?.statusCode}');
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '网络请求失败';
      throw Exception(errorMsg);
    } catch (e) {
      print('💳 创建订单异常: $e');
      throw Exception('创建订单失败，请稍后重试');
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
        '/shop/wxurl',
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

  /// 获取微信支付URL（APP专用）
  /// 与后端约定使用 /shop/wxurl 接口
  /// ✅ 遵守MVVM：返回Model对象
  Future<WechatPayParamsModel?> getWechatPayUrl({
    required String orderId,
    required String flowId,
  }) async {
    try {
      final response = await ref.read(dioClientProvider).post(
        '/shop/wxurl',
        data: {
          'order_id': orderId,
          'flow_id': flowId,
        },
      );

      if (response.data['code'] == 100000) {
        final data = response.data['data'];
        if (data == null) return null;
        
        // ✅ 使用Freezed Model，支持两种命名格式
        // 先尝试下划线格式，如果不存在再尝试驼峰格式
        final normalizedData = {
          'app_id': data['app_id'] ?? data['appId'] ?? '',
          'partner_id': data['partner_id'] ?? data['partnerId'] ?? '',
          'prepay_id': data['prepay_id'] ?? data['prepayId'] ?? '',
          'package': data['package'] ?? 'Sign=WXPay',
          'nonce_str': data['nonce_str'] ?? data['nonceStr'] ?? '',
          'time_stamp': data['time_stamp'] ?? data['timeStamp'] ?? '',
          'sign': data['sign'] ?? '',
        };
        
        return WechatPayParamsModel.fromJson(normalizedData);
      }
      
      return null;
    } catch (e) {
      print('💳 获取微信支付URL失败: $e');
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

  /// 统一支付入口 - 只负责下订单，不管理state
  /// 返回PaymentResult供页面使用
  Future<PaymentResult> startPayment({
    required String goodsId,
    required String goodsMonthsPriceId,
    required int months,
    required double payableAmount,
  }) async {
    try {
      print('\n💳 ========== 开始支付流程 ==========');
      print('📦 商品ID: $goodsId');
      print('💰 金额: $payableAmount');
      
      // ⚠️ 不设置 state，避免 Future already completed 错误
      
      // 1️⃣ 下订单
      final orderResult = await createOrder(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: payableAmount,
      );
      
      if (orderResult == null) {
        return PaymentResult.error('创建订单失败');
      }
      
      final orderId = orderResult['order_id'] ?? '';
      final flowId = orderResult['flow_id'] ?? '';
      final financeBodyId = orderResult['finance_body_id'] ?? '';  // ✅ 获取财务主体ID
      
      print('\n✅ 订单创建成功');
      print('   订单ID: $orderId');
      print('   流水ID: $flowId');
      print('   财务主体ID: $financeBodyId');  // ✅ 打印财务主体ID

      // 2️⃣ 判断金额
      if (payableAmount <= 0) {
        print('\n💰 0元课，支付流程结束');
        return PaymentResult.freeOrder(
          orderId: orderId,
          flowId: flowId,
          goodsId: goodsId,
          financeBodyId: financeBodyId,  // ✅ 传递财务主体ID
        );
      }

      // 3️⃣ 非0元课，返回订单信息，等待跳转确认支付页
      print('\n💵 非0元课，返回订单信息，等待跳转确认支付页');
      return PaymentResult.needPayment(
        orderId: orderId,
        flowId: flowId,
        goodsId: goodsId,
        payableAmount: payableAmount,
        financeBodyId: financeBodyId,  // ✅ 传递财务主体ID
      );
    } on DioException catch (e) {
      print('\n❌ 下订单失败(DioException): $e');
      // ✅ 使用拦截器处理好的友好信息
      final errorMsg = e.error?.toString() ?? '下订单失败，请稍后重试';
      return PaymentResult.error(errorMsg);
    } on Exception catch (e) {
      print('\n❌ 下订单失败(Exception): $e');
      // ✅ Service层抛出的业务异常
      final errorMsg = ErrorMessageMapper.mapException(e);
      return PaymentResult.error(errorMsg);
    } catch (e) {
      print('\n❌ 下订单失败(未预期错误): $e');
      return PaymentResult.error('下订单失败，请稍后重试');
    }
  }
  
  /// 从订单列表继续支付（不创建新订单）
  Future<PaymentResult> continuePayment({
    required String orderId,
    required String flowId,
    required String goodsId,
    required double payableAmount,
  }) async {
    try {
      print('\n💳 从订单列表继续支付');
      print('   订单ID: $orderId');
      
      if (payableAmount <= 0) {
        return PaymentResult.freeOrder(
          orderId: orderId,
          flowId: flowId,
          goodsId: goodsId,
          financeBodyId: '',  // ✅ 继续支付时暂无finance_body_id
        );
      }
      
      return PaymentResult.needPayment(
        orderId: orderId,
        flowId: flowId,
        goodsId: goodsId,
        payableAmount: payableAmount,
        financeBodyId: '',  // ✅ 继续支付时暂无finance_body_id
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器处理好的友好信息
      final errorMsg = e.error?.toString() ?? '继续支付失败，请稍后重试';
      return PaymentResult.error(errorMsg);
    } on Exception catch (e) {
      // ✅ Service层抛出的业务异常
      final errorMsg = ErrorMessageMapper.mapException(e);
      return PaymentResult.error(errorMsg);
    } catch (e) {
      return PaymentResult.error('继续支付失败，请稍后重试');
    }
  }
}

/// 支付状态 (Provider状态管理)
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

/// 支付结果 (方法返回值)
class PaymentResult {
  final bool isSuccess;
  final bool isFreeOrder;
  final String? orderId;
  final String? flowId;
  final String? goodsId;
  final String? financeBodyId;  // ✅ 财务主体ID
  final double? payableAmount;
  final String? errorMessage;
  
  const PaymentResult({
    required this.isSuccess,
    this.isFreeOrder = false,
    this.orderId,
    this.flowId,
    this.goodsId,
    this.financeBodyId,  // ✅ 财务主体ID
    this.payableAmount,
    this.errorMessage,
  });
  
  /// 0元课成功
  const PaymentResult.freeOrder({
    required String orderId,
    required String flowId,
    required String goodsId,
    String? financeBodyId,  // ✅ 财务主体ID
  }) : this(
    isSuccess: true,
    isFreeOrder: true,
    orderId: orderId,
    flowId: flowId,
    goodsId: goodsId,
    financeBodyId: financeBodyId,  // ✅ 传递财务主体ID
  );
  
  /// 需要支付（非0元课）
  const PaymentResult.needPayment({
    required String orderId,
    required String flowId,
    required String goodsId,
    required double payableAmount,
    String? financeBodyId,  // ✅ 财务主体ID
  }) : this(
    isSuccess: true,
    isFreeOrder: false,
    orderId: orderId,
    flowId: flowId,
    goodsId: goodsId,
    payableAmount: payableAmount,
    financeBodyId: financeBodyId,  // ✅ 传递财务主体ID
  );
  
  /// 失败
  const PaymentResult.error(String message) : this(
    isSuccess: false,
    errorMessage: message,
  );
}
