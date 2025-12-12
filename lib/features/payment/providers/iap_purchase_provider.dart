import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// 内购数据模型（用于调试显示）
class IAPPurchaseDebugData {
  final String? purchaseID;
  final String productID;
  final PurchaseVerificationData verificationData;
  final String? transactionDate;
  final PurchaseStatus status;
  final DateTime timestamp;

  IAPPurchaseDebugData({
    required this.purchaseID,
    required this.productID,
    required this.verificationData,
    required this.transactionDate,
    required this.status,
    required this.timestamp,
  });
  
  /// 获取完整的票据数据（Base64）
  String get receiptData => verificationData.serverVerificationData;
  
  /// 获取本地验证数据
  String get localVerificationData => verificationData.localVerificationData;
  
  /// 获取状态名称
  String get statusName {
    switch (status) {
      case PurchaseStatus.pending:
        return '待处理';
      case PurchaseStatus.purchased:
        return '已购买';
      case PurchaseStatus.error:
        return '错误';
      case PurchaseStatus.restored:
        return '已恢复';
      case PurchaseStatus.canceled:
        return '已取消';
    }
  }
}

/// 内购数据 Provider
/// 用于调试界面显示最新的内购验证数据
class IAPPurchaseNotifier extends StateNotifier<IAPPurchaseDebugData?> {
  IAPPurchaseNotifier() : super(null);

  /// 保存内购数据
  void savePurchaseData(PurchaseDetails purchaseDetails) {
    state = IAPPurchaseDebugData(
      purchaseID: purchaseDetails.purchaseID,
      productID: purchaseDetails.productID,
      verificationData: purchaseDetails.verificationData,
      transactionDate: purchaseDetails.transactionDate,
      status: purchaseDetails.status,
      timestamp: DateTime.now(),
    );
  }

  /// 清除数据
  void clear() {
    state = null;
  }
}

/// Provider 定义
final iapPurchaseProvider = StateNotifierProvider<IAPPurchaseNotifier, IAPPurchaseDebugData?>((ref) {
  return IAPPurchaseNotifier();
});
