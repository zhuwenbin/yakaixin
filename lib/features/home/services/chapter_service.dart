import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../models/question_bank_model.dart';

/// 章节练习服务
/// 对应小程序: api/chapter.js, api/index.js
/// API: /c/tiku/chapter/list, /c/tiku/homepage/recommend/chapterpackage
class ChapterService {
  final DioClient _dioClient;

  ChapterService(this._dioClient);

  /// 获取章节列表
  /// API: GET /c/tiku/chapter/list
  Future<List<ChapterModel>> getChapterList({
    required String professionalId,
  }) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/chapter/list',
        queryParameters: {'professional_id': professionalId},
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取章节列表失败');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('章节列表数据为空');
      }

      // ✅ 修复：小程序返回的是 section_info 字段
      final list = (data['section_info'] as List?) ?? [];
      return list
          .map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取章节列表失败: $e');
    }
  }

  /// 获取技能模拟数据
  /// API: GET /c/tiku/homepage/recommend/chapterpackage
  Future<SkillMockModel?> getSkillMock({required String professionalId}) async {
    try {
      final response = await _dioClient.get(
        '/c/tiku/homepage/recommend/chapterpackage',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'jinengmoni',
        },
      );

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取技能模拟失败');
      }

      final data = response.data['data'];
      if (data == null || data['id'] == 0 || data['id'] == '0') {
        return null; // 没有技能模拟数据
      }

      return SkillMockModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      throw Exception('获取技能模拟失败: $e');
    }
  }

  /// 获取章节练习数据（大卡片）
  /// 对应小程序: src/modules/jintiku/components/commen/index-nav.vue Line 268-282
  /// API: GET /c/tiku/homepage/recommend/chapterpackage
  Future<ChapterExerciseModel?> getChapterExercise({
    required String professionalId,
  }) async {
    print('🔍 [ChapterService] 开始获取章节练习: professionalId=$professionalId');
    
    try {
      final response = await _dioClient.get(
        '/c/tiku/homepage/recommend/chapterpackage',
        queryParameters: {
          'professional_id': professionalId,
          'position_identify': 'zhangjielianxi', // ✅ 小程序 Line 269
        },
      );

      print('📥 [ChapterService] 接口响应: ${response.data}');

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '获取章节练习失败';
        print('❌ [ChapterService] 接口返回错误: code=${response.data['code']}, msg=$errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'];
      print('📦 [ChapterService] 返回数据: $data');
      
      if (data == null || data['id'] == 0 || data['id'] == '0') {
        print('⚠️ [ChapterService] 没有章节练习数据 (id=0或null)');
        return null; // 没有章节练习数据
      }

      // ✅ 小程序 Line 273-280
      final model = ChapterExerciseModel(
        id: data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? '章节练习',
        permissionStatus: data['permission_status']?.toString() ?? '2',
        questionNumber: int.tryParse(data['question_num']?.toString() ?? '0') ?? 0,
        doQuestionNum: int.tryParse(
              data['student_finish']?['do_num']?.toString() ?? '0',
            ) ??
            0, // ✅ 从 student_finish.do_num 获取
        year: data['year']?.toString() ?? '',
        professionalId: professionalId,
      );
      
      print('✅ [ChapterService] 章节练习数据创建成功: id=${model.id}, name=${model.name}, questionNumber=${model.questionNumber}, doQuestionNum=${model.doQuestionNum}');
      return model;
    } on DioException catch (e) {
      print('❌ [ChapterService] 网络请求失败: ${e.message}');
      print('❌ [ChapterService] 错误详情: ${e.response?.data}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ [ChapterService] 未知错误: $e');
      print('❌ [ChapterService] 堆栈: $stackTrace');
      throw Exception('获取章节练习失败: $e');
    }
  }
  
  /// 获取章节树（章节列表页使用）
  /// 对应小程序: src/modules/jintiku/pages/chapterExercise/index.vue Line 71-86
  /// API: GET /c/tiku/homepage/chapterpackage/tree
  Future<List<Map<String, dynamic>>> getChapterTree({
    required String professionalId,
    required String goodsId,
  }) async {
    print('🔍 [ChapterService] 开始获取章节树: professionalId=$professionalId, goodsId=$goodsId');
    
    try {
      final response = await _dioClient.get(
        '/c/tiku/homepage/chapterpackage/tree',
        queryParameters: {
          'professional_id': professionalId,
          'goods_id': goodsId,
        },
      );

      print('📥 [ChapterService] 章节树接口响应: code=${response.data['code']}');

      // 统一处理响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '获取章节树失败';
        print('❌ [ChapterService] 接口返回错误: code=${response.data['code']}, msg=$errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'];
      if (data == null) {
        print('⚠️ [ChapterService] 章节树数据为空');
        return [];
      }

      // ✅ 小程序返回: data.section_info (数组)
      var sectionInfo = (data['section_info'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      
      print('📦 [ChapterService] 原始章节数: ${sectionInfo.length}');
      
      // ✅ 对应小程序 Line 75-79: 如果只有1个顶级章节且有子章节，展开子章节
      if (sectionInfo.length == 1) {
        final firstChapter = sectionInfo[0];
        final children = firstChapter['child'] as List?;
        if (children != null && children.isNotEmpty) {
          sectionInfo = children.cast<Map<String, dynamic>>();
          print('📦 [ChapterService] 展开唯一章节的子章节，新章节数: ${sectionInfo.length}');
        }
      }
      
      // ✅ 过滤掉题目数为0的章节 (对应小程序 filter 方法 Line 95-104)
      sectionInfo = _filterEmptyChapters(sectionInfo);
      
      print('✅ [ChapterService] 章节树加载成功: ${sectionInfo.length}个章节');
      return sectionInfo;
    } on DioException catch (e) {
      print('❌ [ChapterService] 网络请求失败: ${e.message}');
      print('❌ [ChapterService] 错误详情: ${e.response?.data}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ [ChapterService] 未知错误: $e');
      print('❌ [ChapterService] 堆栈: $stackTrace');
      throw Exception('获取章节树失败: $e');
    }
  }
  
  /// 过滤空章节（题目数为0的章节）
  /// 对应小程序: filter 方法 Line 95-104
  List<Map<String, dynamic>> _filterEmptyChapters(List<Map<String, dynamic>> chapters) {
    return chapters
        .where((chapter) {
          final questionNum = chapter['question_number']?.toString() ?? '0';
          return questionNum != '0';
        })
        .map((chapter) {
          // 递归过滤子章节
          final children = chapter['child'] as List?;
          if (children != null && children.isNotEmpty) {
            chapter['child'] = _filterEmptyChapters(
              children.cast<Map<String, dynamic>>(),
            );
          }
          return chapter;
        })
        .toList();
  }
}

/// ChapterService Provider
final chapterServiceProvider = Provider<ChapterService>((ref) {
  return ChapterService(ref.read(dioClientProvider));
});
