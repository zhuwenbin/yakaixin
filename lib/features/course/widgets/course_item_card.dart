import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/style/app_style_tokens.dart';
import '../../../../app/config/api_config.dart';
import '../models/course_model.dart';

/// 课程卡片组件（统一用于"学习计划"和"我的课程"）
/// 对应小程序: course.vue (ModuleStudyCourse)
class CourseItemCard extends StatelessWidget {
  /// 支持两种数据格式：
  /// 1. CourseModel - 学习计划使用
  /// 2. Map<String, dynamic> - 我的课程使用
  final dynamic courseData;

  /// 图片路径处理函数（可选，默认使用 ApiConfig.completeImageUrl）
  final String Function(String?)? completePath;

  /// 样式令牌，用于主题色
  final AppStyleTokens? styleTokens;

  const CourseItemCard({
    super.key,
    required this.courseData,
    this.completePath,
    this.styleTokens,
  });

  /// 拼接完整图片URL
  String _completePath(String? path) {
    if (completePath != null) {
      return completePath!(path);
    }
    return ApiConfig.completeImageUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 统一数据格式处理
    final goodsName = _getString('goods_name') ?? '';
    final teachingTypeName = _getString('teaching_type_name') ?? '';
    final classInfo = _getMap('class');
    final classDate = classInfo?['date']?.toString() ?? '';
    final goodsPid = _getString('goods_pid') ?? '0';
    final goodsPidName = _getString('goods_pid_name') ?? '';
    final teachers = ((classInfo?['teacher'] as List?) ?? []).where((t) {
      final avatar = t?['avatar']?.toString().trim() ?? '';
      final name = t?['name']?.toString().trim() ?? '';
      return avatar.isNotEmpty || name.isNotEmpty;
    }).toList();
    final evaluationType = _getList('evaluation_type');
    final businessType = _getValue('business_type');

    return GestureDetector(
      onTap: () => _goToCourseDetail(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          // ✅ 高端/私塘背景图（对应小程序 Line 324-336）
          image: businessType == 2
              ? DecorationImage(
                  image: NetworkImage(
                    ApiConfig.completeImageUrl(
                      'public/61c7173510867228878785_gaoduan.png',
                    ),
                  ),
                  fit: BoxFit.cover,
                )
              : businessType == 3
              ? DecorationImage(
                  image: NetworkImage(
                    ApiConfig.completeImageUrl(
                      'public/6c3f173510870217835730_sishu.png',
                    ),
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            // ✅ 左上角标签（对应小程序 Line 7-9）
            if (teachingTypeName.isNotEmpty)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 80.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: styleTokens?.colors.primary ?? const Color(0xFFFF860E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    teachingTypeName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 5.w,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ 为标签预留空间
                  SizedBox(height: teachingTypeName.isNotEmpty ? 25.h : 0),
                  // ✅ 课程名称（对应小程序 Line 15）
                  Text(
                    goodsName,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF262629),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 7.5.h),
                  // ✅ 课程日期（对应小程序 Line 18-19）
                  if (classDate.isNotEmpty)
                    Text(
                      classDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: styleTokens?.colors.tagText ?? const Color(0xFF4783DC),
                      ),
                    ),
                  // ✅ 套餐信息（对应小程序 Line 20-23）
                  if (goodsPid.isNotEmpty && goodsPid != '0')
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: styleTokens?.colors.tagText ?? const Color(0xFF4783DC),
                          ),
                          children: [
                            const TextSpan(text: '套餐：'),
                            TextSpan(text: goodsPidName),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 16.h),
                  // ✅ 教师列表（对应小程序 Line 39-49，一行显示两个）
                  if (teachers.isNotEmpty) _buildTeachersList(teachers),
                  SizedBox(height: 7.h),
                  // ✅ 操作按钮（evaluation_type）（对应小程序 Line 50-63）
                  if (evaluationType.isNotEmpty)
                    _buildEvaluationButtons(context, evaluationType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 教师列表（一行显示两个教师）
  /// 对应小程序: course.vue Line 39-49, 248-290
  /// 小程序使用: display: flex; justify-content: space-between; flex-wrap: wrap;
  Widget _buildTeachersList(List teachers) {
    // ✅ 将教师列表分组，每两个一组
    final List<List<dynamic>> teacherGroups = [];
    for (int i = 0; i < teachers.length; i += 2) {
      if (i + 1 < teachers.length) {
        teacherGroups.add([teachers[i], teachers[i + 1]]);
      } else {
        teacherGroups.add([teachers[i]]);
      }
    }

    return Column(
      children: teacherGroups.map((group) {
        return Padding(
          padding: EdgeInsets.only(bottom: 22.h), // ✅ 小程序22rpx ÷ 2 = 22.h（垂直间距）
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 第一个教师
              Expanded(
                child: _buildTeacherItem(group[0]),
              ),
              // ✅ 如果有第二个教师，显示第二个
              if (group.length > 1) ...[
                SizedBox(width: 12.w), // ✅ 两个教师之间的间距
                Expanded(
                  child: _buildTeacherItem(group[1]),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 单个教师项
  Widget _buildTeacherItem(dynamic teacher) {
    final avatar = teacher['avatar']?.toString() ?? '';
    final name = teacher['name']?.toString() ?? '';
    final title = teacher['title']?.toString() ?? '';
    final avatarUrl = avatar.isNotEmpty ? _completePath(avatar) : '';

    return Row(
      children: [
        // 头像
        Container(
          width: 40.w, // ✅ 小程序80rpx ÷ 2 = 40.w
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: styleTokens?.colors.primary ?? Colors.green,
              width: 2.w,
            ),
          ),
          child: ClipOval(
            child: avatarUrl.isEmpty
                ? Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        SizedBox(width: 5.w), // ✅ 小程序10rpx ÷ 2 = 5.w
        // 姓名和职称
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 12.sp, // ✅ 小程序24rpx ÷ 2 = 12.sp
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF262629),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h), // ✅ 小程序6rpx ÷ 2 = 3.h
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF262629).withOpacity(0.6), // ✅ 小程序rgba(38, 38, 41, 0.6)
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 操作按钮（evaluation_type）
  /// 对应小程序: course.vue Line 50-63
  Widget _buildEvaluationButtons(BuildContext context, List evaluationType) {
    // ✅ 对应小程序: v-if="btn.paper_version_id != 0"
    final validButtons = evaluationType.where((btn) {
      final paperVersionId = btn['paper_version_id'];
      // ✅ 必须存在且不等于字符串 "0" 或数字 0
      return paperVersionId != null &&
          paperVersionId.toString() != '0' &&
          paperVersionId != 0;
    }).toList();

    if (validButtons.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: validButtons.map((btn) {
        return GestureDetector(
          onTap: () => _goToAnswer(context, btn),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5.w),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Text(
              btn['name']?.toString() ?? '',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 跳转到课程详情
  /// 对应小程序: goLearnCourseDetails() Line 113-117
  void _goToCourseDetail(BuildContext context) {
    final goodsId = _getString('goods_id') ?? '';
    final orderId = _getString('order_id') ?? '';
    final goodsPid = _getString('goods_pid') ?? '';

    context.push(
      AppRoutes.courseDetail,
      extra: {'goodsId': goodsId, 'orderId': orderId, 'goodsPid': goodsPid},
    );
  }

  /// 跳转到答题页面
  /// 对应小程序: goAnswer() Line 123-128
  void _goToAnswer(BuildContext context, Map<String, dynamic> btn) {
    context.push(
      AppRoutes.makeQuestion,
      extra: {
        'paper_version_id': btn['paper_version_id']?.toString() ?? '',
        'evaluation_type_id': btn['id']?.toString() ?? '',
        'professional_id': btn['professional_id']?.toString() ?? '',
        'goods_id':
            _getString('paper_goods_id') ?? _getString('goods_id') ?? '',
        'order_id': _getString('order_id') ?? '',
        'system_id': _getString('system_id') ?? '',
        'order_detail_id': _getString('order_goods_detail_id') ?? '',
      },
    );
  }

  // ✅ 统一数据访问方法
  String? _getString(String key) {
    if (courseData is CourseModel) {
      final model = courseData as CourseModel;
      switch (key) {
        case 'goods_name':
          return model.goodsName;
        case 'teaching_type_name':
          return model.teachingTypeName;
        case 'goods_pid':
          return model.goodsPid;
        case 'goods_pid_name':
          return model.goodsPidName;
        case 'goods_id':
          return model.goodsId;
        case 'order_id':
          return model.orderId;
        default:
          return null;
      }
    } else if (courseData is Map<String, dynamic>) {
      return courseData[key]?.toString();
    }
    return null;
  }

  Map<String, dynamic>? _getMap(String key) {
    if (courseData is CourseModel) {
      final model = courseData as CourseModel;
      if (key == 'class') {
        return model.classInfo;
      }
      return null;
    } else if (courseData is Map<String, dynamic>) {
      return courseData[key] as Map<String, dynamic>?;
    }
    return null;
  }

  List _getList(String key) {
    if (courseData is Map<String, dynamic>) {
      return (courseData as Map<String, dynamic>)[key] as List? ?? [];
    }
    return [];
  }

  dynamic _getValue(String key) {
    if (courseData is Map<String, dynamic>) {
      return courseData[key];
    }
    return null;
  }
}
