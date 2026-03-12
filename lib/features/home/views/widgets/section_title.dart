import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/config/api_config.dart';

/// 区域标题组件
/// 对应小程序: .title
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ 使用 Image.network 避免 iOS Release 模式 Content-Disposition 问题
        // Image.network(
        //   ApiConfig.completeImageUrl('title-icon.png'),
        //   width: 15.w,
        //   height: 15.w,
        //   fit: BoxFit.contain,
        //   errorBuilder: (context, error, stackTrace) {
        //     // 图标加载失败时显示一个默认图标
        //     return Container(
        //       width: 15.w,
        //       height: 15.w,
        //       decoration: BoxDecoration(
        //         color: Color(0xFF018BFF),
        //         shape: BoxShape.circle,
        //       ),
        //       child: Icon(
        //         Icons.star,
        //         size: 10.w,
        //         color: Colors.white,
        //       ),
        //     );
        //   },
        // ),
        // SizedBox(width: 5.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF161f30),
          ),
        ),
      ],
    );
  }
}
