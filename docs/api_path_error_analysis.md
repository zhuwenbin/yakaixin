# 🔴 题库页面 API 路径错误问题

## 问题分析

### 错误日志
```
flutter: ❌ [API错误] GET /api/c/exam/learningData
flutter: ❌ [响应数据] 404 page not found
flutter: ❌ [响应状态码] 404

flutter: ❌ [API错误] GET /api/c/exam/chapter
flutter: ❌ [响应数据] 404 page not found

flutter: ❌ [API错误] GET /api/c/exam/chapterpackage
flutter: ❌ [响应数据] 404 page not found
```

---

## 根本原因：API路径错误 ❌

### 对比分析

| 功能 | Flutter (错误) | 小程序 (正确) | 状态 |
|------|---------------|--------------|------|
| 学习数据 | `/c/exam/learningData` | `/c/tiku/exam/learning/data` | ❌ 错误 |
| 打卡 | `/c/exam/checkinData` | `/c/tiku/exam/checkin/data` | ❌ 错误 |
| 章节列表 | `/c/exam/chapter` | `/c/tiku/chapter/list` | ❌ 错误 |
| 技能模拟 | `/c/exam/chapterpackage` | `/c/tiku/homepage/recommend/chapterpackage` | ❌ 错误 |

---

## 🔍 小程序API定义

### 1. 学习数据API
**文件**: `mini-dev_250812/src/modules/jintiku/api/index.js` Line 1037-1043

```javascript
export const examLearningData = function (data = {}) {
  return http({
    url: '/c/tiku/exam/learning/data',  // ✅ 正确路径
    method: 'GET',
    data
  })
}
```

### 2. 打卡API
**文件**: `mini-dev_250812/src/modules/jintiku/api/index.js` Line 1025-1034

```javascript
export const examCheckinData = function (data = {}) {
  return http({
    url: '/c/tiku/exam/checkin/data',  // ✅ 正确路径
    method: 'POST',
    data,
    header: {
      'Content-Type': 'application/json'
    }
  })
}
```

### 3. 章节列表API
**文件**: `mini-dev_250812/src/modules/jintiku/api/chapter.js` Line 13-19

```javascript
export const getChapterlist = function (data = {}) {
  return http({
    url: '/c/tiku/chapter/list',  // ✅ 正确路径
    method: 'GET',
    data
  })
}
```

### 4. 技能模拟API
**文件**: `mini-dev_250812/src/modules/jintiku/api/index.js` Line 929-936

```javascript
export const chapterpackage = (data = {}) => {
  return http({
    url: '/c/tiku/homepage/recommend/chapterpackage',  // ✅ 正确路径
    method: 'GET',
    data
  })
}
```

---

## 🔧 修复方案

### 需要修改的文件

#### 1. `lib/features/home/services/learning_service.dart`

```dart
// ❌ 错误
final response = await _dioClient.get('/c/exam/learningData', ...);

// ✅ 正确
final response = await _dioClient.get('/c/tiku/exam/learning/data', ...);

// ❌ 错误
final response = await _dioClient.post('/c/exam/checkinData', ...);

// ✅ 正确
final response = await _dioClient.post('/c/tiku/exam/checkin/data', ...);
```

#### 2. `lib/features/home/services/chapter_service.dart`

```dart
// ❌ 错误
final response = await _dioClient.get('/c/exam/chapter', ...);

// ✅ 正确
final response = await _dioClient.get('/c/tiku/chapter/list', ...);

// ❌ 错误
final response = await _dioClient.get('/c/exam/chapterpackage', ...);

// ✅ 正确
final response = await _dioClient.get('/c/tiku/homepage/recommend/chapterpackage', ...);
```

---

## 📋 完整API路径清单

| 功能 | 正确路径 | 方法 | Service |
|------|---------|------|---------|
| 学习数据 | `/c/tiku/exam/learning/data` | GET | LearningService |
| 打卡 | `/c/tiku/exam/checkin/data` | POST | LearningService |
| 章节列表 | `/c/tiku/chapter/list` | GET | ChapterService |
| 技能模拟 | `/c/tiku/homepage/recommend/chapterpackage` | GET | ChapterService |
| 已购商品 | `/c/goods/v2` | GET | GoodsService |
| 每日一测 | `/c/goods/v2` | GET | GoodsService |

---

## ⚠️ 其他发现的问题

### 1. 响应数据结构

小程序章节列表返回：
```javascript
{
  code: 100000,
  data: {
    section_info: [...]  // ✅ 章节数据在 section_info 中
  }
}
```

Flutter当前实现：
```dart
final list = (data['list'] as List?) ?? [];  // ❌ 错误字段
```

**需要修复**：
```dart
final sectionInfo = (data['section_info'] as List?) ?? [];  // ✅ 正确字段
```

---

**修复优先级**: 🔴 **最高** - 导致所有API请求404  
**影响范围**: 学习数据、打卡、章节练习、技能模拟  
**修复时间**: 约10分钟

