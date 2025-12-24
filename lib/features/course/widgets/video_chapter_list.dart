import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 章节列表组件
class VideoChapterList extends StatelessWidget {
  final List<Map<String, dynamic>> chapters;
  final Function(int) onToggleExpand;
  final Function(Map<String, dynamic>) onSwitchLesson;

  const VideoChapterList({
    super.key,
    required this.chapters,
    required this.onToggleExpand,
    required this.onSwitchLesson,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Center(
        child: Text(
          '暂无目录',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        return _ChapterItem(
          chapter: chapters[index],
          onToggleExpand: () => onToggleExpand(index),
          onSwitchLesson: onSwitchLesson,
        );
      },
    );
  }
}

/// 章节项
class _ChapterItem extends StatelessWidget {
  final Map<String, dynamic> chapter;
  final VoidCallback onToggleExpand;
  final Function(Map<String, dynamic>) onSwitchLesson;

  const _ChapterItem({
    required this.chapter,
    required this.onToggleExpand,
    required this.onSwitchLesson,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = chapter['expand'] == true;
    final subs = chapter['subs'] as List? ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          _buildHeader(isExpanded, subs.length),
          if (isExpanded)
            ...subs.map<Widget>(
              (section) => _SectionItem(
                section: section,
                onTap: () => onSwitchLesson(section),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isExpanded, int subsCount) {
    return GestureDetector(
      onTap: onToggleExpand,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chapter['name']?.toString() ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF262629),
                ),
              ),
            ),
            Text(
              '$subsCount节',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF999999),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 20.sp,
              color: const Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }
}

/// 课节项
class _SectionItem extends StatelessWidget {
  final Map<String, dynamic> section;
  final VoidCallback onTap;

  const _SectionItem({
    required this.section,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF4F5F5), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 3.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3B7BFB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['time']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF696E7A),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    section['name']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF5B6E81),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                '播放',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF3B7BFB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
