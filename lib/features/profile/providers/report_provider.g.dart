// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportServiceHash() => r'b536d8976bf0873b5549c92c93d287f77e3b40d6';

/// ReportService Provider
///
/// Copied from [reportService].
@ProviderFor(reportService)
final reportServiceProvider = AutoDisposeProvider<ReportService>.internal(
  reportService,
  name: r'reportServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReportServiceRef = AutoDisposeProviderRef<ReportService>;
String _$learningDataHash() => r'f9d1fd63bc627996c6061ce144be982b4e2be500';

/// 学习数据Provider
/// 对应小程序: report.vue 学习数据Tab
///
/// Copied from [LearningData].
@ProviderFor(LearningData)
final learningDataProvider =
    AutoDisposeNotifierProvider<LearningData, LearningDataState>.internal(
  LearningData.new,
  name: r'learningDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$learningDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LearningData = AutoDisposeNotifier<LearningDataState>;
String _$scoreReportNotifierHash() =>
    r'a74dad8205744807d7bea8e9c3b9cb806360f732';

/// 成绩报告Provider
/// 对应小程序: report.vue 成绩报告Tab
///
/// Copied from [ScoreReportNotifier].
@ProviderFor(ScoreReportNotifier)
final scoreReportNotifierProvider =
    AutoDisposeNotifierProvider<ScoreReportNotifier, ScoreReportState>.internal(
  ScoreReportNotifier.new,
  name: r'scoreReportNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scoreReportNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScoreReportNotifier = AutoDisposeNotifier<ScoreReportState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
