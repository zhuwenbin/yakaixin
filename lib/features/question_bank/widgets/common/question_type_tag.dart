import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';

/// 题型标签组件
/// 
/// 对应小程序: select-question.vue Line 8-11
/// 
/// 显示格式:
/// - [单选题型]
/// - [多选题型] (多选)
/// - [判断题型]
/// - [填空题型]
/// - [简答题型]
class QuestionTypeTag extends StatelessWidget {
  final String questionType;      // 题型 (1/2/3/4/5)
  final bool isMultiple;          // 是否多选
  final String? typeName;         // 自定义题型名称
  
  const QuestionTypeTag({
    required this.questionType,
    this.isMultiple = false,
    this.typeName,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.courseTagBg,
            borderRadius: AppRadius.radiusXs,
          ),
          child: Text(
            _getTypeDisplayText(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.courseTagText,
            ),
          ),
        ),
      ],
    );
  }
  
 /// 获取题型显示文本
  /// 对应小程序: [题型名称]题型 格式
  /// 参考: select-question.vue Line 8-11
  String _getTypeDisplayText() {
    String typeText;
    
    if (typeName != null && typeName!.isNotEmpty) {
      // ✅ 使用自定义题型名称（优先）
      // 数据中的 type_name 字段：A1, B1, 多选 等
      typeText = '[$typeName题型]';
    } else {
      // 根据题型代码判断（兜底）
      switch (questionType) {
        case '1':  // A1型单选题
          typeText = '[A1题型]';
          break;
        case '2':  // A2型单选题
          typeText = '[A2题型]';
          break;
        case '5':  // B1型配伍题（单选）
          typeText = '[B1题型]';
          break;
        case '7':  // 多选题
          typeText = '[多选题型]';
          break;
        case '8':  // 简答题
          typeText = '[简答题型]';
          break;
        case '9':  // 填空题
          typeText = '[填空]';  // 注意：填空题不加"题型"二字
          break;
        case '10':  // 主观题
          typeText = '[主观题型]';
          break;
        case '11':  // 判断题
          typeText = '[判断题型]';
          break;
        case '16':  // B型配伍题（单选）
          typeText = '[B型题型]';
          break;
        default:
          typeText = '[单选题型]';
      }
    }
    
    // ✅ 多选题额外标注
    if (isMultiple && !typeText.contains('多选')) {
      typeText = typeText.replaceAll(']', ' (多选)]');
    }
    
    return typeText;
  }
}
