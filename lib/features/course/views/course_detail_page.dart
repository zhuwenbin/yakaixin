import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import '../providers/course_detail_provider.dart';
import '../models/course_detail_model.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../../app/config/api_config.dart';
import '../helpers/course_navigation_helper.dart';

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
  /// 拼接完整图片路径（使用 ApiConfig.completeImageUrl，避免双斜杠）
  String _completePath(String? path) {
    return ApiConfig.completeImageUrl(path);
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

  /// 头部学习进度条，与小程序 index-new.vue .learn-course-details-progress 一致
  /// 小程序：u-line-progress 默认背景 #ececec、填充 #018CFF、高度 12px、圆角 100px；
  /// 百分数 #018CFF，学习进度文案 12px #424b57，间距 9/14
  Widget _buildProgress(int progress) {
    return Row(
      children: [
        Text(
          '学习进度',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF424B57),
          ),
        ),
        SizedBox(width: 9.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: const Color(0xFFECECEC),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF018CFF)),
              minHeight: 12.h,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          '$progress%',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF018CFF),
          ),
        ),
      ],
    );
  }

  Widget _buildTeachers(List teachers) {
    // ✅ 过滤掉头像和name都为空的数据（和列表页一样）
    final filteredTeachers = teachers.where((teacher) {
      if (teacher is! Map<String, dynamic>) return false;
      final avatar = teacher['avatar']?.toString().trim() ?? '';
      final name = teacher['name']?.toString().trim() ?? '';
      return avatar.isNotEmpty || name.isNotEmpty;
    }).toList();

    if (filteredTeachers.isEmpty) return const SizedBox.shrink();

    // ✅ 将教师列表分组，每两个一组（和列表页一样）
    final List<List<dynamic>> teacherGroups = [];
    for (int i = 0; i < filteredTeachers.length; i += 2) {
      if (i + 1 < filteredTeachers.length) {
        teacherGroups.add([filteredTeachers[i], filteredTeachers[i + 1]]);
      } else {
        teacherGroups.add([filteredTeachers[i]]);
      }
    }

    return Column(
      children: teacherGroups.map((group) {
        return Padding(
          padding: EdgeInsets.only(bottom: 22.h), // ✅ 小程序22rpx ÷ 2 = 22.h（垂直间距）
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 第一个教师
              Expanded(
                child: _TeacherItem(teacher: group[0], completePath: _completePath),
              ),
              // ✅ 如果有第二个教师，显示第二个
              if (group.length > 1) ...[
                SizedBox(width: 12.w), // ✅ 两个教师之间的间距
                Expanded(
                  child: _TeacherItem(teacher: group[1], completePath: _completePath),
                ),
              ],
            ],
          ),
        );
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
            ApiConfig.completeImageUrl('public/5022173314276286241077_播放.png'),
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
                // ✅ 修复：从课程列表中查找对应的课节，获取真实的 teaching_type
                final classList = ref.read(courseDetailNotifierProvider).classList;
                Map<String, dynamic>? targetLesson;
                String teachingType = '3'; // 默认录播
                
                // 遍历所有班级，查找对应的课节
                for (final classItem in classList) {
                  final lessons = classItem.lessons ?? [];
                  final found = lessons.firstWhere(
                    (lesson) => lesson['lesson_id'] == recentlyData.lessonId,
                    orElse: () => {},
                  );
                  if (found.isNotEmpty) {
                    targetLesson = found;
                    teachingType = classItem.teachingType ?? '3';
                    debugPrint('✅ [继续学习] 找到对应课节，teaching_type: $teachingType');
                    break;
                  }
                }
                
                if (targetLesson == null) {
                  debugPrint('⚠️ [继续学习] 未找到对应课节，使用默认 teaching_type=3');
                  targetLesson = {
                    'lesson_id': recentlyData.lessonId,
                    'lesson_name': recentlyData.lessonName,
                  };
                }
                
                _goLookCourse(recentlyData.lessonId!, teachingType, targetLesson);
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

    // 与小程序一致：卡片顶部渐变背景 #E8FFF2 -> #F1FFF8 -> #F4FFFB，下方白色（index-new.vue .learn-course-list-item）
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8FFF2),
            Color(0xFFF1FFF8),
            Color(0xFFF4FFFB),
            Colors.white,
          ],
          stops: [0.0, 0.35, 0.55, 1.0],
        ),
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
                // 与小程序 .teaching-type 一致：蓝底白字 31×17px、圆角 2px、11px
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  constraints: BoxConstraints(minWidth: 31.w, minHeight: 17.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF018CFF),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    classItem.teachingTypeName ?? '',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    classItem.name ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF262629),
                    ),
                  ),
                ),
                Text(
                  '($lessonAttendanceNum/$lessonNum)',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF262629),
                  ),
                ),
                SizedBox(width: 8.w),
                Image.network(
                  isClose
                      ? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/31c3173314287462623784_%E4%B8%8A.png'
                      : 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/57dd17331428838889503_%E4%B8%8B.png',
                  width: 17.w,
                  height: 17.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    isClose ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    size: 17.sp,
                    color: const Color(0xFF262629),
                  ),
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
            // 与学习进度一致：进度条底色 #ECECEC，填充 #018CFF、高 12、圆角 100
            Row(
              children: [
                Text(
                  '班级进度',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF424B57),
                  ),
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: const Color(0xFFECECEC),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF018CFF),
                      ),
                      minHeight: 12.h,
                    ),
                  ),
                ),
                SizedBox(width: 17.w),
                Text(
                  '$lessonAttendanceNum/$lessonNum',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF424B57),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 与小程序 .learn-course-list-content 一致：白底、左右 2px 边距、padding 18px 16px 0（上18 左16 右16 下0），小节无额外左右 padding
  Widget _buildLessonList(CourseClassModel classItem) {
    final lessons = classItem.lessons ?? [];
    final total = lessons.length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
      color: Colors.white,
      child: Column(
        children: lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          return _LessonItem(
            lesson: lesson,
            index: index,
            isFirst: index == 0,
            isLast: index == total - 1,
            teachingType: classItem.teachingType ?? '',
            onTap:
                (
                  String lessonId,
                  String teachingType,
                  Map<String, dynamic> lessonData,
                ) =>
                    _goLookCourse(lessonId, teachingType, lesson),
            onHomeworkTap: _goAnswer,
          );
        }).toList(),
      ),
    );
  }

  Future<void> _goLookCourse(
    String lessonId,
    String teachingType,
    Map<String, dynamic> lesson,
  ) async {
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
      // 与小程序一致：filter_goods_id 用 courseItem.id（套餐商品 id），目录接口只认此 id
      final classIndex = classList.indexWhere(
        (c) => c.classId == classItem.classId,
      );
      final packageGoodsId = classItem.id ?? classItem.classId;
      debugPrint('📹 [课程详情] 录播课程，filterGoodsId(套餐id)=$packageGoodsId, classIndex=$classIndex');
      await CourseNavigationHelper.navigateToLesson(
        context: context,
        ref: ref,
        lessonId: lessonId,
        lessonName: lesson['lesson_name']?.toString() ?? '录播',
        teachingType: teachingType,
        classId: classItem.classId,
        filterGoodsId: packageGoodsId,
        classIndex: classIndex >= 0 ? classIndex : null,
        goodsId: widget.goodsId,
        orderId: widget.orderId,
        systemId: lesson['system_id']?.toString(),
      );
    } else if (teachingType == '1') {
      // ✅ 直播课程 - 调用 CourseNavigationHelper（与小程序一致）
      debugPrint('📺 [课程详情] 直播课程，调用导航辅助类');
      await CourseNavigationHelper.navigateToLesson(
        context: context,
        ref: ref,
        lessonId: lessonId,
        lessonName: lesson['lesson_name']?.toString() ?? '直播',
        teachingType: teachingType,
        classId: classItem.classId, // ✅ 传递 classId（用于签到）
      );
    }
  }

  /// 跳转到课前测/课后测答题页面
  /// 
  /// 对应小程序：pages/answertest/answer
  /// Flutter页面：ExaminationingPage
  void _goAnswer(Map<String, dynamic> lesson, Map<String, dynamic> btn) {
    debugPrint('📝 [课程详情] 跳转课前测/课后测');
    debugPrint('  课节: ${lesson['lesson_name']}');
    debugPrint('  测评: ${btn['name']}');
    debugPrint('  paper_version_id: ${btn['paper_version_id']}');
    debugPrint('  evaluation_type_id: ${btn['id']}');
    
    context.push(
      AppRoutes.examinationing,  // ✅ 修正：使用正确的路由
      extra: {
        'paper_version_id': btn['paper_version_id'] ?? '',
        'evaluation_type_id': btn['id'] ?? '',  // ✅ 测评类型ID（课前测、课后测等）
        'professional_id': btn['professional_id'] ?? '',
        'goods_id': widget.goodsId,  // ✅ 从页面属性获取
        'order_id': widget.orderId,  // ✅ 从页面属性获取
        'title': btn['name'] ?? '',  // ✅ 测评名称作为标题
        'type': '',  // ✅ 空字符串表示课程测评
      },
    );
  }
}

/// 教师信息项（和列表页样式一致）
class _TeacherItem extends StatelessWidget {
  final Map<String, dynamic> teacher;
  final String Function(String?) completePath;

  const _TeacherItem({required this.teacher, required this.completePath});

  @override
  Widget build(BuildContext context) {
    final avatar = teacher['avatar']?.toString() ?? '';
    final name = teacher['name']?.toString() ?? '';
    final title = teacher['title']?.toString() ?? '';
    final avatarUrl = avatar.isNotEmpty ? completePath(avatar) : '';

    return Row(
      children: [
        // 头像（和列表页样式一致）
        Container(
          width: 40.w, // ✅ 小程序80rpx ÷ 2 = 40.w
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 2.w), // ✅ 小程序2rpx ÷ 2 = 2.w
          ),
          child: ClipOval(
            // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
            child: Image.network(
              avatarUrl.isNotEmpty
                  ? avatarUrl
                  : 'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/teacher_avatar.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.network(
                'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/teacher_avatar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w), // ✅ 小程序10rpx ÷ 2 = 5.w
        // 姓名和职称
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 12.sp, // ✅ 小程序24rpx ÷ 2 = 12.sp
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF262629),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h), // ✅ 小程序6rpx ÷ 2 = 3.h
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF262629).withOpacity(0.6), // ✅ 小程序rgba(38, 38, 41, 0.6)
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 课程项
class _LessonItem extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final int index;
  final bool isFirst;
  final bool isLast;
  final String teachingType;
  final Function(String, String, Map<String, dynamic>) onTap;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onHomeworkTap;

  const _LessonItem({
    required this.lesson,
    required this.index,
    required this.isFirst,
    required this.isLast,
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

    const dividerColor = Color(0xFFE8E9EA);
    const dividerOpacity = 0.6;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isFirst)
          Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: dividerColor.withOpacity(dividerOpacity),
          ),
        Container(
          padding: EdgeInsets.only(bottom: 19.h),
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
                  '${widget.index + 1}',
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
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
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
        ),
        if (!widget.isLast)
          Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: dividerColor.withOpacity(dividerOpacity),
          ),
      ],
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
