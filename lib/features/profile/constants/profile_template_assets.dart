/// 非默认模版「我的」页面使用的本地切图路径
///
/// 资源位置: assets/images/Template/mine/
/// 蓝湖导出已规范化命名
class ProfileTemplateAssets {
  ProfileTemplateAssets._();

  static const String _base = 'assets/images/Template/mine';

  /// 顶部背景图（与默认模版 my-background-img 等同，铺满顶部区域）
  static const String profileTopBg = '$_base/profile_top_bg.png';

  /// 顶部右上角装饰图（浅青绿渐变，抽象图形）
  static const String profileDecoration = '$_base/profile_decoration.png';

  /// 菜单图标 - 设计图切图（保持原绿色）
  static const String menuMyCourse = '$_base/icon_my_course.png';

  static const String menuMyReport = '$_base/icon_my_report.png';

  static const String menuCorrection = '$_base/icon_correction.png';

  static const String menuFavorites = '$_base/icon_favorites.png';

  static const String menuOrders = '$_base/icon_orders.png';

  static const String menuPractice = '$_base/icon_practice.png';

  static const String menuSettings = '$_base/icon_settings.png';

  /// 设置页 - 右箭头
  static const String iconChevronRight = '$_base/icon_chevron_right.svg';

  /// 设置页 - 清理（调试工具）
  static const String iconCleaning = '$_base/icon_cleaning.svg';
}
