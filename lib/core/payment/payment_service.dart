import 'dart:async';
import 'package:fluwx/fluwx.dart';
import '../../app/constants/app_constants.dart';

/// 支付服务 - 处理微信支付
/// 对应小程序的支付功能
/// 使用fluwx SDK实现
class PaymentService {
  static final Fluwx _fluwx = Fluwx();
  static FluwxCancelable? _paymentSubscription;
  
  /// 初始化微信SDK
  static Future<bool> initWechat() async {
    try {
      await _fluwx.registerApi(
        appId: AppConstants.wechatAppId,
        universalLink: AppConstants.wechatUniversalLink,
      );
      print('💳 微信SDK初始化成功');
      print('💳 AppID: ${AppConstants.wechatAppId}');
      return true;
    } catch (e) {
      print('💳 微信SDK初始化失败: $e');
      return false;
    }
  }
  
  /// 发起微信支付
  /// 
  /// 参数与小程序 uni.requestPayment 对应:
  /// - appId: 微信开放平台审核通过的应用APPID
  /// - partnerId: 微信支付分配的商户号(从后端返回)
  /// - prepayId: 预支付交易会话ID
  /// - packageValue: 扩展字段(小程序中为 package)
  /// - nonceStr: 随机字符串
  /// - timeStamp: 时间戳
  /// - sign: 签名
  static Future<PaymentResult> requestWechatPayment({
    required String appId,
    required String partnerId,
    required String prepayId,
    required String packageValue,
    required String nonceStr,
    required String timeStamp,
    required String sign,
  }) async {
    try {
      print('💳 发起微信支付...');
      print('💳 appId: $appId');
      print('💳 partnerId: $partnerId');
      print('💳 prepayId: $prepayId');
      
      final completer = Completer<PaymentResult>();
      
      // 监听支付结果
      _paymentSubscription?.cancel();
      _paymentSubscription = _fluwx.addSubscriber((response) {
        if (response is WeChatPaymentResponse) {
          print('💳 支付结果回调: errCode=${response.errCode}');
          
          if (!completer.isCompleted) {
            if (response.errCode == 0) {
              completer.complete(PaymentResult(
                success: true,
                errorCode: '0',
                errorMessage: '支付成功',
              ));
            } else if (response.errCode == -2) {
              completer.complete(PaymentResult(
                success: false,
                errorCode: '-2',
                errorMessage: '用户取消支付',
              ));
            } else {
              completer.complete(PaymentResult(
                success: false,
                errorCode: response.errCode.toString(),
                errorMessage: response.errStr ?? '支付失败',
              ));
            }
          }
        }
      });
      
      // 发起微信支付
      await _fluwx.pay(
        which: Payment(
          appId: appId,
          partnerId: partnerId,
          prepayId: prepayId,
          packageValue: packageValue,
          nonceStr: nonceStr,
          timestamp: int.tryParse(timeStamp) ?? 0,
          sign: sign,
        ),
      );
      print('💳 微信支付调起成功');
      
      // 等待支付结果(最多30秒)
      return await completer.future.timeout(
        Duration(seconds: 30),
        onTimeout: () {
          return PaymentResult(
            success: false,
            errorCode: 'TIMEOUT',
            errorMessage: '支付超时',
          );
        },
      );
    } catch (e) {
      print('💳 微信支付异常: $e');
      return PaymentResult(
        success: false,
        errorCode: 'EXCEPTION',
        errorMessage: '支付失败: $e',
      );
    } finally {
      _paymentSubscription?.cancel();
      _paymentSubscription = null;
    }
  }
  
  /// 检查微信是否安装
  static Future<bool> isWechatInstalled() async {
    try {
      final installed = await _fluwx.isWeChatInstalled;
      print('💳 微信安装状态: $installed');
      return installed;
    } catch (e) {
      print('💳 检查微信安装状态失败: $e');
      return false;
    }
  }
}

/// 支付结果
class PaymentResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.errorCode,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'PaymentResult(success: $success, errorCode: $errorCode, errorMessage: $errorMessage)';
  }
}