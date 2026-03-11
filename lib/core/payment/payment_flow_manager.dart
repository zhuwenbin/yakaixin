import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_routes.dart';
import '../../features/order/providers/order_provider.dart';
import '../utils/safe_type_converter.dart';
import '../storage/storage_service.dart';
import '../../app/constants/storage_keys.dart';
import '../utils/toast_util.dart';
import '../widgets/confirm_dialog.dart';

/// 统一支付流程管理器
/// 
/// 职责:
/// - 统一管理所有页面的支付流程
/// - 支持成功/失败的回调处理
/// - 自动处理页面跳转和刷新
/// - 减少重复代码
/// 
/// 使用场景:
/// - 秘卷真题支付
/// - 课程商品支付
/// - 科目模考支付
/// - 直播课支付
/// - 订单列表再次支付
class PaymentFlowManager {
  final WidgetRef ref;
  final BuildContext context;

  PaymentFlowManager({
    required this.ref,
    required this.context,
  });

  /// 开始支付流程
  /// 
  /// 参数:
  /// - goodsId: 商品ID
  /// - goodsMonthsPriceId: 价格方案ID
  /// - months: 购买月数
  /// - payableAmount: 应付金额
  /// - goodsName: 商品名称（用于确认订单页显示）
  /// - professionalIdName: 专业名称（用于支付成功页）
  /// - refreshGoodsId: 需要刷新的商品ID（通常与goodsId相同）
  /// - isLearnButton: 支付成功页行为（1=去学习/课程Tab，0=开始测验）
  /// - goodsType: 商品类型（2=网课 3=直播），用于支付成功页按钮文案
  /// - onSuccess: 支付成功回调（可选）
  /// - onError: 支付失败回调（可选）
  Future<void> startPaymentFlow({
    required String goodsId,
    required String goodsMonthsPriceId,
    required String months,
    required double payableAmount,
    required String goodsName,
    String? professionalIdName,
    String? refreshGoodsId,
    int? isLearnButton,
    String? goodsType,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    try {
      // ✅ 1. 获取用户信息
      final userInfo = await _getUserInfo();
      if (userInfo == null) {
        _showLoginRequiredDialog();
        onError?.call('未登录');
        return;
      }

      final studentId = userInfo['student_id'] ?? '';
      final employeeId = userInfo['employee_id'] ?? '';

      if (studentId.isEmpty) {
        _showLoginRequiredDialog();
        onError?.call('用户信息无效');
        return;
      }

      // ✅ 2. 显示加载提示
      EasyLoading.show(status: '正在下单...');

      // ✅ 3. 创建订单
      final orderNotifier = ref.read(orderNotifierProvider.notifier);
      final result = await orderNotifier.createOrder(
        goodsId: goodsId,
        goodsMonthsPriceId: goodsMonthsPriceId,
        months: months,
        payableAmount: payableAmount,
        studentId: studentId,
        employeeId: employeeId,
      );

      EasyLoading.dismiss();

      // ✅ 4. 处理订单结果
      await result.when(
        // 0元订单
        freeOrder: (orderId) async {
          await _handleFreeOrder(
            orderId: orderId,
            goodsId: goodsId,
            refreshGoodsId: refreshGoodsId,
            professionalIdName: professionalIdName,
            isLearnButton: isLearnButton,
            goodsType: goodsType,
            onSuccess: onSuccess,
          );
        },
        needPayment: (orderId, flowId) async {
          await _handleNeedPayment(
            orderId: orderId,
            flowId: flowId,
            goodsId: goodsId,
            goodsName: goodsName,
            payableAmount: payableAmount,
            refreshGoodsId: refreshGoodsId,
            professionalIdName: professionalIdName,
            isLearnButton: isLearnButton,
            goodsType: goodsType,
            onSuccess: onSuccess,
            onError: onError,
          );
        },
        // 订单创建失败
        error: (errorMsg) {
          _showErrorMessage('下单失败: $errorMsg');
          onError?.call(errorMsg);
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      final errorMsg = '购买失败: $e';
      _showErrorMessage(errorMsg);
      onError?.call(errorMsg);
    }
  }

  /// 处理0元订单
  Future<void> _handleFreeOrder({
    required String orderId,
    required String goodsId,
    String? refreshGoodsId,
    String? professionalIdName,
    int? isLearnButton,
    String? goodsType,
    VoidCallback? onSuccess,
  }) async {
    print('✅ [支付流程] 0元订单，直接成功');

    if (refreshGoodsId != null && refreshGoodsId.isNotEmpty) {
      await _refreshGoodsDetail(refreshGoodsId);
    }
    onSuccess?.call();

    if (context.mounted) {
      context.push(
        AppRoutes.paySuccess,
        extra: {
          'goods_id': goodsId,
          'order_id': orderId,
          'professional_id_name': professionalIdName,
          'isLearnButton': isLearnButton ?? 0,
          if (goodsType != null && goodsType.isNotEmpty) 'goods_type': goodsType,
        },
      );
    }
  }

  /// 处理需要支付的订单
  Future<void> _handleNeedPayment({
    required String orderId,
    required String flowId,
    required String goodsId,
    required String goodsName,
    required double payableAmount,
    String? refreshGoodsId,
    String? professionalIdName,
    int? isLearnButton,
    String? goodsType,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    print('✅ [支付流程] 需要支付，跳转确认订单页');
    print('   订单ID: $orderId');
    print('   流水ID: $flowId');

    if (!context.mounted) return;

    // 跳转确认订单页，等待支付结果
    final paymentResult = await context.push<Map<String, dynamic>>(
      AppRoutes.confirmPayment,
      extra: {
        'order_id': orderId,
        'flow_id': flowId,
        'goods_id': goodsId,
        'finance_body_id': '', // 在确认订单页内部获取
        'goods_name': goodsName,
        'payable_amount': payableAmount,
        'refresh_goods_id': refreshGoodsId ?? goodsId,
        'professional_id_name': professionalIdName,
      },
    );

    // 处理支付结果
    if (paymentResult != null && paymentResult['success'] == true) {
      print('✅ [支付流程] 支付成功');

      // 1. 刷新商品详情
      if (refreshGoodsId != null && refreshGoodsId.isNotEmpty) {
        await _refreshGoodsDetail(refreshGoodsId);
      }

      // 2. 执行成功回调
      onSuccess?.call();

      // 3. 跳转支付成功页（与0元订单、小程序一致；微信/内购均走此逻辑）
      if (context.mounted) {
        context.push(
          AppRoutes.paySuccess,
          extra: {
            'goods_id': paymentResult['goods_id'] ?? goodsId,
            'order_id': orderId,
            'professional_id_name': professionalIdName,
            'isLearnButton': isLearnButton ?? 0,
            if (goodsType != null && goodsType.isNotEmpty) 'goods_type': goodsType,
          },
        );
      }
    } else if (paymentResult != null && paymentResult['success'] == false) {
      // 支付失败
      final errorMsg = paymentResult['error'] ?? '支付失败';
      print('❌ [支付流程] 支付失败: $errorMsg');
      _showErrorMessage(SafeTypeConverter.toSafeString(errorMsg));
      onError?.call(errorMsg);
    }
  }

  /// 刷新商品详情
  /// 
  /// 根据不同的页面调用对应的Provider刷新
  Future<void> _refreshGoodsDetail(String goodsId) async {
    print('🔄 [支付流程] 刷新商品详情: $goodsId');

    // ⚠️ 这里需要根据页面类型选择合适的Provider
    // 由于不同页面使用不同的Provider，这里提供一个通用的刷新接口
    // 具体的刷新逻辑由各个页面的Provider实现
    
    // 方案1: 通过Provider名称动态刷新（需要页面提供Provider标识）
    // 方案2: 由调用方在onSuccess回调中自行刷新（推荐）
    
    // 这里暂时不做具体实现，由调用方通过onSuccess回调处理
  }

  /// 获取用户信息
  Future<Map<String, dynamic>?> _getUserInfo() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      return userInfo;
    } catch (e) {
      print('❌ [支付流程] 获取用户信息失败: $e');
      return null;
    }
  }

  void _showLoginRequiredDialog() {
    if (!context.mounted) return;

    ConfirmDialog.show(
      context,
      title: '需要登录',
      content: '此操作需要登录账户，请先登录后再试',
      confirmText: '去登录',
      cancelText: '取消',
      onConfirm: () {
        // ✅ 使用 GoRouterState.of(context).uri 获取当前完整路径（包括查询参数）
        final routerState = GoRouterState.of(context);
        final currentUri = routerState.uri;
        String returnPath = currentUri.path;
        if (currentUri.queryParameters.isNotEmpty) {
          final queryString = currentUri.queryParameters.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          returnPath = '$returnPath?$queryString';
        }

        context.push(
          AppRoutes.loginCenter,
          extra: {'returnPath': returnPath},
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    if (!context.mounted) return;
    ToastUtil.error(message);
  }
}

/// 支付流程管理器扩展
/// 
/// 为BuildContext添加便捷方法
extension PaymentFlowExtension on BuildContext {
  /// 启动支付流程
  /// 
  /// 使用示例:
  /// ```dart
  /// await context.startPayment(
  ///   ref: ref,
  ///   goodsId: '123',
  ///   goodsMonthsPriceId: '456',
  ///   months: '12',
  ///   payableAmount: 299.0,
  ///   goodsName: '秘卷真题',
  ///   onSuccess: () {
  ///     // 自定义成功处理
  ///     ref.read(goodsDetailProvider.notifier).refresh(goodsId);
  ///   },
  ///   onError: (error) {
  ///     // 自定义错误处理
  ///     print('支付失败: $error');
  ///   },
  /// );
  /// ```
  Future<void> startPayment({
    required WidgetRef ref,
    required String goodsId,
    required String goodsMonthsPriceId,
    required String months,
    required double payableAmount,
    required String goodsName,
    String? professionalIdName,
    String? refreshGoodsId,
    int? isLearnButton,
    String? goodsType,
    VoidCallback? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    final manager = PaymentFlowManager(ref: ref, context: this);
    await manager.startPaymentFlow(
      goodsId: goodsId,
      goodsMonthsPriceId: goodsMonthsPriceId,
      months: months,
      payableAmount: payableAmount,
      goodsName: goodsName,
      professionalIdName: professionalIdName,
      refreshGoodsId: refreshGoodsId,
      isLearnButton: isLearnButton,
      goodsType: goodsType,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
