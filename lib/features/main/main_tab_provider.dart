import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/style/app_style_provider.dart';

/// 主 Tab 页面枚举 - 使用语义化名称而不是硬编码下标
/// 新顺序：购课(Home)、刷题(QuestionBank)、上课(Course)、我的(Profile)
enum MainTabPage {
  home,      // 购课/首页
  question,  // 刷题/题库
  course,    // 上课/课程
  profile,   // 我的
}

/// Tab 页面扩展
extension MainTabPageExtension on MainTabPage {
  /// 获取页面下标（与 MainTabPage 枚举顺序一致）
  int get pageIndex => index;
  
  /// 获取页面名称
  String get name {
    switch (this) {
      case MainTabPage.home:
        return '购课';
      case MainTabPage.question:
        return '刷题';
      case MainTabPage.course:
        return '上课';
      case MainTabPage.profile:
        return '我的';
    }
  }
}

/// 根据「页面枚举」得到「Tab 下标」
/// 用于跳转到指定 Tab（如切换到 刷题 Tab）
int getTabIndexForPage(MainTabPage page, List<int>? tabBarOrder) {
  final order = tabBarOrder ?? [0, 1, 2, 3]; // 默认顺序：购课、刷题、上课、我的
  if (order.length != 4) return page.pageIndex;
  final i = order.indexOf(page.pageIndex);
  return i >= 0 ? i : page.pageIndex;
}

/// 便捷方法：切换到指定 Tab 页面（使用枚举）
/// 使用示例：switchToTab(ref, MainTabPage.course);
void switchToTab(WidgetRef ref, MainTabPage page) {
  // ✅ 固定顺序，不再使用模板配置的 tabBarOrder
  const tabOrder = [0, 1, 2, 3]; // 购课、刷题、上课、我的
  final tabIndex = getTabIndexForPage(page, tabOrder);
  ref.read(mainTabIndexProvider.notifier).state = tabIndex;
}

/// ✅ 推荐使用：通过 Tab 名称切换到指定页面
/// 支持名称：'购课'、'刷题'、'上课'、'我的'
/// 使用示例：switchToTabByName(ref, '上课');
void switchToTabByName(WidgetRef ref, String tabName) {
  final page = _parseTabName(tabName);
  if (page != null) {
    switchToTab(ref, page);
  } else {
    print('⚠️ [Tab切换] 未知的Tab名称: $tabName');
  }
}

/// 通过名称解析 Tab 页面（不区分大小写，支持多种叫法）
MainTabPage? _parseTabName(String name) {
  final lower = name.toLowerCase().trim();
  
  // 购课/首页
  if (lower == '购课' || lower == 'home' || lower == '首页' || lower == 'shop') {
    return MainTabPage.home;
  }
  
  // 刷题/题库
  if (lower == '刷题' || lower == 'question' || lower == '题库' || lower == '练习') {
    return MainTabPage.question;
  }
  
  // 上课/课程
  if (lower == '上课' || lower == 'course' || lower == '课程' || lower == '学习') {
    return MainTabPage.course;
  }
  
  // 我的
  if (lower == '我的' || lower == 'profile' || lower == 'mine' || lower == '个人中心') {
    return MainTabPage.profile;
  }
  
  return null;
}

/// 主 Tab 索引 Provider - 存的是底部 Tab 下标（0～3）
/// 顺序可能因模版而异，通过 getTabIndexForPage 动态计算
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

/// 兼容旧代码的常量（已废弃，建议使用 MainTabPage 枚举）
@Deprecated('使用 MainTabPage.home.pageIndex 替代')
const int kPageIndexHome = 0;

@Deprecated('使用 MainTabPage.question.pageIndex 替代')
const int kPageIndexQuestion = 1;

@Deprecated('使用 MainTabPage.course.pageIndex 替代')
const int kPageIndexCourse = 2;

@Deprecated('使用 MainTabPage.profile.pageIndex 替代')
const int kPageIndexProfile = 3;

/// 兼容旧方法（已废弃，建议使用 getTabIndexForPage）
@Deprecated('使用 getTabIndexForPage(page, tabBarOrder) 替代')
int tabIndexForPage(int pageIndex, List<int>? tabBarOrder) {
  return getTabIndexForPage(MainTabPage.values[pageIndex], tabBarOrder);
}
