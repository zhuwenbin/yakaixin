import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/style/app_style_provider.dart';
import '../home/views/home_page.dart';
import '../home/views/question_bank_page.dart';
import '../course/views/course_page.dart';
import '../profile/views/profile_page.dart';

/// Tab索引Provider - 用于全局控制Tab切换
final mainTabIndexProvider = StateProvider<int>((ref) => 0);

/// 主页面 - TabBar导航
/// 对应小程序: 4个Tab - 首页/题库/课程/我的
class MainTabPage extends ConsumerWidget {
  const MainTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabIndexProvider);
    final tokens = ref.watch(appStyleTokensProvider);
    final primaryColor = tokens.colors.primary;

    final List<Widget> pages = const [
      HomePage(),
      QuestionBankPage(),
      CoursePage(),
      ProfilePage(),
    ];

    final items = tokens.images.tabBarUseMaterialIcons
        ? _buildMaterialIconItems(primaryColor)
        : _buildAssetIconItems(tokens.images.tabBarIconPaths!);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
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

  static List<BottomNavigationBarItem> _buildMaterialIconItems(Color primary) {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: '首页',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_outlined),
        activeIcon: Icon(Icons.menu_book),
        label: '题库',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.school_outlined),
        activeIcon: Icon(Icons.school),
        label: '课程',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: '我的',
      ),
    ];
  }

  static List<BottomNavigationBarItem> _buildAssetIconItems(
    List<String> paths,
  ) {
    const size = 24.0;
    return [
      BottomNavigationBarItem(
        icon: Image.asset(paths[0], width: size, height: size, errorBuilder:
            (_, __, ___) {
          return const Icon(Icons.home_outlined, size: size);
        }),
        activeIcon: Image.asset(paths[1], width: size, height: size,
            errorBuilder: (_, __, ___) {
          return const Icon(Icons.home, size: size);
        }),
        label: '首页',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(paths[2], width: size, height: size, errorBuilder:
            (_, __, ___) {
          return const Icon(Icons.menu_book_outlined, size: size);
        }),
        activeIcon: Image.asset(paths[3], width: size, height: size,
            errorBuilder: (_, __, ___) {
          return const Icon(Icons.menu_book, size: size);
        }),
        label: '题库',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(paths[4], width: size, height: size, errorBuilder:
            (_, __, ___) {
          return const Icon(Icons.school_outlined, size: size);
        }),
        activeIcon: Image.asset(paths[5], width: size, height: size,
            errorBuilder: (_, __, ___) {
          return const Icon(Icons.school, size: size);
        }),
        label: '课程',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(paths[6], width: size, height: size, errorBuilder:
            (_, __, ___) {
          return const Icon(Icons.person_outline, size: size);
        }),
        activeIcon: Image.asset(paths[7], width: size, height: size,
            errorBuilder: (_, __, ___) {
          return const Icon(Icons.person, size: size);
        }),
        label: '我的',
      ),
    ];
  }
}
