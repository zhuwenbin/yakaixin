import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/app/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../home/services/goods_service.dart';
import '../../home/models/goods_model.dart';
import '../../main/main_tab_page.dart'; // 导入 mainTabIndexProvider
import '../../../core/storage/storage_service.dart'; // ✅ 新增 StorageService
import '../../../app/constants/storage_keys.dart';  // ✅ 新增 StorageKeys
// import 已移除 - 现在使用API调用，MockInterceptor会自动处理Mock数据

/// 课程详情页面 - 对应小程序 study/detail/index.vue
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
  // ✅ 使用真实数据模型
  GoodsModel? _goodsDetail;
  bool _isLoading = true;
  String? _errorMessage;
  
  // 从 Mock数据文件获取数据
  // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
  // TODO: 使用 Dio 调用 API，MockInterceptor 会自动返回 Mock 数据
  Map<String, dynamic> get _mockCourseInfo => {}; // MockCourseData.courseDetail;
  Map<String, dynamic> get _mockRecentlyData => {}; // MockCourseData.recentlyData;
  List<Map<String, dynamic>> get _mockLessonList => []; // MockCourseData.lessonList;
  
  @override
  void initState() {
    super.initState();
    _loadGoodsDetail();
  }
  
  /// 加载商品详情，检查购买状态
  /// 对应小程序 Line 466-480: mounted() 中的逻辑
  Future<void> _loadGoodsDetail() async {
    try {
      // ✅ 关键修复：优先使用传入的 orderId 参数（对应小程序 Line 651-653）
      final orderId = _getOrderIdValue(widget.orderId);
      
      print('\n========== 🔍 [课程详情] 开始加载 ==========');
      print('📦 传入参数:');
      print('  - goodsId: ${widget.goodsId}');
      print('  - orderId: ${widget.orderId} (原始值)');
      print('  - orderId (转换后): $orderId');
      print('  - goodsPid: ${widget.goodsPid}');
      
      // ⚠️ 如果传入的 orderId 有值且大于0，说明已报名，直接显示课程详情
      if (orderId != null && orderId > 0) {
        print('\n✅ 判断结果: 已报名（orderId > 0）');
        print('  → 直接显示课程详情 + "去学习"按钮');
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      // ⚠️ orderId 为空或0，需要调用 getGoodsDetail 检查 permission_order_id
      print('\n📝 判断结果: orderId 为空或0，需要调用 getGoodsDetail 检查权限');
      
      final goodsService = ref.read(goodsServiceProvider);
      
      // ✅ 关键修复: 获取学生ID并传递给API
      final storage = ref.read(storageServiceProvider);
      final studentId = storage.getString(StorageKeys.studentId);
      
      
      final goods = await goodsService.getGoodsDetail(
        goodsId: widget.goodsId,
        userId: studentId,     // ✅ 传递 userId
        studentId: studentId,  // ✅ 传递 studentId
      );
      
 
      
      setState(() {
        _goodsDetail = goods;
        _isLoading = false;
      });
      
      // ✅ 关键判断：参照小程序 Line 475-478
      // 检查 permission_order_id 是否为 0（未报名）
      final permissionOrderId = _getOrderIdValue(goods.permissionOrderId);
      
      print('\n🔍 购买状态判断:');
      print('  - permission_order_id (转换后): $permissionOrderId');
      
      // ⚠️ permission_order_id 为 0 或 null 时，跳转到商品详情页（报名页）
      if (permissionOrderId == null || permissionOrderId == 0) {
        print('\n❌ 最终判断: 未报名（permission_order_id 为空或0）');
        print('  → 跳转到商品详情页（报名/购买页面）');
        // 跳转到商品详情页（报名/购买页面）
        if (mounted) {
          context.push('/course-goods-detail', extra: {
            'goods_id': widget.goodsId,
            'type': goods.type,
          });
        }
        return;
      }
      
      // ✅ 已报名，显示课程详情
      print('\n✅ 最终判断: 已报名（permission_order_id > 0）');
      print('  → 显示课程详情 + "去学习"按钮');
      print('========== ✅ [课程详情] 加载完成 ==========\n');
      
    } catch (e, stackTrace) {
      print('\n❌ [课程详情] 加载失败:');
      print('  错误: $e');
      print('  堆栈: $stackTrace');
      setState(() {
        _errorMessage = '加载失败: $e';
        _isLoading = false;
      });
      EasyLoading.showError('加载课程详情失败');
    }
  }
  
  /// 安全获取 order_id 值
  /// 处理 dynamic 类型，可能是 String "0" 或 int 0 或 null
  int? _getOrderIdValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return int.tryParse(value);
    }
    return null;
  }

 @override
  Widget build(BuildContext context) {
    // ⚠️ 加载中状态
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // ⚠️ 错误状态
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _loadGoodsDetail,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }
    
    // ✅ 正常显示
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
      // ✅ 添加底部"去学习"按钮（已购买且有order_id）
      bottomNavigationBar: _shouldShowLearnButton()
          ? _buildBottomButton()
          : null,
    );
  }
  
  /// 判断是否显示"去学习"按钮
  /// 对应小程序逻辑: 有 order_id 且不为 0
  bool _shouldShowLearnButton() {
    print('\n========== 🔍 判断是否显示"去学习"按钮 ==========');
    
    // ✅ 优先检查传入的 orderId 参数
    final orderId = _getOrderIdValue(widget.orderId);
    print('👉 检查 widget.orderId:');
    print('  - 原始值: ${widget.orderId}');
    print('  - 转换后: $orderId');
    
    if (orderId != null && orderId > 0) {
      print('\n✅ 结果: 显示"去学习"按钮（因为 widget.orderId > 0）');
      print('==============================================\n');
      return true;
    }
    
    // ✅ 如果没有传入 orderId，检查 goodsDetail.permissionOrderId
    print('\n👉 widget.orderId 为空或0，检查 _goodsDetail.permissionOrderId:');
    
    if (_goodsDetail == null) {
      print('  - _goodsDetail: null');
      print('\n❌ 结果: 不显示按钮（_goodsDetail 为 null）');
      print('==============================================\n');
      return false;
    }
    
    print('  - _goodsDetail.permissionOrderId (原始值): ${_goodsDetail!.permissionOrderId}');
    
    final permissionOrderId = _getOrderIdValue(_goodsDetail!.permissionOrderId);
    print('  - permissionOrderId (转换后): $permissionOrderId');
    
    final shouldShow = permissionOrderId != null && permissionOrderId > 0;
    
    if (shouldShow) {
      print('\n✅ 结果: 显示"去学习"按钮（permissionOrderId > 0）');
    } else {
      print('\n❌ 结果: 不显示按钮（permissionOrderId 为空或0）');
    }
    print('==============================================\n');
    
    return shouldShow;
  }
  
  /// 底部"去学习"按钮
  /// 对应小程序的购买后状态，点击返回主页面课程Tab
  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _onGoLearn,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF018CFF), Color(0xFF0066CC)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          alignment: Alignment.center,
          child: Text(
            '去学习',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  
  /// 去学习 - 返回主页面课程Tab
  /// 参照支付成功页的逻辑
  void _onGoLearn() {
    if (mounted) {
      // 1. 设置Tab索引为课程页（索引2）
      ref.read(mainTabIndexProvider.notifier).state = 2;
      // 2. 返回主Tab页面
      context.go(AppRoutes.mainTab);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('课程详情'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCourseHeader(),
          if (_mockRecentlyData['lesson_id'] != null) _buildContinueLearning(),
          ..._buildLessonList(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// 课程头部信息
  Widget _buildCourseHeader() {
    final classInfo = _mockCourseInfo['class'];
    final progress = _calculateProgress(
      classInfo['lesson_attendance_num'],
      classInfo['lesson_num'],
    );

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCourseName(),
          SizedBox(height: 12.h),
          _buildCourseDate(classInfo['date']),
          SizedBox(height: 16.h),
          _buildProgress(progress),
          SizedBox(height: 16.h),
          _buildTeachers(classInfo['teacher']),
        ],
      ),
    );
  }

  Widget _buildCourseName() {
    final businessType = _mockCourseInfo['business_type'];

    return Row(
      children: [
        if (businessType == 2 || businessType == 3)
          Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: businessType == 2 ? const Color(0xFFFFE5CC) : const Color(0xFFE6F4FF),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              businessType == 2 ? '高端' : '私塾',
              style: TextStyle(
                fontSize: 12.sp,
                color: businessType == 2 ? const Color(0xFFFF6600) : const Color(0xFF018CFF),
              ),
            ),
          ),
        Expanded(
          child: Text(
            _mockCourseInfo['goods_name'] ?? '',
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
      date ?? '',
      style: TextStyle(
        fontSize: 12.sp,
        color: const Color(0xFF999999),
      ),
    );
  }

  Widget _buildProgress(int progress) {
    return Row(
      children: [
        Text(
          '学习进度',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
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
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildTeachers(List teachers) {
    if (teachers == null || teachers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 16.w,
      runSpacing: 12.h,
      children: teachers.map<Widget>((teacher) {
        return _TeacherItem(teacher: teacher);
      }).toList(),
    );
  }

  /// 继续学习卡片
  Widget _buildContinueLearning() {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.play_circle, size: 20.sp, color: const Color(0xFF018CFF)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _mockRecentlyData['lesson_name'] ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF262629),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => _goLookCourse(_mockRecentlyData['lesson_id'], '3'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF018CFF),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                '继续学习',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 课程列表
  List<Widget> _buildLessonList() {
    return _mockLessonList.map((item) {
      return _LessonClassCard(
        classInfo: item,
        onToggle: () {
          setState(() {
            item['isClose'] = !item['isClose'];
          });
        },
        onLessonTap: _goLookCourse,
        onHomeworkTap: _goAnswer,
      );
    }).toList();
  }

  int _calculateProgress(int completed, int total) {
    if (total == 0) return 0;
    return ((completed / total) * 100).round();
  }

  void _goLookCourse(String lessonId, String teachingType) {
    if (teachingType == '3') {
      // 录播
      context.push(AppRoutes.videoIndex, extra: {
        'lesson_id': lessonId,
      });
    } else if (teachingType == '1') {
      // 直播
      context.push(AppRoutes.liveIndex, extra: {
        'lesson_id': lessonId,
      });
    }
  }

  void _goAnswer(Map<String, dynamic> lesson, Map<String, dynamic> btn) {
    context.push(AppRoutes.makeQuestion, extra: {
      'paper_version_id': btn['paper_version_id'],
      'evaluation_type_id': btn['id'],
      'lesson_id': lesson['lesson_id'],
    });
  }
}

/// 教师信息项
class _TeacherItem extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const _TeacherItem({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage: teacher['avatar'] != null && teacher['avatar'].isNotEmpty
              ? NetworkImage(teacher['avatar'])
              : null,
          child: teacher['avatar'] == null || teacher['avatar'].isEmpty
              ? Icon(Icons.person, size: 20.sp)
              : null,
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
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 班级课程卡片
class _LessonClassCard extends StatelessWidget {
  final Map<String, dynamic> classInfo;
  final VoidCallback onToggle;
  final Function(String, String) onLessonTap;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onHomeworkTap;

  const _LessonClassCard({
    required this.classInfo,
    required this.onToggle,
    required this.onLessonTap,
    required this.onHomeworkTap,
  });

  @override
  Widget build(BuildContext context) {
    final isClose = classInfo['isClose'] ?? false;
    final progress = _calculateProgress(
      classInfo['lesson_attendance_num'],
      classInfo['lesson_num'],
    );

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildHeader(isClose, progress),
          if (!isClose) _buildLessonList(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isClose, int progress) {
    return GestureDetector(
      onTap: onToggle,
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
                    classInfo['teaching_type_name'] ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF018CFF),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    classInfo['name'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF262629),
                    ),
                  ),
                ),
                Text(
                  '(${classInfo['lesson_attendance_num'] ?? 0}/${classInfo['lesson_num'] ?? 0})',
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
            if (classInfo['address'] != null && classInfo['address'].isNotEmpty) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14.sp, color: const Color(0xFF999999)),
                  SizedBox(width: 4.w),
                  Text(
                    classInfo['address'],
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
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF018CFF)),
                      minHeight: 4.h,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${classInfo['lesson_attendance_num'] ?? 0}/${classInfo['lesson_num'] ?? 0}',
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

  Widget _buildLessonList() {
    final lessons = classInfo['lesson'] as List? ?? [];

    return Column(
      children: lessons.asMap().entries.map((entry) {
        final index = entry.key;
        final lesson = entry.value;
        return _LessonItem(
          lesson: lesson,
          index: index,
          teachingType: classInfo['teaching_type'],
          onTap: onLessonTap,
          onHomeworkTap: onHomeworkTap,
        );
      }).toList(),
    );
  }

  int _calculateProgress(int completed, int total) {
    if (total == 0) return 0;
    return ((completed / total) * 100).round();
  }
}

/// 课程项
class _LessonItem extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final int index;
  final String teachingType;
  final Function(String, String) onTap;
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
            onTap: () => widget.onTap(widget.lesson['lesson_id'], widget.teachingType),
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
          Row(
            children: [
              if (widget.teachingType == '1') ...[
                Icon(
                  widget.lesson['lesson_status'] == '3' ? Icons.play_circle : Icons.videocam,
                  size: 14.sp,
                  color: const Color(0xFF999999),
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.lesson['lesson_status'] == '3' ? '回放' : '直播',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Text(
                  widget.lesson['date'] ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              ),
              Text(
                isFinished ? '已学完' : '未学习',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isFinished ? const Color(0xFF999999) : const Color(0xFF018CFF),
                ),
              ),
            ],
          ),
          if (widget.lesson['evaluation_type_top'] != null &&
              widget.lesson['evaluation_type_top'].isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildHomeworkButtons(),
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
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF999999),
          ),
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
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF018CFF),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHomeworkButtons() {
    final buttons = widget.lesson['evaluation_type_top'] as List;

    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: buttons.map<Widget>((btn) {
        return GestureDetector(
          onTap: () => widget.onHomeworkTap(widget.lesson, btn),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.assignment, size: 14.sp, color: const Color(0xFF018CFF)),
                SizedBox(width: 4.w),
                Text(
                  btn['name'] ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF018CFF),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
