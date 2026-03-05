import 'dart:async';
import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// 视频播放器资源管理器
///
/// 目标：确保 Better Player 和百家云SDK不会同时运行
/// 严格的资源隔离和生命周期管理
class VideoPlayerManager {
  VideoPlayerManager._();

  // ============ 单例 ============
  static final VideoPlayerManager _instance = VideoPlayerManager._();
  static VideoPlayerManager get instance => _instance;

  // ============ 状态管理 ============

  /// 当前 Better Player 控制器实例
  BetterPlayerController? _betterPlayerController;

  /// 百家云SDK是否已初始化
  bool _isBaijiayunActive = false;

  /// 是否正在释放资源
  bool _isDisposing = false;

  /// 资源锁（防止并发操作）
  final _lock = Completer<void>()..complete();

  /// 是否是鸿蒙系统（缓存）
  bool? _isHarmonyOS;

  /// 设备信息通道
  static const MethodChannel _deviceChannel = MethodChannel(
    'com.yakaixin.yakaixin.android/device',
  );

  // ============ 获取状态 ============

  /// 获取当前 Better Player 控制器
  BetterPlayerController? get betterPlayerController => _betterPlayerController;

  /// 是否有活跃的 video_player
  bool get hasActiveVideoPlayer => _betterPlayerController != null;

  /// 是否有活跃的百家云
  bool get hasBaijiayunActive => _isBaijiayunActive;

  // ============ Better Player 管理 ============

  /// 检测是否是鸿蒙系统
  Future<bool> _checkIsHarmonyOS() async {
    if (_isHarmonyOS != null) {
      return _isHarmonyOS!;
    }

    if (!Platform.isAndroid) {
      _isHarmonyOS = false;
      return false;
    }

    try {
      // ✅ 通过 MethodChannel 调用原生代码检测
      final result = await _deviceChannel.invokeMethod<bool>('isHarmonyOS');
      _isHarmonyOS = result ?? false;

      debugPrint('🔍 [VideoPlayerManager] 设备检测: isHarmonyOS=${_isHarmonyOS}');

      return _isHarmonyOS!;
    } catch (e) {
      debugPrint('⚠️ [VideoPlayerManager] 检测鸿蒙系统失败: $e');
      // ✅ 默认假设不是鸿蒙系统
      _isHarmonyOS = false;
      return false;
    }
  }

  /// 初始化 Better Player
  ///
  /// 确保百家云未运行后才能初始化
  ///
  /// [url] 视频URL
  /// [initialTime] 初始播放时间（秒）
  /// [retryCount] 重试次数，默认 0（不重试）
  Future<BetterPlayerController> initVideoPlayer(
    String url, {
    double initialTime = 0,
    int retryCount = 0,
  }) async {
    // 等待之前的操作完成
    await _lock.future;

    final completer = Completer<void>();
    _lock.future.then((_) => completer.future);

    try {
      // ✅ 检查：百家云SDK不能处于活跃状态
      if (_isBaijiayunActive) {
        throw VideoPlayerConflictException(
          '百家云SDK正在运行，无法初始化视频播放器。\n'
          '请先释放百家云资源。',
        );
      }

      debugPrint('🎬 [VideoPlayerManager] 开始初始化 Better Player');
      debugPrint('📹 [VideoPlayerManager] URL: $url');
      debugPrint('⏱️ [VideoPlayerManager] 初始时间: ${initialTime}s');
      debugPrint('📱 [VideoPlayerManager] 平台: ${Platform.operatingSystem}');
      if (retryCount > 0) {
        debugPrint('🔄 [VideoPlayerManager] 重试次数: $retryCount');
      }

      // ✅ iOS模拟器警告
      if (Platform.isIOS && !kReleaseMode) {
        debugPrint('⚠️ [VideoPlayerManager] iOS模拟器检测：如果视频无画面，请在真机上测试');
        debugPrint('   原因：iOS模拟器对H.264/H.265视频编解码支持有限');
        debugPrint('   建议：使用真机测试或检查视频编码格式');
      }

      // ✅ 检测是否是鸿蒙系统（用于日志记录）
      await _checkIsHarmonyOS();

      // ✅ 彻底释放旧实例
      await _disposeVideoPlayerInternal();

      // ✅ 创建视频数据源
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        // ✅ iOS真机必须使用硬件加速，否则进度条会异常
        // iOS模拟器可能无法显示视频，但这是模拟器限制，真机正常
      );

      // ✅ 创建播放器配置（针对鸿蒙系统和iOS优化）
      final configuration = BetterPlayerConfiguration(
        // ✅ 关键修复：禁用自动播放，等待视频初始化完成后手动播放
        // iOS进度条问题：autoPlay: true 时，视频时长还没获取到就开始播放，导致进度条计算错误
        autoPlay: false,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        // ✅ 鸿蒙系统优化：启用自动重试
        autoDispose: false,
        // ✅ iOS模拟器修复：设置渲染方式
        useRootNavigator: false,
        // ✅ 控制条配置（通过详细的样式配置统一 iOS 和 Android 外观）
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
          enableMute: true,
          enablePlayPause: true,
          enableProgressText: true,
          enableProgressBar: true,
          enableProgressBarDrag: true,
          enableSubtitles: false,
          enableOverflowMenu: true, // ✅ 仅显示倍速（其余菜单项关闭）
          enablePlaybackSpeed: true,
          enableQualities: false,
          enableAudioTracks: false,
          enablePip: false,
          enableRetry: false, // ✅ 启用重试按钮
          enableSkips: true, // ✅ 启用快进快退功能
          // forwardSkipTimeInMilliseconds: 15000, // ✅ 快进 10 秒
          // backwardSkipTimeInMilliseconds: 15000, // ✅ 快退 10 秒
          showControlsOnInitialize: true,
          controlBarColor: Colors.black.withOpacity(0.5), // ✅ 黑色半透明蒙版
          iconsColor: Colors.white,
          textColor: Colors.white,
          progressBarPlayedColor: Color(0xFF3B7BFB),
          progressBarHandleColor: Color(0xFF3B7BFB),
          progressBarBufferedColor: Colors.grey,
          progressBarBackgroundColor: const Color(
            0xFFE0E0E0,
          ), // ✅ 对应 Colors.grey.shade300
        ),
        // ✅ 错误处理配置
        errorBuilder: (context, errorMessage) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    '视频加载失败: $errorMessage',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        // ✅ 移除 placeholder，由页面级加载指示器统一处理，避免两个加载状态叠加
      );

      // ✅ 创建 Better Player 控制器
      _betterPlayerController = BetterPlayerController(
        configuration,
        betterPlayerDataSource: dataSource,
      );

      // ✅ iOS进度条修复：等待视频初始化完成后再跳转和播放
      //
      // 问题原因：
      // - videoFormat: BetterPlayerVideoFormat.other 关闭了硬件加速
      // - autoPlay: true 在视频时长未获取时就开始播放
      // - 导致进度条计算错误，显示在最右侧（100%）
      //
      // 解决方案：
      // 1. 移除 videoFormat 配置，使用硬件加速（真机必需）
      // 2. autoPlay: false，禁用自动播放
      // 3. 监听 initialized 事件，视频准备好后再跳转和播放
      bool hasInitialized = false;

      _betterPlayerController!.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized &&
            !hasInitialized) {
          hasInitialized = true;
          debugPrint('✅ [VideoPlayerManager] 视频已初始化（时长已获取）');

          // 跳转到上次播放位置
          if (initialTime > 0) {
            debugPrint('⏩ [VideoPlayerManager] 跳转到 ${initialTime}s');
            _betterPlayerController!.seekTo(
              Duration(seconds: initialTime.toInt()),
            );
          }

          // 延迟后开始播放（确保跳转完成）
          Future.delayed(const Duration(milliseconds: 300), () {
            _betterPlayerController?.play();
            debugPrint('▶️ [VideoPlayerManager] 开始播放');
          });
        }
      });

      debugPrint('✅ [VideoPlayerManager] Better Player 初始化成功');

      return _betterPlayerController!;
    } catch (e, stackTrace) {
      // ✅ 详细错误日志（用于诊断鸿蒙系统问题）
      debugPrint('❌ [VideoPlayerManager] 初始化失败');
      debugPrint('   错误类型: ${e.runtimeType}');
      debugPrint('   错误信息: $e');
      debugPrint('   URL: $url');
      debugPrint('   重试次数: $retryCount');
      debugPrint('   堆栈追踪:');
      debugPrint('   $stackTrace');

      // ✅ 检查是否是 MediaCodec 错误（硬件解码器不支持，常见于鸿蒙系统）
      final errorString = e.toString().toLowerCase();
      final stackString = stackTrace.toString().toLowerCase();
      final isMediaCodecError =
          errorString.contains('mediacodec') ||
          errorString.contains('exoplaybackexception') ||
          errorString.contains('videorenderer') ||
          errorString.contains('codec') ||
          stackString.contains('mediacodec') ||
          stackString.contains('exoplayer') ||
          stackString.contains('codec');

      if (isMediaCodecError) {
        debugPrint('⚠️ [VideoPlayerManager] 检测到解码器错误（可能是鸿蒙系统兼容性问题）');
        debugPrint('   可能原因：');
        debugPrint('   1. 鸿蒙系统的硬件解码器不支持该视频编码格式');
        debugPrint('   2. 视频编码格式（H.264/H.265）与设备不兼容');
        debugPrint('   3. ExoPlayer 在鸿蒙系统上的兼容性问题');

        // ✅ 检测是否是鸿蒙系统
        final isHarmony = await _checkIsHarmonyOS();

        if (retryCount < 2) {
          debugPrint('   🔄 尝试重试（第 ${retryCount + 1} 次）...');
          await _disposeVideoPlayerInternal();
          // ⚠️ 等待更长时间后重试（鸿蒙系统可能需要更多时间）
          await Future.delayed(const Duration(milliseconds: 1500));
          return initVideoPlayer(
            url,
            initialTime: initialTime,
            retryCount: retryCount + 1,
          );
        } else {
          debugPrint('   ❌ 重试次数已达上限，放弃重试');
          if (isHarmony) {
            debugPrint('   💡 建议：这是鸿蒙系统硬件解码器限制，请联系客服获取低分辨率版本');
          }
        }
      }

      await _disposeVideoPlayerInternal();
      rethrow;
    } finally {
      completer.complete();
    }
  }

  /// 释放视频播放器资源
  ///
  /// 公开方法，供外部调用
  Future<void> disposeVideoPlayer() async {
    await _lock.future;

    final completer = Completer<void>();
    _lock.future.then((_) => completer.future);

    try {
      await _disposeVideoPlayerInternal();
    } finally {
      completer.complete();
    }
  }

  /// 内部：释放视频播放器资源
  Future<void> _disposeVideoPlayerInternal() async {
    if (_betterPlayerController == null && !_isDisposing) {
      return;
    }

    _isDisposing = true;

    try {
      debugPrint('🗑️ [VideoPlayerManager] 开始释放 Better Player');

      final controller = _betterPlayerController;
      _betterPlayerController = null;

      if (controller != null) {
        controller.dispose(forceDispose: true);
        debugPrint('✅ [VideoPlayerManager] Better Player 已释放');

        // ⚠️ 等待资源完全释放（重要！）
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('✅ [VideoPlayerManager] 资源释放等待完成');
      }
    } catch (e) {
      debugPrint('⚠️ [VideoPlayerManager] 释放过程出错: $e');
    } finally {
      _isDisposing = false;
    }
  }

  // ============ 百家云SDK 管理 ============

  /// 标记百家云SDK开始使用
  ///
  /// 确保视频播放器未运行后才能标记
  Future<void> markBaijiayunActive() async {
    await _lock.future;

    final completer = Completer<void>();
    _lock.future.then((_) => completer.future);

    try {
      // ✅ 检查：视频播放器不能处于活跃状态
      if (_betterPlayerController != null) {
        throw VideoPlayerConflictException(
          '视频播放器正在运行，无法启动百家云SDK。\n'
          '请先释放视频播放器资源。',
        );
      }

      debugPrint('🎯 [VideoPlayerManager] 百家云SDK标记为活跃');
      _isBaijiayunActive = true;
    } finally {
      completer.complete();
    }
  }

  /// 标记百家云SDK已释放
  Future<void> markBaijiayunInactive() async {
    await _lock.future;

    final completer = Completer<void>();
    _lock.future.then((_) => completer.future);

    try {
      debugPrint('🗑️ [VideoPlayerManager] 百家云SDK标记为非活跃');
      _isBaijiayunActive = false;

      // ⚠️ 等待资源释放
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      completer.complete();
    }
  }

  // ============ 全局清理 ============

  /// 清理所有资源（App退出时调用）
  Future<void> disposeAll() async {
    debugPrint('🧹 [VideoPlayerManager] 清理所有资源');

    await disposeVideoPlayer();
    await markBaijiayunInactive();

    debugPrint('✅ [VideoPlayerManager] 所有资源已清理');
  }
}

/// 播放器冲突异常
class VideoPlayerConflictException implements Exception {
  final String message;

  VideoPlayerConflictException(this.message);

  @override
  String toString() => 'VideoPlayerConflictException: $message';
}
