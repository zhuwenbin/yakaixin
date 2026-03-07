import 'package:flutter/material.dart';
import 'app_style_config.dart';

/// 颜色调色板
class AppColorPalette {
  final Color primary;
  final Color primaryGradientStart;
  final Color primaryGradientEnd;
  final Color actionPrimary;
  final Color actionGradientStart;
  final Color actionGradientEnd;
  final Color actionShadowColor;
  final Color actionPrimarySoftBg;
  final Color actionPrimarySoftText;
  final Color statsHighlight;
  final Color courseDateSelected;
  final Color tagBg;
  final Color tagText;
  final Color tagBorder;
  final Color progressBar;
  final Color cardLightBg;
  /// 秒杀/限时倒计时数字颜色（主色调）
  final Color countdownTextColor;

  const AppColorPalette({
    required this.primary,
    required this.primaryGradientStart,
    required this.primaryGradientEnd,
    required this.actionPrimary,
    required this.actionGradientStart,
    required this.actionGradientEnd,
    required this.actionShadowColor,
    required this.actionPrimarySoftBg,
    required this.actionPrimarySoftText,
    required this.statsHighlight,
    required this.courseDateSelected,
    required this.tagBg,
    required this.tagText,
    required this.tagBorder,
    required this.progressBar,
    required this.cardLightBg,
    required this.countdownTextColor,
  });
}

/// 排版配置
class AppLayoutConfig {
  final double cardRadius;
  final double cardPadding;
  final double sectionSpacing;

  const AppLayoutConfig({
    required this.cardRadius,
    required this.cardPadding,
    required this.sectionSpacing,
  });
}

/// 图片包配置（题库四入口 + TabBar）
class AppImagePackConfig {
  final List<String> studyCardUrls;
  final bool tabBarUseMaterialIcons;
  final List<String>? tabBarIconPaths;
  /// Tab 顺序：tabBarOrder[tabIndex] = 页面下标（0首页 1题库 2课程 3我的）
  /// null 或 [0,1,2,3] 为默认顺序；非默认如 [1,2,0,3] 表示 题库、课程、首页、我的
  final List<int>? tabBarOrder;
  /// Tab 文案（按 Tab 下标顺序）：如 ['刷题','上课','购课','我的']。null 则用默认 首页/题库/课程/我的
  final List<String>? tabBarLabels;

  const AppImagePackConfig({
    required this.studyCardUrls,
    this.tabBarUseMaterialIcons = true,
    this.tabBarIconPaths,
    this.tabBarOrder,
    this.tabBarLabels,
  });
}

/// 预设数据
class AppStylePresets {
  AppStylePresets._();

  static const String _baseUrl =
      'https://yakaixin.oss-cn-beijing.aliyuncs.com/public';

  // ========== 蓝（默认）==========
  static const AppColorPalette blue = AppColorPalette(
    // ✅ 与当前项目默认使用的 Colors.blue 保持一致（main.dart / MainTabPage）
    primary: Color(0xFF2196F3),
    primaryGradientStart: Color(0xFF2E68FF),
    primaryGradientEnd: Color(0xFF1A4FCC),
    // ✅ 题库首页/商品购买等按钮当前使用的橙色系（先保持现状，后续逐步接入更多场景）
    actionPrimary: Color(0xFFFF5500),
    actionGradientStart: Color(0xFFFF8928),
    actionGradientEnd: Color(0xFFFF5430),
    actionShadowColor: Color(0xFFFF5932),
    actionPrimarySoftBg: Color(0xFFFFEEE7),
    actionPrimarySoftText: Color(0xFFF44900),
    statsHighlight: Color(0xFFFF5500),
    // ✅ 课程日期选中（当前 AppColors.courseDatePrimary）
    courseDateSelected: Color(0xFF018CFF),
    tagBg: Color(0xFFEBF1FF),
    tagText: Color(0xFF2E68FF),
    tagBorder: Color(0xFF4981D7),
    progressBar: Color(0xFF2E68FF),
    cardLightBg: Color(0xFFE0F0FF),
    countdownTextColor: Color(0xFF1F232E),
  );

  static const AppLayoutConfig layoutA = AppLayoutConfig(
    cardRadius: 16,
    cardPadding: 16,
    sectionSpacing: 16,
  );

  static const AppLayoutConfig layoutB = AppLayoutConfig(
    cardRadius: 12,
    cardPadding: 12,
    sectionSpacing: 12,
  );

  static AppImagePackConfig imagePackA(String Function(String) completeUrl) {
    return AppImagePackConfig(
      studyCardUrls: [
        '$_baseUrl/predictIcon.png',
        '$_baseUrl/test-icon.png',
        '$_baseUrl/exam-icon.png',
        completeUrl('col-4.png'),
      ],
      tabBarUseMaterialIcons: true,
    );
  }

  static const String _mainTabBar = 'assets/images/Template/main_tabbar';
  static const String _tiku = 'assets/images/Template/tiku';

  /// 非默认模版：顺序 题库、课程、首页、我的，设计图图标 Template/main_tabbar，四个功能图标 Template/tiku
  static AppImagePackConfig imagePackB() {
    return AppImagePackConfig(
      studyCardUrls: [
        '$_tiku/tiku_func_1.png',
        '$_tiku/tiku_func_2.png',
        '$_tiku/tiku_func_3.png',
        '$_tiku/tiku_func_4.png',
      ],
      tabBarUseMaterialIcons: false,
      tabBarOrder: const [1, 2, 0, 3],
      tabBarLabels: const ['刷题', '上课', '购课', '我的'],
      tabBarIconPaths: [
        '$_mainTabBar/main_tabbar_goods.png',
        '$_mainTabBar/main_tabbar_goods.png',
        '$_mainTabBar/main_tabbar_course.png',
        '$_mainTabBar/main_tabbar_course.png',
        '$_mainTabBar/main_tabbar_home.png',
        '$_mainTabBar/main_tabbar_home.png',
        '$_mainTabBar/main_tabbar_mine.png',
        '$_mainTabBar/main_tabbar_mine.png',
      ],
    );
  }

  // ========== 橙黄色 ==========
  static const AppColorPalette orangeYellow = AppColorPalette(
    primary: Color(0xFFFF8C00),
    primaryGradientStart: Color(0xFFFFA500),
    primaryGradientEnd: Color(0xFFFF8C00),
    actionPrimary: Color(0xFFFF8C00),
    actionGradientStart: Color(0xFFFFA500),
    actionGradientEnd: Color(0xFFFF8C00),
    actionShadowColor: Color(0xFFE69500),
    actionPrimarySoftBg: Color(0xFFFFF4E6),
    actionPrimarySoftText: Color(0xFFE69500),
    statsHighlight: Color(0xFFFF8C00),
    courseDateSelected: Color(0xFFFF8C00),
    tagBg: Color(0xFFFFF4E6),
    tagText: Color(0xFFFF8C00),
    tagBorder: Color(0xFFE69500),
    progressBar: Color(0xFFFF8C00),
    cardLightBg: Color(0xFFFFF8F0),
    countdownTextColor: Color(0xFFFF8C00),
  );

  // ========== 绿色（主色 #00A788）==========
  static const AppColorPalette green = AppColorPalette(
    primary: Color(0xFF00A788),
    primaryGradientStart: Color(0xFF00A788),
    primaryGradientEnd: Color(0xFF008A6E),
    actionPrimary: Color(0xFF00A788),
    actionGradientStart: Color(0xFF00A788),
    actionGradientEnd: Color(0xFF008A6E),
    actionShadowColor: Color(0xFF008A6E),
    actionPrimarySoftBg: Color(0xFFE0F7F4),
    actionPrimarySoftText: Color(0xFF008A6E),
    statsHighlight: Color(0xFF00A788),
    courseDateSelected: Color(0xFF00A788),
    tagBg: Color(0xFFE0F7F4),
    tagText: Color(0xFF00A788),
    tagBorder: Color(0xFF008A6E),
    progressBar: Color(0xFF00A788),
    cardLightBg: Color(0xFFF0FCFA),
    countdownTextColor: Color(0xFF00A788),
  );

  /// 预设模板对应的完整配置（颜色+排版+图片）
  static ({AppColorPalette palette, AppLayoutConfig layout, AppImagePack pack})
      presetForTemplate(AppStyleTemplate t, String Function(String) completeUrl) {
    switch (t) {
      case AppStyleTemplate.blueDefault:
        return (palette: blue, layout: layoutA, pack: AppImagePack.packA);
      case AppStyleTemplate.orangeYellow:
        return (palette: orangeYellow, layout: layoutB, pack: AppImagePack.packB);
      case AppStyleTemplate.green:
        return (palette: green, layout: layoutB, pack: AppImagePack.packB);
      case AppStyleTemplate.custom:
        return (palette: blue, layout: layoutA, pack: AppImagePack.packA);
    }
  }

  static AppColorPalette paletteForTemplate(AppStyleTemplate t) {
    return presetForTemplate(t, (s) => s).palette;
  }

  static AppLayoutConfig layoutForVariant(AppLayoutVariant v) {
    return v == AppLayoutVariant.layoutA ? layoutA : layoutB;
  }
}
