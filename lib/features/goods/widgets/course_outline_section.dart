import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_radius.dart';

/// 课程大纲区域组件
class CourseOutlineSection extends StatefulWidget {
  final List<Map<String, dynamic>> courseList;
  final Function(Map<String, dynamic>) onTrialListen;

  const CourseOutlineSection({
    super.key,
    required this.courseList,
    required this.onTrialListen,
  });

  @override
  State<CourseOutlineSection> createState() => _CourseOutlineSectionState();
}

class _CourseOutlineSectionState extends State<CourseOutlineSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.courseList.isEmpty) {
      return _buildEmpty();
    }

    return Container(
      color: AppColors.surface,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        children: widget.courseList.map((course) {
          return _CourseBlock(
            course: course,
            onTrialListen: widget.onTrialListen,
            onToggle: () {
              setState(() {});
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Text(
        '暂无课程大纲',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      ),
    );
  }
}

/// 课程块
class _CourseBlock extends StatelessWidget {
  final Map<String, dynamic> course;
  final Function(Map<String, dynamic>) onTrialListen;
  final VoidCallback onToggle;

  const _CourseBlock({
    required this.course,
    required this.onTrialListen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course['name'] ?? '',
            style: AppTextStyles.heading4,
          ),
          SizedBox(height: 12.h),
          ...((course['chapterData'] as List?) ?? []).map((chapter) {
            return _ChapterBlock(
              chapter: chapter,
              onTrialListen: onTrialListen,
              onToggle: onToggle,
            );
          }),
        ],
      ),
    );
  }
}

/// 章节块
class _ChapterBlock extends StatelessWidget {
  final Map<String, dynamic> chapter;
  final Function(Map<String, dynamic>) onTrialListen;
  final VoidCallback onToggle;

  const _ChapterBlock({
    required this.chapter,
    required this.onTrialListen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isExpand = chapter['expand'] ?? true;
    final subs = (chapter['subs'] as List?) ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              chapter['expand'] = !isExpand;
              onToggle();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    chapter['name'] ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${subs.length}节',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  isExpand
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
          if (isExpand) ...[
            SizedBox(height: 8.h),
            ...subs.map((section) {
              return _SectionItem(
                section: section,
                onTrialListen: () => onTrialListen(section),
              );
            }),
          ],
        ],
      ),
    );
  }
}

/// 课程小节项
class _SectionItem extends StatelessWidget {
  final Map<String, dynamic> section;
  final VoidCallback onTrialListen;

  const _SectionItem({
    required this.section,
    required this.onTrialListen,
  });

  @override
  Widget build(BuildContext context) {
    final canTrial = section['is_trial_listening'] == 1;
    final name = section['name']?.toString() ?? '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF4F5F5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 蓝色竖条
          Container(
            width: 1.5,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.radiusXs,
            ),
          ),
          SizedBox(width: 6.w),
          // 课程名称
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF5B6E81),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 试听按钮
          if (canTrial) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onTrialListen,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Text(
                  '开始试听',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
