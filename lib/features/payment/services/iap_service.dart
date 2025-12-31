import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'balance_service.dart';
import 'iap_receipt_cache.dart';
import '../providers/iap_purchase_provider.dart';
import '../providers/iap_debug_provider.dart';
import '../../../core/network/dio_client.dart';

/// 内购结果回调
typedef IAPCallback = void Function(bool success, String? errorMessage);

/// iOS内购服务
///
/// 功能说明：
/// 1. 支持内购支付和票据验证（当前使用苹果SDK本地验证）
/// 2. 支持未验证票据的自动补发机制
/// 3. 支持清理未完成交易，避免重复购买错误
class IAPService {
  final IAPPaymentService _paymentService;
  final Ref _ref; // 用于更新调试数据 Provider
  final DioClient _dioClient; // 用于后台验证

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // 当前正在处理的订单信息
  String? _currentOrderId;
  String? _currentGoodsId;
  String? _currentFinanceBodyId; // ✅ 财务主体ID
  String? _currentStudentId;

  // 支付结果回调
  IAPCallback? _paymentCallback;

  // 清理模式标志：在清理待处理交易时设置为true，跳过验证流程
  bool _isCleaningMode = false;
  Completer<void>? _cleaningCompleter;

  // 苹果共享密钥（从 App Store Connect 获取）
  static const String _appleSharedSecret = '5717ac9e6dea4d7299d45d7d24d7d89c';

  // 验证模式：true=后台验证，false=本地验证（保留用于测试）
  static const bool _useServerVerification = true;

  /// 生成苹果产品ID
  ///
  /// 规则：bundle_id + 商品价格（去除小数点后的0）
  /// 例如：
  /// - 价格 9.9 → product_id = "com.yakaixin.yakaixin.9.9"
  /// - 价格 19.9 → product_id = "com.yakaixin.yakaixin.19.9"
  /// - 价格 9.0 → product_id = "com.yakaixin.yakaixin.9"
  /// - 价格 298.00 → product_id = "com.yakaixin.yakaixin.298"
  String getProductId(double amount) {
    const bundleId = 'com.yakaixin.yakaixin';

    // 格式化价格：去除小数点后的0
    // 例如：9.9 → "9.9", 9.0 → "9", 298.00 → "298"
    final priceStr = amount
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'\.?0+$'), '');

    return '$bundleId.$priceStr';
  }

  IAPService(this._paymentService, this._ref, this._dioClient);

  // #region agent log
  /// Debug logging helper - writes NDJSON to debug.log
  void _debugLog(
    String location,
    String message,
    Map<String, dynamic> data,
    String hypothesisId,
  ) {
    try {
      final logEntry = jsonEncode({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'location': location,
        'message': message,
        'data': data,
        'sessionId': 'debug-session',
        'hypothesisId': hypothesisId,
      });
      final logFile = File('/Users/mac/Desktop/vueToFlutter/.cursor/debug.log');
      logFile.writeAsStringSync(
        '$logEntry\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      debugPrint('Debug log error: $e');
    }
  }
  // #endregion

  /// 初始化内购服务
  Future<bool> initialize() async {
    // #region agent log
    _debugLog(
      'iap_service.dart:initialize:entry',
      'Initialize called',
      {},
      'B',
    );
    // #endregion

    if (!Platform.isIOS) {
      debugPrint('非 iOS 平台，跳过内购初始化');
      return false;
    }

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        debugPrint('内购服务不可用');
        return false;
      }

      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => debugPrint('购买监听结束'),
        onError: (error) => debugPrint('购买监听错误: $error'),
      );

      // #region agent log
      _debugLog(
        'iap_service.dart:initialize:listener_set',
        'purchaseStream listener set',
        {'subscription_active': _subscription != null},
        'B',
      );
      // #endregion

      await _clearPendingTransactions();
      await retryFailedReceipts();

      debugPrint('内购服务初始化成功');

      // #region agent log
      _debugLog('iap_service.dart:initialize:exit', 'Initialize completed', {
        'subscription_active': _subscription != null,
      }, 'B');
      // #endregion

      return true;
    } catch (e) {
      debugPrint('内购初始化失败: $e');
      return false;
    }
  }

  /// 清理所有待处理的交易
  /// 作用：避免 storekit_duplicate_product_object 错误
  Future<void> _clearPendingTransactions() async {
    try {
      debugPrint('清理模式：开始');

      _isCleaningMode = true;

      // #region agent log
      _debugLog(
        'iap_service.dart:_clearPendingTransactions:start',
        'Cleaning mode started',
        {'isCleaningMode': _isCleaningMode},
        'A,E',
      );
      // #endregion

      _cleaningCompleter = Completer<void>();

      await _iap.restorePurchases();

      try {
        // ✅ 增加到 5 秒，给足够时间处理
        await _cleaningCompleter!.future.timeout(const Duration(seconds: 5));
        debugPrint('清理模式：检测到交易并已处理');
      } catch (e) {
        debugPrint('清理超时，可能没有待处理交易');
      }

      _isCleaningMode = false;
      _cleaningCompleter = null;

      // #region agent log
      _debugLog(
        'iap_service.dart:_clearPendingTransactions:end',
        'Cleaning mode ended',
        {'isCleaningMode': _isCleaningMode},
        'A,E',
      );
      // #endregion

      debugPrint('清理模式：完成');
    } catch (e) {
      debugPrint('清理交易错误: $e');
      _isCleaningMode = false;
      _cleaningCompleter = null;
    }
  }

  /// 查询产品信息
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async {
    try {
      debugPrint('查询产品: $productIds');

      final response = await _iap.queryProductDetails(productIds);

      if (response.error != null) {
        debugPrint('查询错误: ${response.error}');
        throw Exception('查询产品失败: ${response.error}');
      }

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('未找到产品: ${response.notFoundIDs}');
      }

      debugPrint('找到 ${response.productDetails.length} 个产品');
      return response.productDetails.toList();
    } catch (e) {
      debugPrint('查询产品失败: $e');
      throw Exception('查询产品失败: $e');
    }
  }

  /// 发起购买
  Future<void> purchase({
    required String orderId,
    required String goodsId,
    required double amount, // ✅ 商品价格（用于生成产品ID）
    required String financeBodyId, // ✅ 财务主体ID（后台验证时使用）
    required String studentId,
    String? goodsName,
    required IAPCallback callback,
  }) async {
    try {
      // #region agent log
      _debugLog('iap_service.dart:purchase:entry', 'Purchase called', {
        'orderId': orderId,
        'goodsId': goodsId,
        'amount': amount,
        'isCleaningMode': _isCleaningMode,
        'subscription_active': _subscription != null,
      }, 'A,E');
      // #endregion

      // ✅ 等待清理模式完成（避免竞态条件）
      if (_isCleaningMode && _cleaningCompleter != null) {
        debugPrint('⏳ 检测到清理模式进行中，等待完成...');

        // #region agent log
        _debugLog(
          'iap_service.dart:purchase:wait_cleaning',
          'Waiting for cleaning mode to complete',
          {'isCleaningMode': _isCleaningMode},
          'A,E',
        );
        // #endregion

        try {
          // 最多等待 6 秒（清理模式超时是 5 秒）
          await _cleaningCompleter!.future.timeout(const Duration(seconds: 6));
          debugPrint('✅ 清理模式已完成，继续购买');
        } catch (e) {
          debugPrint('⚠️ 等待清理模式超时，继续购买');
        }

        // #region agent log
        _debugLog(
          'iap_service.dart:purchase:after_wait',
          'After waiting for cleaning',
          {'isCleaningMode': _isCleaningMode},
          'A,E',
        );
        // #endregion
      }

      debugPrint('开始购买 - 订单:$orderId 商品:$goodsId 价格:¥$amount');

      // // 清理待处理交易
      // await _clearPendingTransactions();

      // 保存订单信息
      _currentOrderId = orderId;
      _currentGoodsId = goodsId;
      _currentFinanceBodyId = financeBodyId; // ✅ 保存财务主体ID
      _currentStudentId = studentId;
      _paymentCallback = callback;

      // 生成产品ID（使用价格）
      final productId = getProductId(amount);
      debugPrint('产品ID: $productId (基于价格: ¥$amount)');

      // 查询产品
      final products = await queryProducts({productId});

      if (products.isEmpty) {
        debugPrint('未找到产品: $productId');
        throw Exception('未找到产品ID: $productId');
      }

      final product = products.first;
      debugPrint('产品: ${product.title} - ${product.price}');

      // ⚠️ 消耗型商品无需检查历史购买记录
      // 消耗型商品可以重复购买，不会触发 restored 状态
      debugPrint('💰 消耗型商品，允许重复购买');

      // 发起购买
      final purchaseParam = PurchaseParam(
        productDetails: product,
        applicationUserName: studentId,
      );

      final success = await _iap.buyConsumable(purchaseParam: purchaseParam);

      if (!success) {
        debugPrint('购买请求失败');
        final cb = _paymentCallback;
        _paymentCallback = null;
        cb?.call(false, 'StoreKit API调用失败');
        return;
      }

      debugPrint('购买请求已发送，等待用户确认');
    } catch (e) {
      debugPrint('购买失败: $e');

      // 特殊处理重复购买错误
      if (e.toString().contains('storekit_duplicate_product_object')) {
        debugPrint('⚠️ 检测到未完成交易，尝试主动处理...');

        // ✅ 临时修复：主动触发恢复购买来处理 pending transaction
        _handlePendingTransaction(amount, studentId);
        return;
      }

      final cb = _paymentCallback;
      _paymentCallback = null;
      cb?.call(false, '购买失败: $e');
    }
  }

  /// 恢复购买
  /// ⚠️ 注意：消耗型商品不支持恢复购买
  /// 此方法仅用于清理待处理交易
  Future<void> restorePurchases() async {
    try {
      debugPrint('开始恢复购买');
      await _iap.restorePurchases();
      debugPrint('恢复购买请求已发送');
    } catch (e) {
      debugPrint('恢复购买失败: $e');
      throw Exception('恢复购买失败: $e');
    }
  }

  /// 🧪 调试功能：清除所有购买记录（仅用于测试）
  /// ⚠️ 此方法会完成所有待处理的交易，慎用！
  ///
  /// 注意：由于苹果服务器会记住沙盒账号的购买记录，
  /// 此方法只能清除本地待处理的交易。
  /// 要完全清除购买记录，请：
  /// 1. 退出当前沙盒账号
  /// 2. 创建并登录新的沙盒账号
  Future<void> debugClearAllPurchases() async {
    try {
      debugPrint('🧪 [调试] 开始清除所有购买记录');

      // 恢复所有购买
      await _iap.restorePurchases();

      // 等待回调完成
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('🧪 [调试] 购买记录清除完成');
      debugPrint('⚠️ [提示] 请重启应用以生效');
      debugPrint('⚠️ [提示] 如仍然无法购买，请更换沙盒测试账号');
    } catch (e) {
      debugPrint('🧪 [调试] 清除失败: $e');
    }
  }

  /// 🧹 手动清理所有 pending transactions
  /// 在调试页面手动触发，尝试多次恢复购买来清理
  Future<void> clearAllPendingTransactions() async {
    debugPrint('');
    debugPrint('🧹 ========== 手动清理 Pending Transactions ==========');
    debugPrint('💡 此操作会尝试多次恢复购买来处理未完成的交易');

    try {
      // 1. 第一次尝试
      debugPrint('');
      debugPrint('🔄 第 1 次尝试：恢复购买...');
      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 3));
      debugPrint('✅ 第 1 次完成');

      // 2. 第二次尝试
      debugPrint('');
      debugPrint('🔄 第 2 次尝试：恢复购买...');
      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 3));
      debugPrint('✅ 第 2 次完成');

      // 3. 第三次尝试
      debugPrint('');
      debugPrint('🔄 第 3 次尝试：恢复购买...');
      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 3));
      debugPrint('✅ 第 3 次完成');

      debugPrint('');
      debugPrint('✅ ========== 清理操作完成 ==========');
      debugPrint('💡 结果分析：');
      debugPrint('   - 如果看到"收到购买更新"日志，说明检测到了交易');
      debugPrint('   - 如果没有任何回调，说明没有 pending transaction');
      debugPrint('   - 如果仍然无法购买，请重启应用');
      debugPrint('');
    } catch (e) {
      debugPrint('');
      debugPrint('❌ 清理失败: $e');
      debugPrint('💡 建议：');
      debugPrint('   1. 重启应用');
      debugPrint('   2. 或退出登录 App Store 后重新登录');
      debugPrint('');
      rethrow;
    }
  }

  /// ✅ 临时修复：处理 pending transaction
  /// 当检测到 storekit_duplicate_product_object 错误时调用
  Future<void> _handlePendingTransaction(
    double amount,
    String studentId,
  ) async {
    try {
      debugPrint('🔄 开始处理 pending transaction...');
      debugPrint('   产品ID: ${getProductId(amount)}');

      // 1. 第一次尝试：触发恢复购买
      debugPrint('   第1次尝试：触发恢复购买...');
      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 2));

      // 2. 检查是否收到回调
      debugPrint('   检查是否有回调触发...');

      // 3. 第二次尝试：再次触发恢复购买
      debugPrint('   第2次尝试：再次触发恢复购买...');
      await _iap.restorePurchases();
      await Future.delayed(const Duration(seconds: 3));

      debugPrint('⚠️ 处理完成，但可能需要重启应用');
      debugPrint('💡 原因分析：');
      debugPrint('   - StoreKit 报告有未完成交易');
      debugPrint('   - 但恢复购买没有触发回调');
      debugPrint('   - 这个交易可能处于"僵死"状态');
      debugPrint('💡 解决方案：');
      debugPrint('   1. 重启应用（推荐）');
      debugPrint('   2. 或者在手机设置中退出登录 App Store');
      debugPrint('   3. 重新登录后再试');

      // 4. 通知UI
      final cb = _paymentCallback;
      _paymentCallback = null;
      cb?.call(false, '检测到未完成的交易，但无法自动处理。\n请重启应用或重新登录 App Store');
    } catch (e) {
      debugPrint('❌ 处理 pending transaction 失败: $e');
      final cb = _paymentCallback;
      _paymentCallback = null;
      cb?.call(false, '检测到未完成的交易，请重启应用');
    }
  }

  /// 处理购买更新回调
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    // #region agent log
    try {
      _debugLog(
        'iap_service.dart:_onPurchaseUpdate:entry',
        'Callback triggered',
        {
          'count': purchaseDetailsList.length,
          'isCleaningMode': _isCleaningMode,
          'currentOrderId': _currentOrderId ?? 'null',
          'hasCallback': _paymentCallback != null,
        },
        'C,D',
      );
    } catch (e) {
      debugPrint('Log error in _onPurchaseUpdate entry: $e');
    }
    // #endregion

    debugPrint('');
    debugPrint('📱 ========== 收到购买更新 ==========');
    debugPrint('   数量: ${purchaseDetailsList.length}');
    debugPrint('   清理模式: $_isCleaningMode');
    debugPrint('   当前订单ID: $_currentOrderId');

    if (_isCleaningMode) {
      debugPrint('⚠️ 当前处于清理模式');
    }

    for (int i = 0; i < purchaseDetailsList.length; i++) {
      final purchaseDetails = purchaseDetailsList[i];

      debugPrint('');
      debugPrint('📦 处理交易 ${i + 1}/${purchaseDetailsList.length}:');
      debugPrint('   产品ID: ${purchaseDetails.productID}');
      debugPrint('   交易ID: ${purchaseDetails.purchaseID}');
      debugPrint('   状态: ${purchaseDetails.status}');

      // 清理模式：检查是否为已购买状态
      if (_isCleaningMode) {
        debugPrint('🧹 清理模式：直接完成交易');
        // ✅ 如果是购买成功状态，保存收据供后续验证
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          debugPrint('⚠️ 清理模式检测到已购买交易，保存收据供后续验证');
          debugPrint('   产品ID: ${purchaseDetails.productID}');
          debugPrint('   交易ID: ${purchaseDetails.purchaseID}');

          // 保存收据数据供后续验证
          final receiptData =
              purchaseDetails.verificationData.serverVerificationData;

          // ✅ 方案 1: 如果有订单信息，保存到缓存
          if (receiptData.isNotEmpty &&
              _currentOrderId != null &&
              _currentGoodsId != null) {
            debugPrint('   保存收据到缓存（有订单信息）');
            await IAPReceiptCache.saveFailedReceipt(
              orderId: _currentOrderId!,
              goodsId: _currentGoodsId!,
              financeBodyId: _currentFinanceBodyId ?? '',
              studentId: _currentStudentId ?? '',
              receiptData: receiptData,
              productId: purchaseDetails.productID,
              transactionId: purchaseDetails.purchaseID ?? '',
            );
            debugPrint('✅ 已保存收据到缓存，下次启动时自动验证');
          }
          // ✅ 方案 2: 没有订单信息，使用交易 ID 作为临时标识
          else if (receiptData.isNotEmpty &&
              purchaseDetails.purchaseID != null) {
            debugPrint('   保存收据到缓存（使用交易ID作为临时标识）');
            await IAPReceiptCache.saveFailedReceipt(
              orderId: purchaseDetails.purchaseID!, // ← 使用交易ID
              goodsId: purchaseDetails.productID,
              financeBodyId: '',
              studentId: '',
              receiptData: receiptData,
              productId: purchaseDetails.productID,
              transactionId: purchaseDetails.purchaseID!,
            );
            debugPrint('✅ 已保存收据（临时标识），下次启动时自动验证');
          } else {
            debugPrint('⚠️ 收据为空或无交易ID，无法保存');
          }
        }

        // 完成交易
        debugPrint('   完成清理模式交易');
        _iap.completePurchase(purchaseDetails);

        if (i == purchaseDetailsList.length - 1 &&
            _cleaningCompleter != null &&
            !_cleaningCompleter!.isCompleted) {
          debugPrint('   完成清理模式');
          _cleaningCompleter!.complete();
        }
        debugPrint('   ⏭️ 跳过此交易（清理模式）');

        // #region agent log
        _debugLog(
          'iap_service.dart:_onPurchaseUpdate:cleaning_skip',
          'Skipping transaction in cleaning mode',
          {
            'productId': purchaseDetails.productID,
            'status': purchaseDetails.status.toString(),
          },
          'A',
        );
        // #endregion

        continue;
      }

      // #region agent log
      _debugLog(
        'iap_service.dart:_onPurchaseUpdate:normal_mode',
        'Processing in normal mode',
        {
          'productId': purchaseDetails.productID,
          'status': purchaseDetails.status.toString(),
          'isCleaningMode': _isCleaningMode,
        },
        'A',
      );
      // #endregion

      debugPrint('💡 正常购买模式处理');
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          debugPrint('⏳ 购买状态：待处理');
          break;

        case PurchaseStatus.purchased:
          // #region agent log
          _debugLog(
            'iap_service.dart:_onPurchaseUpdate:purchased',
            'Purchase succeeded, starting verification',
            {
              'productId': purchaseDetails.productID,
              'transactionId': purchaseDetails.purchaseID ?? 'null',
            },
            'A',
          );
          // #endregion

          debugPrint('✅ 购买状态：成功');
          debugPrint('   开始验证收据...');
          _verifyAndFinishTransaction(purchaseDetails);
          break;

        case PurchaseStatus.error:
          debugPrint('❌ 购买状态：失败 - ${purchaseDetails.error?.message}');
          _iap.completePurchase(purchaseDetails);
          final cb = _paymentCallback;
          _paymentCallback = null;
          cb?.call(false, purchaseDetails.error?.message ?? '支付失败');
          break;

        case PurchaseStatus.restored:
          // ⚠️ 消耗型商品不支持恢复购买，这个状态不应该出现
          debugPrint('🔄 购买状态：恢复（消耗型商品不应出现此状态）');
          _iap.completePurchase(purchaseDetails);
          break;

        case PurchaseStatus.canceled:
          debugPrint('🚫 购买状态：取消');
          _iap.completePurchase(purchaseDetails);
          final cb = _paymentCallback;
          _paymentCallback = null;
          cb?.call(false, '用户取消支付');
          break;
      }
    }

    debugPrint('========================================');
    debugPrint('');
  }

  /// 验证收据并完成交易
  Future<void> _verifyAndFinishTransaction(
    PurchaseDetails purchaseDetails,
  ) async {
    String? receiptData;

    try {
      debugPrint('开始验证收据流程');

      if (_currentOrderId == null ||
          _currentGoodsId == null ||
          _currentStudentId == null) {
        debugPrint('订单信息不完整，跳过验证');
        await _iap.completePurchase(purchaseDetails);
        return;
      }

      // 获取收据数据
      receiptData = purchaseDetails.verificationData.serverVerificationData;

      final ttt = purchaseDetails.verificationData.serverVerificationData;

      debugPrint('票据服务数据: $ttt');

      if (receiptData.isEmpty) {
        debugPrint('收据数据为空');
        await _iap.completePurchase(purchaseDetails);
        return;
      }

      // 🔍 保存内购调试数据
      if (kDebugMode) {
        _ref.read(iapDebugDataProvider.notifier).state = IAPDebugData(
          purchaseID: purchaseDetails.purchaseID,
          productID: purchaseDetails.productID,
          verificationData: purchaseDetails.verificationData,
          transactionDate: purchaseDetails.transactionDate,
          status: purchaseDetails.status,
          timestamp: DateTime.now(),
        );
        debugPrint('✅ 已保存内购调试数据到 Provider');
      }

      // ✅ 优化：验证之前先保存收据（防止验证过程中应用崩溃导致收据丢失）
      debugPrint('💾 验证前保存收据到缓存（安全备份）');
      await IAPReceiptCache.saveFailedReceipt(
        orderId: _currentOrderId!,
        goodsId: _currentGoodsId!,
        financeBodyId: _currentFinanceBodyId!,
        studentId: _currentStudentId!,
        receiptData: receiptData,
        productId: purchaseDetails.productID,
        transactionId: purchaseDetails.purchaseID ?? '',
      );
      debugPrint('✅ 收据已安全备份');

      // 根据配置选择验证方式
      if (_useServerVerification) {
        // 🔥 后台验证（生产环境）
        debugPrint('开始后台验证...');
        final verifyResult = await _verifyReceiptWithServer(
          receiptData: receiptData,
          orderId: _currentOrderId!,
          financeBodyId: _currentFinanceBodyId!, // ✅ 使用财务主体ID
          productId: purchaseDetails.productID, // ✅ 当前购买的产品ID
          transactionId: purchaseDetails.purchaseID ?? '', // ✅ 当前交易ID
        );

        if (!verifyResult['success']) {
          throw Exception('后台验证失败: ${verifyResult['message']}');
        }

        debugPrint('后台验证成功 - 订单ID: $_currentOrderId');
      } else {
        // 🧪 本地验证（测试阶段）
        debugPrint('开始苹果SDK本地验证...');
        final verifyResult = await _verifyReceiptWithApple(receiptData);

        if (!verifyResult['success']) {
          throw Exception('苹果SDK验证失败: ${verifyResult['message']}');
        }

        debugPrint('本地验证成功 - 订单ID: $_currentOrderId');
      }

      // ✅ 验证成功，删除缓存
      debugPrint('🗑️ 验证成功，删除收据缓存');
      await IAPReceiptCache.removeFailedReceipt(_currentOrderId!);

      // 完成交易
      await _iap.completePurchase(purchaseDetails);

      // 通知UI支付成功
      final cb = _paymentCallback;
      _paymentCallback = null;
      cb?.call(true, null);

      // 清理临时数据
      _currentOrderId = null;
      _currentGoodsId = null;
      _currentFinanceBodyId = null; // ✅ 清理财务主体ID
      _currentStudentId = null;

      debugPrint('内购流程完成');
    } catch (e) {
      debugPrint('验证收据失败: $e');

      // ⚠️ 验证失败，收据已在验证前保存，这里只需要提示
      debugPrint('💾 收据已保存在缓存中，将在下次启动时自动重试');

      await _iap.completePurchase(purchaseDetails);

      // 通知UI验证失败
      final cb = _paymentCallback;
      _paymentCallback = null;
      cb?.call(false, '收据验证失败，已保存数据，将自动重试: $e');
    }
  }

  /// 补发验证失败的收据
  /// 在应用启动或进入个人中心时调用，自动重试验证失败的收据
  Future<void> retryFailedReceipts() async {
    try {
      debugPrint('检查待补发的收据');

      final failedReceipts = await IAPReceiptCache.getFailedReceipts();

      if (failedReceipts.isEmpty) {
        debugPrint('没有待补发的收据');
        return;
      }

      debugPrint('发现 ${failedReceipts.length} 条待补发的收据');

      int successCount = 0;
      int failureCount = 0;

      for (int i = 0; i < failedReceipts.length; i++) {
        final receipt = failedReceipts[i];
        final orderId = receipt['orderId'] as String;
        final goodsId = receipt['goodsId'] as String;
        final financeBodyId =
            receipt['financeBodyId'] as String? ?? ''; // ✅ 读取财务主体ID
        final studentId = receipt['studentId'] as String;
        final receiptData = receipt['receiptData'] as String;
        final productId = receipt['productId'] as String;
        final transactionId = receipt['transactionId'] as String;

        debugPrint('正在重试 [${i + 1}/${failedReceipts.length}] - 订单ID: $orderId');

        try {
          // 根据配置选择验证方式
          if (_useServerVerification) {
            // 🔥 后台验证
            final verifyResult = await _verifyReceiptWithServer(
              receiptData: receiptData,
              orderId: orderId,
              financeBodyId: financeBodyId, // ✅ 使用缓存中的财务主体ID
              productId: productId, // ✅ 产品ID
              transactionId: transactionId, // ✅ 交易ID
            );

            if (!verifyResult['success']) {
              throw Exception('后台验证失败: ${verifyResult['message']}');
            }
          } else {
            // 🧪 本地验证
            final verifyResult = await _verifyReceiptWithApple(receiptData);

            if (!verifyResult['success']) {
              throw Exception('苹果SDK验证失败: ${verifyResult['message']}');
            }
          }

          debugPrint('验证成功，清除缓存');
          await IAPReceiptCache.removeFailedReceipt(orderId);
          successCount++;
        } catch (e) {
          debugPrint('验证仍然失败: $e');
          failureCount++;
        }
      }

      debugPrint('补发结果 - 成功: $successCount, 失败: $failureCount');
    } catch (e) {
      debugPrint('补发收据时出错: $e');
    }
  }

  /// 🔥 使用后台服务器验证收据（生产环境）
  Future<Map<String, dynamic>> _verifyReceiptWithServer({
    required String receiptData,
    required String orderId,
    required String financeBodyId, // ✅ 财务主体ID
    required String productId, // ✅ 产品ID
    required String transactionId, // ✅ 交易ID
  }) async {
    try {
      debugPrint('后台验证：开始');
      debugPrint('流水ID: $orderId');
      debugPrint('财务主体ID: $financeBodyId');
      debugPrint('产品ID: $productId');
      debugPrint('交易ID: $transactionId');
      debugPrint('票据数据长度: ${receiptData.length} 字符');

      final response = await _dioClient.post(
        '/c/pay/applepay',
        data: {
          'receipt_data': receiptData,
          'flow_id': int.tryParse(orderId) ?? 0, // ✅ 流水ID
          'finance_body_id': int.tryParse(financeBodyId) ?? 0, // ✅ 财务主体ID
          'product_id': productId, // ✅ 当前购买的产品ID
          'transaction_id': transactionId, // ✅ 当前交易ID
        },
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => true,
        ),
      );

      debugPrint('后台验证响应: ${response.statusCode}');
      debugPrint('响应数据: ${response.data}');

      if (response.statusCode != 200) {
        return {
          'success': false,
          'status': response.statusCode,
          'message': 'HTTP请求失败: ${response.statusCode}',
        };
      }

      final result = response.data as Map<String, dynamic>;
      final code = result['code'] as int?;

      if (code == 100000) {
        debugPrint('后台验证成功');
        return {
          'success': true,
          'status': code,
          'message': '验证成功',
          'data': result['data'],
        };
      } else {
        final errorMsg = result['msg'] is List
            ? (result['msg'] as List).first.toString()
            : result['msg']?.toString() ?? '验证失败';
        return {'success': false, 'status': code ?? -1, 'message': errorMsg};
      }
    } catch (e) {
      debugPrint('后台验证出错: $e');
      return {'success': false, 'status': -1, 'message': '后台验证出错: $e'};
    }
  }

  /// 🧪 使用苹果SDK验证收据（本地验证，仅用于测试）
  Future<Map<String, dynamic>> _verifyReceiptWithApple(
    String receiptData,
  ) async {
    try {
      debugPrint('苹果SDK验证：开始');
      debugPrint('票据数据长度: ${receiptData.length} 字符');
      debugPrint('票据数据: $receiptData');

      final requestBody = {
        'receipt-data': receiptData,
        'password': _appleSharedSecret,
        'exclude-old-transactions': false,
      };

      final dio = Dio();
      final response = await dio.post(
        'https://sandbox.itunes.apple.com/verifyReceipt',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != 200) {
        return {
          'success': false,
          'status': response.statusCode,
          'message': 'HTTP请求失败: ${response.statusCode}',
        };
      }

      final result = response.data as Map<String, dynamic>;
      final status = result['status'] as int;

      debugPrint('苹果验证状态码: $status');

      if (status == 0) {
        debugPrint('验证成功');
        return {
          'success': true,
          'status': status,
          'message': '验证成功',
          'receipt': result['receipt'],
        };
      } else if (status == 21007) {
        debugPrint('检测到生产收据，尝试生产服务器');
        return await _verifyReceiptWithProduction(receiptData);
      } else {
        return {
          'success': false,
          'status': status,
          'message': _getAppleStatusMessage(status),
        };
      }
    } catch (e) {
      debugPrint('苹果SDK验证出错: $e');
      return {'success': false, 'status': -1, 'message': '验证过程出错: $e'};
    }
  }

  /// 使用生产环境验证收据
  Future<Map<String, dynamic>> _verifyReceiptWithProduction(
    String receiptData,
  ) async {
    try {
      debugPrint('生产环境验证');
      debugPrint('票据数据长度: ${receiptData.length} 字符');
      debugPrint('票据数据: $receiptData');

      final requestBody = {
        'receipt-data': receiptData,
        'password': _appleSharedSecret, // ✅ 使用共享密钥
        'exclude-old-transactions': false,
      };

      final dio = Dio();
      final response = await dio.post(
        'https://buy.itunes.apple.com/verifyReceipt',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != 200) {
        return {
          'success': false,
          'status': response.statusCode,
          'message': 'HTTP请求失败: ${response.statusCode}',
        };
      }

      final result = response.data as Map<String, dynamic>;
      final status = result['status'] as int;

      if (status == 0) {
        debugPrint('生产环境验证成功');
        return {
          'success': true,
          'status': status,
          'message': '生产环境验证成功',
          'receipt': result['receipt'],
        };
      } else {
        return {
          'success': false,
          'status': status,
          'message': _getAppleStatusMessage(status),
        };
      }
    } catch (e) {
      debugPrint('生产环境验证出错: $e');
      return {'success': false, 'status': -1, 'message': '生产环境验证出错: $e'};
    }
  }

  /// 获取苹果状态码说明
  String _getAppleStatusMessage(int status) {
    switch (status) {
      case 0:
        return '成功';
      case 21000:
        return 'App Store 不能读取您提供的JSON对象';
      case 21002:
        return 'receipt-data 属性中的数据格式错误或服务无法读取';
      case 21003:
        return '收据无法通过验证';
      case 21004:
        return '您提供的共享密钥与您账户中的共享密钥不匹配';
      case 21005:
        return '收据服务器当前不可用';
      case 21006:
        return '此收据有效，但订阅已过期';
      case 21007:
        return '此收据来自沙盒环境，但发送到了生产环境进行验证';
      case 21008:
        return '此收据来自生产环境，但发送到了沙盒环境进行验证';
      case 21010:
        return '此收据无法授权。请处理此收据，就像它未通过验证一样';
      default:
        return '未知错误码: $status';
    }
  }

  /// 释放资源
  void dispose() {
    _subscription?.cancel();
  }
}

/// IAPService Provider
final iapServiceProvider = Provider<IAPService>((ref) {
  final service = IAPService(
    ref.read(iapPaymentServiceProvider),
    ref,
    ref.read(dioClientProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
});
