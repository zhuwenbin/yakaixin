import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
            title: '隐私协议',
            onTap: () {
              // TODO: 跳转隐私协议页面
            },
          ),
          _buildSettingItem(
            title: '用户协议',
            onTap: () {
              // TODO: 跳转用户协议页面
            },
          ),
          _buildSettingItem(
            title: '退出登录',
            onTap: _logout,
            showArrow: false,
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
          onPressed: () {
            Navigator.pop(context);
            // TODO: 清除登录状态
            // context.go(AppRoutes.home);
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
