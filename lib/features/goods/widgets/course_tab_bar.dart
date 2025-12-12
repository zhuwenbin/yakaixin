import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// 课程Tab切换组件
/// 对应小程序: .tab
class CourseTabBar extends StatelessWidget {
  final int tabIndex;
  final Function(int) onTabChanged;
  final List<Map<String, dynamic>> tabList;

  const CourseTabBar({
    super.key,
    required this.tabIndex,
    required this.onTabChanged,
    required this.tabList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: tabList.map((tab) {
          final isActive = tabIndex == tab['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(tab['id']),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tab['title'],
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                      if (tab['hasIcon'] == true) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.play_circle,
                          size: 16.sp,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    height: 3.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      borderRadius: AppRadius.radiusXs,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
