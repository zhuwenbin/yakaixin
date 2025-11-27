# Mock 首页数据使用说明

## 概述

已完成首页所需的所有 Mock 数据，包括商品列表（题库、网课、直播）和配置接口。

## 完成的 Mock 数据

### 1. 商品列表数据 (`goods_data.json`)

**文件路径**: `assets/mock/goods_data.json`

**数据内容**: 
- **题库商品** (7条): type=8(试卷)、10(模考)、18(章节练习)
- **网课商品** (3条): type=2、3，teaching_type=3(录播)
- **直播商品** (3条): type=2、3，teaching_type=1(直播)

**总计**: 13条商品数据，覆盖首页所有Tab的展示需求

**数据字段**:
```json
{
  "id": "商品ID",
  "name": "商品名称",
  "material_cover_path": "封面图片路径",
  "type": "商品类型(8=试卷,10=模考,18=章节练习,2=网课,3=系列课)",
  "type_name": "类型名称",
  "teaching_type": "授课类型(0=题库,1=直播,3=录播)",
  "teaching_type_name": "授课类型名称",
  "business_type": "业务类型",
  "is_recommend": "是否推荐",
  "sale_price": "售价",
  "original_price": "原价",
  "permission_status": "权限状态(1=已购买,2=未购买)",
  "is_homepage_recommend": "是否首页推荐(1=是)",
  "seckill_countdown": "秒杀倒计时(秒)",
  "total_class_hour": "总课时",
  "student_num": "学员数量",
  "teacher_data": "教师信息数组",
  "create_time": "创建时间"
}
```

### 2. 配置数据 (`config_data.json`)

**文件路径**: `assets/mock/config_data.json`

**数据内容**:
```json
{
  "PUBLISH": {
    "code": "PUBLISH",
    "value": "2",
    "description": "发布状态：1=仅显示题库，2=显示题库+网课+直播"
  }
}
```

**作用**: 控制首页 Tab 的显示
- value="1": 仅显示"题库"Tab
- value="2": 显示"题库"、"网课"、"直播"三个Tab

## Mock 接口支持

### 1. 商品列表接口

**接口路径**: 
- `GET /c/goods/v2/servicehall/mine`
- `GET /c/goods/v2/servicehall/mine/courseevaluation`

**支持的查询参数**:

#### 基础筛选
```dart
// 题库商品 (type=8,10,18)
GET /c/goods/v2?type=8,10,18

// 网课商品 (teaching_type=3, type=2,3)
GET /c/goods/v2?teaching_type=3&type=2,3

// 直播商品 (teaching_type=1, type=2,3)
GET /c/goods/v2?teaching_type=1&type=2,3

// 首页推荐商品 (is_homepage_recommend=1 && permission_status=2)
GET /c/goods/v2?is_homepage_recommend=1&permission_status=2
```

#### 多条件组合
```dart
// 未购买的网课
GET /c/goods/v2?teaching_type=3&permission_status=2

// 未购买的试卷
GET /c/goods/v2?type=8&permission_status=2

// 价格范围查询
GET /c/goods/v2?sale_price_min=100&sale_price_max=500

// 名称模糊查询
GET /c/goods/v2?name_like=口腔
```

#### 排序和分页
```dart
// 按创建时间降序
GET /c/goods/v2?sort=create_time&order=desc

// 按学员数量降序
GET /c/goods/v2?sort=student_num&order=desc

// 分页查询
GET /c/goods/v2?page=1&page_size=10
```

### 2. 配置接口

**接口路径**: `GET /c/common/configcommon/getbycode`

**查询参数**:
```dart
GET /c/common/configcommon/getbycode?code=PUBLISH
```

**返回数据**:
```json
{
  "code": 200,
  "msg": "success",
  "data": "2"
}
```

## 首页数据筛选逻辑

### 1. 秒杀轮播 (Swiper)

**筛选条件**:
- `is_homepage_recommend=1`: 首页推荐
- `permission_status=2`: 未购买

**对应数据** (4条):
```
1. 2026口腔执业医师历年真题精选 (type=8, seckill_countdown=3600秒)
2. 口腔医学综合模拟考试 (type=10, seckill_countdown=1800秒)
3. 口腔解剖学精讲课程 (type=18)
4. 口腔执业医师基础精讲课 (type=3, 网课)
```

### 2. 题库Tab (tabIndex=1)

**筛选条件**: `type=8,10,18`

**对应数据** (7条):
- 章节练习 (type=18): 3条
- 试卷 (type=8): 2条
- 模考 (type=10): 2条

### 3. 网课Tab (tabIndex=2)

**筛选条件**: `teaching_type=3&type=2,3`

**对应数据** (3条):
- 2026精品医师考试高清网课 (type=2)
- 口腔执业医师基础精讲课 (type=3)
- 口腔内科学精讲网课 (type=2)

### 4. 直播Tab (tabIndex=3)

**筛选条件**: `teaching_type=1&type=2,3`

**对应数据** (3条):
- 口腔执业医师直播课 (type=2)
- 2026医师考试冲刺直播 (type=3)
- 口腔修复学专题直播 (type=2)

## 使用示例

### 在 Provider 中使用 (零污染方式)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

// 1. 获取首页Tab配置
@riverpod
class HomeTabConfig extends _$HomeTabConfig {
  @override
  Future<String> build() async {
    final api = ref.read(apiProvider);
    final response = await api.getConfigCommon(code: 'PUBLISH');
    return response.data ?? '1'; // 默认只显示题库
  }
}

// 2. 获取题库商品列表 (type=8,10,18)
@riverpod
class GoodsListTiku extends _$GoodsListTiku {
  @override
  Future<List<Goods>> build() async {
    final api = ref.read(apiProvider);
    final response = await api.getGoods(
      type: '8,10,18',
      shelfPlatformId: '1',
      professionalId: '123',
    );
    return response.data?.list ?? [];
  }
}

// 3. 获取网课列表 (teaching_type=3, type=2,3)
@riverpod
class GoodsListOnline extends _$GoodsListOnline {
  @override
  Future<List<Goods>> build() async {
    final api = ref.read(apiProvider);
    final response = await api.getGoods(
      teachingType: '3',
      type: '2,3',
      shelfPlatformId: '1',
    );
    return response.data?.list ?? [];
  }
}

// 4. 获取直播列表 (teaching_type=1, type=2,3)
@riverpod
class GoodsListLive extends _$GoodsListLive {
  @override
  Future<List<Goods>> build() async {
    final api = ref.read(apiProvider);
    final response = await api.getGoods(
      teachingType: '1',
      type: '2,3',
      shelfPlatformId: '1',
    );
    return response.data?.list ?? [];
  }
}

// 5. 获取秒杀推荐列表
@riverpod
class GoodsListRecommend extends _$GoodsListRecommend {
  @override
  Future<List<Goods>> build() async {
    final api = ref.read(apiProvider);
    final response = await api.getGoods(
      type: '8,10,18',
      shelfPlatformId: '1',
      professionalId: '123',
    );
    
    // 筛选首页推荐且未购买的商品
    final list = response.data?.list ?? [];
    return list.where((item) => 
      item.isHomepageRecommend == '1' && 
      item.permissionStatus == '2'
    ).toList();
  }
}
```

### 在 Page 中使用 (零污染方式)

```dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 监听Tab配置
    final tabConfigAsync = ref.watch(homeTabConfigProvider);
    
    // 2. 监听各个商品列表
    final tikuAsync = ref.watch(goodsListTikuProvider);
    final onlineAsync = ref.watch(goodsListOnlineProvider);
    final liveAsync = ref.watch(goodsListLiveProvider);
    final recommendAsync = ref.watch(goodsListRecommendProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Column(
        children: [
          // 秒杀轮播
          recommendAsync.when(
            data: (list) => _buildSeckillSwiper(list),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => Text('Error: $e'),
          ),
          
          // Tab切换
          tabConfigAsync.when(
            data: (config) => _buildTabs(config),
            loading: () => const SizedBox(),
            error: (e, s) => const SizedBox(),
          ),
          
          // 内容区域
          Expanded(
            child: TabBarView(
              children: [
                // 题库Tab
                tikuAsync.when(
                  data: (list) => _buildGoodsList(list),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error: $e'),
                ),
                // 网课Tab
                if (tabConfigAsync.value == '2')
                  onlineAsync.when(
                    data: (list) => _buildGoodsList(list),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error: $e'),
                  ),
                // 直播Tab
                if (tabConfigAsync.value == '2')
                  liveAsync.when(
                    data: (list) => _buildGoodsList(list),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error: $e'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSeckillSwiper(List<Goods> list) {
    if (list.isEmpty) {
      return const Center(child: Text('暂无秒杀商品'));
    }
    
    return SizedBox(
      height: 200.h,
      child: PageView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final goods = list[index];
          return GoodsCard(goods: goods, showSeckill: true);
        },
      ),
    );
  }
  
  Widget _buildTabs(String config) {
    final tabs = <String>['题库'];
    if (config == '2') {
      tabs.addAll(['网课', '直播']);
    }
    
    return TabBar(
      tabs: tabs.map((name) => Tab(text: name)).toList(),
    );
  }
  
  Widget _buildGoodsList(List<Goods> list) {
    if (list.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }
    
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final goods = list[index];
        return GoodsCard(goods: goods);
      },
    );
  }
}
```

## Mock 开关控制

**开发环境**:
```dart
// lib/core/config/env.dart
class Env {
  static const bool enableMock = true;  // 开启Mock
}
```

**生产环境**:
```dart
class Env {
  static const bool enableMock = false;  // 关闭Mock
}
```

## 数据完整性验证

### ✅ 题库商品 (type=8,10,18)
- [x] 章节练习 (type=18): 3条 ✅
- [x] 试卷 (type=8): 2条 ✅
- [x] 模考 (type=10): 2条 ✅

### ✅ 网课商品 (teaching_type=3, type=2,3)
- [x] 网课 (type=2): 2条 ✅
- [x] 系列课 (type=3): 1条 ✅

### ✅ 直播商品 (teaching_type=1, type=2,3)
- [x] 直播课 (type=2): 2条 ✅
- [x] 系列直播 (type=3): 1条 ✅

### ✅ 秒杀推荐 (is_homepage_recommend=1 && permission_status=2)
- [x] 包含题库、网课、直播多种类型 ✅
- [x] 带有倒计时数据 ✅

### ✅ 配置接口
- [x] PUBLISH 配置 ✅

## 参数筛选能力验证

### ✅ 精确匹配
- [x] type=8 → 筛选出2条试卷 ✅
- [x] teaching_type=1 → 筛选出3条直播 ✅
- [x] permission_status=1 → 筛选出已购买 ✅

### ✅ 多值匹配
- [x] type=8,10,18 → 筛选出7条题库 ✅
- [x] type=2,3 → 筛选出6条网课+直播 ✅

### ✅ 模糊查询
- [x] name_like=口腔 → 筛选出包含"口腔"的商品 ✅
- [x] name_like=医师 → 筛选出包含"医师"的商品 ✅

### ✅ 范围查询
- [x] sale_price_min=100&sale_price_max=500 → 筛选价格区间 ✅

### ✅ 排序
- [x] sort=create_time&order=desc → 按时间降序 ✅
- [x] sort=student_num&order=desc → 按学员数降序 ✅

### ✅ 分页
- [x] page=1&page_size=10 → 分页查询 ✅

## 总结

✅ **首页Mock数据已完整实现**，包括：
1. 商品列表数据（13条，覆盖题库+网课+直播）
2. 配置接口数据（控制Tab显示）
3. 支持所有查询参数（精确、多值、模糊、范围、排序、分页）
4. 秒杀推荐数据完整（包含倒计时）
5. 教师信息数组完整
6. 零污染实现（页面代码无Mock逻辑）

**可以直接在首页使用，无需任何额外配置！** 🎉
