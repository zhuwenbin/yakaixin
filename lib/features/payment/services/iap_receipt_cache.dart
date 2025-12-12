import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// iOS内购收据缓存管理
/// 
/// 用途：
/// 1. 保存验证失败的收据数据
/// 2. 在合适的时机补发验证请求
/// 3. 避免用户支付成功但未开通权限的情况
/// 
/// 场景：
/// - 用户支付成功，但网络断开
/// - 用户支付成功，但后端服务故障
/// - 用户支付成功，但验证接口超时
class IAPReceiptCache {
  IAPReceiptCache._();

  static const String _failedReceiptsKey = 'failed_iap_receipts';
  static const String _processingReceiptsKey = 'processing_iap_receipts';

  /// 💾 保存验证失败的收据
  /// 
  /// 参数说明：
  /// - orderId: 流水ID（flow_id，不是订单ID！）
  /// - goodsId: 商品ID
  /// - financeBodyId: 财务主体ID（后台验证时使用）
  /// - studentId: 学生ID
  /// - receiptData: Base64编码的收据数据
  /// - productId: 苹果产品ID
  /// - transactionId: 交易ID
  static Future<void> saveFailedReceipt({
    required String orderId,
    required String goodsId,
    required String financeBodyId,  // ✅ 新增：财务主体ID
    required String studentId,
    required String receiptData,
    required String productId,
    required String transactionId,
  }) async {
    try {
      print('\n💾 ========== 保存验证失败的收据 ==========');
      print('📋 订单信息:');
      print('   ├─ 流水ID: $orderId');
      print('   ├─ 商品ID: $goodsId');
      print('   ├─ 财务主体ID: $financeBodyId');  // ✅ 财务主体ID
      print('   ├─ 学生ID: $studentId');
      print('   ├─ 产品ID: $productId');
      print('   ├─ 交易ID: $transactionId');
      print('   └─ 收据长度: ${receiptData.length} 字符');

      final prefs = await SharedPreferences.getInstance();
      final List<String> failed = prefs.getStringList(_failedReceiptsKey) ?? [];

      // 检查是否已存在相同订单
      final exists = failed.any((item) {
        final data = jsonDecode(item) as Map<String, dynamic>;
        return data['orderId'] == orderId;
      });

      if (exists) {
        print('⚠️ 订单 $orderId 已存在于缓存中，跳过保存');
        return;
      }

      final receiptInfo = {
        'orderId': orderId,
        'goodsId': goodsId,
        'financeBodyId': financeBodyId,  // ✅ 保存财务主体ID
        'studentId': studentId,
        'receiptData': receiptData,
        'productId': productId,
        'transactionId': transactionId,
        'timestamp': DateTime.now().toIso8601String(),
        'retryCount': 0, // 重试次数
      };

      failed.add(jsonEncode(receiptInfo));
      await prefs.setStringList(_failedReceiptsKey, failed);

      print('✅ 收据数据已保存到本地');
      print('   当前缓存数量: ${failed.length}');
      print('   保存时间: ${DateTime.now()}');
      print('   💡 将在合适时机自动补发验证');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      print('❌ 保存收据缓存失败: $e');
    }
  }

  /// 📋 获取所有失败的收据
  static Future<List<Map<String, dynamic>>> getFailedReceipts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> failed = prefs.getStringList(_failedReceiptsKey) ?? [];

      return failed
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('❌ 获取收据缓存失败: $e');
      return [];
    }
  }

  /// ✅ 移除已验证成功的收据
  static Future<void> removeFailedReceipt(String orderId) async {
    try {
      print('\n🗑️ 移除已验证成功的收据: $orderId');

      final prefs = await SharedPreferences.getInstance();
      final List<String> failed = prefs.getStringList(_failedReceiptsKey) ?? [];

      final beforeCount = failed.length;
      failed.removeWhere((item) {
        final data = jsonDecode(item) as Map<String, dynamic>;
        return data['orderId'] == orderId;
      });

      await prefs.setStringList(_failedReceiptsKey, failed);

      print('✅ 收据已移除');
      print('   移除前数量: $beforeCount');
      print('   移除后数量: ${failed.length}');
    } catch (e) {
      print('❌ 移除收据缓存失败: $e');
    }
  }

  /// 🔄 更新收据的重试次数
  static Future<void> updateRetryCount(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> failed = prefs.getStringList(_failedReceiptsKey) ?? [];

      final updated = failed.map((item) {
        final data = jsonDecode(item) as Map<String, dynamic>;
        if (data['orderId'] == orderId) {
          data['retryCount'] = (data['retryCount'] as int? ?? 0) + 1;
          data['lastRetryTime'] = DateTime.now().toIso8601String();
        }
        return jsonEncode(data);
      }).toList();

      await prefs.setStringList(_failedReceiptsKey, updated);
    } catch (e) {
      print('❌ 更新重试次数失败: $e');
    }
  }

  /// 🧹 清除所有缓存（慎用！）
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_failedReceiptsKey);
      await prefs.remove(_processingReceiptsKey);
      print('✅ 所有收据缓存已清除');
    } catch (e) {
      print('❌ 清除缓存失败: $e');
    }
  }

  /// 📊 获取缓存统计信息
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final failed = await getFailedReceipts();
      
      return {
        'totalCount': failed.length,
        'oldestTime': failed.isEmpty
            ? null
            : failed
                .map((e) => DateTime.parse(e['timestamp'] as String))
                .reduce((a, b) => a.isBefore(b) ? a : b)
                .toIso8601String(),
        'newestTime': failed.isEmpty
            ? null
            : failed
                .map((e) => DateTime.parse(e['timestamp'] as String))
                .reduce((a, b) => a.isAfter(b) ? a : b)
                .toIso8601String(),
      };
    } catch (e) {
      return {'totalCount': 0};
    }
  }
}
