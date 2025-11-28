import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../models/goods_model.dart';

part 'goods_service.g.dart';

/// 商品Service Provider
@riverpod
GoodsService goodsService(GoodsServiceRef ref) {
  final dioClient = ref.watch(dioClientProvider);
  return GoodsService(dioClient);
}

/// 商品Service
/// 对应小程序: src/modules/jintiku/api/index.js getGoods
class GoodsService {
  final DioClient _dioClient;

  GoodsService(this._dioClient);

  /// 获取商品列表
  /// [shelfPlatformId] 货架平台ID
  /// [professionalId] 专业ID
  /// [type] 商品类型 8:试卷 10:模考 18:章节练习 2:套餐 3:课程 (可组合如: '8,10,18')
  /// [teachingType] 授课类型 1:直播 2:录播 3:网课
  /// [isBuyed] 是否已购买 1:是
  /// [isHomepageRecommend] 是否首页推荐
  /// [positionIdentify] 位置标识 (linianzhenti:历年真题 kemumokao:科目模考)
  Future<GoodsListResponse> getGoodsList({
    String? shelfPlatformId,
    String? professionalId,
    String? type,
    String? teachingType,
    int? isBuyed,
    int? isHomepageRecommend,
    String? positionIdentify,
  }) async {
    final response = await _dioClient.get(
      '/c/goods/v2',
      queryParameters: {
        if (shelfPlatformId != null) 'shelf_platform_id': shelfPlatformId,
        if (professionalId != null) 'professional_id': professionalId,
        if (type != null) 'type': type,
        if (teachingType != null) 'teaching_type': teachingType,
        if (isBuyed != null) 'is_buyed': isBuyed,
        if (isHomepageRecommend != null) 'is_homepage_recommend': isHomepageRecommend,
        if (positionIdentify != null) 'position_identify': positionIdentify,
      },
    );

    return GoodsListResponse.fromJson(response.data['data']);
  }

  /// 获取商品详情
  Future<GoodsModel> getGoodsDetail({required String goodsId}) async {
    final response = await _dioClient.get(
      '/c/goods/v2/detail',
      queryParameters: {'goods_id': goodsId},
    );

    return GoodsModel.fromJson(response.data['data']);
  }

  /// 根据position_identify获取商品列表
  /// 对应小程序: getGoods({ position_identify: 'linianzhenti' })
  /// 用于学习卡片跳转: 绝密押题、科目模考、模拟考试
  Future<GoodsListResponse> getGoodsByPosition({
    required String positionIdentify,
    String? professionalId,
  }) async {
    final response = await _dioClient.get(
      '/c/goods',
      queryParameters: {
        'position_identify': positionIdentify,
        if (professionalId != null) 'professional_id': professionalId,
      },
    );

    return GoodsListResponse.fromJson(response.data['data']);
  }

  /// 获取课程章节数据
  /// 对应小程序: chapterpaper (api/index.js:994-1000)
  /// 对应接口: GET /c/goods/v2/chapter
  /// 参数:
  ///   - goodsId: 商品ID
  ///   - noProfessionalId: 不筛选专业ID (固定"1")
  ///   - noUserId: 不筛选用户ID (固定"1")
  Future<List<dynamic>> getChapterPaper({
    required String goodsId,
    String noProfessionalId = '1',
    String noUserId = '1',
  }) async {
    final response = await _dioClient.get(
      '/c/goods/v2/chapter',
      queryParameters: {
        'goods_id': goodsId,
        'no_professional_id': noProfessionalId,
        'no_user_id': noUserId,
      },
    );

    // 返回章节列表数据
    return response.data['data'] as List<dynamic>;
  }
}
