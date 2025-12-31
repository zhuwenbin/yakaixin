import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 做题页面底部工具栏
/// 
/// 对应小程序: bottom-utils.vue
/// 
/// 功能:
/// - 问老师（微信分享）
/// - 重新做题/查看解析
/// - 答题卡
/// - 收藏/取消收藏
/// - 纠错
class BottomToolbar extends StatelessWidget {
  final VoidCallback? onAskTeacher;       // 问老师（分享）
  final VoidCallback? onToggleAnalysis;   // 重新做题/查看解析
  final VoidCallback? onShowAnswerSheet;  // 显示答题卡
  final VoidCallback? onToggleCollect;    // 收藏/取消收藏
  final VoidCallback? onErrorCorrection;  // 纠错
  final bool isCollected;                 // 是否已收藏
  final bool hasAnswer;                   // 用户是否已答题
  final bool showAnalysis;                // 当前是否显示解析
  final bool showAskTeacher;              // 是否显示"问老师"按钮
  final bool showToggleAnalysis;          // 是否显示"重新做题/查看解析"按钮
  final bool showAnswerSheet;             // 是否显示"答题卡"按钮
  final bool showCollect;                 // 是否显示"收藏"按钮
  final bool showErrorCorrection;         // 是否显示"纠错"按钮
  
  const BottomToolbar({
    this.onAskTeacher,
    this.onToggleAnalysis,
    this.onShowAnswerSheet,
    this.onToggleCollect,
    this.onErrorCorrection,
    this.isCollected = false,
    this.hasAnswer = false,
    this.showAnalysis = false,
    this.showAskTeacher = true,
    this.showToggleAnalysis = true,
    this.showAnswerSheet = true,
    this.showCollect = true,
    this.showErrorCorrection = true,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. 问老师（系统分享）
          // 对应小程序: bottom-utils.vue Line 5-9
          // 小程序图标: /static/imgs/jintiku/share-two.svg
          if (showAskTeacher)
            _ToolbarButton(
              icon: Icons.share,  // ✅ 使用Material分享图标
              label: '问老师',
              onTap: onAskTeacher,
            ),
          
          // 2. 重新做题/查看解析
          if (showToggleAnalysis)
            _ToolbarButton(
              icon: Icons.refresh,  // ✅ 只显示重新做题
              label: '重新做题',
              onTap: onToggleAnalysis,  // ✅ 答题后可点击
            ),
          
          // 3. 答题卡
          if (showAnswerSheet)
            _ToolbarButton(
              icon: Icons.grid_on_outlined,
              label: '答题卡',
              onTap: onShowAnswerSheet,
            ),
          
          // 4. 收藏/取消收藏
          if (showCollect)
            _ToolbarButton(
              icon: isCollected ? Icons.star : Icons.star_border,
              label: isCollected ? '已收藏' : '收藏',
              iconColor: isCollected ? AppColors.warning : null,
              onTap: onToggleCollect,
            ),
          
          // 5. 纠错
          if (showErrorCorrection)
            _ToolbarButton(
              icon: Icons.error_outline,
              label: '纠错',
              onTap: onErrorCorrection,
            ),
        ],
      ),
    );
  }
}

/// 工具栏按钮组件
class _ToolbarButton extends StatelessWidget {
  final IconData? icon;              // Material图标
  final String? iconUrl;             // 网络图标URL
  final IconData? fallbackIcon;      // 网络图标加载失败时的备用图标
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;
  
  const _ToolbarButton({
    this.icon,
    this.iconUrl,
    this.fallbackIcon,
    required this.label,
    this.iconColor,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    // ✅ 禁用状态：onTap 为 null
    final isDisabled = onTap == null;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,  // ✅ 禁用时降低透明度
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ 支持网络图标或Material图标
              _buildIcon(),
              SizedBox(height: 4.h),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: iconColor ?? AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建图标（支持网络图标和Material图标）
  Widget _buildIcon() {
    // ✅ 优先使用网络图标
    if (iconUrl != null) {
      return Image.network(
        iconUrl!,
        width: 20.w,   // ✅ 小程序：40rpx ÷ 2 = 20.w
        height: 20.w,
        fit: BoxFit.contain,
        color: iconColor ?? AppColors.textSecondary,
        errorBuilder: (context, error, stackTrace) {
          // ✅ 加载失败时使用备用图标
          return Icon(
            fallbackIcon ?? Icons.error_outline,
            size: 24.sp,
            color: iconColor ?? AppColors.textSecondary,
          );
        },
      );
    }
    
    // ✅ 使用Material图标
    return Icon(
      icon ?? Icons.help_outline,
      size: 24.sp,
      color: iconColor ?? AppColors.textSecondary,
    );
  }
}
