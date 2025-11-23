import '../../../core/network/dio_client.dart';
import '../models/goods_model.dart';

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
}
