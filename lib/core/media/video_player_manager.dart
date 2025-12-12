import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

/// 视频播放器资源管理器
/// 
/// 目标：确保 video_player 和百家云SDK不会同时运行
/// 严格的资源隔离和生命周期管理
class VideoPlayerManager {
  VideoPlayerManager._();
  
  // ============ 单例 ============
  static final VideoPlayerManager _instance = VideoPlayerManager._();
  static VideoPlayerManager get instance => _instance;
  
  // ============ 状态管理 ============
  
  /// 当前 video_player 控制器实例
  VideoPlayerController? _videoPlayerController;
  
  /// 百家云SDK是否已初始化
  bool _isBaijiayunActive = false;
  
  /// 是否正在释放资源
  bool _isDisposing = false;
  
  /// 资源锁（防止并发操作）
  final _lock = Completer<void>()..complete();
  
  // ============ 获取状态 ============
  
  /// 获取当前 video_player 控制器
  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  
  /// 是否有活跃的 video_player
  bool get hasActiveVideoPlayer => _videoPlayerController != null;
  
  /// 是否有活跃的百家云
  bool get hasBaijiayunActive => _isBaijiayunActive;
  
  // ============ video_player 管理 ============
  
  /// 初始化 video_player
  /// 
  /// 确保百家云未运行后才能初始化
  Future<VideoPlayerController> initVideoPlayer(String url) async {
    // 等待之前的操作完成
    await _lock.future;
    
    final completer = Completer<void>();
    _lock.future.then((_) => completer.future);
    
    try {
      // ✅ 检查：百家云SDK不能处于活跃状态
      if (_isBaijiayunActive) {
        throw VideoPlayerConflictException(
          '百家云SDK正在运行，无法初始化video_player。\n'
          '请先释放百家云资源。',
        );
      }
      
      debugPrint('🎬 [VideoPlayerManager] 开始初始化 video_player');
      debugPrint('📹 [VideoPlayerManager] URL: $url');
      
      // ✅ 彻底释放旧实例
      await _disposeVideoPlayerInternal();
      
      // ✅ 创建新实例
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );
      
      // ✅ 初始化
      await _videoPlayerController!.initialize();
      
      debugPrint('✅ [VideoPlayerManager] video_player 初始化成功');
      
      return _videoPlayerController!;
      
    } catch (e) {
      debugPrint('❌ [VideoPlayerManager] 初始化失败: $e');
      await _disposeVideoPlayerInternal();
      rethrow;
    } finally {
      completer.complete();
    }
  }
  
  /// 释放 video_player 资源
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
  
  /// 内部：释放 video_player 资源
  Future<void> _disposeVideoPlayerInternal() async {
    if (_videoPlayerController == null && !_isDisposing) {
      return;
    }
    
    _isDisposing = true;
    
    try {
      debugPrint('🗑️ [VideoPlayerManager] 开始释放 video_player');
      
      final controller = _videoPlayerController;
      _videoPlayerController = null;
      
      if (controller != null) {
        await controller.dispose();
        debugPrint('✅ [VideoPlayerManager] video_player 已释放');
        
        // ⚠️ 等待资源完全释放（重要！）
        // 给系统时间释放底层 AVFoundation 资源
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
  /// 确保 video_player 未运行后才能标记
  Future<void> markBaijiayunActive() async {
    await _lock.future;
    
    final completer = Completer<void>();
    _lock.future.then((_) => completer.future);
    
    try {
      // ✅ 检查：video_player 不能处于活跃状态
      if (_videoPlayerController != null) {
        throw VideoPlayerConflictException(
          'video_player正在运行，无法启动百家云SDK。\n'
          '请先释放video_player资源。',
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
