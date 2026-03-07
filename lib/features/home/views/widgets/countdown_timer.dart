import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 倒计时组件
/// 对应小程序: count-down.vue
/// [boxBackgroundColor] 为 null 时使用默认蓝色；传入样式模板主色时与当前模板一致
class CountdownTimer extends StatefulWidget {
  /// 倒计时时长(秒)
  final int durationSeconds;
  /// 数字块背景色（与样式模板主色一致，如不传则使用默认蓝）
  final Color? boxBackgroundColor;
  /// 倒计时结束回调
  final VoidCallback? onFinish;

  const CountdownTimer({
    required this.durationSeconds,
    this.boxBackgroundColor,
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
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    final boxColor = widget.boxBackgroundColor ?? const Color(0xFF018BFF);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeBox(hours.toString().padLeft(2, '0'), boxColor),
        _buildSeparator(),
        _buildTimeBox(minutes.toString().padLeft(2, '0'), boxColor),
        _buildSeparator(),
        _buildTimeBox(seconds.toString().padLeft(2, '0'), boxColor),
      ],
    );
  }

  Widget _buildTimeBox(String value, Color boxColor) {
    return Container(
      width: 17.w,
      height: 17.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: 10.w,
      alignment: Alignment.center,
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF5B606D),
        ),
      ),
    );
  }
}
