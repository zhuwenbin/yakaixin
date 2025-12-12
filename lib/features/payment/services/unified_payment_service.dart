import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wechat_payment_service.dart';
import 'iap_service.dart';
import '../models/wechat_pay_params_model.dart';

/// 统一支付服务
/// 
/// 根据平台自动选择支付方式：
/// - iOS: 使用内购（商品ID直接对应苹果产品ID）
/// - Android: 使用微信支付
/// 
/// 注意：本项目不支持余额充值模式
class UnifiedPaymentService {
  final WechatPaymentService _wechatPayment;
  final IAPService _iapService;

  UnifiedPaymentService(this._wechatPayment, this._iapService);

  /// 初始化支付服务
  Future<bool> initialize() async {
    if (Platform.isIOS) {
      print('🍎 iOS平台，初始化内购服务');
      return await _iapService.initialize();
    } else if (Platform.isAndroid) {
      print('🤖 Android平台，初始化微信支付');
      return await _wechatPayment.initWechat();
    }
    
    print('⚠️ 未知平台');
    return false;
  }

  /// 统一支付入口
  /// 
  /// iOS: 调用内购（异步回调）
  /// Android: 调用微信支付
  Future<PaymentResult> pay({
    required String orderId,
    required String flowId,
    required String goodsId,
    required String financeBodyId,  // ✅ 财务主体ID
    required double amount,
    required String studentId,
    String? goodsName,
    WechatPayParamsModel? wechatParams,
    required void Function(bool success, String? errorMessage) onResult,
  }) async {
    try {
      if (Platform.isIOS) {
        // iOS: 使用内购（异步回调模式）
        print('\n🍎 ========== iOS内购支付 ==========');
        print('   💡 注意: iOS内购是异步回调模式，不会等待支付完成');
        print('   💡 支付结果将通过 onResult 回调通知');
        
        _iapService.purchase(
          orderId: flowId,  // ✅ 使用流水ID，不是订单ID
          goodsId: goodsId,
          financeBodyId: financeBodyId,  // ✅ 财务主体ID
          studentId: studentId,
          goodsName: goodsName,
          callback: (success, errorMessage) {
            print('\n👉 内购结果回调');
            print('   成功: $success');
            print('   错误: $errorMessage');
            onResult(success, errorMessage);
          },
        );
        
        // 💡 iOS内购是异步模式，这里返回“请求已发送”
        // 真正的结果将通过 onResult 回调通知UI
        return PaymentResult.succeeded();
      } else if (Platform.isAndroid) {
        // Android: 使用微信支付
        print('\n🤖 ========== Android微信支付 ==========');
        
        if (wechatParams == null) {
          return PaymentResult.failed('缺少微信支付参数');
        }
        
        return await _wechatPayment.requestPayment(
          appId: wechatParams.appId,
          partnerId: wechatParams.partnerId,
          prepayId: wechatParams.prepayId,
          packageValue: wechatParams.package,
          nonceStr: wechatParams.nonceStr,
          timeStamp: wechatParams.timeStamp,
          sign: wechatParams.sign,
        );
      } else {
        return PaymentResult.failed('不支持的平台');
      }
    } catch (e) {
      print('❌ 支付失败: $e');
      return PaymentResult.failed(e.toString());
    }
  }

  /// 获取平台名称（用于UI显示）
  String getPlatformName() {
    if (Platform.isIOS) {
      return 'Apple Pay';
    } else if (Platform.isAndroid) {
      return '微信支付';
    } else {
      return '未知支付';
    }
  }

  /// 检查是否支持支付
  bool isPaymentSupported() {
    return Platform.isIOS || Platform.isAndroid;
  }
}

/// UnifiedPaymentService Provider
final unifiedPaymentServiceProvider = Provider<UnifiedPaymentService>((ref) {
  return UnifiedPaymentService(
    ref.read(wechatPaymentServiceProvider),
    ref.read(iapServiceProvider),
  );
});
