import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/style/app_style_provider.dart';
import '../home/views/home_page.dart';
import '../home/views/question_bank_page.dart';
import '../course/views/course_page.dart';
import '../profile/views/profile_page.dart';

/// Tab索引Provider - 存的是底部 Tab 下标（0～3），顺序可能因模版为 题库/课程/首页/我的
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

/// 页面下标：0首页 1题库 2课程 3我的。跳转时用 tabIndexForPage(pageIndex, tokens.images.tabBarOrder)
const int kPageIndexHome = 0;
const int kPageIndexQuestion = 1;
const int kPageIndexCourse = 2;
const int kPageIndexProfile = 3;

const List<String> _kTabLabelsByPageIndex = ['首页', '题库', '课程', '我的'];

/// 主页面 - TabBar导航
/// 默认模版：首页、题库、课程、我的；非默认模版：题库、课程、首页、我的 + Template/main_tabbar 图标
class MainTabPage extends ConsumerWidget {
  const MainTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(mainTabIndexProvider);
    final tokens = ref.watch(appStyleTokensProvider);
    final primaryColor = tokens.colors.primary;
    final tabOrder = tokens.images.tabBarOrder ?? [0, 1, 2, 3];

    final List<Widget> pages = const [
      HomePage(),
      QuestionBankPage(),
      CoursePage(),
      ProfilePage(),
    ];

    final pageIndex = tabOrder.length == 4
        ? tabOrder[currentTabIndex.clamp(0, 3)]
        : currentTabIndex;

    final labels = tokens.images.tabBarLabels;
    final items = tokens.images.tabBarUseMaterialIcons
        ? _buildMaterialIconItems(primaryColor, tabOrder, labels)
        : _buildAssetIconItems(
            tokens.images.tabBarIconPaths!,
            tabOrder,
            labels,
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
    List<String>? tabBarLabels,
  ) {
    final icons = [
      (Icon(Icons.home_outlined), Icon(Icons.home)),
      (Icon(Icons.menu_book_outlined), Icon(Icons.menu_book)),
      (Icon(Icons.school_outlined), Icon(Icons.school)),
      (Icon(Icons.person_outline), Icon(Icons.person)),
    ];
    return List.generate(4, (i) {
      final pageIdx = tabOrder.length == 4 ? tabOrder[i] : i;
      final label = (tabBarLabels != null && tabBarLabels.length == 4)
          ? tabBarLabels[i]
          : (pageIdx >= 0 && pageIdx < _kTabLabelsByPageIndex.length
              ? _kTabLabelsByPageIndex[pageIdx]
              : '');
      final pair = icons[pageIdx.clamp(0, 3)];
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
    List<String>? tabBarLabels,
  ) {
    const size = 24.0;
    return List.generate(4, (i) {
      final pageIdx = tabOrder.length == 4 ? tabOrder[i] : i;
      final label = (tabBarLabels != null && tabBarLabels.length == 4)
          ? tabBarLabels[i]
          : (pageIdx >= 0 && pageIdx < _kTabLabelsByPageIndex.length
              ? _kTabLabelsByPageIndex[pageIdx]
              : '');
      final base = i * 2;
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
