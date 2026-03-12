import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:bjy_liveui_flutter/bjy_liveui_flutter.dart'; // ❌ 暂时注释：使用WebView播放
import '../../../core/media/video_player_manager.dart';
import '../../../app/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../managers/live_manager.dart';

/// 直播课程页面 - 对应小程序 study/live/index.vue
/// 
/// ✅ 功能说明：
/// - 使用 WebView 播放直播/回放
/// - 支持全屏播放
/// - 显示 AppBar 标题（课程小节名称）
/// 
/// ✅ 跳转逻辑（与小程序完全一致）：
/// - 录播课程 (teaching_type == "3"):
///   → 调用 /c/study/learning/playbackPath 接口
///   → 获取 path 字段
///   → 使用 WebView 播放
/// 
/// - 直播课程 (teaching_type == "1"):
///   → 调用 /c/study/learning/live 接口
///   → 如果有 playback_url → 使用 WebView 播放（回放web）
///   → 如果只有 live_url → 使用 WebView 播放（直播web）
class LivePlayerPage extends ConsumerStatefulWidget {
  final String lessonId;
  final String? liveUrl; // ✅ 可选：百家云直播 URL（如果已有则不再请求）
  final String? lessonName; // ✅ 课程小节名称

  const LivePlayerPage({
    super.key,
    required this.lessonId,
    this.liveUrl, // ✅ 改为可选参数
    this.lessonName, // ✅ 课程小节名称
  });

  @override
  ConsumerState<LivePlayerPage> createState() => _LivePlayerPageState();
}

class _LivePlayerPageState extends ConsumerState<LivePlayerPage> {
  bool _isInitializing = true;
  String? _error;
  String? _roomId;
  bool _isLive = true; // ✅ 默认为直播状态
  int _viewerCount = 0; // ✅ 观看人数
  
  // ✅ 学习数据记录
  Timer? _learningTimer;
  String? _dataId;
  int _terminal = 4; // iOS: 4, Android: 3
  
  // ✅ H5直播（WebView）
  WebViewController? _webViewController;
  String? _liveUrl;
  
  // ✅ 全屏状态跟踪
  bool _isFullscreen = false;
  
  @override
  void initState() {
    super.initState();
    _initLiveRoom();
    _startLearningRecord(); // ✅ 启动学习数据记录
  }
  
  /// 初始化百家云直播间
  /// 对应小程序: live/index.vue mounted()
  Future<void> _initLiveRoom() async {
    try {
      debugPrint('📺 [直播] 开始初始化百家云直播间');
      debugPrint('📺 [直播] lesson_id: ${widget.lessonId}');
      debugPrint('📺 [直播] 当前模式: ${LiveManager.instance.getModeDescription()}');
      
      // ✅ 1. 获取直播URL（如果未提供）
      String liveUrl;
      if (widget.liveUrl != null && widget.liveUrl!.isNotEmpty) {
        liveUrl = widget.liveUrl!;
        debugPrint('📺 [直播] 使用传入的 live_url');
      } else {
        debugPrint('📺 [直播] 调用接口获取 live_url');
        liveUrl = await _fetchLiveUrl();
      }
      
      debugPrint('📺 [直播] live_url: $liveUrl');
      _liveUrl = liveUrl;
      
      // ✅ 2. 根据模式初始化
      final mode = LiveManager.instance.currentMode;
      
      if (mode == LiveMode.h5) {
        // ✅ H5模式：使用WebView（对应小程序）
        await _initH5Live(liveUrl);
      } else {
        // ✅ 原生模式：使用百家云SDK
        await _initNativeLive(liveUrl);
      }
      
      setState(() {
        _isInitializing = false;
      });
      
      debugPrint('✅ [直播] 百家云直播间初始化完成');
      
    } catch (e) {
      debugPrint('❌ [直播] 初始化失败: $e');
      setState(() {
        _isInitializing = false;
        _error = '直播间初始化失败: $e';
      });
    }
  }
  
  /// 初始化H5直播（WebView）
  /// 对应小程序: baijiayunLive.vue
  Future<void> _initH5Live(String liveUrl) async {
    debugPrint('🌐 [直播H5] 初始化WebView');
    
    try {
      // ✅ 创建WebView Controller
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFF5F5F5)) // ✅ 浅灰色背景（更美观）
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              debugPrint('🌐 [直播H5] 开始加载: $url');
            },
            onPageFinished: (String url) {
              debugPrint('✅ [直播H5] 加载完成: $url');
              // ✅ 注入JavaScript监听全屏事件
              _injectFullscreenListener();
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('❌ [直播H5] 加载错误: ${error.description}');
            },
          ),
        )
        // ✅ 添加JavaScript通道，用于接收全屏事件
        ..addJavaScriptChannel(
          'FlutterFullscreen',
          onMessageReceived: (JavaScriptMessage message) {
            _handleFullscreenEvent(message.message);
          },
        )
        ..loadRequest(Uri.parse(liveUrl));
      
      debugPrint('✅ [直播H5] WebView初始化完成');
    } catch (e) {
      debugPrint('❌ [直播H5] WebView初始化失败: $e');
      rethrow;
    }
  }
  
  /// 注入JavaScript监听全屏事件
  /// ✅ 监听视频全屏变化
  Future<void> _injectFullscreenListener() async {
    try {
      final js = '''
        (function() {
          // 监听HTML5全屏事件
          document.addEventListener('fullscreenchange', function() {
            if (document.fullscreenElement) {
              FlutterFullscreen.postMessage('enter');
            } else {
              FlutterFullscreen.postMessage('exit');
            }
          });
          
          // 监听WebKit全屏事件（iOS Safari）
          document.addEventListener('webkitfullscreenchange', function() {
            if (document.webkitFullscreenElement) {
              FlutterFullscreen.postMessage('enter');
            } else {
              FlutterFullscreen.postMessage('exit');
            }
          });
          
          // 监听视频元素的全屏事件
          var videos = document.querySelectorAll('video');
          videos.forEach(function(video) {
            video.addEventListener('webkitbeginfullscreen', function() {
              FlutterFullscreen.postMessage('enter');
            });
            video.addEventListener('webkitendfullscreen', function() {
              FlutterFullscreen.postMessage('exit');
            });
          });
          
          console.log('✅ 全屏监听器已注入');
        })();
      ''';
      
      await _webViewController?.runJavaScript(js);
      debugPrint('✅ [直播H5] 全屏监听器注入成功');
    } catch (e) {
      debugPrint('❌ [直播H5] 全屏监听器注入失败: $e');
    }
  }
  
  /// 停止 H5 直播媒体播放
  /// ✅ 解决 iOS 返回后直播间声音继续响的问题
  /// - 注入 JS 暂停所有 video/audio 元素
  /// - 加载 about:blank 卸载页面以释放媒体资源
  Future<void> _stopH5Media() async {
    if (_webViewController == null) return;
    try {
      await _webViewController!.runJavaScript('''
        (function(){
          try {
            document.querySelectorAll('video, audio').forEach(function(el){
              el.pause();
              el.src = '';
              el.load();
            });
          } catch(e) { console.warn('stop media:', e); }
        })();
      ''');
      await _webViewController!.loadRequest(Uri.parse('about:blank'));
      debugPrint('✅ [直播H5] 已停止媒体播放');
    } catch (e) {
      debugPrint('⚠️ [直播H5] 停止媒体时出错: $e');
    }
  }

  /// 处理全屏事件
  void _handleFullscreenEvent(String message) {
    debugPrint('📺 [直播H5] 全屏事件: $message');
    
    setState(() {
      if (message == 'enter') {
        _isFullscreen = true;
        debugPrint('✅ [直播H5] 进入全屏模式');
        // ✅ 隐藏系统状态栏
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      } else if (message == 'exit') {
        _isFullscreen = false;
        debugPrint('✅ [直播H5] 退出全屏模式');
        // ✅ 显示系统状态栏
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      }
    });
  }
  
  /// 初始化原生直播（百家云SDK）
  /// 
  /// ⚠️ 重要：调用SDK后会自动打开原生全屏直播间页面
  /// - iOS: 会push一个UIViewController
  /// - Android: 会启动一个Activity
  /// - 当前Flutter页面可以关闭，因为原生直播间会覆盖整个屏幕
  Future<void> _initNativeLive(String liveUrl) async {
    debugPrint('📦 [直播原生] 初始化百家云SDK');
    
    try {
      // ✅ 1. 标记百家云SDK为活跃
      await VideoPlayerManager.instance.markBaijiayunActive();
      
      // ✅ 2. 解析roomId（用于日志）
      _roomId = LiveManager.instance.parseRoomId(liveUrl);
      
      if (_roomId == null || _roomId!.isEmpty) {
        throw Exception('无法解析直播房间ID');
      }
      
      debugPrint('📦 [直播原生] 解析到 room_id: $_roomId');
      
      // ✅ 3. 从URL解析参数并进入直播间（默认使用Professional布局）
      // ⚠️ 这个调用会立即打开原生全屏直播间，不会返回Widget
      await LiveManager.instance.enterLiveByUrl(
        liveUrl: liveUrl,
        // 可选：覆盖用户昵称，不传则使用URL中的user_name
        // userName: '自定义昵称',
      );
      
      debugPrint('✅ [直播原生] SDK已打开原生直播间页面');
      
      // ✅ 4. 原生直播间已打开，关闭当前Flutter页面
      // SDK会自动管理原生页面的生命周期
      if (mounted) {
        // 延迟一小段时间，确保原生页面已完全打开
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && context.mounted) {
          Navigator.pop(context);
          debugPrint('✅ [直播原生] 已关闭Flutter页面，用户现在在原生直播间中');
        }
      }
    } on VideoPlayerConflictException catch (e) {
      debugPrint('❌ [直播原生] 冲突错误: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ [直播原生] 进入直播间失败: $e');
      rethrow;
    }
  }
  
  /// 获取直播URL
  /// 对应小程序接口: /c/study/learning/live
  /// 对应小程序 API: api/index.js Line 97-103
  Future<String> _fetchLiveUrl() async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        '/c/study/learning/live',
        queryParameters: {'lesson_id': widget.lessonId},
      );
      
      if (response.data['code'] != 100000) {
        throw Exception(response.data['msg']?.first ?? '获取直播地址失败');
      }
      
      final data = response.data['data'];
      if (data == null) {
        throw Exception('直播数据为空');
      }
      
      // ✅ 优先使用 live_url
      if (data['live_url'] != null && data['live_url'].toString().isNotEmpty) {
        String liveUrl = data['live_url'].toString();
        
        // ✅ 添加小程序同样的参数
        // 对应小程序: courseList.vue Line 310
        // const longUrl = data.live_url + '&enterH5=true&dsp=1&disable_ppt_animate=1';
        if (liveUrl.contains('?')) {
          liveUrl += '&enterH5=true&dsp=1&disable_ppt_animate=1';
        } else {
          liveUrl += '?enterH5=true&dsp=1&disable_ppt_animate=1';
        }
        
        return liveUrl;
      } else {
        throw Exception('live_url为空');
      }
    } catch (e) {
      debugPrint('❌ [直播] 获取live_url失败: $e');
      rethrow;
    }
  }
  
  /// 解析直播URL获取roomId
  /// URL格式: https://www.baijiayun.com/web/playback/index.html?...
  String? _parseRoomId(String url) {
    try {
      final uri = Uri.parse(url);
      // 从URL参数中提取room_id
      return uri.queryParameters['room_id'] ?? 
             uri.queryParameters['roomId'] ??
             uri.queryParameters['class_id'];
    } catch (e) {
      debugPrint('⚠️ [直播] URL解析失败: $e');
      return null;
    }
  }
  
  /// 初始化百家云SDK
  Future<void> _initBaijiayunSDK() async {
    debugPrint('📺 [直播] 初始化百家云SDK');
    debugPrint('📺 [直播] Partner ID: ${ApiConfig.bjyPartnerId}');
    debugPrint('📺 [直播] SDK Key: ${ApiConfig.bjySdkKey}');
    debugPrint('📺 [直播] Room ID: $_roomId');
    
    try {
      // ✅ 初始化百家云SDK
      // BJYLiveUIFlutter().initSDK(ApiConfig.bjyPartnerId); // ❌ 暂时注释：使用WebView播放
      debugPrint('✅ [直播] ✅ 使用WebView播放，无需初始化百家云SDK');
      
      // ⚠️ 注意：百家云直播需要使用特殊的进入方式
      // 方式1: 通过参加码进入 (如果有的话)
      // BJYLiveUIFlutter().startLiveByCodeWithLayoutTemplateAndCodeAndUserName(
      //   BJYUILayoutTemplate.Triple,
      //   '参加码',
      //   '用户昵称',
      // );
      
      // 方式2: 通过签名进入 (推荐)
      // 需要后端提供 sign 和 userInfo
      // BJYLiveUIFlutter().startLiveBySignWithLayoutTemplateAndRoomIDAndSignAndUserInfo(
      //   BJYUILayoutTemplate.Triple,
      //   roomID,
      //   sign,
      //   userInfo,
      // );
      
      debugPrint('⚠️ [直播] 需要后端提供sign或参加码才能进入直播间');
      
    } catch (e) {
      debugPrint('❌ [直播] SDK初始化失败: $e');
      // 不抛出异常，先显示占位UI
    }
  }
  
  @override
  void dispose() {
    _learningTimer?.cancel(); // ✅ 清除学习记录定时器
    // ✅ 停止 H5 直播媒体（解决 iOS 返回后声音继续响的问题）
    if (LiveManager.instance.currentMode == LiveMode.h5) {
      _webViewController?.runJavaScript('''
        (function(){
          try {
            document.querySelectorAll('video, audio').forEach(function(el){
              el.pause();
              el.src = '';
              el.load();
            });
          } catch(e) {}
        })();
      ''');
      _webViewController?.loadRequest(Uri.parse('about:blank'));
    }
    // ✅ 根据模式释放资源
    if (LiveManager.instance.currentMode == LiveMode.native) {
      VideoPlayerManager.instance.markBaijiayunInactive();
    }
    super.dispose();
  }
  
  /// 开始学习数据记录
  /// 对应小程序: live/index.vue onLoad() - setInterval
  void _startLearningRecord() {
    debugPrint('📊 [学习记录] 开始记录学习数据');
    
    // 立即记录一次
    _addLearningData();
    
    // 每5分钟记录一次（对应小程序: 1000 * 60 * 5）
    _learningTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _addLearningData(),
    );
  }
  
  /// 记录学习数据
  /// 对应小程序: live/index.vue addData()
  Future<void> _addLearningData() async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.post(
        '/c/exam/addData',
        data: {
          'data_id': _dataId ?? '',
          'lesson_id': widget.lessonId,
          'play_position': '', // 直播无播放进度
          'terminal': _terminal, // iOS: 4, Android: 3
          'type': 1, // 直播类型
          'user_type': 1,
        },
      );
      
      if (response.data['code'] == 100000) {
        final data = response.data['data'];
        if (data != null && data['data_id'] != null) {
          _dataId = data['data_id'].toString();
          debugPrint('✅ [学习记录] 记录成功, data_id: $_dataId');
        }
      } else {
        debugPrint('⚠️ [学习记录] 记录返回失败: ${response.data['msg']}');
      }
    } catch (e) {
      debugPrint('❌ [学习记录] 记录失败: $e');
      // 不抛出异常，允许继续观看直播
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 显示AppBar，标题为课程小节名称
    return Scaffold(
      backgroundColor: Colors.white,
      // ✅ 添加AppBar
      appBar: _isFullscreen ? null : AppBar(
        title: Text(
          widget.lessonName ?? '直播',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
          onPressed: () async {
            if (LiveManager.instance.currentMode == LiveMode.h5) {
              await _stopH5Media();
            }
            if (mounted && context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _buildBody(),
    );
  }



  Widget _buildBody() {
    // ✅ 处理初始化状态
    if (_isInitializing) {
      final mode = LiveManager.instance.currentMode;
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                mode == LiveMode.native 
                  ? '正在启动原生直播间...'
                  : '加载直播中...',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
    }
    
    // ✅ 处理错误状态
    if (_error != null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.red),
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }
    
    // ✅ 原生模式：不应该显示这个页面，因为SDK会打开原生全屏页面
    // 如果代码执行到这里，说明原生页面还没打开或出错了
    final mode = LiveManager.instance.currentMode;
    if (mode == LiveMode.native) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.live_tv, size: 64.sp, color: Colors.black54),
              SizedBox(height: 16.h),
              Text(
                '原生直播间启动中...',
                style: TextStyle(fontSize: 16.sp, color: Colors.black87),
              ),
              SizedBox(height: 8.h),
              Text(
                '如果长时间未响应，请返回重试',
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }
    
    // ✅ H5模式：全屏WebView（对应小程序 baijiayunLive.vue）
    return _buildH5Player();
  }

  /// H5播放器（全屏WebView）
  /// 对应小程序: baijiayunLive.vue <web-view>
  /// ✅ 小程序为全屏web-view，没有聊天框，没有任何额外UI
  Widget _buildH5Player() {
    if (_webViewController == null) {
      return Container(
        color: Colors.white, // ✅ 小程序背景色
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                '加载直播中...',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
    }
    
    // ✅ 全屏WebView（对应小程序 width: 100%, height: 100%）
    // ✅ 小程序中 web-view 的 class="live-webview" style="width: 100%; height: 100%;"
    return Container(
      color: Colors.white, // ✅ 小程序 .my-detail { background-color: #fff; }
      child: WebViewWidget(controller: _webViewController!),
    );
  }



}
