import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';
import '../common/html_content_view.dart';

/// 答案解析组件
/// 
/// 对应小程序: question-answer.vue
/// 
/// 功能:
/// - 显示正确答案
/// - 显示用户答案
/// - 显示名师解析
/// - 显示全站统计（被作答次数、全站正确率、易错选项）
/// - 显示知识点
class QuestionAnalysis extends StatelessWidget {
  final String correctAnswer;        // 正确答案
  final String analysis;             // 解析内容
  final String? userAnswer;          // 用户答案
  final bool? isCorrect;             // 是否正确
  final Map<String, dynamic>? statistics;  // 统计信息
  final List<String>? knowledgePoints;  // 知识点列表
  final bool showStatistics;         // 是否显示统计信息
  final bool showUserAnswer;         // 是否显示用户答案
  
  const QuestionAnalysis({
    required this.correctAnswer,
    required this.analysis,
    this.userAnswer,
    this.isCorrect,
    this.statistics,
    this.knowledgePoints,
    this.showStatistics = true,
    this.showUserAnswer = true,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 正确答案 + 您的答案
        _buildAnswerSection(),
        
        SizedBox(height: 24.h),
        
        // 2. 名师解析
        _buildAnalysisSection(),
        
        // 3. 全站统计（可选）
        if (showStatistics && statistics != null) ...[
          SizedBox(height: 24.h),
          _buildStatisticsSection(),
        ],
        
        // 4. 知识点
        if (knowledgePoints != null && knowledgePoints!.isNotEmpty) ...[
          SizedBox(height: 24.h),
          _buildKnowledgePointsSection(),
        ],
      ],
    );
  }
  
  /// 1. 构建答案区域（正确答案 + 您的答案）
  Widget _buildAnswerSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          // 正确答案
          Expanded(
            child: Row(
              children: [
                Text(
                  '正确答案',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  correctAnswer,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Color(0xFFFF9500),  // 橙色
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // 您的答案（只要答过题就显示）
          if (showUserAnswer && userAnswer != null && userAnswer!.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  Text(
                    '您的答案',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // ✅ 过滤特殊标记 __FORCE_SHOW__
                  if (userAnswer == '__FORCE_SHOW__')
                    Text(
                      '未答题',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                    )
                  else
                    Text(
                      userAnswer!,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  /// 2. 构建名师解析
  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '名师解析',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        // 解析内容
        HtmlContentView(
          content: analysis.isEmpty ? '暂无解析' : analysis,
          textStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
  
  /// 3. 构建全站统计
  Widget _buildStatisticsSection() {
    final doQuestionNum = statistics?['doQuestionNum'] as int? ?? 0;
    final accuracy = statistics?['accuracy']?.toString() ?? '0';
    final errorOption = statistics?['errorOption']?.toString() ?? '';
    
    // 将数字索引转换为字母
    final errorOptionLabel = _convertIndexToLabel(errorOption);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '全站统计',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        // 统计数据（三列）
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Color(0xFFF7F8FA),
            borderRadius: AppRadius.radiusSm,
          ),
          child: Row(
            children: [
              // 被作答次数
              Expanded(
                child: _buildStatItem(
                  '被作答次数',
                  doQuestionNum > 0 ? '$doQuestionNum次' : '0次',
                ),
              ),
              
              // 分割线
              Container(
                width: 1,
                height: 40.h,
                color: AppColors.divider,
              ),
              
              // 全站正确率
              Expanded(
                child: _buildStatItem(
                  '全站正确率',
                  accuracy.isNotEmpty ? '$accuracy%' : '暂无',
                ),
              ),
              
              // 分割线
              Container(
                width: 1,
                height: 40.h,
                color: AppColors.divider,
              ),
              
              // 易错选项
              Expanded(
                child: _buildStatItem(
                  '易错选项',
                  errorOptionLabel.isNotEmpty ? errorOptionLabel : '暂无',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// 构建统计项
  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  /// 4. 构建知识点
  Widget _buildKnowledgePointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '知识点',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        // 知识点列表
        if (knowledgePoints!.isEmpty)
          Text(
            '暂无相关知识点',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          )
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: knowledgePoints!.map((point) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppRadius.radiusXs,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  point,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
  
  /// 将数字索引转换为字母（0→A, 1→B, ...）
  String _convertIndexToLabel(String index) {
    if (index.isEmpty) return '';
    try {
      final num = int.tryParse(index);
      if (num == null) return index;  // 如果已经是字母，直接返回
      
      const labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      if (num >= 0 && num < labels.length) {
        return labels[num];
      }
      return index;
    } catch (e) {
      return index;
    }
  }
  

}
