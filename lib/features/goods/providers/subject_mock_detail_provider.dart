import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../goods/models/goods_detail_model.dart';
import '../../goods/services/goods_service.dart';

part 'subject_mock_detail_provider.freezed.dart';
part 'subject_mock_detail_provider.g.dart';

/// 科目模考详情状态
@freezed
class SubjectMockDetailState with _$SubjectMockDetailState {
  const factory SubjectMockDetailState({
    GoodsDetailModel? goodsDetail,
    @Default(false) bool isLoading,
    String? error,
    @Default(0) int activePriceIndex, // 当前选中的价格索引
  }) = _SubjectMockDetailState;
}

/// 科目模考详情Provider
/// 对应小程序: pages/test/subjectMockDetail.vue
@riverpod
class SubjectMockDetailNotifier extends _$SubjectMockDetailNotifier {
  @override
  SubjectMockDetailState build() => const SubjectMockDetailState();

  /// 加载商品详情
  Future<void> loadDetail(String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: productId);

      state = state.copyWith(goodsDetail: detail, isLoading: false);
    } catch (e) {
      print('❌ [科目模考详情] 加载失败: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 刷新数据
  Future<void> refresh(String productId) async {
    await loadDetail(productId);
  }

  /// 更新选中的价格索引
  void updateActivePriceIndex(int index) {
    state = state.copyWith(activePriceIndex: index);
  }
}
