// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveManagerHash() => r'c6ac7092c7617ba15e9ac8eec1eefac26eb0ae30';

/// 直播管理器 - 管理百家云直播的核心逻辑
///
/// 职责：
/// 1. 初始化百家云SDK
/// 2. 获取直播信息
/// 3. 进入直播间
/// 4. 记录学习数据
///
/// Copied from [LiveManager].
@ProviderFor(LiveManager)
final liveManagerProvider =
    AutoDisposeNotifierProvider<LiveManager, AsyncValue<String?>>.internal(
  LiveManager.new,
  name: r'liveManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$liveManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveManager = AutoDisposeNotifier<AsyncValue<String?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
