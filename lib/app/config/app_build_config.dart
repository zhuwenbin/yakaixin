import '../../core/style/app_style_config.dart';

/// 应用构建配置（开发者配置，非用户选择）
///
/// 正式环境（release）始终使用此处配置的模版，用户无法切换。
/// Debug 模式下可通过网络调试悬浮窗临时切换，便于开发调试。
class AppBuildConfig {
  AppBuildConfig._();

  /// 正式环境默认模版（开发者修改此常量，打正式包后生效）
  static const AppStyleTemplate productionTemplate = AppStyleTemplate.green;

  /// 编译时覆盖：flutter build apk --dart-define=APP_TEMPLATE=green
  /// 若未传则使用 productionTemplate
  static AppStyleTemplate get resolvedProductionTemplate {
    const name = String.fromEnvironment('APP_TEMPLATE');
    if (name.isEmpty) return productionTemplate;
    return AppStyleTemplate.values.firstWhere(
      (e) => e.name == name,
      orElse: () => productionTemplate,
    );
  }

  /// 正式环境是否强制使用开发者配置（忽略本地存储）
  static const bool forceProductionTemplate = true;
}
