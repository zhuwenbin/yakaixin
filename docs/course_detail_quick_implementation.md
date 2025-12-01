# 学习课程详情页快速实现方案

## 📋 API接口（小程序 api/index.js）

### 1. 获取课程详情
```javascript
// URL: /c/study/learning/series
// 方法: GET
// 参数: { goods_id, goods_pid, order_id, page, size }
// 返回: { list: [courseInfo] }
```

### 2. 获取课程课节列表
```javascript
// URL: /c/study/learning/series/goods
// 方法: GET
// 参数: { goods_id, goods_pid, order_id, page, size }
// 返回: { list: [classInfo] }
```

### 3. 获取最近学习记录
```javascript
// URL: /c/study/learning/series/recent
// 方法: GET
// 参数: { goods_id, goods_pid, order_id }
// 返回: { lesson_id, lesson_name }
```

## 🚀 快速实现步骤

### Step 1: 创建 Service (10分钟)
创建 `course_detail_service.dart`，封装3个API

### Step 2: 创建 Mock 数据 (15分钟)
在 `assets/mock/course_detail_data.json` 创建测试数据

### Step 3: 更新 Provider (15分钟)
创建 `course_detail_provider.dart` 管理状态

### Step 4: 更新 UI (10分钟)
修改 `course_detail_page.dart` 使用真实数据

## ⚡ 预计总时间：50分钟

立即开始实现！

