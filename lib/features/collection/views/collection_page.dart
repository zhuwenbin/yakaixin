import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';
import 'package:yakaixin_app/core/theme/app_spacing.dart';
import '../models/collection_question_model.dart';
import '../providers/collection_provider.dart';
import '../widgets/question_type_selector.dart';
import '../widgets/time_range_selector.dart';
import '../widgets/collection_question_card.dart';
import 'collection_detail_page.dart';

/// 我的收藏页面
/// 对应小程序: collect/index.vue
class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showTypeSelector = false;
  bool _showTimeSelector = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // 初始加载
    Future.microtask(() {
      ref.read(collectionNotifierProvider.notifier).loadCollections(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(collectionNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(collectionNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('我的收藏'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 主内容区
          Column(
            children: [
              // 顶部筛选栏
              _buildFilterHeader(),
              
              // 收藏列表
              Expanded(
                child: _buildCollectionList(state),
              ),
            ],
          ),
          
          // 题型选择器
          if (_showTypeSelector)
            QuestionTypeSelector(
              selectedType: state.questionType ?? '',
              selectedName: state.questionTypeName ?? '',
              onClose: () => setState(() => _showTypeSelector = false),
              onConfirm: (type, name) {
                setState(() => _showTypeSelector = false);
                ref.read(collectionNotifierProvider.notifier).updateFilter(
                  questionType: type.isEmpty ? null : type,
                  questionTypeName: name.isEmpty ? null : name,
                );
              },
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
                ref.read(collectionNotifierProvider.notifier).updateFilter(
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

  /// 顶部筛选栏
  /// 对应小程序: Line 3-16
  Widget _buildFilterHeader() {
    final state = ref.watch(collectionNotifierProvider);
    
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Row(
          children: [
            // 题型筛选
            Expanded(
              child: _buildFilterButton(
                label: state.questionTypeName?.isNotEmpty == true 
                    ? state.questionTypeName! 
                    : '题型',
                onTap: () => setState(() => _showTypeSelector = true),
              ),
            ),
            
            // 时间筛选
            Expanded(
              child: _buildFilterButton(
                label: state.timeRangeName ?? '时间',
                onTap: () => setState(() => _showTimeSelector = true),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 16.sp,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 6.w),
            Image.network(
              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/169693015786889b916969301578688446_%E7%BC%96%E7%BB%84%402x.png',
              width: 8.w,
              height: 5.h,
              errorBuilder: (_, __, ___) => Icon(
                Icons.arrow_drop_down,
                size: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 收藏列表
  /// 对应小程序: Line 17-68
  Widget _buildCollectionList(CollectionState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildError(state.error!);
    }

    if (state.groupedQuestions.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(collectionNotifierProvider.notifier)
            .loadCollections(refresh: true);
      },
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 12.h,
          bottom: 12.h,
        ),
        children: [
          // 按题型分组显示
          ...state.groupedQuestions.entries.map((entry) {
            final group = entry.value;
            return _buildQuestionTypeGroup(group);
          }),
          
          // 加载更多提示
          if (state.isLoadingMore)
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          
          // 没有更多数据
          if (!state.hasMore && state.allQuestions.isNotEmpty)
            _buildNoMore(),
        ],
      ),
    );
  }

  /// 题型分组
  /// 对应小程序: Line 18-64
  Widget _buildQuestionTypeGroup(CollectionGroupModel group) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题型标题
          Text(
            '${group.typeName}题型',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF161F30),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // 该题型的题目列表
          ...group.questions.map((question) {
            return CollectionQuestionCard(
              question: question,
              onTap: () => _goToDetail(question),
            );
          }),
        ],
      ),
    );
  }

  /// 跳转到详情页
  /// 对应小程序: goDetail() Line 194-198
  void _goToDetail(CollectionQuestionModel question) {
    final state = ref.read(collectionNotifierProvider);
    
    // 找到当前问题在所有问题中的索引
    final allQuestions = state.allQuestions;
    final index = allQuestions.indexWhere((q) => q.id == question.id);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionDetailPage(
          questions: allQuestions,  // 传递所有问题
          initialIndex: index >= 0 ? index : 0,  // 传递初始索引
        ),
      ),
    );
  }

  /// 空状态
  /// 对应小程序: Line 67
  Widget _buildEmpty() {
    return Center(
      child: Text(
        '没有任何收藏呢～',
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12.sp,
          color: const Color(0xFFCCCCCC),
        ),
      ),
    );
  }

  /// 没有更多
  /// 对应小程序: Line 66
  Widget _buildNoMore() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: Text(
        '没有更多啦～',
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12.sp,
          color: const Color(0xFFCCCCCC),
        ),
      ),
    );
  }

  /// 错误状态
  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '加载失败',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textHint,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              ref.read(collectionNotifierProvider.notifier)
                  .loadCollections(refresh: true);
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
