import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/config/debug_config.dart';

/// 设置页面 - 对应小程序 userInfo/set.vue
/// 功能：章节练习设置、隐私协议、用户协议、退出登录
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int _chapterQuestionNumber = 20;
  bool _showDialog = false;
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // TODO: API调用获取设置
    setState(() {
      _chapterQuestionNumber = 20;
      _numberController.text = _chapterQuestionNumber.toString();
    });
  }

  void _showQuestionNumberDialog() {
    _numberController.text = _chapterQuestionNumber.toString();
    showDialog(
      context: context,
      builder: (context) => _buildQuestionNumberDialog(),
    );
  }

  Future<void> _saveQuestionNumber() async {
    final number = int.tryParse(_numberController.text);
    if (number == null || number <= 0) {
      // TODO: 显示错误提示
      return;
    }

    // TODO: 保存设置到服务器
    setState(() {
      _chapterQuestionNumber = number;
    });
    Navigator.pop(context);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => _buildLogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 监听调试工具开关状态
    final isDebugEnabled = ref.watch(debugToolsEnabledProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.w),
        children: [
          _buildSettingItem(
            title: '章节练习',
            trailing: '每次$_chapterQuestionNumber道题',
            onTap: _showQuestionNumberDialog,
          ),
          _buildSettingItem(
            title: '修改密码',
            onTap: () {
              context.push(AppRoutes.changePassword);
            },
          ),
          _buildSettingItem(
            title: '隐私协议',
            onTap: () {
              context.push(AppRoutes.privacyPolicy);
            },
          ),
          _buildSettingItem(
            title: '用户协议',
            onTap: () {
              context.push(AppRoutes.userServiceAgreement);
            },
          ),
          
          // ✅ Debug 模式下显示调试工具开关
          if (kDebugMode) ...[
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔧 开发者工具',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildDebugSwitchItem(
                    title: '调试框架显示',
                    subtitle: '关闭后隐藏网络调试悬浮窗（用于截图）',
                    value: isDebugEnabled,
                    onChanged: (value) {
                      ref.read(debugToolsEnabledProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
          
          _buildSettingItem(
            title: '退出登录',
            onTap: _logout,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDebugSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF161F30),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF787E8F),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? trailing,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF161F30),
              ),
            ),
            Row(
              children: [
                if (trailing != null)
                  Text(
                    trailing,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF787E8F),
                    ),
                  ),
                if (showArrow) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right,
                    size: 18.sp,
                    color: const Color(0xFF787E8F),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionNumberDialog() {
    return AlertDialog(
      title: const Text('章节练习'),
      content: TextField(
        controller: _numberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '请输入题目数',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _saveQuestionNumber,
          child: const Text('确定'),
        ),
      ],
    );
  }

  Widget _buildLogoutDialog() {
    return AlertDialog(
      title: const Text('提示'),
      content: const Text('确定退出登录'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            // 执行退出登录
            await ref.read(authProvider.notifier).logout();
            // 跳转到登录页
            if (mounted) {
              context.go(AppRoutes.loginCenter);
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
