import 'package:flutter/material.dart';
import 'app_style_config.dart';
import 'app_style_presets.dart';

/// 当前生效的样式令牌
///
/// 选择预设模板时，自定义配置不生效
class AppStyleTokens {
  final AppColorPalette colors;
  final AppLayoutConfig layout;
  final AppImagePackConfig images;
  final AppStyleConfig config;

  const AppStyleTokens({
    required this.colors,
    required this.layout,
    required this.images,
    required this.config,
  });

  static AppStyleTokens build(
    AppStyleConfig config, {
    required String Function(String) completeImageUrl,
  }) {
    final isCustom = config.template == AppStyleTemplate.custom;

    AppColorPalette palette;
    AppLayoutConfig layout;
    AppImagePack imagePack;

    if (isCustom) {
      palette = config.customPrimaryColorValue != null
          ? _paletteFromPrimary(Color(config.customPrimaryColorValue!))
          : AppStylePresets.blue;
      layout = AppStylePresets.layoutForVariant(
        config.customLayout ?? AppLayoutVariant.layoutA,
      );
      imagePack = config.customImagePack ?? AppImagePack.packA;
    } else {
      final preset =
          AppStylePresets.presetForTemplate(config.template, completeImageUrl);
      palette = preset.palette;
      layout = preset.layout;
      imagePack = preset.pack;
    }

    final images = imagePack == AppImagePack.packA
        ? AppStylePresets.imagePackA(completeImageUrl)
        : AppStylePresets.imagePackB();

    return AppStyleTokens(
      colors: palette,
      layout: layout,
      images: images,
      config: config,
    );
  }

  static AppColorPalette _paletteFromPrimary(Color primary) {
    final hsl = HSLColor.fromColor(primary);
    final start =
        hsl.withLightness((hsl.lightness + 0.05).clamp(0, 1)).toColor();
    final end =
        hsl.withLightness((hsl.lightness - 0.1).clamp(0, 1)).toColor();
    final tagBg = hsl.withLightness(0.96).withSaturation(0.3).toColor();
    final tagText = primary;
    final tagBorder =
        hsl.withLightness((hsl.lightness - 0.1).clamp(0, 1)).toColor();
    final softBg =
        hsl.withLightness((hsl.lightness + 0.55).clamp(0, 1)).toColor();
    final softText =
        hsl.withLightness((hsl.lightness - 0.05).clamp(0, 1)).toColor();
    final actionGradientStart =
        hsl.withLightness((hsl.lightness + 0.12).clamp(0, 1)).toColor();
    final actionGradientEnd = primary;
    return AppColorPalette(
      primary: primary,
      primaryGradientStart: start,
      primaryGradientEnd: end,
      actionPrimary: primary,
      actionGradientStart: actionGradientStart,
      actionGradientEnd: actionGradientEnd,
      actionShadowColor: primary,
      actionPrimarySoftBg: softBg,
      actionPrimarySoftText: softText,
      statsHighlight: primary,
      courseDateSelected: primary,
      tagBg: tagBg,
      tagText: tagText,
      tagBorder: tagBorder,
      progressBar: primary,
      cardLightBg: tagBg,
      countdownTextColor: primary,
    );
  }
}
