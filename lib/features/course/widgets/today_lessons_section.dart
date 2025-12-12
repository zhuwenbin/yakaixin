import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../models/lesson_model.dart';
import '../../../../app/config/api_config.dart';
import '../helpers/course_navigation_helper.dart';

/// 今日课节列表组件
/// 对应小程序: LessonsList
class TodayLessonsSection extends StatelessWidget {
  final String lessonNum;
  final String attendanceNum;
  final List<LessonModel> lessons;

  const TodayLessonsSection({
    super.key,
    required this.lessonNum,
    required this.attendanceNum,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    if (lessonNum == '0' || lessons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        // borderRadius: AppRadius.radiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 16.h),
          ...lessons.map((lesson) => LessonItem(lesson: lesson)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Image.network(
          ApiConfig.completeImageUrl('title-icon.png'),
          width: 15.w,
          height: 15.w,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.star, size: 15.w, color: AppColors.primary),
        ),
        SizedBox(width: 5.w),
        Text('今日共', style: AppTextStyles.heading4),
        Text(
          lessonNum,
          style: AppTextStyles.heading4.copyWith(
            color: const Color(0xFFFF860E),
          ),
        ),
        Text('节课', style: AppTextStyles.heading4),
        SizedBox(width: 13.w),
        Text('已完成', style: AppTextStyles.bodySmall),
        Text(
          attendanceNum,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text('节', style: AppTextStyles.bodySmall),
      ],
    );
  }
}

/// 课节列表项
class LessonItem extends ConsumerWidget {
  final LessonModel lesson;

  const LessonItem({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = lesson.startTime?.split(' ').last.substring(0, 5) ?? '';
    final teachingTypeName = lesson.teachingTypeName ?? '';
    final lessonNum = lesson.lessonNum ?? '';
    final lessonName = lesson.lessonName ?? '';
    final lessonId = lesson.lessonId ?? '';

    // ✅ 添加调试日志
    debugPrint('🔍 [今日课程按钮] lesson_id: $lessonId');
    debugPrint('🔍 [今日课程按钮] resourceDocument: ${lesson.resourceDocument}');
    debugPrint('🔍 [今日课程按钮] evaluationType: ${lesson.evaluationType}');

    // ✅ 严格判断：对应小程序逻辑
    // 小程序: v-if="item.resource_document && item.resource_document.length > 0"
    final hasDocument = lesson.resourceDocument.isNotEmpty;
    final evaluationTypes = lesson.evaluationType;

    // ✅ 对应小程序判断逻辑：btn.paper_version_id && btn.paper_version_id != "0"
    // 小程序在 study/index.vue 中过滤：btn.paper_version_id && btn.paper_version_id != "0"
    bool isValidPaperVersionId(dynamic paperVersionId) {
      // ✅ 必须存在（truthy）且不等于字符串 "0"
      if (paperVersionId == null) return false;
      // ✅ 转换为字符串进行比较，确保与小程序逻辑一致
      final paperVersionIdStr = paperVersionId.toString();
      return paperVersionIdStr != '0';
    }

    // ✅ 打印有效的评测按钮
    final validEvaluations = evaluationTypes.where((e) {
      final paperVersionId = e['paper_version_id'];
      final isValid = isValidPaperVersionId(paperVersionId);
      debugPrint(
        '🔍 [评测按钮] name: ${e['name']}, paper_version_id: $paperVersionId, 是否显示: $isValid',
      );
      return isValid;
    }).toList();

    debugPrint(
      '🔍 [今日课程按钮] hasDocument: $hasDocument, validEvaluations数量: ${validEvaluations.length}',
    );
    debugPrint('-----------------------------------');

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FF),
        borderRadius: AppRadius.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeSection(startTime, teachingTypeName),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildLessonInfo(context, ref, lessonNum, lessonName),
              ),
            ],
          ),
          // ✅ 对应小程序逻辑：只有当有课前作业或有评测按钮时才显示按钮区域
          if (hasDocument || validEvaluations.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ✅ 课前作业按钮：当 resource_document 存在且不为空时显示
                  if (hasDocument)
                    _LessonButton(
                      text: '课前作业',
                      isHighlight: true,
                      onTap: () {
                        context.push(
                          AppRoutes.dataDownload,
                          extra: {'lesson_id': lessonId},
                        );
                      },
                    ),
                  if (hasDocument && validEvaluations.isNotEmpty)
                    SizedBox(width: 8.w),
                  // ✅ 评测按钮：遍历 evaluation_type，且 paper_version_id 存在且不等于 "0" 时显示
                  // ✅ 对应小程序：v-if="btn.paper_version_id != 0" 和过滤逻辑：btn.paper_version_id && btn.paper_version_id != "0"
                  ...validEvaluations.asMap().entries.map((entry) {
                    final evaluationType = entry.value;
                    final evaluationId = evaluationType['id']?.toString() ?? '';
                    final validIndex = entry.key;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LessonButton(
                          text: evaluationType['name']?.toString() ?? '',
                          onTap: () {
                            context.push(
                              AppRoutes.makeQuestion,
                              extra: {
                                'lesson_id': lessonId,
                                'evaluation_id': evaluationId,
                                'type': 'evaluation',
                              },
                            );
                          },
                        ),
                        // ✅ 只在不是最后一个有效按钮时显示间距
                        if (validIndex < validEvaluations.length - 1)
                          SizedBox(width: 8.w),
                      ],
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(String startTime, String teachingTypeName) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          Text(
            startTime,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF009F32),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0F4921), width: 1.5),
              borderRadius: AppRadius.radiusXs,
            ),
            child: Text(
              teachingTypeName,
              style: AppTextStyles.labelMedium.copyWith(
                color: const Color(0xFF0F4921),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonInfo(
    BuildContext context,
    WidgetRef ref,
    String lessonNum,
    String lessonName,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // ✅ 扩大点击区域，整个区域都可以点击
      onTap: () => _handleLessonTap(context, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Text(
            lessonNum.isNotEmpty ? '第$lessonNum节' : '',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            lessonName,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 处理课节点击
  /// 对应小程序: lessonsList.vue goLookCourse()
  void _handleLessonTap(BuildContext context, WidgetRef ref) async {
    final lessonId = lesson.lessonId ?? '';
    final lessonName = lesson.lessonName ?? '直播'; // ✅ 获取课节名称

    // ✅ 调试: 打印原始数据
    debugPrint('🐞 [调试] lesson 原始数据: $lesson');
    debugPrint('🐞 [调试] teachingType 字段值: ${lesson.teachingType}');
    debugPrint('🐞 [调试] teachingTypeName 字段值: ${lesson.teachingTypeName}');

    // ✅ 从LessonModel的teaching_type获取授课类型
    final teachingType = lesson.teachingType?.toString() ?? '';

    debugPrint('📚 [今日课程] 点击课节');
    debugPrint('📚 [今日课程] lesson_id: $lessonId');
    debugPrint('📚 [今日课程] lesson_name: $lessonName');
    debugPrint('📚 [今日课程] teaching_type: $teachingType');

    // ✅ 调用统一的导航辅助类（处理录播和直播）
    await CourseNavigationHelper.navigateToLesson(
      context: context,
      ref: ref,
      lessonId: lessonId,
      lessonName: lessonName,
      teachingType: teachingType,
    );
  }
}

/// 课节按钮（课前作业、评测等）
class _LessonButton extends StatelessWidget {
  final String text;
  final bool isHighlight;
  final VoidCallback? onTap;

  const _LessonButton({
    required this.text,
    this.isHighlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        decoration: BoxDecoration(
          gradient: isHighlight
              ? const LinearGradient(
                  colors: [Color(0xFFFF860E), Color(0xFFFF6912)],
                )
              : null,
          border: isHighlight
              ? null
              : Border.all(color: const Color(0xFFFF5500)),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isHighlight ? AppColors.textWhite : const Color(0xFFFF5500),
          ),
        ),
      ),
    );
  }
}
