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
    // ✅ 对应小程序: getStartTime(time) { return time.toString().split(' ')[1]; }
    // 小程序返回完整时间部分（如 "14:30:00"），不截取
    final startTime = lesson.startTime?.split(' ').length == 2 
        ? lesson.startTime!.split(' ')[1] 
        : '';
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
        color: const Color(0xFFF7F9FC), // 与小程序 .today-lesson-item 一致
        borderRadius: AppRadius.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeSection(
                startTime,
                teachingTypeName,
                onTypeTap: teachingTypeName == '录播'
                    ? () => _handleLessonTap(context, ref)
                    : null,
              ),
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
                  // ✅ 课前作业：资料类型（非试卷），与小程序 goDataDownload(path) 一致——有 path 则直接打开 PDF
                  if (hasDocument)
                    _LessonButton(
                      text: '课前作业',
                      isHighlight: true,
                      onTap: () {
                        final firstDoc = lesson.resourceDocument.isNotEmpty
                            ? lesson.resourceDocument[0]
                            : null;
                        final path = firstDoc is Map
                            ? firstDoc['path']?.toString()
                            : null;
                        if (path != null && path.isNotEmpty) {
                          final fullUrl = ApiConfig.completeImageUrl(path);
                          context.push(
                            AppRoutes.pdfIndex,
                            extra: {'pdf_url': fullUrl},
                          );
                        } else {
                          context.push(
                            AppRoutes.dataDownload,
                            extra: {'lesson_id': lessonId},
                          );
                        }
                      },
                    ),
                  if (hasDocument && validEvaluations.isNotEmpty)
                    SizedBox(width: 8.w),
                  // ✅ 评测按钮（课前测、课后测等）：跳转与小程序 goAnswer 一致 → pages/answertest/answer → Flutter ExaminationingPage
                  ...validEvaluations.asMap().entries.map((entry) {
                    final evaluationType = entry.value;
                    final validIndex = entry.key;
                    final paperVersionId =
                        evaluationType['paper_version_id']?.toString() ?? '';
                    final evaluationTypeId =
                        evaluationType['id']?.toString() ?? '';
                    final professionalId =
                        evaluationType['professional_id']?.toString() ?? '';
                    final title = evaluationType['name']?.toString() ?? '';
                    final orderId = lesson.orderId?.toString() ?? '';
                    final paperGoodsId = lesson.paperGoodsId?.toString() ?? '';
                    final systemId = lesson.systemId?.toString();
                    final orderDetailId =
                        lesson.orderGoodsDetailId?.toString();

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LessonButton(
                          text: title,
                          isHighlight: false,
                          onTap: () {
                            context.push(
                              AppRoutes.examinationing,
                              extra: {
                                'paper_version_id': paperVersionId,
                                'evaluation_type_id': evaluationTypeId,
                                'professional_id': professionalId,
                                'goods_id': paperGoodsId,
                                'order_id': orderId,
                                'title': title,
                                'type': '8', // 课前测/课后测等测评，与小程序 answertest/answer 一致
                                'time_limit': 0, // 测评无倒计时
                                if (systemId != null &&
                                    systemId.isNotEmpty)
                                  'system_id': systemId,
                                if (orderDetailId != null &&
                                    orderDetailId.isNotEmpty)
                                  'order_detail_id': orderDetailId,
                              },
                            );
                          },
                        ),
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

  /// 构建时间区域
  /// 对应小程序: .today-lesson-item-left；录播标签可点击进课（与小程序 @click="goLookCourse(item, 'video')" 一致）
  Widget _buildTimeSection(
    String startTime,
    String teachingTypeName, {
    VoidCallback? onTypeTap,
  }) {
    final typeLabel = Container(
      width: 50.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF0F4921),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        teachingTypeName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF0F4921),
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          Text(
            startTime,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3C5548),
            ),
          ),
          SizedBox(height: 6.h),
          onTypeTap != null
              ? GestureDetector(
                  onTap: onTypeTap,
                  behavior: HitTestBehavior.opaque,
                  child: typeLabel,
                )
              : typeLabel,
        ],
      ),
    );
  }

  /// 构建课节信息
  /// 对应小程序: .today-lesson-item-right .today-lesson-title 和 .learn-course-lessons-assistant-name-name
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
          SizedBox(height: 16.h), // ✅ 对应小程序 padding-top: 32rpx (16.h)
          // ✅ 主标题：对应小程序 .today-lesson-title
          Text(
            lessonNum.isNotEmpty ? '第$lessonNum节' : '',
            style: TextStyle(
              fontSize: 16.sp, // ✅ 对应小程序 font-size: 32rpx (16.sp)
              fontWeight: FontWeight.w500, // ✅ 对应小程序 font-weight: 500
              color: const Color(0xFF000000), // ✅ 对应小程序 color: #000000
              height: 1.4, // ✅ 对应小程序 line-height: 1.4
            ),
            maxLines: 2, // ✅ 对应小程序 -webkit-line-clamp: 2
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          // ✅ 副标题：对应小程序 .learn-course-lessons-assistant-name-name
          Text(
            lessonName,
            style: TextStyle(
              fontSize: 14.sp, // ✅ 对应小程序 font-size: 28rpx (14.sp)
              color: const Color(0xFF666666), // ✅ 对应小程序 color: #666666
            ),
            maxLines: 1, // ✅ 对应小程序 white-space: nowrap
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

/// 课节按钮（课前作业、课前测、课后测等）
/// 与小程序 .button-group-child / .full-class 一致：课前作业绿色填充，评测绿色描边
class _LessonButton extends StatelessWidget {
  final String text;
  final bool isHighlight;
  final VoidCallback? onTap;

  const _LessonButton({
    required this.text,
    this.isHighlight = false,
    this.onTap,
  });

  static const Color _green = Color(0xFF00A788);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isHighlight ? _green : null,
          border: isHighlight ? null : Border.all(color: _green, width: 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isHighlight ? Colors.white : _green,
          ),
        ),
      ),
    );
  }
}
