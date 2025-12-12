import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../home/services/chapter_service.dart';

/// 章节练习列表页面
/// 对应小程序: src/modules/jintiku/pages/chapterExercise/index.vue
class ChapterListPage extends ConsumerStatefulWidget {
  const ChapterListPage({super.key});

  @override
  ConsumerState<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends ConsumerState<ChapterListPage> {
  List<Map<String, dynamic>> _chapters = [];
  bool _isLoading = true;
  final Set<String> _expandedChapters = {};
  
  // ✅ 从路由参数获取
  String? _professionalId;
  String? _goodsId;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    // ✅ 延迟获取路由参数，确保 context 已初始化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractRouteParams();
      _loadChapterData();
    });
  }
  
  /// 提取路由参数
  /// 对应小程序: onLoad(e) Line 45-49
  void _extractRouteParams() {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (extra != null) {
      _professionalId = extra['professional_id'] as String?;
      _goodsId = extra['goods_id'] as String?;
      _total = extra['total'] as int? ?? 0;
      
      print('📚 [ChapterListPage] 路由参数: professionalId=$_professionalId, goodsId=$_goodsId, total=$_total');
    } else {
      print('⚠️ [ChapterListPage] 未接收到路由参数');
    }
  }

  /// 加载章节数据
  /// 对应小程序: getList() + chapterpackageTree API (Line 68-93)
  Future<void> _loadChapterData() async {
    if (_professionalId == null || _goodsId == null) {
      print('❌ [ChapterListPage] 缺少必要参数: professionalId=$_professionalId, goodsId=$_goodsId');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    
    print('🔍 [ChapterListPage] 开始加载章节数据...');
    
    try {
      // ✅ 调用 ChapterService.getChapterTree
      final service = ref.read(chapterServiceProvider);
      final response = await service.getChapterTree(
        professionalId: _professionalId!,
        goodsId: _goodsId!,
      );
      
      print('📦 [ChapterListPage] 获取到章节数据: ${response.length}个章节');
      
      setState(() {
        _chapters = response;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ [ChapterListPage] 加载章节数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('章节练习'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    // ✅ 如果有数据，计算总题数；否则使用传入的 total
    final totalQuestions = _chapters.isNotEmpty
        ? _chapters.fold<int>(
            0,
            (sum, chapter) => sum + int.parse(chapter['question_number']?.toString() ?? '0'),
          )
        : _total;

    return Column(
      children: [
        // 顶部提示
        Container(
          width: double.infinity,
          padding: AppSpacing.horizontalMd.add(AppSpacing.verticalMd),
          color: AppColors.card,
          child: Text(
            '本题库共有$totalQuestions道题',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // 章节列表
        Expanded(
          child: _chapters.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
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

  /// 空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无章节数据',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建章节项（支持递归多层结构）
  /// 对应小程序: tree-item.vue (递归组件)
  Widget _buildChapterItem(Map<String, dynamic> chapter, {int level = 1}) {
    final chapterId = chapter['id']?.toString() ?? '';
    final isExpanded = _expandedChapters.contains(chapterId);
    final children = chapter['child'] as List?;
    final hasChildren = children != null && children.isNotEmpty;
    final questionNum = chapter['question_number']?.toString() ?? '0';
    final doQuestionNum = chapter['do_question_num']?.toString() ?? '0';
    final correctRate = _calculateCorrectRate(chapter);
    final sectionType = chapter['section_type']?.toString();
    
    // ✅ section_type == '2' 表示知识点（叶子节点），直接显示为子章节样式
    if (sectionType == '2') {
      return _buildLeafChapterItem(chapter, level: level);
    }
    
    // ✅ 如果没有子节点，也使用叶子节点样式（防止崩溃）
    if (!hasChildren) {
      return _buildLeafChapterItem(chapter, level: level);
    }

    return Column(
      children: [
        // 章节标题
        InkWell(
          onTap: () {
            // ✅ 小程序逻辑：headClick(item)
            // level < 3: 展开收起
            // level >= 3: 跳转做题
            if (level < 3) {
              // 展开/收起
              setState(() {
                if (isExpanded) {
                  _expandedChapters.remove(chapterId);
                } else {
                  _expandedChapters.add(chapterId);
                }
              });
            } else {
              // 跳转做题（层级>=3）
              _startPractice(chapter);
            }
          },
          child: Container(
            // ✅ 根据层级设置左边距，实现缩进效果
            padding: EdgeInsets.fromLTRB(
              AppSpacing.sm + (level - 1) * 20.w,
              8.h,
              AppSpacing.sm,
              8.h,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                // ✅ 展开/收起箭头（只有子节点时才显示）
                // ⚠️ 使用 GestureDetector 阻止事件冒泡（对应小程序 @click.stop）
                GestureDetector(
                  onTap: () {
                    // ✅ 箭头点击：只展开/收起，不管层级
                    setState(() {
                      if (isExpanded) {
                        _expandedChapters.remove(chapterId);
                      } else {
                        _expandedChapters.add(chapterId);
                      }
                    });
                  },
                  child: Container(
                    height: 24.h,
                    width: 28.w,
                    alignment: Alignment.center,
                    color: Colors.transparent,  // ⚠️ 必须设置，否则点击区域无效
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,  // 0.5 = 180度
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16.w,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
                // 章节名称
                Expanded(
                  child: Text(
                    chapter['sectionname']?.toString() ?? chapter['name']?.toString() ?? '未命名',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      // ✅ 根据层级调整字体大小
                      fontSize: level == 1 ? 14.sp : 13.sp,
                    ),
                  ),
                ),
                // 统计信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$doQuestionNum/$questionNum',
                      style: AppTextStyles.bodySmall,
                    ),
                    if (doQuestionNum != '0') ...[
                      SizedBox(height: 2.h),
                      Text(
                        '正确率$correctRate%',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        // ✅ 递归渲染子章节（支持多层嵌套）
        if (isExpanded && hasChildren)
          ...children!.cast<Map<String, dynamic>>().map(
            (child) => _buildChapterItem(child, level: level + 1),
          ),
      ],
    );
  }

  /// 构建叶子节点（知识点，section_type == '2'）
  /// 对应小程序: child-com.vue
  Widget _buildLeafChapterItem(Map<String, dynamic> chapter, {int level = 1}) {
    final questionNum = chapter['question_number']?.toString() ?? '0';
    final doQuestionNum = chapter['do_question_num']?.toString() ?? '0';
    final correctNum = chapter['correct_question_num']?.toString() ?? '0';
    final errorNum = chapter['error_question_num']?.toString() ?? '0';
    final notAnsweredNum = chapter['not_answered_question_num']?.toString() ?? '0';
    final isChecked = chapter['is_checked']?.toString() == '1';  // 上次练习标记

    return InkWell(
      onTap: () => _startPractice(chapter),
      child: Container(
        // ✅ 小程序：paddingLeft: 32 + (res.leval - 1) * 40
        // 32rpx ÷ 2 = 16.w, 40rpx ÷ 2 = 20.w
        padding: EdgeInsets.fromLTRB(
          16.w + (level - 1) * 20.w,
          0,
          16.w,
          0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 标题行（小程序 content-head）
              Row(
                children: [
                  // ✅ 圆点标识（小程序 circle）
                  // ⚠️ Flutter不支持负数margin，使用Transform.translate替代
                  Transform.translate(
                    offset: Offset(-4.w, 0),  // 小程序margin-left: -8rpx ÷ 2 = -4
                    child: Container(
                      width: 10.w,  // 小程序20rpx ÷ 2 = 10
                      height: 10.w,
                      margin: EdgeInsets.only(right: 15.w),  // 小程序30rpx ÷ 2 = 15
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // ✅ 章节名称（小程序 unit）
                  Expanded(
                    child: Text(
                      chapter['sectionname']?.toString() ?? chapter['name']?.toString() ?? '未命名',
                      style: TextStyle(
                        fontSize: 13.sp,  // 小程序26rpx ÷ 2 = 13
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  // ✅ 上次练习标记（小程序 pre-picter）
                  if (isChecked)
                    Text(
                      '上次练习',
                      style: TextStyle(
                        fontSize: 12.sp,  // 小程序24rpx ÷ 2 = 12
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10.h),  // 小程序paddingTop: 20rpx ÷ 2 = 10
              // ✅ 统计信息（小程序 content-static）
              Container(
                height: 47.h,  // 小程序94rpx ÷ 2 = 47
                padding: EdgeInsets.only(
                  left: 20.w,   // 小程序40rpx ÷ 2 = 20
                  right: 40.w,  // 小程序80rpx ÷ 2 = 40
                  top: 10.h,    // 小程序20rpx ÷ 2 = 10
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.primary,
                      width: 1,  // 小程序2rpx ÷ 2 = 1
                      style: BorderStyle.solid,  // 小程序是dashed，但这里用solid
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '做对 $correctNum',
                      style: TextStyle(
                        fontSize: 12.sp,  // 小程序24rpx ÷ 2 = 12
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      '做错 $errorNum',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      '未答 $notAnsweredNum',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  /// 对应小程序: tree-head.vue goDetail() 和 child-com.vue goDetail()
  void _startPractice(Map<String, dynamic> chapter) {
    final questionNum = chapter['question_number']?.toString() ?? '0';
    final notAnsweredNum = chapter['not_answered_question_num']?.toString() ?? '0';
    
    // ✅ 1. 检查是否有题目
    if (questionNum == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无题目！')),
      );
      return;
    }
    
    // ✅ 小程序逻辑：type固定为'10'（对应章节练习类型）
    // 参考：index.vue Line 69-70
    final type = '10';
    
    // ✅ 2. 如果已做完所有题，跳转查看解析页
    if (notAnsweredNum == '0') {
      print('📝 [ChapterListPage] 跳转查看解析页面：knowledge_id=${chapter['id']}, chapter_id=${chapter['sectionprent']}');
      
      context.push(AppRoutes.makeQuestion, extra: {
        'knowledge_id': chapter['id'],                    // ✅ 当前节点ID
        'type': type,                                      // ✅ 固定为'10'
        'chapter_id': chapter['sectionprent'],            // ✅ 父节点ID
        'teaching_system_package_id': chapter['teaching_system_package_id'],
        'professional_id': chapter['professional_id'] ?? _professionalId,
        'goods_id': _goodsId,
        'total': _total.toString(),
        'is_look_analysis': true,  // 标记为查看解析模式
      });
      return;
    }
    
    // ✅ 3. 正常做题 - 传递完整参数
    print('📝 [ChapterListPage] 跳转做题页面：');
    print('   - knowledge_id: ${chapter['id']}');
    print('   - type: $type');
    print('   - chapter_id: ${chapter['sectionprent']}');
    print('   - teaching_system_package_id: ${chapter['teaching_system_package_id']}');
    
    context.push(AppRoutes.makeQuestion, extra: {
      'knowledge_id': chapter['id'],                    // ✅ 当前节点ID（小程序：item.id）
      'type': type,                                      // ✅ 固定为'10'（小程序：this.type）
      'chapter_id': chapter['sectionprent'],            // ✅ 父节点ID（小程序：item.sectionprent）
      'chapter_name': chapter['sectionname'] ?? chapter['name'],
      'teaching_system_package_id': chapter['teaching_system_package_id'],
      'professional_id': chapter['professional_id'] ?? _professionalId,
      'goods_id': _goodsId,
      'total': _total.toString(),
      'is_next_chapter': '2',  // 对应小程序的 isnextChapter
    });
  }
  
  /// 计算正确率
  /// 对应小程序: addCorrectRate 方法 Line 58-66
  String _calculateCorrectRate(Map<String, dynamic> chapter) {
    final doNum = int.parse(chapter['do_question_num']?.toString() ?? '0');
    final correctNum = int.parse(chapter['correct_question_num']?.toString() ?? '0');
    if (doNum > 0) {
      return ((correctNum / doNum) * 100).toStringAsFixed(1);
    }
    return '0.0';
  }
}
