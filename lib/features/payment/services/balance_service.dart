import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

/// iOS内购支付服务
/// 负责内购收据验证相关的API调用
/// 
/// 注意：本项目采用商品ID直接对应苹果产品ID的模式，不支持余额充值
class IAPPaymentService {
  final DioClient _dioClient;

  IAPPaymentService(this._dioClient);

  /// 验证苹果支付收据
  /// 接口: POST /c/pay/iap/verify
  /// 
  /// 内购模式说明：
  /// - 商品ID = 苹果产品ID（一一对应）
  /// - 用户购买后直接开通对应商品权限
  /// - 不经过余额充值流程
  Future<Map<String, dynamic>> verifyIAPReceipt({
    required String orderId,
    required String goodsId,
    required String receiptData,
    required String transactionId,
    required String productId,
    required String studentId,
  }) async {
    try {
      final response = await _dioClient.post(
        '/c/pay/iap/verify',
        data: {
          'order_id': orderId,
          'goods_id': goodsId,
          'receipt_data': receiptData,
          'transaction_id': transactionId,
          'product_id': productId,
          'student_id': studentId,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '验证支付失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('验证结果为空');
      }

      return data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('验证支付失败: $e');
    }
  }

}

/// IAPPaymentService Provider
final iapPaymentServiceProvider = Provider<IAPPaymentService>((ref) {
  return IAPPaymentService(ref.read(dioClientProvider));
});

/// 向后兼容：保留旧的 balanceServiceProvider 别名
@Deprecated('请使用 iapPaymentServiceProvider')
final balanceServiceProvider = iapPaymentServiceProvider;
