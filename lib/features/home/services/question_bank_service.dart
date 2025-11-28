import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/question_bank_model.dart';

/// 题库数据服务
/// ✅ 只负责数据访问和类型转换，不包含业务逻辑
class QuestionBankService {
  final DioClient _dioClient;

  QuestionBankService(this._dioClient);

  /// 获取学习数据
  Future<LearningDataModel> getLearningData({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/exam/learningData',
        queryParameters: {
          'professional_id': professionalId,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['message'] ?? '获取学习数据失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('学习数据为空');
      }

      return LearningDataModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('获取学习数据失败: $e');
    }
  }

  /// 获取章节列表
  Future<List<ChapterModel>> getChapterList({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/exam/chapter/list',
        queryParameters: {
          'professional_id': professionalId,
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['message'] ?? '获取章节列表失败');
      }

      final list = response.data['data'] as List?;
      if (list == null) {
        return [];
      }

      return list
          .map((item) {
            try {
              return ChapterModel.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              print('跳过无效章节数据: $e');
              return null;
            }
          })
          .whereType<ChapterModel>()
          .toList();
    } catch (e) {
      throw Exception('获取章节列表失败: $e');
    }
  }

  /// 获取已购商品
  Future<List<PurchasedGoodsModel>> getPurchasedGoods({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/goods/v2',
        queryParameters: {
          'professional_id': professionalId,
          'type': '10,8',
          'is_buyed': '1',
        },
      );

      if (response.data['code'] != 200) {
        throw Exception(response.data['message'] ?? '获取已购商品失败');
      }

      final list = response.data['data']['list'] as List?;
      if (list == null) {
        return [];
      }

      return list
          .map((item) {
            try {
              return PurchasedGoodsModel.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              print('跳过无效商品数据: $e');
              return null;
            }
          })
          .whereType<PurchasedGoodsModel>()
          .toList();
    } catch (e) {
      throw Exception('获取已购商品失败: $e');
    }
  }

  /// 获取每日一测
  Future<DailyPracticeModel?> getDailyPractice({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/goods/v2',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'daily30',
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['message'] ?? '获取每日一测失败');
      }

      final list = response.data['data']['list'] as List?;
      if (list == null || list.isEmpty) {
        return null;
      }

      return DailyPracticeModel.fromJson(list[0] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('获取每日一测失败: $e');
    }
  }

  /// 获取技能模拟
  Future<SkillMockModel?> getSkillMock({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/exam/chapterpackage',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'jinengmoni',
        },
      );

      if (response.data['code'] != 100000) {
        throw Exception(response.data['message'] ?? '获取技能模拟失败');
      }

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null || data['id'] == null || data['id'] == 0) {
        return null;
      }

      return SkillMockModel.fromJson(data);
    } catch (e) {
      throw Exception('获取技能模拟失败: $e');
    }
  }

  /// 打卡
  Future<LearningDataModel> checkIn({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.post(
        '/c/exam/checkinData',
        data: {
          'professional_id': professionalId,
        },
      );

      if (response.data['code'] != 100000) {
        final msg = response.data['msg'];
        final message = msg is List && msg.isNotEmpty ? msg[0] : '打卡失败';
        throw Exception(message);
      }

      // 打卡成功后重新获取学习数据
      return await getLearningData(professionalId: professionalId);
    } catch (e) {
      throw Exception('打卡失败: $e');
    }
  }
}

/// Service Provider
final questionBankServiceProvider = Provider<QuestionBankService>((ref) {
  return QuestionBankService(ref.read(dioClientProvider));
});
