# 详情页实现总结

## 📋 概述

本文档总结了从首页跳转的4个详情页面的实现情况，包括页面功能、对应小程序、API接口和Mock数据。

---

## ✅ 已完成页面

### 1. GoodsDetailPage（经典商品详情页）

**功能描述**：
- 显示商品基本信息（名称、副标题、封面图）
- 秒杀倒计时（如果有）
- 价格列表（支持多个有效期选择）
- 章节信息（type=18题库类型）
- 商品介绍（HTML渲染）
- 底部购买栏

**对应小程序**：`modules/jintiku/pages/test/detail.vue`

**API接口**：
- `GET /c/goods/v2/detail?goods_id=xxx`
- `POST /c/goods/v2/order` (购买接口，暂未实现)

**核心逻辑**：
- 价格排序：永久有效期排最后
- 免费商品处理：`is_free=1`
- 路径交换：type!=18时，交换`material_cover_path`和`material_intro_path`
- 章节树：type=18时显示章节练习入口

**文件位置**：
- View: `lib/features/goods/views/goods_detail_page.dart`
- Provider: `lib/features/goods/providers/goods_detail_provider.dart`
- Model: `lib/features/goods/models/goods_detail_model.dart`
- Service: `lib/features/goods/services/goods_service.dart`

**Mock数据**：
- 文件：`assets/mock/goods_detail_data.json`
- ID：`593505082385898224`（未购买）

**跳转条件**（来自HomePage）：
```dart
// 题库商品 + 未购买 + details_type=1
if (permissionStatus == '2' && type == '18' && detailsType == '1') {
  context.push('/goods-detail', extra: {'productId': goodsId});
}
```

---

### 2. SecretRealDetailPage（绝密真题详情页）

**功能描述**：
- 渐变背景 + 白色卡片布局
- 显示考试标题（`exam_title`）
- "绝密真题"标签
- 题目内容标题
- 统计信息列表：
  - 题目总数
  - 练习次数
  - 正确率
  - 错题链接
  - 有效期
- 底部按钮：已购买显示"开始冲刺做题"，未购买显示"立即购买"

**对应小程序**：`modules/jintiku/pages/test/secretRealDetail.vue`

**API接口**：
- `GET /c/goods/v2/detail?goods_id=xxx`

**核心字段**：
```dart
examTitle: String?           // 考试标题
paperStatistics: {           // 试卷统计
  doCount: dynamic,          // 练习次数
  totalAccuracyRate: dynamic // 正确率
}
tikuGoodsDetails: {
  questionNum: dynamic,      // 题目总数
  examTime: String?          // 有效期
}
```

**文件位置**：
- View: `lib/features/goods/views/secret_real_detail_page.dart`
- Provider: `lib/features/goods/providers/secret_real_detail_provider.dart`

**Mock数据**：
- 文件：`assets/mock/goods_detail_data.json`
- ID：`593505082385898225`（未购买）、`593505082385898228`（已购买）

**跳转条件**（来自HomePage）：
```dart
// 试卷类型 + details_type=2
if (type == '8' && detailsType == '2') {
  context.push('/secret-real-detail', extra: {'productId': goodsId});
}
```

---

### 3. SubjectMockDetailPage（科目模考详情页）

**功能描述**：
- 全屏显示长图介绍（`long_img_path`）
- 底部固定购买栏
- 显示当前选中价格
- 购买按钮（未购买）或开始练习（已购买）

**对应小程序**：`modules/jintiku/pages/test/subjectMockDetail.vue`

**API接口**：
- `GET /c/goods/v2/detail?goods_id=xxx`

**核心字段**：
```dart
longImgPath: String?  // 长图介绍路径
prices: List<Price>   // 价格列表
```

**文件位置**：
- View: `lib/features/goods/views/subject_mock_detail_page.dart`
- Provider: `lib/features/goods/providers/subject_mock_detail_provider.dart`

**Mock数据**：
- 文件：`assets/mock/goods_detail_data.json`
- ID：`593505082385898227`（未购买）

**跳转条件**（来自HomePage）：
```dart
// 试卷类型 + details_type=3
if (type == '8' && detailsType == '3') {
  context.push('/subject-mock-detail', extra: {'productId': goodsId});
}
```

---

### 4. SimulatedExamRoomPage（模拟考场页）

**功能描述**：
- 左侧边栏：显示专业、满分、时长
- 右侧内容区：
  - 考场标题和副标题
  - 总分和时间信息
  - 考试统计表格（占位，需要额外接口）
  - 注意事项（3条）
  - 进入考场按钮

**对应小程序**：`modules/jintiku/pages/test/simulatedExamRoom.vue`

**API接口**：
- `GET /c/goods/v2/detail?goods_id=xxx`（基本信息）
- `GET /c/tiku/mockexam/examinfo?product_id=xxx&mock_exam_id=xxx&professional_id=xxx`（考试列表，暂未实现）

**注意事项**：
1. 交卷后，显示分数及答案解析。
2. 每天每个科目只能进行**1**次考试。
3. 考试中途退出会保留做题记录。

**文件位置**：
- View: `lib/features/goods/views/simulated_exam_room_page.dart`
- Provider: `lib/features/goods/providers/simulated_exam_room_provider.dart`

**Mock数据**：
- 文件：`assets/mock/goods_detail_data.json`
- ID：`593505082385898226`（未购买）

**跳转条件**（来自HomePage）：
```dart
// 模拟考试类型 + details_type=4 或 data_type=2
if (type == '10' || dataType == '2' || detailsType == '4') {
  context.push('/simulated-exam-room', extra: {'productId': goodsId});
}
```

---

## 📊 页面对比矩阵

| 页面 | 小程序文件 | details_type | type | permission_status | 核心特征 |
|-----|----------|-------------|------|------------------|---------|
| GoodsDetailPage | detail.vue | 1 | 18 | 1/2 | 价格选择、章节树 |
| SecretRealDetailPage | secretRealDetail.vue | 2 | 8 | 1/2 | 渐变背景、统计卡片 |
| SubjectMockDetailPage | subjectMockDetail.vue | 3 | 8 | 1/2 | 长图展示 |
| SimulatedExamRoomPage | simulatedExamRoom.vue | 4 | 10 | 1/2 | 左侧栏、注意事项 |

---

## 🗂️ Mock数据结构

### Mock文件位置
`assets/mock/goods_detail_data.json`

### 数据条目
```json
{
  "version": "1.0.0",
  "api": "GET /c/goods/v2/detail",
  "data": [
    { "goods_id": "593505082385898224", ... },  // GoodsDetailPage
    { "goods_id": "593505082385898225", ... },  // SecretRealDetailPage
    { "goods_id": "593505082385898226", ... },  // SimulatedExamRoomPage
    { "goods_id": "593505082385898227", ... },  // SubjectMockDetailPage
    { "goods_id": "593505082385898228", ... },  // SecretRealDetailPage (已购买)
    { "goods_id": "593505082385898229", ... }   // GoodsDetailPage (已购买)
  ]
}
```

### 关键字段说明
- `type`: 18-题库, 8-试卷, 10-模拟考试, 2-网课, 3-系列课
- `permission_status`: 1-已购买, 2-未购买
- `details_type`: 1-经典商品, 2-历年真题, 3-科目模考, 4-模拟考场
- `data_type`: 1-普通, 2-模考类型
- `long_img_path`: 长图路径（科目模考专用）
- `exam_title`: 考试标题（绝密真题专用）
- `paper_statistics`: 试卷统计（绝密真题专用）

---

## 🔄 Mock架构集成

### MockDatabase查询
```dart
// lib/core/mock/mock_database.dart
static Future<Map<String, dynamic>> queryGoodsDetail(Map<String, dynamic> params) async {
  await init();
  final goodsId = params['goods_id'] as String?;
  if (goodsId == null) {
    return {'code': 0, 'msg': '缺少商品ID', 'data': null};
  }
  final detail = _goodsDetailTable!.firstWhere(
    (item) => item['goods_id'] == goodsId,
    orElse: () => {},
  );
  if (detail.isEmpty) {
    return {'code': 0, 'msg': '商品不存在', 'data': null};
  }
  return {'code': 100000, 'msg': 'success', 'data': detail};
}
```

### MockDataRouter路由
```dart
// lib/core/mock/mock_data_router.dart
if (method == 'GET' && path.contains('/goods/v2/detail')) {
  return await MockDatabase.queryGoodsDetail(params);
}
```

### MockInterceptor拦截
```dart
// lib/core/network/mock_interceptor.dart
// Mock模式下自动拦截所有HTTP请求
// 如果没有对应Mock数据，拒绝请求（不会发起真实API调用）
```

---

## 🧪 测试场景

### 测试步骤
1. 在调试页面开启Mock模式
2. 返回首页，刷新数据
3. 点击不同商品卡片，验证跳转和页面显示

### 测试覆盖
- ✅ 未购买商品 → 显示购买按钮
- ✅ 已购买商品 → 显示做题/练习按钮
- ✅ 不同商品类型 → 跳转不同详情页
- ✅ 价格显示 → 使用SafeTypeConverter安全转换
- ✅ 图片加载 → CachedNetworkImage + errorWidget
- ✅ HTML内容 → HtmlWidget渲染

---

## 📝 待实现功能

### 购买功能
- [ ] 购买弹窗UI
- [ ] 价格选择交互
- [ ] 支付接口集成
- [ ] 支付结果处理

### 做题功能
- [ ] 章节练习页面
- [ ] 试卷练习页面
- [ ] 模拟考试页面
- [ ] 错题本页面

### 额外接口
- [ ] 模拟考场考试列表接口 (`/c/tiku/mockexam/examinfo`)
- [ ] 章节树详情接口 (`/c/exam/chapterpackage/tree`)

---

## 🎯 架构亮点

### MVVM分层
- **View**: 纯UI展示，无业务逻辑
- **Provider**: 状态管理 + 业务逻辑
- **Service**: API调用 + 数据转换
- **Model**: Freezed不可变数据类

### 数据安全
- 使用`dynamic`类型处理不确定字段
- `SafeTypeConverter`安全类型转换
- 完整的异常处理机制

### Mock架构
- JSON文件存储Mock数据
- Dio拦截器透明拦截请求
- 支持开关切换Mock/真实API
- 防止Mock模式下真实请求泄漏

---

## 📚 参考文档

- [商品详情页API分析](./goods_detail_page_api_analysis.md)
- [Mock架构完整方案](./mock_complete_solution.md)
- [Mock数据测试指南](./mock_data_testing_guide.md)
- [主要跳转路由](./主要跳转路由.md)

---

**更新时间**: 2025-11-29  
**状态**: ✅ 4个详情页全部实现完成


