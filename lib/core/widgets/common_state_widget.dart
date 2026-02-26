import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

/// 通用状态组件类型
enum CommonStateType {
  /// 网络错误
  networkError,
  
  /// 加载失败
  loadError,
  
  /// 空数据
  empty,
  
  /// 暂无订单
  noOrder,
  
  /// 暂无课程
  noCourse,
  
  /// 暂无收藏
  noCollection,
  
  /// 暂无错题
  noWrongQuestion,
}

/// 通用状态组件
/// 
/// 统一管理以下场景：
/// - 网络错误（断网、超时等）
/// - 加载失败（服务器错误、接口异常等）
/// - 空数据（暂无数据、暂无订单等）
/// 
/// 使用示例：
/// ```dart
/// // 网络错误
/// CommonStateWidget(
///   type: CommonStateType.networkError,
///   onRetry: () => ref.read(provider.notifier).refresh(),
/// )
/// 
/// // 自定义错误
/// CommonStateWidget.error(
///   message: '加载失败，请稍后重试',
///   onRetry: () => refresh(),
/// )
/// 
/// // 空数据
/// CommonStateWidget.empty(
///   message: '暂无数据',
/// )
/// ```
class CommonStateWidget extends StatelessWidget {
  /// 状态类型
  final CommonStateType? type;
  
  /// 自定义标题
  final String? title;
  
  /// 自定义消息
  final String? message;
  
  /// 自定义图标
  final IconData? icon;
  
  /// 自定义图片URL
  final String? imageUrl;
  
  /// 重试回调
  final VoidCallback? onRetry;
  
  /// 操作按钮文字
  final String? actionText;
  
  /// 操作按钮回调
  final VoidCallback? onAction;

  const CommonStateWidget({
    super.key,
    this.type,
    this.title,
    this.message,
    this.icon,
    this.imageUrl,
    this.onRetry,
    this.actionText,
    this.onAction,
  });

  /// 网络错误
  factory CommonStateWidget.networkError({
    VoidCallback? onRetry,
  }) {
    return CommonStateWidget(
      type: CommonStateType.networkError,
      onRetry: onRetry,
    );
  }

  /// 加载失败
  factory CommonStateWidget.loadError({
    String? message,
    VoidCallback? onRetry,
  }) {
    return CommonStateWidget(
      type: CommonStateType.loadError,
      message: message,
      onRetry: onRetry,
    );
  }

  /// 通用错误（自定义消息）
  factory CommonStateWidget.error({
    String? title,
    String? message,
    VoidCallback? onRetry,
  }) {
    return CommonStateWidget(
      title: title ?? '加载失败',
      message: message,
      icon: Icons.error_outline,
      onRetry: onRetry,
    );
  }

  /// 空数据
  factory CommonStateWidget.empty({
    String? message,
    String? imageUrl,
  }) {
    return CommonStateWidget(
      type: CommonStateType.empty,
      message: message,
      imageUrl: imageUrl,
    );
  }

  /// 暂无订单
  factory CommonStateWidget.noOrder({
    String? message,
    String? imageUrl,
  }) {
    return CommonStateWidget(
      type: CommonStateType.noOrder,
      message: message,
      imageUrl: imageUrl,
    );
  }

  /// 暂无课程
  factory CommonStateWidget.noCourse({
    String? message,
    String? imageUrl,
    VoidCallback? onAction,
  }) {
    return CommonStateWidget(
      type: CommonStateType.noCourse,
      message: message,
      imageUrl: imageUrl,
      onAction: onAction,
    );
  }

  /// 暂无收藏
  factory CommonStateWidget.noCollection({
    String? message,
    String? imageUrl,
  }) {
    return CommonStateWidget(
      type: CommonStateType.noCollection,
      message: message,
      imageUrl: imageUrl,
    );
  }

  /// 暂无错题
  factory CommonStateWidget.noWrongQuestion({
    String? message,
    String? imageUrl,
  }) {
    return CommonStateWidget(
      type: CommonStateType.noWrongQuestion,
      message: message,
      imageUrl: imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图片或图标
            if (config.imageUrl != null)
              _buildImage(config.imageUrl!, type)
            else if (config.icon != null)
              _buildIcon(config.icon!, config.iconColor),
            
            // 标题
            if (config.title != null) ...[
              SizedBox(height: AppSpacing.mdV),
              Text(
                config.title!,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // 消息
            if (config.message != null) ...[
              SizedBox(height: config.title != null ? AppSpacing.smV : AppSpacing.mdV),
              Text(
                config.message!,
                style: TextStyle(
                  // ✅ 错题本空状态：对应小程序 color: #787e8f, font-size: 32rpx (16sp), font-weight: 400
                  fontSize: type == CommonStateType.noWrongQuestion ? 16.sp : null,
                  color: type == CommonStateType.noWrongQuestion 
                      ? const Color(0xFF787E8F)  // ✅ 对应小程序 #787e8f
                      : AppColors.textHint,
                  fontWeight: FontWeight.normal, // ✅ 对应小程序 font-weight: 400
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // 操作按钮
            if (config.showRetryButton || config.actionText != null) ...[
              SizedBox(height: AppSpacing.lgV),
              if (config.showRetryButton)
                _buildRetryButton()
              else if (config.actionText != null)
                _buildActionButton(config.actionText!, config.actionCallback),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建图片
  /// 根据类型设置不同的图片大小
  Widget _buildImage(String imageUrl, CommonStateType? type) {
    // ✅ 错题本空状态：对应小程序 300rpx x 220rpx (150px x 110px)
    double? width;
    double? height;
    
    if (type == CommonStateType.noWrongQuestion) {
      width = 150.w;  // ✅ 对应小程序 300rpx
      height = 110.h; // ✅ 对应小程序 220rpx
    } else {
      // 默认大小
      width = 156.w;
      height = 102.h;
    }
    
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.image_not_supported_outlined,
          size: 80.sp,
          color: AppColors.textHint.withOpacity(0.3),
        );
      },
    );
  }

  /// 构建图标
  Widget _buildIcon(IconData icon, Color color) {
    return Icon(
      icon,
      size: 64.sp,
      color: color,
    );
  }

  /// 构建重试按钮
  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: onRetry,
      icon: Icon(Icons.refresh, size: 18.sp),
      label: Text('重试', style: AppTextStyles.buttonMedium),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 12.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(String text, VoidCallback? callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 122.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(22.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.buttonMedium.copyWith(
            fontSize: 13.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 获取配置
  _StateConfig _getConfig() {
    // 自定义配置优先
    if (type == null) {
      return _StateConfig(
        title: title,
        message: message,
        icon: icon,
        iconColor: AppColors.error.withOpacity(0.3),
        imageUrl: imageUrl,
        showRetryButton: onRetry != null,
        actionText: actionText,
        actionCallback: onAction,
      );
    }

    // 预设类型配置
    switch (type!) {
      case CommonStateType.networkError:
        return _StateConfig(
          icon: Icons.wifi_off_outlined,
          iconColor: AppColors.textHint.withOpacity(0.5),
          title: '网络连接失败',
          message: '请检查网络设置后重试',
          showRetryButton: true,
        );

      case CommonStateType.loadError:
        return _StateConfig(
          icon: Icons.error_outline,
          iconColor: AppColors.error.withOpacity(0.3),
          title: '加载失败',
          message: message ?? '请稍后重试',
          showRetryButton: true,
        );

      case CommonStateType.empty:
        return _StateConfig(
          // 空状态图仅在旧 OSS，与小程序一致用完整 URL
          imageUrl: imageUrl ?? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
          message: message ?? '暂无数据',
        );

      case CommonStateType.noOrder:
        return _StateConfig(
          // ✅ 对应小程序: order-list.vue Line 59
          // 小程序使用旧OSS完整URL: https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16954369620338446169543696203498545_%E7%BC%96%E7%BB%84%402x%20(4).png
          // ⚠️ 注意：此图片在旧OSS域名，需要完整URL
          imageUrl: imageUrl ?? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16954369620338446169543696203498545_%E7%BC%96%E7%BB%84%402x%20(4).png',
          message: message ?? '暂无订单！',
        );

      case CommonStateType.noCourse:
        return _StateConfig(
          imageUrl: imageUrl ?? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
          message: message ?? '未找到符合的学习内容',
          actionText: '去看课程',
          actionCallback: onAction,
        );

      case CommonStateType.noCollection:
        return _StateConfig(
          imageUrl: imageUrl ?? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
          message: message ?? '暂无收藏',
        );

      case CommonStateType.noWrongQuestion:
        return _StateConfig(
          // ✅ 对应小程序: wrongQuestionBook/index.vue Line 162-163
          // 小程序使用旧OSS: https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16975967239088c80169759672390853792_%E7%BC%96%E7%BB%84%205%402x.png
          // 图片大小: 300rpx x 220rpx (150.w x 110.h)
          // ⚠️ 注意：此图片在旧OSS域名，需要完整URL
          imageUrl: imageUrl ?? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16975967239088c80169759672390853792_%E7%BC%96%E7%BB%84%205%402x.png',
          message: message ?? '暂无错题~',
        );
    }
  }
}

/// 状态配置
class _StateConfig {
  final String? title;
  final String? message;
  final IconData? icon;
  final Color iconColor;
  final String? imageUrl;
  final bool showRetryButton;
  final String? actionText;
  final VoidCallback? actionCallback;

  _StateConfig({
    this.title,
    this.message,
    this.icon,
    this.iconColor = Colors.grey,
    this.imageUrl,
    this.showRetryButton = false,
    this.actionText,
    this.actionCallback,
  });
}
