import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/live_service.dart';
import '../models/live_url_model.dart';
import '../listeners/live_room_listener.dart';

part 'live_manager.g.dart';

/// 直播管理器 - 管理百家云直播的核心逻辑
/// 
/// 职责：
/// 1. 初始化百家云SDK
/// 2. 获取直播信息
/// 3. 进入直播间
/// 4. 记录学习数据
@riverpod
class LiveManager extends _$LiveManager {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  /// 初始化百家云SDK
  /// 
  /// 参数：
  /// - sdkKey: 百家云SDK密钥
  /// 
  /// 注意：建议在用户同意隐私政策后调用
  Future<void> initSDK(String sdkKey) async {
    try {
      // 1. 初始化SDK
      // BJYLiveUIFlutterPlatform.instance.initSDK(sdkKey);
      
      // // 2. 设置直播间监听器
      // BJYLiveUIFlutter().setRoomListener(LiveRoomListener());
      
      if (kDebugMode) {
        print('[LiveManager] 百家云SDK初始化成功: $sdkKey');
      }
      
      state = const AsyncValue.data('initialized');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[LiveManager] 百家云SDK初始化失败: $e');
      }
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 进入直播间
  /// 
  /// 参数：
  /// - lessonId: 课节ID
  /// - userName: 用户昵称
  /// - userNumber: 用户唯一标识
  /// - userAvatar: 用户头像URL (可选)
  /// - layoutTemplate: 直播间布局模板 (默认专业小班课)
  /// - goodsId: 商品ID (可选，用于学习数据记录)
  /// - orderId: 订单ID (可选，用于学习数据记录)
  /// - goodsPid: 商品父ID (可选)
  // Future<void> enterLiveRoom({
  //   required String lessonId,
  //   required String userName,
  //   required String userNumber,
  //   String? userAvatar,
  //   BJYUILayoutTemplate layoutTemplate = BJYUILayoutTemplate.Professional,
  //   String? goodsId,
  //   String? orderId,
  //   String? goodsPid,
  // }) async {
  //   try {
  //     // 1. 获取直播信息
  //     final service = ref.read(liveServiceProvider);
  //     final liveInfo = await service.getLiveUrl(lessonId: lessonId);

  //     // 2. 解析直播间信息
  //     // 注意：这里需要根据实际API返回的数据结构调整
  //     // 小程序返回的是URL，但SDK需要roomId和sign
  //     // 可能需要调用其他API获取roomId和sign，或从URL中解析
      
  //     if (kDebugMode) {
  //       print('[LiveManager] 准备进入直播间: lessonId=$lessonId');
  //       print('[LiveManager] 直播信息: $liveInfo');
  //     }

  //     // 3. 构造用户信息
  //     final userInfo = {
  //       'name': userName,
  //       'number': userNumber,
  //       'type': 0, // 0:学生 1:老师 2:助教
  //       if (userAvatar != null && userAvatar.isNotEmpty) 'avatar': userAvatar,
  //       'groupId': 0, // 默认不分组
  //     };

  //     // 4. 进入直播间
  //     // TODO: 根据实际API返回的数据决定使用参加码还是签名方式
  //     // 方式1: 使用参加码
  //     // await BJYLiveUIFlutter().startLiveByCodeWithLayoutTemplateAndCodeAndUserName(
  //     //   layoutTemplate,
  //     //   participationCode,
  //     //   userName,
  //     // );
      
  //     // 方式2: 使用签名 (推荐)
  //     // await BJYLiveUIFlutter().startLiveBySignWithLayoutTemplateAndRoomIDAndSignAndUserInfo(
  //     //   layoutTemplate,
  //     //   roomId,
  //     //   sign,
  //     //   userInfo,
  //     // );
      
  //     // 当前先抛出异常，提示需要实现
  //     throw UnimplementedError(
  //       '需要根据实际API返回的数据实现进入直播间逻辑。'
  //       '请检查 /c/study/learning/live 接口返回的数据结构，'
  //       '确定是使用参加码还是roomId+sign方式进入直播间。'
  //     );

  //     // 5. 记录学习数据(不阻塞进入直播间)
  //     if (goodsId != null && orderId != null) {
  //       _recordStudyData(
  //         lessonId: lessonId,
  //         goodsId: goodsId,
  //         orderId: orderId,
  //         goodsPid: goodsPid,
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print('[LiveManager] 进入直播间失败: $e');
  //     }
  //     rethrow;
  //   }
  // }

  /// 记录学习数据(异步，不阻塞)
  void _recordStudyData({
    required String lessonId,
    required String goodsId,
    required String orderId,
    String? goodsPid,
  }) {
    Future(() async {
      try {
        final service = ref.read(liveServiceProvider);
        await service.addStudyData(
          lessonId: lessonId,
          goodsId: goodsId,
          orderId: orderId,
          goodsPid: goodsPid,
        );
        if (kDebugMode) {
          print('[LiveManager] 学习数据记录成功');
        }
      } catch (e) {
        if (kDebugMode) {
          print('[LiveManager] 学习数据记录失败: $e');
        }
      }
    });
  }

  /// 检查SDK是否已初始化
  bool get isInitialized {
    return state.value != null && state.value == 'initialized';
  }

  /// 重置状态
  void reset() {
    state = const AsyncValue.data(null);
  }
}
