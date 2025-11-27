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
      print('🏠 首页加载数据 - 专业ID: $majorId');
      
      if (majorId == null || majorId.isEmpty) {
        print('⚠️ 专业ID为空，停止加载');
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
      
      print('📊 数据加载完成:');
      print('   题库商品: ${allQuestionBank.length} 条');
      print('   秒杀推荐: ${recommendList.length} 条');
      print('   网课列表: ${onlineCourseList.length} 条');
      print('   直播列表: ${liveList.length} 条');

      state = state.copyWith(
        questionBankList: allQuestionBank,
        recommendList: recommendList,
        onlineCourseList: onlineCourseList,
        liveList: liveList,
        isLoading: false,
      );
    } catch (e) {
      print('❌ 首页数据加载失败: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    print('🔄 开始刷新首页数据...');
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
