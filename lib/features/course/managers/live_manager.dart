import 'package:flutter/foundation.dart';
import '../../../app/config/api_config.dart';

/// 直播模式枚举
enum LiveMode {
  /// H5直播（使用WebView，对应小程序）
  h5,
  
  /// 原生插件直播（使用百家云原生SDK）
  native,
}

/// 直播管理类
/// 
/// 功能：
/// - 管理直播模式（H5 / 原生插件）
/// - 初始化百家云SDK
/// - 提供统一的直播入口
/// 
/// 对应小程序: components/study/live/baijiayunLive.vue (H5模式)
class LiveManager {
  LiveManager._();
  
  static final LiveManager instance = LiveManager._();
  
  /// 当前直播模式（默认使用原生插件）
  LiveMode _currentMode = LiveMode.h5;
  
  /// 是否已初始化SDK
  bool _isSDKInitialized = false;
  
  /// 获取当前直播模式
  LiveMode get currentMode => _currentMode;
  
  /// 切换直播模式
  /// 
  /// 参数:
  /// - mode: 直播模式（h5 / native）
  void setLiveMode(LiveMode mode) {
    _currentMode = mode;
    debugPrint('📺 [直播管理] 切换直播模式: ${mode == LiveMode.h5 ? "H5" : "原生插件"}');
  }
  
  /// 初始化百家云SDK - 已废弃
  /// 
  /// ⚠️ 注意：项目已改用H5 WebView方案，不再需要初始化原生SDK
  @Deprecated('使用H5 WebView方案，不再需要SDK初始化')
  Future<void> initSDK() async {
    debugPrint('⚠️ [直播管理] SDK初始化方法已废弃（使用H5方案）');
  }
  
  /// 进入直播间（原生插件模式）- 已废弃
  /// 
  /// ⚠️ 注意：项目已改用H5 WebView方案，此方法已废弃
  @Deprecated('使用H5 WebView方案，请使用LivePage')
  Future<void> enterLiveByCode({
    required String code,
    required String userName,
  }) async {
    throw UnimplementedError('原生插件方法已废弃，请使用H5 WebView方案');
  }
  
  /// 进入直播间（原生插件模式）- 已废弃
  /// 
  /// ⚠️ 注意：项目已改用H5 WebView方案，此方法已废弃
  @Deprecated('使用H5 WebView方案，请使用LivePage')
  Future<void> enterLiveBySign({
    required String roomId,
    required String sign,
    required Map<String, dynamic> userInfo,
  }) async {
    throw UnimplementedError('原生插件方法已废弃，请使用H5 WebView方案');
  }
  
  /// 解析直播URL获取roomId
  /// 
  /// 参数:
  /// - liveUrl: 百家云直播URL
  /// 
  /// 返回:
  /// - roomId 或 null
  String? parseRoomId(String liveUrl) {
    try {
      final uri = Uri.parse(liveUrl);
      return uri.queryParameters['room_id'] ?? 
             uri.queryParameters['roomId'] ??
             uri.queryParameters['class_id'];
    } catch (e) {
      debugPrint('⚠️ [直播管理] URL解析失败: $e');
      return null;
    }
  }
  
  /// 从直播URL解析参数并进入直播间（原生插件模式）- 已废弃
  /// 
  /// ⚠️ 注意：项目已改用H5 WebView方案，此方法已废弃
  @Deprecated('使用H5 WebView方案，请使用LivePage')
  Future<void> enterLiveByUrl({
    required String liveUrl,
    String? userName,
  }) async {
    throw UnimplementedError('原生插件方法已废弃，请使用H5 WebView方案');
  }
  
  /// 获取直播模式说明
  String getModeDescription() {
    switch (_currentMode) {
      case LiveMode.h5:
        return 'H5直播（使用WebView，与小程序一致）';
      case LiveMode.native:
        return '原生插件直播（使用百家云SDK）';
    }
  }
}
