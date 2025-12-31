import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
// ignore: unused_import
import '../../../core/theme/app_radius.dart'; // 保留：恢复筛选功能时需要
import '../models/course_model.dart';
import '../../../../app/config/api_config.dart';
import 'course_item_card.dart';

/// 学习计划区域
/// 对应小程序: CourseList
class StudyPlanSection extends ConsumerWidget {
  final List<CourseModel> courseList;
  final bool isCourseListLoading;
  final String teachingType;
  final Function(String) onTeachingTypeChanged;

  const StudyPlanSection({
    super.key,
    required this.courseList,
    required this.isCourseListLoading,
    required this.teachingType,
    required this.onTeachingTypeChanged,
  });

  static final List<Map<String, String>> _teachingTypeOptions = [
    {'name': '全部', 'id': ''},
    {'name': '录播', 'id': '3'},
    {'name': '直播', 'id': '1'},
    {'name': '面授', 'id': '2'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      color: AppColors.backgroundLightGray,
      padding: AppSpacing.allMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 16.h),
          _buildFilterBar(context),
          if (isCourseListLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(25.h),
                child: const CircularProgressIndicator(),
              ),
            )
          else if (courseList.isEmpty)
            _buildEmptyState()
          else
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                children: courseList
                    .map((course) => CourseItemCard(courseData: course))
                    .toList(),
              ),
            ),
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
        Text('学习计划', style: AppTextStyles.heading4),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTeachingTypeFilter(context),
        _buildMyCoursesButton(context),
      ],
    );
  }

  Widget _buildTeachingTypeFilter(BuildContext context) {
    // ✅ 暂时显示为文本，但保留原有功能代码
    // TODO: 后续需要恢复筛选功能时，取消注释下面的代码，删除上面的 Text widget
    return Text(
      '授课形式',
      style: AppTextStyles.bodyMedium,
    );

    // ⚠️ 保留原有筛选功能代码（暂时注释）
    // return PopupMenuButton<String>(
    //   initialValue: teachingType,
    //   onSelected: onTeachingTypeChanged,
    //   offset: Offset(0, 35.h),
    //   shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
    //   color: AppColors.surface,
    //   elevation: 4,
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Text(
    //         _getTeachingTypeName(teachingType),
    //         style: AppTextStyles.bodyMedium,
    //       ),
    //       SizedBox(width: 3.w),
    //       Icon(
    //         Icons.keyboard_arrow_down,
    //         size: 16.sp,
    //         color: AppColors.textPrimary,
    //       ),
    //     ],
    //   ),
    //   itemBuilder: (context) => _teachingTypeOptions.map((option) {
    //     final isActive = teachingType == option['id'];
    //     return PopupMenuItem<String>(
    //       value: option['id'],
    //       child: Container(
    //         width: 100.w,
    //         alignment: Alignment.center,
    //         padding: EdgeInsets.symmetric(vertical: 8.h),
    //         child: Text(
    //           option['name']!,
    //           style: AppTextStyles.bodyMedium.copyWith(
    //             color: isActive ? AppColors.primary : AppColors.textPrimary,
    //           ),
    //         ),
    //       ),
    //     );
    //   }).toList(),
    // );
  }

  Widget _buildMyCoursesButton(BuildContext context) {
    // ✅ 与小程序保持一致：只有文字，颜色 #0075FF
    // 对应小程序: courseList.vue Line 22-24
    // <view class="my-course" @click="goMyCourse">
    //   <text style="color: #0075FF;">我的课程</text>
    // </view>
    return GestureDetector(
      onTap: () => context.push(AppRoutes.myCourse),
      child: Text(
        '我的课程',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400, // font-weight: 400
          color: const Color(0xFF0075FF), // color: #0075FF
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        SizedBox(height: 25.h),
        Image.network(
          ApiConfig.completeImageUrl(
            'public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
          ),
          width: 60.w,
          height: 60.w,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.inbox, size: 60.w, color: AppColors.textHint),
        ),
        SizedBox(height: 8.h),
        Text(
          '未找到符合的学习内容',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  /// 获取授课形式名称（保留：恢复筛选功能时需要）
  // ignore: unused_element
  String _getTeachingTypeName(String id) {
    final option = _teachingTypeOptions.firstWhere(
      (item) => item['id'] == id,
      orElse: () => {'name': '授课形式', 'id': ''},
    );
    return option['name']!;
  }
}
