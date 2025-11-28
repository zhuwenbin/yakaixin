import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../app/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/goods_model.dart';
import '../services/goods_service.dart';

part 'home_provider.freezed.dart';

/// GoodsService Provider
final goodsServiceProvider = Provider<GoodsService>((ref) {
  return GoodsService(ref.read(dioClientProvider));
});

/// 首页状态
@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<GoodsModel> recommendList,
    @Default([]) List<GoodsModel> questionBankList,
    @Default([]) List<GoodsModel> onlineCourseList,
    @Default([]) List<GoodsModel> liveList,
    @Default(false) bool isLoading,
    String? error,
  }) = _HomeState;
}

/// 首页Provider
class HomeNotifier extends StateNotifier<HomeState> {
  final GoodsService _goodsService;
  final Ref _ref;

  HomeNotifier(this._goodsService, this._ref) : super(const HomeState());

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
      // 4. getGoods({ teaching_type: '3' }) - 网课列表
      // 5. getGoods({ teaching_type: '1' }) - 直播列表
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
        // 4. 获取网课列表 (teaching_type: '3')
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          teachingType: '3',
          type: '2,3', // 小程序: type: '2,3'
        ),
        // 5. 获取直播列表 (teaching_type: '1')
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          teachingType: '1',
          type: '2,3',
        ),
      ]);

      // 合并所有题库数据
      final allQuestionBank = [
        ...results[0].list,
        ...results[1].list,
        ...results[2].list,
      ];
      
      // 网课列表
      final onlineCourseList = results[3].list;
      
      // 直播列表
      final liveList = results[4].list;

      // 筛选秒杀推荐商品 (首页推荐 且 **未购买**)
      // 参考小程序: is_homepage_recommend == 1 && permission_status == '2'
      // ⚠️ 注意: permission_status='2' 表示未购买，'1'表示已购买
      final recommendList = allQuestionBank.where((e) {
        final isRecommend = e.isHomepageRecommend?.toString() == '1' || e.isHomepageRecommend == 1;
        final isNotBought = e.permissionStatus == '2'; // ⚠️ 未购买
        return isRecommend && isNotBought;
      }).toList();
      
      state = state.copyWith(
        questionBankList: allQuestionBank,
        recommendList: recommendList,
        onlineCourseList: onlineCourseList,
        liveList: liveList,
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
    // ⚠️ 不清空数据，直接重新加载，保持 loading 状态
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
