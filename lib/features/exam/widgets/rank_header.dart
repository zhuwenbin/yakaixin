import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yakaixin_app/app/config/api_config.dart';

/// 排行榜头部组件 - 对应小程序 rank-header.vue
/// 显示前3名的柱状图和排行榜按钮
class RankHeader extends StatelessWidget {
  final List<Map<String, dynamic>> rankData;
  final bool showRankButton;
  final VoidCallback? onRankButtonTap;

  const RankHeader({
    super.key,
    required this.rankData,
    this.showRankButton = false,
    this.onRankButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215.w, // 对应小程序 57.5vw
      child: Stack(
        children: [
          // 背景图 - 对应小程序 Line 4-7
          _buildBackground(),
          
          // 排行榜柱状图 - 对应小程序 Line 8-54
          Positioned(
            top: 0,
            left: 10.w,
            right: 10.w,
            bottom: 0,
            child: _buildBars(),
          ),
          
          // 排行榜按钮 - 对应小程序 Line 55
          if (showRankButton) _buildRankButton(),
        ],
      ),
    );
  }

  /// 背景图
  Widget _buildBackground() {
    return Positioned(
      top: 0,
      left: 10.w,
      right: 10.w,
      child: Image.network(
        'https://yakaixin.oss-cn-beijing.aliyuncs.com/public/rank-bg.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }

  /// 柱状图内容
  Widget _buildBars() {
    final firstRank = _getRankData(0);
    final secondRank = _getRankData(1);
    final thirdRank = _getRankData(2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 第2名柱子 - 对应小程序 Line 19-28
        Expanded(
          child: _buildBar(
            rank: secondRank,
            barHeight: 95.w, // 对应小程序 25.3vw
            avatarTop: 65.w, // 对应小程序 17.41vw
            borderColor: const Color(0xFFB6D0EA), // 银色边框
            avatarSize: 48.w,
          ),
        ),
        
        // 第1名柱子 - 对应小程序 Line 29-39
        Expanded(
          child: _buildBar(
            rank: firstRank,
            barHeight: 130.w, // 对应小程序 34.5vw
            avatarTop: 21.w, // 对应小程序 5.51vw
            borderColor: const Color(0xFFF0BF2B), // 金色边框
            avatarSize: 58.w,
            isFirst: true,
          ),
        ),
        
        // 第3名柱子 - 对应小程序 Line 40-51
        Expanded(
          child: _buildBar(
            rank: thirdRank,
            barHeight: 96.w, // 对应小程序 25.6vw
            avatarTop: 65.w, // 对应小程序 17.41vw
            borderColor: const Color(0xFFE7B582), // 铜色边框
            avatarSize: 48.w,
          ),
        ),
      ],
    );
  }

  /// 单个柱子
  Widget _buildBar({
    required Map<String, dynamic> rank,
    required double barHeight,
    required double avatarTop,
    required Color borderColor,
    required double avatarSize,
    bool isFirst = false,
  }) {
    return SizedBox(
      height: 215.w,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 柱子内容区域 - 在底部
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: barHeight,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: isFirst ? 15.w : 15.w),
                  
                  // 姓名 - 对应小程序 Line 21, 31, 44
                  Text(
                    rank['name'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: isFirst ? 4.w : 5.w),
                  
                  // 分数 - 对应小程序 Line 22-25, 32-35, 45-48
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: rank['score']?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222333),
                          ),
                        ),
                        TextSpan(
                          text: '分',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isFirst ? 11.w : 6.w),
                  
                  // 时间 - 对应小程序 Line 26, 36, 49
                  Text(
                    rank['time'] ?? '',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 头像 - 在顶部绝对定位
          Positioned(
            top: avatarTop,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1),
                color: Colors.white,
              ),
              child: ClipOval(
                child: _buildAvatarImage(
                  rank['avatar']?.toString() ?? '',
                  avatarSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 排行榜按钮 - 对应小程序 Line 356-372
  Widget _buildRankButton() {
    return Positioned(
      top: 5.h,
      right: 0,
      child: GestureDetector(
        onTap: onRankButtonTap,
        child: Container(
          width: 60.w,
          height: 21.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            '排行榜',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// 头像图片（支持本地 asset 与网络 URL）
  Widget _buildAvatarImage(String avatarPath, double size) {
    if (avatarPath.startsWith('assets/')) {
      return Image.asset(
        avatarPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.person, size: size * 0.5, color: Colors.grey),
      );
    }
    return Image.network(
      avatarPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.person, size: size * 0.5, color: Colors.grey),
    );
  }

  /// 获取排名数据
  Map<String, dynamic> _getRankData(int index) {
    if (rankData.length > index) {
      final data = rankData[index];
      final avatar = data['avatar']?.toString() ?? '';
      final fullAvatar = avatar.isNotEmpty
          ? ApiConfig.completeImageUrl(avatar)
          : 'assets/images/app_icon.png';

      final name = data['nickname']?.toString() ?? data['name']?.toString() ?? '';
      final score = data['score']?.toString() ?? '';
      final time = _formatSeconds(data['kaoshi_time']);

      return {
        'avatar': fullAvatar,
        'name': name,
        'score': score,
        'time': time,
      };
    }

    return {
      'avatar': 'assets/images/app_icon.png',
      'name': '',
      'score': '',
      'time': '',
    };
  }

  /// 格式化秒数为时间字符串
  String _formatSeconds(dynamic seconds) {
    if (seconds == null) return '';
    
    final totalSeconds = int.tryParse(seconds.toString()) ?? 0;
    if (totalSeconds == 0) return '';
    
    final minutes = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    
    if (minutes > 0) {
      return '$minutes分$secs秒';
    }
    return '$secs秒';
  }
}
