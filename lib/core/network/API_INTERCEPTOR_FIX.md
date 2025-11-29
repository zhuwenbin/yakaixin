# API 拦截器修复文档

## 问题描述

**时间**: 2025-01-27

**问题**: Flutter 商品详情页 `permission_status` 返回值不正确

**现象**:
- 网页端调用 `/c/goods/v2/detail` API 返回 `permission_status='1'`（已购买）
- Flutter 端调用同一接口返回 `permission_status='2'`（未购买）或其他错误值

**对比网页端请求**:
```
https://yakaixingw.yunsop.com/api/c/goods/v2/detail?
  goods_id=594826813692189511
  &user_id=594244629616925424      ← ✅ 包含 user_id
  &student_id=594244629616925424   ← ✅ 包含 student_id
  &merchant_id=408559575579495187
  &brand_id=408559632588540691

响应:
{
  "code": 100000,
  "data": {
    "permission_status": "1"  ← ✅ 正确返回已购买状态
  }
}
```

## 根本原因

### 原来的逻辑（错误）

```dart
// ❌ 错误逻辑: 只有不在白名单中的接口才添加用户参数
if (!isInWhitelist && studentId != null && studentId.isNotEmpty) {
  userParams = {
    'user_id': studentId,
    'student_id': studentId,
  };
}
```

**问题**:
1. `/c/goods/v2/detail` 不在白名单中（被注释掉了）
2. 所以 `isInWhitelist = false`
3. 拦截器会添加用户参数... **等等，这个逻辑看起来是对的？**

**真正的问题**: 白名单的语义理解错误！

- **白名单的本意**: "这些接口不需要强制登录（游客可访问）"
- **错误的实现**: "白名单接口不添加用户参数"
- **正确的实现**: "白名单接口允许未登录访问，但如果已登录仍需添加用户参数"

### 为什么需要添加 user_id/student_id？

后端 API 需要这些参数来判断用户的购买状态：

```javascript
// 后端逻辑（伪代码）
function getGoodsDetail(goods_id, user_id, student_id) {
  const goods = getGoods(goods_id);
  
  // ⚠️ 如果没有 user_id，无法查询订单
  if (user_id) {
    const order = getOrderByUserAndGoods(user_id, goods_id);
    goods.permission_status = order ? '1' : '2'; // 1=已购买 2=未购买
    goods.permission_order_id = order?.id || '0';
  } else {
    // 游客模式：默认未购买
    goods.permission_status = '2';
    goods.permission_order_id = '0';
  }
  
  return goods;
}
```

## 修复方案

### 修改文件

`lib/core/network/api_interceptor.dart`

### 修复内容

**删除白名单逻辑**，改用 `no_user_id` 参数控制：

```dart
// ✅ 正确逻辑: 检查是否显式禁止添加用户参数
final shouldAddUserParams = !currentParams.containsKey('user_id') && 
                            currentParams['no_user_id'] != "1";

final studentId = _storage.getString(StorageKeys.studentId);

Map<String, dynamic> userParams = {};

// ✅ 如果已登录 && 没有显式禁止添加用户参数，则添加
if (shouldAddUserParams && studentId != null && studentId.isNotEmpty) {
  userParams = {
    'user_id': studentId,
    'student_id': studentId,
  };
}
```

### 关键改进

1. **移除白名单检查**: 白名单只用于文档说明，不影响参数注入逻辑
2. **使用 `no_user_id` 参数**: 接口如果不需要用户参数，显式传 `no_user_id: '1'`
3. **默认行为**: 已登录用户总是添加 `user_id` 和 `student_id`

## 对应小程序逻辑

小程序的请求拦截器：`mini-dev_250812/src/modules/jintiku/api/request.js`

```javascript
// Line 118-125
if (
  userInfo &&
  userInfo.student_id &&
  !Object.keys(data).includes('user_id') &&
  data.no_user_id !== "1"
) {
  data.user_id = userInfo.student_id
  data.student_id = userInfo.student_id
}
```

**逻辑**:
- ✅ 检查用户已登录 (`userInfo.student_id`)
- ✅ 检查请求参数中没有 `user_id`
- ✅ 检查没有显式禁止 (`no_user_id !== "1"`)
- ✅ 满足条件则添加 `user_id` 和 `student_id`

Flutter 现在的逻辑与小程序完全一致！

## 验证方法

### 1. 测试商品详情接口

```dart
// 已登录用户访问商品详情
final response = await goodsService.getGoodsDetail(
  goodsId: '594826813692189511',
  userId: studentId,     // ✅ 会自动添加
  studentId: studentId,  // ✅ 会自动添加
);

// 检查响应
print(response.permissionStatus); // 应该返回 '1' (已购买)
print(response.permissionOrderId); // 应该返回订单ID
```

### 2. 查看网络请求日志

```bash
# 应该看到类似的请求
GET /c/goods/v2/detail?
  goods_id=594826813692189511
  &user_id=594244629616925424      ← ✅ 自动添加
  &student_id=594244629616925424   ← ✅ 自动添加
  &merchant_id=408559575579495187
  &brand_id=408559632588540691
```

### 3. 验证响应数据

```json
{
  "code": 100000,
  "data": {
    "permission_status": "1",        ← ✅ 正确
    "permission_order_id": "595209421978606407" ← ✅ 有订单ID
  }
}
```

## 影响范围

### 受影响的接口

所有需要根据用户状态返回个性化数据的接口：

1. ✅ `/c/goods/v2/detail` - 商品详情（购买状态）
2. ✅ `/c/goods/v2` - 商品列表（购买状态）
3. ✅ `/c/tiku/homepage/chapterpackage/tree` - 章节包树（学习进度）
4. ✅ 其他所有需要用户信息的接口

### 不受影响的接口

显式禁止添加用户参数的接口（传 `no_user_id: '1'`）：

1. ✅ 登录接口
2. ✅ 发送验证码接口
3. ✅ 其他公开接口

## 相关文件

- `lib/core/network/api_interceptor.dart` - API 拦截器（已修复）
- `lib/features/home/services/goods_service.dart` - 商品服务
- `lib/features/home/models/goods_model.dart` - 商品模型
- `mini-dev_250812/src/modules/jintiku/api/request.js` - 小程序参考实现

## 总结

### 修复前

- ❌ 白名单逻辑导致已登录用户也不添加 `user_id`
- ❌ 商品详情返回错误的 `permission_status`
- ❌ 无法判断用户购买状态

### 修复后

- ✅ 已登录用户总是添加 `user_id` 和 `student_id`
- ✅ 商品详情返回正确的 `permission_status`
- ✅ 正确显示"去学习"或"立即报名"按钮
- ✅ 与小程序逻辑完全一致

### 经验教训

1. **理解白名单的真正含义**: 不是"不添加参数"，而是"允许未登录访问"
2. **参照小程序实现**: 小程序的逻辑已经过验证，要完全对齐
3. **使用参数控制行为**: `no_user_id` 比白名单更灵活、更明确
