import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:bjy_liveui_flutter/bjy_liveui_flutter.dart'; // ❌ 暂时注释：使用WebView播放
import '../providers/live_manager.dart';

/// 百家云直播启动器
/// 对应小程序页面: pages/study/live/index.vue
/// 
/// ❌ 暂时注释：使用WebView播放直播/回放
/// 
/// 注意：此类不是一个页面，而是直播间的启动器
/// 调用后会自动打开百家云SDK的原生直播间页面
/// 
/// 使用方式：
/// ```dart
/// await BaijiayunLiveHelper.enterLiveRoom(
///   context: context,
///   ref: ref,
///   lessonId: '123',
///   userName: '张三',
///   userNumber: '123456',
/// );
/// ```
// ❌ 暂时注释：使用WebView播放直播/回放
class BaijiayunLiveHelper {
  /// 进入直播间
  /// ❌ 暂时注释：使用WebView播放
  static Future<void> enterLiveRoom({
    required BuildContext context,
    required WidgetRef ref,
    required String lessonId,
    required String userName,
    required String userNumber,
    String? userAvatar,
    // BJYUILayoutTemplate layoutTemplate = BJYUILayoutTemplate.Professional,
    String? goodsId,
    String? orderId,
    String? goodsPid,
  }) async {
    debugPrint('⚠️ [直播] ✅ 已改用WebView播放，请使用 LivePlayerPage');
    // try {
    //   if (context.mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('正在进入直播间...')),
    //     );
    //   }
    //   await ref.read(liveManagerProvider.notifier).enterLiveRoom(
    //     lessonId: lessonId,
    //     userName: userName,
    //     userNumber: userNumber,
    //     userAvatar: userAvatar,
    //     layoutTemplate: layoutTemplate,
    //     goodsId: goodsId,
    //     orderId: orderId,
    //     goodsPid: goodsPid,
    //   );
    // } catch (e) {
    //   if (context.mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('进入直播间失败: $e')),
    //     );
    //   }
    //   rethrow;
    // }
  }
}

// ❌ 暂时注释：使用WebView播放
// /// 百家云直播间布局模板枚举扩展
// extension BJYUILayoutTemplateExtension on BJYUILayoutTemplate {
//   /// 获取布局模板的中文名称
//   String get displayName {
//     switch (this) {
//       case BJYUILayoutTemplate.Triple:
//         return '三分屏';
//       case BJYUILayoutTemplate.Enterprise:
//         return '企业竖屏';
//       case BJYUILayoutTemplate.Sell:
//         return '直播带货';
//       case BJYUILayoutTemplate.Professional:
//         return '专业小班课';
//     }
//   }
// }
