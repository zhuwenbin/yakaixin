import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../services/profile_service.dart';

part 'settings_provider.freezed.dart';
part 'settings_provider.g.dart';

/// 设置状态
@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(20) int chapterQuestionNumber, // 章节练习每次题目数
    @Default(false) bool isLoading,
    String? error,
  }) = _SettingsState;
}

/// 设置 Provider
/// 对应小程序: userInfo/set.vue
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    // ✅ 初始化时从本地存储加载
    // ⚠️ 注意：不能在 build() 中访问 state，需要直接返回包含加载值的状态
    final storage = ref.read(storageServiceProvider);
    final savedNumber = storage.getInt(StorageKeys.chapterQuestionNumber);
    
    if (savedNumber != null) {
      print('📦 [SettingsProvider] 从本地存储加载: chapterQuestionNumber=$savedNumber');
      return SettingsState(chapterQuestionNumber: savedNumber);
    }
    
    return const SettingsState();
  }

  /// 加载设置（从服务器）
  /// 对应小程序: set.vue onLoad() → getExamTime()
  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(profileServiceProvider);
      final config = await service.getExamTime();

      // ✅ 小程序返回: data.data.chapter_number
      final chapterNumberStr = config['chapter_number']?.toString() ?? '20';
      final chapterNumber = int.tryParse(chapterNumberStr) ?? 20;

      // 保存到本地存储
      final storage = ref.read(storageServiceProvider);
      await storage.setInt(StorageKeys.chapterQuestionNumber, chapterNumber);

      state = state.copyWith(
        chapterQuestionNumber: chapterNumber,
        isLoading: false,
      );

      print('✅ [SettingsProvider] 设置加载成功: chapterQuestionNumber=$chapterNumber');
    } on DioException catch (e) {
      final errorMsg = e.error?.toString() ?? '加载设置失败，请稍后重试';
      state = state.copyWith(isLoading: false, error: errorMsg);
      print('❌ [SettingsProvider] 加载设置失败: $errorMsg');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载设置失败: $e',
      );
      print('❌ [SettingsProvider] 加载设置失败: $e');
    }
  }

  /// 保存章节练习题目数设置
  /// 对应小程序: set.vue setQuestion() → setTimeInfo()
  Future<bool> saveChapterQuestionNumber(int number) async {
    if (number <= 0) {
      state = state.copyWith(error: '请输入正确的数字！');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(profileServiceProvider);
      await service.setTimeInfo(chapterNumber: number.toString());

      // 保存到本地存储
      final storage = ref.read(storageServiceProvider);
      await storage.setInt(StorageKeys.chapterQuestionNumber, number);

      state = state.copyWith(
        chapterQuestionNumber: number,
        isLoading: false,
      );

      print('✅ [SettingsProvider] 设置保存成功: chapterQuestionNumber=$number');
      return true;
    } on DioException catch (e) {
      final errorMsg = e.error?.toString() ?? '保存设置失败，请稍后重试';
      state = state.copyWith(isLoading: false, error: errorMsg);
      print('❌ [SettingsProvider] 保存设置失败: $errorMsg');
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '保存设置失败: $e',
      );
      print('❌ [SettingsProvider] 保存设置失败: $e');
      return false;
    }
  }
}

