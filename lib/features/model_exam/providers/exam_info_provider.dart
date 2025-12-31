import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../exam/services/exam_service.dart';
import '../models/exam_info_detail_model.dart';

part 'exam_info_provider.freezed.dart';
part 'exam_info_provider.g.dart';

/// 模考详情页状态
@freezed
class ExamInfoState with _$ExamInfoState {
  const factory ExamInfoState({
    ExamInfoDetailModel? detail,
    @Default(false) bool isLoading,
    String? error,
    String? productId, // 保存原始 productId，用于重新加载
    String? selectedMockExamId, // 保存选中的模考ID
  }) = _ExamInfoState;
}

/// 模考详情页 Provider
/// 对应小程序: examInfo.vue
@riverpod
class ExamInfoNotifier extends _$ExamInfoNotifier {
  @override
  ExamInfoState build() => const ExamInfoState();

  /// 加载模考详情
  /// 对应小程序: examInfo.vue getList() Line 209-232
  Future<void> loadExamInfo({
    required String productId,
    String? mockExamId,
    String? professionalId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(examServiceProvider);
      final detail = await service.getExaminfoDetail(
        productId: productId,
        mockExamId: mockExamId,
        professionalId: professionalId,
      );

      state = state.copyWith(
        detail: detail,
        productId: productId, // 保存 productId
        selectedMockExamId: mockExamId, // 保存选中的模考ID
        isLoading: false,
      );

      print('✅ [ExamInfoProvider] 模考详情加载成功');
    } on DioException catch (e) {
      final errorMsg = e.error?.toString() ?? '加载模考详情失败，请稍后重试';
      state = state.copyWith(isLoading: false, error: errorMsg);
      print('❌ [ExamInfoProvider] 加载失败: $errorMsg');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载模考详情失败: $e',
      );
      print('❌ [ExamInfoProvider] 加载失败: $e');
    }
  }

  /// 模考报名
  /// 对应小程序: examInfo.vue sinUp() Line 133-143
  Future<bool> signup(String examId) async {
    try {
      final service = ref.read(examServiceProvider);
      await service.mockexamSignup(examId: examId);

      // 重新加载数据
      final currentState = state;
      if (currentState.productId != null && currentState.detail != null) {
        // 延迟100ms后重新加载（对应小程序 Line 139-141）
        await Future.delayed(const Duration(milliseconds: 100));
        await loadExamInfo(
          productId: currentState.productId!,
          mockExamId: currentState.selectedMockExamId,
          professionalId: currentState.detail!.mockExam.professionalId,
        );
      }

      print('✅ [ExamInfoProvider] 报名成功');
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      print('❌ [ExamInfoProvider] 报名失败: $e');
      return false;
    }
  }

  /// 补考报名
  /// 对应小程序: examInfo.vue sinUp() Line 145-153 (已注释)
  Future<bool> makeupSignup(String examRoundId) async {
    try {
      final service = ref.read(examServiceProvider);
      await service.makeupSignup(examRoundId: examRoundId);

      // 重新加载数据
      final currentState = state;
      if (currentState.productId != null && currentState.detail != null) {
        await loadExamInfo(
          productId: currentState.productId!,
          mockExamId: currentState.selectedMockExamId,
          professionalId: currentState.detail!.mockExam.professionalId,
        );
      }

      print('✅ [ExamInfoProvider] 补考报名成功');
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      print('❌ [ExamInfoProvider] 补考报名失败: $e');
      return false;
    }
  }
}

