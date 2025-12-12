import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';
import '../common/html_content_view.dart';

/// 单个选项组件
/// 
/// 对应小程序: select-question.vue Line 91-110
/// 
/// 功能:
/// - 显示选项标签 (A/B/C/D)
/// - 显示选项内容
/// - 显示选中状态
/// - 显示正确/错误状态
/// - 支持点击选择
class OptionItem extends StatelessWidget {
  final String label;              // 选项标签 (A/B/C/D)
  final String content;            // 选项内容
  final bool isSelected;           // 是否被选中
  final bool isCorrect;            // 是否是正确答案
  final bool showResult;           // 是否显示结果（查看解析模式）
  final bool readOnly;             // 是否只读（不可点击）
  final VoidCallback? onTap;       // 点击回调
  
  const OptionItem({
    required this.label,
    required this.content,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
    this.readOnly = false,
    this.onTap,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final colors = _getOptionColors();
    
    return GestureDetector(
      onTap: readOnly ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          border: Border.all(
            color: colors.borderColor,
            width: 1.5,
          ),
          borderRadius: AppRadius.radiusSm,
        ),
        child: Row(
          children: [
            // 选项标签圆圈
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: colors.labelBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // 选项内容
            Expanded(
              child: HtmlContentView(
                content: content,
                textStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textColor,
                  height: 1.4,
                ),
              ),
            ),
            
            // 正确/错误图标
            if (showResult && (isSelected || isCorrect)) ...[
              SizedBox(width: 8.w),
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 20.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// 获取选项颜色配置
  /// 对应小程序: select-question.vue Line 376-401
  /// 
  /// 颜色规则:
  /// - 答题模式:
  ///   - 已选中: 蓝色边框 #567dfa, 浅蓝背景 rgba(124, 191, 247, 0.18)
  /// - 查看解析模式:
  ///   - 正确答案: 紫色边框 rgba(132, 124, 247, 0.5), 浅紫背景 rgba(132, 124, 247, 0.18)
  ///   - 错误答案: 红色边框 rgba(247, 119, 105, 0.6), 浅红背景 #fff3f2
  _OptionColors _getOptionColors() {
    if (showResult) {
      // 查看解析模式
      if (isSelected && !isCorrect) {
        // ✅ 用户选错了 - 红色
        return _OptionColors(
          backgroundColor: Color(0xFFFFF3F2),  // #fff3f2
          borderColor: Color(0xFFF77769).withOpacity(0.6),  // rgba(247, 119, 105, 0.6)
          labelBackgroundColor: Color(0xFFF77769),  // 红色标签
          textColor: AppColors.textPrimary,
        );
      } else if (isCorrect) {
        // ✅ 正确答案（用户选对或未选） - 紫色
        return _OptionColors(
          backgroundColor: Color(0xFF847CF7).withOpacity(0.18),  // rgba(132, 124, 247, 0.18)
          borderColor: Color(0xFF847CF7).withOpacity(0.5),  // rgba(132, 124, 247, 0.5)
          labelBackgroundColor: Color(0xFF847CF7),  // 紫色标签
          textColor: AppColors.textPrimary,
        );
      } else {
        // ✅ 普通选项（未选且非正确答案）
        return _OptionColors(
          backgroundColor: AppColors.surface,
          borderColor: Color(0xFFECECEC),  // #ececec
          labelBackgroundColor: AppColors.textHint,
          textColor: AppColors.textPrimary,
        );
      }
    } else {
      // 答题模式
      if (isSelected) {
        // ✅ 已选中 - 蓝色
        return _OptionColors(
          backgroundColor: Color(0xFF7CBFF7).withOpacity(0.18),  // rgba(124, 191, 247, 0.18)
          borderColor: Color(0xFF567DFA),  // #567dfa
          labelBackgroundColor: Color(0xFF567DFA),  // 蓝色标签
          textColor: AppColors.textPrimary,
        );
      } else {
        // ✅ 未选中 - 灰色
        return _OptionColors(
          backgroundColor: AppColors.surface,
          borderColor: Color(0xFFECECEC),  // #ececec
          labelBackgroundColor: AppColors.textHint,
          textColor: AppColors.textPrimary,
        );
      }
    }
  }
}

/// 选项颜色配置
class _OptionColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color labelBackgroundColor;
  final Color textColor;
  
  _OptionColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.labelBackgroundColor,
    required this.textColor,
  });
}
