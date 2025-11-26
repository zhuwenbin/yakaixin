import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页Tab切换栏
/// 对应小程序: .tabs
class HomeTabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const HomeTabBar({
    required this.tabs,
    required this.activeIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isActive = index == activeIndex;
            return Padding(
              padding: EdgeInsets.only(
                right: index == tabs.length - 1 ? 0 : 20.w,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: _buildTabItem(
                  tabs[index],
                  isActive: isActive,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isActive ? 18.sp : 16.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.black : const Color(0xFF666666),
          ),
        ),
        if (isActive) ...[
          SizedBox(height: 4.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFF018BFF),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ],
    );
  }
}
