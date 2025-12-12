import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../wrong_book/providers/wrong_book_provider.dart';
import '../../wrong_book/models/wrong_question_model.dart';
import '../../collection/widgets/time_range_selector.dart';
import 'wrong_book_detail_page.dart';

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
  bool _showTimeSelector = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    
    // 初始加载数据
    Future.microtask(() {
      ref.read(wrongBookNotifierProvider.notifier).loadWrongQuestions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wrongBookNotifierProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('错题本'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Tab栏 + 筛选按钮
              _buildTabBar(),
              // 错题列表
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildQuestionList(state.allQuestions),      // 全部
                    _buildQuestionList(state.markedQuestions),   // 标记
                    _buildQuestionList(state.fallibleQuestions), // 易错
                  ],
                ),
              ),
              // 底部按钮
              if (_getCurrentQuestions(state).isNotEmpty) _buildBottomButton(state),
            ],
          ),
          
          // 时间选择器
          if (_showTimeSelector)
            TimeRangeSelector(
              selectedRange: state.timeRange,
              selectedName: state.timeRangeName ?? '时间',
              startDate: state.startDate,
              endDate: state.endDate,
              onClose: () => setState(() => _showTimeSelector = false),
              onConfirm: (range, name, startDate, endDate) {
                setState(() => _showTimeSelector = false);
                ref.read(wrongBookNotifierProvider.notifier).updateFilter(
                  timeRange: range,
                  timeRangeName: name,
                  startDate: startDate,
                  endDate: endDate,
                );
              },
            ),
        ],
      ),
    );
  }

  /// 构建Tab栏和筛选按钮
  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      padding: AppSpacing.horizontalMd.add(EdgeInsets.symmetric(vertical: 8.h)),
      child: Row(
        children: [
          // Tab栏
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTextStyles.bodyMedium,
              indicatorColor: AppColors.primary,
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
            onTap: () => setState(() => _showTimeSelector = true),
            child: Row(
              children: [
                Text(
                  '筛选',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.filter_list,
                  size: 18.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错题列表
  Widget _buildQuestionList(List<WrongQuestionModel> questions) {
    if (questions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(wrongBookNotifierProvider.notifier).loadWrongQuestions();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(12.w),
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return _buildNoMore();
          }
          return _buildQuestionItem(questions[index]);
        },
      ),
    );
  }

  /// 构建单个错题项
  Widget _buildQuestionItem(WrongQuestionModel question) {
    // ✅ 使用 SafeTypeConverter 安全转换类型
    final isMark = SafeTypeConverter.toInt(question.isMark) == 1;
    final isFallibility = SafeTypeConverter.toInt(question.isFallibility) == 1;
    final level = SafeTypeConverter.toInt(question.level, defaultValue: 1);
    
    // ✅ 获取题干内容 - 参照小程序，显示 stemList[0].content
    String questionText = '';
    if (question.thematicStem != null && question.thematicStem!.isNotEmpty) {
      questionText = _stripHtml(question.thematicStem!);
    } else if (question.stemList != null && question.stemList!.isNotEmpty) {
      questionText = _stripHtml(question.stemList!.first.content ?? '');
    }
    
    // ✅ 显示章节名称 - 不显示tags字段
    final chapterName = question.chapterIdsName ?? '';
    
    // ✅ 时间显示 - 从 created_at_val 获取，只显示前16位
    final timeText = question.createdAtVal ?? question.createdAt ?? '';
    final displayTime = timeText.isNotEmpty && timeText.length >= 16 
        ? timeText.substring(0, 16) 
        : timeText;

    return GestureDetector(
      onTap: () {
        // 跳转到错题详情页
        _goToDetail(question);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusSm,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 题目内容 - 去除HTML标签
                Text(
                  questionText,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                // 章节标签 (不显示tags字段)
                if (chapterName.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppRadius.radiusXs,
                    ),
                    child: Text(
                      chapterName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (chapterName.isNotEmpty) SizedBox(height: 8.h),
                // ✅ 显示标记标签 - 对应小程序 Line 115-122
                if (isMark && question.tags != null && question.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: question.tags!.split(',').map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: AppRadius.radiusXs,
                        ),
                        child: Text(
                          tag.trim(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (isMark && question.tags != null && question.tags!.isNotEmpty)
                  SizedBox(height: 8.h),
                // 时间 - 显示YYYY-MM-DD HH:mm
                if (displayTime.isNotEmpty)
                  Text(
                    displayTime,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                SizedBox(height: 8.h),
                // 难易度
                Row(
                  children: [
                    Text(
                      '难易度：',
                      style: AppTextStyles.labelMedium,
                    ),
                    ...List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.star,
                          size: 14.sp,
                          color: index < level
                              ? AppColors.warning
                              : AppColors.border,
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
                  if (isFallibility)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: AppRadius.radiusXs,
                      ),
                      child: Text(
                        '易错',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  if (isFallibility && isMark)
                    SizedBox(width: 4.w),
                  // 标记图标
                  if (isMark)
                    Icon(
                      Icons.bookmark,
                      size: 20.sp,
                      color: AppColors.warning,
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
            color: AppColors.border,
          ),
          SizedBox(height: AppSpacing.mdV),
          Text(
            '暂无错题~',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  /// 去除HTML标签
  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .trim();
  }

  /// 没有更多
  Widget _buildNoMore() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: Text(
        '没有更多啦~',
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12.sp,
          color: const Color(0xFFCCCCCC),
        ),
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomButton(WrongBookState state) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            // 开始错题复查 - 跳转到详情页
            final questions = _getCurrentQuestions(state);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WrongBookDetailPage(
                    questions: questions,
                    initialIndex: 0,
                    isReview: true,
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radiusSm,
            ),
            elevation: 0,
          ),
          child: Text(
            '错题复查',
            style: AppTextStyles.buttonMedium,
          ),
        ),
      ),
    );
  }

  /// 跳转到详情页
  void _goToDetail(WrongQuestionModel question) {
    final state = ref.read(wrongBookNotifierProvider);
    final allQuestions = _getCurrentQuestions(state);
    final index = allQuestions.indexWhere((q) => q.id == question.id);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WrongBookDetailPage(
          questions: allQuestions,
          initialIndex: index >= 0 ? index : 0,
          isReview: false,
        ),
      ),
    );
  }

  /// 获取当前Tab的题目列表
  List<WrongQuestionModel> _getCurrentQuestions(WrongBookState state) {
    switch (_tabController.index) {
      case 1:
        return state.markedQuestions;
      case 2:
        return state.fallibleQuestions;
      default:
        return state.allQuestions;
    }
  }
}
