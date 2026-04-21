import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/toast_util.dart';
import '../../../core/widgets/loading_hud.dart';
import '../providers/major_provider.dart';

/// 选择专业页面
/// 对应小程序: src/modules/jintiku/pages/major/index.vue
/// 左右分栏布局：左侧分类 + 右侧平铺专业
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
  // 当前选中的左侧分类索引
  int _selectedLeftIndex = 0;

  // 当前选中的专业ID和名称（第三层）
  String? _selectedMajorId;
  String? _selectedMajorName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(majorProvider.notifier).loadMajors();
    });
  }

  /// 检查某个第一级分类下是否有第三层专业（叶子节点）
  bool _hasLeafMajors(dynamic parent) {
    final subs = parent['subs'] as List<dynamic>? ?? [];
    for (final sub in subs) {
      final subSubs = sub['subs'] as List<dynamic>? ?? [];
      if (subSubs.isNotEmpty) return true;
    }
    return false;
  }

  /// 获取某个第一级分类下的所有第三层专业（扁平化）
  List<Map<String, String>> _getAllLeafMajors(dynamic parent) {
    final result = <Map<String, String>>[];
    final subs = parent['subs'] as List<dynamic>? ?? [];
    for (final sub in subs) {
      final subName = sub['data_name']?.toString() ?? '';
      final subSubs = sub['subs'] as List<dynamic>? ?? [];
      for (final major in subSubs) {
        result.add({
          'id': major['id']?.toString() ?? '',
          'name': major['data_name']?.toString() ?? '',
          'parentName': subName,
        });
      }
    }
    return result;
  }

  /// 获取第一个有子专业的分类索引
  int _getFirstValidIndex(List<dynamic> majorList) {
    for (int i = 0; i < majorList.length; i++) {
      if (_hasLeafMajors(majorList[i])) return i;
    }
    return 0;
  }

  /// 返回时自动选择第一个专业
  void _autoSelectFirstMajor(List<dynamic> majorList) {
    for (final parent in majorList) {
      final majors = _getAllLeafMajors(parent);
      if (majors.isNotEmpty) {
        final first = majors.first;
        _submitSelection(first['id']!, first['name']!);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final majorState = ref.watch(majorProvider);
    final isLoading = majorState.isLoading;
    final majorList = majorState.majors;
    final error = majorState.error;

    // 如果有数据，确保选中第一个有效分类
    if (majorList.isNotEmpty) {
      final firstValidIndex = _getFirstValidIndex(majorList);
      if (_selectedLeftIndex >= majorList.length || !_hasLeafMajors(majorList[_selectedLeftIndex])) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedLeftIndex = firstValidIndex;
            });
          }
        });
      }
    }

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedMajorId == null && majorList.isNotEmpty) {
          _autoSelectFirstMajor(majorList);
        } else if (_selectedMajorId != null) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 隐藏返回按钮
          title: Text(
            '选择专业',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : error != null
                ? _buildErrorState(error, primaryColor)
                : majorList.isEmpty
                    ? _buildEmptyState(primaryColor)
                    : _buildContent(majorList, primaryColor),
        bottomNavigationBar: _selectedMajorId != null
            ? Container(
                padding: EdgeInsets.only(
                  left: 40.w,
                  right: 40.w,
                  top: 12.h,
                  bottom: 12.h + MediaQuery.of(context).padding.bottom,
                ),
                child: _buildSubmitButton(primaryColor),
              )
            : null,
      ),
    );
  }

  Widget _buildErrorState(String error, Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.w, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            '加载失败',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => ref.read(majorProvider.notifier).loadMajors(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('重新加载'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 48.w, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            '暂无专业数据',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => ref.read(majorProvider.notifier).loadMajors(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('重新加载'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<dynamic> majorList, Color primaryColor) {
    final selectedParent = majorList[_selectedLeftIndex.clamp(0, majorList.length - 1)];
    final leafMajors = _getAllLeafMajors(selectedParent);

    return Row(
      children: [
        // 左侧分类列表
        Container(
          width: 100.w,
          color: const Color(0xFFF5F5F5),
          child: ListView.builder(
            itemCount: majorList.length,
            itemBuilder: (context, index) {
              final parent = majorList[index];
              final parentName = parent['data_name']?.toString() ?? '';
              final hasChildren = _hasLeafMajors(parent);
              final isSelected = _selectedLeftIndex == index;

              return GestureDetector(
                onTap: hasChildren
                    ? () {
                        setState(() {
                          _selectedLeftIndex = index;
                        });
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isSelected ? primaryColor : Colors.transparent,
                        width: 3.w,
                      ),
                    ),
                  ),
                  child: Text(
                    parentName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: !hasChildren
                          ? Colors.grey // 无子专业：置灰
                          : isSelected
                              ? primaryColor // 选中：主题色
                              : const Color(0xFF333333),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        ),
        // 右侧专业列表
        Expanded(
          child: Container(
            color: Colors.white,
            child: leafMajors.isEmpty
                ? Center(
                    child: Text(
                      '该分类下暂无专业',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      // 分组显示专业
                      _buildMajorGroups(selectedParent, primaryColor),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  /// 按第二级分组显示第三级专业
  Widget _buildMajorGroups(dynamic parent, Color primaryColor) {
    final subs = parent['subs'] as List<dynamic>? ?? [];
    final List<Widget> groups = [];

    for (final sub in subs) {
      final subName = sub['data_name']?.toString() ?? '';
      final subSubs = sub['subs'] as List<dynamic>? ?? [];

      if (subSubs.isEmpty) continue;

      // 分组标题（第二级）
      groups.add(
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
          child: Text(
            subName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      );

      // 第三级专业平铺
      groups.add(
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: subSubs.map((major) {
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.1) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  majorName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? primaryColor : const Color(0xFF333333),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups,
    );
  }

  /// 提交按钮
  Widget _buildSubmitButton(Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          elevation: 0,
        ),
        child: Text(
          '提交',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// 提交专业选择
  Future<void> _handleSubmit() async {
    if (_selectedMajorId == null || _selectedMajorName == null) {
      ToastUtil.error('请先选择专业');
      return;
    }

    await _submitSelection(_selectedMajorId!, _selectedMajorName!);
  }

  /// 提交选择（支持自动选择时调用）
  Future<void> _submitSelection(String majorId, String majorName) async {
    try {
      LoadingHUD.show('提交中...');

      await ref.read(majorProvider.notifier).saveMajor(
        majorId: majorId,
        majorName: majorName,
      );

      LoadingHUD.dismiss();
      ToastUtil.success('保存成功');

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      if (widget.canGoBack == true) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    } on DioException catch (e) {
      LoadingHUD.dismiss();
      final errorMsg = e.error?.toString() ?? '保存失败，请稍后重试';
      ToastUtil.error(errorMsg);
    } catch (e) {
      LoadingHUD.dismiss();
      ToastUtil.error('保存失败，请稍后重试');
    }
  }
}
