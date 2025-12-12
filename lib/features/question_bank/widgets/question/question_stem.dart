import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../common/html_content_view.dart';
import '../common/question_type_tag.dart';

/// 题干显示组件
/// 
/// 对应小程序: select-question.vue Line 6-43
/// 对应小程序: question-tmp.vue Line 47-49 (B1型题显示)
/// 
/// 功能:
/// - 显示题型标签
/// - 显示题目序号
/// - 显示公用题干（病例等）
/// - 显示B1型题组标题（"B1第X组题"）
/// - 显示题目内容（HTML渲染）
class QuestionStem extends StatelessWidget {
  final int questionNumber;         // 题目序号
  final String questionType;        // 题型 (1/2/3/4/5)
  final String questionContent;     // 题目内容
  final String? typeName;           // 自定义题型名称
  final String? thematicStem;       // 公用题干（病例等）
  final bool isMultiple;            // 是否多选
  final bool isB1Group;             // 是否是B1配伍题
  final int b1GroupNumber;          // B1组号（第几组）
  final int b1SubIndex;             // 组内索引（第几个子题）
  final int b1GroupSize;            // 组内题目总数
  
  const QuestionStem({
    required this.questionNumber,
    required this.questionType,
    required this.questionContent,
    this.typeName,
    this.thematicStem,
    this.isMultiple = false,
    this.isB1Group = false,
    this.b1GroupNumber = 0,
    this.b1SubIndex = 0,
    this.b1GroupSize = 0,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 题型标签
        QuestionTypeTag(
          questionType: questionType,
          typeName: typeName,
          isMultiple: isMultiple,
        ),
        
        SizedBox(height: 12.h),
        
        // B1型题组标题："B1第X组题"
        // 对应小程序: question-tmp.vue Line 47-49
        if (isB1Group && b1SubIndex == 1) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: AppRadius.radiusSm,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              '$questionNumber、B1第$b1GroupNumber组题',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        
        // 公用题干（病例等）
        if (thematicStem != null && thematicStem!.isNotEmpty) ...[
          Container(
            padding: AppSpacing.allSm,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusSm,
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '病例：',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: HtmlContentView(
                    content: thematicStem!,
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
        
        // 题目内容
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题目序号：B1型题显示"(1)、"，普通题显示"1、"
            // 对应小程序: question-tmp.vue Line 66
            Text(
              isB1Group ? '($b1SubIndex)、' : '$questionNumber、',
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            // 题目内容
            Expanded(
              child: HtmlContentView(
                content: questionContent,
                textStyle: AppTextStyles.heading4.copyWith(
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
