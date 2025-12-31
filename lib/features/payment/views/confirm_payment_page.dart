import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../services/unified_payment_service.dart';
import '../services/wechat_payment_service.dart' as wechat_pay;

/// 确认付款页面
/// 功能: 展示订单信息、支付
/// 
/// 📋 参数说明：
/// - orderId: 订单ID（必需，由startPayment返回）
/// - flowId: 流水ID（必需，由startPayment返回）
/// - goodsId: 商品ID（必需）
/// - goodsName: 商品名称（显示用）
/// - payableAmount: 应付金额
/// - refreshGoodsId: 支付成功后需要刷新的商品ID（可选）
/// - professionalIdName: 专业ID名称（跳转支付成功页用）
class ConfirmPaymentPage extends ConsumerStatefulWidget {
  final String orderId;         // ✅ 必需：订单ID
  final String flowId;          // ✅ 必需：流水ID
  final String goodsId;         // ✅ 必需：商品ID
  final String financeBodyId;   // ✅ 必需：财务主体ID
  final String goodsName;       // 显示用
  final double payableAmount;   // 应付金额
  final String? refreshGoodsId; // ✅ 新增：支付成功后刷新的商品ID
  final String? professionalIdName; // ✅ 新增：跳转支付成功页用
  final String? goodsType; // ✅ 新增：商品类型（从详情页传递，避免支付成功页再次调用API）

  const ConfirmPaymentPage({
    super.key,
    required this.orderId,
    required this.flowId,
    required this.goodsId,
    required this.financeBodyId,  // ✅ 财务主体ID
    required this.goodsName,
    required this.payableAmount,
    this.refreshGoodsId,
    this.professionalIdName,
    this.goodsType, // ✅ 新增：商品类型参数
  });

  @override
  ConsumerState<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends ConsumerState<ConfirmPaymentPage> {
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    print('\n💳 ========== 确认支付页 ==========');
    print('📝 订单ID: ${widget.orderId}');
    print('📄 流水ID: ${widget.flowId}');
    print('📦 商品ID: ${widget.goodsId}');
    print('💰 金额: ${widget.payableAmount}');
  }

  /// 处理支付 - 统一支付流程
  /// iOS: 内购（直接购买模式）
  /// Android: 微信支付
  Future<void> _handlePayment() async {
    if (_isPaying) {
      EasyLoading.showInfo('请勿重复点击');
      return;
    }

    setState(() => _isPaying = true);
    
    try {
      final storage = ref.read(storageServiceProvider);
      final userInfo = storage.getJson(StorageKeys.userInfo);
      final studentId = userInfo?['student_id']?.toString() ?? '';
      
      if (Platform.isIOS) {
        // 🍎 iOS: 使用内购（直接购买模式）
        print('\n🍎 ========== iOS内购支付 ==========');
        print('   💡 iOS内购是异步模式，需要等待回调');
        EasyLoading.show(status: '正在支付...');
        
        final paymentService = ref.read(unifiedPaymentServiceProvider);
        
        // 💡 使用 Completer 等待异步回调结果
        final completer = Completer<wechat_pay.PaymentResult>();
        
        await paymentService.pay(
          orderId: widget.orderId,
          flowId: widget.flowId,
          goodsId: widget.goodsId,
          financeBodyId: widget.financeBodyId,  // ✅ 财务主体ID
          amount: widget.payableAmount,
          studentId: studentId,
          goodsName: widget.goodsName,
          onResult: (success, errorMessage) {
            if (!completer.isCompleted) {
              print('\n👉 收到内购结果回调');
              print('   成功: $success');
              print('   错误: $errorMessage');
              
              if (success) {
                completer.complete(wechat_pay.PaymentResult.succeeded());
              } else {
                completer.complete(wechat_pay.PaymentResult.failed(errorMessage ?? '内购失败'));
              }
            }
          },
        );
        
        // 等待回调结果
        print('   ⏳ 等待支付结果...');
        final result = await completer.future;
        
        // 关闭 Loading
        EasyLoading.dismiss();
        
        if (!result.isSuccess) {
          EasyLoading.showError(
            result.errorMessage ?? '支付失败',
            duration: Duration(seconds: 3),
          );
          return;
        }
      } else if (Platform.isAndroid) {
        // 🤖 Android: 提示支付功能开发中
        print('\n🤖 ========== Android支付 ==========');
        EasyLoading.showInfo('支付功能开发中');
        setState(() => _isPaying = false);
        return;
        
        /* ⚠️ 以下Android微信支付代码暂时注释，待开发完成后启用
        print('\n🤖 ========== Android微信支付 ==========');
        
        // 步骤1: 获取微信支付参数
        EasyLoading.show(status: '获取支付参数...');
        print('   订单ID: ${widget.orderId}');
        print('   流水ID: ${widget.flowId}');
        
        final paymentNotifier = ref.read(paymentProvider.notifier);
        final payParams = await paymentNotifier.getWechatPayUrl(
          orderId: widget.orderId,
          flowId: widget.flowId,
        );
        
        if (payParams == null) {
          EasyLoading.dismiss();
          EasyLoading.showError('获取支付参数失败');
          return;
        }
        
        print('✅ 支付参数获取成功');
        
        // 步骤2: 调用微信支付
        EasyLoading.show(status: '正在支付...');
        
        final paymentService = ref.read(unifiedPaymentServiceProvider);
        final result = await paymentService.pay(
          orderId: widget.orderId,
          flowId: widget.flowId,
          goodsId: widget.goodsId,
          financeBodyId: widget.financeBodyId,  // ✅ 财务主体ID
          amount: widget.payableAmount,
          studentId: studentId,
          goodsName: widget.goodsName,
          wechatParams: payParams,
          onResult: (success, errorMessage) {
            // Android微信支付不使用回调
          },
        );
        
        EasyLoading.dismiss();
        
        if (!result.isSuccess) {
          EasyLoading.showError(result.errorMessage ?? '支付失败');
          return;
        }
        */
      } else {
        EasyLoading.showError('不支持的平台');
        return;
      }
      
      if (!mounted) return;

      // ✅ 支付成功处理
      print('\n✅ 支付成功！');
      print('   平台: ${Platform.isIOS ? 'iOS内购' : 'Android微信'}');
      
      // 🔄 返回上一页，携带刷新标记
      context.pop({
        'success': true,
        'goods_id': widget.goodsId,
        'refresh_goods_id': widget.refreshGoodsId,
      });
      
      // 🎯 延迟跳转支付成功页
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        context.push('/pay-success', extra: {
          'goods_id': widget.goodsId,
          'professional_id_name': widget.professionalIdName ?? '',
          'goods_type': widget.goodsType, // ✅ 传递商品类型，避免支付成功页再次调用API
        });
      }
    } catch (e) {
      print('\n❌ 支付异常: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('支付失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isPaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('确认付款'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildOrderInfo(),
                SizedBox(height: 16.h),
                _buildPaymentMethod(),
                SizedBox(height: 100.h), // 给底部按钮留出空间
              ],
            ),
          ),
          // 底部按钮固定在底部
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 12.h,
                bottom: 32.h,
              ),
              child: _buildPayButton(),
            ),
          ),
        ],
      ),
    );
  }

  /// 订单信息（卡片样式）
  Widget _buildOrderInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('订单信息', style: AppTextStyles.heading4),
          SizedBox(height: 16.h),
          _buildInfoRow('商品名称', widget.goodsName),
          SizedBox(height: 12.h),
          _buildInfoRow('订单ID', widget.orderId),
          SizedBox(height: 12.h),
          _buildInfoRow(
            '应付金额',
            '¥${widget.payableAmount.toStringAsFixed(2)}',
            valueColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 支付方式（不可选择，卡片样式）
  /// 对应小程序: secretRealDetail.vue Line 78-89
  Widget _buildPaymentMethod() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧：微信支付图标+文字
          Row(
            children: [
              // 微信支付图标
              Image.asset(
                'assets/images/wechat_pay_icon.png',
                width: 24.w,
                height: 24.w,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.payment,
                    size: 24.w,
                    color: AppColors.primary,
                  );
                },
              ),
              SizedBox(width: 12.w),
              Text(
                Platform.isIOS ? 'Apple内购' : '微信支付',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
          // 右侧：选中图标（固定选中，不可点击）
          Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: 22.w,
          ),
        ],
      ),
    );
  }

  /// 支付按钮
  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: _isPaying ? null : _handlePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          _isPaying 
              ? '支付中...' 
              : '确认支付',
          style: AppTextStyles.buttonLarge,
        ),
      ),
    );
  }
  
  
}
