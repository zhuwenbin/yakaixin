import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/question_bank_model.dart';

class DailyPracticeCard extends StatelessWidget {
  final DailyPracticeModel dailyPractice;

  const DailyPracticeCard({super.key, required this.dailyPractice});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 24.sp, color: const Color(0xFF5B9BFF)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(dailyPractice.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ),
          Icon(Icons.chevron_right, size: 20.sp, color: const Color(0xFF999999)),
        ],
      ),
    );
  }
}
