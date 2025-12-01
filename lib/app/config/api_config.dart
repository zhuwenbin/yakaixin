import 'package:flutter/foundation.dart';
import '../constants/storage_keys.dart';
import '../../core/storage/storage_service.dart';

/// API配置
/// 对应小程序: src/modules/jintiku/config.js, .env.production
class ApiConfig {
  // 环境配置
  // dev: 开发环境(本地代理) + 网络调试
  // test: 测试环境 + 网络调试
  // prod: 生产环境
  static const String env = String.fromEnvironment('ENV', defaultValue: 'prod');
  
  // 运行时环境切换 (用于调试)
  // ✅ 优化 1: 默认使用真实 API (生产环境)
  static String _runtimeEnv = env;
  
  // ✅ 优化 3: 保存 StorageService 引用，用于保存/恢复环境
  static StorageService? _storage;
  
  /// 初始化 ApiConfig (从本地存储恢复环境)
  /// ✅ Debug 模式下记录当前环境，热重启后不需要重新选择
  static void init(StorageService storage) {
    _storage = storage;
    
    // 在 Debug 模式下，尝试从本地存储恢复上次的环境
    if (isDebug) {
      final savedEnv = storage.getString(StorageKeys.debugEnv);
      if (savedEnv != null && (savedEnv == 'prod' || savedEnv == 'test' || savedEnv == 'dev')) {
        _runtimeEnv = savedEnv;
        print('✅ 从本地存储恢复环境: $savedEnv');
      } else {
        // 首次启动，保存默认环境
        storage.setString(StorageKeys.debugEnv, _runtimeEnv);
        print('✅ 保存默认环境: $_runtimeEnv');
      }
    }
  }
  
  /// 是否为 Debug 模式
  static bool get isDebug => kDebugMode;
  
  /// 获取当前环境
  static String get currentEnv => _runtimeEnv;
  
  /// 切换环境 (仅在 Debug 模式下可用)
  /// ✅ 优化 2: 切换环境后退出登录，清除登录状态和用户数据
  /// ✅ 优化 3: 保存环境到本地存储
  static void switchEnv(String newEnv) {
    if (isDebug && (newEnv == 'prod' || newEnv == 'test' || newEnv == 'dev')) {
      _runtimeEnv = newEnv;
      
      // ✅ 保存环境到本地存储
      if (_storage != null) {
        _storage!.setString(StorageKeys.debugEnv, newEnv);
        print('✅ 保存环境到本地存储: $newEnv');
        
        // ✅ 切换环境后清除登录状态和用户数据
        _storage!.remove(StorageKeys.token);
        _storage!.remove(StorageKeys.userInfo);
        _storage!.remove(StorageKeys.studentId);
        _storage!.remove(StorageKeys.majorInfo);
        _storage!.remove(StorageKeys.currentMajorId);
        print('✅ 已清除登录状态和用户数据');
      }
    }
  }
  
  // 基础URL
  static const String baseUrlProd = 'https://yakaixin.yunsop.com/api';
  static const String baseUrlTest = 'https://yakaixin-test.yunsop.com/api'; // ✅ 添加 https://
  static const String baseUrlDev = '/api'; // 本地代理
  
  static String get baseUrl {
    switch (_runtimeEnv) {
      case 'prod':
        return baseUrlProd;
      case 'test':
        return baseUrlTest;
      case 'dev':
        return baseUrlDev;
      default:
        return baseUrlProd;
    }
  }
  
  // Basic认证 (对应小程序 VUE_APP_BASICKEY/VUE_APP_BASICVALUE)
  static const String basicKey = 's2b2c2b';
  static const String basicValue = 'qOEffNlL1H5Qh!wA@ekN%ry7v521Nz97';
  
  // 平台配置 (对应小程序 VUE_APP_PLATFORMID等)
  static const String platformId = '409974729504527968';
  static const String merchantId = '408559575579495187';
  static const String brandId = '408559632588540691';
  static const String channelId = '515957991174840396';
  static const String extendUid = '508948528815416786';
  
  // 微信配置 (对应小程序 app_id)
  // 注意: 这是微信小程序的AppId,微信开放平台AppId在AppConstants中
  static const String wechatMiniProgramAppId = 'wxf787cf63760d80a0';
  
  // 货架平台ID (对应小程序 shelf_platform_id)
  static const String shelfPlatformId = '480130129201204499';
  
  // 超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 版本号 (对应小程序 version)
  static const String version = '1.4.14';
  
  // ✅ OSS配置 (对应小程序 VUE_APP_YAKAIXIN_BASEOSSURL)
  // 用于拼接完整的图片URL
  static const String ossBaseUrl = 'https://yakaixin.oss-cn-beijing.aliyuncs.com/';
  
  /// 拼接完整的图片URL
  /// 对应小程序: utils/index.js Line 615-616 completePathNew()
  static String completeImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    
    // 如果已经包含完整URL，直接返回
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    
    // 拼接OSS基础URL
    return ossBaseUrl + path;
  }
}
