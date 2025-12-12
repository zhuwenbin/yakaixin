import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';  // ✅ 添加图片选择
import 'dart:io';  // ✅ 用于File类型
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';

/// 纠错弹窗
/// 
/// 对应小程序: error-correction.vue
/// 
/// 功能:
/// - 选择错误类型（题干/答案/解析/知识点/其他）
/// - 输入错误描述
/// - 上传截图（可选）
/// - 提交纠错
class ErrorCorrectionDialog extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? onSubmit;  // 提交回调
  
  const ErrorCorrectionDialog({
    this.onSubmit,
    super.key,
  });

  /// 显示纠错弹窗
  static Future<void> show(
    BuildContext context, {
    ValueChanged<Map<String, dynamic>>? onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ErrorCorrectionDialog(onSubmit: onSubmit);
      },
    );
  }

  @override
  State<ErrorCorrectionDialog> createState() => _ErrorCorrectionDialogState();
}

class _ErrorCorrectionDialogState extends State<ErrorCorrectionDialog> {
  String _selectedType = '';  // 选中的错误类型
  final TextEditingController _descriptionController = TextEditingController();
  String _imagePath = '';  // 上传的图片路径
  File? _imageFile;  // ✅ 本地图片文件
  final ImagePicker _picker = ImagePicker();  // ✅ 图片选择器

  /// 错误类型列表（对应小程序 Line 69-90）
  static const List<Map<String, String>> _errorTypes = [
    {'id': '1', 'label': '题干'},
    {'id': '2', 'label': '答案'},
    {'id': '3', 'label': '解析'},
    {'id': '4', 'label': '知识点'},
    {'id': '5', 'label': '其他'},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 半屏显示：使用屏幕高度的70%
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = screenHeight * 0.7;
    
    // ✅ 获取键盘高度，确保输入框不被键盘遮挡
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      height: sheetHeight + bottomInset,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // 标题栏
            _buildHeader(),
            
            // 内容区（可滚动）
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: bottomInset + 16.h,  // ✅ 键盘弹起时留出空间
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    
                    // 错误类型
                    _buildSectionTitle('错误类型'),
                    SizedBox(height: 12.h),
                    _buildTypeSelector(),
                    
                    SizedBox(height: 20.h),
                    
                    // 错误描述
                    _buildSectionTitle('错误描述'),
                    SizedBox(height: 12.h),
                    _buildDescriptionInput(),
                    
                    SizedBox(height: 20.h),
                    
                    // ✅ 图片上传（对应小程序 Line 25-32）
                    _buildImageUpload(),
                    
                    SizedBox(height: 20.h),
                    
                    // 提交按钮
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('纠错', style: AppTextStyles.heading4),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 构建章节标题
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 构建错误类型选择器
  /// 对应小程序 Line 180-197
  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 10.w,
      runSpacing: 16.h,
      children: _errorTypes.map((type) {
        final isSelected = _selectedType == type['id'];
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedType = type['id']!.toString();  // ✅ 确保是 String 类型
            });
          },
          child: Container(
            width: 107.w,  // 对应小程序 214rpx ÷ 2
            height: 34.h,  // 对应小程序 68rpx ÷ 2
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEBF1FF) : const Color(0xFFF6F7F8),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1,
              ),
              borderRadius: AppRadius.radiusLg,
            ),
            alignment: Alignment.center,
            child: Text(
              type['label']!,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建错误描述输入框
  /// 对应小程序 Line 18-24
  Widget _buildDescriptionInput() {
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: '请输入错误描述',
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: AppTextStyles.bodyMedium,
      ),
    );
  }

  /// 构建图片上传区域
  /// 对应小程序 Line 25-32, Line 140-144
  Widget _buildImageUpload() {
    return GestureDetector(
      onTap: _handleImagePick,
      child: Container(
        width: 124.w,  // 对应小程序 248rpx ÷ 2
        height: 124.w,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40.sp,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '上传图片',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: AppRadius.radiusMd,
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
      ),
    );
  }

  /// 处理图片选择
  /// 对应小程序 Line 140-144 handleUploadingImg()
  Future<void> _handleImagePick() async {
    try {
      // ✅ 弹出选择对话框：相机 or 相册
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('选择图片来源'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('从相册选择'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('拍照'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      // ✅ 选择图片
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,  // ✅ 限制图片宽度
        maxHeight: 1920,
        imageQuality: 85,  // ✅ 压缩质量
      );

      if (pickedFile == null) return;

      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePath = pickedFile.path;  // ⚠️ 暂时使用本地路径，后续需要上传到OSS
      });

      print('✅ 图片选择成功: ${pickedFile.path}');
      
      // TODO: 上传图片到OSS，获取远程URL
      // final uploadedUrl = await uploadToOSS(_imageFile!);
      // setState(() {
      //   _imagePath = uploadedUrl;
      // });
      
    } catch (e) {
      print('❌ 图片选择失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('图片选择失败: $e')),
        );
      }
    }
  }

  /// 构建提交按钮
  /// 对应小程序 Line 33-35
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusMd,
          ),
        ),
        child: Text(
          '提交',
          style: AppTextStyles.buttonMedium,
        ),
      ),
    );
  }

  /// 处理提交
  /// 对应小程序 Line 114-135
  void _handleSubmit() {
    // ✅ 验证错误类型
    if (_selectedType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择纠错类型')),
      );
      return;
    }
    
    // ✅ 验证错误描述
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入详细内容')),
      );
      return;
    }
    
    // ✅ 返回纠错数据（明确类型为 List<String>）
    widget.onSubmit?.call({
      'err_type': _selectedType,
      'description': _descriptionController.text.trim(),
      'file_path': _imagePath.isEmpty ? <String>[] : <String>[_imagePath],  // ✅ 明确类型
    });
    
    // ✅ 关闭弹窗
    Navigator.pop(context);
  }
}
