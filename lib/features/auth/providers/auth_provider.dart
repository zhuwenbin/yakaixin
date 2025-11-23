import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/widgets/loading_hud.dart';
import '../../../core/utils/toast_util.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'dart:convert';

/// 认证状态
class AuthState {
  final UserModel? user;
  final MajorModel? currentMajor;
  final bool isLoggedIn;
  final bool isLoading;

  AuthState({
    this.user,
    this.currentMajor,
    this.isLoggedIn = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    UserModel? user,
    MajorModel? currentMajor,
    bool? isLoggedIn,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      currentMajor: currentMajor ?? this.currentMajor,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 认证Provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final StorageService _storage;

  AuthNotifier(this._authService, this._storage) : super(AuthState()) {
    _loadUserFromStorage();
  }

  /// 从本地存储加载用户信息
  Future<void> _loadUserFromStorage() async {
    final userJson = _storage.getJson(StorageKeys.userInfo);
    final majorJson = _storage.getJson(StorageKeys.majorInfo);
    final token = _storage.getString(StorageKeys.token);

    if (userJson != null && token != null) {
      try {
        final user = UserModel.fromJson({...userJson, 'token': token});
        final major = majorJson != null ? MajorModel.fromJson(majorJson) : null;

        state = state.copyWith(
          user: user,
          currentMajor: major,
          isLoggedIn: true,
        );
      } catch (e) {
        // 数据格式错误,清空
        await logout();
      }
    }
  }

  /// 验证码登录
  Future<void> loginWithSms({
    required String phone,
    required String code,
    String? majorId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      LoadingHUD.show('登录中...');

      final response = await _authService.loginWithSms(
        phone: phone,
        code: code,
        majorId: majorId,
      );

      // 保存token
      await _storage.setString(StorageKeys.token, response.token);

      // 保存用户信息
      final userJson = {
        'student_id': response.studentId,
        'student_name': response.studentName,
        'nickname': response.nickname,
        'avatar': response.avatar,
        'phone': response.phone,
        'merchant': response.merchants?.map((m) => m.toJson()).toList(),
        'employee_info': response.employeeInfo?.toJson(),
      };
      await _storage.setJson(StorageKeys.userInfo, userJson);

      // 保存专业信息 (如果有,且majorId不为0)
      if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
        final majorJson = {
          'major_id': response.majorId.toString(),  // 转换为String存储(支持int/String/num)
          'major_name': response.majorName!,
        };
        await _storage.setJson(StorageKeys.majorInfo, majorJson);
        await _storage.setString(StorageKeys.currentMajorId, response.majorId.toString());
      }

      // 创建UserModel
      final user = UserModel(
        token: response.token,
        studentId: response.studentId,
        studentName: response.studentName,
        nickname: response.nickname,
        avatar: response.avatar,
        phone: response.phone,
        merchants: response.merchants,
        employeeInfo: response.employeeInfo,
        majors: null, // 登录响应不包含major列表
      );

      // 创建MajorModel (如果有,且majorId不为0)
      MajorModel? currentMajor;
      if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
        currentMajor = MajorModel(
          majorId: response.majorId.toString(),  // 转换为String(支持int/String/num)
          majorName: response.majorName!,
        );
      }

      state = state.copyWith(
        user: user,
        currentMajor: currentMajor,
        isLoggedIn: true,
        isLoading: false,
      );

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
    }
  }

  /// 发送验证码
  Future<void> sendVerifyCode(String phone) async {
    try {
      LoadingHUD.show('发送中...');
      await _authService.sendVerifyCode(phone: phone);
      LoadingHUD.dismiss();
      ToastUtil.success('验证码已发送');
    } catch (e) {
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
      rethrow;
    }
  }

  /// 手机号登录 (用于测试,小程序主要用微信登录)
  Future<void> loginWithPhone({
    required String account,
    required String password,
    String? majorId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      LoadingHUD.show('登录中...');

      // 使用固定的wxopenid (测试用)
      final response = await _authService.login(
        wxopenid: 'test_wxopenid',
        account: account,
        password: password,
        majorId: majorId,
      );

      // 保存token
      await _storage.setString(StorageKeys.token, response.token);

      // 保存用户信息
      final userJson = {
        'student_id': response.studentId,
        'student_name': response.studentName,
        'nickname': response.nickname,
        'avatar': response.avatar,
        'phone': response.phone,
        'merchant': response.merchants?.map((m) => m.toJson()).toList(),
        'employee_info': response.employeeInfo?.toJson(),
      };
      await _storage.setJson(StorageKeys.userInfo, userJson);

      // 保存专业信息 (如果有,且majorId不为0)
      if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
        final majorJson = {
          'major_id': response.majorId.toString(),  // 转换为String存储(支持int/String/num)
          'major_name': response.majorName!,
        };
        await _storage.setJson(StorageKeys.majorInfo, majorJson);
        await _storage.setString(StorageKeys.currentMajorId, response.majorId.toString());
      }

      // 创建UserModel
      final user = UserModel(
        token: response.token,
        studentId: response.studentId,
        studentName: response.studentName,
        nickname: response.nickname,
        avatar: response.avatar,
        phone: response.phone,
        merchants: response.merchants,
        employeeInfo: response.employeeInfo,
        majors: null,
      );

      // 创建MajorModel (如果有,且majorId不为0)
      MajorModel? currentMajor;
      if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
        currentMajor = MajorModel(
          majorId: response.majorId.toString(),  // 转换为String(支持int/String/num)
          majorName: response.majorName!,
        );
      }

      state = state.copyWith(
        user: user,
        currentMajor: currentMajor,
        isLoggedIn: true,
        isLoading: false,
      );

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
    }
  }

  /// 微信登录
  Future<void> loginWithWechat({
    required String wxopenid,
    String? majorId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      LoadingHUD.show('登录中...');

      final response = await _authService.login(
        wxopenid: wxopenid,
        majorId: majorId,
      );

      // 保存token
      await _storage.setString(StorageKeys.token, response.token);

      // 保存用户信息
      final userJson = {
        'student_id': response.studentId,
        'student_name': response.studentName,
        'nickname': response.nickname,
        'avatar': response.avatar,
        'phone': response.phone,
        'merchant': response.merchants?.map((m) => m.toJson()).toList(),
        'employee_info': response.employeeInfo?.toJson(),
      };
      await _storage.setJson(StorageKeys.userInfo, userJson);

      // 保存专业信息 (如果有,且majorId不为0)
      if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
        final majorJson = {
          'major_id': response.majorId.toString(),  // 转换为String存储(支持int/String/num)
          'major_name': response.majorName!,
        };
        await _storage.setJson(StorageKeys.majorInfo, majorJson);
        await _storage.setString(StorageKeys.currentMajorId, response.majorId.toString());
      }

      // 创建UserModel
      final user = UserModel(
        token: response.token,
        studentId: response.studentId,
        studentName: response.studentName,
        nickname: response.nickname,
        avatar: response.avatar,
        phone: response.phone,
        merchants: response.merchants,
        employeeInfo: response.employeeInfo,
        majors: null,
      );

      // 创建MajorModel (如果有,且majorId不为0)
      MajorModel? currentMajor;
      if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
        currentMajor = MajorModel(
          majorId: response.majorId.toString(),  // 转换为String(支持int/String/num)
          majorName: response.majorName!,
        );
      }

      state = state.copyWith(
        user: user,
        currentMajor: currentMajor,
        isLoggedIn: true,
        isLoading: false,
      );

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
    }
  }

  /// 切换专业
  Future<void> switchMajor(MajorModel major) async {
    await _storage.setJson(StorageKeys.majorInfo, major.toJson());
    await _storage.setString(StorageKeys.currentMajorId, major.majorId);
    
    state = state.copyWith(currentMajor: major);
    ToastUtil.success('已切换到${major.majorName}');
  }

  /// 登出
  Future<void> logout() async {
    await _storage.remove(StorageKeys.token);
    await _storage.remove(StorageKeys.userInfo);
    await _storage.remove(StorageKeys.majorInfo);
    await _storage.remove(StorageKeys.currentMajorId);

    state = AuthState();
    ToastUtil.show('已退出登录');
  }
}

/// AuthProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final storage = ref.read(storageServiceProvider);
  return AuthNotifier(authService, storage);
});

/// 是否已登录Provider (便捷访问)
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

/// 当前用户Provider (便捷访问)
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

/// 当前专业Provider (便捷访问)
final currentMajorProvider = Provider<MajorModel?>((ref) {
  return ref.watch(authProvider).currentMajor;
});
