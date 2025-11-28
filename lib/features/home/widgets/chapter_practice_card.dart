import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/question_bank_model.dart';

/// 章节练习卡片
class ChapterPracticeCard extends StatelessWidget {
  final List<ChapterModel> chapters;

  const ChapterPracticeCard({
    super.key,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '章节练习',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12.h),
          ...chapters.take(5).map((chapter) => _ChapterItem(chapter: chapter)),
          if (chapters.length > 5)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Center(
                child: Text(
                  '查看全部 ${chapters.length} 个章节',
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF5B9BFF)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChapterItem extends StatelessWidget {
  final ChapterModel chapter;

  const _ChapterItem({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final progress = chapter.questionCount > 0
        ? chapter.doneCount / chapter.questionCount
        : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.chapterName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${chapter.doneCount}/${chapter.questionCount} 题',
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF5B9BFF)),
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}
