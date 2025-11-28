import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/question_bank_model.dart';
import '../services/question_bank_service.dart';
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
  network,    // 网络错误
  dataEmpty,  // 数据为空
  unknown,    // 未知错误
}

// ============================================
// ViewModel - 业务逻辑处理
// ============================================

class QuestionBankNotifier extends StateNotifier<QuestionBankState> {
  final QuestionBankService _service;
  final Ref _ref;

  QuestionBankNotifier(this._service, this._ref) 
      : super(const QuestionBankState());

  /// 加载所有数据
  Future<void> loadAllData() async {
    // 获取当前专业ID
    final majorId = _ref.read(currentMajorProvider)?.majorId;
    if (majorId == null || majorId.isEmpty) {
      state = state.copyWith(
        error: '请先选择专业',
        errorType: ErrorType.dataEmpty,
      );
      return;
    }

    // 并行加载所有数据
    await Future.wait([
      _loadLearningData(majorId),
      _loadChapters(majorId),
      _loadPurchasedGoods(majorId),
      _loadDailyPractice(majorId),
      _loadSkillMock(majorId),
    ]);
  }

  /// 加载学习数据
  Future<void> _loadLearningData(String majorId) async {
    state = state.copyWith(isLoadingLearning: true, error: null);
    
    try {
      final learningData = await _service.getLearningData(
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
      final chapters = await _service.getChapterList(
        professionalId: majorId,
      );
      
      state = state.copyWith(
        chapters: chapters,
        isLoadingChapters: false,
      );
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
      final goods = await _service.getPurchasedGoods(
        professionalId: majorId,
      );
      
      state = state.copyWith(
        purchasedGoods: goods,
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
      final dailyPractice = await _service.getDailyPractice(
        professionalId: majorId,
      );
      
      state = state.copyWith(dailyPractice: dailyPractice);
    } catch (e) {
      print('加载每日一测失败: $e');
      // 每日一测失败不影响整体页面
    }
  }

  /// 加载技能模拟
  Future<void> _loadSkillMock(String majorId) async {
    // 只有特定专业显示技能模拟
    final showSkillMock = majorId == '524033912737962623' || 
                          majorId == '524033614019566207';
    
    if (!showSkillMock) {
      state = state.copyWith(skillMock: null);
      return;
    }
    
    try {
      final skillMock = await _service.getSkillMock(
        professionalId: majorId,
      );
      
      state = state.copyWith(skillMock: skillMock);
    } catch (e) {
      print('加载技能模拟失败: $e');
      // 技能模拟失败不影响整体页面
    }
  }

  /// 打卡
  Future<void> checkIn() async {
    // ✅ 业务逻辑验证：已打卡或正在加载时不处理
    final isCheckedIn = (state.learningData?.isCheckin ?? 0) == 1;
    if (isCheckedIn || state.isLoadingLearning) {
      return;
    }
    
    final majorId = _ref.read(currentMajorProvider)?.majorId;
    if (majorId == null || majorId.isEmpty) {
      state = state.copyWith(
        error: '请先选择专业',
        errorType: ErrorType.dataEmpty,
      );
      return;
    }
    
    state = state.copyWith(
      isLoadingLearning: true,
      error: null,
      checkInSuccess: false,
    );
    
    try {
      final updatedLearningData = await _service.checkIn(
        professionalId: majorId,
      );
      
      state = state.copyWith(
        learningData: updatedLearningData,
        isLoadingLearning: false,
        checkInSuccess: true,
        successMessage: '打卡成功',
      );
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
    state = state.copyWith(
      checkInSuccess: false,
      successMessage: null,
    );
  }
}

/// Provider 实例
final questionBankProvider = StateNotifierProvider<QuestionBankNotifier, QuestionBankState>((ref) {
  return QuestionBankNotifier(
    ref.read(questionBankServiceProvider),
    ref,
  );
});
