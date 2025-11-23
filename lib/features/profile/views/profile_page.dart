import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/login_page.dart';

/// 我的页面
/// 对应小程序: src/modules/jintiku/pages/my/index.vue
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final major = ref.watch(currentMajorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 用户信息卡片
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.white,
                    child: (user?.avatar != null && user!.avatar!.isNotEmpty)
                        ? ClipOval(
                            child: Image.network(
                              user.avatar!,
                              width: 80.r,
                              height: 80.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // 图片加载失败显示默认头像
                                return Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: Colors.blue,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50.sp,
                            color: Colors.blue,
                          ),
                  ),
                  SizedBox(height: 15.h),
                  // 用户名
                  Text(
                    user?.studentName ?? user?.nickname ?? '未设置',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  // 学员ID
                  Text(
                    'ID: ${user?.studentId ?? '-'}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                  if (major != null) ...[
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        major.majorName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // 功能列表
          _buildMenuItem(Icons.person_outline, '个人信息', () {}),
          _buildMenuItem(Icons.bookmark_outline, '我的收藏', () {}),
          _buildMenuItem(Icons.error_outline, '错题本', () {}),
          _buildMenuItem(Icons.history, '学习记录', () {}),
          _buildMenuItem(Icons.shopping_bag_outlined, '我的订单', () {}),
          _buildMenuItem(Icons.settings_outlined, '设置', () {}),
          SizedBox(height: 20.h),
          // 退出登录按钮
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                '退出登录',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
      onTap: onTap,
    );
  }
}
