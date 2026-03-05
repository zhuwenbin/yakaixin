import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../auth/providers/auth_provider.dart';
import '../services/profile_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../app/config/api_config.dart';
import '../../../core/utils/error_message_mapper.dart';

part 'person_edit_provider.freezed.dart';
part 'person_edit_provider.g.dart';

/// 个人信息编辑状态
@freezed
class PersonEditState with _$PersonEditState {
  const factory PersonEditState({
    @Default('') String studentId,
    @Default('') String nickname,
    @Default('') String avatar,
    @Default(false) bool isLoading,
    @Default(false) bool isUploading,
    String? error,
  }) = _PersonEditState;
}

/// 个人信息编辑 Provider
/// 对应小程序: my/person.vue
@riverpod
class PersonEditNotifier extends _$PersonEditNotifier {
  @override
  PersonEditState build() {
    // ✅ 不在 build 中调用异步方法，改为在页面初始化时调用
    return const PersonEditState();
  }

  /// 初始化用户信息（由页面调用）
  /// 对应小程序 onLoad (Line 56-65)
  Future<void> initUserInfo() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final userJson = storage.getJson(StorageKeys.userInfo);

      if (userJson != null) {
        // 小程序 Line 61: this.form.nickname = info.nickname || info.student_name
        final nickname = userJson['nickname'] as String? ?? userJson['student_name'] as String? ?? '';
        
        // 小程序 Line 62-64: 如果没有头像，使用默认头像
        final avatar = userJson['avatar'] as String? ?? 
                      '408559575579495187/2025/04/23/17453936827177152-1745393682722-52009.png';
        
        state = state.copyWith(
          studentId: userJson['student_id'] as String? ?? '',
          nickname: nickname,
          avatar: avatar,
        );
        
        print('✅ [个人信息编辑] 加载用户信息成功: studentId=${state.studentId}, nickname=${state.nickname}');
      }
    } catch (e) {
      print('❌ [个人信息编辑] 加载用户信息失败: $e');
    }
  }

  /// 更新昵称
  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  /// 上传头像
  /// 对应小程序 updateJobDoc (Line 95-116)
  Future<void> uploadAvatar(String filePath) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      print('📷 [上传头像] 开始: $filePath');
      
      final service = ref.read(profileServiceProvider);
      final avatarPath = await service.uploadImage(filePath);

      print('✅ [上传头像] 成功，路径: $avatarPath');
      
      state = state.copyWith(
        avatar: avatarPath,
        isUploading: false,
      );
    } catch (e) {
      print('❌ [上传头像] 失败: $e');
      
      // ✅ 对应小程序 Line 108-110: catch 显示 '上传文件失败！'
      state = state.copyWith(
        isUploading: false,
        error: '上传文件失败！',  // 与小程序保持一致
      );
    }
  }

  /// 保存个人信息
  /// 对应小程序 save (Line 71)
  Future<bool> save() async {
    // 验证必填项
    if (state.nickname.isEmpty) {
      state = state.copyWith(error: '姓名不能为空');
      return false;
    }

    if (state.avatar.isEmpty) {
      state = state.copyWith(error: '头像不能为空');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(profileServiceProvider);
      await service.changeBasic(
        studentId: state.studentId,
        nickname: state.nickname,
        avatar: state.avatar,
      );

      // 更新本地存储（对应小程序 Line 85-88）
      final storage = ref.read(storageServiceProvider);
      final userJson = storage.getJson(StorageKeys.userInfo);
      if (userJson != null) {
        // 更新用户信息JSON
        final updatedUserJson = {
          ...userJson,
          'nickname': state.nickname,
          'avatar': state.avatar,
        };
        await storage.setJson(StorageKeys.userInfo, updatedUserJson);
        print('💾 [个人信息] 已更新本地存储: nickname=${state.nickname}, avatar=${state.avatar}');

        // 更新 AuthProvider 中的用户状态
        final currentAuthState = ref.read(authProvider);
        if (currentAuthState.user != null) {
          final updatedUser = currentAuthState.user!.copyWith(
            nickname: state.nickname,
            avatar: state.avatar,
          );
          ref.read(authProvider.notifier).state = currentAuthState.copyWith(
            user: updatedUser,
          );
          print('✅ [个人信息] 已同步更新 AuthProvider');
        }
      }

      state = state.copyWith(isLoading: false);
      return true;
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '保存失败，请稍后重试';
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
      );
      return false;
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoading: false,
        error: '保存失败，请稍后重试',
      );
      return false;
    }
  }

  /// 获取完整头像URL
  /// 对应小程序 getAvatar (Line 68-70): this.$xh.completePathNew(this.form.avatar)
  /// 使用 ApiConfig.completeImageUrl() 拼接 OSS 完整 URL；历史数据中的旧 OSS 域名用 convertLegacyOssUrl 转新 OSS
  String getCompleteAvatarUrl() {
    final url = ApiConfig.completeImageUrl(state.avatar);
    return ApiConfig.convertLegacyOssUrl(url);
  }
}
