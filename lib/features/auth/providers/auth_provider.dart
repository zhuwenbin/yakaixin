import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_service.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/widgets/loading_hud.dart';
import '../../../core/utils/toast_util.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

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
  /// 对应小程序: store/index.js - CODELOGIN
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

      // 执行登录成功后的通用处理
      await _handleLoginSuccess(response, phone);

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
      rethrow;
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

      // 执行登录成功后的通用处理
      await _handleLoginSuccess(response, account);

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
      rethrow;
    }
  }

  /// 登录成功通用处理逻辑
  /// 对应小程序: store/index.js:149-191 (LOGIN action)
  Future<void> _handleLoginSuccess(
    dynamic response,
    String? phone,
  ) async {
    // 1. 保存token
    await _storage.setString(StorageKeys.token, response.token);

    // 2. 处理昵称 - 如果没有昵称,设置默认昵称
    // 对应小程序: store/index.js:154-156
    String nickname = response.nickname ?? '';
    final bool needDefaultNickname = nickname.isEmpty;
    if (needDefaultNickname && phone != null && phone.length >= 7) {
      nickname = '牙开心${phone.substring(phone.length - 4)}';
    }

    // 3. 保存用户信息
    final userJson = {
      'student_id': response.studentId,
      'student_name': response.studentName,
      'nickname': nickname, // 使用处理后的昵称
      'avatar': response.avatar,
      'phone': response.phone ?? phone,
      'merchant': response.merchants?.map((m) => m.toJson()).toList(),
      'employee_info': response.employeeInfo?.toJson(),
    };
    await _storage.setJson(StorageKeys.userInfo, userJson);

    // 4. 处理专业信息
    // 对应小程序: index/index.vue:607-608, 331-332, 423-424
    MajorModel? currentMajor;
    if (response.majorId != null && response.majorId != 0 && response.majorName != null) {
      // 有专业信息，保存
      final majorJson = {
        'major_id': response.majorId.toString(),
        'major_name': response.majorName!,
      };
      await _storage.setJson(StorageKeys.majorInfo, majorJson);
      await _storage.setString(StorageKeys.currentMajorId, response.majorId.toString());
      
      currentMajor = MajorModel(
        majorId: response.majorId.toString(),
        majorName: response.majorName!,
      );
    } else {
      // 没有专业或major_id=0，设置默认专业
      // 对应小程序默认: 524033912737962623 - 口腔执业医师
      final defaultMajorJson = {
        'major_id': '524033912737962623',
        'major_name': '医学-口腔执业医师',
      };
      await _storage.setJson(StorageKeys.majorInfo, defaultMajorJson);
      await _storage.setString(StorageKeys.currentMajorId, '524033912737962623');
      
      currentMajor = MajorModel(
        majorId: '524033912737962623',
        majorName: '医学-口腔执业医师',
      );
    }

    // 5. 清除旧的答题缓存
    // 对应小程序: store/index.js:168
    await _storage.remove(StorageKeys.answersList);

    // 6. 创建 UserModel
    final user = UserModel(
      token: response.token,
      studentId: response.studentId,
      studentName: response.studentName,
      nickname: nickname,
      avatar: response.avatar,
      phone: response.phone ?? phone,
      merchants: response.merchants,
      employeeInfo: response.employeeInfo,
      majors: null,
    );

    // 7. 更新状态
    state = state.copyWith(
      user: user,
      currentMajor: currentMajor,
      isLoggedIn: true,
      isLoading: false,
    );

    // 8. 如果需要更新默认昵称,同步到服务器
    // 对应小程序: store/index.js:161-167
    if (needDefaultNickname) {
      // TODO: 调用 changeBasic 接口同步昵称
      // await _authService.updateUserInfo(
      //   id: response.studentId,
      //   nickname: nickname,
      //   avatar: response.avatar,
      // );
    }

    // 9. 活动记录 (TODO: 如需要)
    // 对应小程序: store/index.js:169-188 (activateuserRecord, shareRecord)
  }

  /// ✅ Mock 数据登录 - 调试模式，直接使用 Mock 数据
  /// 按照用户要求: 登录调试使用Mock数据直转Model
  Future<void> loginWithMockData(Map<String, dynamic> mockData) async {
    try {
      state = state.copyWith(isLoading: true);
      LoadingHUD.show('登录中...');

      // 1. 保存token
      final token = mockData['token'] as String;
      await _storage.setString(StorageKeys.token, token);

      // 2. 处理昵称
      final nickname = mockData['nickname'] as String? ?? '牙开心用户';

      // 3. 保存用户信息
      final userJson = {
        'student_id': mockData['student_id'],
        'student_name': mockData['student_name'],
        'nickname': nickname,
        'avatar': mockData['avatar'],
        'phone': mockData['phone'],
      };
      await _storage.setJson(StorageKeys.userInfo, userJson);

      // 4. 处理专业信息
      final majorId = mockData['major_id']?.toString() ?? '524033912737962623';
      final majorName = mockData['major_name'] as String? ?? '医学-口腔执业医师';
      
      final majorJson = {
        'major_id': majorId,
        'major_name': majorName,
      };
      await _storage.setJson(StorageKeys.majorInfo, majorJson);
      await _storage.setString(StorageKeys.currentMajorId, majorId);
      
      final currentMajor = MajorModel(
        majorId: majorId,
        majorName: majorName,
      );

      // 5. 清除旧的答题缓存
      await _storage.remove(StorageKeys.answersList);

      // 6. 创建 UserModel
      final user = UserModel(
        token: token,
        studentId: mockData['student_id'] as String,
        studentName: mockData['student_name'] as String,
        nickname: nickname,
        avatar: mockData['avatar'] as String?,
        phone: mockData['phone'] as String?,
        merchants: null,
        employeeInfo: null,
        majors: null,
      );

      // 7. 更新状态
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
      ToastUtil.error('登录失败: $e');
      rethrow;
    }
  }

  /// 微信登录
  /// 对应小程序: store/index.js - LOGIN
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

      // 执行登录成功后的通用处理
      await _handleLoginSuccess(response, response.phone);

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
      rethrow;
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
