import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/models/user_model.dart'; // 导入 MajorModel
import '../../auth/providers/auth_provider.dart';

/// 专业状态
class MajorState {
  final List<dynamic> majors;
  final bool isLoading;
  final String? error;

  MajorState({
    this.majors = const [],
    this.isLoading = false,
    this.error,
  });

  MajorState copyWith({
    List<dynamic>? majors,
    bool? isLoading,
    String? error,
  }) {
    return MajorState(
      majors: majors ?? this.majors,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 专业Provider
class MajorNotifier extends StateNotifier<MajorState> {
  final Ref ref;
  final DioClient _dioClient;
  final StorageService _storage;

  MajorNotifier({
    required this.ref,
    required DioClient dioClient,
    required StorageService storage,
  })  : _dioClient = dioClient,
        _storage = storage,
        super(MajorState());

  /// 加载专业列表
  /// 对应小程序: api/index.js:299-308 getMajor
  Future<void> loadMajors() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dioClient.get(
        '/c/teaching/mapping/tree',
        queryParameters: {
          'code': 'professional',
          'is_auth': 2,
          'is_usable': 1,
          'professional_ids': '',
          'is_standard': 0,
        },
      );

      final data = response.data['data'] as List<dynamic>?  ?? [];
      state = state.copyWith(
        majors: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  /// 保存专业选择
  /// 对应小程序: api/index.js:310-323 checkMajor
  Future<void> saveMajor({
    required String majorId,
    required String majorName,
  }) async {
    try {
      final authState = ref.read(authProvider);
      final studentId = authState.user?.studentId;

      if (studentId == null) {
        throw Exception('用户未登录');
      }

      // 调用API保存专业
      await _dioClient.put(
        '/c/student',
        data: {
          'id': studentId,
          'major_id': majorId,
        },
      );

      // 保存到本地存储
      final majorJson = {
        'major_id': majorId,
        'major_name': majorName,
      };
      await _storage.setJson(StorageKeys.majorInfo, majorJson);
      await _storage.setString(StorageKeys.currentMajorId, majorId);

      // 更新 authProvider 中的 currentMajor
      final currentMajor = MajorModel(
        majorId: majorId,
        majorName: majorName,
      );
      
      // 更新 authProvider 中的 currentMajor
      final authNotifier = ref.read(authProvider.notifier);
      final currentAuthState = ref.read(authProvider);
      authNotifier.state = currentAuthState.copyWith(
        currentMajor: currentMajor,
      );

      // 对应小程序的setTimeInfo调用（设置章节数为3000）
      // 延迟1秒后调用
      Future.delayed(Duration(seconds: 1), () async {
        try {
          await _dioClient.post(
            '/c/student/save/attr',
            data: {
              'chapter_number': '3000',
            },
          );
        } catch (e) {
          // 忽略错误
          print('设置章节数失败: $e');
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}

/// 专业Provider实例
final majorProvider = StateNotifierProvider<MajorNotifier, MajorState>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final storage = ref.watch(storageServiceProvider);

  return MajorNotifier(
    ref: ref,
    dioClient: dioClient,
    storage: storage,
  );
});
