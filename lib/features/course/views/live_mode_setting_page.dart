import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../managers/live_manager.dart';

/// 直播模式切换页面（调试/设置页面）
/// 
/// 功能：
/// - 显示当前直播模式
/// - 切换 H5 / 原生插件模式
/// - 显示模式说明
class LiveModeSettingPage extends StatefulWidget {
  const LiveModeSettingPage({super.key});

  @override
  State<LiveModeSettingPage> createState() => _LiveModeSettingPageState();
}

class _LiveModeSettingPageState extends State<LiveModeSettingPage> {
  LiveMode _currentMode = LiveManager.instance.currentMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('直播模式设置'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _buildModeSelector(),
          SizedBox(height: AppSpacing.lgV),
          _buildModeInfo(),
          SizedBox(height: AppSpacing.lgV),
          _buildComparison(),
        ],
      ),
    );
  }

  /// 模式选择器
  Widget _buildModeSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: AppSpacing.allMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('当前模式', style: AppTextStyles.heading3),
            SizedBox(height: AppSpacing.mdV),
            
            // H5 模式
            RadioListTile<LiveMode>(
              title: Row(
                children: [
                  const Icon(Icons.web, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  const Text('H5 模式'),
                ],
              ),
              subtitle: const Text('使用 WebView，与小程序一致'),
              value: LiveMode.h5,
              groupValue: _currentMode,
              onChanged: _onModeChanged,
            ),
            
            // 原生插件模式
            RadioListTile<LiveMode>(
              title: Row(
                children: [
                  const Icon(Icons.code, color: AppColors.secondary),
                  SizedBox(width: 8.w),
                  const Text('原生插件模式'),
                ],
              ),
              subtitle: const Text('使用百家云 SDK，性能更好'),
              value: LiveMode.native,
              groupValue: _currentMode,
              onChanged: _onModeChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// 模式信息
  Widget _buildModeInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: AppSpacing.allMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('模式说明', style: AppTextStyles.heading3),
            SizedBox(height: AppSpacing.mdV),
            
            if (_currentMode == LiveMode.h5) ...[
              _buildInfoItem(
                icon: Icons.check_circle,
                title: 'H5 模式特点',
                items: [
                  '✅ 与小程序完全一致',
                  '✅ 无需额外配置',
                  '✅ 开箱即用',
                  '✅ 自动添加 URL 参数',
                ],
              ),
            ] else ...[
              _buildInfoItem(
                icon: Icons.check_circle,
                title: '原生插件模式特点',
                items: [
                  '⚡ 性能更好',
                  '⚡ 功能更丰富',
                  '⚡ UI 可定制',
                  '⚠️ 需要后端提供 sign',
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 对比表格
  Widget _buildComparison() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: AppSpacing.allMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('功能对比', style: AppTextStyles.heading3),
            SizedBox(height: AppSpacing.mdV),
            
            _buildComparisonRow('实现方式', 'WebView H5 页面', '百家云原生 SDK'),
            _buildComparisonRow('小程序对应', '✅ 完全一致', '❌ 不支持'),
            _buildComparisonRow('初始化', '无需初始化', '需要初始化 SDK'),
            _buildComparisonRow('进入方式', '直接加载 URL', '需要 sign 或参加码'),
            _buildComparisonRow('性能', '中等', '高'),
            _buildComparisonRow('UI 定制', '较困难', '容易'),
            _buildComparisonRow('推荐场景', '快速开发', '高性能需求'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Text(title, style: AppTextStyles.bodyLarge),
          ],
        ),
        SizedBox(height: 8.h),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(left: 28.w, bottom: 4.h),
          child: Text(item, style: AppTextStyles.bodySmall),
        )),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, String h5Value, String nativeValue) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(feature, style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            child: Text(
              h5Value,
              style: AppTextStyles.bodySmall.copyWith(
                color: _currentMode == LiveMode.h5 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              nativeValue,
              style: AppTextStyles.bodySmall.copyWith(
                color: _currentMode == LiveMode.native 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onModeChanged(LiveMode? mode) {
    if (mode == null) return;
    
    setState(() {
      _currentMode = mode;
      LiveManager.instance.setLiveMode(mode);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已切换到${mode == LiveMode.h5 ? "H5" : "原生插件"}模式'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
