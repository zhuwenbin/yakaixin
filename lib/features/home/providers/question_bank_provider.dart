import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../app/config/api_config.dart';
import '../models/question_bank_model.dart';
import '../services/learning_service.dart';
import '../services/chapter_service.dart';
import '../../goods/services/goods_service.dart';
import '../../auth/providers/auth_provider.dart';

part 'question_bank_provider.freezed.dart';

// ============================================
// State 定义
// ============================================

/// 题库页面状态
@freezed
class QuestionBankState with _$QuestionBankState {
  const factory QuestionBankState({
    // 学习数据
    LearningDataModel? learningData,
    @Default(false) bool isLoadingLearning,

    // 章节数据
    @Default([]) List<ChapterModel> chapters,
    @Default(false) bool isLoadingChapters,

    // 章节练习（大卡片，对应小程序 index-nav.vue）
    ChapterExerciseModel? chapterExercise,

    // 已购商品
    @Default([]) List<PurchasedGoodsModel> purchasedGoods,
    @Default(false) bool isLoadingPurchased,

    // 每日一测
    DailyPracticeModel? dailyPractice,

    // 技能模拟
    SkillMockModel? skillMock,

    // 错误信息
    String? error,
    ErrorType? errorType,

    // 操作成功标志
    @Default(false) bool checkInSuccess,
    String? successMessage,
  }) = _QuestionBankState;
}

/// 错误类型
enum ErrorType {
  network, // 网络错误
  dataEmpty, // 数据为空
  unknown, // 未知错误
}

// ============================================
// ViewModel - 业务逻辑处理
// ============================================

class QuestionBankNotifier extends StateNotifier<QuestionBankState> {
  final Ref _ref;

  QuestionBankNotifier(this._ref) : super(const QuestionBankState());

  /// 加载所有数据
  Future<void> loadAllData() async {
    // 获取当前专业ID
    var majorId = _ref.read(currentMajorProvider)?.majorId;

    // ✅ 如果没有专业，使用默认专业（口腔执业医师）
    if (majorId == null || majorId.isEmpty) {
      majorId = '524033912737962623';
      print('⚠️ [QuestionBankProvider] 未选择专业，使用默认专业: $majorId');
    } else {
      print('✅ [QuestionBankProvider] 当前专业ID: $majorId');
    }

    // 并行加载所有数据
    try {
      await Future.wait([
        _loadLearningData(majorId),
        _loadChapters(majorId),
        _loadChapterExercise(majorId), // ✅ 加载章节练习
        _loadPurchasedGoods(majorId),
        _loadDailyPractice(majorId),
        _loadSkillMock(majorId),
      ]);
      print('✅ [QuestionBankProvider] 所有数据加载完成');
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '数据加载失败，请稍后重试';
      print('❌ [QuestionBankProvider] 数据加载失败: $errorMsg');
      state = state.copyWith(error: errorMsg, errorType: ErrorType.network);
    } catch (e) {
      // ✅ 兜底：未预期的错误
      print('❌ [QuestionBankProvider] 未预期错误: $e');
      state = state.copyWith(
        error: '数据加载失败，请稍后重试',
        errorType: ErrorType.network,
      );
    }
  }

  /// 加载学习数据
  Future<void> _loadLearningData(String majorId) async {
    state = state.copyWith(isLoadingLearning: true, error: null);

    try {
      // ✅ 使用真实的 LearningService
      final service = _ref.read(learningServiceProvider);
      final learningData = await service.getLearningData(
        professionalId: majorId,
      );

      state = state.copyWith(
        learningData: learningData,
        isLoadingLearning: false,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载学习数据失败';
      state = state.copyWith(
        isLoadingLearning: false,
        error: errorMsg,
        errorType: ErrorType.network,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoadingLearning: false,
        error: '加载学习数据失败',
        errorType: ErrorType.network,
      );
    }
  }

  /// 加载章节列表
  Future<void> _loadChapters(String majorId) async {
    state = state.copyWith(isLoadingChapters: true);

    try {
      // ✅ 使用真实的 ChapterService
      final service = _ref.read(chapterServiceProvider);
      final chapters = await service.getChapterList(professionalId: majorId);

      state = state.copyWith(chapters: chapters, isLoadingChapters: false);
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载章节失败';
      state = state.copyWith(
        isLoadingChapters: false,
        error: errorMsg,
        errorType: ErrorType.network,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoadingChapters: false,
        error: '加载章节失败',
        errorType: ErrorType.network,
      );
    }
  }

  /// 加载章节练习（大卡片）
  /// 对应小程序: src/modules/jintiku/components/commen/index-nav.vue Line 268-282
  Future<void> _loadChapterExercise(String majorId) async {
    print('📚 [QuestionBankProvider] 开始加载章节练习: majorId=$majorId');
    state = state.copyWith(isLoadingChapters: true);

    try {
      // ✅ 使用正确的 ChapterService.getChapterExercise 方法
      final service = _ref.read(chapterServiceProvider);
      print(
        '🔧 [QuestionBankProvider] ChapterService实例已获取，调用getChapterExercise...',
      );

      final chapterExercise = await service.getChapterExercise(
        professionalId: majorId,
      );

      print(
        '📦 [QuestionBankProvider] getChapterExercise返回结果: ${chapterExercise != null ? "有数据" : "null"}',
      );

      state = state.copyWith(chapterExercise: chapterExercise);

      if (chapterExercise != null) {
        print(
          '✅ [QuestionBankProvider] 章节练习加载成功: id=${chapterExercise.id}, name=${chapterExercise.name}, questionNumber=${chapterExercise.questionNumber}, doQuestionNum=${chapterExercise.doQuestionNum}, permissionStatus=${chapterExercise.permissionStatus}',
        );
      } else {
        print('⚠️ [QuestionBankProvider] 没有章节练习数据（接口返回null）');
      }
    } catch (e, stackTrace) {
      print('❌ [QuestionBankProvider] 加载章节练习失败: $e');
      print('❌ [QuestionBankProvider] 堆栈: $stackTrace');
      // 章节练习失败不影响整体页面
      state = state.copyWith(chapterExercise: null);
    }
  }

  /// 加载已购商品
  Future<void> _loadPurchasedGoods(String majorId) async {
    print('📚 [题库Provider] 开始加载已购试题: majorId=$majorId');
    state = state.copyWith(isLoadingPurchased: true);

    try {
      // ✅ 使用真实的 GoodsService
      final service = _ref.read(goodsServiceProvider);
      // ✅ 修复：添加 shelf_platform_id 参数，与小程序保持一致
      // 对应小程序: index.vue Line 291-296
      final response = await service.getGoodsList(
        shelfPlatformId: ApiConfig.shelfPlatformId, // ✅ 新增：平台ID筛选
        professionalId: majorId,
        type: '10,8', // 模拟考试、试卷
        isBuyed: 1, // 已购买
      );

      print('📚 [题库Provider] API返回商品数量: ${response.list.length}');

      if (response.list.isNotEmpty) {
        print('📚 [题库Provider] 前3个商品:');
        for (var i = 0; i < response.list.length && i < 3; i++) {
          final goods = response.list[i];
          print(
            '  [$i] ${goods.name}, permission_status=${goods.permissionStatus}, type=${goods.type}',
          );
        }
      }

      // ✅ 将 GoodsModel 转换为 PurchasedGoodsModel
      final purchasedGoods = response.list.map((goods) {
        // ✅ 计算 num_text（对应小程序 Line 275-328）
        // ⚠️ 注意：小程序中如果 tiku_goods_details 为 null 或相关字段为 0/不存在，num_text 可能为空
        // 小程序 Line 9: v-if="info.num_text" - 只有当 num_text 存在且为真值时才显示
        String? numText;
        if (goods.tikuGoodsDetails != null) {
          final details = goods.tikuGoodsDetails!;
          final type = goods.type?.toString() ?? '';

          if (type == '8') {
            // 试卷：显示份数
            final paperNum = details.paperNum;
            // ✅ 只有当 paperNum 存在且大于 0 时才设置 numText
            if (paperNum != null && paperNum != 0) {
              numText = '共${paperNum}份';
            }
          } else if (type == '10') {
            // 模考：显示轮数
            final examRoundNum = details.examRoundNum;
            // ✅ 只有当 examRoundNum 存在且大于 0 时才设置 numText
            if (examRoundNum != null && examRoundNum != 0) {
              numText = '共${examRoundNum}轮';
            }
          } else {
            // 题库：显示题数
            final questionNum = details.questionNum;
            // ✅ 只有当 questionNum 存在且大于 0 时才设置 numText
            if (questionNum != null && questionNum != 0) {
              numText = '共${questionNum}题';
            }
          }
        }

        // ✅ 构造JSON数据，然后使用fromJson转换（利用Freezed的转换器）
        final json = <String, dynamic>{
          'id': goods.goodsId?.toString() ?? '',
          'name': goods.name ?? '',
          'material_cover_path': goods.materialCoverPath ?? '',
          'question_count': goods.tikuGoodsDetails?.questionNum ?? 0,
          'type': goods.type?.toString() ?? '',
          'details_type': goods.detailsType?.toString() ?? '',
          'data_type': goods.dataType?.toString() ?? '',
          'permission_status': goods.permissionStatus?.toString() ?? '1',
          'recitation_question_model':
              goods.recitationQuestionModel?.toString() ?? '',
          'professional_id': majorId,
          'validity_start_date': goods.validityStartDate,
          'validity_end_date': goods.validityEndDate,
          'created_at': goods.createdAt, // ✅ 从 GoodsModel 中获取 created_at（开考时间）
          'num_text':
              numText, // ✅ 如果值为 0 或不存在，numText 为 null，不显示标签（对应小程序 v-if="info.num_text"）
          if (goods.tikuGoodsDetails != null)
            'tiku_goods_details': {
              'question_num': goods.tikuGoodsDetails!.questionNum ?? 0,
              'paper_num': goods.tikuGoodsDetails!.paperNum ?? 0,
              'exam_round_num': goods.tikuGoodsDetails!.examRoundNum ?? 0,
              'exam_time': goods.tikuGoodsDetails!.examTime ?? '',
            },
        };

        return PurchasedGoodsModel.fromJson(json);
      }).toList();

      state = state.copyWith(
        purchasedGoods: purchasedGoods,
        isLoadingPurchased: false,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      state = state.copyWith(
        isLoadingPurchased: false,
        error: errorMsg,
        errorType: ErrorType.network,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoadingPurchased: false,
        error: '加载失败，请稍后重试',
        errorType: ErrorType.network,
      );
    }
  }

  /// 加载每日一测
  Future<void> _loadDailyPractice(String majorId) async {
    try {
      // ✅ 使用真实的 GoodsService
      final service = _ref.read(goodsServiceProvider);
      final response = await service.getGoodsList(
        professionalId: majorId,
        positionIdentify: 'daily30',
      );

      if (response.list.isNotEmpty) {
        final goods = response.list[0];
        final dailyPractice = DailyPracticeModel(
          id: goods.goodsId?.toString() ?? '',
          name: goods.name ?? '每日一练',
          permissionStatus: goods.permissionStatus ?? '2', // ✅ 传递权限状态
          totalQuestions:
              int.tryParse(
                goods.tikuGoodsDetails?.questionNum?.toString() ?? '30',
              ) ??
              30,
          doneQuestions: 0, // TODO: 需要从其他接口获取已做题数
        );

        state = state.copyWith(dailyPractice: dailyPractice);
      } else {
        state = state.copyWith(dailyPractice: null);
      }
    } catch (e) {
      print('加载每日一测失败: $e');
      // 每日一测失败不影响整体页面
      state = state.copyWith(dailyPractice: null);
    }
  }

  /// 加载技能模拟
  Future<void> _loadSkillMock(String majorId) async {
    try {
      // ✅ 使用真实的 ChapterService
      final service = _ref.read(chapterServiceProvider);
      final skillMock = await service.getSkillMock(professionalId: majorId);

      state = state.copyWith(skillMock: skillMock);
    } catch (e) {
      print('加载技能模拟失败: $e');
      // 技能模拟失败不影响整体页面
      state = state.copyWith(skillMock: null);
    }
  }

  /// 打卡
  Future<void> checkIn() async {
    // ✅ 业务逻辑验证：已打卡或正在加载时不处理
    final isCheckedIn = (state.learningData?.isCheckin ?? 0) == 1;
    if (isCheckedIn || state.isLoadingLearning) {
      return;
    }

    var majorId = _ref.read(currentMajorProvider)?.majorId;

    // ✅ 如果没有专业，使用默认专业
    if (majorId == null || majorId.isEmpty) {
      majorId = '524033912737962623';
      print('⚠️ [QuestionBankProvider] 打卡时未选择专业，使用默认专业: $majorId');
    }

    state = state.copyWith(
      isLoadingLearning: true,
      error: null,
      checkInSuccess: false,
    );

    try {
      // ✅ 使用真实的 LearningService
      final service = _ref.read(learningServiceProvider);
      await service.checkIn(professionalId: majorId);

      // ✅ 打卡成功后重新加载学习数据
      await _loadLearningData(majorId);

      state = state.copyWith(checkInSuccess: true, successMessage: '打卡成功');
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '打卡失败，请稍后重试';
      state = state.copyWith(
        isLoadingLearning: false,
        error: errorMsg,
        errorType: ErrorType.network,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoadingLearning: false,
        error: '打卡失败，请稍后重试',
        errorType: ErrorType.network,
      );
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    await loadAllData();
  }

  /// 清除成功标志（避免重复显示Toast）
  void clearSuccessFlag() {
    state = state.copyWith(checkInSuccess: false, successMessage: null);
  }
}

/// Provider 实例
final questionBankProvider =
    StateNotifierProvider<QuestionBankNotifier, QuestionBankState>((ref) {
      return QuestionBankNotifier(ref);
    });
