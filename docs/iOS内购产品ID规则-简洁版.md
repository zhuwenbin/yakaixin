# iOS 内购产品ID生成规则变更（简洁版）

**变更日期**: 2025-01-25

---

## 📋 变更内容

### 旧规则（已废弃）
```
产品ID = com.yakaixin.yakaixin.{商品ID}
例如：com.yakaixin.yakaixin.595918548996463431
```

### 新规则（当前使用）✅
```
产品ID = com.yakaixin.yakaixin.{商品价格（去除小数点后的0）}
例如：com.yakaixin.yakaixin.1
```

---

## 🎯 生成规则

1. **基础格式**: `com.yakaixin.yakaixin.{格式化后的价格}`
2. **价格格式化**:
   - 先格式化为 2 位小数
   - 去除末尾的 0 和小数点

### 示例

| 商品价格 | 产品ID |
|---------|--------|
| 1.0 | `com.yakaixin.yakaixin.1` |
| 9.9 | `com.yakaixin.yakaixin.9.9` |
| 19.9 | `com.yakaixin.yakaixin.19.9` |
| 99.0 | `com.yakaixin.yakaixin.99` |
| 298.00 | `com.yakaixin.yakaixin.298` |
| 999.99 | `com.yakaixin.yakaixin.999.99` |

---

## 💻 代码实现

### JavaScript/TypeScript
```javascript
function getProductId(amount) {
  const priceStr = amount.toFixed(2).replace(/\.?0+$/, '');
  return `com.yakaixin.yakaixin.${priceStr}`;
}
```

### Python
```python
import re

def get_product_id(amount):
    price_str = re.sub(r'\.?0+$', '', f'{amount:.2f}')
    return f'com.yakaixin.yakaixin.{price_str}'
```

### Java
```java
public static String getProductId(double amount) {
    String priceStr = String.format("%.2f", amount).replaceAll("\\.?0+$", "");
    return "com.yakaixin.yakaixin." + priceStr;
}
```

---

## ⚠️ 后端需要做的

1. **App Store Connect**: 根据商品价格创建对应的产品ID
2. **验证接口**: 如果后端验证产品ID，需要同步验证逻辑
3. **数据库**: 如果有存储产品ID映射，需要更新

---

## 📞 联系方式

如有疑问，请联系前端团队。

**文档位置**: `docs/iOS内购产品ID生成规则-后端同步.md`（详细版）

