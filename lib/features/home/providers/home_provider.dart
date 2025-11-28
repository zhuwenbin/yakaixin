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
  /// 参考小程序: src/modules/jintiku/pages/index/brushing.vue getGoods()
  Future<void> loadHomeData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 获取当前专业ID
      final majorId = _ref.read(currentMajorProvider)?.majorId;
      
      print('🔍 [首页数据加载] 开始加载...');
      print('📍 [专业ID] majorId: $majorId');
      
      if (majorId == null || majorId.isEmpty) {
        print('❌ [首页数据加载] 专业ID为空');
        state = state.copyWith(
          isLoading: false,
          error: '请先选择专业',
        );
        return;
      }

      // ✅ 对照小程序逻辑:
      // 1. getGoods({ type: '8,10,18' }) - 一次性获取题库数据(试卷+模考+章节练习)
      // 2. getGoods({ teaching_type: '3', type: '2,3' }) - 网课列表
      // 3. getGoods({ teaching_type: '1', type: '2,3' }) - 直播列表
      print('🌐 [API请求] 开始并发请求3个接口...');
      final results = await Future.wait([
        // 1. ✅ 获取题库数据 (type: '8,10,18') - 与小程序一致
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          professionalId: majorId,
          type: '8,10,18', // ✅ 一次性获取: 试卷(8)+模考(10)+章节练习(18)
        ),
        // 2. 获取网课列表 (teaching_type: '3', type: '2,3')
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          teachingType: '3',
          type: '2,3',
        ),
        // 3. 获取直播列表 (teaching_type: '1', type: '2,3')
        _goodsService.getGoodsList(
          shelfPlatformId: ApiConfig.shelfPlatformId,
          teachingType: '1',
          type: '2,3',
        ),
      ]);

      // ✅ 题库数据 - 直接使用第一个结果
      final questionBankList = results[0].list;
      print('📚 [题库数据] 获取到 ${questionBankList.length} 条数据');
      
      // ✅ 网课列表
      final onlineCourseList = results[1].list;
      print('🎓 [网课数据] 获取到 ${onlineCourseList.length} 条数据');
      
      // ✅ 直播列表
      final liveList = results[2].list;
      print('📡 [直播数据] 获取到 ${liveList.length} 条数据');

      // ✅ 筛选秒杀推荐商品 (首页推荐 且 **未购买**)
      // 参考小程序 Line 258-262: 
      // res.data.list.filter(e => e.is_homepage_recommend == 1 && e.permission_status == '2')
      // ⚠️ 注意: permission_status='2' 表示未购买，'1'表示已购买
      print('\n🔍 [秒杀筛选] 开始筛选推荐商品...');
      print('📋 [题库总数] ${questionBankList.length} 条');
      
      final recommendList = questionBankList.where((e) {
        final isRecommend = e.isHomepageRecommend?.toString() == '1' || e.isHomepageRecommend == 1;
        final isNotBought = e.permissionStatus == '2'; // ✅ 未购买商品才显示在秒杀区
        
        // 打印每个商品的详细信息
        if (isRecommend || isNotBought) {
          print('  📦 商品: ${e.name}');
          print('     - ID: ${e.goodsId}');
          print('     - is_homepage_recommend: ${e.isHomepageRecommend}');
          print('     - permission_status: ${e.permissionStatus}');
          print('     - isRecommend: $isRecommend');
          print('     - isNotBought: $isNotBought');
          print('     - ✅ 满足条件: ${isRecommend && isNotBought}');
        }
        
        return isRecommend && isNotBought;
      }).toList();
      
      print('\n🎯 [秒杀结果] 筛选到 ${recommendList.length} 个秒杀商品');
      if (recommendList.isEmpty) {
        print('⚠️ [秒杀为空] 将显示空状态图片');
      } else {
        print('✅ [秒杀商品列表]:');
        for (var goods in recommendList) {
          print('   - ${goods.name} (ID: ${goods.goodsId})');
        }
      }
      
      state = state.copyWith(
        questionBankList: questionBankList,
        recommendList: recommendList,
        onlineCourseList: onlineCourseList,
        liveList: liveList,
        isLoading: false,
      );
      
      print('\n✅ [首页数据加载] 完成!');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    } catch (e, stackTrace) {
      print('❌ [首页数据加载] 失败: $e');
      print('📍 堆栈信息: $stackTrace');
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
