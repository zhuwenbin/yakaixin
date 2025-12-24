import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

/// 讲义内容组件
class VideoHandout extends StatelessWidget {
  final String content;

  const VideoHandout({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return Center(
        child: Text(
          '暂无讲义',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Html(
        data: content,
        style: _htmlStyles,
        onLinkTap: _onLinkTap,
      ),
    );
  }

  Map<String, Style> get _htmlStyles => {
        // 全局样式
        "*": Style(
          fontSize: FontSize(14.sp),
          color: const Color(0xFF262629),
          lineHeight: const LineHeight(1.6),
        ),
        // 段落样式
        "p": Style(margin: Margins.only(bottom: 12.h)),
        // 标题样式
        "h1": Style(
          fontSize: FontSize(20.sp),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 16.h, top: 16.h),
        ),
        "h2": Style(
          fontSize: FontSize(18.sp),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 14.h, top: 14.h),
        ),
        "h3": Style(
          fontSize: FontSize(16.sp),
          fontWeight: FontWeight.w600,
          margin: Margins.only(bottom: 12.h, top: 12.h),
        ),
        // 列表样式
        "ul": Style(
          padding: HtmlPaddings.only(left: 20.w),
          margin: Margins.only(bottom: 12.h),
        ),
        "ol": Style(
          padding: HtmlPaddings.only(left: 20.w),
          margin: Margins.only(bottom: 12.h),
        ),
        "li": Style(margin: Margins.only(bottom: 6.h)),
        // 图片样式
        "img": Style(
          width: Width.auto(),
          margin: Margins.symmetric(vertical: 10.h),
        ),
        // 代码样式
        "code": Style(
          backgroundColor: const Color(0xFFF5F5F5),
          padding: HtmlPaddings.symmetric(horizontal: 4.w, vertical: 2.h),
          fontFamily: 'monospace',
        ),
        "pre": Style(
          backgroundColor: const Color(0xFFF5F5F5),
          padding: HtmlPaddings.all(12.w),
          margin: Margins.only(bottom: 12.h),
        ),
        // 引用样式
        "blockquote": Style(
          border: const Border(
            left: BorderSide(color: Color(0xFF3B7BFB), width: 4),
          ),
          padding: HtmlPaddings.only(left: 12.w),
          margin: Margins.only(bottom: 12.h),
          backgroundColor: const Color(0xFFF8F8F8),
        ),
        // 表格样式
        "table": Style(
          border: const Border.fromBorderSide(
            BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
          margin: Margins.only(bottom: 12.h),
        ),
        "th": Style(
          padding: HtmlPaddings.all(8.w),
          backgroundColor: const Color(0xFFF5F5F5),
          fontWeight: FontWeight.bold,
        ),
        "td": Style(
          padding: HtmlPaddings.all(8.w),
          border: const Border.fromBorderSide(
            BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
        ),
      };

  void _onLinkTap(String? url, Map<String, String> attributes, element) {
    if (url != null) {
      debugPrint('[讲义] 点击链接: $url');
      // TODO: 使用 url_launcher 打开链接
    }
  }
}
