# 图片 URL 前缀说明（与小程序对照）

## 小程序中的两套 OSS

| 环境变量 | 值 | 用途 |
|----------|-----|------|
| **VUE_APP_BASEOSSURL** | `https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/` | 旧 OSS，completepath() |
| **VUE_APP_YAKAIXIN_BASEOSSURL** | `https://yakaixin.oss-cn-beijing.aliyuncs.com/` | 新 OSS，completePathNew() |

- **动态拼接**（API 返回的 path）：小程序用 **completePathNew**，即 **新 OSS**。
- **写死的静态图**：很多仍写死为 `xy-shunshun-pro...`，因历史资源在旧桶、未迁移。

参考：`mini-dev_250812/src/utlis/index.js` Line 612-616，`.env.production` 等。

---

## Flutter 项目中的约定

### 1. 用于拼接的前缀（API 返回相对 path 时）

- **唯一入口**：`ApiConfig.completeImageUrl(path)`
- **前缀**：`ApiConfig.ossBaseUrl` = `https://yakaixin.oss-cn-beijing.aliyuncs.com/`
- **与小程序**：对应 `VUE_APP_YAKAIXIN_BASEOSSURL` / completePathNew()，**正确**。

### 2. 何时用新 OSS 拼接

- 用户头像、商品封面、课程封面、课程介绍图等 **接口返回的相对 path**，一律用 `ApiConfig.completeImageUrl(path)`，会拼到 **yakaixin.oss-cn-beijing.aliyuncs.com**。

### 3. 为何还有旧 OSS 的完整 URL

- **ApiConfig.legacyOssUrl** = `https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/` 仅作**常量引用**，不用于拼接。
- 部分页面里**写死的完整 URL**（如暂无订单图、错题本空状态图、登录页图标等）仍为 `https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/...`，是因为这些图**只在旧 OSS 存在**，未迁到新桶，写死旧 URL 才能加载，与小程序一致。

---

## 总结

| 场景 | 前缀/用法 | 说明 |
|------|-----------|------|
| 接口返回的 path 拼接 | `ApiConfig.completeImageUrl(path)` → 新 OSS | 与小程序 completePathNew 一致 ✅ |
| 已知只在旧 OSS 的静态图 | 写死 `https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/...` | 与小程序多处写死一致 |
| 新 OSS 已有或需统一的图 | 用相对 path + completeImageUrl，或写死新 OSS 完整 URL | 建议优先新 OSS |

**结论**：`https://yakaixin.oss-cn-beijing.aliyuncs.com/` 作为**拼接前缀**是正确的；项目中另一前缀（旧 OSS）仅用于未迁移的静态图完整 URL，并非拼错。
