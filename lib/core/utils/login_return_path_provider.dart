import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 登录返回路径 Provider
/// 用于在路由拦截器中获取登录后的返回路径
/// 因为路由拦截器触发时，state.extra 可能已经丢失
final loginReturnPathProvider = StateProvider<String?>((ref) => null);

/// 设置登录返回路径
void setLoginReturnPath(WidgetRef ref, String? returnPath) {
  ref.read(loginReturnPathProvider.notifier).state = returnPath;
}

/// 获取并清除登录返回路径
String? getAndClearLoginReturnPath(WidgetRef ref) {
  final returnPath = ref.read(loginReturnPathProvider);
  ref.read(loginReturnPathProvider.notifier).state = null;
  return returnPath;
}
