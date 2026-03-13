import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/config/api_config.dart';
import '../../../core/style/app_style_config.dart';
import '../../../core/style/app_style_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../main/main_tab_page.dart';
import '../constants/profile_template_assets.dart';

/// 我的页面
/// 对应小程序: src/modules/jintiku/pages/my/index.vue
///
/// 按模版区分:
/// - 蓝色默认: 网络背景图、4 Tab + 3 菜单
/// - 非默认(橙黄/绿/自定义): 渐变背景、右上装饰、7 个卡片菜单，使用 Template/mine 切图
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appStyleConfigProvider);
    final isBlueDefault = config.template == AppStyleTemplate.blueDefault;
    if (isBlueDefault) {
      return const _ProfilePageBlueLayout();
    }
    return const _ProfilePageAlternativeLayout();
  }
}

/// 蓝色默认模版 - 网络背景、4 Tab + 3 菜单
class _ProfilePageBlueLayout extends ConsumerWidget {
  const _ProfilePageBlueLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              ApiConfig.completeImageUrl('my-background-img.png'),
              height: statusBarHeight + 220.h,
              fit: BoxFit.cover,
              headers: ApiConfig.ossImageHeaders,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: statusBarHeight + 220.h,
                  color: Colors.white,
                );
              },
            ),
          ),
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: statusBarHeight + 38.h),
              ),
              SliverToBoxAdapter(
                child: _buildHeader(
                  context,
                  authState.isLoggedIn,
                  authState.user,
                ),
              ),
              SliverToBoxAdapter(child: _buildTabs(context, ref)),
              SliverToBoxAdapter(child: _buildMenuList(context, ref)),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建头部用户信息
  /// 对应小程序: .header-box
  Widget _buildHeader(BuildContext context, bool isLoggedIn, UserModel? user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 32rpx ÷ 2 = 16.w
      child: Container(
        padding: EdgeInsets.only(bottom: 15.h), // 30rpx ÷ 2 = 15.h
        child: GestureDetector(
          // ✅ 优化：整个区域都可点击
          onTap: () {
            if (isLoggedIn) {
              // 跳转到个人信息编辑页
              context.push(AppRoutes.personEdit);
            } else {
              // ✅ 跳转到登录页面，登录后返回当前页面
              final router = GoRouter.of(context);
              final currentPath =
                  router.routerDelegate.currentConfiguration.uri.path;
              context.push(
                AppRoutes.loginCenter,
                extra: {'returnPath': currentPath},
              );
            }
          },
          behavior: HitTestBehavior.opaque, // ✅ 确保整个区域可点击
          child: Row(
            children: [
              // 头像
              Container(
                width: 64.w, // 128rpx ÷ 2 = 64.w
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4.w, // 8rpx ÷ 2 = 4.w
                  ),
                ),
                child: ClipOval(
                  child:
                      isLoggedIn &&
                          user?.avatar != null &&
                          user!.avatar!.isNotEmpty
                      ? Image.network(
                          ApiConfig.convertLegacyOssUrl(
                            ApiConfig.completeImageUrl(user.avatar),
                          ),
                          fit: BoxFit.cover,
                          headers: ApiConfig.ossImageHeaders,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 30.w,
                                  color: Colors.white,
                                ),
                              ),
                        )
                      : Image.asset(
                          'assets/images/app_icon.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 12.w), // 24rpx ÷ 2 = 12.w
              // 用户信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn
                          ? (user?.nickname ?? user?.studentName ?? '用户')
                          : '请登录',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF03203D),
                      ),
                    ),
                    if (isLoggedIn && user?.phone != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _formatPhone(user!.phone!),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF03203D).withOpacity(0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 编辑图标
              // 对应小程序: .edit image (Line 36-37)
              if (isLoggedIn)
                Image.network(
                  // ✅ 使用小程序相同的完整URL（旧OSS）
                  'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/34e7174539261545097316_%E7%BC%96%E7%BB%84%204%E5%A4%87%E4%BB%BD%203%402x.png',
                  width: 20.w, // ✅ 对应小程序 width: 20px (20.w)
                  height: 20.w, // ✅ 对应小程序 height: 20px (20.w)
                  errorBuilder: (context, error, stackTrace) {
                    // ✅ 图片加载失败时显示默认图标
                    return Icon(
                      Icons.edit,
                      color: const Color(0xFF03203D), // ✅ 对应小程序 color: #03203d
                      size: 20.w,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建功能Tab
  /// 对应小程序: .tab
  Widget _buildTabs(BuildContext context, WidgetRef ref) {
    final tabs = [
      {
        'icon': ApiConfig.completeImageUrl('order.png'),
        'text': '我的课程',
        'onTap': () {
          // 切换到课程 Tab
          ref.read(mainTabIndexProvider.notifier).state =
            tabIndexForPage(kPageIndexCourse, ref.read(appStyleTokensProvider).images.tabBarOrder);
        },
      },
      {
        'icon': ApiConfig.completeImageUrl('flower.png'),
        'text': '我的报告',
        'onTap': () {
          // 跳转到报告中心页面
          context.push(AppRoutes.reportCenter);
        },
      },
      {
        'icon': ApiConfig.completeImageUrl('error.png'),
        'text': '错题本',
        'onTap': () {
          // 跳转到错题本页面
          context.push(AppRoutes.wrongBookIndex);
        },
      },
      {
        'icon': ApiConfig.completeImageUrl('mail.png'),
        'text': '试题收藏',
        'onTap': () {
          // 跳转到试题收藏页面
          context.push(AppRoutes.collectIndex);
        },
      },
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) {
          return GestureDetector(
            onTap: tab['onTap'] as VoidCallback,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  tab['icon'] as String,
                  width: 32.w,
                  height: 32.w,
                  headers: ApiConfig.ossImageHeaders,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 32.w,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  tab['text'] as String,
                  style: TextStyle(fontSize: 12.sp, color: Color(0xFF333333)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建功能列表
  Widget _buildMenuList(BuildContext context, WidgetRef ref) {
    final menuItems = [
      // {
      //   'icon': ApiConfig.completeImageUrl('wallet.png'),
      //   'title': '我的余额',
      //   'onTap': () {
      //     // 跳转到余额页面
      //     context.push('/balance');
      //   },
      // },
      {
        'icon': ApiConfig.completeImageUrl('file.png'),
        'title': '我的订单',
        'onTap': () {
          // 跳转到订单页面
          context.push(AppRoutes.myOrder);
        },
      },
      {
        'icon': ApiConfig.completeImageUrl('pen.png'),
        'title': '我的练习',
        'onTap': () {
          // 切换到首页 Tab
          ref.read(mainTabIndexProvider.notifier).state =
            tabIndexForPage(kPageIndexHome, ref.read(appStyleTokensProvider).images.tabBarOrder);
        },
      },
      {
        'icon': ApiConfig.completeImageUrl('meme.png'),
        'title': '设置',
        'onTap': () {
          // 跳转到设置页面
          context.push(AppRoutes.settings);
        },
      },
    ];

    // 每个菜单项都是独立的圆角卡片（对应小程序的单独.list）
    return Column(
      children: menuItems.map((item) {
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r), // 对应小程序 32rpx
          ),
          child: _buildMenuItem(
            icon: item['icon'] as String,
            title: item['title'] as String,
            onTap: item['onTap'] as VoidCallback,
          ),
        );
      }).toList(),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            // ✅ 改用 Image.network 避免 CachedNetworkImage 在 iOS Release 模式下
            // 因 Content-Disposition: attachment 导致的无法显示问题
            Image.network(
              icon,
              width: 24.w,
              height: 24.w,
              headers: ApiConfig.ossImageHeaders,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: 24.w,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15.sp, color: Color(0xFF333333)),
              ),
            ),
            Icon(Icons.chevron_right, size: 20.sp, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }

  /// 格式化手机号
  String _formatPhone(String phone) {
    if (phone.length >= 11) {
      return '${phone.substring(0, 3)}****${phone.substring(7)}';
    }
    return phone;
  }
}

/// 非默认模版 - 渐变背景、右上装饰、7 个白色卡片菜单，使用 Template/mine 切图
class _ProfilePageAlternativeLayout extends ConsumerWidget {
  const _ProfilePageAlternativeLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final tokens = ref.watch(appStyleTokensProvider);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final topHeight = statusBarHeight + 220.h;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [
          // 顶部背景图（与默认模版一致：铺满顶部，BoxFit.cover）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              ProfileTemplateAssets.profileTopBg,
              height: topHeight,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: topHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tokens.colors.cardLightBg,
                      tokens.colors.primaryGradientStart.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 右上角装饰图（叠加在背景之上）
          Positioned(
            top: statusBarHeight + 16.h,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 140.h,
              child: Image.asset(
                ProfileTemplateAssets.profileDecoration,
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: statusBarHeight + 38.h),
              ),
              SliverToBoxAdapter(
                child: _buildHeader(
                  context,
                  authState.isLoggedIn,
                  authState.user,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: _buildMenuCards(context, ref, tokens.colors.primary),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLoggedIn, UserModel? user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          if (isLoggedIn) {
            context.push(AppRoutes.personEdit);
          } else {
            final router = GoRouter.of(context);
            final currentPath =
                router.routerDelegate.currentConfiguration.uri.path;
            context.push(
              AppRoutes.loginCenter,
              extra: {'returnPath': currentPath},
            );
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.w),
              ),
              child: ClipOval(
                child:
                    isLoggedIn &&
                        user?.avatar != null &&
                        user!.avatar!.isNotEmpty
                    ? Image.network(
                        ApiConfig.convertLegacyOssUrl(
                          ApiConfig.completeImageUrl(user.avatar),
                        ),
                        fit: BoxFit.cover,
                        headers: ApiConfig.ossImageHeaders,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 30.w,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoggedIn
                        ? (user?.nickname ?? user?.studentName ?? '用户')
                        : '请登录',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF03203D),
                    ),
                  ),
                  if (isLoggedIn && user?.phone != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      _formatPhone(user!.phone!),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF03203D).withOpacity(0.85),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isLoggedIn)
              Icon(Icons.edit, color: const Color(0xFF03203D), size: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCards(
    BuildContext context,
    WidgetRef ref,
    Color primaryColor,
  ) {
    const menuItems = [
      (ProfileTemplateAssets.menuMyCourse, '我的课程'),
      (ProfileTemplateAssets.menuMyReport, '我的报告'),
      (ProfileTemplateAssets.menuCorrection, '纠错'),
      (ProfileTemplateAssets.menuFavorites, '试题收藏'),
      (ProfileTemplateAssets.menuOrders, '我的订单'),
      (ProfileTemplateAssets.menuPractice, '我的练习'),
      (ProfileTemplateAssets.menuSettings, '设置'),
    ];
    final taps = [
      () => ref.read(mainTabIndexProvider.notifier).state =
          tabIndexForPage(kPageIndexCourse, ref.read(appStyleTokensProvider).images.tabBarOrder),
      () => context.push(AppRoutes.reportCenter),
      () => context.push(AppRoutes.wrongBookIndex),
      () => context.push(AppRoutes.collectIndex),
      () => context.push(AppRoutes.myOrder),
      () => ref.read(mainTabIndexProvider.notifier).state =
          tabIndexForPage(kPageIndexHome, ref.read(appStyleTokensProvider).images.tabBarOrder),
      () => context.push(AppRoutes.settings),
    ];
    return Column(
      children: List.generate(menuItems.length, (i) {
        final item = menuItems[i];
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: _buildMenuCardItem(
            iconPath: item.$1,
            title: item.$2,
            onTap: taps[i],
            primaryColor: primaryColor,
          ),
        );
      }),
    );
  }

  Widget _buildMenuCardItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24.w,
              height: 24.w,
              errorBuilder: (_, __, ___) => Icon(Icons.article_outlined, size: 24.w, color: primaryColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: const Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPhone(String phone) {
    if (phone.length >= 11) {
      return '${phone.substring(0, 3)}****${phone.substring(7)}';
    }
    return phone;
  }
}
