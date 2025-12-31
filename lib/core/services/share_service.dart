import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

/// 分享服务
/// 
/// 对应小程序: open-type="share" 微信分享功能
/// 
/// 功能:
/// - 分享题目（问老师）
/// - 分享课程
/// - 分享考试成绩
/// - 分享学习记录
/// 
/// 使用示例:
/// ```dart
/// await ShareService.shareQuestion(
///   questionText: '牙釉质的主要成分是？',
///   questionId: '123',
/// );
/// ```
class ShareService {
  /// 应用下载地址（需要替换为实际地址）
  static const String appDownloadUrl = 'https://yakaixin.com/download';
  
  /// 应用名称
  static const String appName = '牙开心题库';
  
  /// 分享题目（问老师功能）
  /// 
  /// 对应小程序: bottom-utils.vue askTeacher 按钮
  /// 
  /// [questionText] 题目内容
  /// [questionId] 题目ID（可选，用于生成分享链接）
  /// [shareRect] 分享弹窗的位置（iPad需要）
  static Future<void> shareQuestion({
    required String questionText,
    String? questionId,
    Rect? shareRect,
  }) async {
    // 清理HTML标签
    final cleanText = _cleanHtmlContent(questionText);
    
    // 限制题目长度（避免分享内容过长）
    final displayText = cleanText.length > 100 
        ? '${cleanText.substring(0, 100)}...' 
        : cleanText;
    
    // 构建分享链接（如果有题目ID）
    final shareLink = questionId != null 
        ? '$appDownloadUrl?question_id=$questionId'
        : appDownloadUrl;
    
    // 构建分享文本
    final shareText = '''
📚 $appName - 问老师

题目：
$displayText

一起来学习讨论吧！👇
$shareLink
''';
    
    try {
      // 调用系统分享
      await Share.share(
        shareText,
        subject: '$appName - 问老师',
        sharePositionOrigin: shareRect, // iPad需要指定分享弹窗位置
      );
    } catch (e) {
      debugPrint('❌ [ShareService] 分享失败: $e');
      rethrow;
    }
  }
  
  /// 分享课程
  /// 
  /// [courseName] 课程名称
  /// [courseId] 课程ID
  /// [coverImage] 课程封面图（可选）
  /// [shareRect] 分享弹窗的位置（iPad需要）
  static Future<void> shareCourse({
    required String courseName,
    required String courseId,
    String? coverImage,
    Rect? shareRect,
  }) async {
    final shareLink = '$appDownloadUrl?course_id=$courseId';
    
    final shareText = '''
📖 $appName - 课程推荐

《$courseName》

精品课程，助你轻松备考！👇
$shareLink
''';
    
    try {
      if (coverImage != null && coverImage.isNotEmpty) {
        // TODO: 如果需要分享图片，可以先下载图片再分享
        // final imageFile = await _downloadImage(coverImage);
        // await Share.shareXFiles([XFile(imageFile.path)], text: shareText);
        await Share.share(shareText, subject: '$appName - 课程推荐', sharePositionOrigin: shareRect);
      } else {
        await Share.share(shareText, subject: '$appName - 课程推荐', sharePositionOrigin: shareRect);
      }
    } catch (e) {
      debugPrint('❌ [ShareService] 分享课程失败: $e');
      rethrow;
    }
  }
  
  /// 分享考试成绩
  /// 
  /// [examName] 考试名称
  /// [score] 分数
  /// [totalScore] 总分
  /// [correctRate] 正确率（0-100）
  /// [shareRect] 分享弹窗的位置（iPad需要）
  static Future<void> shareExamResult({
    required String examName,
    required int score,
    required int totalScore,
    required double correctRate,
    Rect? shareRect,
  }) async {
    final shareText = '''
🎉 $appName - 考试成绩

考试：$examName
成绩：$score/$totalScore
正确率：${correctRate.toStringAsFixed(1)}%

一起来刷题提升吧！👇
$appDownloadUrl
''';
    
    try {
      await Share.share(
        shareText,
        subject: '$appName - 考试成绩',
        sharePositionOrigin: shareRect,
      );
    } catch (e) {
      debugPrint('❌ [ShareService] 分享成绩失败: $e');
      rethrow;
    }
  }
  
  /// 分享学习记录
  /// 
  /// [studyDays] 学习天数
  /// [questionCount] 做题数量
  /// [correctRate] 正确率（0-100）
  /// [shareRect] 分享弹窗的位置（iPad需要）
  static Future<void> shareStudyRecord({
    required int studyDays,
    required int questionCount,
    required double correctRate,
    Rect? shareRect,
  }) async {
    final shareText = '''
📊 $appName - 我的学习记录

✅ 已坚持学习 $studyDays 天
✅ 累计做题 $questionCount 道
✅ 正确率 ${correctRate.toStringAsFixed(1)}%

一起来打卡学习吧！👇
$appDownloadUrl
''';
    
    try {
      await Share.share(
        shareText,
        subject: '$appName - 学习记录',
        sharePositionOrigin: shareRect,
      );
    } catch (e) {
      debugPrint('❌ [ShareService] 分享学习记录失败: $e');
      rethrow;
    }
  }
  
  /// 分享应用（邀请好友）
  /// 
  /// [inviteCode] 邀请码（可选）
  /// [shareRect] 分享弹窗的位置（iPad需要）
  static Future<void> shareApp({
    String? inviteCode,
    Rect? shareRect,
  }) async {
    final inviteText = inviteCode != null ? '\n邀请码：$inviteCode' : '';
    
    final shareText = '''
📱 推荐一个超棒的学习App！

$appName - 专业的医学考试题库
海量题目、精品课程、智能刷题$inviteText

立即下载：👇
$appDownloadUrl
''';
    
    try {
      await Share.share(
        shareText,
        subject: '$appName - 邀请好友',
        sharePositionOrigin: shareRect,
      );
    } catch (e) {
      debugPrint('❌ [ShareService] 分享应用失败: $e');
      rethrow;
    }
  }
  
  /// 清理HTML内容，移除标签保留文本
  static String _cleanHtmlContent(String html) {
    if (html.isEmpty) return '';
    
    String cleaned = html;
    // 移除HTML标签
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');
    // 替换HTML实体
    cleaned = cleaned.replaceAll(RegExp(r'&nbsp;'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'&lt;'), '<');
    cleaned = cleaned.replaceAll(RegExp(r'&gt;'), '>');
    cleaned = cleaned.replaceAll(RegExp(r'&amp;'), '&');
    cleaned = cleaned.replaceAll(RegExp(r'&quot;'), '"');
    // 移除多余空格和换行
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    cleaned = cleaned.trim();
    
    return cleaned;
  }
}

