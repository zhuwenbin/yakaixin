import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/style/app_style_provider.dart';
import '../home/views/home_page.dart';
import '../home/views/question_bank_page.dart';
import '../course/views/course_page.dart';
import '../profile/views/profile_page.dart';
import 'main_tab_provider.dart';

/// 页面标签（与新顺序对应：购课、刷题、上课、我的）
const List<String> _kTabLabelsByPageIndex = ['购课', '刷题', '上课', '我的'];

/// 主页面 - TabBar导航
/// 新顺序：购课、刷题、上课、我的
class MainTabPage extends ConsumerWidget {
  const MainTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(mainTabIndexProvider);
    final tokens = ref.watch(appStyleTokensProvider);
    final primaryColor = tokens.colors.primary;
    
    // ✅ 固定顺序：购课(0)、刷题(1)、上课(2)、我的(3)
    // 不再使用模板配置的 tabBarOrder，避免模板旧数据导致顺序错乱
    const tabOrder = [0, 1, 2, 3];

    final List<Widget> pages = const [
      HomePage(),      // 购课
      QuestionBankPage(), // 刷题
      CoursePage(),    // 上课
      ProfilePage(),   // 我的
    ];

    final pageIndex = currentTabIndex.clamp(0, 3);

    final items = tokens.images.tabBarUseMaterialIcons
        ? _buildMaterialIconItems(primaryColor, tabOrder)
        : _buildAssetIconItems(
            tokens.images.tabBarIconPaths!,
            tabOrder,
          );

    return Scaffold(
      body: IndexedStack(
        index: pageIndex.clamp(0, pages.length - 1),
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (index) {
          ref.read(mainTabIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        items: items,
      ),
    );
  }

  static List<BottomNavigationBarItem> _buildMaterialIconItems(
    Color primary,
    List<int> tabOrder,
  ) {
    // 图标对应页面下标：购课(0)、刷题(1)、上课(2)、我的(3)
    final icons = [
      (Icon(Icons.shopping_bag_outlined), Icon(Icons.shopping_bag)), // 购课
      (Icon(Icons.menu_book_outlined), Icon(Icons.menu_book)),       // 刷题
      (Icon(Icons.school_outlined), Icon(Icons.school)),             // 上课
      (Icon(Icons.person_outline), Icon(Icons.person)),              // 我的
    ];
    return List.generate(4, (i) {
      final pageIdx = tabOrder[i];
      final label = _kTabLabelsByPageIndex[pageIdx];
      final pair = icons[pageIdx];
      return BottomNavigationBarItem(
        icon: pair.$1,
        activeIcon: pair.$2,
        label: label,
      );
    });
  }

  static List<BottomNavigationBarItem> _buildAssetIconItems(
    List<String> paths,
    List<int> tabOrder,
  ) {
    const size = 24.0;
    return List.generate(4, (i) {
      final pageIdx = tabOrder[i];
      final label = _kTabLabelsByPageIndex[pageIdx];
      final base = pageIdx * 2;
      return BottomNavigationBarItem(
        icon: Image.asset(
          paths[base],
          width: size,
          height: size,
          errorBuilder: (_, __, ___) => const Icon(Icons.circle_outlined, size: size),
        ),
        activeIcon: Image.asset(
          paths[base + 1],
          width: size,
          height: size,
          errorBuilder: (_, __, ___) => const Icon(Icons.circle, size: size),
        ),
        label: label,
      );
    });
  }
}
