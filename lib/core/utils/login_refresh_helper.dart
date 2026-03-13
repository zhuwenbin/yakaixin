import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/home/providers/home_provider.dart';
import '../../features/home/providers/question_bank_provider.dart';
import '../../features/course/providers/course_provider.dart';

/// 登录后刷新辅助类
/// 用于在登录成功后自动刷新各个页面的数据
class LoginRefreshHelper {
  /// 刷新所有主要页面的数据
  /// 在登录成功后调用（支持 Ref / WidgetRef）
  static void refreshAllPages(dynamic ref) {
    print('🔄 [登录刷新] 开始刷新所有页面数据...');
    
    // ✅ 刷新首页数据
    try {
      ref.read(homeProvider.notifier).loadHomeData();
      print('✅ [登录刷新] 首页数据刷新已触发');
    } catch (e) {
      print('⚠️ [登录刷新] 首页数据刷新失败: $e');
    }
    
    // ✅ 刷新题库页面数据
    try {
      ref.read(questionBankProvider.notifier).loadAllData();
      print('✅ [登录刷新] 题库页面数据刷新已触发');
    } catch (e) {
      print('⚠️ [登录刷新] 题库页面数据刷新失败: $e');
    }
    
    // ✅ 刷新课程页面数据
    try {
      ref.read(courseNotifierProvider.notifier).loadInitialData(
        DateTime.now(),
        '',
      );
      print('✅ [登录刷新] 课程页面数据刷新已触发');
    } catch (e) {
      print('⚠️ [登录刷新] 课程页面数据刷新失败: $e');
    }
    
    // ✅ 刷新我的页面数据（如果有Provider）
    // 注意：我的页面主要是显示用户信息，通常通过 authProvider 自动更新
    // 如果需要刷新其他数据，可以在这里添加
    
    print('✅ [登录刷新] 所有页面数据刷新完成');
  }
}

/// 登录状态监听Provider
/// 用于在登录状态变化时自动刷新数据
final loginRefreshProvider = Provider<void>((ref) {
  // 监听登录状态变化
  ref.listen<bool>(
    isLoggedInProvider,
    (previous, next) {
      // 如果从未登录变为已登录，刷新所有页面
      if (previous == false && next == true) {
        print('🔄 [登录监听] 检测到登录状态变化：未登录 → 已登录');
        LoginRefreshHelper.refreshAllPages(ref);
      }
    },
  );
});
