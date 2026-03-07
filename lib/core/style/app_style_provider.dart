import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_service.dart';
import '../../app/constants/storage_keys.dart';
import '../../app/config/api_config.dart';
import 'app_style_config.dart';
import 'app_style_tokens.dart';

/// 样式配置 Provider
final appStyleConfigProvider =
    StateNotifierProvider<AppStyleController, AppStyleConfig>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return AppStyleController(storage);
});

/// 当前生效的样式令牌 Provider
final appStyleTokensProvider = Provider<AppStyleTokens>((ref) {
  final config = ref.watch(appStyleConfigProvider);
  return AppStyleTokens.build(
    config,
    completeImageUrl: ApiConfig.completeImageUrl,
  );
});

class AppStyleController extends StateNotifier<AppStyleConfig> {
  final StorageService _storage;

  AppStyleController(this._storage) : super(_loadConfig(_storage));

  static AppStyleConfig _loadConfig(StorageService s) {
    final json = s.getJson(StorageKeys.appStyleConfig);
    if (json == null) return const AppStyleConfig();
    try {
      return AppStyleConfig.fromJson(json);
    } catch (_) {
      return const AppStyleConfig();
    }
  }

  Future<void> _save(AppStyleConfig config) async {
    state = config;
    await _storage.setJson(StorageKeys.appStyleConfig, config.toJson());
  }

  /// 切换预设模板
  Future<void> setTemplate(AppStyleTemplate template) async {
    await _save(state.copyWith(template: template));
  }

  /// 自定义：设置颜色（ARGB int）
  Future<void> setCustomPrimaryColor(int? colorValue) async {
    await _save(state.copyWith(customPrimaryColorValue: colorValue));
  }

  /// 自定义：设置排版
  Future<void> setCustomLayout(AppLayoutVariant? layout) async {
    await _save(state.copyWith(customLayout: layout));
  }

  /// 自定义：设置图片包
  Future<void> setCustomImagePack(AppImagePack? pack) async {
    await _save(state.copyWith(customImagePack: pack));
  }

  /// 更新完整自定义配置（仅在 template==custom 时生效）
  Future<void> setCustomConfig({
    int? primaryColorValue,
    AppLayoutVariant? layout,
    AppImagePack? imagePack,
  }) async {
    if (state.template != AppStyleTemplate.custom) return;
    await _save(state.copyWith(
      customPrimaryColorValue: primaryColorValue ?? state.customPrimaryColorValue,
      customLayout: layout ?? state.customLayout,
      customImagePack: imagePack ?? state.customImagePack,
    ));
  }
}
