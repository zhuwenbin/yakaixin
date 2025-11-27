import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
// import 已移除 - 现在使用API调用，MockInterceptor会自动处理Mock数据

/// 我的课程页面 - 对应小程序 study/myCourse/index.vue
/// 功能：显示已购买的课程列表，支持按授课方式筛选
class MyCoursePage extends ConsumerStatefulWidget {
  const MyCoursePage({super.key});

  @override
  ConsumerState<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends ConsumerState<MyCoursePage> {
  String _teachingType = '3'; // 3: 全部, 1: 录播, 2: 直播
  bool _loading = true;
  final List<Map<String, dynamic>> _courseList = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_loading && _hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadCourses() async {
    setState(() {
      _loading = true;
    });
    // TODO: API调用
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _courseList.addAll(_mockCourses);
      _loading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _currentPage++;
      _loading = false;
    });
  }

  void _onTeachingTypeChanged(String type) {
    setState(() {
      _teachingType = type;
      _currentPage = 1;
      _courseList.clear();
    });
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(
        title: const Text('我的课程'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildTeachingTypeTab(),
          Expanded(
            child: _buildCourseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingTypeTab() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _buildTabItem('3', '全部'),
          SizedBox(width: 20.w),
          _buildTabItem('1', '录播'),
          SizedBox(width: 20.w),
          _buildTabItem('2', '直播'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String value, String label) {
    final isSelected = _teachingType == value;
    return GestureDetector(
      onTap: () => _onTeachingTypeChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F69FF) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2F69FF) : const Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    if (_loading && _courseList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_courseList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: _courseList.length + (_loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _courseList.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _CourseItem(course: _courseList[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            '暂无课程',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF999999)),
          ),
          SizedBox(height: 8.h),
          Text(
            '快去选购课程开始学习吧~',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFFCCCCCC)),
          ),
        ],
      ),
    );
  }

  // 从 Mock数据文件获取数据
  // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
  // TODO: 使用 Dio 调用 API，MockInterceptor 会自动返回 Mock 数据
  List<Map<String, dynamic>> get _mockCourses => []; // MockCourseData.myCourseList;
}

/// 课程项组件
class _CourseItem extends StatelessWidget {
  final Map<String, dynamic> course;

  const _CourseItem({required this.course});

  @override
  Widget build(BuildContext context) {
    final className = course['class']?['name'] ?? '';
    final teachers = (course['class']?['teacher'] as List?) ?? [];
    final progress = course['learn_progress'] ?? 0;
    final teachingType = course['teaching_type'] ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(teachingType),
          SizedBox(height: 12.h),
          _buildClassName(className),
          SizedBox(height: 8.h),
          _buildTeachers(teachers),
          SizedBox(height: 12.h),
          _buildProgress(progress),
          SizedBox(height: 12.h),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(String teachingType) {
    final typeText = teachingType == '1' ? '录播' : (teachingType == '2' ? '直播' : '');
    if (typeText.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        typeText,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF2F69FF),
        ),
      ),
    );
  }

  Widget _buildClassName(String className) {
    return Text(
      className,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF262629),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTeachers(List teachers) {
    if (teachers.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.person_outline, size: 14.sp, color: const Color(0xFF999999)),
        SizedBox(width: 4.w),
        Text(
          teachers.map((t) => t['name'] ?? '').join('、'),
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF999999),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgress(int progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '学习进度',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666)),
            ),
            Text(
              '$progress%',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF2F69FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: const Color(0xFFF0F0F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2F69FF)),
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // 查看课程详情
              // ✅ 修复：添加缺少的 orderId 参数
              context.push(
                AppRoutes.courseDetail,
                extra: {
                  'goodsId': course['goods_id'],
                  'orderId': course['order_id'] ?? '',
                  'goodsPid': course['goods_pid'],
                },
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2F69FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            child: Text(
              '课程详情',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2F69FF)),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // 继续学习
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F69FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              elevation: 0,
            ),
            child: Text(
              '继续学习',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
