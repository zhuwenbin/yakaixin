import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 答题卡弹窗
/// 
/// 对应小程序: answer-sheet.vue
/// 
/// 功能:
/// - 显示所有题目状态（已做/未做/标疑）
/// - 点击跳转到对应题目
/// - 显示答题统计
/// 
/// 使用场景:
/// - 章节练习
/// - 每日一测
/// - 模拟考试
class AnswerSheetDialog extends StatelessWidget {
  final List<Map<String, dynamic>> questions;  // 题目列表
  final int currentIndex;                      // 当前题目索引
  final ValueChanged<int>? onQuestionTap;      // 题目点击回调
  
  const AnswerSheetDialog({
    required this.questions,
    required this.currentIndex,
    this.onQuestionTap,
    super.key,
  });

  /// 显示答题卡弹窗
  static Future<void> show(
    BuildContext context, {
    required List<Map<String, dynamic>> questions,
    required int currentIndex,
    ValueChanged<int>? onQuestionTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnswerSheetDialog(
          questions: questions,
          currentIndex: currentIndex,
          onQuestionTap: onQuestionTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 半屏显示：使用屏幕高度的60%
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = screenHeight * 0.6;
    
    return Container(
      height: sheetHeight,  // ✅ 半屏高度
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // 标题栏
          _buildHeader(context),
          
          // 状态说明
          _buildLegend(),
          
          // 题目网格
          Expanded(
            child: _buildQuestionGrid(context),
          ),
        ],
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '答题卡',
            style: AppTextStyles.heading4,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 构建状态说明
  /// 对应小程序 Line 3-16
  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 已做
          _buildLegendItem(
            color: const Color(0xFF567DFA),  // 对应小程序 #567dfa
            label: '已做',
          ),
          
          SizedBox(width: 47.w),  // 对应小程序 94rpx ÷ 2
          
          // 未做
          _buildLegendItem(
            color: const Color(0xFFE4E4E4),  // 对应小程序 #e4e4e4
            label: '未做',
          ),
          
          SizedBox(width: 47.w),
          
          // 标疑
          _buildLegendItem(
            color: const Color(0xFFFB9E0C),  // 对应小程序 #fb9e0c
            label: '标疑',
          ),
        ],
      ),
    );
  }

  /// 构建单个状态说明项
  /// 对应小程序 Line 72-92
  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        // 圆点标识
        Container(
          width: 8.w,   // 对应小程序 16rpx ÷ 2
          height: 8.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),  // 对应小程序 12rpx ÷ 2
        
        // 文字
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,  // 对应小程序 28rpx ÷ 2
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// 构建题目网格
  /// 对应小程序 Line 17-30
  Widget _buildQuestionGrid(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,  // 对应小程序 40rpx ÷ 2
        vertical: 30.h,    // 对应小程序 60rpx ÷ 2
      ),
      child: Wrap(
        spacing: 32.w,     // 对应小程序 64rpx ÷ 2 (水平间距)
        runSpacing: 22.h,  // 对应小程序 44rpx ÷ 2 (垂直间距)
        children: List.generate(
          questions.length,
          (index) => _buildQuestionItem(
            context: context,
            index: index,
            question: questions[index],
          ),
        ),
      ),
    );
  }

  /// 构建单个题目项
  /// 对应小程序 Line 18-29
  Widget _buildQuestionItem({
    required BuildContext context,
    required int index,
    required Map<String, dynamic> question,
  }) {
    // 判断题目状态
    final userAnswer = question['user_answer']?.toString() ?? '';
    final isDone = userAnswer.isNotEmpty;  // 已做
    final isDoubt = question['doubt'] == true;  // 标疑
    
    // 判断背景色和文字颜色
    Color backgroundColor;
    Color textColor;
    
    if (isDoubt) {
      // 标疑状态（橙色）
      backgroundColor = const Color(0xFFFB9E0C);
      textColor = Colors.white;
    } else if (isDone) {
      // 已做状态（蓝色）
      backgroundColor = const Color(0xFFE7F3FE);
      textColor = const Color(0xFF567DFA);
    } else {
      // 未做状态（灰色）
      backgroundColor = const Color(0xFFF6F6F6);
      textColor = Colors.black;
    }
    
    return GestureDetector(
      onTap: () {
        // ✅ 先关闭弹窗，再调用回调（确保 context 有效）
        Navigator.pop(context);
        // ✅ 延迟执行跳转，等待弹窗关闭动画完成
        Future.delayed(const Duration(milliseconds: 300), () {
          onQuestionTap?.call(index);
        });
      },
      child: Container(
        width: 40.w,   // 对应小程序 80rpx ÷ 2
        height: 40.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: 16.sp,  // 对应小程序 32rpx ÷ 2
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
