/// 预设模板
enum AppStyleTemplate {
  /// 蓝 - 默认（当前金医圣样式）
  blueDefault,
  /// 橙黄色
  orangeYellow,
  /// 绿色
  green,
  /// 自定义（自由搭配颜色/排版/图片）
  custom,
}

/// 排版变体
enum AppLayoutVariant {
  /// 排版A - 当前默认
  layoutA,
  /// 排版B - 备选
  layoutB,
}

/// 图片包
enum AppImagePack {
  /// 图片包A - 当前默认
  packA,
  /// 图片包B - 备选
  packB,
}

/// 应用样式配置
///
/// 持久化存储，选择 preset 时 custom* 不生效
class AppStyleConfig {
  final AppStyleTemplate template;
  final AppLayoutVariant? customLayout;
  final AppImagePack? customImagePack;
  final int? customPrimaryColorValue;

  const AppStyleConfig({
    this.template = AppStyleTemplate.blueDefault,
    this.customLayout,
    this.customImagePack,
    this.customPrimaryColorValue,
  });

  AppStyleConfig copyWith({
    AppStyleTemplate? template,
    AppLayoutVariant? customLayout,
    AppImagePack? customImagePack,
    int? customPrimaryColorValue,
  }) {
    return AppStyleConfig(
      template: template ?? this.template,
      customLayout: customLayout ?? this.customLayout,
      customImagePack: customImagePack ?? this.customImagePack,
      customPrimaryColorValue: customPrimaryColorValue ?? this.customPrimaryColorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'template': template.name,
      'customLayout': customLayout?.name,
      'customImagePack': customImagePack?.name,
      'customPrimaryColorValue': customPrimaryColorValue,
    };
  }

  static AppStyleConfig fromJson(Map<String, dynamic> json) {
    return AppStyleConfig(
      template: _parseTemplate(json['template']),
      customLayout: _parseLayout(json['customLayout']),
      customImagePack: _parseImagePack(json['customImagePack']),
      customPrimaryColorValue: json['customPrimaryColorValue'] as int?,
    );
  }

  static AppStyleTemplate _parseTemplate(dynamic v) {
    if (v == null) return AppStyleTemplate.blueDefault;
    final s = v.toString();
    return AppStyleTemplate.values.firstWhere(
      (e) => e.name == s,
      orElse: () => AppStyleTemplate.blueDefault,
    );
  }

  static AppLayoutVariant? _parseLayout(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    try {
      return AppLayoutVariant.values.firstWhere((e) => e.name == s);
    } catch (_) {
      return null;
    }
  }

  static AppImagePack? _parseImagePack(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    try {
      return AppImagePack.values.firstWhere((e) => e.name == s);
    } catch (_) {
      return null;
    }
  }
}
