import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../goods/models/goods_detail_model.dart';
import '../../goods/services/goods_service.dart';

part 'simulated_exam_room_provider.freezed.dart';
part 'simulated_exam_room_provider.g.dart';

/// 模拟考场状态
@freezed
class SimulatedExamRoomState with _$SimulatedExamRoomState {
  const factory SimulatedExamRoomState({
    GoodsDetailModel? goodsDetail,
    @Default(false) bool isLoading,
    String? error,
  }) = _SimulatedExamRoomState;
}

/// 模拟考场Provider
/// 对应小程序: pages/test/simulatedExamRoom.vue
@riverpod
class SimulatedExamRoomNotifier extends _$SimulatedExamRoomNotifier {
  @override
  SimulatedExamRoomState build() => const SimulatedExamRoomState();

  /// 加载商品详情
  Future<void> loadDetail(String productId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: productId);

      state = state.copyWith(goodsDetail: detail, isLoading: false);
    } catch (e) {
      print('❌ [模拟考场] 加载失败: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 刷新数据
  Future<void> refresh(String productId) async {
    await loadDetail(productId);
  }
}
