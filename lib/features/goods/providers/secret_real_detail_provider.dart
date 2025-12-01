import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../goods/models/goods_detail_model.dart';
import '../../goods/services/goods_service.dart';

part 'secret_real_detail_provider.freezed.dart';
part 'secret_real_detail_provider.g.dart';

/// 历年真题详情状态
@freezed
class SecretRealDetailState with _$SecretRealDetailState {
  const factory SecretRealDetailState({
    GoodsDetailModel? goodsDetail,
    @Default(false) bool isLoading,
    String? error,
  }) = _SecretRealDetailState;
}

/// 历年真题详情Provider
/// 对应小程序: pages/test/secretRealDetail.vue
@riverpod
class SecretRealDetailNotifier extends _$SecretRealDetailNotifier {
  @override
  SecretRealDetailState build() => const SecretRealDetailState();

  /// 加载商品详情
  Future<void> loadDetail(String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: productId);

      state = state.copyWith(goodsDetail: detail, isLoading: false);
    } catch (e) {
      print('❌ [真题详情] 加载失败: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 刷新数据
  Future<void> refresh(String productId) async {
    await loadDetail(productId);
  }
}
