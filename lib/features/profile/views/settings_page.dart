import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/config/debug_config.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../constants/profile_template_assets.dart';
import '../providers/settings_provider.dart';
import '../../payment/services/iap_service.dart';

/// 设置页面 - 对应小程序 userInfo/set.vue
/// 功能：章节练习设置、隐私协议、用户协议、退出登录
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _numberController = TextEditingController();
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    // 加载设置（从服务器）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsNotifierProvider.notifier).loadSettings();
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _showQuestionNumberDialog() {
    final settingsState = ref.read(settingsNotifierProvider);
    _numberController.text = settingsState.chapterQuestionNumber.toString();
    showDialog(
      context: context,
      builder: (context) => _buildQuestionNumberDialog(),
    );
  }

  Future<void> _saveQuestionNumber() async {
    final number = int.tryParse(_numberController.text);
    if (number == null || number <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请输入正确的数字！')),
        );
      }
      return;
    }

    final success = await ref.read(settingsNotifierProvider.notifier).saveChapterQuestionNumber(number);
    
    if (mounted) {
      Navigator.pop(context);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('设置成功！')),
        );
      } else {
        final error = ref.read(settingsNotifierProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? '保存失败，请稍后重试')),
        );
      }
    }
  }

  Future<void> _logout() async {
    // ✅ 使用统一的确认对话框组件
    final confirmed = await ConfirmDialog.show(
      context,
      title: '提示',
      content: '确定退出登录',
    );
    
    if (confirmed == true) {
      // 执行退出登录
      await ref.read(authProvider.notifier).logout();
      // ✅ 退出登录后跳转到主页（公开页面），而不是登录页
      // 这样可以避免返回按钮导致的路由循环问题
      if (mounted) {
        context.go(AppRoutes.mainTab);
      }
    }
  }

  /// 🧹 清理未完成的内购交易
  Future<void> _clearPendingTransactions() async {
    // ✅ 确认对话框
    final confirmed = await ConfirmDialog.show(
      context,
      title: '清理未完成交易',
      content: '此操作会尝试处理所有未完成的内购交易。\n\n操作需要约 10 秒，期间请勿关闭应用。\n\n确定继续吗？',
    );
    
    if (confirmed != true) return;

    setState(() => _isClearing = true);
    
    try {
      // ✅ 调用 IAPService 的清理方法
      final iapService = ref.read(iapServiceProvider);
      await iapService.clearAllPendingTransactions();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 清理完成！\n请查看控制台日志了解详情'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 清理失败: $e\n\n建议重启应用或退出登录 App Store'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isClearing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 监听调试工具开关状态
    final isDebugEnabled = ref.watch(debugToolsEnabledProvider);
    // ✅ 监听设置状态
    final settingsState = ref.watch(settingsNotifierProvider);
    
    // ✅ 处理副作用（错误提示）
    ref.listen<SettingsState>(
      settingsNotifierProvider,
      (previous, next) {
        if (next.error != null && previous?.error != next.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        }
      },
    );
    
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
            trailing: settingsState.isLoading 
                ? '加载中...' 
                : '每次${settingsState.chapterQuestionNumber}道题',
            onTap: settingsState.isLoading ? () {} : _showQuestionNumberDialog,
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
          _buildSettingItem(
            title: '关于我们',
            onTap: () {
              context.push(AppRoutes.aboutUs);
            },
          ),
          _buildSettingItem(
            title: '删除账户',
            onTap: () {
              context.push(AppRoutes.deleteAccountRisk);
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
                  
                  // ✅ iOS 内购交易清理按钮
                  _buildDebugActionItem(
                    iconPath: ProfileTemplateAssets.iconCleaning,
                    title: '清理未完成交易',
                    subtitle: '清理 iOS 内购的 pending transaction（仅 iOS）',
                    isLoading: _isClearing,
                    onTap: _isClearing ? null : _clearPendingTransactions,
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

  Widget _buildDebugActionItem({
    required String iconPath,
    required String title,
    required String subtitle,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 20.sp,
                height: 20.sp,
                colorFilter: const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 12.w),
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
            if (isLoading)
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              )
            else
              SvgPicture.asset(
                ProfileTemplateAssets.iconChevronRight,
                width: 16.sp,
                height: 16.sp,
                colorFilter: const ColorFilter.mode(Color(0xFF787E8F), BlendMode.srcIn),
              ),
          ],
        ),
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
                  SvgPicture.asset(
                    ProfileTemplateAssets.iconChevronRight,
                    width: 18.sp,
                    height: 18.sp,
                    colorFilter: const ColorFilter.mode(Color(0xFF787E8F), BlendMode.srcIn),
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
    final settingsState = ref.watch(settingsNotifierProvider);
    
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
          onPressed: settingsState.isLoading ? null : () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: settingsState.isLoading ? null : _saveQuestionNumber,
          child: settingsState.isLoading
              ? SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('确定'),
        ),
      ],
    );
  }

}
