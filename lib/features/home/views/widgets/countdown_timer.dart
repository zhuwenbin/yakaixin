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

  /// 格式化时间: HH:mm:ss
  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(secs)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_remainingSeconds),
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF082980),
        letterSpacing: 2.w,
      ),
    );
  }
}
