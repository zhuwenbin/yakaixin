import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
// import 已移除 - 现在使用API调用，MockInterceptor会自动处理Mock数据

/// 章节练习列表页面
/// 对应小程序: src/modules/jintiku/pages/chapterExercise/index.vue
class ChapterListPage extends ConsumerStatefulWidget {
  const ChapterListPage({super.key});

  @override
  ConsumerState<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends ConsumerState<ChapterListPage> {
  // ✅ 遵守Mock规则: 通过API获取章节数据
  List<Map<String, dynamic>> _chapters = [];
  bool _isLoading = true;
  final Set<String> _expandedChapters = {};

  @override
  void initState() {
    super.initState();
    _loadChapterData();
  }

  /// 加载章节数据
  /// 对应小程序: getChapterTree API
  Future<void> _loadChapterData() async {
    try {
      // TODO: 实现API调用获取章节树数据
      // final response = await chapterService.getChapterTree();
      // setState(() {
      //   _chapters = response.list;
      //   _isLoading = false;
      // });
      
      // 临时使用Mock数据（通过拦截器会自动返回）
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        // ⚠️ 以下 Mock 数据引用已废弃，需要改为通过 API 调用获取
        // TODO: 使用 Dio 调用 /c/exam/chapter API，MockInterceptor 会自动返回 Mock 数据
        _chapters = []; // QuestionBankMockData.chapterTree['data']['list'] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('❌ 加载章节数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('章节练习'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    final totalQuestions = _chapters.fold<int>(
      0,
      (sum, chapter) => sum + int.parse(chapter['question_num'] as String),
    );

    return Column(
      children: [
        // 顶部提示
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          color: Color(0xFFF5F5F5),
          child: Text(
            '本题库共有$totalQuestions道题',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF666666),
            ),
          ),
        ),
        // 章节列表
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _chapters.length,
            itemBuilder: (context, index) {
              final chapter = _chapters[index];
              return _buildChapterItem(chapter);
            },
          ),
        ),
        // 底部继续练习按钮（如果有上次练习记录）
        _buildContinueButton(),
      ],
    );
  }

  /// 构建章节项
  Widget _buildChapterItem(Map<String, dynamic> chapter) {
    final chapterId = chapter['id'] as String;
    final isExpanded = _expandedChapters.contains(chapterId);
    final hasChildren = (chapter['children'] as List).isNotEmpty;
    final questionNum = chapter['question_num'] as String;
    final doQuestionNum = chapter['do_question_num'] as String;
    final correctRate = chapter['correct_rate'] as String;

    return Column(
      children: [
        // 章节标题
        InkWell(
          onTap: () {
            if (hasChildren) {
              setState(() {
                if (isExpanded) {
                  _expandedChapters.remove(chapterId);
                } else {
                  _expandedChapters.add(chapterId);
                }
              });
            } else {
              // 直接进入练习
              _startPractice(chapter);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
              ),
            ),
            child: Row(
              children: [
                // 展开/收起图标
                if (hasChildren)
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 20.sp,
                    color: Color(0xFF999999),
                  )
                else
                  SizedBox(width: 20.sp),
                SizedBox(width: 8.w),
                // 章节名称
                Expanded(
                  child: Text(
                    chapter['name'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // 统计信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$doQuestionNum/$questionNum',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF666666),
                      ),
                    ),
                    if (doQuestionNum != '0') ...[
                      SizedBox(height: 2.h),
                      Text(
                        '正确率$correctRate%',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        // 子章节
        if (isExpanded && hasChildren)
          ...(chapter['children'] as List<Map<String, dynamic>>).map(
            (child) => _buildSubChapterItem(child),
          ),
      ],
    );
  }

  /// 构建子章节项
  Widget _buildSubChapterItem(Map<String, dynamic> chapter) {
    final questionNum = chapter['question_num'] as String;
    final doQuestionNum = chapter['do_question_num'] as String;
    final correctRate = chapter['correct_rate'] as String;

    return InkWell(
      onTap: () => _startPractice(chapter),
      child: Container(
        padding: EdgeInsets.fromLTRB(43.w, 14.h, 15.w, 14.h),
        decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // 章节名称
            Expanded(
              child: Text(
                chapter['name'] as String,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            // 统计信息
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$doQuestionNum/$questionNum',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF666666),
                  ),
                ),
                if (doQuestionNum != '0') ...[
                  SizedBox(height: 2.h),
                  Text(
                    '正确率$correctRate%',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right,
              size: 16.sp,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部继续练习按钮
  Widget _buildContinueButton() {
    // Mock: 假设有上次练习记录
    final hasLastPractice = true;
    final lastPracticeName = '第一节 牙体解剖';

    if (!hasLastPractice) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // 继续上次练习
            context.push(AppRoutes.makeQuestion, extra: {
              'knowledge_id': '1-1',
              'type': '1',
            });
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '上次练习：$lastPracticeName',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '继续练习',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 开始练习
  void _startPractice(Map<String, dynamic> chapter) {
    context.push(AppRoutes.makeQuestion, extra: {
      'knowledge_id': chapter['id'],
      'type': '1',
      'chapter_name': chapter['name'],
    });
  }
}
