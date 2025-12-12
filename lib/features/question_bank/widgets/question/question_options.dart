import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import 'option_item.dart';

/// 选项列表组件 - 智能判断题型
/// 
/// 对应小程序: select-question.vue Line 91-110
/// 
/// 支持题型:
/// - 1: A1单选题
/// - 2: A2单选题
/// - 5: B1型配伍题（单选）
/// - 7: 多选题
/// - 8: 简答题（待实现）
/// - 9: 填空题（待实现）
/// - 10: 主观题（待实现）
/// - 11: 判断题
/// - 16: B型配伍题（单选）
class QuestionOptions extends StatelessWidget {
  final String questionType;          // 题型 (1/2/3/4/5)
  final List<Map<String, dynamic>> options;  // 选项列表
  final String? userAnswer;           // 用户答案
  final String correctAnswer;         // 正确答案
  final bool showAnswer;              // 是否显示答案
  final bool readOnly;                // 是否只读
  final ValueChanged<String>? onAnswerChanged;  // 答案变化回调
  
  const QuestionOptions({
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    this.userAnswer,
    this.showAnswer = false,
    this.readOnly = false,
    this.onAnswerChanged,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    // 根据题型选择不同的渲染方式
    // 参考小程序: utils/index.js Line 402-432
    
    // 简答题: type = 8, 10
    if (questionType == '8' || questionType == '10') {
      return _buildSubjectiveAnswer();
    }
    
    // 填空题: type = 9
    if (questionType == '9') {
      return _buildFillBlankOptions();
    }
    
    // 其他都是选择题（包括B1型配伍题type=5）
    // 选择题包括: 1(A1单选), 2(A2单选), 5(B1配伍), 7(多选), 11(判断), 16(B型配伍)
    return _buildChoiceOptions();
  }
  
  /// 构建选择题选项（单选/多选/判断）
  Widget _buildChoiceOptions() {
    return Column(
      children: options.map((option) {
        final label = option['label']?.toString() ?? '';
        final content = option['text']?.toString() ?? '';
        
        final isSelected = userAnswer?.contains(label) ?? false;
        final isCorrect = correctAnswer.contains(label);
        
        return OptionItem(
          label: label,
          content: content,
          isSelected: isSelected,
          isCorrect: isCorrect,
          showResult: showAnswer,
          readOnly: readOnly || showAnswer,
          onTap: () => _handleOptionTap(label),
        );
      }).toList(),
    );
  }
  
  /// 处理选项点击
  void _handleOptionTap(String label) {
    if (onAnswerChanged == null) return;
    
    final currentAnswer = userAnswer ?? '';
    
    if (questionType == '2') {
      // 多选题
      String newAnswer;
      if (currentAnswer.contains(label)) {
        // 取消选择
        newAnswer = currentAnswer.replaceAll(label, '');
      } else {
        // 添加选择
        newAnswer = currentAnswer + label;
      }
      onAnswerChanged!(newAnswer);
    } else {
      // 单选题/判断题
      onAnswerChanged!(label);
    }
  }
  
  /// 构建填空题输入框
  /// TODO: 待实现
  Widget _buildFillBlankOptions() {
    return Container(
      padding: AppSpacing.allMd,
      child: Column(
        children: [
          Icon(Icons.edit_note, size: 48.sp, color: AppColors.textHint),
          SizedBox(height: 8.h),
          Text(
            '填空题功能开发中...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建简答题输入框
  /// TODO: 待实现
  Widget _buildSubjectiveAnswer() {
    return Container(
      padding: AppSpacing.allMd,
      child: Column(
        children: [
          Icon(Icons.edit_note, size: 48.sp, color: AppColors.textHint),
          SizedBox(height: 8.h),
          Text(
            '简答题功能开发中...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
