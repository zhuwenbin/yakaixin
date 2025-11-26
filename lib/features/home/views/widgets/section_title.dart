import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 区域标题组件
/// 对应小程序: .title
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/title-icon.png',
          width: 15.w,
          height: 15.w,
          fit: BoxFit.contain,
          placeholder: (context, url) => SizedBox(
            width: 15.w,
            height: 15.w,
            child: Center(
              child: SizedBox(
                width: 10.w,
                height: 10.w,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Color(0xFF018BFF),
                ),
              ),
            ),
          ),
          errorWidget: (context, error, stackTrace) {
            // 图标加载失败时显示一个默认图标
            return Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: Color(0xFF018BFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star,
                size: 10.w,
                color: Colors.white,
              ),
            );
          },
        ),
        SizedBox(width: 5.w),
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
