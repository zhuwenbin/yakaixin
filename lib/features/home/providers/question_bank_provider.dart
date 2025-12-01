import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
        _loadPurchasedGoods(majorId),
        _loadDailyPractice(majorId),
        _loadSkillMock(majorId),
      ]);
      print('✅ [QuestionBankProvider] 所有数据加载完成');
    } catch (e) {
      print('❌ [QuestionBankProvider] 数据加载失败: $e');
      state = state.copyWith(error: '数据加载失败', errorType: ErrorType.network);
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
    } catch (e) {
      state = state.copyWith(
        isLoadingLearning: false,
        error: e.toString(),
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
    } catch (e) {
      state = state.copyWith(
        isLoadingChapters: false,
        error: e.toString(),
        errorType: ErrorType.network,
      );
    }
  }

  /// 加载已购商品
  Future<void> _loadPurchasedGoods(String majorId) async {
    state = state.copyWith(isLoadingPurchased: true);

    try {
      // ✅ 使用真实的 GoodsService
      final service = _ref.read(goodsServiceProvider);
      final response = await service.getGoodsList(
        professionalId: majorId,
        type: '10,8', // 模拟考试、试卷
        isBuyed: 1, // 已购买
      );

      // ✅ 将 GoodsModel 转换为 PurchasedGoodsModel
      final purchasedGoods = response.list.map((goods) {
        return PurchasedGoodsModel(
          id: goods.goodsId?.toString() ?? '',
          name: goods.name ?? '',
          materialCoverPath: goods.materialCoverPath ?? '',
          questionCount:
              int.tryParse(
                goods.tikuGoodsDetails?.questionNum?.toString() ?? '0',
              ) ??
              0,
        );
      }).toList();

      state = state.copyWith(
        purchasedGoods: purchasedGoods,
        isLoadingPurchased: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingPurchased: false,
        error: e.toString(),
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
    } catch (e) {
      state = state.copyWith(
        isLoadingLearning: false,
        error: e.toString(),
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
