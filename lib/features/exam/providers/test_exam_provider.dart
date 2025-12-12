import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yakaixin_app/core/network/dio_client.dart';
import 'package:yakaixin_app/core/utils/safe_type_converter.dart';
import 'package:yakaixin_app/features/exam/models/paper_model.dart';
import 'package:yakaixin_app/features/exam/services/exam_service.dart';
import 'package:yakaixin_app/features/home/models/goods_model.dart';

part 'test_exam_provider.freezed.dart';
part 'test_exam_provider.g.dart';

/// 试卷详情页状态
@freezed
class TestExamState with _$TestExamState {
  const factory TestExamState({
    @Default(false) bool isLoading,
    String? error,
    GoodsModel? goodsInfo,
    @Default([]) List<PaperModel> paperList, // 普通试卷列表 (data_type == '1')
    @Default([])
    List<ChapterPaperModel> chapterPaperList, // 章节试卷列表 (data_type == '3')
  }) = _TestExamState;
}

/// 试卷详情页 Provider
@riverpod
class TestExamNotifier extends _$TestExamNotifier {
  late final ExamService _examService;

  @override
  TestExamState build() {
    _examService = ExamService(ref.read(dioClientProvider));
    return const TestExamState();
  }

  /// 加载商品详情和试卷列表
  /// 对应小程序: onShow -> getGoodsDetail Line 104-106, 162-207
  Future<void> loadExamData({required String goodsId}) async {
    print('\n📥 [TestExamProvider] loadExamData 开始');
    print('  - goodsId: $goodsId');

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. 获取商品详情
      print('\n🔄 正在获取商品详情...');
      final goodsInfo = await _examService.getGoodsDetail(goodsId: goodsId);
      print('✅ 商品详情获取成功:');
      print('  - name: ${goodsInfo.name}');
      print('  - type: ${goodsInfo.type}');
      print('  - data_type: ${goodsInfo.dataType}');
      print('  - permission_status: ${goodsInfo.permissionStatus}');

      state = state.copyWith(goodsInfo: goodsInfo);

      // 2. 检查权限状态
      final permissionStatus = goodsInfo.permissionStatus;
      if (permissionStatus != '1') {
        print('⚠️ 未购买商品，不加载试卷列表');
        state = state.copyWith(isLoading: false);
        return;
      }

      // 3. 获取 order_id
      final orderId = _getOrderId(goodsInfo);
      print('  - orderId: $orderId');

      // 4. 根据 data_type 加载对应的试卷列表
      final dataType = SafeTypeConverter.toSafeString(goodsInfo.dataType);
      print('\n📋 data_type = $dataType');

      if (dataType == '3') {
        // 章节试卷 (对应小程序 Line 146-152)
        print('  → 加载章节试卷列表...');
        await _loadChapterPaperList(goodsId: goodsId, orderId: orderId);
        print('  ✅ 章节试卷加载完成，数量: ${state.chapterPaperList.length}');
      } else if (dataType == '1') {
        // 普通试卷 (对应小程序 Line 154-160)
        print('  → 加载普通试卷列表...');
        await _loadPaperList(goodsId: goodsId, orderId: orderId);
        print('  ✅ 普通试卷加载完成，数量: ${state.paperList.length}');
      } else {
        print('  ⚠️ data_type 不是 1 或 3，跳过试卷加载');
      }

      state = state.copyWith(isLoading: false);
      print('\n✅ [TestExamProvider] loadExamData 完成\n');
    } catch (e) {
      print('\n❌ [TestExamProvider] loadExamData 失败: $e\n');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 获取订单ID
  /// 对应小程序 Line 195-197
  String _getOrderId(GoodsModel goodsInfo) {
    // ✅ permission_operation_type == '2' 时使用默认订单ID '1' (对应小程序 Line 195-197)
    final operationType = SafeTypeConverter.toSafeString(
      goodsInfo.permissionOperationType,
    );
    if (operationType == '2') {
      return '1';
    }

    // ✅ 否则使用 permission_order_id
    return SafeTypeConverter.toSafeString(
      goodsInfo.permissionOrderId,
      defaultValue: '1',
    );
  }

  /// 加载普通试卷列表
  Future<void> _loadPaperList({
    required String goodsId,
    required String orderId,
  }) async {
    final paperList = await _examService.getPaperList(
      goodsId: goodsId,
      orderId: orderId,
    );
    state = state.copyWith(paperList: paperList);
  }

  /// 加载章节试卷列表
  Future<void> _loadChapterPaperList({
    required String goodsId,
    required String orderId,
  }) async {
    final chapterPaperList = await _examService.getChapterPaperList(
      goodsId: goodsId,
      orderId: orderId,
    );
    state = state.copyWith(chapterPaperList: chapterPaperList);
  }
}
