import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/goods_detail_model.dart';
import '../../home/models/goods_model.dart';

/// 商品服务
/// 负责商品相关的API调用
class GoodsService {
  final DioClient _dioClient;

  GoodsService(this._dioClient);

  /// 获取商品列表
  /// 对应小程序: /c/goods/v2
  /// 参考: brushing.vue Line 252-268, index.vue Line 263-300
  Future<GoodsListResponse> getGoodsList({
    String? shelfPlatformId,
    String? professionalId,
    String? type,
    String? teachingType,
    int? isBuyed,
    String? positionIdentify,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (shelfPlatformId != null) {
        queryParams['shelf_platform_id'] = shelfPlatformId;
      }
      if (professionalId != null) {
        queryParams['professional_id'] = professionalId;
      }
      if (type != null) {
        queryParams['type'] = type;
      }
      if (teachingType != null) {
        queryParams['teaching_type'] = teachingType;
      }
      if (isBuyed != null) {
        queryParams['is_buyed'] = isBuyed;
      }
      if (positionIdentify != null) {
        queryParams['position_identify'] = positionIdentify;
      }

      final response = await _dioClient.get(
        '/c/goods/v2',
        queryParameters: queryParams,
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取商品列表失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('商品列表数据为空');
      }

      return GoodsListResponse.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取商品列表失败: $e');
    }
  }

  /// 通过position_identify获取商品
  /// 对应小程序: study-card-grid.vue getGoods({ shelf_platform_id, professional_id, position_identify })，接口 /c/goods/v2
  Future<GoodsListResponse> getGoodsByPosition({
    required String positionIdentify,
    String? professionalId,
    String? shelfPlatformId,
  }) async {
    return getGoodsList(
      positionIdentify: positionIdentify,
      professionalId: professionalId,
      shelfPlatformId: shelfPlatformId,
    );
  }

  /// 获取商品详情
  /// 对应小程序: /c/goods/v2/detail
  /// 参考: newVideo.vue getDetail() Line 386-396 (goods_id, user_id, student_id, merchant_id, brand_id, no_professional_id)
  Future<GoodsDetailModel> getGoodsDetail({
    required String goodsId,
    String? userId,
    String? studentId,
    String? merchantId,
    String? brandId,
    String? noProfessionalId,
  }) async {
    try {
      final queryParams = <String, dynamic>{'goods_id': goodsId};

      if (userId != null && userId.isNotEmpty) {
        queryParams['user_id'] = userId;
      }
      if (studentId != null && studentId.isNotEmpty) {
        queryParams['student_id'] = studentId;
      }
      if (merchantId != null && merchantId.isNotEmpty) {
        queryParams['merchant_id'] = merchantId;
      }
      if (brandId != null && brandId.isNotEmpty) {
        queryParams['brand_id'] = brandId;
      }
      if (noProfessionalId != null && noProfessionalId.isNotEmpty) {
        queryParams['no_professional_id'] = noProfessionalId;
      }

      final response = await _dioClient.get(
        '/c/goods/v2/detail',
        queryParameters: queryParams,
      );

      // ✅ 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取商品详情失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('商品详情数据为空');
      }

      return GoodsDetailModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取商品详情失败: $e');
    }
  }
}

/// GoodsService Provider
final goodsServiceProvider = Provider<GoodsService>((ref) {
  return GoodsService(ref.read(dioClientProvider));
});
