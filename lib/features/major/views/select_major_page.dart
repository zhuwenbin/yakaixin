import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/widgets/loading_hud.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/major_provider.dart';

/// 选择专业页面
/// 对应小程序: src/modules/jintiku/pages/major/index.vue
class SelectMajorPage extends ConsumerStatefulWidget {
  final bool? canGoBack; // 是否可以返回（从我的页面进入时为true）

  const SelectMajorPage({
    super.key,
    this.canGoBack,
  });

  @override
  ConsumerState<SelectMajorPage> createState() => _SelectMajorPageState();
}

class _SelectMajorPageState extends ConsumerState<SelectMajorPage> {
  String? _selectedParentId; // 已选择的一级分类ID
  String? _selectedParentName; // 已选择的一级分类名称
  String? _selectedMajorId; // 已选择的专业ID
  String? _selectedMajorName; // 已选择的专业名称

  @override
  void initState() {
    super.initState();
    // 加载专业列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(majorProvider.notifier).loadMajors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final majorState = ref.watch(majorProvider);
    final isLoading = majorState.isLoading;
    final majorList = majorState.majors;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16696400618188716166964006181894592_backThree.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Column(
                    children: [
                      SizedBox(height: 100.h),
                      // 标题
                      Text(
                        '你的专业是？',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF03203D),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // 提示
                      Text(
                        '填写后定制你的个性化课程中心',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF03203D).withOpacity(0.45),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // 内容区域
                      if (_selectedParentId == null)
                        _buildParentList(majorList)
                      else
                        _buildMajorList(majorList),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
        ),
      ),
      // 底部提交按钮
      floatingActionButton: _selectedMajorId != null
          ? _buildSubmitButton()
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// 一级分类列表
  Widget _buildParentList(List<dynamic> majorList) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 16.h,
      children: majorList.map((parent) {
        final parentId = parent['id']?.toString() ?? '';
        final parentName = parent['data_name']?.toString() ?? '';
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedParentId = parentId;
              _selectedParentName = parentName;
            });
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 107.w),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 17.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE4F2FF).withOpacity(0.5),
                  blurRadius: 12.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Text(
              parentName,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF03203D),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 专业列表（二级）
  Widget _buildMajorList(List<dynamic> majorList) {
    final selectedParent = majorList.firstWhere(
      (p) => p['id']?.toString() == _selectedParentId,
      orElse: () => {},
    );
    
    final subs = selectedParent['subs'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 返回按钮
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedParentId = null;
              _selectedParentName = null;
              _selectedMajorId = null;
              _selectedMajorName = null;
            });
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 107.w),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 17.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE4F2FF).withOpacity(0.5),
                  blurRadius: 12.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/1669641564098755c166964156409840548_left.png',
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  _selectedParentName ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2E68FF),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.h),
        // 专业分类标题
        Text(
          _selectedParentName ?? '',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFF03203D).withOpacity(0.45),
          ),
        ),
        SizedBox(height: 16.h),
        // 专业列表
        Wrap(
          spacing: 12.w,
          runSpacing: 16.h,
          children: subs.map((major) {
            final majorId = major['id']?.toString() ?? '';
            final majorName = major['data_name']?.toString() ?? '';
            final isSelected = _selectedMajorId == majorId;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMajorId = majorId;
                  _selectedMajorName = majorName;
                });
              },
              child: Container(
                constraints: BoxConstraints(minWidth: 107.w),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 17.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE4F2FF).withOpacity(0.5),
                      blurRadius: 12.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Text(
                  majorName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? Color(0xFF2E68FF) : Color(0xFF03203D),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 32.h),
        // 提示
        Center(
          child: Text(
            '该信息可随时在首页更改',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF03203D).withOpacity(0.45),
            ),
          ),
        ),
      ],
    );
  }

  /// 提交按钮
  Widget _buildSubmitButton() {
    return Container(
      width: 248.w,
      height: 44.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E68FF), Color(0xFF2E68FF)],
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2E68FF).withOpacity(0.25),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleSubmit,
          borderRadius: BorderRadius.circular(22.r),
          child: Center(
            child: Text(
              '提交',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 提交专业选择
  /// 对应小程序: major/index.vue:107-141
  Future<void> _handleSubmit() async {
    if (_selectedMajorId == null || _selectedMajorName == null) {
      ToastUtil.error('请先选择专业');
      return;
    }

    try {
      LoadingHUD.show('提交中...');

      // 调用API保存专业
      await ref.read(majorProvider.notifier).saveMajor(
        majorId: _selectedMajorId!,
        majorName: _selectedMajorName!,
      );

      LoadingHUD.dismiss();
      ToastUtil.success('保存成功');

      // 延迟一下再跳转，让用户看到成功提示
      await Future.delayed(Duration(milliseconds: 500));

      if (!mounted) return;

      // 根据canGoBack决定跳转逻辑
      if (widget.canGoBack == true) {
        // 从我的页面进入，返回上一页
        context.pop();
      } else {
        // 从登录进入，跳转到首页
        context.go(AppRoutes.home);
      }
    } catch (e) {
      LoadingHUD.dismiss();
      ToastUtil.error(e.toString());
    }
  }
}
