import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _loadUserInfo() {
    // TODO: 从存储获取用户信息
    setState(() {
      _nicknameController.text = '张三';
      _avatarUrl = '';
    });
  }

  Future<void> _pickImage() async {
    // TODO: 实现图片选择和上传
    print('选择头像');
  }

  Future<void> _save() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      // TODO: 显示错误提示
      return;
    }
    if (_avatarUrl.isEmpty) {
      // TODO: 显示错误提示
      return;
    }

    // TODO: 保存到服务器
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('个人信息'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildAvatarSection(),
                  SizedBox(height: 16.h),
                  _buildNicknameField(),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
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
                  color: const Color(0xFF03203D).withOpacity(0.65),
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
            onTap: _pickImage,
            child: _buildAvatar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        shape: BoxShape.circle,
      ),
      child: _avatarUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                _avatarUrl,
                width: 58.w,
                height: 58.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 32.sp,
                    color: const Color(0xFF999999),
                  );
                },
              ),
            )
          : Icon(
              Icons.person,
              size: 32.sp,
              color: const Color(0xFF999999),
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
              color: const Color(0xFF03203D).withOpacity(0.65),
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

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      child: SizedBox(
        width: double.infinity,
        height: 44.h,
        child: ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E68FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
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
