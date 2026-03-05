import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/api_config.dart';
import '../providers/person_edit_provider.dart';

/// 个人信息编辑页面 - 对应小程序 my/person.vue
/// 功能：修改头像、姓名
class PersonEditPage extends ConsumerStatefulWidget {
  final String? toUrl;

  const PersonEditPage({
    super.key,
    this.toUrl,
  });

  @override
  ConsumerState<PersonEditPage> createState() => _PersonEditPageState();
}

class _PersonEditPageState extends ConsumerState<PersonEditPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // 延迟加载以避免在build期间修改状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initUserInfo();
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 初始化用户信息
  Future<void> _initUserInfo() async {
    // ✅ 调用 Provider 的 initUserInfo 方法
    await ref.read(personEditNotifierProvider.notifier).initUserInfo();
    
    // 设置文本框的值
    final state = ref.read(personEditNotifierProvider);
    _nicknameController.text = state.nickname;
    
    print('✅ [页面] 初始化用户信息完成: nickname=${state.nickname}');
  }

  /// 选择并上传头像
  /// 对应小程序 updateJobDoc (Line 95)
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image == null) return;

      if (!mounted) return;
      EasyLoading.show(status: '上传中...');

      await ref.read(personEditNotifierProvider.notifier).uploadAvatar(image.path);

      if (!mounted) return;
      EasyLoading.dismiss();

      final error = ref.read(personEditNotifierProvider).error;
      if (error != null) {
        EasyLoading.showError(error);
      }
    } catch (e) {
      if (mounted) {
        EasyLoading.dismiss();
        EasyLoading.showError('选择图片失败');
      }
    }
  }

  /// 保存个人信息
  /// 对应小程序 save (Line 71)
  Future<void> _save() async {
    // 更新昵称到Provider
    final nickname = _nicknameController.text.trim();
    ref.read(personEditNotifierProvider.notifier).updateNickname(nickname);

    EasyLoading.show(status: '保存中...');

    final success = await ref.read(personEditNotifierProvider.notifier).save();

    if (!mounted) return;
    EasyLoading.dismiss();

    if (success) {
      EasyLoading.showSuccess('保存成功');
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      // 对应小程序 Line 85-91：保存成功后返回或跳转
      if (widget.toUrl != null && widget.toUrl!.isNotEmpty) {
        context.go(widget.toUrl!);
      } else {
        context.pop();
      }
    } else {
      final error = ref.read(personEditNotifierProvider).error;
      EasyLoading.showError(error ?? '保存失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(personEditNotifierProvider);

    // 监听错误状态（上传图片时的错误）
    ref.listen<PersonEditState>(
      personEditNotifierProvider,
      (previous, next) {
        if (next.isUploading && previous?.isUploading == false) {
          // 开始上传时已在 _pickImage 中显示loading
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('修改资料'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildAvatarSection(state),
                  SizedBox(height: 16.h),
                  _buildNicknameField(),
                ],
              ),
            ),
          ),
          _buildSaveButton(state),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(PersonEditState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFD8DDE1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '头像',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF03203D).withValues(alpha: 0.65),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '上传头像',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF2E68FF),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: state.isUploading ? null : _pickImage,
            child: _buildAvatar(state),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(PersonEditState state) {
    final avatarUrl = ref.read(personEditNotifierProvider.notifier).getCompleteAvatarUrl();

    return Container(
      width: 58.w,
      height: 58.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F4F7),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          // 头像层
          Center(
            child: avatarUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      avatarUrl,
                      width: 58.w,
                      height: 58.w,
                      fit: BoxFit.cover,
                      headers: ApiConfig.ossImageHeaders,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    ),
                  )
                : _buildDefaultAvatar(),
          ),
          // 上传中的遮罩
          if (state.isUploading) _buildUploadingMask(),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      size: 32.sp,
      color: const Color(0xFF999999),
    );
  }

  Widget _buildUploadingMask() {
    return Container(
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildNicknameField() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFD8DDE1), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '姓名',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF03203D).withValues(alpha: 0.65),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _nicknameController,
            maxLength: 10,
            decoration: InputDecoration(
              hintText: '请输入你的姓名',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFCCCCCC),
              ),
              border: InputBorder.none,
              counterText: '',
            ),
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(PersonEditState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      child: SizedBox(
        width: double.infinity,
        height: 44.h,
        child: ElevatedButton(
          onPressed: state.isLoading || state.isUploading ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E68FF),
            disabledBackgroundColor: const Color(0xFF2E68FF).withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: state.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  '保存',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
