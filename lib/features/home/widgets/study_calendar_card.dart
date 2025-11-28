import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/question_bank_model.dart';

class StudyCalendarCard extends StatelessWidget {
  final LearningDataModel? learningData;
  final VoidCallback? onCheckIn;

  const StudyCalendarCard({super.key, this.learningData, this.onCheckIn});

  @override
  Widget build(BuildContext context) {
    if (learningData == null) return const SizedBox.shrink();
    
    // ✅ 将 int 类型的 isCheckin (0/1) 转换为 bool
    final isCheckin = (learningData!.isCheckin == 1);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('学习统计', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('签到天数', '${learningData!.checkinNum}', const Color(0xFF5B9BFF)),
              _buildStatItem('已做题目', '${learningData!.totalNum}', const Color(0xFFFF8A5B)),
              _buildStatItem('正确率', learningData!.correctRate, const Color(0xFF5BFF8A)),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: isCheckin ? null : onCheckIn,
            child: Container(
              width: double.infinity,
              height: 44.h,
              decoration: BoxDecoration(
                gradient: isCheckin ? null : const LinearGradient(colors: [Color(0xFF5B9BFF), Color(0xFF8AB8FF)]),
                color: isCheckin ? const Color(0xFFEEEEEE) : null,
                borderRadius: BorderRadius.circular(22.r),
              ),
              alignment: Alignment.center,
              child: Text(
                isCheckin ? '今日已签到' : '立即签到',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: isCheckin ? const Color(0xFF999999) : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999))),
      ],
    );
  }
}
