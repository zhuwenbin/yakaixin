import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/network/dio_client.dart';
import '../../../app/routes/app_routes.dart';

/// 上课主页 - 对应小程序: src/modules/jintiku/pages/study/index.vue
/// 
/// 主要功能：
/// 1. 日历选择器 - 选择日期查看当天课程
/// 2. 今日课程列表 (LessonsList) - 显示选中日期的课节
/// 3. 学习计划 (CourseList) - 显示课程列表,支持授课形式筛选
/// 4. 空状态提示 (NotLearn)
class CoursePage extends ConsumerStatefulWidget {
  const CoursePage({super.key});

  @override
  ConsumerState<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends ConsumerState<CoursePage> {
  DateTime _selectedDate = DateTime.now();
  String _teachingType = ''; // "": 全部, "1": 直播, "2": 面授, "3": 录播
  bool _showCalendar = false;
  bool _showPlan = true; // 是否显示学习计划
  
  // 数据
  List<String> _dotDates = []; // 打卡日期
  Map<String, dynamic>? _lessonsData; // 课节数据
  List<Map<String, dynamic>> _courseList = []; // 课程列表
  bool _loading = true;
  bool _courseListLoading = false;
  
  // ✅ Overlay 相关
  OverlayEntry? _calendarOverlay;
  final LayerLink _layerLink = LayerLink();
  
  final List<Map<String, String>> _teachingTypeOptions = [
    {'name': '全部', 'id': ''},
    {'name': '录播', 'id': '3'},
    {'name': '直播', 'id': '1'},
    {'name': '面授', 'id': '2'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _removeCalendarOverlay();
    super.dispose();
  }

  /// 显示日历 Overlay
  void _showCalendarOverlay() {
    _removeCalendarOverlay();
    
    _calendarOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 遮罩层
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeCalendarOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // 日历下拉框 - 从周历底部展开
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, 42.h + 7.h + 5.h), // ✅ 周历高度(42h) + 底部padding(7h) + 顶部padding(5h)
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 500.h,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: _buildFullCalendar(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    Overlay.of(context).insert(_calendarOverlay!);
    setState(() {
      _showCalendar = true;
    });
  }
  
  /// 移除日历 Overlay
  void _removeCalendarOverlay() {
    _calendarOverlay?.remove();
    _calendarOverlay = null;
    setState(() {
      _showCalendar = false;
    });
  }

  /// 加载所有数据
  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });
    
    await Future.wait([
      _getCalendar(),
      _getDateLessons(),
      _getDateCourse(),
      _getConfigCommon(),
    ]);
    
    setState(() {
      _loading = false;
    });
  }

  /// 获取学习日历(打卡日期) - 获取前后3个月的数据
  Future<void> _getCalendar() async {
    try {
      final dio = ref.read(dioClientProvider);
      
      // ✅ 获取前一个月第一天到后一个月最后一天的日历数据
      final now = DateTime.now();
      final prevMonthFirstDay = DateTime(now.year, now.month - 1, 1);
      final nextMonthLastDay = DateTime(now.year, now.month + 2, 0);
      
      final response = await dio.get(
        '/c/study/learning/calendar',
        queryParameters: {
          'start_date': _formatDate(prevMonthFirstDay),
          'end_date': _formatDate(nextMonthLastDay),
        },
      );
      
      if (response.data['code'] == 100000) {
        final List<dynamic> data = response.data['data'] as List;
        setState(() {
          // ✅ 只保留 status == '1' 的日期用于显示圆点
          _dotDates = data
              .where((item) => item['status'] == '1')
              .map<String>((item) => item['date'] as String)
              .toList();
        });
      }
    } catch (e) {
      print('获取日历失败: $e');
    }
  }

  /// 获取指定日期的课节
  Future<void> _getDateLessons() async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/study/learning/lesson',
        queryParameters: {
          'date': _formatDate(_selectedDate),
        },
      );
      
      if (response.data['code'] == 100000) {
        setState(() {
          _lessonsData = response.data['data'] as Map<String, dynamic>?;
        });
      } else {
        setState(() {
          _lessonsData = null;
        });
      }
    } catch (e) {
      print('获取课节失败: $e');
      setState(() {
        _lessonsData = null;
      });
    }
  }

  /// 获取学习计划课程
  Future<void> _getDateCourse() async {
    setState(() {
      _courseListLoading = true;
    });
    
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/study/learning/plan',
        queryParameters: {
          'teaching_type': _teachingType,
          'date': _formatDate(_selectedDate),
        },
      );
      
      if (response.data['code'] == 100000) {
        final List<dynamic> data = response.data['data'] as List;
        setState(() {
          _courseList = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _courseList = [];
        });
      }
    } catch (e) {
      print('获取课程失败: $e');
      setState(() {
        _courseList = [];
      });
    } finally {
      setState(() {
        _courseListLoading = false;
      });
    }
  }

  /// 获取配置(showPlan开关)
  Future<void> _getConfigCommon() async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/config/common',
        queryParameters: {
          'code': 'PUBLISH',
        },
      );
      
      if (response.data['code'] == 100000) {
        final int value = int.tryParse(response.data['data']?.toString() ?? '2') ?? 2;
        setState(() {
          _showPlan = value == 2; // 2: 显示, 1: 隐藏
        });
      }
    } catch (e) {
      print('获取配置失败: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // ==================== UI 构建方法 ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // 主内容区
          Column(
            children: [
              // 导航栏
              _buildAppBar(),
              // 周历选择
              _buildWeekCalendar(),
              // 内容区
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // ✅ 今日课程列表 - 只有当 lesson_num != '0' 时才显示
                          if (_lessonsData != null &&
                              (_lessonsData!['lesson_num']?.toString() ?? '0') != '0')
                            _buildLessonsList(),
                          // 学习计划区域
                          if (_showPlan) _buildStudyPlan(),
                          // ✅ 无学习内容提示 - 没有课程且没有学习计划时显示
                          if ((_lessonsData == null ||
                                  (_lessonsData!['lesson_num']?.toString() ?? '0') == '0') &&
                              _courseList.isEmpty &&
                              !_loading)
                            _buildNotLearn(),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 顶部Header
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '上课',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final weekDays = _getCurrentWeek(_selectedDate);
    
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(7.w, 5.h, 0, 7.h),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 42.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: weekDays.map((day) => _buildWeekDayItem(day)).toList(),
                ),
              ),
            ),
            _buildMoreDatesButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDayItem(DateTime day) {
    final isSelected = isSameDay(day, _selectedDate);
    final isToday = isSameDay(day, DateTime.now());
    final hasDot = _dotDates.contains(_formatDate(day));
    
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedDate = day;
          _loading = true;
          _lessonsData = null; // ✅ 清空旧数据
          _courseList = [];
        });
        // ✅ 等待数据加载完成
        await Future.wait([
          _getDateLessons(),
          _getDateCourse(),
        ]);
        setState(() {
          _loading = false;
        });
      },
      child: Container(
        width: 40.w,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF018CFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isToday ? '今天' : _getWeekDayName(day),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xFF5B6E81),
                height: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              isSelected
                  ? '${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}'
                  : day.day.toString(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF262629),
                height: 1.1,
              ),
            ),
            if (hasDot)
              SizedBox(height: 3.h),
            if (hasDot)
              Container(
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFF018CFF),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreDatesButton() {
    return GestureDetector(
      onTap: () {
        if (_showCalendar) {
          _removeCalendarOverlay();
        } else {
          _showCalendarOverlay();
        }
      },
      child: Container(
        width: 51.w,
        height: 42.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAFCFF), Color(0xFFFFFFFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x38E8EAEF),
              offset: Offset(-2, 0),
              blurRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '更多',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262629),
                  height: 1.6,
                ),
              ),
              Text(
                '日期',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262629),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 今日课节列表
  Widget _buildLessonsList() {
    final lessonNum = _lessonsData!['lesson_num']?.toString() ?? '0';
    final attendanceNum = _lessonsData!['lesson_attendance_num']?.toString() ?? '0';
    final lessons = (_lessonsData!['lesson_attendance'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    if (lessonNum == '0' || lessons.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Image.network(
                'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
                width: 15.w,
                height: 15.w,
              ),
              SizedBox(width: 5.w),
              Text(
                '今日共',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
              Text(
                lessonNum,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF860E),
                ),
              ),
              Text(
                '节课',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
              SizedBox(width: 13.w),
              Text(
                '已完成',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              Text(
                attendanceNum,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
              Text(
                '节',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // 课节列表
          ...lessons.map((lesson) => _buildLessonItem(lesson)).toList(),
        ],
      ),
    );
  }

  /// 构建单个课节项
  Widget _buildLessonItem(Map<String, dynamic> lesson) {
    return _LessonItemWidget(lesson: lesson);
  }

  /// 学习计划
  Widget _buildStudyPlan() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Image.network(
                'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
                width: 15.w,
                height: 15.w,
              ),
              SizedBox(width: 5.w),
              Text(
                '学习计划',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF262629),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // 筛选和我的课程
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ 授课形式 - 使用 PopupMenuButton
              PopupMenuButton<String>(
                initialValue: _teachingType,
                onSelected: (value) {
                  setState(() {
                    _teachingType = value;
                  });
                  _getDateCourse();
                },
                offset: Offset(0, 35.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                color: Colors.white,
                elevation: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getTeachingTypeName(_teachingType),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
                      color: const Color(0xFF333333),
                    ),
                  ],
                ),
                itemBuilder: (context) => _teachingTypeOptions.map((option) {
                  final isActive = _teachingType == option['id'];
                  return PopupMenuItem<String>(
                    value: option['id'],
                    child: Container(
                      width: 100.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        option['name']!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: isActive
                              ? const Color(0xFF018CFF)
                              : const Color(0xFF333333),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              GestureDetector(
                onTap: () {
                  // 跳转我的课程
                  context.push(AppRoutes.myCourse);
                },
                child: Row(
                  children: [
                    Image.network(
                      'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/652517359747899528889_wodekecheng.png',
                      width: 9.w,
                      height: 9.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '我的课程',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: const Color(0xBF03203D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 课程列表
          if (_courseListLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(25.h),
                child: const CircularProgressIndicator(),
              ),
            )
          else if (_courseList.isEmpty)
            _buildEmptyCourseList()
          else
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                children: _courseList.map((course) => _buildCourseCard(course)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCourseList() {
    return Column(
      children: [
        SizedBox(height: 25.h),
        Image.network(
          'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
          width: 60.w,
          height: 60.w,
        ),
        SizedBox(height: 8.h),
        Text(
          '未找到符合的学习内容',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF999999),
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  /// 构建课程卡片
  Widget _buildCourseCard(Map<String, dynamic> course) {
    return _CourseCardWidget(course: course);
  }

  /// 空状态
  Widget _buildNotLearn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Image.network(
            'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/4045173295663081752515_8b3592c2dcddcac66af8ddd46abbbf1b74efa19fac63-AlBs3V_fw1200%402x.png',
            width: 120.w,
            height: 120.w,
          ),
          SizedBox(height: 16.h),
          Text(
            '未找到学习内容',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// 完整日历选择器
  Widget _buildFullCalendar() {
    return _FullCalendarWidget(
      selectedDate: _selectedDate,
      dotDates: _dotDates,
      onDaySelected: (selectedDay) async {
        setState(() {
          _selectedDate = selectedDay;
          _loading = true;
          _lessonsData = null;
          _courseList = [];
        });
        _removeCalendarOverlay();
        await Future.wait([
          _getDateLessons(),
          _getDateCourse(),
        ]);
        setState(() {
          _loading = false;
        });
      },
      onPageChanged: (focusedDay) {
        _getCalendar();
      },
    );
  }

  // ========== 工具方法 ==========

  List<DateTime> _getCurrentWeek(DateTime date) {
    final weekDay = date.weekday % 7;
    final sunday = date.subtract(Duration(days: weekDay));
    return List.generate(7, (i) => sunday.add(Duration(days: i)));
  }

  String _getWeekDayName(DateTime date) {
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekDays[date.weekday % 7];
  }

  String _getTeachingTypeName(String id) {
    final option = _teachingTypeOptions.firstWhere(
      (item) => item['id'] == id,
      orElse: () => {'name': '授课形式', 'id': ''},
    );
    return option['name']!;
  }
}

/// 课节列表项组件
class _LessonItemWidget extends StatelessWidget {
  final Map<String, dynamic> lesson;

  const _LessonItemWidget({required this.lesson});

  @override
  Widget build(BuildContext context) {
    // ✅ 使用小程序实际的字段名
    final startTime = lesson['start_time']?.toString().split(' ').last.substring(0, 5) ?? '';
    final teachingTypeName = lesson['teaching_type_name']?.toString() ?? '';
    final lessonNum = lesson['lesson_num']?.toString() ?? '';
    final lessonName = lesson['lesson_name']?.toString() ?? '';
    final lessonId = lesson['lesson_id']?.toString() ?? '';
    final hasDocument = (lesson['resource_document'] as List?)?.isNotEmpty ?? false;
    final evaluationTypes = (lesson['evaluation_type'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FF),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧时间和类型
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Text(
                      startTime,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF009F32),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0F4921), width: 1.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        teachingTypeName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0F4921),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 右侧课程信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      lessonNum.isNotEmpty ? '第$lessonNum节' : '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      lessonName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF666666),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 按钮标签区域
          if (hasDocument || evaluationTypes.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (hasDocument)
                    _buildLessonButton(
                      context,
                      '课前作业',
                      isHighlight: true,
                      onTap: () {
                        context.push(AppRoutes.dataDownload, extra: {'lesson_id': lessonId});
                      },
                    ),
                  if (hasDocument && evaluationTypes.isNotEmpty)
                    SizedBox(width: 8.w),
                  ...evaluationTypes.asMap().entries.map((entry) {
                    final evaluationType = entry.value;
                    final evaluationId = evaluationType['id']?.toString() ?? '';
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLessonButton(
                          context,
                          entry.value['name']?.toString() ?? '',
                          onTap: () {
                            context.push(
                              AppRoutes.makeQuestion,
                              extra: {
                                'lesson_id': lessonId,
                                'evaluation_id': evaluationId,
                                'type': 'evaluation',
                              },
                            );
                          },
                        ),
                        if (entry.key < evaluationTypes.length - 1)
                          SizedBox(width: 8.w),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLessonButton(BuildContext context, String text, {bool isHighlight = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        decoration: BoxDecoration(
          gradient: isHighlight
              ? const LinearGradient(
                  colors: [Color(0xFFFF860E), Color(0xFFFF6912)],
                )
              : null,
          border: isHighlight ? null : Border.all(color: const Color(0xFFFF5500)),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isHighlight ? Colors.white : const Color(0xFFFF5500),
          ),
        ),
      ),
    );
  }
}

/// 完整日历组件
class _FullCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> dotDates;
  final Function(DateTime) onDaySelected;
  final Function(DateTime)? onPageChanged;

  const _FullCalendarWidget({
    required this.selectedDate,
    required this.dotDates,
    required this.onDaySelected,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        locale: 'zh_CN',
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2030, 12, 31),
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        headerStyle: _buildHeaderStyle(),
        calendarStyle: _buildCalendarStyle(),
        daysOfWeekStyle: _buildDaysOfWeekStyle(),
        calendarBuilders: _buildCalendarBuilders(),
        onDaySelected: (selectedDay, focusedDay) {
          onDaySelected(selectedDay);
        },
        onPageChanged: onPageChanged != null
            ? (focusedDay) => onPageChanged!(focusedDay)
            : null,
      ),
    );
  }

  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextFormatter: (date, locale) {
        return '${date.year}年${date.month}月';
      },
      titleTextStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF333333),
      ),
      leftChevronIcon: Icon(
        Icons.chevron_left,
        color: const Color(0xFF333333),
        size: 24.sp,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right,
        color: const Color(0xFF333333),
        size: 24.sp,
      ),
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: const Color(0xFF018CFF).withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      selectedDecoration: const BoxDecoration(
        color: Color(0xFF018CFF),
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: const Color(0xFF018CFF),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      selectedTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      defaultTextStyle: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 14.sp,
      ),
      weekendTextStyle: TextStyle(
        color: const Color(0xFF333333),
        fontSize: 14.sp,
      ),
      outsideTextStyle: TextStyle(
        color: const Color(0xFFCCCCCC),
        fontSize: 14.sp,
      ),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: TextStyle(
        color: const Color(0xFF666666),
        fontSize: 12.sp,
      ),
      weekendStyle: TextStyle(
        color: const Color(0xFF666666),
        fontSize: 12.sp,
      ),
    );
  }

  CalendarBuilders _buildCalendarBuilders() {
    return CalendarBuilders(
      dowBuilder: (context, day) {
        final text = DateFormat.E('zh_CN').format(day);
        return Center(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF666666),
              fontSize: 12.sp,
            ),
          ),
        );
      },
      markerBuilder: (context, date, events) {
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if (dotDates.contains(dateStr)) {
          return Positioned(
            bottom: 4.h,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B6B),
                shape: BoxShape.circle,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

/// 课程卡片组件
class _CourseCardWidget extends StatelessWidget {
  final Map<String, dynamic> course;

  const _CourseCardWidget({required this.course});

  @override
  Widget build(BuildContext context) {
    final goodsName = course['goods_name']?.toString() ?? '';
    final teachingTypeName = course['teaching_type_name']?.toString() ?? '';
    final classInfo = course['class'] as Map<String, dynamic>?;
    final classDate = classInfo?['date']?.toString() ?? '';
    final goodsPid = course['goods_pid']?.toString() ?? '0';
    final goodsPidName = course['goods_pid_name']?.toString() ?? '';
    final goodsId = course['goods_id']?.toString() ?? '';
    final orderId = course['order_id']?.toString() ?? '';

    return GestureDetector(
      onTap: () {
        // ✅ 修复：使用正确的参数键名（驼峰命名）
        context.push(
          AppRoutes.courseDetail,
          extra: {
            'goodsId': goodsId,
            'orderId': orderId,
            'goodsPid': goodsPid,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (teachingTypeName.isNotEmpty)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4921),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    teachingTypeName,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 8.h),
            Text(
              goodsName,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF000000),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Text(
              classDate,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF666666),
              ),
            ),
            if (goodsPid != '0' && goodsPidName.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        '套餐：',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF7E4E0C),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          goodsPidName,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF7E4E0C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
