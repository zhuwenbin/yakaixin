import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 调试框架全局开关配置
/// 
/// 功能:
/// 1. 控制网络调试悬浮窗显示/隐藏
/// 2. 控制其他调试工具显示/隐藏
/// 3. 方便截图时隐藏所有调试信息
class DebugConfig {
  DebugConfig._();
  
  /// 是否启用调试工具（全局开关）
  /// true: 显示所有调试工具
  /// false: 隐藏所有调试工具（用于截图）
  static bool _debugToolsEnabled = true;
  
  /// 获取调试工具开关状态
  static bool get isDebugToolsEnabled => _debugToolsEnabled;
  
  /// 设置调试工具开关状态
  static void setDebugToolsEnabled(bool enabled) {
    _debugToolsEnabled = enabled;
  }
}

/// 调试工具开关状态 Provider
/// 
/// 用于在UI中响应式更新调试工具的显示状态
final debugToolsEnabledProvider = StateProvider<bool>((ref) => true);
