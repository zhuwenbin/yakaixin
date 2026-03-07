import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_style_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../models/goods_model.dart';
import '../../providers/home_provider.dart';
import 'seckill_banner.dart';
import 'section_title.dart';
import 'home_tab_bar.dart';
import 'goods_card.dart';
import 'course_card.dart';

/// 首页主内容区域
class HomeContent extends StatelessWidget {
  final HomeState state;
  final int tabIndex;
  final AppStyleTokens? styleTokens;
  final ValueChanged<int> onTabChanged;
  final void Function(GoodsModel) onSeckillTap;
  final void Function(GoodsModel) onGoodsTap;
  final void Function(GoodsModel) onCourseTap;

  const HomeContent({
    required this.state,
    required this.tabIndex,
    this.styleTokens,
    required this.onTabChanged,
    required this.onSeckillTap,
    required this.onGoodsTap,
    required this.onCourseTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['题库', '网课', '直播'];
    final currentList = _getCurrentList();

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.md),
            topRight: Radius.circular(AppRadius.md),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 秒杀区域
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.mdV),
                  const SectionTitle(title: '秒杀'),
                  SizedBox(height: AppSpacing.smV),
                ],
              ),
            ),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: SeckillBanner(
                recommendList: state.recommendList,
                onTap: onSeckillTap,
              ),
            ),
            SizedBox(height: AppSpacing.lgV),
            
            // Tab切换和列表
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeTabBar(
                    tabs: tabs,
                    activeIndex: tabIndex - 1,
                    onTap: (idx) => onTabChanged(idx + 1),
                  ),
                  SizedBox(height: AppSpacing.smV),
                  _buildList(currentList),
                  SizedBox(height: AppSpacing.xlV),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GoodsModel> _getCurrentList() {
    switch (tabIndex) {
      case 1:
        return state.questionBankList;
      case 2:
        return state.onlineCourseList;
      case 3:
        return state.liveList;
      default:
        return state.questionBankList;
    }
  }

  Widget _buildList(List<GoodsModel> list) {
    if (tabIndex == 1) {
      return _buildQuestionBankList(list);
    } else {
      return _buildCourseList(list);
    }
  }

  Widget _buildQuestionBankList(List<GoodsModel> list) {
    if (list.isEmpty) {
      return _buildEmpty('暂无题库数据');
    }

    return Column(
      children: list
          .map((goods) => GoodsCard(
                goods: goods,
                onTap: () => onGoodsTap(goods),
                styleTokens: styleTokens,
              ))
          .toList(),
    );
  }

  Widget _buildCourseList(List<GoodsModel> list) {
    if (list.isEmpty) {
      return _buildEmpty('暂无课程数据');
    }

    return Column(
      children: list
          .map((goods) => CourseCard(
                goods: goods,
                onTap: () => onCourseTap(goods),
                styleTokens: styleTokens,
              ))
          .toList(),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Padding(
        padding: AppSpacing.allXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: AppColors.divider,
            ),
            SizedBox(height: AppSpacing.mdV),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
