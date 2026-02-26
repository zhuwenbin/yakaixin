import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../../../core/widgets/common_state_widget.dart';
import '../../wrong_book/providers/wrong_book_provider.dart';
import '../../wrong_book/models/wrong_question_model.dart';
import '../../collection/widgets/time_range_selector_dialog.dart';
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
                    _buildQuestionList(state.allQuestions), // 全部
                    _buildQuestionList(state.markedQuestions), // 标记
                    _buildQuestionList(state.fallibleQuestions), // 易错
                  ],
                ),
              ),
              // 底部按钮
              if (_getCurrentQuestions(state).isNotEmpty)
                _buildBottomButton(state),
            ],
          ),

          // ✅ 时间选择器（使用 Dialog，与专业选择动画一致）
          // 注意：不再使用 if 条件显示，而是通过 showDialog 控制
        ],
      ),
    );
  }

  /// 构建Tab栏和筛选按钮
  /// 对应小程序: wrongQuestionBook/index.vue .header_tab
  /// 小程序样式：
  /// - font-size: 32rpx (16sp)
  /// - 默认颜色: #262629
  /// - 激活颜色: #387dfc
  /// - font-weight: 400 (激活时也是400，不加粗)
  /// - tab 间距: margin-right: 60rpx (30px)
  /// - 没有底部指示器
  Widget _buildTabBar() {
    final currentIndex = _tabController.index;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ), // ✅ 对应小程序 padding: 16rpx 24rpx
      child: Row(
        children: [
          // ✅ 自定义 Tab 栏（对应小程序 .left_tab）
          Expanded(
            child: Row(
              children: [
                _buildCustomTab(0, '全部', currentIndex),
                SizedBox(width: 30.w), // ✅ 对应小程序 margin-right: 60rpx
                _buildCustomTab(1, '标记', currentIndex),
                SizedBox(width: 30.w),
                _buildCustomTab(2, '易错', currentIndex),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // ✅ 筛选按钮（对应小程序 .right_screen）
          GestureDetector(
            onTap: () => _showTimeRangeSelector(context, ref),
            child: Row(
              children: [
                Text(
                  '筛选',
                  style: TextStyle(
                    fontSize: 14.sp, // ✅ 对应小程序 font-size: 28rpx (14sp)
                    color: const Color(0xFF03203D), // ✅ 对应小程序 color: #03203d
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.filter_list,
                  size: 12.sp, // ✅ 对应小程序 24rpx (12sp)
                  color: const Color(0xFF03203D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建自定义 Tab 项
  /// 对应小程序: .tab_name 和 .init
  Widget _buildCustomTab(int index, String text, int currentIndex) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp, // ✅ 对应小程序 font-size: 32rpx (16sp)
          fontWeight: FontWeight.normal, // ✅ 对应小程序 font-weight: 400
          color: isActive
              ? const Color(0xFF387DFC) // ✅ 对应小程序 .init { color: #387dfc }
              : const Color(0xFF262629), // ✅ 对应小程序默认颜色 #262629
        ),
      ),
    );
  }

  /// 构建错题列表
  Widget _buildQuestionList(List<WrongQuestionModel> questions) {
    if (questions.isEmpty) {
      // ✅ 使用统一的空状态组件（对应小程序图片和样式）
      return CommonStateWidget.noWrongQuestion();
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
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
                if (isMark &&
                    question.tags != null &&
                    question.tags!.isNotEmpty)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: question.tags!.split(',').map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
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
                if (isMark &&
                    question.tags != null &&
                    question.tags!.isNotEmpty)
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
                    Text('难易度：', style: AppTextStyles.labelMedium),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
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
                  if (isFallibility && isMark) SizedBox(width: 4.w),
                  // 标记图标
                  if (isMark)
                    Icon(Icons.bookmark, size: 20.sp, color: AppColors.warning),
                ],
              ),
            ),
          ],
        ),
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
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
            elevation: 0,
          ),
          child: Text('错题复查', style: AppTextStyles.buttonMedium),
        ),
      ),
    );
  }

  /// 跳转到详情页（与小程序一致：只传当前一道题，详情页只显示该题）
  /// 对应小程序 index.vue goDetail(data, type) type 为假时 listInfo: [{ question_list: [data] }]
  void _goToDetail(WrongQuestionModel question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WrongBookDetailPage(
          questions: [question],
          initialIndex: 0,
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

  /// 显示时间范围选择器
  /// 从底部弹出，使用与专业选择相同的动画参数
  void _showTimeRangeSelector(BuildContext context, WidgetRef ref) async {
    final state = ref.read(wrongBookNotifierProvider);

    final result = await showTimeRangeSelectorDialog(
      context,
      selectedRange: state.timeRange,
      selectedName: state.timeRangeName ?? '时间',
      startDate: state.startDate,
      endDate: state.endDate,
    );

    if (result != null) {
      ref
          .read(wrongBookNotifierProvider.notifier)
          .updateFilter(
            timeRange: result['range'] as String,
            timeRangeName: result['name'] as String,
            startDate: result['startDate'] as String?,
            endDate: result['endDate'] as String?,
          );
    }
  }
}
