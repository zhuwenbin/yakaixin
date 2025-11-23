import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/goods_model.dart';
import '../services/goods_service.dart';

/// GoodsService Provider
final goodsServiceProvider = Provider<GoodsService>((ref) {
  return GoodsService(ref.read(dioClientProvider));
});

/// 首页状态
/// ✅ 符合数据安全规则: 使用不可变状态类,所有字段都有默认值
class HomeState {
  final List<GoodsModel> recommendList; // 秒杀推荐列表
  final List<GoodsModel> questionBankList; // 题库列表
  final List<GoodsModel> onlineCourseList; // 网课列表
  final List<GoodsModel> liveList; // 直播列表
  final bool isLoading;
  final String? error;

  const HomeState({
    this.recommendList = const [],
    this.questionBankList = const [],
    this.onlineCourseList = const [],
    this.liveList = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<GoodsModel>? recommendList,
    List<GoodsModel>? questionBankList,
    List<GoodsModel>? onlineCourseList,
    List<GoodsModel>? liveList,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      recommendList: recommendList ?? this.recommendList,
      questionBankList: questionBankList ?? this.questionBankList,
      onlineCourseList: onlineCourseList ?? this.onlineCourseList,
      liveList: liveList ?? this.liveList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 首页Provider
class HomeNotifier extends StateNotifier<HomeState> {
  final GoodsService _goodsService;
  final Ref _ref;

  HomeNotifier(this._goodsService, this._ref) : super(HomeState());

  /// 加载首页数据
  /// 参考小程序: src/modules/jintiku/pages/index/index.vue getGoods()
  Future<void> loadHomeData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 获取当前专业ID
      final majorId = _ref.read(currentMajorProvider)?.majorId;
      if (majorId == null || majorId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: '请先选择专业',
        );
        return;
      }

      // 参考小程序的实现:
      // 1. getGoods({ type: 18 }) - 章节练习
      // 2. getGoods({ type: '8,10' }) - 试卷和模考
      // 3. getGoods({ type: '10,8', is_buyed: 1 }) - 已购试题
      final results = await Future.wait([
        // 1. 获取章节练习 (type: 18)
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          professionalId: majorId,
          type: '18',
        ),
        // 2. 获取试卷和模考 (type: 8,10)
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          professionalId: majorId,
          type: '8,10',
        ),
        // 3. 获取已购试题 (type: 10,8, is_buyed: 1)
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          professionalId: majorId,
          type: '10,8',
          isBuyed: 1,
        ),
      ]);

      // 合并所有题库数据
      final allQuestionBank = [
        ...results[0].list,
        ...results[1].list,
        ...results[2].list,
      ];

      // 筛选秒杀推荐商品 (首页推荐 且 已购买)
      // 参考小程序: is_homepage_recommend == 1 && permission_status == '2'
      final recommendList = allQuestionBank.where((e) {
        final isRecommend = e.isHomepageRecommend?.toString() == '1' || e.isHomepageRecommend == 1;
        final isBought = e.permissionStatus == '2';
        return isRecommend && isBought;
      }).toList();

      state = state.copyWith(
        questionBankList: allQuestionBank,
        recommendList: recommendList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    state = const HomeState(); // 清空数据
    await loadHomeData();
  }
}

/// 首页Provider实例
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    ref.read(goodsServiceProvider),
    ref,
  );
});
