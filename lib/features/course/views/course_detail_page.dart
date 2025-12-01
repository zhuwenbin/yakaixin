import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import '../providers/course_detail_provider.dart';
import '../models/course_detail_model.dart';
import '../../../core/utils/safe_type_converter.dart';

/// 学习课程详情页面 - 对应小程序 study/detail/index.vue
/// 功能：显示课程信息、学习进度、课程列表
class CourseDetailPage extends ConsumerStatefulWidget {
  final String goodsId;
  final String orderId;
  final String? goodsPid;

  const CourseDetailPage({
    super.key,
    required this.goodsId,
    required this.orderId,
    this.goodsPid,
  });

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  /// 拼接完整图片路径
  /// 对应小程序: completePath() (Line 478-486)
  String _completePath(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    // 如果已经包含完整域名,直接返回
    if (path.contains('http://') || path.contains('https://')) {
      return path;
    }
    // 拼接完整路径
    return 'https://yakaixin.oss-cn-beijing.aliyuncs.com/$path';
  }

  @override
  void initState() {
    super.initState();
    // ✅ 使用 Provider 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(courseDetailNotifierProvider.notifier)
          .loadAllData(
            goodsId: widget.goodsId,
            orderId: widget.orderId,
            goodsPid: widget.goodsPid,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseDetailNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? _buildError(state.error!)
          : _buildContent(state),
      // ✅ 小程序中没有底部按钮，已删除
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('课程详情'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            error,
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(courseDetailNotifierProvider.notifier)
                  .loadAllData(
                    goodsId: widget.goodsId,
                    orderId: widget.orderId,
                    goodsPid: widget.goodsPid,
                  );
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CourseDetailState state) {
    final courseInfo = state.courseInfo;
    final classList = state.classList;
    final recentlyData = state.recentlyData;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 课程头部信息
          if (courseInfo != null) _buildCourseHeader(courseInfo),
          // 继续学习卡片
          if (recentlyData != null) _buildContinueLearning(recentlyData),
          // 课程列表
          ...classList.map((classItem) => _buildLessonClassCard(classItem)),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// 课程头部信息
  Widget _buildCourseHeader(CourseDetailModel courseInfo) {
    final classInfo = courseInfo.classInfo ?? {};
    final lessonNum = SafeTypeConverter.toInt(classInfo['lesson_num']);
    final lessonAttendanceNum = SafeTypeConverter.toInt(
      classInfo['lesson_attendance_num'],
    );
    final progress = lessonNum > 0
        ? ((lessonAttendanceNum / lessonNum) * 100).round()
        : 0;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCourseName(courseInfo),
          SizedBox(height: 12.h),
          _buildCourseDate(classInfo['date']?.toString() ?? ''),
          SizedBox(height: 16.h),
          _buildProgress(progress),
          SizedBox(height: 16.h),
          _buildTeachers(classInfo['teacher'] as List? ?? []),
        ],
      ),
    );
  }

  Widget _buildCourseName(CourseDetailModel courseInfo) {
    final businessType = SafeTypeConverter.toInt(courseInfo.businessType);

    return Row(
      children: [
        if (businessType == 2 || businessType == 3)
          Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: businessType == 2
                  ? const Color(0xFFFFE5CC)
                  : const Color(0xFFE6F4FF),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              businessType == 2 ? '高端' : '私塾',
              style: TextStyle(
                fontSize: 12.sp,
                color: businessType == 2
                    ? const Color(0xFFFF6600)
                    : const Color(0xFF018CFF),
              ),
            ),
          ),
        Expanded(
          child: Text(
            courseInfo.goodsName ?? '课程名称',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF262629),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDate(String date) {
    return Text(
      date,
      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
    );
  }

  Widget _buildProgress(int progress) {
    return Row(
      children: [
        Text(
          '学习进度',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.r),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: const Color(0xFFD3F4E2),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF018CFF)),
              minHeight: 6.h,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          '$progress%',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildTeachers(List teachers) {
    if (teachers.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16.w,
      runSpacing: 12.h,
      children: teachers.map<Widget>((teacher) {
        if (teacher is! Map<String, dynamic>) return const SizedBox.shrink();
        return _TeacherItem(teacher: teacher, completePath: _completePath);
      }).toList(),
    );
  }

  /// 继续学习卡片
  Widget _buildContinueLearning(RecentlyDataModel recentlyData) {
    final lessonName = recentlyData.lessonName ?? '';
    final displayName = lessonName.length > 12
        ? '${lessonName.substring(0, 12)}...'
        : lessonName;

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // ✅ 使用图片图标（与小程序一致）
          Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/5022173314276286241077_播放.png',
            width: 20.w,
            height: 20.w,
            errorBuilder: (_, __, ___) => Icon(
              Icons.play_circle,
              size: 20.sp,
              color: const Color(0xFF018CFF),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              displayName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF262629),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (recentlyData.lessonId != null) {
                _goLookCourse(recentlyData.lessonId!, '3', {
                  'lesson_id': recentlyData.lessonId,
                  'lesson_name': recentlyData.lessonName,
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                // ✅ 与小程序一致：rgba(1, 163, 99, 0.07)
                color: const Color(0xFF018CFF).withOpacity(0.07),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                '继续学习',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF018CFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 班级课程卡片
  Widget _buildLessonClassCard(CourseClassModel classItem) {
    final index = ref
        .read(courseDetailNotifierProvider)
        .classList
        .indexOf(classItem);
    final isClose = classItem.isClose;
    final lessonNum = SafeTypeConverter.toInt(classItem.lessonNum);
    final lessonAttendanceNum = SafeTypeConverter.toInt(
      classItem.lessonAttendanceNum,
    );
    final progress = lessonNum > 0
        ? ((lessonAttendanceNum / lessonNum) * 100).round()
        : 0;

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildClassHeader(classItem, isClose, progress, index),
          if (!isClose) _buildLessonList(classItem),
        ],
      ),
    );
  }

  Widget _buildClassHeader(
    CourseClassModel classItem,
    bool isClose,
    int progress,
    int index,
  ) {
    final lessonNum = SafeTypeConverter.toInt(classItem.lessonNum);
    final lessonAttendanceNum = SafeTypeConverter.toInt(
      classItem.lessonAttendanceNum,
    );

    return GestureDetector(
      onTap: () {
        ref
            .read(courseDetailNotifierProvider.notifier)
            .toggleClassExpand(index);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4FF),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    classItem.teachingTypeName ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF018CFF),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    classItem.name ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF262629),
                    ),
                  ),
                ),
                Text(
                  '($lessonAttendanceNum/$lessonNum)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  isClose ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  size: 20.sp,
                  color: const Color(0xFF999999),
                ),
              ],
            ),
            if (classItem.address != null && classItem.address!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    classItem.address!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  '班级进度',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: const Color(0xFFD3F4E2),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF018CFF),
                      ),
                      minHeight: 4.h,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '$lessonAttendanceNum/$lessonNum',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList(CourseClassModel classItem) {
    final lessons = classItem.lessons ?? [];

    return Column(
      children: lessons.asMap().entries.map((entry) {
        final index = entry.key;
        final lesson = entry.value;
        return _LessonItem(
          lesson: lesson,
          index: index,
          teachingType: classItem.teachingType ?? '',
          onTap:
              (
                String lessonId,
                String teachingType,
                Map<String, dynamic> lessonData,
              ) => _goLookCourse(lessonId, teachingType, lesson),
          onHomeworkTap: _goAnswer,
        );
      }).toList(),
    );
  }

  void _goLookCourse(
    String lessonId,
    String teachingType,
    Map<String, dynamic> lesson,
  ) {
    // ✅ 对应小程序 goLookCourse 方法
    // teaching_type: "1"=直播, "3"=录播

    // 获取当前班级的ID (对应小程序的 courseItem.id)
    // ⚠️ 修复：使用 lesson_id 进行匹配，避免对象引用比较失败
    final classList = ref.read(courseDetailNotifierProvider).classList;

    print('\n========== 🔍 [开始查找班级] ==========');
    print('📚 班级总数: ${classList.length}');
    print('🎯 目标 lesson_id: ${lesson['lesson_id']}');

    final classItem = classList.firstWhere(
      (item) {
        final lessons = item.lessons;
        if (lessons == null || lessons.isEmpty) {
          print('   - 班级 "${item.name}" (班级ID: ${item.classId}): lessons 为空');
          return false;
        }
        final hasLesson = lessons.any(
          (l) => l['lesson_id'] == lesson['lesson_id'],
        );
        if (hasLesson) {
          print('   ✅ 找到匹配班级: "${item.name}" (班级ID: ${item.classId})');
        }
        return hasLesson;
      },
      orElse: () {
        print('\u26a0️ [班级查找] 未找到匹配的班级，使用第一个班级');
        if (classList.isNotEmpty) {
          print(
            '   ✅ 使用第一个班级: "${classList.first.name}" (班级ID: ${classList.first.classId})',
          );
          return classList.first;
        }
        throw Exception('班级列表为空');
      },
    );

    print('=========================================\n');

    // ✅ 添加详细日志，验证参数传递
    print('\n========== 🎬 [跳转视频播放页] ==========');
    print('🆔 课节ID (lesson_id): $lessonId');
    print('📝 课节名称 (lesson_name): ${lesson['lesson_name']}');
    print('🎥 教学类型 (teaching_type): $teachingType');
    print('📦 套餐商品ID (goods_id): ${widget.goodsId}');
    print('🎯 班级ID (filter_goods_id): ${classItem.classId}');
    print('🎯 班级名称: ${classItem.name}');
    print('🏫 班级ID (class_id): ${classItem.classId}');
    print('🔧 系统ID (system_id): ${lesson['system_id']}');
    print('📋 订单ID (order_id): ${widget.orderId}');

    // ✅ 准备章节数据（从班级中提取）
    final List<Map<String, dynamic>> chapterData = [];
    // 将班级作为一个章节，班级内的lessons作为subs
    if (classItem.lessons != null && classItem.lessons!.isNotEmpty) {
      chapterData.add({
        'id': classItem.classId ?? '1',
        'name': classItem.name ?? '课程列表',
        'subs': classItem.lessons!.map((lessonMap) {
          return {
            'lesson_id': lessonMap['lesson_id']?.toString() ?? '',
            'name': lessonMap['lesson_name']?.toString() ?? '',
            'time': '', // 可以从lesson中获取
            'is_trial_listening':
                lessonMap['is_trial_listening']?.toString() ?? '0',
            'teaching_type': lessonMap['teaching_type']?.toString() ?? '3',
            'system_id': lessonMap['system_id']?.toString() ?? '',
            'status': lessonMap['status']?.toString() ?? '1',
          };
        }).toList(),
      });
      print(
        '📚 准备传递章节数据: ${chapterData.length} 个章节, 共 ${classItem.lessons!.length} 个课节',
      );
    } else {
      print('⚠️ 当前班级没有课节数据');
    }

    print('==========================================\n');

    if (teachingType == '3') {
      // 录播 - 跳转录播页面
      context.push(
        AppRoutes.videoIndex,
        extra: {
          'lesson_id': lessonId,
          'goods_id': widget.goodsId,
          'order_id': widget.orderId,
          'goods_pid': widget.goodsPid,
          'system_id': lesson['system_id']?.toString(),
          'name': lesson['lesson_name']?.toString(),
          'filter_goods_id': classItem.classId, // ✅ 对应小程序 filter_goods_id
          'class_id': classItem.classId, // ✅ 对应小程序 class_id
          'chapter_data': chapterData, // ✅ 新增：直接传递章节数据
        },
      );
    } else if (teachingType == '1') {
      // 直播 - 跳转直播页面
      context.push(
        AppRoutes.liveIndex,
        extra: {
          'lesson_id': lessonId,
          'filter_goods_id': classItem.classId,
          'class_id': classItem.classId,
        },
      );
    }
  }

  void _goAnswer(Map<String, dynamic> lesson, Map<String, dynamic> btn) {
    context.push(
      AppRoutes.makeQuestion,
      extra: {
        'paper_version_id': btn['paper_version_id'],
        'evaluation_type_id': btn['id'],
        'lesson_id': lesson['lesson_id'],
      },
    );
  }
}

/// 教师信息项
class _TeacherItem extends StatelessWidget {
  final Map<String, dynamic> teacher;
  final String Function(String?) completePath;

  const _TeacherItem({required this.teacher, required this.completePath});

  @override
  Widget build(BuildContext context) {
    final avatar = teacher['avatar']?.toString() ?? '';
    final avatarUrl = avatar.isNotEmpty ? completePath(avatar) : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage: avatarUrl.isNotEmpty
              ? NetworkImage(avatarUrl)
              : null,
          child: avatarUrl.isEmpty ? Icon(Icons.person, size: 20.sp) : null,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teacher['name'] ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF262629),
              ),
            ),
            Text(
              teacher['title'] ?? '',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
            ),
          ],
        ),
      ],
    );
  }
}

/// 课程项
class _LessonItem extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final int index;
  final String teachingType;
  final Function(String, String, Map<String, dynamic>) onTap;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onHomeworkTap;

  const _LessonItem({
    required this.lesson,
    required this.index,
    required this.teachingType,
    required this.onTap,
    required this.onHomeworkTap,
  });

  @override
  State<_LessonItem> createState() => _LessonItemState();
}

class _LessonItemState extends State<_LessonItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isFinished = widget.lesson['status'] == '2';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFE8E9EA).withOpacity(0.6)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => widget.onTap(
              widget.lesson['lesson_id'],
              widget.teachingType,
              widget.lesson,
            ),
            child: Row(
              children: [
                Text(
                  '${widget.index + 1 < 10 ? '0' : ''}${widget.index + 1}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF900D),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    widget.lesson['lesson_name'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF262629),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.lesson['lesson_name_other'] != null &&
              widget.lesson['lesson_name_other'].isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildLessonDescription(),
          ],
          SizedBox(height: 8.h),
          // ✅ 课节消息区域（与小程序一致：浅黄色背景，可点击）
          GestureDetector(
            onTap: () => widget.onTap(
              widget.lesson['lesson_id'],
              widget.teachingType,
              widget.lesson,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E3), // 与小程序一致
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  if (widget.teachingType == '1') ...[
                    Icon(
                      widget.lesson['lesson_status'] == '3'
                          ? Icons.play_circle
                          : Icons.videocam,
                      size: 14.sp,
                      color: const Color(0xFF424B57),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.lesson['lesson_status'] == '3' ? '回放' : '直播',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF424B57),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 1,
                      height: 10.h,
                      color: const Color(0xFFE1E5E8),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: Text(
                      widget.lesson['date'] ?? '',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF424B57),
                      ),
                    ),
                  ),
                  Text(
                    isFinished ? '已学完' : '未学习',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isFinished
                          ? const Color(0xFF999999)
                          : const Color(0xFF018CFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.lesson['evaluation_type_top'] != null &&
              widget.lesson['evaluation_type_top'].isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildTopOperations(),
          ],
          // ✅ 新增：底部作业列表
          if (widget.lesson['evaluation_type_bottom'] != null &&
              widget.lesson['evaluation_type_bottom'].isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildBottomEvaluations(),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonDescription() {
    final description = widget.lesson['lesson_name_other'] as String;
    final shouldShowToggle = description.length > 23;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF999999)),
          maxLines: _isExpanded ? null : 1,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),
        if (shouldShowToggle)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? '收起' : '展开',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF018CFF)),
            ),
          ),
      ],
    );
  }

  /// 顶部操作区（作业+资料）
  Widget _buildTopOperations() {
    final topButtons = widget.lesson['evaluation_type_top'] as List;
    final resourceDocument = widget.lesson['resource_document'] as List? ?? [];

    return Container(
      padding: EdgeInsets.only(bottom: 22.h), // 与小程序一致
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 作业按钮
          ...topButtons.asMap().entries.map((entry) {
            final index = entry.key;
            final btn = entry.value;
            final isLast =
                index == topButtons.length - 1 && resourceDocument.isEmpty;
            return _buildOperationButton(
              icon: Icons.assignment,
              text: btn['name'] ?? '',
              onTap: () => widget.onHomeworkTap(widget.lesson, btn),
              showDivider: !isLast,
            );
          }),
          // 资料按钮
          if (resourceDocument.isNotEmpty)
            _buildOperationButton(
              icon: Icons.file_download,
              text: '资料',
              onTap: () {
                final path = resourceDocument[0]['path'];
                if (path != null) {
                  context.push(
                    AppRoutes.dataDownload,
                    extra: {'resource_path': path},
                  );
                }
              },
              showDivider: false,
            ),
        ],
      ),
    );
  }

  /// 操作按钮（带分隔线）
  Widget _buildOperationButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: const Color(0xFF018CFF)),
              SizedBox(width: 4.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF018CFF),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) ...[
          SizedBox(width: 12.w),
          Container(width: 1, height: 10.h, color: const Color(0xFFECEEF1)),
          SizedBox(width: 12.w),
        ],
      ],
    );
  }

  /// 底部作业列表（独立测评）
  Widget _buildBottomEvaluations() {
    final bottomButtons = widget.lesson['evaluation_type_bottom'] as List;

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFE8E9EA).withOpacity(0.6)),
        ),
      ),
      child: Column(
        children: bottomButtons.map<Widget>((item) {
          final isCompleted = item['is_evaluation'] == '1';
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Icon(Icons.quiz, size: 16.sp, color: const Color(0xFF018CFF)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    item['name'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF262629),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: isCompleted
                      ? null
                      : () => widget.onHomeworkTap(widget.lesson, item),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFFE8E9EA)
                          : const Color(0xFF018CFF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      isCompleted ? '已完成' : '去考试',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isCompleted
                            ? const Color(0xFF999999)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
