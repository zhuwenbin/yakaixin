import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../app/config/api_config.dart';
import '../../../core/utils/safe_type_converter.dart';
import '../models/goods_detail_model.dart';
import '../services/goods_service.dart';

part 'goods_detail_provider.freezed.dart';
part 'goods_detail_provider.g.dart';

/// 商品详情状态
@freezed
class GoodsDetailState with _$GoodsDetailState {
  const factory GoodsDetailState({
    GoodsDetailModel? goodsDetail,
    @Default(0) int selectedPriceIndex, // 当前选择的价格索引
    @Default(false) bool isLoading,
    String? error,
  }) = _GoodsDetailState;
}

/// 商品详情Provider
/// 对应小程序: pages/test/detail.vue
@riverpod
class GoodsDetailNotifier extends _$GoodsDetailNotifier {
  @override
  GoodsDetailState build() => const GoodsDetailState();

  /// 加载商品详情
  /// 对应小程序: detail.vue Line 408-503
  Future<void> loadGoodsDetail(String goodsId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: goodsId);

      // ✅ 数据处理逻辑（对应小程序 Line 412-503）
      final processedDetail = _processGoodsDetail(detail);

      state = state.copyWith(goodsDetail: processedDetail, isLoading: false);
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      print('❌ [商品详情] 加载失败: $errorMsg');
      state = state.copyWith(isLoading: false, error: errorMsg);
    } catch (e) {
      // ✅ 兜底：未预期的错误
      print('❌ [商品详情] 未预期错误: $e');
      state = state.copyWith(isLoading: false, error: '加载失败，请稍后重试');
    }
  }

  /// 处理商品详情数据
  /// 对应小程序的数据处理逻辑
  GoodsDetailModel _processGoodsDetail(GoodsDetailModel detail) {
    // 1. ✅ 排序价格（永久有效期排最后）
    // 对应小程序 Line 416-432
    final sortedPrices = [...detail.prices]
      ..sort((a, b) {
        final aMonth = SafeTypeConverter.toInt(a.month);
        final bMonth = SafeTypeConverter.toInt(b.month);
        if (aMonth == 0) return 1; // 永久排最后
        if (bMonth == 0) return -1;
        return aMonth.compareTo(bMonth);
      });

    // 2. ✅ 处理价格为空的情况（免费商品）
    // 对应小程序 Line 433-445
    final finalPrices = sortedPrices.isEmpty
        ? [
            const GoodsPriceModel(
              goodsMonthsPriceId: '',
              month: 0,
              salePrice: '0.00',
              originalPrice: '0.00',
              days: '0',
            ),
          ]
        : sortedPrices;

    // 3. ⚠️ 特殊处理：type!=18时，封面和介绍路径互换
    // 对应小程序 Line 477-484
    String? coverPath = detail.materialCoverPath;
    String? introPath = detail.materialIntroPath;

    final typeInt = SafeTypeConverter.toInt(detail.type);
    if (typeInt != 18) {
      // 非章节练习类型，路径互换
      coverPath = detail.materialIntroPath;
      introPath = detail.materialCoverPath;
    }

    // 4. ✅ 处理封面路径为空的情况，并拼接完整URL
    // 对应小程序 Line 485-492: this.info.material_cover_path = this.completepath(this.info.material_cover_path)
    print('🖼️ [商品详情] 封面路径处理前: coverPath=$coverPath, introPath=$introPath');
    if (coverPath == null || coverPath.isEmpty) {
      coverPath = 'assets/images/app_icon.png';
      print('🖼️ [商品详情] 封面路径为空，使用本地默认图片');
    } else {
      // ✅ 调用 completeImageUrl 拼接完整URL（对应小程序 completepath()）
      final originalCoverPath = coverPath;
      coverPath = ApiConfig.completeImageUrl(coverPath);
      print('🖼️ [商品详情] 封面路径处理后: $originalCoverPath → $coverPath');
    }

    // 5. ✅ 处理介绍路径，拼接完整URL（如果存在）
    // 对应小程序 Line 89: completepath(info.material_intro_path)
    if (introPath != null && introPath.isNotEmpty) {
      final originalIntroPath = introPath;
      introPath = ApiConfig.completeImageUrl(introPath);
      print('🖼️ [商品详情] 介绍路径处理后: $originalIntroPath → $introPath');
    } else {
      print('🖼️ [商品详情] 介绍路径为空');
    }

    return detail.copyWith(
      prices: finalPrices,
      materialCoverPath: coverPath,
      materialIntroPath: introPath,
    );
  }

  /// 选择价格
  /// 对应小程序: detail.vue Line 233-236
  void selectPrice(int index) {
    if (index >= 0 && index < (state.goodsDetail?.prices.length ?? 0)) {
      state = state.copyWith(selectedPriceIndex: index);
    }
  }

  /// 刷新数据
  Future<void> refresh(String goodsId) async {
    await loadGoodsDetail(goodsId);
  }
}
