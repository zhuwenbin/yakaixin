import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
// import 已移除 - 现在使用API调用，MockInterceptor会自动处理Mock数据

/// 收藏页面
/// 对应小程序: src/modules/jintiku/pages/collect/index.vue
class CollectPage extends ConsumerStatefulWidget {
  const CollectPage({super.key});

  @override
  ConsumerState<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends ConsumerState<CollectPage> {
  String _selectedQuestionType = '';
  String _selectedTimeRange = '全部';

  // 从 Mock数据文件获取数据
  List<Map<String, dynamic>> get _collectQuestions => [];
  // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
  // TODO: 使用 Dio 调用 API，MockInterceptor 会自动返回 Mock 数据
  // TODO: 从收藏题目 API 中解析数据

  @override
  Widget build(BuildContext context) {
    final filteredQuestions = _getFilteredQuestions();
    final groupedQuestions = _groupQuestionsByType(filteredQuestions);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('收藏'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 筛选栏
          _buildFilterBar(),
          // 收藏列表
          Expanded(
            child: filteredQuestions.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: EdgeInsets.all(12.w),
                    children: groupedQuestions.entries.map((entry) {
                      return _buildQuestionTypeGroup(
                        entry.key,
                        entry.value,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选栏
  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.white,
      child: Row(
        children: [
          // 题型筛选
          Expanded(
            child: _buildFilterButton(
              label: _selectedQuestionType.isEmpty ? '题型' : _selectedQuestionType,
              onTap: () => _showQuestionTypeDialog(),
            ),
          ),
          SizedBox(width: 12.w),
          // 时间筛选
          Expanded(
            child: _buildFilterButton(
              label: _selectedTimeRange,
              onTap: () => _showTimeRangeDialog(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选按钮
  Widget _buildFilterButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16.sp,
              color: Color(0xFF666666),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建题型分组
  Widget _buildQuestionTypeGroup(String typeName, List<Map<String, dynamic>> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 题型标题
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(
            '$typeName题型',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        // 题目列表
        ...questions.map((question) => _buildQuestionItem(question)),
      ],
    );
  }

  /// 构建单个收藏题目
  Widget _buildQuestionItem(Map<String, dynamic> question) {
    return GestureDetector(
      onTap: () {
        // 跳转到题目详情
        context.push(AppRoutes.makeQuestion, extra: {
          'question_id': question['id'],
          'from': 'collect',
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题目内容
            Text(
              question['question'] as String,
              style: TextStyle(
                fontSize: 15.sp,
                color: Color(0xFF333333),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            // 底部信息
            Row(
              children: [
                // 时间
                Text(
                  (question['created_at'] as String).substring(0, 16),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF999999),
                  ),
                ),
                Spacer(),
                // 难易度
                Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Icon(
                        Icons.star,
                        size: 14.sp,
                        color: index < (question['level'] as int)
                            ? Color(0xFFFFA726)
                            : Color(0xFFE0E0E0),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: Color(0xFFE0E0E0),
          ),
          SizedBox(height: 16.h),
          Text(
            '没有任何收藏呢~',
            style: TextStyle(
              fontSize: 15.sp,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示题型筛选弹窗
  void _showQuestionTypeDialog() {
    final questionTypes = ['全部', '单选', '多选', '判断'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    '选择题型',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Divider(height: 1),
                // 选项列表
                ...questionTypes.map((type) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedQuestionType = type == '全部' ? '' : type;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Color(0xFF333333),
                            ),
                          ),
                          if ((type == '全部' && _selectedQuestionType.isEmpty) ||
                              type == _selectedQuestionType)
                            Icon(
                              Icons.check,
                              size: 20.sp,
                              color: Color(0xFF4A90E2),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示时间范围筛选弹窗
  void _showTimeRangeDialog() {
    final timeRanges = ['全部', '近3天', '一周内', '一月内', '自定义'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    '选择时间范围',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Divider(height: 1),
                // 选项列表
                ...timeRanges.map((range) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTimeRange = range;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            range,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Color(0xFF333333),
                            ),
                          ),
                          if (range == _selectedTimeRange)
                            Icon(
                              Icons.check,
                              size: 20.sp,
                              color: Color(0xFF4A90E2),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 获取过滤后的题目列表
  List<Map<String, dynamic>> _getFilteredQuestions() {
    var questions = _collectQuestions;

    // 按题型筛选
    if (_selectedQuestionType.isNotEmpty) {
      questions = questions.where((q) => q['type_name'] == _selectedQuestionType).toList();
    }

    // TODO: 按时间范围筛选

    return questions;
  }

  /// 按题型分组
  Map<String, List<Map<String, dynamic>>> _groupQuestionsByType(
    List<Map<String, dynamic>> questions,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (var question in questions) {
      final typeName = question['type_name'] as String;
      if (!grouped.containsKey(typeName)) {
        grouped[typeName] = [];
      }
      grouped[typeName]!.add(question);
    }

    return grouped;
  }
}
