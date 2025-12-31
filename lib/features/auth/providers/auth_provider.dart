import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yakaixin_app/core/utils/error_handler.dart';
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

    print('🔍 [启动恢复] 开始从本地存储恢复用户数据...');
    print('📦 [userJson] $userJson');
    print('📦 [majorJson] $majorJson');
    print(
      '🔑 [token] ${token != null ? "存在(${token.substring(0, 20)}...)" : "不存在"}',
    );

    if (userJson != null && token != null) {
      try {
        final user = UserModel.fromJson({...userJson, 'token': token});
        MajorModel? major;

        if (majorJson != null) {
          print('🎯 [专业恢复] majorJson存在，开始解析...');
          print('   - major_id类型: ${majorJson['major_id'].runtimeType}');
          print('   - major_id值: ${majorJson['major_id']}');
          print('   - major_name: ${majorJson['major_name']}');

          major = MajorModel.fromJson(majorJson);
          print('✅ [专业恢复] 解析成功: ID=${major.majorId}, Name=${major.majorName}');
        } else {
          print('⚠️ [专业恢复] majorJson为null');
        }

        state = state.copyWith(
          user: user,
          currentMajor: major,
          isLoggedIn: true,
        );

        print('✅ [启动恢复] 用户数据恢复完成');
        print('   - 用户ID: ${user.studentId}');
        print('   - 专业ID: ${major?.majorId ?? "未设置"}');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      } catch (e, stackTrace) {
        // 数据格式错误,清空
        print('❌ [启动恢复] 数据解析失败: $e');
        print('📍 堆栈: $stackTrace');
        await logout();
      }
    } else {
      print('⚠️ [启动恢复] 未找到登录信息（userJson或token为null）');
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
      // ✅ 统一错误处理
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      final errorMsg = ErrorHandler.handle(e);
      ToastUtil.error(errorMsg);
      print('⚠️ [验证码登录] 向用户显示错误: $errorMsg');
      rethrow;
    }
  }

  /// 发送验证码
  ///
  /// [phone] 手机号
  /// [scene] 场景类型：2-登录, 3-修改密码
  Future<void> sendVerifyCode(String phone, {int scene = 2}) async {
    try {
      LoadingHUD.show('发送中...');
      await _authService.sendVerifyCode(phone: phone, scene: scene);
      LoadingHUD.dismiss();
      ToastUtil.success('验证码已发送');
    } catch (e) {
      // ✅ 统一错误处理
      LoadingHUD.dismiss();
      final errorMsg = ErrorHandler.handle(e);
      ToastUtil.error(errorMsg);
      print('⚠️ [发送验证码] 向用户显示错误: $errorMsg');
      rethrow;
    }
  }

  /// 密码登录
  /// 对应后台新接口: POST /c/student/login
  Future<void> loginWithPhone({
    required String account,
    required String password,
    String? majorId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      LoadingHUD.show('登录中...');

      // ✅ 使用新的密码登录接口
      final response = await _authService.loginWithPassword(
        account: account,
        password: password,
        majorId: majorId,
      );

      // 执行登录成功后的通用处理
      await _handleLoginSuccess(response, account);

      LoadingHUD.dismiss();
      ToastUtil.success('登录成功');
    } catch (e) {
      // ✅ 统一错误处理
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      final errorMsg = ErrorHandler.handle(e);
      ToastUtil.error(errorMsg);
      print('⚠️ [密码登录] 向用户显示错误: $errorMsg');
      rethrow;
    }
  }

  /// 登录成功通用处理逻辑
  /// 对应小程序: store/index.js:149-191 (LOGIN action)
  Future<void> _handleLoginSuccess(dynamic response, String? phone) async {
    // 1. 保存token
    await _storage.setString(StorageKeys.token, response.token);

    // 2. 处理昵称 - 如果没有昵称,设置默认昵称
    // 对应小程序: store/index.js:154-156
    String nickname = response.nickname ?? '';
    final bool needDefaultNickname = nickname.isEmpty;
    if (needDefaultNickname && phone != null && phone.length >= 7) {
      nickname = '牙开心${phone.substring(phone.length - 4)}';
    }

    // 3. 保存用户信息（保存完整的登录响应数据）
    final userJson = {
      'student_id': response.studentId,
      'student_name': response.studentName,
      'nickname': nickname, // 使用处理后的昵称
      'avatar': response.avatar,
      'phone': response.phone ?? phone,
      'merchant': response.merchants?.map((m) => m.toJson()).toList(),
      'employee_info': response.employeeInfo?.toJson(),
      // ✅ 保存完整的登录响应字段
      'major_id': response.majorId?.toString(),
      'major_name': response.majorName,
      'employee_id': response.employeeId?.toString(),
      'is_real_name': response.isRealName?.toString(),
      'promoter_id': response.promoterId,
      'promoter_type': response.promoterType?.toString(),
      'is_new': response.isNew?.toString(),
    };
    await _storage.setJson(StorageKeys.userInfo, userJson);

    // ✅ 同时单独保存 studentId，供 ApiInterceptor 使用
    await _storage.setString(StorageKeys.studentId, response.studentId);
    print('💾 [存储] 已保存 studentId: ${response.studentId}');

    // ⚠️ 调试：验证保存是否成功
    final savedStudentId = _storage.getString(StorageKeys.studentId);
    final savedUserInfo = _storage.getJson(StorageKeys.userInfo);
    print('✅ [验证保存] 立即读取 studentId: $savedStudentId');
    print('✅ [验证保存] 立即读取 userInfo: $savedUserInfo');

    // 4. 处理专业信息
    // 对应小程序: index/index.vue:607-608, 331-332, 423-424
    MajorModel? currentMajor;

    print('\n🔍 [登录响应] 处理专业信息...');
    print(
      '📍 [response.majorId] ${response.majorId} (类型: ${response.majorId.runtimeType})',
    );
    print('📍 [response.majorName] ${response.majorName}');

    // ✅ 修复: majorId可能是String或int，需要安全判断
    bool hasMajorId = false;
    if (response.majorId != null) {
      if (response.majorId is int) {
        hasMajorId = response.majorId > 0;
      } else if (response.majorId is String) {
        final majorIdStr = response.majorId as String;
        hasMajorId = majorIdStr.isNotEmpty && majorIdStr != '0';
      }
    }

    if (hasMajorId && response.majorName != null) {
      // 有专业信息，保存
      print(
        '✅ [专业信息] 登录返回了有效专业ID: ${response.majorId}, 专业名: ${response.majorName}',
      );
      final majorJson = {
        'major_id': response.majorId.toString(),
        'major_name': response.majorName!,
      };
      await _storage.setJson(StorageKeys.majorInfo, majorJson);
      await _storage.setString(
        StorageKeys.currentMajorId,
        response.majorId.toString(),
      );

      print('💾 [存储] majorJson: $majorJson');

      currentMajor = MajorModel(
        majorId: response.majorId.toString(),
        majorName: response.majorName!,
      );
    } else {
      // 没有专业或major_id无效，设置默认专业
      // 对应小程序默认: 524033912737962623 - 口腔执业医师
      print('⚠️ [专业信息] 登录未返回有效专业ID (majorId=${response.majorId})，使用默认专业');
      final defaultMajorJson = {
        'major_id': '524033912737962623',
        'major_name': '医学-口腔执业医师',
      };
      await _storage.setJson(StorageKeys.majorInfo, defaultMajorJson);
      await _storage.setString(
        StorageKeys.currentMajorId,
        '524033912737962623',
      );

      print('💾 [存储] defaultMajorJson: $defaultMajorJson');

      currentMajor = MajorModel(
        majorId: '524033912737962623',
        majorName: '医学-口腔执业医师',
      );
    }

    print(
      '✅ [专业信息] 最终currentMajor: ID=${currentMajor.majorId}, Name=${currentMajor.majorName}',
    );
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

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

  /// 重置密码
  Future<void> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    try {
      LoadingHUD.show('重置中...');
      await _authService.resetPassword(
        phone: phone,
        code: code,
        newPassword: newPassword,
      );
      LoadingHUD.dismiss();
      ToastUtil.success('密码重置成功');
    } catch (e) {
      // ✅ 统一错误处理
      LoadingHUD.dismiss();
      final errorMsg = ErrorHandler.handle(e);
      ToastUtil.error(errorMsg);
      rethrow;
    }
  }

  /// 修改密码（通过验证码）
  Future<void> changePassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    try {
      LoadingHUD.show('修改中...');
      await _authService.changePassword(
        phone: phone,
        code: code,
        newPassword: newPassword,
      );
      LoadingHUD.dismiss();
      ToastUtil.success('密码修改成功');
    } catch (e) {
      // ✅ 统一错误处理
      LoadingHUD.dismiss();
      final errorMsg = ErrorHandler.handle(e);
      ToastUtil.error(errorMsg);
      rethrow;
    }
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

      // ✅ 同时单独保存 studentId
      await _storage.setString(
        StorageKeys.studentId,
        mockData['student_id'] as String,
      );
      print('💾 [Mock存储] 已保存 studentId: ${mockData['student_id']}');

      // ⚠️ 调试：验证保存是否成功
      final savedStudentId = _storage.getString(StorageKeys.studentId);
      final savedUserInfo = _storage.getJson(StorageKeys.userInfo);
      print('✅ [Mock验证保存] 立即读取 studentId: $savedStudentId');
      print('✅ [Mock验证保存] 立即读取 userInfo: $savedUserInfo');

      // 4. 处理专业信息
      final majorId = mockData['major_id']?.toString() ?? '524033912737962623';
      final majorName = mockData['major_name'] as String? ?? '医学-口腔执业医师';

      final majorJson = {'major_id': majorId, 'major_name': majorName};
      await _storage.setJson(StorageKeys.majorInfo, majorJson);
      await _storage.setString(StorageKeys.currentMajorId, majorId);

      final currentMajor = MajorModel(majorId: majorId, majorName: majorName);

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
      // ✅ 统一错误处理
      state = state.copyWith(isLoading: false);
      LoadingHUD.dismiss();
      final errorMsg = ErrorHandler.handle(e);
      ToastUtil.error(errorMsg);
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
