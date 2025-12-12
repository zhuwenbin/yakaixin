import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// 内购调试数据模型（用于调试显示）
class IAPDebugData {
  final String? purchaseID;
  final String productID;
  final PurchaseVerificationData verificationData;
  final String? transactionDate;
  final PurchaseStatus status;
  final DateTime timestamp;

  IAPDebugData({
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
  
  /// 获取状态颜色
  String get statusColor {
    switch (status) {
      case PurchaseStatus.pending:
        return '#FFA500'; // 橙色
      case PurchaseStatus.purchased:
        return '#4CAF50'; // 绿色
      case PurchaseStatus.error:
        return '#F44336'; // 红色
      case PurchaseStatus.restored:
        return '#2196F3'; // 蓝色
      case PurchaseStatus.canceled:
        return '#9E9E9E'; // 灰色
    }
  }
}

/// 内购调试数据 Provider
/// 保存最新验证的内购数据
final iapDebugDataProvider = StateProvider<IAPDebugData?>((ref) => null);
