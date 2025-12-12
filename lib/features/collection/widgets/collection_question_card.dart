import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yakaixin_app/core/theme/app_colors.dart';
import 'package:yakaixin_app/core/theme/app_text_styles.dart';
import '../models/collection_question_model.dart';

/// 收藏题目卡片
/// 对应小程序: collect/index.vue Line 20-64
class CollectionQuestionCard extends StatelessWidget {
  final CollectionQuestionModel question;
  final VoidCallback onTap;

  const CollectionQuestionCard({
    super.key,
    required this.question,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题目标题
            _buildQuestionTitle(),
            
            SizedBox(height: 11.h),
            
            // 收藏时间和难度星级
            _buildQuestionInfo(),
          ],
        ),
      ),
    );
  }

  /// 题目标题
  /// 对应小程序: Line 26-43
  Widget _buildQuestionTitle() {
    // ✅ 现在titleInfo已经是List<String>?，不需要手动转换
    final titleInfo = question.titleInfo ?? [];
    
    // 病例题型
    if (question.thematicStem != null && question.thematicStem!.isNotEmpty) {
      return Text(
        '病例：${question.thematicStem}',
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF212121),
        ),
      );
    }
    
    // B1题型 - 显示选项列表
    if (_isB1Type() && titleInfo.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: titleInfo.asMap().entries.map((entry) {
          final int index = entry.key;
          final option = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < titleInfo.length - 1 ? 4.h : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${String.fromCharCode(65 + index)}、',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                Expanded(
                  child: Html(
                    data: option,
                    style: {
                      "body": Style(
                        fontSize: FontSize(15.sp),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
    
    // 其他题型 - 显示题干内容
    if (titleInfo.isNotEmpty) {
      return Html(
        data: titleInfo[0],
        style: {
          "body": Style(
            fontSize: FontSize(15.sp),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212121),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
        },
      );
    }
    
    return const SizedBox.shrink();
  }

  /// 题目信息(时间 + 难度星级)
  /// 对应小程序: Line 45-63
  Widget _buildQuestionInfo() {
    final createdAt = question.createdAt ?? '';
    final displayTime = createdAt.length >= 16 
        ? createdAt.substring(0, 16) 
        : createdAt;
    
    return Row(
      children: [
        // 收藏时间
        Text(
          displayTime,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 12.sp,
            color: const Color(0xFF898A8D),
          ),
        ),
        
        const Spacer(),
        
        // 难度星级
        _buildDifficultyStars(),
      ],
    );
  }

  /// 难度星级
  /// 对应小程序: Line 49-61
  Widget _buildDifficultyStars() {
    final level = int.tryParse(question.level) ?? 0;
    
    return Row(
      children: List.generate(5, (index) {
        final isFilled = index < level;
        return Padding(
          padding: EdgeInsets.only(right: index < 4 ? 4.5.w : 0),
          child: Image.network(
            isFilled
                ? 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16953700953269c48169537009532642625_%E7%BC%96%E7%BB%84%E5%A4%87%E4%BB%BD%205%402x.png'
                : 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/public/16953700763015ff616953700763011336_Fill%202%402x.png',
            width: 12.w,
            height: 12.w,
            errorBuilder: (_, __, ___) => Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: 12.sp,
              color: isFilled ? Colors.amber : Colors.grey,
            ),
          ),
        );
      }),
    );
  }

  /// 判断是否为B1题型
  bool _isB1Type() {
    return question.type == '5'; // B1题型
  }
}
