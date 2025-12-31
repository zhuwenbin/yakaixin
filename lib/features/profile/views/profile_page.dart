import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/config/api_config.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../main/main_tab_page.dart'; // 导入mainTabIndexProvider

/// 我的页面
/// 对应小程序: src/modules/jintiku/pages/my/index.vue
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isLoggedIn;
    final user = authState.user;
    // 获取状态栏高度
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      // ✅ 不使用 SafeArea,让背景图片充满状态栏
      body: Stack(
        children: [
          // ✅ 背景图片 - 充满状态栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              ApiConfig.completeImageUrl('my-background-img.png'),
              height: statusBarHeight + 220.h, // 状态栏 + 头部区域高度
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: statusBarHeight + 220.h,
                  color: Colors.white,
                );
              },
            ),
          ),
          // 主内容区域
          CustomScrollView(
            slivers: [
              // 顶部占位(状态栏高度)
              SliverToBoxAdapter(
                child: SizedBox(height: statusBarHeight + 38.h),
              ),
              // 头部用户信息
              SliverToBoxAdapter(
                child: _buildHeader(context, isLoggedIn, user),
              ),
              // 功能Tab
              SliverToBoxAdapter(
                child: _buildTabs(context, ref),
              ),
              // 功能列表
              SliverToBoxAdapter(
                child: _buildMenuList(context, ref),
              ),
              // 底部间距
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
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
              // 跳转到登录页面
              context.push(AppRoutes.loginCenter);
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
                  child: isLoggedIn && user?.avatar != null && user!.avatar!.isNotEmpty
                      ? Image.network(
                          // ✅ 修复：使用 ApiConfig.completeImageUrl() 拼接完整URL
                          ApiConfig.completeImageUrl(user.avatar),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.person, size: 30.w, color: Colors.white),
                          ),
                        )
                      : Image.network(
                          // ✅ 修复：未登录时使用旧OSS域名的默认头像
                          // 对应小程序: Line 10 (使用旧OSS域名)
                          'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/yakaixindf.png',
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
                  width: 20.w,  // ✅ 对应小程序 width: 20px (20.w)
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
          ref.read(mainTabIndexProvider.notifier).state = 2;
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
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 32.w,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  tab['text'] as String,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF333333),
                  ),
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
          ref.read(mainTabIndexProvider.notifier).state = 0;
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
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: Color(0xFF999999),
            ),
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
