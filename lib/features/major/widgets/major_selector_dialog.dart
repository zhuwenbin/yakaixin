import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/storage/storage_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart' as auth_model;
import '../models/major_model.dart';
import '../services/major_service.dart';

/// 专业选择弹窗
/// 对应小程序: components/select-major.vue
class MajorSelectorDialog extends ConsumerStatefulWidget {
  final VoidCallback? onChanged;
  /// 弹窗顶部偏移量（可选）
  /// 如果不提供，则使用默认值（首页：statusBarHeight + 48.h + 1）
  /// 题库页面需要传入按钮底部位置
  final double? topOffset;

  const MajorSelectorDialog({
    super.key,
    this.onChanged,
    this.topOffset,
  });

  @override
  ConsumerState<MajorSelectorDialog> createState() => _MajorSelectorDialogState();
}

class _MajorSelectorDialogState extends ConsumerState<MajorSelectorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  String? _selectedLeftId;
  List<MajorModel> _dataList = [];
  List<MajorModel> _rightItems = [];
  bool _isLoading = true;
  CurrentMajor? _currentMajor;

  @override
  void initState() {
    super.initState();
    
    // 动画控制器
    _animationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // 开始动画
    _animationController.forward();
    
    // 加载专业列表和当前选中的专业
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 加载数据
  Future<void> _loadData() async {
    try {
      // 加载当前选中的专业
      final storage = ref.read(storageServiceProvider);
      final majorJson = storage.getJson(StorageKeys.majorInfo);
      if (majorJson != null) {
        _currentMajor = CurrentMajor.fromJson(majorJson);
      }

      // 加载专业列表
      final service = ref.read(majorServiceProvider);
      final response = await service.getMajorList();

      setState(() {
        _dataList = response.list;
        _isLoading = false;
      });

      // 默认选中第一个左侧分类（医学类）
      if (_dataList.isNotEmpty) {
        final defaultItem = _dataList.firstWhere(
          (item) => item.id == '524032969673806221',
          orElse: () => _dataList.first,
        );
        _getRightInfo(defaultItem);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      EasyLoading.showError('加载失败: $e');
      print('❌ 加载专业列表失败: $e');
    }
  }

  /// 获取右侧内容
  void _getRightInfo(MajorModel item) {
    setState(() {
      _selectedLeftId = item.id;
      _rightItems = item.subs;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 计算弹窗顶部位置
    // 如果提供了 topOffset，使用提供的值；否则使用默认值（首页的情况）
    final dialogTop = widget.topOffset ?? () {
      final statusBarHeight = MediaQuery.of(context).padding.top;
      final headerHeight = statusBarHeight + 48.h;
      // ✅ 添加1像素偏移，确保在小米真机上不覆盖按钮
      return headerHeight + 1;
    }();

    return GestureDetector(
      onTap: _close,
      child: Stack(
        children: [
          // ✅ 遮罩从按钮下方开始（headerHeight + 1）
          Positioned(
            top: dialogTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          // ✅ 内容区域从按钮下方开始下拉（使用高度展开动画，与小程序一致）
          Positioned(
            top: dialogTop,
            left: 0,
            right: 0,
            child: SizeTransition(
              sizeFactor: _animation, // ✅ 高度展开动画（从0到1）
              axis: Axis.vertical,
              axisAlignment: -1.0, // 从顶部开始展开
              child: GestureDetector(
                onTap: () {}, // 阻止点击事件冒泡
                child: Container(
                  height: 480.h, // 小程序960rpx ÷ 2 = 480.h
                  color: Colors.white,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            // 左侧分类列表
                            _buildLeftList(),
                            // 右侧专业列表
                            Expanded(
                              child: _buildRightList(),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 左侧分类列表
  Widget _buildLeftList() {
    return Container(
      width: 92.w, // 小程序184rpx ÷ 2 = 92.w
      color: Color(0xFFF6F7F8),
      child: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          final item = _dataList[index];
          final isActive = _selectedLeftId == item.id;

          return GestureDetector(
            onTap: () => _getRightInfo(item),
            child: Container(
              height: 48.h, // 小程序96rpx ÷ 2 = 48.h
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              color: isActive ? Colors.white : Color(0xFFF6F7F8),
              child: Text(
                item.dataName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp, // 小程序26rpx ÷ 2 = 13.sp
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF03203D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 右侧专业列表（支持分组显示）
  Widget _buildRightList() {
    if (_rightItems.isEmpty) {
      return Center(
        child: Text(
          '暂无专业',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 15.h),
      itemCount: _rightItems.length,
      itemBuilder: (context, index) {
        final group = _rightItems[index];
        return _buildGroupSection(group);
      },
    );
  }

  /// 分组区域
  Widget _buildGroupSection(MajorModel group) {
    final items = group.subs.isNotEmpty ? group.subs : [group];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.subs.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              group.dataName,
              style: TextStyle(
                fontSize: 12.sp, // ✅ 小程序24rpx ÷ 2 = 12.sp
                fontWeight: FontWeight.w400, // ✅ 小程序font-weight: 400
                color: const Color(0xFF03203D).withOpacity(0.65), // ✅ 小程序rgba(3, 32, 61, 0.65)
              ),
            ),
          ),
        Wrap(
          spacing: 11.w,
          runSpacing: 16.h,
          children: items.map((item) => _buildMajorItem(item)).toList(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  /// 专业项
  Widget _buildMajorItem(MajorModel item) {
    final isActive = _currentMajor?.majorId == item.id;

    return GestureDetector(
      onTap: () => _selectMajor(item),
      child: Container(
        width: (1.sw - 92.w - 24.w - 11.w) / 2, // 计算宽度
        height: 34.h, // 对应小程序 68rpx
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEBF1FF) : const Color(0xFFF6F7F8),
          border: Border.all(
            color: isActive
                ? const Color(0xFF2E68FF).withOpacity(0.5)
                : Colors.transparent,
            width: isActive ? 1 : 0,
          ),
          borderRadius: BorderRadius.circular(17.r), // 对应小程序 34rpx
        ),
        child: Text(
          item.dataName,
          style: TextStyle(
            fontSize: 12.sp, // ✅ 小程序24rpx ÷ 2 = 12.sp
            fontWeight: FontWeight.w400, // ✅ 小程序font-weight: 400（常规）
            color: isActive ? const Color(0xFF2E68FF) : const Color(0xFF03203D), // ✅ 小程序颜色
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// 选择专业
  /// 对应小程序: change (Line 96-132)
  Future<void> _selectMajor(MajorModel item) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final studentId = storage.getString(StorageKeys.studentId);

      if (studentId != null && studentId.isNotEmpty) {
        // 已登录：调用API更新专业
        EasyLoading.show(status: '保存中...');
        final service = ref.read(majorServiceProvider);
        await service.selectMajor(
          studentId: studentId,
          majorId: item.id,
        );
        EasyLoading.dismiss();
      }

      // 保存到本地存储
      final currentMajor = CurrentMajor(
        majorId: item.id,
        majorName: item.dataName,
        majorPidLevel: item.level,
      );
      await storage.setJson(StorageKeys.majorInfo, currentMajor.toJson());
      await storage.setString(StorageKeys.currentMajorId, item.id);

      // ✅ 关键修复：更新 authProvider 的专业状态
      // 这样 currentMajorProvider 才能读取到最新的专业信息
      // 注意：使用 auth_model.MajorModel（来自 user_model.dart）
      final majorModel = auth_model.MajorModel(
        majorId: item.id,
        majorName: item.dataName,
      );
      // ✅ 必须 await，确保状态更新后再触发 onChanged，否则 loadHomeData() 会读到旧专业 ID
      await ref.read(authProvider.notifier).switchMajor(majorModel);

      // 回调（此时 currentMajorProvider 已为新专业，loadHomeData 会加载正确数据）
      if (widget.onChanged != null) {
        widget.onChanged!();
      }

      _close();
    } catch (e) {
      EasyLoading.showError('操作失败: $e');
      print('❌ 选择专业失败: $e');
    }
  }

  /// 关闭弹窗
  void _close() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// 显示专业选择弹窗
/// [topOffset] 弹窗顶部偏移量（可选）
/// 如果不提供，则使用默认值（首页：statusBarHeight + 48.h + 1）
/// 题库页面需要传入按钮底部位置
Future<void> showMajorSelector(
  BuildContext context, {
  VoidCallback? onChanged,
  double? topOffset,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => MajorSelectorDialog(
      onChanged: onChanged,
      topOffset: topOffset,
    ),
  );
}
