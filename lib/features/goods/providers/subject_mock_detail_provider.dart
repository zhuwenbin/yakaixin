import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/utils/error_message_mapper.dart';
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
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      print('❌ [科目模考详情] 加载失败: $errorMsg');
      state = state.copyWith(isLoading: false, error: errorMsg);
    } catch (e) {
      // ✅ 兜底：未预期的错误
      print('❌ [科目模考详情] 未预期错误: $e');
      state = state.copyWith(isLoading: false, error: '加载失败，请稍后重试');
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
