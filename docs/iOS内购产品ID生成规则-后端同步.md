# iOS 内购产品ID生成规则变更 - 后端同步文档

**更新时间**: 2025-01-25  
**变更类型**: 产品ID生成规则变更  
**影响范围**: iOS 内购产品配置

---

## 📋 变更说明

### 变更前（旧规则）

```
产品ID = bundle_id + 商品ID
例如：com.yakaixin.yakaixin.595918548996463431
```

### 变更后（新规则）✅

```
产品ID = bundle_id + 商品价格（去除小数点后的0）
例如：com.yakaixin.yakaixin.1
```

---

## 🎯 详细规则

### 1. 基础格式

```
产品ID = {bundle_id}.{格式化后的价格}
```

- **bundle_id**: `com.yakaixin.yakaixin`（固定值）
- **价格格式**: 去除小数点后的0

### 2. 价格格式化规则

**步骤**：
1. 将价格格式化为 2 位小数：`amount.toStringAsFixed(2)`
2. 去除末尾的 0 和小数点：`replaceAll(RegExp(r'\.?0+$'), '')`

**正则表达式说明**：
- `\.?` - 可选的小数点
- `0+` - 一个或多个 0
- `$` - 字符串结尾

### 3. 示例对照表

| 商品价格 | 格式化步骤 | 最终产品ID |
|---------|-----------|-----------|
| `1.0` | `1.00` → `1` | `com.yakaixin.yakaixin.1` |
| `1.00` | `1.00` → `1` | `com.yakaixin.yakaixin.1` |
| `9.9` | `9.90` → `9.9` | `com.yakaixin.yakaixin.9.9` |
| `9.90` | `9.90` → `9.9` | `com.yakaixin.yakaixin.9.9` |
| `19.9` | `19.90` → `19.9` | `com.yakaixin.yakaixin.19.9` |
| `99.0` | `99.00` → `99` | `com.yakaixin.yakaixin.99` |
| `99.00` | `99.00` → `99` | `com.yakaixin.yakaixin.99` |
| `298.0` | `298.00` → `298` | `com.yakaixin.yakaixin.298` |
| `298.00` | `298.00` → `298` | `com.yakaixin.yakaixin.298` |
| `999.99` | `999.99` → `999.99` | `com.yakaixin.yakaixin.999.99` |

---

## 💻 代码实现（参考）

### Flutter/Dart 实现

```dart
String getProductId(double amount) {
  const bundleId = 'com.yakaixin.yakaixin';
  
  // 格式化价格：去除小数点后的0
  final priceStr = amount
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'\.?0+$'), '');
  
  return '$bundleId.$priceStr';
}
```

### JavaScript/TypeScript 实现

```javascript
function getProductId(amount) {
  const bundleId = 'com.yakaixin.yakaixin';
  
  // 格式化价格：去除小数点后的0
  const priceStr = amount
    .toFixed(2)
    .replace(/\.?0+$/, '');
  
  return `${bundleId}.${priceStr}`;
}
```

### Python 实现

```python
import re

def get_product_id(amount: float) -> str:
    bundle_id = 'com.yakaixin.yakaixin'
    
    # 格式化价格：去除小数点后的0
    price_str = re.sub(r'\.?0+$', '', f'{amount:.2f}')
    
    return f'{bundle_id}.{price_str}'
```

### Java 实现

```java
public static String getProductId(double amount) {
    String bundleId = "com.yakaixin.yakaixin";
    
    // 格式化价格：去除小数点后的0
    String priceStr = String.format("%.2f", amount)
        .replaceAll("\\.?0+$", "");
    
    return bundleId + "." + priceStr;
}
```

---

## 🔧 后端需要同步的内容

### 1. App Store Connect 产品配置

**需要操作**：
1. 登录 [App Store Connect](https://appstoreconnect.apple.com)
2. 进入"我的 App" → 选择应用
3. 进入"App 内购买项目"
4. 为每个商品创建/更新产品ID

**产品ID对照表**（示例）：

| 商品名称 | 商品价格 | 产品ID |
|---------|---------|--------|
| 一元优惠直播课 | ¥1.00 | `com.yakaixin.yakaixin.1` |
| 测试商品 | ¥9.90 | `com.yakaixin.yakaixin.9.9` |
| 标准课程 | ¥99.00 | `com.yakaixin.yakaixin.99` |
| 高级课程 | ¥298.00 | `com.yakaixin.yakaixin.298` |

### 2. 后端验证接口

**如果后端需要验证产品ID**，需要同步验证逻辑：

```python
# 示例：验证产品ID是否匹配价格
def verify_product_id(product_id: str, expected_price: float) -> bool:
    bundle_id = 'com.yakaixin.yakaixin'
    
    # 生成期望的产品ID
    expected_product_id = get_product_id(expected_price)
    
    # 验证是否匹配
    return product_id == expected_product_id
```

### 3. 数据库/配置表

**如果后端存储了产品ID映射**，需要更新：

**旧表结构**（如果存在）：
```sql
CREATE TABLE iap_products (
    goods_id VARCHAR(50) PRIMARY KEY,
    product_id VARCHAR(100)  -- 旧：com.yakaixin.yakaixin.{goods_id}
);
```

**新表结构**（推荐）：
```sql
CREATE TABLE iap_products (
    goods_id VARCHAR(50) PRIMARY KEY,
    price DECIMAL(10, 2),  -- 商品价格
    product_id VARCHAR(100)  -- 新：com.yakaixin.yakaixin.{price}
);
```

**或者动态生成**（推荐）：
```python
# 不需要存储 product_id，动态生成即可
def get_product_id_by_price(price: float) -> str:
    return get_product_id(price)
```

---

## ⚠️ 注意事项

### 1. 价格精度

- **输入**: 支持任意精度（如 `1.0`, `1.00`, `1`）
- **处理**: 统一格式化为 2 位小数后去除末尾 0
- **结果**: 保证一致性

### 2. 边界情况

| 情况 | 处理结果 |
|------|---------|
| `0.0` | `com.yakaixin.yakaixin.0` |
| `0.00` | `com.yakaixin.yakaixin.0` |
| `0.1` | `com.yakaixin.yakaixin.0.1` |
| `0.10` | `com.yakaixin.yakaixin.0.1` |
| `10.0` | `com.yakaixin.yakaixin.10` |
| `10.00` | `com.yakaixin.yakaixin.10` |

### 3. 兼容性

**旧产品ID**（基于 goods_id）：
- ❌ 不再使用
- ⚠️ 如果 App Store Connect 中还有旧产品，需要删除或禁用

**新产品ID**（基于 price）：
- ✅ 当前使用
- ✅ 需要重新在 App Store Connect 中创建

---

## 📝 迁移清单

### App Store Connect 操作

- [ ] 1. 登录 App Store Connect
- [ ] 2. 进入"App 内购买项目"
- [ ] 3. 删除或禁用所有旧产品ID（基于 goods_id）
- [ ] 4. 根据商品价格创建新产品ID
- [ ] 5. 验证产品ID格式正确

### 后端代码更新

- [ ] 1. 更新产品ID生成逻辑（如果后端有）
- [ ] 2. 更新验证接口（如果后端验证产品ID）
- [ ] 3. 更新数据库/配置表（如果有存储）
- [ ] 4. 测试验证流程

### 测试验证

- [ ] 1. 测试不同价格的产品ID生成
- [ ] 2. 测试边界情况（0.0, 0.1, 整数价格等）
- [ ] 3. 测试购买流程
- [ ] 4. 测试收据验证

---

## 🔗 相关文档

- [iOS 内购验证流程说明](./iOS内购验证流程说明.md)
- [iOS 内购日志说明](./iOS内购日志说明.md)
- [内购流程检查报告](./内购流程检查报告.md)

---

## 📞 联系方式

如有疑问，请联系：
- **前端负责人**: [你的名字]
- **更新日期**: 2025-01-25

---

**更新时间**: 2025-01-25  
**版本**: v2.0（基于价格）  
**状态**: ✅ 已实施，待后端同步

