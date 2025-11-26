import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/toast_util.dart';
import '../providers/major_provider.dart';
import '../../auth/providers/auth_provider.dart';

/// 专业选择弹窗
/// 对应小程序: components/select-major.vue
class MajorSelectorDialog extends ConsumerStatefulWidget {
  final VoidCallback? onChanged;

  const MajorSelectorDialog({
    super.key,
    this.onChanged,
  });

  @override
  ConsumerState<MajorSelectorDialog> createState() => _MajorSelectorDialogState();
}

class _MajorSelectorDialogState extends ConsumerState<MajorSelectorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  String? _selectedLeftId;
  List<dynamic> _rightItems = [];

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
    
    // 加载专业列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(majorProvider.notifier).loadMajors();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final majorState = ref.watch(majorProvider);
    final majors = majorState.majors;
    final currentMajor = ref.watch(authProvider).currentMajor;

    // 初始化默认选中（医学分类）
    if (_selectedLeftId == null && majors.isNotEmpty) {
      // 默认选中第一个分类（医学）
      final firstCategory = majors.first;
      _selectedLeftId = firstCategory['id']?.toString();
      _rightItems = firstCategory['subs'] as List<dynamic>? ?? [];
    }

    return GestureDetector(
      onTap: _close,
      child: Stack(
        children: [
          // 遮罩从header下方开始
          Positioned(
            top: 48.h, // header高度
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
          // 内容区域从header下方开始下拉
          Positioned(
            top: 48.h, // header高度
            left: 0,
            right: 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -1),
                end: Offset.zero,
              ).animate(_animation),
              child: GestureDetector(
                onTap: () {}, // 阻止点击事件冒泡
                child: Container(
                  height: 480.h, // 小程序960rpx ÷ 2 = 480.h
                  color: Colors.white,
                  child: Row(
                    children: [
                      // 左侧分类列表
                      _buildLeftList(majors),
                      // 右侧专业列表
                      Expanded(
                        child: _buildRightList(currentMajor?.majorId),
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
  Widget _buildLeftList(List<dynamic> majors) {
    return Container(
      width: 92.w, // 小程序184rpx ÷ 2 = 92.w
      color: Color(0xFFF6F7F8),
      child: ListView.builder(
        itemCount: majors.length,
        itemBuilder: (context, index) {
          final item = majors[index];
          final id = item['id']?.toString() ?? '';
          final name = item['data_name']?.toString() ?? '';
          final isActive = _selectedLeftId == id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedLeftId = id;
                _rightItems = item['subs'] as List<dynamic>? ?? [];
              });
            },
            child: Container(
              height: 48.h, // 小程序96rpx ÷ 2 = 48.h
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              color: isActive ? Colors.white : Color(0xFFF6F7F8),
              child: Text(
                name,
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

  /// 右侧专业列表
  Widget _buildRightList(String? currentMajorId) {
    if (_rightItems.isEmpty) {
      return Center(
        child: Text(
          '请先选择分类',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 15.h, 12.w, 0), // 小程序24/30/24/0 ÷ 2
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h, // 小程序32rpx ÷ 2 = 16.h
          crossAxisSpacing: 11.w, // 小程序22rpx ÷ 2 = 11.w
          childAspectRatio: 2.5, // 调整宽高比
        ),
        itemCount: _rightItems.length,
        itemBuilder: (context, index) {
          final item = _rightItems[index];
          final id = item['id']?.toString() ?? '';
          final name = item['data_name']?.toString() ?? '';
          final isActive = currentMajorId == id;

          return GestureDetector(
            onTap: () => _selectMajor(id, name),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? Color(0xFFEBF1FF) : Color(0xFFF6F7F8),
                borderRadius: BorderRadius.circular(17.r), // 小程序34rpx ÷ 2 = 17.r
                border: isActive
                    ? Border.all(color: Color(0xFF2E68FF).withOpacity(0.5), width: 1.w)
                    : null,
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp, // 小程序24rpx ÷ 2 = 12.sp
                  fontWeight: FontWeight.w400,
                  color: isActive ? Color(0xFF2E68FF) : Color(0xFF03203D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 选择专业
  Future<void> _selectMajor(String majorId, String majorName) async {
    try {
      await ref.read(majorProvider.notifier).saveMajor(
        majorId: majorId,
        majorName: majorName,
      );
      
      ToastUtil.success('操作成功');
      
      if (widget.onChanged != null) {
        widget.onChanged!();
      }
      
      _close();
    } catch (e) {
      ToastUtil.error(e.toString());
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
Future<void> showMajorSelector(
  BuildContext context, {
  VoidCallback? onChanged,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => MajorSelectorDialog(onChanged: onChanged),
  );
}
