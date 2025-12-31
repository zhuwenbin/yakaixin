import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 倒计时组件
/// 对应小程序: count-down.vue
class CountdownTimer extends StatefulWidget {
  /// 倒计时时长(秒)
  final int durationSeconds;
  
  /// 倒计时结束回调
  final VoidCallback? onFinish;

  const CountdownTimer({
    required this.durationSeconds,
    this.onFinish,
    super.key,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    // print('✅ CountdownTimer initState: 倒计时启动 - $_remainingSeconds 秒');
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // print('🗑️ CountdownTimer dispose: Timer 已销毁 - 剩余 $_remainingSeconds 秒');
    super.dispose();
  }

  /// 启动倒计时
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        // 每隔5秒打印一次日志(避免过多日志) - 已禁用
        // if (_remainingSeconds % 5 == 0) {
        //   print('⏱️ 倒计时更新: 剩余 $_remainingSeconds 秒');
        // }
      } else {
        timer.cancel();
        // print('⏰ 倒计时结束!');
        widget.onFinish?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 对应小程序 count-down.vue 的显示格式
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ 小时
        Container(
          width: 17.w, // ✅ 小程序34rpx ÷ 2 = 17.w
          height: 17.h, // ✅ 小程序34rpx ÷ 2 = 17.h
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF018BFF), // ✅ 小程序background: #018BFF
            borderRadius: BorderRadius.circular(4.r), // ✅ 小程序border-radius: 8rpx ÷ 2 = 4.r
          ),
          child: Text(
            hours > 9 ? hours.toString() : '0$hours',
            style: TextStyle(
              fontSize: 12.sp, // ✅ 小程序24rpx ÷ 2 = 12.sp
              fontWeight: FontWeight.w400, // ✅ 小程序font-weight: 400
              color: Colors.white, // ✅ 小程序color: #ffffff
            ),
          ),
        ),
        // ✅ 分隔符
        Container(
          width: 10.w, // ✅ 小程序20rpx ÷ 2 = 10.w
          alignment: Alignment.center,
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF5B606D), // ✅ 小程序color: #5b606d
            ),
          ),
        ),
        // ✅ 分钟
        Container(
          width: 17.w,
          height: 17.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF018BFF),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            minutes > 9 ? minutes.toString() : '0$minutes',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        // ✅ 分隔符
        Container(
          width: 10.w,
          alignment: Alignment.center,
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF5B606D),
            ),
          ),
        ),
        // ✅ 秒
        Container(
          width: 17.w,
          height: 17.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF018BFF),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            seconds > 9 ? seconds.toString() : '0$seconds',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
