import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/mock/data/question_bank_mock_data.dart';

/// 错题本页面
/// 对应小程序: src/modules/jintiku/pages/wrongQuestionBook/index.vue
class WrongBookPage extends ConsumerStatefulWidget {
  const WrongBookPage({super.key});

  @override
  ConsumerState<WrongBookPage> createState() => _WrongBookPageState();
}

class _WrongBookPageState extends ConsumerState<WrongBookPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // 从 Mock数据文件获取数据
  List<Map<String, dynamic>> get _wrongQuestions => [];
  // TODO: 从 QuestionBankMockData.wrongBookIndex 中解析数据

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('错题本'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab栏 + 筛选按钮
          _buildTabBar(),
          // 错题列表
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuestionList(_wrongQuestions), // 全部
                _buildQuestionList(_wrongQuestions.where((q) => q['is_mark'] == true).toList()), // 标记
                _buildQuestionList(_wrongQuestions.where((q) => q['is_fallibility'] == true).toList()), // 易错
              ],
            ),
          ),
          // 底部按钮
          if (_getFilteredQuestions().isNotEmpty) _buildBottomButton(),
        ],
      ),
    );
  }

  /// 构建Tab栏和筛选按钮
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Tab栏
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF4A90E2),
              unselectedLabelColor: Color(0xFF666666),
              labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
              indicatorColor: Color(0xFF4A90E2),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: '全部'),
                Tab(text: '标记'),
                Tab(text: '易错'),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // 筛选按钮
          GestureDetector(
            onTap: () {
              // TODO: 显示筛选弹窗
              _showFilterDialog();
            },
            child: Row(
              children: [
                Text(
                  '筛选',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF666666),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.filter_list,
                  size: 18.sp,
                  color: Color(0xFF666666),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错题列表
  Widget _buildQuestionList(List<Map<String, dynamic>> questions) {
    if (questions.isEmpty) {
      return _buildEmptyState();
    }

    // 按题型分组
    final Map<String, List<Map<String, dynamic>>> groupedQuestions = {};
    for (var question in questions) {
      final type = question['type'] == '1' ? '单选' : (question['type'] == '2' ? '多选' : '判断');
      if (!groupedQuestions.containsKey(type)) {
        groupedQuestions[type] = [];
      }
      groupedQuestions[type]!.add(question);
    }

    return ListView(
      padding: EdgeInsets.only(bottom: 20.h),
      children: groupedQuestions.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题型标题
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              margin: EdgeInsets.only(top: 12.h),
              color: Color(0xFFF5F5F5),
              child: Text(
                '${entry.key}题 共${entry.value.length}道',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // 题目列表
            ...entry.value.map((question) => _buildQuestionItem(question)),
          ],
        );
      }).toList(),
    );
  }

  /// 构建单个错题项
  Widget _buildQuestionItem(Map<String, dynamic> question) {
    return GestureDetector(
      onTap: () {
        // 跳转到做题页面
        context.push(AppRoutes.makeQuestion, extra: {
          'question_id': question['id'],
          'from': 'wrong_book',
        });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            Column(
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
                SizedBox(height: 10.h),
                // 章节标签
                if (question['chapter_name'] != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFE3EBFF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      question['chapter_name'] as String,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Color(0xFF2E68FF),
                      ),
                    ),
                  ),
                SizedBox(height: 8.h),
                // 时间
                Text(
                  question['created_at'] as String,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF999999),
                  ),
                ),
                SizedBox(height: 8.h),
                // 标签
                if ((question['tags'] as List).isNotEmpty)
                  Wrap(
                    spacing: 8.w,
                    children: (question['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 8.h),
                // 难易度
                Row(
                  children: [
                    Text(
                      '难易度：',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF999999),
                      ),
                    ),
                    ...List.generate(5, (index) {
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
                  ],
                ),
              ],
            ),
            // 右上角标记图标
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  // 易错标记
                  if (question['is_fallibility'] == true)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '易错',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xFFE74C3C),
                        ),
                      ),
                    ),
                  if (question['is_fallibility'] == true && question['is_mark'] == true)
                    SizedBox(width: 4.w),
                  // 标记图标
                  if (question['is_mark'] == true)
                    Icon(
                      Icons.bookmark,
                      size: 20.sp,
                      color: Color(0xFFFF9800),
                    ),
                ],
              ),
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
            Icons.check_circle_outline,
            size: 80.sp,
            color: Color(0xFFE0E0E0),
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无错题~',
            style: TextStyle(
              fontSize: 15.sp,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            // 开始错题复查
            context.push(AppRoutes.makeQuestion, extra: {
              'from': 'wrong_book',
              'mode': 'review',
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
            '错题复查',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 显示筛选弹窗
  void _showFilterDialog() {
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
                // 时间选项
                _buildFilterOption('最近一周'),
                _buildFilterOption('最近一月'),
                _buildFilterOption('最近三月'),
                _buildFilterOption('自定义时间'),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建筛选选项
  Widget _buildFilterOption(String label) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // TODO: 处理筛选逻辑
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  /// 获取当前Tab过滤后的题目
  List<Map<String, dynamic>> _getFilteredQuestions() {
    switch (_currentTabIndex) {
      case 1:
        return _wrongQuestions.where((q) => q['is_mark'] == true).toList();
      case 2:
        return _wrongQuestions.where((q) => q['is_fallibility'] == true).toList();
      default:
        return _wrongQuestions;
    }
  }
}
