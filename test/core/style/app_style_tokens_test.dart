import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yakaixin_app/core/style/app_style_config.dart';
import 'package:yakaixin_app/core/style/app_style_tokens.dart';

void main() {
  group('AppStyleTokens.build', () {
    test('preset 模板时忽略 custom 配置', () {
      const config = AppStyleConfig(
        template: AppStyleTemplate.blueDefault,
        customLayout: AppLayoutVariant.layoutB,
        customImagePack: AppImagePack.packB,
        customPrimaryColorValue: 0xFF00FF00,
      );

      final tokens = AppStyleTokens.build(
        config,
        completeImageUrl: (s) => s,
      );

      expect(tokens.config.template, AppStyleTemplate.blueDefault);
      expect(tokens.colors.primary, const Color(0xFF2196F3));
      expect(tokens.layout.cardRadius, 16);
      expect(tokens.images.tabBarUseMaterialIcons, true);
    });

    test('custom 模板时使用自定义 primary，并派生 actionPrimary', () {
      const config = AppStyleConfig(
        template: AppStyleTemplate.custom,
        customPrimaryColorValue: 0xFF123456,
      );

      final tokens = AppStyleTokens.build(
        config,
        completeImageUrl: (s) => s,
      );

      expect(tokens.config.template, AppStyleTemplate.custom);
      expect(tokens.colors.primary, const Color(0xFF123456));
      expect(tokens.colors.actionPrimary, const Color(0xFF123456));
    });

    test('orangeYellow 模板默认使用 packB（TabBar 走资源图标）', () {
      const config = AppStyleConfig(template: AppStyleTemplate.orangeYellow);

      final tokens = AppStyleTokens.build(
        config,
        completeImageUrl: (s) => s,
      );

      expect(tokens.config.template, AppStyleTemplate.orangeYellow);
      expect(tokens.images.tabBarUseMaterialIcons, false);
      expect(tokens.images.tabBarIconPaths, isNotNull);
      expect(tokens.images.tabBarIconPaths!.length, 8);
    });
  });
}

