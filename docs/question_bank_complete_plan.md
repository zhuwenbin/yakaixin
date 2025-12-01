# 题库页面完整功能实现计划

## 📋 小程序功能分析

### 页面结构 (对应 index.vue)

```
┌─────────────────────────────────────────┐
│  1. 顶部导航栏 (专业切换)                │
├─────────────────────────────────────────┤
│  2. 学习日历组件 (StudyCalendar)        │
│     - 坚持打卡天数 (checkin_num)        │
│     - 已做题数 (total_num)              │
│     - 正确率 (correct_rate)             │
│     - 今日打卡状态 (is_checkin)         │
│     - 打卡按钮                          │
├─────────────────────────────────────────┤
│  3. 4功能卡片 (StudyCardGrid)           │
│     - 绝密押题 (position_identify:       │
│       jemiyati)                         │
│     - 科目模考 (position_identify:       │
│       kemupattern)                      │
│     - 模拟考试 (position_identify:       │
│       mokao)                            │
│     - 学习报告                          │
├─────────────────────────────────────────┤
│  4. 每日一测 (DailyNav)                 │
│     - 条件显示 (hasDaily30)             │
│     - position_identify: daily30        │
├─────────────────────────────────────────┤
│  5. 章节练习 (IndexNav)                 │
│     - API: /c/tiku/chapter/list         │
│     - 显示前几个章节                     │
│     - 查看更多按钮                       │
├─────────────────────────────────────────┤
│  6. 技能模拟 (SkillMockNav)             │
│     - 条件显示 (hasSkillMock &&          │
│       showSkillMock)                    │
│     - 特定专业显示 (口腔执业医师/        │
│       助理医师)                         │
│     - position_identify: jinengmoni     │
├─────────────────────────────────────────┤
│  7. 已购试题 (IndexNavItem)             │
│     - type: 10,8                        │
│     - is_buyed: 1                       │
│     - 循环显示列表                       │
└─────────────────────────────────────────┘
```

---

## 🔍 核心数据流程

### 1. 页面初始化 (onLoad)
```javascript
init(e) {
  // 1. 处理场景参数 (scene, employee_id, major_id)
  // 2. 检查专业是否设置，默认口腔执业医师
  // 3. 调用 getSkillMock() - 检查是否有技能模拟
  // 4. 调用 getDaily30() - 检查是否有每日一测
  // 5. 调用 apiExamLearningData() - 获取学习数据
}
```

### 2. 页面显示 (onShow)
```javascript
onShow() {
  // 1. 调用 startFun() - 启动函数
  // 2. 调用 autoUpdate() - 自动更新
  // 3. 调用 activityRecord() - 活动记录
}
```

### 3. 数据更新 (updata)
```javascript
updata() {
  // 1. 清空已有数据列表
  // 2. 调用 getGoods() - 获取商品列表
  // 3. 调用 indexNav.init() - 刷新章节列表
  // 4. 调用 apiExamLearningData() - 刷新学习数据
  // 5. 调用 majorChangeInit() - 专业切换初始化
}
```

---

## 📦 API调用清单

| API | 路径 | 方法 | 用途 | 何时调用 |
|-----|------|------|------|----------|
| 学习数据 | `/c/tiku/exam/learning/data` | GET | 获取打卡统计 | 初始化、打卡后、专业切换 |
| 打卡 | `/c/tiku/exam/checkin/data` | POST | 每日打卡 | 点击打卡按钮 |
| 章节列表 | `/c/tiku/chapter/list` | GET | 获取章节 | 初始化、专业切换 |
| 技能模拟 | `/c/tiku/homepage/recommend/chapterpackage` | GET | 检查是否有技能模拟 | 初始化、专业切换 |
| 每日一测 | `/c/goods/v2` | GET | 检查是否有每日一测 | 初始化、专业切换 |
| 已购商品 | `/c/goods/v2` | GET | 获取已购试题 | 初始化、专业切换 |

---

## 🎯 Flutter实现任务

### ✅ 已完成
1. ✅ LearningService 创建
2. ✅ ChapterService 创建
3. ✅ GoodsService 扩展
4. ✅ QuestionBankProvider 基础实现
5. ✅ API路径修复
6. ✅ 基础UI实现

### 🔄 待完善

#### 1. Mock数据完善
- [ ] `learning_data.json` - 学习数据
- [ ] `chapter_data.json` - 章节列表
- [ ] `goods_data.json` - 确保包含所有类型商品
- [ ] `skill_mock_data.json` - 技能模拟数据

#### 2. 学习日历组件 (_StudyCalendarCard)
- [ ] 显示坚持打卡天数
- [ ] 显示已做题数
- [ ] 显示正确率
- [ ] 打卡按钮状态 (今日是否已打卡)
- [ ] 打卡成功后刷新数据
- [ ] 打卡动画效果

#### 3. 4功能卡片 (StudyCardGrid)
```dart
// 需要补充的逻辑：
// 1. 根据 position_identify 获取商品数据
// 2. 显示商品图片、标题
// 3. 点击跳转到对应页面
const cards = [
  {
    'title': '绝密押题',
    'positionIdentify': 'jemiyati',
    'icon': '...'
  },
  {
    'title': '科目模考',
    'positionIdentify': 'kemupattern',
    'icon': '...'
  },
  {
    'title': '模拟考试',
    'positionIdentify': 'mokao',
    'icon': '...'
  },
  {
    'title': '学习报告',
    'navigate': 'study_report',
    'icon': '...'
  }
];
```

#### 4. 每日一测列表 (DailyPracticeList)
- [ ] 条件渲染 (hasDaily30)
- [ ] 显示每日一测商品
- [ ] 点击跳转到答题页面
- [ ] 显示已做题数/总题数

#### 5. 章节练习列表优化
- [ ] 默认显示前3个章节
- [ ] "查看更多"按钮
- [ ] 点击跳转到章节详情
- [ ] 显示章节进度

#### 6. 技能模拟入口
- [ ] 条件显示 (hasSkillMock && showSkillMock)
- [ ] 仅特定专业显示
- [ ] 显示技能模拟卡片
- [ ] 点击跳转

#### 7. 已购试题列表
- [ ] 查询 type=10,8 is_buyed=1
- [ ] 显示商品卡片列表
- [ ] 点击跳转到商品详情/答题页面
- [ ] 显示答题进度

#### 8. 专业切换功能
- [ ] 顶部专业选择下拉
- [ ] 切换后刷新所有数据
- [ ] 保存选择的专业

#### 9. 下拉刷新
- [ ] RefreshIndicator 实现
- [ ] 刷新所有数据

#### 10. 错误处理
- [ ] 网络错误显示
- [ ] 空数据显示
- [ ] Toast提示

---

## 📂 需要创建/修改的文件

### Models
- [x] `learning_data_model.dart` (已有)
- [x] `chapter_model.dart` (已有)
- [x] `skill_mock_model.dart` (已有)
- [x] `goods_model.dart` (已有)
- [ ] 需要检查字段完整性

### Services
- [x] `learning_service.dart` (已修复)
- [x] `chapter_service.dart` (已修复)
- [x] `goods_service.dart` (已修复)

### Providers
- [x] `question_bank_provider.dart` (已接入真实API)
- [ ] 需要完善逻辑

### Views
- [x] `question_bank_page.dart` (基础UI)
- [ ] 需要完善条件渲染和交互

### Widgets
- [x] `_StudyCalendarCard` (基础)
- [ ] 需要完善打卡逻辑
- [ ] `_DailyPracticeList` (待创建)
- [ ] `_SkillMockCard` (待创建)
- [ ] 专业选择器 (待创建)

### Mock Data
- [ ] `assets/mock/learning_data.json`
- [ ] `assets/mock/chapter_data.json`
- [ ] `assets/mock/skill_mock_data.json`
- [ ] `assets/mock/goods_data.json` (需要补充)

---

## 🎨 UI组件清单

```
QuestionBankPage
├── AppBar (专业切换下拉)
├── RefreshIndicator
│   └── CustomScrollView
│       ├── SliverToBoxAdapter
│       │   └── _StudyCalendarCard ✅
│       ├── SliverToBoxAdapter
│       │   └── StudyCardGrid (4功能卡片) ✅
│       ├── SliverToBoxAdapter
│       │   └── _DailyPracticeSection ❌ 待完善
│       ├── SliverToBoxAdapter
│       │   └── _ChapterPracticeSection ✅ 待优化
│       ├── SliverToBoxAdapter
│       │   └── _SkillMockSection ❌ 待完善
│       └── SliverList
│           └── _PurchasedGoodsList ✅ 待优化
```

---

## 🔄 数据流程图

```
用户打开页面
    ↓
QuestionBankProvider.build()
    ↓
初始化 loading=true
    ↓
并发请求 5个API:
    ├── LearningService.getLearningData()
    ├── ChapterService.getChapterList()
    ├── GoodsService.getGoodsByPosition(daily30)
    ├── ChapterService.getSkillMock()
    └── GoodsService.getGoodsList(type=10,8, is_buyed=1)
    ↓
更新 State 数据
    ↓
loading=false
    ↓
UI 渲染
    ↓
用户交互:
    ├── 打卡 → checkIn() → 刷新学习数据
    ├── 点击卡片 → 跳转对应页面
    ├── 切换专业 → 刷新所有数据
    └── 下拉刷新 → 刷新所有数据
```

---

## 📝 Mock数据需求

### 1. learning_data.json
```json
{
  "code": 100000,
  "msg": ["操作成功"],
  "data": {
    "checkin_num": 7,        // 坚持打卡天数
    "total_num": "350",      // 已做题数
    "correct_rate": "85.5",  // 正确率
    "is_checkin": 1          // 今日是否已打卡 (0/1)
  }
}
```

### 2. chapter_data.json
```json
{
  "code": 100000,
  "data": {
    "section_info": [
      {
        "id": "1",
        "name": "第一章 口腔解剖生理学",
        "do_question_num": "50",
        "total_question_num": "100",
        "correct_rate": "80.0"
      },
      // ... 更多章节
    ]
  }
}
```

### 3. skill_mock_data.json
```json
{
  "code": 100000,
  "data": {
    "id": "123456",
    "name": "技能模拟考试",
    "cover_path": "...",
    "position_identify": "jinengmoni"
  }
}
```

### 4. goods_data.json (补充)
```json
{
  "code": 100000,
  "data": {
    "list": [
      // 每日一测
      {
        "id": "1",
        "name": "每日一测",
        "type": "18",
        "position_identify": "daily30",
        "permission_status": "1"
      },
      // 绝密押题
      {
        "id": "2",
        "name": "绝密押题",
        "type": "18",
        "position_identify": "jemiyati",
        "permission_status": "2"
      },
      // ... 其他商品
    ]
  }
}
```

---

## ⏱️ 预计工作量

| 任务 | 预计时间 |
|------|---------|
| Mock数据完善 | 30分钟 |
| 学习日历组件完善 | 30分钟 |
| 4功能卡片逻辑 | 40分钟 |
| 每日一测列表 | 30分钟 |
| 章节列表优化 | 20分钟 |
| 技能模拟入口 | 20分钟 |
| 已购试题优化 | 20分钟 |
| 专业切换功能 | 40分钟 |
| 测试和调试 | 30分钟 |
| **总计** | **约4小时** |

---

## 🎯 优先级

1. 🔴 **最高优先级**: Mock数据完善 (所有功能依赖)
2. 🟠 **高优先级**: 学习日历打卡逻辑、4功能卡片
3. 🟡 **中优先级**: 每日一测、技能模拟、章节优化
4. 🟢 **低优先级**: 专业切换、UI细节优化

---

**下一步**: 从Mock数据完善开始，按优先级逐一实现功能

