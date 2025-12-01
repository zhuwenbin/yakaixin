# 课程详情页完整实现方案

## 📋 小程序功能分析

### 页面参数
```javascript
{
  goods_id: "xxx",
  order_id: "xxx",  // 订单ID
  goods_pid: "0"    // 套餐ID（可选）
}
```

### 数据加载流程

```
mounted() {
  ↓
1. getCourseDetail()         - 获取课程详情
   API: study.courseDetail({
     goods_id, goods_pid, order_id,
     page: 1, size: 20
   })
   返回: courseInfo = data.list[0]
  ↓
2. getCourseDetailLessons()  - 获取课程列表
   API: study.courseDetailLessons({
     goods_id, goods_pid, order_id,
     page: 1, size: 100
   })
   返回: learnCourseList = data.list
  ↓
3. getCourseDetailRecently() - 获取最近学习
   API: study.courseDetailRecently({
     goods_id, goods_pid, order_id
   })
   返回: recentlyData = data
}
```

---

## 📦 数据结构

### 1. courseInfo (课程详情)
```json
{
  "goods_id": "xxx",
  "goods_name": "2026口腔执业医师精品班",
  "business_type": 2,  // 1:普通 2:高端 3:私塾
  "class": {
    "name": "精品班A班",
    "date": "2024年10月-2025年6月",
    "teaching_type": "1",
    "teaching_type_name": "直播",
    "lesson_num": 120,
    "lesson_attendance_num": 45,
    "address": "北京市朝阳区XX路XX号",
    "teacher": [
      {
        "id": "1",
        "name": "张医生",
        "title": "主任医师",
        "avatar": "https://..."
      }
    ]
  }
}
```

### 2. learnCourseList (课程列表)
```json
[
  {
    "class_id": "xxx",
    "name": "基础阶段",
    "teaching_type": "1",
    "teaching_type_name": "直播",
    "lesson_num": 40,
    "lesson_attendance_num": 15,
    "address": "...",
    "isClose": false,
    "lesson": [
      {
        "lesson_id": "xxx",
        "lesson_name": "口腔解剖学",
        "lesson_name_other": "牙体解剖、颌面部解剖",
        "date": "2024-10-15 19:00-21:00",
        "teaching_type": "1",
        "status": "2",  // 1:未学 2:已学
        "lesson_status": "3",  // 3:回放可看
        "evaluation_type_top": [
          {
            "id": "1",
            "name": "课前作业",
            "paper_version_id": "xxx"
          }
        ]
      }
    ]
  }
]
```

### 3. recentlyData (最近学习)
```json
{
  "lesson_id": "xxx",
  "lesson_name": "口腔解剖学"
}
```

---

## 🎯 Flutter实现任务

### ✅ 已完成
1. ✅ 页面框架和UI布局
2. ✅ 购买状态判断逻辑
3. ✅ "去学习"按钮
4. ✅ 空数据处理

### 🔄 待实现
1. ❌ 创建CourseDetailService (3个API)
2. ❌ 创建CourseDetailProvider (状态管理)
3. ❌ 创建CourseDetail相关Model
4. ❌ 创建Mock数据文件
5. ❌ 接入真实API调用

---

## 📂 需要创建的文件

### Models
```
lib/features/course/models/
├── course_detail_model.dart     (课程详情)
├── course_class_model.dart      (班级信息)
└── course_lesson_model.dart     (课节信息)
```

### Services
```
lib/features/course/services/
└── course_detail_service.dart   (3个API方法)
```

### Providers
```
lib/features/course/providers/
└── course_detail_provider.dart  (状态管理)
```

### Mock Data
```
assets/mock/
└── course_detail_data.json      (课程详情Mock数据)
```

---

## 🔧 快速实现步骤

### Step 1: 创建CourseDetailService (20分钟)

```dart
class CourseDetailService {
  final DioClient _dioClient;

  /// 获取课程详情
  Future<CourseDetailModel> getCourseDetail({
    required String goodsId,
    required String orderId,
    String? goodsPid,
  }) async {
    final response = await _dioClient.get('/c/study/course/detail', ...);
    return CourseDetailModel.fromJson(response.data['data']['list'][0]);
  }

  /// 获取课程列表
  Future<List<CourseClassModel>> getCourseDetailLessons({...}) async {...}

  /// 获取最近学习
  Future<RecentlyDataModel?> getCourseDetailRecently({...}) async {...}
}
```

### Step 2: 创建Models (30分钟)

使用Freezed创建不可变数据类

### Step 3: 创建Provider (20分钟)

```dart
@freezed
class CourseDetailState with _$CourseDetailState {
  const factory CourseDetailState({
    CourseDetailModel? courseInfo,
    @Default([]) List<CourseClassModel> classList,
    RecentlyDataModel? recentlyData,
    @Default(true) bool isLoading,
    String? error,
  }) = _CourseDetailState;
}
```

### Step 4: 创建Mock数据 (30分钟)

在 `assets/mock/course_detail_data.json` 中创建完整数据

### Step 5: 更新UI (20分钟)

用Provider替换现有的Mock数据引用

---

**预计总时间**: 约2小时

---

## 💡 建议

由于课程详情页比较复杂，建议：
1. 先实现基础API调用
2. 再完善UI细节
3. 最后添加交互功能

或者：
- 暂时保持当前"开发中"状态
- 优先完成更重要的功能（如题库页面）

