# GoodsDetailPage API分析和实现方案

基于小程序 `mini-dev_250812/src/modules/jintiku/pages/test/detail.vue` 的分析

---

## 📡 API接口分析

### 主接口: getGoodsDetail

**接口定义** (`mini-dev_250812/src/modules/jintiku/api/index.js` Line 890-896):
```javascript
export const getGoodsDetail = (data = {}) => {
  return http({
    url: '/c/goods/v2/detail',
    method: 'GET',
    data
  })
}
```

**调用参数** (`detail.vue` Line 409-411):
```javascript
getGoodsDetail({
  goods_id: this.id  // 商品ID
})
```

**接口地址**: `GET /c/goods/v2/detail?goods_id={id}`

---

### 辅助接口

#### 1. 章节树接口 (仅type==18时调用)

**接口**: `chapterpackageTree` (`detail.vue` Line 389-396)

```javascript
import { chapterpackageTree } from '../../api/chapter'

chapterpackageTree({
  professional_id: this.professional_id,
  goods_id: this.id
})
```

**作用**: 获取章节练习的章节树结构

---

#### 2. 下单接口

**接口**: `getOrderV2` (`detail.vue` Line 509-580)

```javascript
getOrderV2({
  business_scene: 1,
  goods: [{
    goods_id: goods_id,
    goods_months_price_id: ...,
    months: ...,
    goods_num: '1'
  }],
  deposit_amount: ...,
  payable_amount: ...,
  real_amount: ...,
  total_amount: ...,
  student_id: student_id,
  app_id: app_id,
  professional_id: ...,
  // ...
})
```

---

## 📦 返回数据结构分析

### 主要字段 (`detail.vue` Line 408-503)

```javascript
// 核心返回数据
{
  id: '',                          // 商品ID
  name: '',                        // 商品名称
  type: 18,                        // 类型: 18=章节练习, 8=试卷, 10=模考
  material_cover_path: '',         // 封面图片路径
  material_intro_path: '',         // 详情图片路径（HTML长图）
  permission_status: '2',          // 权限状态: 1=已购买, 2=未购买
  professional_id: '',             // 专业ID
  professional_id_name: '',        // 专业名称
  
  // 价格信息（数组）
  prices: [
    {
      goods_months_price_id: '',   // 价格ID
      month: 0,                    // 有效期月份，0=永久
      sale_price: '199.00',        // 销售价
      original_price: '299.00',    // 原价
      days: '365',                 // 天数
    }
  ],
  
  // 题库详情（type==18时有效）
  tiku_goods_details: {
    question_num: 3580,            // 题目数量（type==18）
    paper_num: 10,                 // 试卷数量（type==8）
    exam_round_num: 5,             // 考试轮次（type==10）
    exam_time: '2026-12-31'        // 开考时间（type==10）
  },
  
  // 教学体系
  teaching_system: {
    system_id_name: '国家统考',   // 体系名称
  },
  
  // 计算字段（前端生成）
  num_text: '共3580题',            // 数量文本
  year: '2026年',                  // 年份
  tips: ''                         // 提示信息
}
```

### 数据处理逻辑 (`detail.vue` Line 449-484)

```javascript
// 1. 根据type计算num_text
let num_text = `共${info.tiku_goods_details.question_num}题`  // type==18
if (info.type == 8) {
  num_text = `共${info.tiku_goods_details.paper_num}份`       // type==8
}
if (info.type == 10) {
  num_text = `共${info.tiku_goods_details.exam_round_num}轮`  // type==10
}

// 2. 根据type计算tips (system_id_name)
let system_id_name = info?.teaching_system?.system_id_name || ''
if (info.type == 10) {
  system_id_name = `开考时间:${info.tiku_goods_details.exam_time}`
}

// 3. 价格排序（永久有效期排最后）
this.prices = res.data.prices
  .sort((a, b) => {
    if (a.month == 0) return 1
    else return Number(a.month) - Number(b.month)
  })
  .map(item => {
    let discount_price = Math.floor(
      (Number(item.original_price) - Number(item.sale_price)) * 100
    ) / 100
    return { ...item, discount_price }
  })

// 4. ⚠️ 特殊处理：type!=18时，封面和介绍路径互换
if (res.data.type != 18) {
  let material_intro_path = this.info.material_intro_path
  let material_cover_path = this.info.material_cover_path
  //封面
  this.info.material_cover_path = material_intro_path
  //介绍
  this.info.material_intro_path = material_cover_path
}
```

---

## 🎨 UI布局分析

### 页面结构 (`detail.vue` Line 1-150)

```
1. 顶部商品信息区
   ├─ 封面图片 (material_cover_path)
   ├─ 秒杀倒计时区
   │  ├─ "题库秒杀" + 倒计时
   │  └─ 秒杀价 = 原价 - 限时优惠
   └─ 商品信息区
      ├─ 商品名称 (name) + 分享按钮
      ├─ 标签 (num_text, year)
      ├─ 提示 (tips/system_id_name)
      └─ 有效期选择 (prices列表)

2. 中间内容区（根据type不同显示）
   ├─ type==18: 章节列表
   │  ├─ 标题: "本题库共有 XXX 道题"
   │  └─ treeChapter组件（章节树）
   └─ type==8/10: 商品介绍长图
      └─ <image :src="material_intro_path">

3. 底部操作栏
   ├─ permission_status=='2'（未购买）
   │  ├─ 显示价格
   │  └─ "立即购买"按钮
   └─ permission_status=='1'（已购买）
      ├─ type==18: "立即刷题"
      └─ type==8/10: "立即测试"
```

---

## 🚀 Flutter实现方案

### 1. Model 定义

创建 `yakaixin_app/lib/features/goods/models/goods_detail_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_detail_model.freezed.dart';
part 'goods_detail_model.g.dart';

/// 商品详情Model
@freezed
class GoodsDetailModel with _$GoodsDetailModel {
  const factory GoodsDetailModel({
    @JsonKey(name: 'id') dynamic goodsId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'type') dynamic type,
    @JsonKey(name: 'material_cover_path') String? materialCoverPath,
    @JsonKey(name: 'material_intro_path') String? materialIntroPath,
    @JsonKey(name: 'permission_status') String? permissionStatus,
    @JsonKey(name: 'professional_id') String? professionalId,
    @JsonKey(name: 'professional_id_name') String? professionalIdName,
    @JsonKey(name: 'prices') @Default([]) List<GoodsPriceModel> prices,
    @JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails,
    @JsonKey(name: 'teaching_system') TeachingSystem? teachingSystem,
    @JsonKey(name: 'year') String? year,
  }) = _GoodsDetailModel;

  factory GoodsDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsDetailModelFromJson(json);
}

/// 商品价格Model
@freezed
class GoodsPriceModel with _$GoodsPriceModel {
  const factory GoodsPriceModel({
    @JsonKey(name: 'goods_months_price_id') String? goodsMonthsPriceId,
    @JsonKey(name: 'month') dynamic month,
    @JsonKey(name: 'sale_price') String? salePrice,
    @JsonKey(name: 'original_price') String? originalPrice,
    @JsonKey(name: 'days') String? days,
  }) = _GoodsPriceModel;

  factory GoodsPriceModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsPriceModelFromJson(json);
}

/// 题库商品详情
@freezed
class TikuGoodsDetails with _$TikuGoodsDetails {
  const factory TikuGoodsDetails({
    @JsonKey(name: 'question_num') dynamic questionNum,
    @JsonKey(name: 'paper_num') dynamic paperNum,
    @JsonKey(name: 'exam_round_num') dynamic examRoundNum,
    @JsonKey(name: 'exam_time') String? examTime,
  }) = _TikuGoodsDetails;

  factory TikuGoodsDetails.fromJson(Map<String, dynamic> json) =>
      _$TikuGoodsDetailsFromJson(json);
}

/// 教学体系
@freezed
class TeachingSystem with _$TeachingSystem {
  const factory TeachingSystem({
    @JsonKey(name: 'system_id_name') String? systemIdName,
  }) = _TeachingSystem;

  factory TeachingSystem.fromJson(Map<String, dynamic> json) =>
      _$TeachingSystemFromJson(json);
}
```

### 2. Service 定义

在 `yakaixin_app/lib/features/goods/services/goods_service.dart` 添加方法:

```dart
/// 获取商品详情
/// 对应小程序: /c/goods/v2/detail
Future<GoodsDetailModel> getGoodsDetail({
  required String goodsId,
}) async {
  try {
    final response = await _dioClient.get(
      '/c/goods/v2/detail',
      queryParameters: {
        'goods_id': goodsId,
      },
    );

    // 检查响应码
    if (response.data['code'] != 100000) {
      throw ApiException(response.data['msg']?.first ?? '获取商品详情失败');
    }

    final data = response.data['data'];
    if (data == null) {
      throw DataParseException('商品详情数据为空');
    }

    return GoodsDetailModel.fromJson(data as Map<String, dynamic>);
    
  } on DioException catch (e) {
    throw NetworkException('网络请求失败: ${e.message}');
  } catch (e) {
    throw UnknownException('未知错误: $e');
  }
}
```

### 3. Provider 定义

创建 `yakaixin_app/lib/features/goods/providers/goods_detail_provider.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/goods_detail_model.dart';
import '../services/goods_service.dart';

part 'goods_detail_provider.freezed.dart';
part 'goods_detail_provider.g.dart';

/// 商品详情状态
@freezed
class GoodsDetailState with _$GoodsDetailState {
  const factory GoodsDetailState({
    GoodsDetailModel? goodsDetail,
    @Default(0) int selectedPriceIndex,  // 当前选择的价格索引
    @Default(false) bool isLoading,
    String? error,
  }) = _GoodsDetailState;
}

/// 商品详情Provider
@riverpod
class GoodsDetailNotifier extends _$GoodsDetailNotifier {
  @override
  GoodsDetailState build() => const GoodsDetailState();
  
  /// 加载商品详情
  Future<void> loadGoodsDetail(String goodsId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final service = ref.read(goodsServiceProvider);
      final detail = await service.getGoodsDetail(goodsId: goodsId);
      
      // ✅ 数据处理逻辑（对应小程序 Line 449-503）
      final processedDetail = _processGoodsDetail(detail);
      
      state = state.copyWith(
        goodsDetail: processedDetail,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 处理商品详情数据
  /// 对应小程序的数据处理逻辑
  GoodsDetailModel _processGoodsDetail(GoodsDetailModel detail) {
    // 1. 排序价格（永久有效期排最后）
    final sortedPrices = [...detail.prices]..sort((a, b) {
      final aMonth = SafeTypeConverter.toInt(a.month);
      final bMonth = SafeTypeConverter.toInt(b.month);
      if (aMonth == 0) return 1;
      if (bMonth == 0) return -1;
      return aMonth.compareTo(bMonth);
    });
    
    // 2. ⚠️ type!=18时，封面和介绍路径互换
    String? coverPath = detail.materialCoverPath;
    String? introPath = detail.materialIntroPath;
    
    final typeInt = SafeTypeConverter.toInt(detail.type);
    if (typeInt != 18) {
      coverPath = detail.materialIntroPath;
      introPath = detail.materialCoverPath;
    }
    
    return detail.copyWith(
      prices: sortedPrices,
      materialCoverPath: coverPath,
      materialIntroPath: introPath,
    );
  }
  
  /// 选择价格
  void selectPrice(int index) {
    state = state.copyWith(selectedPriceIndex: index);
  }
}
```

### 4. UI实现

替换现有的 `goods_detail_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/goods_detail_provider.dart';
import '../../../core/utils/safe_type_converter.dart';

/// 商品详情页(经典版)
/// 对应小程序: pages/test/detail
class GoodsDetailPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? goodsId;
  final String? professionalId;
  final String? active;

  const GoodsDetailPage({
    super.key,
    this.productId,
    this.goodsId,
    this.professionalId,
    this.active,
  });

  @override
  ConsumerState<GoodsDetailPage> createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends ConsumerState<GoodsDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final goodsId = widget.goodsId ?? widget.productId;
      if (goodsId != null && goodsId.isNotEmpty) {
        ref.read(goodsDetailNotifierProvider.notifier).loadGoodsDetail(goodsId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goodsDetailNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品详情'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.isLoading
          ? _buildLoading()
          : state.error != null
              ? _buildError(state.error!)
              : state.goodsDetail != null
                  ? _buildContent(state.goodsDetail!)
                  : _buildEmpty(),
      bottomNavigationBar: state.goodsDetail != null
          ? _buildBottomBar(state.goodsDetail!)
          : null,
    );
  }

  // ... 实现各个_build方法
}
```

---

## ✅ 实现步骤

### Step 1: 创建Model ✅
```bash
cd yakaixin_app
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: 更新Service ✅
在`goods_service.dart`添加`getGoodsDetail`方法

### Step 3: 创建Provider ✅
创建`goods_detail_provider.dart`

### Step 4: 实现UI ✅
完整实现`goods_detail_page.dart`

---

## 📝 注意事项

1. **类型安全**: 使用`SafeTypeConverter`处理dynamic字段
2. **路径互换**: type!=18时封面和介绍路径互换
3. **价格排序**: 永久有效期排最后
4. **权限判断**: 根据`permission_status`显示不同按钮
5. **章节列表**: type==18时需要额外调用`chapterpackageTree`接口

---

**下一步**: 开始实现这个页面

