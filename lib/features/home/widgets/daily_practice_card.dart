import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/question_bank_model.dart';
import 'section_title.dart';

/// 每日一测卡片
class DailyPracticeCard extends StatelessWidget {
  final DailyPracticeModel dailyPractice;
  final VoidCallback onTap;

  const DailyPracticeCard({
    super.key,
    required this.dailyPractice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '每日一测'),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEBF8FF), Color(0xFFFFFFFF)],
                stops: [0.0, 0.4],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 标题
                Text(
                  dailyPractice.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF161F30),
                    height: 1.0,
                  ),
                ),
                // 立即刷题按钮
                Container(
                  width: 100.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF860E), Color(0xFFFF6912)],
                    ),
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(35.r),
                      child: Center(
                        child: Text(
                          '立即刷题',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
