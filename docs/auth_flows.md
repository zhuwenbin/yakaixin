# 登录 / 退出登录 / 账号被顶 - 流程图与程序操作清单

## 一、核心判断：本地真实登录状态

| 状态       | 判断依据                                              | 说明                                   |
|------------|-------------------------------------------------------|----------------------------------------|
| **已登录** | `StorageKeys.isLoggedIn` = true                       | 本地 bool，在登录/退出时同步更新        |
| **未登录** | `StorageKeys.isLoggedIn` = false 或未设置（null→false）| 游客态                                 |

**StorageKey**：`StorageKeys.isLoggedIn`（存储 key: `auth_is_logged_in`）

**API 拦截器规则**：401 或 code 100002 时，**仅当 `StorageKeys.isLoggedIn` 为 true** 才执行「登录失效」流程；游客（false）直接透出错误，避免重复循环。

**更新时机**：

| 场景             | 操作                  |
|------------------|-----------------------|
| 登录成功         | `setBool(isLoggedIn, true)` |
| 启动恢复（有 token） | `setBool(isLoggedIn, true)` |
| 启动恢复（无 token） | `setBool(isLoggedIn, false)` |
| 主动退出         | `setBool(isLoggedIn, false)` |
| 账号被顶（401/100002） | 先 `setBool(isLoggedIn, false)` 再执行后续流程 |

---

## 二、登录流程

### 流程图

```
用户输入账号/验证码
       │
       ▼
  校验协议勾选
       │
       ▼
  调用登录 API
       │
       ├── 失败 ──► Toast 错误
       │
       ▼ 成功
  _handleLoginSuccess()
       │
       ├─ 1. storage.setString(token)
       ├─ 2. storage.setJson(userInfo)
       ├─ 3. storage.setString(studentId)
       ├─ 4. storage.setJson(majorInfo) + currentMajorId
       ├─ 5. storage.remove(answersList)
       ├─ 6. state.copyWith(isLoggedIn: true, user, currentMajor)
       └─ 7. _refreshAllPagesAfterLogin()
       │
       ▼
  跳转逻辑（login_page addPostFrameCallback）
       │
       ├─ canPop=true  ──► Navigator.pop() 返回上一页
       └─ canPop=false ──► context.go(mainTab)
```

### 程序操作列表（登录成功）

| 步骤 | 操作 | 文件/位置 |
|------|------|-----------|
| 1 | 保存 `token` | `auth_provider._handleLoginSuccess` → `_storage.setString(StorageKeys.token)` |
| 2 | 保存 `userInfo` | `_storage.setJson(StorageKeys.userInfo)` |
| 3 | 保存 `studentId` | `_storage.setString(StorageKeys.studentId)` |
| 4 | 保存 `majorInfo` 和 `currentMajorId` | `_storage.setJson` / `setString` |
| 5 | 清除答题缓存 | `_storage.remove(StorageKeys.answersList)` |
| 6 | 更新 AuthState | `state.copyWith(user, currentMajor, isLoggedIn: true)` |
| 7 | 刷新首页、题库、课程数据 | `_refreshAllPagesAfterLogin` → `loadHomeData`, `loadAllData`, `loadInitialData` |
| 8 | 清除 loginReturnPath | `login_page` 中 `loginReturnPathProvider.state = null` |
| 9 | 初始化支付服务 | `Future.microtask` 中 `paymentService.initialize()` |
| 10 | 返回或跳转 | `Navigator.pop()` 或 `context.go(mainTab)` |

---

## 三、退出登录流程

### 流程图

```
用户点击「退出登录」
       │
       ▼
  AuthNotifier.logout()
       │
       ├─ 1. storage.remove(token, userInfo, studentId, majorInfo, currentMajorId)
       ├─ 2. _ensureGuestDefaultMajor()
       ├─ 3. state = AuthState(currentMajor: DefaultMajor.model)
       ├─ 4. ToastUtil.show('已退出登录')
       └─ 5. _refreshAllPagesAfterLogout()
       │
       ▼
  loadHomeData / loadAllData / loadInitialData
  （刷新为游客态数据）
```

### 程序操作列表（主动退出登录）

| 步骤 | 操作 | 文件/位置 |
|------|------|-----------|
| 1 | 清除 token | `auth_provider.logout` → `_storage.remove(StorageKeys.token)` |
| 2 | 清除 userInfo | `_storage.remove(StorageKeys.userInfo)` |
| 3 | 清除 studentId | `_storage.remove(StorageKeys.studentId)` |
| 4 | 清除 majorInfo、currentMajorId | `_storage.remove(StorageKeys.majorInfo/currentMajorId)` |
| 5 | 设置游客默认专业 | `_ensureGuestDefaultMajor()` |
| 6 | 重置 AuthState | `state = AuthState(currentMajor: DefaultMajor.model)` |
| 7 | Toast 提示 | `ToastUtil.show('已退出登录')` |
| 8 | 刷新首页、题库、课程 | `_refreshAllPagesAfterLogout` → `loadHomeData`, `loadAllData`, `loadInitialData` |

---

## 四、账号被其他设备登录（单点登录失效）

### 触发条件

- API 返回 **code 100002** 或 **HTTP 401**
- 且本地 **存在 token**（真实登录状态）

若本地无 token（游客），100002/401 不会触发登录失效流程，避免重复循环。

### 流程图

```
API 返回 100002 或 401
       │
       ▼
ApiInterceptor 检查本地 token
       │
       ├─ 无 token ──► 不处理，仅 reject 错误，由页面处理
       │
       ▼ 有 token
  _handleLoginExpiredIfHadToken()
       │
       ├─ 1. storage.remove(token, userInfo, studentId)
       └─ 2. onLoginExpired()
       │
       ▼
main.dart override 的 onLoginExpired
       │
       ├─ 1. authProvider.logoutDueToSessionExpired()
       │       ├─ storage.remove(token, userInfo, studentId, majorInfo, currentMajorId)
       │       ├─ _ensureGuestDefaultMajor()
       │       ├─ state = AuthState(currentMajor: DefaultMajor.model)
       │       ├─ ToastUtil.show('登录已失效，请重新登录')
       │       └─ _refreshAllPagesAfterLogout()
       │
       └─ 2. router.go(loginCenter)
```

### 程序操作列表（账号被顶）

| 步骤 | 操作 | 文件/位置 |
|------|------|-----------|
| 1 | 判断本地有 token | `api_interceptor._handleLoginExpiredIfHadToken` |
| 2 | 清除 token、userInfo、studentId | ApiInterceptor 中 `_storage.remove` |
| 3 | 回调 onLoginExpired | `_onLoginExpired?.call()` |
| 4 | 调用 logoutDueToSessionExpired | main.dart `dioClientProvider` override |
| 5 | 完整清理 storage | `auth_provider.logoutDueToSessionExpired` |
| 6 | 设置游客默认专业 | `_ensureGuestDefaultMajor()` |
| 7 | 重置 AuthState | `state = AuthState(currentMajor: DefaultMajor.model)` |
| 8 | Toast 提示 | `ToastUtil.show('登录已失效，请重新登录')` |
| 9 | 刷新页面数据 | `_refreshAllPagesAfterLogout` |
| 10 | 跳转登录页 | `router.go(AppRoutes.loginCenter)` |

---

## 五、状态变化汇总

| 场景           | 操作入口                 | Storage 变化                           | AuthState 变化            |
|----------------|--------------------------|----------------------------------------|---------------------------|
| **登录成功**   | loginWithSms / loginWithPhone | 写入 token, userInfo, studentId, majorInfo | isLoggedIn: true, 有 user |
| **主动退出**   | logout()                 | 删除 token 等，保留游客专业            | isLoggedIn: false         |
| **账号被顶**   | 401/100002 + 有 token    | 同主动退出                             | isLoggedIn: false         |
| **游客 100002**| 100002 + 无 token        | 不变                                   | 不变，不进入登录失效流程  |
