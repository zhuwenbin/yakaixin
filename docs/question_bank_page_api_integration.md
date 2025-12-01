# 题库主页面 - 小程序 vs Flutter 对比分析

## 📋 功能模块对比

| 功能模块 | 小程序 (index.vue) | Flutter (question_bank_page.dart) | 状态 |
|---------|-------------------|----------------------------------|------|
| **专业选择** | ✅ 顶部专业切换 | ✅ 已实现 | ✅ 完成 |
| **学习日历** | ✅ 打卡、做题数、正确率 | ✅ 已实现UI | ⚠️ **需接入真实API** |
| **4个功能卡片** | ✅ 绝密押题、科目模考、模拟考试、学习报告 | ✅ 已实现 | ⚠️ **需优化跳转逻辑** |
| **每日一测** | ✅ 显示、跳转 | ✅ 已实现UI | ⚠️ **需接入真实API** |
| **章节练习** | ✅ 显示前3个章节 | ✅ 已实现UI | ⚠️ **需接入真实API** |
| **技能模拟** | ✅ 特定专业显示 | ✅ 已实现UI | ⚠️ **需接入真实API** |
| **已购试题** | ✅ 已购买商品列表 | ✅ 已实现UI | ⚠️ **需接入真实API** |

---

## 🔌 需要接入的真实API

### 1. 学习数据API ⚠️ **优先级：高**

**小程序实现**（Line 323-360）：
```javascript
apiExamLearningData() {
  let { major_id = '' } = uni.getStorageSync('__xingyun_major__')
  let { student_id = '' } = uni.getStorageSync('__xingyun_userinfo__')
  
  let params = {
    professional_id: major_id,
    user_id: student_id,
    student_id: student_id
  }
  examLearningData(params).then(res => {
    if (res.code === 100000) {
      this.examLearningData = res.data;
    }
  })
}
```

**API接口**：
- 接口路径：`/c/exam/learningData`
- 请求方法：`GET`
- 请求参数：
  ```dart
  {
    'professional_id': String,  // 专业ID
    'user_id': String?,         // 用户ID（可选）
    'student_id': String?       // 学生ID（可选）
  }
  ```
- 响应数据：
  ```dart
  {
    'code': 100000,
    'data': {
      'checkin_num': int,      // 打卡天数
      'total_num': int,        // 做题总数
      'correct_rate': String,  // 正确率（如 "75.5"）
      'is_checkin': int        // 是否已打卡（0-未打卡, 1-已打卡）
    }
  }
  ```

**Flutter待实现**：
- 文件：`lib/features/home/services/learning_service.dart`
- 方法：`getLearningData(String professionalId, String? userId)`

---

### 2. 打卡API ⚠️ **优先级：高**

**小程序实现**（Line 302-322）：
```javascript
apiExamCheckinData() {
  let { major_id = '' } = uni.getStorageSync('__xingyun_major__')
  
  let params = {
    professional_id: major_id ? major_id : '524033912737962623'
  }
  
  examCheckinData(params).then(res => {
    if (res.code === 100000) {
      this.apiExamLearningData();  // 打卡成功后刷新学习数据
    } else {
      uni.showToast({ title: res.msg[0], icon: 'error' })
    }
  })
}
```

**API接口**：
- 接口路径：`/c/exam/checkinData`
- 请求方法：`POST`
- 请求参数：
  ```dart
  {
    'professional_id': String  // 专业ID
  }
  ```
- 响应数据：
  ```dart
  {
    'code': 100000,
    'msg': ['打卡成功']
  }
  ```

**Flutter待实现**：
- 文件：`lib/features/home/services/learning_service.dart`
- 方法：`checkIn(String professionalId)`

---

### 3. 章节练习API ⚠️ **优先级：中**

**小程序实现**：
- 通过子组件 `index-nav` 实现
- 参考：`src/modules/jintiku/components/commen/index-nav.vue`

**API接口**：
- 接口路径：`/c/exam/chapter`
- 请求方法：`GET`
- 请求参数：
  ```dart
  {
    'professional_id': String  // 专业ID
  }
  ```
- 响应数据：
  ```dart
  {
    'code': 100000,
    'data': {
      'list': [
        {
          'id': String,
          'section_name': String,         // 章节名称
          'question_number': int,         // 总题数
          'do_question_num': int,         // 已做题数
          'correct_rate': double,         // 正确率
          'accuracy': String              // 正确率百分比
        }
      ]
    }
  }
  ```

**Flutter当前状态**：
- ✅ UI已实现
- ❌ API未接入（使用Mock数据）

**Flutter待实现**：
- 文件：`lib/features/home/services/chapter_service.dart`
- 方法：`getChapterList(String professionalId)`

---

### 4. 每日一测API ⚠️ **优先级：中**

**小程序实现**（Line 380-396）：
```javascript
getDaily30() {
  getGoods({
    professional_id: uni.getStorageSync('__xingyun_major__').major_id || '',
    position_identify: "daily30",  // 特殊标识
  }).then(res => {
    if (res.data && res.data.list && res.data.list.length == 0) {
      this.hasDaily30 = false
    } else {
      this.hasDaily30 = true
    }
  })
}
```

**API接口**：
- 接口路径：`/c/goods/v2`
- 请求方法：`GET`
- 请求参数：
  ```dart
  {
    'professional_id': String,
    'position_identify': 'daily30'  // 固定值
  }
  ```
- 响应数据：
  ```dart
  {
    'code': 100000,
    'data': {
      'list': [
        {
          'id': String,
          'name': String,              // 每日一练
          'total_question': int,       // 总题数
          'done_question': int         // 已做题数
        }
      ]
    }
  }
  ```

**Flutter当前状态**：
- ✅ UI已实现
- ❌ API未接入

---

### 5. 技能模拟API ⚠️ **优先级：低**

**小程序实现**（Line 361-379）：
```javascript
getSkillMock() {
  chapterpackage({
    professional_id: uni.getStorageSync('__xingyun_major__').major_id || '',
    position_identify: "jinengmoni",  // 特殊标识
    noloading: true
  }).then(res => {
    if (res.data && res.data.id != 0) {
      this.hasSkillMock = true;
    } else {
      this.hasSkillMock = false
    }
  })
}
```

**API接口**：
- 接口路径：`/c/exam/chapterpackage`
- 请求方法：`GET`
- 请求参数：
  ```dart
  {
    'professional_id': String,
    'position_identify': 'jinengmoni'  // 固定值
  }
  ```

**Flutter当前状态**：
- ✅ UI已实现
- ❌ API未接入

---

### 6. 已购试题API ⚠️ **优先级：中**

**小程序实现**（Line 290-300）：
```javascript
getGoods({
  shelf_platform_id,
  professional_id: major_id,
  type: '10,8',
  is_buyed: 1  // 已购买标识
}).then(res => {
  this.goodsList10 = res.data.list
})
```

**API接口**：
- 接口路径：`/c/goods/v2`
- 请求方法：`GET`
- 请求参数：
  ```dart
  {
    'shelf_platform_id': String,
    'professional_id': String,
    'type': '10,8',  // 模拟考试、试卷
    'is_buyed': 1    // 1-已购买, 0-未购买
  }
  ```
- 响应数据：
  ```dart
  {
    'code': 100000,
    'data': {
      'list': [
        {
          'id': String,
          'name': String,
          'material_cover_path': String,
          'tiku_goods_details': {
            'question_num': int
          }
        }
      ]
    }
  }
  ```

**Flutter当前状态**：
- ✅ UI已实现
- ❌ API未接入

---

## 🎯 实现优先级

### 高优先级（核心功能）
1. ✅ **学习数据API** - 打卡、做题数、正确率（首屏核心数据）
2. ✅ **打卡API** - 用户交互核心功能

### 中优先级（内容展示）
3. **章节练习API** - 主要学习入口
4. **已购试题API** - 已购买商品展示
5. **每日一测API** - 每日学习引导

### 低优先级（特定场景）
6. **技能模拟API** - 仅特定专业显示

---

## 🔧 需要修复的问题

### 1. 4个功能卡片的跳转逻辑 ⚠️

**当前问题**：
```dart
// question_bank_page.dart Line 750-765
void _handleCardClick(BuildContext context, WidgetRef ref, int type) {
  switch (type) {
    case 0:
      // 绝密押题
      _navigateToGoodsDetail(context, ref, 'linianzhenti', AppRoutes.secretRealDetail);
      break;
    // ...
  }
}
```

**问题分析**：
- ❌ 使用了错误的 `positionIdentify`：`linianzhenti`（历年真题）
- ✅ 应该使用小程序中的标识

**小程序参考**：
```javascript
// study-card-grid.vue 组件
cards: [
  { 
    title: '绝密押题',
    positionIdentify: 'jemiyati'  // ✅ 正确标识
  },
  {
    title: '科目模考',
    positionIdentify: 'kemumokao'
  },
  {
    title: '模拟考试',
    positionIdentify: 'mokao'
  }
]
```

**需要修复**：
```dart
case 0:
  // ✅ 修复为正确的标识
  _navigateToGoodsDetail(context, ref, 'jemiyati', AppRoutes.secretRealDetail);
  break;
case 1:
  _navigateToGoodsDetail(context, ref, 'kemumokao', AppRoutes.subjectMockDetail);
  break;
case 2:
  _navigateToGoodsDetail(context, ref, 'mokao', AppRoutes.simulatedExamRoom);
  break;
```

---

### 2. GoodsService缺少方法 ⚠️

**当前问题**：
```dart
// question_bank_page.dart Line 786
final response = await goodsService.getGoodsByPosition(
  positionIdentify: positionIdentify,
  professionalId: professionalId.isNotEmpty ? professionalId : null,
);
```

**问题**：
- ❌ `GoodsService` 中没有 `getGoodsByPosition` 方法
- ❌ `GoodsService` 中没有 `getGoodsList` 方法（HomeProvider需要）

**需要实现**：
```dart
// lib/features/goods/services/goods_service.dart
class GoodsService {
  // 1. 通过position_identify获取商品
  Future<GoodsListResponse> getGoodsByPosition({
    required String positionIdentify,
    String? professionalId,
  }) async { ... }
  
  // 2. 获取商品列表（支持多个查询参数）
  Future<GoodsListResponse> getGoodsList({
    String? shelfPlatformId,
    String? professionalId,
    String? type,
    String? teachingType,
    int? isBuyed,
  }) async { ... }
}
```

---

## 📝 实现步骤建议

### Step 1: 创建LearningService（高优先级）
1. 创建 `lib/features/home/services/learning_service.dart`
2. 实现 `getLearningData` 方法
3. 实现 `checkIn` 方法
4. 更新 `QuestionBankProvider` 调用真实API

### Step 2: 扩展GoodsService（高优先级）
1. 添加 `getGoodsList` 方法
2. 添加 `getGoodsByPosition` 方法
3. 处理所有查询参数

### Step 3: 创建ChapterService（中优先级）
1. 创建 `lib/features/home/services/chapter_service.dart`
2. 实现 `getChapterList` 方法
3. 更新 `QuestionBankProvider` 调用真实API

### Step 4: 修复跳转逻辑（高优先级）
1. 修复4个功能卡片的 `positionIdentify`
2. 测试跳转到各个详情页

### Step 5: 测试与优化
1. 测试Mock模式和真实API模式切换
2. 处理Loading状态和Error状态
3. 优化用户体验

---

## ⚠️ 注意事项

1. **API参数命名**：
   - 小程序使用蛇形命名：`professional_id`, `shelf_platform_id`
   - Flutter Dart使用驼峰命名：`professionalId`, `shelfPlatformId`
   - 需要在API调用时转换

2. **数据类型安全**：
   - 使用 `dynamic` 接收不确定类型字段
   - 使用 `SafeTypeConverter` 安全转换
   - 参考：`data_type_safety.md`

3. **Mock数据支持**：
   - 所有新API都需要添加Mock数据
   - 更新 `MockDatabase` 和 `MockDataRouter`

4. **错误处理**：
   - 使用 `EasyLoading` 显示错误信息
   - 提供友好的错误提示

---

**更新时间**: 2025-11-29  
**状态**: 📋 待实现


