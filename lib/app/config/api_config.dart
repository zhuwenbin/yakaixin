import 'package:flutter/foundation.dart';

/// API配置
/// 对应小程序: src/modules/jintiku/config.js, .env.production
class ApiConfig {
  // 环境配置
  // dev: 开发环境(本地代理) + 网络调试
  // test: 测试环境 + 网络调试
  // prod: 生产环境
  static const String env = String.fromEnvironment('ENV', defaultValue: 'prod');
  
  // 运行时环境切换 (用于调试)
  static String _runtimeEnv = env;
  
  /// 是否为 Debug 模式
  static bool get isDebug => kDebugMode;
  
  /// 获取当前环境
  static String get currentEnv => _runtimeEnv;
  
  /// 切换环境 (仅在 Debug 模式下可用)
  static void switchEnv(String newEnv) {
    if (isDebug) {
      _runtimeEnv = newEnv;
    }
  }
  
  // 基础URL
  static const String baseUrlProd = 'https://yakaixin.yunsop.com/api';
  static const String baseUrlTest = 'https://xypaytest.jinyingjie.com/api';
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
}
