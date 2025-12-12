import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// HTML内容渲染组件
/// 
/// 功能:
/// - 移除HTML标签，保留纯文本
/// - 处理HTML实体字符 (&nbsp; &lt; &gt;)
/// - 支持自定义文本样式
/// 
/// 使用场景:
/// - 题目内容显示
/// - 选项内容显示
/// - 解析内容显示
class HtmlContentView extends StatelessWidget {
  final String content;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const HtmlContentView({
    required this.content,
    this.textStyle,
    this.maxLines,
    this.overflow,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final processedText = _processHtmlContent(content);
    
    return Text(
      processedText,
      style: textStyle ?? AppTextStyles.bodyMedium.copyWith(
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
  
  /// 处理HTML内容
  /// 对应小程序: 移除HTML标签和实体字符
  String _processHtmlContent(String html) {
    if (html.isEmpty) return '';
    
    String processed = html;
    
    // 1. 移除HTML标签
    processed = processed.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // 2. 处理HTML实体字符
    processed = processed.replaceAll(RegExp(r'&nbsp;'), ' ');
    processed = processed.replaceAll(RegExp(r'&lt;'), '<');
    processed = processed.replaceAll(RegExp(r'&gt;'), '>');
    processed = processed.replaceAll(RegExp(r'&amp;'), '&');
    processed = processed.replaceAll(RegExp(r'&quot;'), '"');
    processed = processed.replaceAll(RegExp(r'&apos;'), "'");
    
    // 3. 移除多余的空白字符
    processed = processed.replaceAll(RegExp(r'\s+'), ' ');
    processed = processed.trim();
    
    return processed;
  }
}
