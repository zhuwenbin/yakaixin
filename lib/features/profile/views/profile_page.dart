import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';

/// 我的页面
/// 对应小程序: src/modules/jintiku/pages/my/index.vue
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isLoggedIn;
    final user = authState.user;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 头部用户信息
            SliverToBoxAdapter(
              child: _buildHeader(context, isLoggedIn, user),
            ),
            // 功能Tab
            SliverToBoxAdapter(
              child: _buildTabs(context),
            ),
            // 功能列表
            SliverToBoxAdapter(
              child: _buildMenuList(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建头部用户信息
  /// 对应小程序: .header-box
  Widget _buildHeader(BuildContext context, bool isLoggedIn, UserModel? user) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 38.h, 16.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
      ),
      child: Row(
        children: [
          // 头像
          GestureDetector(
            onTap: () {
              if (isLoggedIn) {
                // TODO: 跳转到个人信息页面
              } else {
                // TODO: 跳转到登录页面
              }
            },
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: isLoggedIn && user?.avatar != null
                    ? CachedNetworkImage(
                        imageUrl: user!.avatar!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person, size: 30.w, color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person, size: 30.w, color: Colors.white),
                        ),
                      )
                    : Image.network(
                        'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/yakaixindf.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
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
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (isLoggedIn && user?.phone != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    _formatPhone(user!.phone!),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 编辑图标
          if (isLoggedIn)
            Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24.sp,
            ),
        ],
      ),
    );
  }

  /// 构建功能Tab
  /// 对应小程序: .tab
  Widget _buildTabs(BuildContext context) {
    final tabs = [
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/order.png',
        'text': '我的课程',
        'onTap': () {
          // TODO: 跳转到我的课程页面
        },
      },
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/flower.png',
        'text': '我的报告',
        'onTap': () {
          // TODO: 跳转到我的报告页面
        },
      },
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/error.png',
        'text': '错题本',
        'onTap': () {
          // TODO: 跳转到错题本页面
        },
      },
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/mail.png',
        'text': '试题收藏',
        'onTap': () {
          // TODO: 跳转到试题收藏页面
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
            onTap: () => tab['onTap'] as VoidCallback,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: tab['icon'] as String,
                  width: 32.w,
                  height: 32.w,
                  placeholder: (context, url) => Container(
                    width: 32.w,
                    height: 32.w,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Icon(
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
  Widget _buildMenuList(BuildContext context) {
    final menuItems = [
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/file.png',
        'title': '我的订单',
        'onTap': () {
          // TODO: 跳转到订单页面
        },
      },
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/pen.png',
        'title': '我的练习',
        'onTap': () {
          // TODO: 跳转到练习页面
        },
      },
      {
        'icon': 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/meme.png',
        'title': '设置',
        'onTap': () {
          // TODO: 跳转到设置页面
        },
      },
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;

          return Column(
            children: [
              _buildMenuItem(
                icon: item['icon'] as String,
                title: item['title'] as String,
                onTap: item['onTap'] as VoidCallback,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56.w,
                  color: Color(0xFFE5E5E5),
                ),
            ],
          );
        }).toList(),
      ),
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
            CachedNetworkImage(
              imageUrl: icon,
              width: 24.w,
              height: 24.w,
              placeholder: (context, url) => Container(
                width: 24.w,
                height: 24.w,
                color: Colors.grey[200],
              ),
              errorWidget: (context, url, error) => Icon(
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
