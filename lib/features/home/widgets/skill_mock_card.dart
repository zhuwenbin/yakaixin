import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/question_bank_model.dart';

/// 技能模拟卡片
class SkillMockCard extends StatelessWidget {
  final SkillMockModel skillMock;

  const SkillMockCard({
    super.key,
    required this.skillMock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology, size: 24.sp, color: const Color(0xFFFF8A5B)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skillMock.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                if (skillMock.desc != null && skillMock.desc!.isNotEmpty)
                  Text(
                    skillMock.desc!,
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20.sp, color: const Color(0xFF999999)),
        ],
      ),
    );
  }
}
