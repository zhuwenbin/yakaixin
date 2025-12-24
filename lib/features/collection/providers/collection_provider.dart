import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yakaixin_app/core/network/dio_client.dart';
import 'package:yakaixin_app/core/utils/error_message_mapper.dart';
import '../models/collection_question_model.dart';
import '../services/collection_service.dart';

part 'collection_provider.freezed.dart';
part 'collection_provider.g.dart';

/// CollectionService Provider
final collectionServiceProvider = Provider<CollectionService>((ref) {
  return CollectionService(ref.read(dioClientProvider));
});

/// 收藏列表状态
/// 对应小程序: collect/index.vue Line 93-134
@freezed
class CollectionState with _$CollectionState {
  const factory CollectionState({
    // 分组后的收藏列表 (按题型分组)
    @Default({}) Map<String, CollectionGroupModel> groupedQuestions,
    
    // 全部收藏题目列表
    @Default([]) List<CollectionQuestionModel> allQuestions,
    
    // 加载状态
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    
    // 错误信息
    String? error,
    
    // 分页信息
    @Default(1) int currentPage,
    @Default(0) int total,
    
    // 筛选条件
    @Default('0') String timeRange, // '0'-全部, '1'-近3天, '2'-一周内, '3'-一月内, '4'-自定义
    String? questionType, // 题型
    String? startDate, // 开始日期
    String? endDate, // 结束日期
    
    // UI辅助字段
    String? timeRangeName, // 时间范围名称
    String? questionTypeName, // 题型名称
  }) = _CollectionState;
}

/// 收藏列表Provider
/// 对应小程序: collect/index.vue
@riverpod
class CollectionNotifier extends _$CollectionNotifier {
  @override
  CollectionState build() => const CollectionState();

  /// 加载收藏列表
  /// 对应小程序: getList() Line 145-188
  Future<void> loadCollections({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        groupedQuestions: {},
        allQuestions: [],
      );
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final service = ref.read(collectionServiceProvider);
      final response = await service.getCollectionList(
        page: state.currentPage,
        size: 10,
        timeRange: state.timeRange,
        questionType: state.questionType,
        startDate: state.startDate,
        endDate: state.endDate,
      );

      if (response.list.isEmpty && state.currentPage == 1) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          hasMore: false,
          allQuestions: [],
          groupedQuestions: {},
        );
        return;
      }

      // 处理题目列表，添加 titleInfo
      final processedList = response.list.map((item) {
        return _processQuestionTitleInfo(item);
      }).toList();

      // 合并新旧数据
      final updatedList = refresh 
          ? processedList 
          : [...state.allQuestions, ...processedList];

      // 按题型分组
      final grouped = _groupQuestionsByType(updatedList);

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        groupedQuestions: grouped,
        allQuestions: updatedList,
        total: response.total,
        hasMore: updatedList.length < response.total,
      );
    } on DioException catch (e) {
      // ✅ 使用拦截器已处理好的用户友好错误信息
      final errorMsg = e.error?.toString() ?? '加载失败，请稍后重试';
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: errorMsg,
      );
    } catch (e) {
      // ✅ 兜底：未预期的错误
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: '加载失败，请稍后重试',
      );
    }
  }

  /// 加载更多
  /// 对应小程序: onReachBottom() Line 204-211
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadCollections(refresh: false);
  }

  /// 更新筛选条件并刷新
  /// 对应小程序: success() Line 141-144
  Future<void> updateFilter({
    String? timeRange,
    String? questionType,
    String? startDate,
    String? endDate,
    String? timeRangeName,
    String? questionTypeName,
  }) async {
    state = state.copyWith(
      timeRange: timeRange ?? state.timeRange,
      questionType: questionType,
      startDate: startDate,
      endDate: endDate,
      timeRangeName: timeRangeName ?? state.timeRangeName,
      questionTypeName: questionTypeName,
      currentPage: 1,
    );
    
    await loadCollections(refresh: true);
  }

  /// 重置筛选条件
  Future<void> resetFilter() async {
    state = state.copyWith(
      timeRange: '0',
      questionType: null,
      startDate: null,
      endDate: null,
      timeRangeName: '时间',
      questionTypeName: null,
      currentPage: 1,
    );
    
    await loadCollections(refresh: true);
  }

  /// 处理题目标题信息
  /// 对应小程序: Line 160-171
  CollectionQuestionModel _processQuestionTitleInfo(CollectionQuestionModel item) {
    List<String> titleInfo = [];

    if (item.thematicStem != null && item.thematicStem!.isNotEmpty) {
      // 病例题型，直接使用病例题干
      titleInfo.add(item.thematicStem!);
    } else if (_isB1Type(item.type)) {
      // B1题型，解析选项
      if (item.stemList.isNotEmpty && item.stemList[0].option != null) {
        try {
          final options = jsonDecode(item.stemList[0].option!) as List;
          titleInfo = options.map((e) => e.toString()).toList();
        } catch (e) {
          print('解析选项失败: $e');
        }
      }
    } else {
      // 其他题型，使用题干内容
      if (item.stemList.isNotEmpty && item.stemList[0].content != null) {
        titleInfo.add(item.stemList[0].content!);
      }
    }

    return item.copyWith(titleInfo: titleInfo, isCollect: '1');
  }

  /// 判断是否为B1题型
  /// 对应小程序: utils/index.js isB1()
  bool _isB1Type(String type) {
    return type == '5'; // B1题型的type是'5'
  }

  /// 按题型分组
  /// 对应小程序: Line 173-183
  Map<String, CollectionGroupModel> _groupQuestionsByType(
    List<CollectionQuestionModel> questions,
  ) {
    final Map<String, CollectionGroupModel> grouped = {};

    // 先排序
    final sortedQuestions = [...questions]
      ..sort((a, b) => int.parse(a.type).compareTo(int.parse(b.type)));

    for (final question in sortedQuestions) {
      final typeName = question.typeName ?? '未知题型';
      if (!grouped.containsKey(question.type)) {
        grouped[question.type] = CollectionGroupModel(
          typeName: typeName,
          questions: [],
        );
      }
      grouped[question.type] = grouped[question.type]!.copyWith(
        questions: [...grouped[question.type]!.questions, question],
      );
    }

    return grouped;
  }

  /// 收藏/取消收藏题目
  /// 对应小程序: api/commen.js Line 22-28
  Future<void> toggleCollect({
    required String questionVersionId,
    required String status,
  }) async {
    try {
      final service = ref.read(collectionServiceProvider);
      await service.toggleCollect(
        questionVersionId: questionVersionId,
        status: status,
      );
      
      // ✅ 收藏成功后，刷新收藏列表
      await loadCollections(refresh: true);
    } catch (e) {
      print('❌ [CollectionNotifier] 收藏操作失败: $e');
      rethrow;
    }
  }

  /// 提交题目纠错
  /// 对应小程序: error-correction.vue Line 123-135
  Future<void> submitErrorCorrection({
    required String questionVersionId,
    required String errorContent,
    required String errorType,
    required List<String> filePath,
  }) async {
    try {
      final service = ref.read(collectionServiceProvider);
      await service.submitCorrection(
        questionVersionId: questionVersionId,
        description: errorContent,
        errType: errorType,
        filePath: filePath,
      );
      
      print('✅ [CollectionNotifier] 纠错提交成功');
    } catch (e) {
      print('❌ [CollectionNotifier] 纠错提交失败: $e');
      rethrow;
    }
  }
}
