# 医考SaaS小程序 - API接口文档

> 基于小程序源码提取 + Swagger API文档 (https://yakaixin.yunsop.com/swagger/doc.json)
> 
> 生成时间: 2025-11-23
> 
> **系统架构**: uni-app + Vue2 + Vuex

---

## 📋 功能清单

### ① 核心功能模块 (4个)
- **F1. 用户认证** - 登录/注册/选专业
- **F2. 题库练习** - 章节练习/真题闯关/智能测评/考点词条
- **F3. 模拟考试** - 模考大赛/科目模考/试卷练习
- **F4. 学习中心** - 直播/录播/课程/资料

### ② 辅助功能模块 (5个)
- **F5. 商品订单** - 商品列表/详情/订单/支付
- **F6. 我的中心** - 个人信息/设置/报告
- **F7. 错题本** - 错题列表/错题详情
- **F8. 收藏管理** - 试题收藏/考点收藏
- **F9. H5活动** - 兑换码/APP下载

---

## 📝 功能与页面对应表

### F1. 用户认证模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P1-1 | 登录中心 | `/loginCenter/index` | 微信授权登录 |
| P1-2 | H5登录 | `/loginCenter/h5` | 手机号验证码登录 |
| P1-3 | 选择专业 | `/major/index` | 选择学习专业 |

### F2. 题库练习模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P2-1 | 首页(题库) | `/index/index` | 题库首页,章节练习入口 |
| P2-2 | 章节练习 | `/chapterExercise/index` | 章节列表 |
| P2-3 | 章节详情 | `/chapterExercise/detail` | 章节题目列表 |
| P2-4 | 做题页 | `/makeQuestion/makeQuestion` | 做题界面 |
| P2-5 | 查看解析 | `/makeQuestion/lookAnalysisQuestion` | 题目解析 |
| P2-6 | 成绩报告 | `/statistics/scoreReporting` | 练习成绩 |
| P2-7 | 真题闯关 | `/questionChallenge/index` | 闯关入口 |
| P2-8 | 关卡列表 | `/questionChallenge/levelList` | 关卡选择 |
| P2-9 | 闯关练习 | `/questionChallenge/practise` | 闯关做题 |
| P2-10 | 闯关报告 | `/questionChallenge/report` | 闯关成绩 |
| P2-11 | 智能测评 | `/intelligentEvaluation/index` | 测评入口 |
| P2-12 | 测评练习 | `/intelligentEvaluation/practise` | 测评做题 |
| P2-13 | 测评报告 | `/intelligentEvaluation/report` | 测评成绩 |
| P2-14 | 考点词条 | `/examEntry/index` | 考点列表 |
| P2-15 | 词条详情 | `/examEntry/entry` | 考点内容 |
| P2-16 | 考点口诀 | `/examEntry/examKnack` | 口诀列表 |

### F3. 模拟考试模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P3-1 | 全部模考 | `/modelExaminationCompetition/index` | 模考列表 |
| P3-2 | 模考详情 | `/modelExaminationCompetition/examInfo` | 模考信息 |
| P3-3 | 考试须知 | `/examination/notice` | 考前须知 |
| P3-4 | 考试中 | `/examination/examinationing` | 考试答题 |
| P3-5 | 交卷成功 | `/examination/submitSuccess` | 交卷页 |
| P3-6 | 试卷详情 | `/test/exam` | 历史试卷 |
| P3-7 | 成绩报告 | `/test/examScoreReporting` | 考试成绩 |
| P3-8 | 排行榜 | `/test/rankList` | 成绩排名 |

### F4. 学习中心模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P4-1 | 课程首页 | `/study/index` | 学习日历/课程列表 |
| P4-2 | 我的课程 | `/study/myCourse/index` | 已购课程 |
| P4-3 | 课程详情 | `/study/detail/index` | 课程信息 |
| P4-4 | 直播课程 | `/study/live/index` | 直播观看 |
| P4-5 | 视频播放 | `/study/video/index` | 录播观看 |
| P4-6 | 资料下载 | `/study/dataDownload/index` | 讲义下载 |
| P4-7 | PDF查看 | `/study/pdf/index` | PDF预览 |

### F5. 商品订单模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P5-1 | 商品详情 | `/test/detail` | 题库/试卷商品详情 |
| P5-2 | 我的订单 | `/test/order` | 订单列表 |
| P5-3 | 支付成功 | `/order/paySuccess` | 支付结果 |

### F6. 我的中心模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P6-1 | 个人中心 | `/my/index` | 用户信息/菜单 |
| P6-2 | 修改资料 | `/my/person` | 编辑个人信息 |
| P6-3 | 报告中心 | `/userInfo/report` | 历史报告 |
| P6-4 | 设置 | `/userInfo/set` | 系统设置 |

### F7. 错题本模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P7-1 | 错题本 | `/wrongQuestionBook/index` | 错题列表 |
| P7-2 | 错题详情 | `/wrongQuestionBook/wrongQuestionDetails` | 错题解析 |

### F8. 收藏管理模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P8-1 | 试题收藏 | `/collect/index` | 收藏题目列表 |
| P8-2 | 试题详情 | `/collect/detail` | 收藏题目详情 |
| P8-3 | 考点收藏 | `/examEntry/examEntryCollect` | 收藏考点列表 |

### F9. H5活动模块

| 编号 | 页面名称 | 路径 | 功能说明 |
|------|----------|------|----------|
| P9-1 | 兑换码领取 | `/h5Active/code-receive` | 兑换码兑换 |
| P9-2 | APP下载 | `/h5Active/app-upload` | APP下载页 |
| P9-3 | 打开APP | `/h5Active/open-app` | 跳转APP |

---

## 🔍 页面接口速查表

### P1. 用户认证模块接口

#### P1-1 登录中心 (`/loginCenter/index`)
**调用接口**:
- `POST /c/student/openid` - 获取OpenID
- `POST /c/student/login` - 微信登录
- `GET /c/student/mobile` - 获取手机号

#### P1-2 H5登录 (`/loginCenter/h5`)
**调用接口**:
- `POST /b/base/sms/sendcode` - 发送验证码
- `POST /c/student/smslogin` - 验证码登录

**数据Model**:
```javascript
// login-h5.vue:155-161
sendCode({
  phone: this.form.phone,
  scene: 2  // 2=登录
})
```

#### P1-3 选择专业 (`/major/index`)
**调用接口**:
- `GET /c/teaching/mapping/tree` - 获取专业列表
- `PUT /c/student` - 选择专业

---

### P2. 题库练习模块接口

#### P2-1 首页(题库) (`/index/index`)
**调用接口**:
- `GET /c/tiku/bistatistic/indexdata` - 首页统计
- `GET /c/goods/v2` - 获取商品列表 (type=8,10,18)
- `GET /c/tiku/homepage/recommend/chapterpackage` - 推荐章节
- `GET /c/tiku/last/study/progress` - 上次练习信息
- `GET /c/tiku/exam/learning/data` - 打卡学习数据
- `POST /c/tiku/exam/checkin/data` - 学习打卡

**数据Model** (index.vue:200-286):
```javascript
// 商品列表处理
getGoods({ 
  shelf_platform_id,
  professional_id: major_id,
  type: 18  // 8=试卷, 10=模考, 18=题库
}).then(res => {
  this.goodsList18 = res.data.list
  // 筛选首页推荐且未购买
  this.recommendList = this.recommendList.concat(
    res.data.list.filter(
      e => e.is_homepage_recommend == 1 && e.permission_status == '2'
    )
  )
})
```

#### P2-2 章节练习 (`/chapterExercise/index`)
**调用接口**:
- `GET /c/tiku/homepage/chapterpackage/tree` - 获取章节树
- `GET /c/tiku/chapter/list` - 获取章节列表

**数据Model** (chapterExercise/index.vue:68-93):
```javascript
// 章节树处理
chapterpackageTree({
  professional_id: this.query.professional_id,
  goods_id: this.query.goods_id
}).then(data => {
  let section_info = this.filter(data?.data?.section_info || [])
  // 过滤零题目
  section_info = section_info.filter(e => e.question_number != '0')
  // 计算正确率
  this.addCorrectRate(section_info)
  this.lists = section_info
})

// 正确率计算
addCorrectRate(tree) {
  tree.forEach(item => {
    const doNum = parseInt(item.do_question_num || '0')
    const correctNum = parseInt(item.correct_question_num || '0')
    item.correctRate = doNum > 0 
      ? (correctNum / doNum * 100).toFixed(1) 
      : '0.0'
  })
}
```

#### P2-4 做题页 (`/makeQuestion/makeQuestion`)
**调用接口**:
- `GET /c/tiku/question/getquestionlist` - 获取题目列表
- `GET /c/tiku/chapter/getquestionlist` - 章节出题
- `POST /c/tiku/question/answer` - 交卷

#### P2-6 成绩报告 (`/statistics/scoreReporting`)
**调用接口**:
- `GET /c/tiku/servicehall/scorereporting` - 获取成绩报告
- `GET /c/tiku/paper/ranking` - 获取排名

---

### P3. 模拟考试模块接口

#### P3-1 全部模考 (`/modelExaminationCompetition/index`)
**调用接口**:
- `GET /c/tiku/mockexam/allexam` - 获取所有模考
- `GET /c/tiku/mockexam/getstudentexaminfo` - 学员考试信息

#### P3-2 模考详情 (`/modelExaminationCompetition/examInfo`)
**调用接口**:
- `GET /c/tiku/mockexam/examinfo` - 模考详情
- `POST /c/tiku/mockexam/signup` - 模考报名
- `POST /c/tiku/mockexam/makeup` - 模考补考

#### P3-4 考试中 (`/examination/examinationing`)
**调用接口**:
- `GET /c/tiku/mockexam/info` - 考试信息
- `POST /c/tiku/question/answer` - 考试交卷
- `GET /c/tiku/session/delayeeventlogs` - 查询延时操作
- `GET /c/tiku/session/lockscreeneventlogs` - 查询锁屏操作
- `GET /c/tiku/session/pauseeventlogs` - 查询暂停操作
- `GET /c/tiku/session/smseventlogs` - 获取消息
- `GET /c/tiku/session/submiteventlogs` - 查询强制交卷
- `POST /c/tiku/session/lastid` - 设置最后题目ID

---

### P4. 学习中心模块接口

#### P4-1 课程首页 (`/study/index`)
**调用接口**:
- `GET /c/study/learning/calendar` - 获取学习日历
- `GET /c/study/learning/lesson` - 获取日期课节
- `GET /c/study/learning/plan` - 获取日期课程

#### P4-3 课程详情 (`/study/detail/index`)
**调用接口**:
- `GET /c/study/learning/series` - 获取课程详情
- `GET /c/study/learning/series/goods` - 获取课程详情课节
- `GET /c/study/learning/series/recent` - 最近学习记录

#### P4-4 直播课程 (`/study/live/index`)
**调用接口**:
- `GET /c/study/learning/live` - 获取直播地址
- `POST /c/live/data/add` - 添加学习数据

#### P4-5 视频播放 (`/study/video/index`)
**调用接口**:
- `GET /c/study/learning/playback` - 获取录播路径
- `POST /c/live/data/add` - 添加学习数据

#### P4-6 资料下载 (`/study/dataDownload/index`)
**调用接口**:
- `GET /c/study/learning/resource/handout` - 获取讲义

---

### P5. 商品订单模块接口

#### P5-1 商品详情 (`/test/detail`)
**调用接口**:
- `GET /c/goods/v2/detail` - 获取商品详情
- `GET /c/tiku/homepage/chapterpackage/tree` - 章节树 (type=18)
- `POST /c/order/v2` - 创建订单
- `GET /c/config/finance/account` - 支付方式列表
- `GET /c/config/finance/account/detail` - 支付方式详情
- `POST /c/pay/wechatpay/jsapi` - 微信支付

**已完成Model定义** (见前面章节)

#### P5-2 我的订单 (`/test/order`)
**调用接口**:
- `GET /c/order/my/list` - 订单列表

---

### P6. 我的中心模块接口

#### P6-1 个人中心 (`/my/index`)
**调用接口**:
- `GET /c/student/platform/menu` - 获取平台菜单

---

### P7. 错题本模块接口

#### P7-1 错题本 (`/wrongQuestionBook/index`)
**调用接口**:
- `GET /c/tiku/question/practice/collect/list` - 错题列表

---

### P8. 收藏管理模块接口

#### P8-1 试题收藏 (`/collect/index`)
**调用接口**:
- `GET /c/tiku/question/practice/collect/list` - 收藏列表

---

### P9. H5活动模块接口

#### P9-1 兑换码领取 (`/h5Active/code-receive`)
**调用接口**:
- `GET /c/tiku/exchange/code/active` - 获取兑换码详情
- `POST /c/tiku/exchange/code/receive` - 兑换码兑换
- `POST /c/tiku/exchange/code/share` - 分享
- `GET /c/tiku/exchange/code/active/codelist` - 获取code段
- `POST /c/base/sms/sendcode` - 发送验证码 (H5版)

---

## 1. 用户认证模块

### 1.1 微信小程序登录

**接口地址**: `POST /c/student/login`

**功能说明**: 微信小程序用户登录,获取token

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:21-27
export const Login = function (data = {}) {
  return http({
    url: '/c/student/login',
    method: 'POST',
    data
  })
}
```

**请求参数**:
```json
{
  "wxopenid": "微信openid",
  "account": "手机号(可选)",
  "password": "密码(可选)",
  "merchant_id": "436047240159563069",
  "brand_id": "508925829265162766",
  "channel_id": "436047240159563069",
  "major_id": "专业ID(可选)"
}
```

**Model定义**: `WechatLoginResponse`
```dart
class WechatLoginResponse {
  final String token;
  final String studentId;
  final String nickname;
  final String? avatar;
  final String? mobile;
  final List<MerchantInfo> merchant;
  final EmployeeInfo? employee;
}

class MerchantInfo {
  final String merchantId;
  final String brandId;
}

class EmployeeInfo {
  final String id;
  final String name;
}
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "student_id": "555343665594113147",
    "nickname": "牙开心8000",
    "avatar": "https://thirdwx.qlogo.cn/...",
    "mobile": "13800138000",
    "account": "13800138000",
    "wxopenid": "oXxXx1234567890",
    "merchant": [
      {
        "merchant_id": "436047240159563069",
        "brand_id": "508925829265162766"
      }
    ],
    "employee": {
      "id": "508948528815416786",
      "name": "业务员姓名"
    }
  }
}
```

**字段说明**:
- `code`: 100000表示成功,0也表示成功(兼容)
- `msg`: 消息数组,失败时包含错误信息
- `student_id`: 学员ID,后续请求需要使用
- `merchant`: 商户品牌信息数组
- `employee`: 推广员工信息

---

### 1.2 验证码登录

**接口地址**: `POST /c/student/smslogin`

**功能说明**: 手机号+验证码登录

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:29-35
export const smslogin = function (data = {}) {
  return http({
    url: '/c/student/smslogin',
    method: 'POST',
    data
  })
}
```

**请求参数**:
```json
{
  "phone": "13800138000",
  "code": "123456",
  "merchant_id": "436047240159563069",
  "brand_id": "508925829265162766",
  "channel_id": "436047240159563069",
  "extendu_id": "508948528815416786",
  "need_employee_info": 1
}
```

**使用场景** (login-h5.vue:166-175):
```javascript
this.$store.dispatch('jintiku/CODELOGIN', {
  phone: this.form.phone,
  code: this.form.code,
  brand_id,
  merchant_id,
  channel_id: process.env.VUE_APP_CHANNELID,
  extendu_id: process.env.VUE_APP_EXTENDUID,
  need_employee_info: 1
})
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["登录成功"],
  "data": {
    "token": "eyJhbGciOiJIUzI1...",
    "student_id": "555343665594113147",
    "nickname": "张三",
    "avatar": "https://...",
    "mobile": "13800138000",
    "merchant": [{"merchant_id": "xxx", "brand_id": "xxx"}]
  }
}
```

---

### 1.3 获取OpenID

**接口地址**: `GET /c/student/openid`

**功能说明**: 通过code获取微信openid

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:13-19
export const getCode = function (data = {}) {
  return http({
    url: '/c/student/openid',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?code=微信登录code
```

---

### 1.4 切换品牌获取Token

**接口地址**: `POST /c/student/switchmerchantbrand`

**功能说明**: 切换商户品牌,获取新token

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:36-42
export const getToken = function (data = {}) {
  return http({
    url: '/c/student/switchmerchantbrand',
    method: 'POST',
    data
  })
}
```

---

### 1.5 发送验证码

**接口地址**: `POST /b/base/sms/sendcode`

**功能说明**: 发送手机验证码(登录/注册场景)

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:325-331
export const getSendcode = function (data = {}) {
  return http({
    url: '/b/base/sms/sendcode',
    method: 'POST',
    data
  })
}
```

**请求参数**:
```json
{
  "account": "13800138000",
  "app_id": "wxf787cf63760d80a0",
  "merchant_id": "436047240159563069",
  "brand_id": "508925829265162766",
  "channel_id": "436047240159563069",
  "extendu_id": "508948528815416786",
  "scene": "login"
}
```

**参数说明**:
- `account`: 手机号(注意不是phone字段)
- `scene`: 验证码场景 - `"login"` 登录, `"register"` 注册, `"forget"` 找回密码

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["发送成功"]
}
```

**备注**: H5活动页面使用 `/c/base/sms/sendcode` 接口,参数为 `{phone, scene: 2}`

---

### 1.6 获取手机号

**接口地址**: `GET /c/student/mobile`

**功能说明**: 获取微信绑定的手机号

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:291-297
export const getPhone = function (data = {}) {
  return http({
    url: '/c/student/mobile',
    method: 'GET',
    data
  })
}
```

---

## 2. 首页模块

### 2.1 获取平台菜单

**接口地址**: `GET /c/student/platform/menu`

**功能说明**: 获取首页菜单配置(题库/直播/网课等)

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:5-11
export const getMenus = function (data = {}) {
  return http({
    url: '/c/student/platform/menu',
    method: 'GET',
    data
  })
}
```

**响应示例**:
```json
{
  "code": 0,
  "data": [
    {
      "id": "1",
      "name": "题库",
      "icon": "https://...",
      "type": "tiku"
    },
    {
      "id": "2",
      "name": "直播",
      "icon": "https://...",
      "type": "live"
    }
  ]
}
```

---

### 2.2 首页推荐章节

**接口地址**: `GET /c/tiku/homepage/recommend/chapterpackage`

**功能说明**: C端首页推荐章节列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:929-936
export const chapterpackage = (data = {}) => {
  return http({
    url: '/c/tiku/homepage/recommend/chapterpackage',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?professional_id=专业ID
```

**响应示例**:
```json
{
  "code": 0,
  "data": [
    {
      "id": "123",
      "name": "章节包名称",
      "chapter_num": 10,
      "question_num": 500,
      "price": 99.00
    }
  ]
}
```

---

### 2.3 首页统计数据

**接口地址**: `GET /c/tiku/bistatistic/indexdata`

**功能说明**: 首页统计数据(学习天数/做题数等)

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:332-341
export const index = {
  static(data) {
    return http({
      url: '/c/tiku/bistatistic/indexdata',
      method: 'GET',
      data
    })
  }
}
```

---

### 2.4 获取专业列表

**接口地址**: `GET /c/teaching/mapping/tree`

**功能说明**: 获取所有专业分类树

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:299-308
export const getMajor = function (data = {}) {
  return http({
    url: '/c/teaching/mapping/tree',
    method: 'GET',
    data: {
      ...data,
      is_standard: 0
    }
  })
}
```

**响应示例**:
```json
{
  "code": 0,
  "data": [
    {
      "id": "1",
      "name": "临床医学",
      "children": [
        {
          "id": "11",
          "name": "内科学"
        }
      ]
    }
  ]
}
```

---

### 2.5 选择专业

**接口地址**: `PUT /c/student`

**功能说明**: 用户选择/切换专业

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:310-323
export const checkMajor = function (data = {}) {
  return http({
    url: '/c/student',
    method: 'PUT',
    data
  }).then(res => {
    setTimeout(() => {
      setTimeInfo({ chapter_number: '3000' }).then(data => {})
    }, 1000)
    return res
  })
}
```

**请求参数**:
```json
{
  "professional_id": "专业ID"
}
```

---

## 3. 学习中心模块

### 3.1 获取学习日历

**接口地址**: `GET /c/study/learning/calendar`

**功能说明**: 获取用户学习日历(打卡记录)

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:46-52
export const calendar = function (data = {}) {
  return http({
    url: '/c/study/learning/calendar',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?year=2024&month=11
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "calendar": [
      {
        "date": "2024-11-01",
        "is_checkin": 1,
        "study_duration": 3600,
        "question_count": 50,
        "correct_count": 42
      },
      {
        "date": "2024-11-02",
        "is_checkin": 1,
        "study_duration": 5400,
        "question_count": 80,
        "correct_count": 65
      }
    ],
    "total_days": 30,
    "checkin_days": 25,
    "continuous_days": 7
  }
}
```

**字段说明**:
- `is_checkin`: 是否打卡 0=否 1=是
- `study_duration`: 学习时长(秒)
- `question_count`: 当天做题数
- `correct_count`: 当天正确数
- `continuous_days`: 连续打卡天数

---

### 3.2 获取日期课节

**接口地址**: `GET /c/study/learning/lesson`

**功能说明**: 获取指定日期的课节列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:55-61
export const dateLessons = function (data = {}) {
  return http({
    url: '/c/study/learning/lesson',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?date=2024-11-23
```

---

### 3.3 获取日期课程

**接口地址**: `GET /c/study/learning/plan`

**功能说明**: 获取学习计划

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:64-70
export const dateCourse = function (data = {}) {
  return http({
    url: '/c/study/learning/plan',
    method: 'GET',
    data
  })
}
```

---

### 3.4 获取直播地址

**接口地址**: `GET /c/study/learning/live`

**功能说明**: 获取直播课程播放地址

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:97-103
export const liveUrl = function (data = {}) {
  return http({
    url: '/c/study/learning/live',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?lesson_id=课节ID
```

**响应示例**:
```json
{
  "code": 0,
  "data": {
    "play_url": "https://live.example.com/...",
    "start_time": "2024-11-23 19:00:00",
    "end_time": "2024-11-23 21:00:00"
  }
}
```

---

### 3.5 获取录播地址

**接口地址**: `GET /c/study/learning/playback`

**功能说明**: 获取录播课程播放地址

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:151-157
export const playbackPath = function (data = {}) {
  return http({
    url: '/c/study/learning/playback',
    method: 'GET',
    data
  })
}
```

---

### 3.6 获取讲义

**接口地址**: `GET /c/study/learning/resource/handout`

**功能说明**: 获取课程讲义资源

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:106-112
export const getHandout = function (data = {}) {
  return http({
    url: '/c/study/learning/resource/handout',
    method: 'GET',
    data
  })
}
```

---

### 3.7 获取课程详情

**接口地址**: `GET /c/study/learning/series`

**功能说明**: 获取课程系列详情

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:115-121
export const courseDetail = function (data = {}) {
  return http({
    url: '/c/study/learning/series',
    method: 'GET',
    data
  })
}
```

---

### 3.8 获取课程详情课节

**接口地址**: `GET /c/study/learning/series/goods`

**功能说明**: 获取课程下的所有课节

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:124-130
export const courseDetailLessons = function (data = {}) {
  return http({
    url: '/c/study/learning/series/goods',
    method: 'GET',
    data
  })
}
```

---

### 3.9 添加学习数据

**接口地址**: `POST /c/live/data/add`

**功能说明**: 记录用户学习数据(时长/进度)

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:73-82
export const addStudyData = function (data = {}) {
  return http({
    url: '/c/live/data/add',
    method: 'POST',
    header: {
      'Content-Type': 'application/json'
    },
    data
  })
}
```

**请求参数**:
```json
{
  "lesson_id": "课节ID",
  "duration": 3600,
  "progress": 80
}
```

---

### 3.10 打卡接口

**接口地址**: `POST /c/tiku/exam/checkin/data`

**功能说明**: 学习打卡

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1025-1034
export const examCheckinData = function (data = {}) {
  return http({
    url: '/c/tiku/exam/checkin/data', 
    method: 'POST',
    data,
    header: {
      'Content-Type': 'application/json'
    }
  })
}
```

---

### 3.11 打卡信息

**接口地址**: `GET /c/tiku/exam/learning/data`

**功能说明**: 获取打卡学习数据

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1037-1043
export const examLearningData = function (data = {}) {
  return http({
    url: '/c/tiku/exam/learning/data',
    method: 'GET',
    data
  })
}
```

---

## 4. 题库模块

### 4.1 获取题目列表

**接口地址**: `GET /c/tiku/question/getquestionlist`

**功能说明**: 获取练习题目列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:183-189
export const getQuestionList = function (data = {}) {
  return http({
    url: '/c/tiku/question/getquestionlist',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?practice_id=练习ID&page=1&size=20
```

**响应示例**:
```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": "473024261183771326",
        "type": "1",
        "type_name": "A1",
        "stem_list": [
          {
            "content": "<p>题干内容</p>",
            "option": "[\"选项A\", \"选项B\", \"选项C\", \"选项D\"]",
            "answer": "[\"1\"]"
          }
        ],
        "parse": "<b>解析</b>"
      }
    ],
    "total": 100
  }
}
```

---

### 4.2 提交答案(交卷)

**接口地址**: `POST /c/tiku/question/answer`

**功能说明**: 提交练习答案或考试交卷

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:210-219
export const postAnswer = function (data = {}) {
  return http({
    url: '/c/tiku/question/answer',
    method: 'POST',
    data,
    header: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  })
}
```

**请求参数**:
```json
{
  "practice_id": "练习ID",
  "answers": [
    {
      "question_id": "题目ID",
      "user_option": "[\"1\"]",
      "duration": 30
    }
  ]
}
```

---

### 4.3 获取成绩报告

**接口地址**: `GET /c/tiku/servicehall/scorereporting`

**功能说明**: 获取练习成绩报告

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:192-198
export const getScorereporting = function (data = {}) {
  return http({
    url: '/c/tiku/servicehall/scorereporting',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?practice_id=练习ID
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["提交成功"],
  "data": {
    "score": 85,
    "total_question": 100,
    "correct_num": 85,
    "error_num": 15,
    "accuracy": "85.00",
    "duration": 3600,
    "ranking": 120,
    "beat_rate": "75.5",
    "practice_id": "479966355437655235",
    "error_questions": [
      {
        "question_id": "473024261183771326",
        "user_answer": "[\"2\"]",
        "correct_answer": "[\"1\"]"
      }
    ]
  }
}
```

**字段说明**:
- `score`: 得分
- `accuracy`: 正确率(百分比)
- `duration`: 用时(秒)
- `ranking`: 排名
- `beat_rate`: 击败率(百分比)
- `error_questions`: 错题列表

---

### 4.4 获取排名

**接口地址**: `GET /c/tiku/paper/ranking`

**功能说明**: 获取成绩排名

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:201-207
export const getRanking = function (data = {}) {
  return http({
    url: '/c/tiku/paper/ranking',
    method: 'GET',
    data
  })
}
```

---

### 4.5 获取上次练习信息

**接口地址**: `GET /c/tiku/last/study/progress`

**功能说明**: 获取上次练习的进度

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:795-801
export const getPreInfo = (data = {}) => {
  return http({
    url: '/c/tiku/last/study/progress',
    method: 'GET',
    data
  })
}
```

---

### 4.6 收藏列表

**接口地址**: `GET /c/tiku/question/practice/collect/list`

**功能说明**: 获取收藏题目列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/collect.js:6-12
export const getCollectlist = function (data = {}) {
  return http({
    url: '/c/tiku/question/practice/collect/list',
    method: 'GET',
    data
  })
}
```

---

## 5. 章节练习模块

### 5.1 获取章节列表

**接口地址**: `GET /c/tiku/chapter/list`

**功能说明**: 获取专业下的章节列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/chapter.js:13-19
export const getChapterlist = function (data = {}) {
  return http({
    url: '/c/tiku/chapter/list',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?professional_id=专业ID
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": [
    {
      "id": "437657998052172130",
      "name": "第一章 内科学基础",
      "question_number": "500",
      "parent_id": "0",
      "sort": 1,
      "children": [
        {
          "id": "437658088934351202",
          "name": "第一节 呼吸系统",
          "question_number": "100",
          "parent_id": "437657998052172130",
          "sort": 1,
          "children": []
        }
      ]
    }
  ]
}
```

**字段说明**:
- `question_number`: 题目数量(String类型)
- `parent_id`: 父级ID 0=顶级
- `sort`: 排序
- `children`: 子章节数组

---

### 5.2 章节练习包树

**接口地址**: `GET /c/tiku/homepage/chapterpackage/tree`

**功能说明**: 获取章节练习包商品树

**小程序调用**:
```javascript
// src/modules/jintiku/api/chapter.js:21-27
export const chapterpackageTree = function (data = {}) {
  return http({
    url: '/c/tiku/homepage/chapterpackage/tree',
    method: 'GET',
    data
  })
}
```

---

### 5.3 章节出题

**接口地址**: `GET /c/tiku/chapter/getquestionlist`

**功能说明**: 获取章节练习题目

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:803-809
export const getquestionlistchap = (data = {}) => {
  return http({
    url: '/c/tiku/chapter/getquestionlist',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?chapter_id=章节ID&question_num=50
```

---

## 6. 模考模块

### 6.1 获取所有考试

**接口地址**: `GET /c/tiku/mockexam/allexam`

**功能说明**: 获取所有模考列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:779-785
export const getAllExam = (data = {}) => {
  return http({
    url: '/c/tiku/mockexam/allexam',
    method: 'GET',
    data
  })
}
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "list": [
      {
        "id": "479966355437655235",
        "exam_name": "2024年口腔执业医师模考大赛第一场",
        "start_time": "2024-11-25 09:00:00",
        "end_time": "2024-11-25 11:00:00",
        "exam_status": "1",
        "is_signup": 0,
        "signup_start_time": "2024-11-20 00:00:00",
        "signup_end_time": "2024-11-24 23:59:59",
        "exam_duration": 120,
        "question_num": 100,
        "total_score": 100,
        "pass_score": 60
      }
    ]
  }
}
```

**字段说明**:
- `exam_status`: 考试状态 0=未开始 1=报名中 2=进行中 3=已结束
- `is_signup`: 是否已报名 0=否 1=是
- `exam_duration`: 考试时长(分钟)

---

### 6.2 获取模考详情

**接口地址**: `GET /c/tiku/mockexam/examinfo`

**功能说明**: 获取模考详细信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:939-945
export const getExaminfoDetail = (data = {}) => {
  return http({
    url: '/c/tiku/mockexam/examinfo',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?exam_id=考试ID
```

---

### 6.3 模考报名

**接口地址**: `POST /c/tiku/mockexam/signup`

**功能说明**: 报名参加模考

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:947-953
export const mockexamSignup = (data = {}) => {
  return http({
    url: '/c/tiku/mockexam/signup',
    method: 'POST',
    data
  })
}
```

**请求参数**:
```json
{
  "exam_id": "考试ID"
}
```

---

### 6.4 模考补考

**接口地址**: `POST /c/tiku/mockexam/makeup`

**功能说明**: 申请模考补考

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:955-961
export const makeupSignup = (data = {}) => {
  return http({
    url: '/c/tiku/mockexam/makeup',
    method: 'POST',
    data
  })
}
```

---

### 6.5 获取学员考试信息

**接口地址**: `GET /c/tiku/mockexam/getstudentexaminfo`

**功能说明**: 获取学员考试状态和信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:727-733
export const getstudentexaminfo = (data = {}) => {
  return http({
    url: '/c/tiku/mockexam/getstudentexaminfo',
    method: 'GET',
    data
  })
}
```

---

### 6.6 考试成绩报告

**接口地址**: `GET /c/tiku/exam/scorereporting`

**功能说明**: 获取考试成绩报告

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:820-826
export const examScorereporting = (data = {}) => {
  return http({
    url: '/c/tiku/exam/scorereporting',
    method: 'GET',
    data
  })
}
```

---

## 7. 商品订单模块

### 7.1 获取商品列表

**接口地址**: `GET /c/goods/v2`

**功能说明**: 获取课程商品列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:882-888
export const getGoods = (data = {}) => {
  return http({
    url: '/c/goods/v2',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?type=1&page=1&size=10
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "list": [
      {
        "id": "555343665594113147",
        "goods_name": "2024口腔执业医师题库",
        "name": "2024口腔执业医师题库",
        "price": "299.00",
        "original_price": "599.00",
        "cover_img": "https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/cover.png",
        "type": "18",
        "permission_status": "2",
        "is_homepage_recommend": 1,
        "validity_day": "180",
        "professional_id": "524033912737962623",
        "professional_id_name": "医学-口腔执业医师",
        "tiku_goods_details": {
          "question_num": "5000",
          "paper_num": "50",
          "exam_round_num": "3",
          "exam_time": "2024-06-15"
        },
        "teaching_system": {
          "system_id_name": "章节练习系统"
        },
        "material_intro_path": "https://xxx.com/intro.html",
        "material_cover_path": "https://xxx.com/cover.png",
        "prices": [
          {
            "goods_months_price_id": "555343665594178683",
            "month": "6",
            "days": "180",
            "sale_price": "299.00",
            "original_price": "599.00"
          }
        ]
      }
    ],
    "total": 50
  }
}
```

**字段说明**:
- `type`: 商品类型 8=试卷 10=模考 18=题库
- `permission_status`: 权限状态 1=已购买 2=未购买
- `is_homepage_recommend`: 是否首页推荐 1=是
- `tiku_goods_details`: 题库商品详情
  - `question_num`: 题目数量(type=18时)
  - `paper_num`: 试卷数量(type=8时)
  - `exam_round_num`: 考试轮次(type=10时)
  - `exam_time`: 开考时间(type=10时)
- `prices`: 价格套餐数组

---

### 7.2 获取商品详情

**接口地址**: `GET /c/goods/v2/detail`

**功能说明**: 获取商品详细信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:890-896
export const getGoodsDetail = (data = {}) => {
  return http({
    url: '/c/goods/v2/detail',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?goods_id=555343665594113147
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "id": "555343665594113147",
    "goods_name": "2024口腔执业医师题库",
    "name": "2024口腔执业医师题库",
    "price": "299.00",
    "original_price": "599.00",
    "type": "18",
    "permission_status": "2",
    "professional_id": "524033912737962623",
    "professional_id_name": "医学-口腔执业医师",
    "tiku_goods_details": {
      "question_num": "5000",
      "paper_num": "0",
      "exam_round_num": "0",
      "exam_time": ""
    },
    "teaching_system": {
      "system_id_name": "章节练习系统"
    },
    "material_intro_path": "https://xxx.com/intro.html",
    "material_cover_path": "https://xxx.com/cover.png",
    "cover_img": "https://xxx.com/cover.png",
    "prices": [
      {
        "goods_months_price_id": "555343665594178683",
        "month": "6",
        "days": "180",
        "sale_price": "299.00",
        "original_price": "599.00"
      },
      {
        "goods_months_price_id": "555343665594178684",
        "month": "12",
        "days": "365",
        "sale_price": "499.00",
        "original_price": "999.00"
      },
      {
        "goods_months_price_id": "555343665594178685",
        "month": "0",
        "days": "0",
        "sale_price": "999.00",
        "original_price": "1999.00"
      }
    ]
  }
}
```

**Model转换逻辑** (detail.vue:408-503):
```javascript
// 1. 处理价格数组：按月份排序，0(永久)在最后
if (!Array.isArray(res.data.prices)) {
  res.data.prices = []
}
this.prices = res.data.prices
  .sort((a, b) => {
    if (a.month == 0) return 1  // 永久套餐排在最后
    return Number(a.month) - Number(b.month)
  })
  .map(item => ({
    ...item,
    discount_price: Math.floor(
      (Number(item.original_price) - Number(item.sale_price)) * 100
    ) / 100  // 计算优惠金额
  }))

// 2. 处理商品信息
let info = res.data
let num_text = `共${info.tiku_goods_details.question_num}题`
if (info.type == 8) {
  num_text = `共${info.tiku_goods_details.paper_num}份`
}
if (info.type == 10) {
  num_text = `共${info.tiku_goods_details.exam_round_num}轮`
}

// 3. 处理系统信息
let system_id_name = info?.teaching_system?.system_id_name || ''
if (info.type == 10) {
  system_id_name = `开考时间:${info.tiku_goods_details.exam_time}`
}

// 4. 构建商品Model
this.info = {
  ...res.data,
  num_text: num_text,  // 数量文本：共XX题/份/轮
  tips: system_id_name, // 提示信息
  system_id_name: info?.teaching_system?.system_id_name || ''
}

// 5. 处理图片路径(非题库类型需要交换)
if (res.data.type != 18) {
  let material_intro_path = this.info.material_intro_path
  let material_cover_path = this.info.material_cover_path
  this.info.material_cover_path = material_intro_path  // 封面
  this.info.material_intro_path = material_cover_path   // 介绍
}
```

**Dart Model定义**:
```dart
class GoodsDetail {
  final String id;
  final String name;
  final String type;  // "8"=试卷, "10"=模考, "18"=题库
  final String permissionStatus;  // "1"=已购买, "2"=未购买
  final String professionalId;
  final String professionalIdName;
  final TikuGoodsDetails tikuGoodsDetails;
  final TeachingSystem? teachingSystem;
  final String? materialIntroPath;
  final String? materialCoverPath;
  final List<GoodsPrice> prices;
  
  // 计算字段
  final String numText;  // 根据type计算：共XX题/份/轮
  final String? tips;    // 系统名或开考时间
}

class TikuGoodsDetails {
  final String questionNum;   // 题目数量(type=18)
  final String paperNum;      // 试卷数量(type=8)
  final String examRoundNum;  // 考试轮次(type=10)
  final String examTime;      // 开考时间(type=10)
}

class GoodsPrice {
  final String goodsMonthsPriceId;
  final String month;  // "0"=永久
  final String days;
  final String salePrice;
  final String originalPrice;
  final double discountPrice;  // 计算得出
}

class TeachingSystem {
  final String systemIdName;
}
```,
        "days": "0",
        "sale_price": "999.00",
        "original_price": "1999.00"
      }
    ]
  }
}
```

**字段说明**:
- `month`: 月数 0=永久
- `days`: 天数 0=永久
- `prices`: 按月份升序排列,0(永久)排最后

---

### 7.3 创建订单

**接口地址**: `POST /c/order/v2`

**功能说明**: 创建商品订单

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:898-907
export const getOrderV2 = (data = {}) => {
  return http({
    url: '/c/order/v2',
    method: 'post',
    data,
    header: {
      'Content-Type': 'application/json'
    }
  })
}
```

**请求参数** (detail.vue:529-560):
```json
{
  "business_scene": 1,
  "goods": [
    {
      "goods_id": "555343665594113147",
      "goods_months_price_id": "555343665594178683",
      "months": "6",
      "class_campus_id": "",
      "class_city_id": "",
      "goods_num": "1"
    }
  ],
  "deposit_amount": 299.00,
  "payable_amount": 299.00,
  "real_amount": 299.00,
  "total_amount": 299.00,
  "discount_amount": 0,
  "remark": "",
  "student_adddatas_id": "",
  "student_id": "555343665594113147",
  "app_id": "wxf787cf63760d80a0",
  "pay_method": "",
  "order_type": 10,
  "coupons_ids": [],
  "employee_id": "508948528815416786",
  "delivery_type": 1
}
```

**参数构造逻辑**:
```javascript
let payable_amount = this.prices[this.active].sale_price
let student_id = uni.getStorageSync('__xingyun_userinfo__').student_id
let goods_id = this.id
let data = {
  business_scene: 1,  // 业务场景
  goods: [{
    goods_id: goods_id,
    goods_months_price_id: this.prices[this.active].goods_months_price_id,
    months: this.prices[this.active].month,
    class_campus_id: '',
    class_city_id: '',
    goods_num: '1'
  }],
  deposit_amount: Number(payable_amount),
  payable_amount: Number(payable_amount),
  real_amount: Number(payable_amount),
  total_amount: Number(payable_amount),
  remark: '',
  student_adddatas_id: '',
  student_id: student_id,
  app_id: app_id,
  pay_method: '',
  order_type: 10,
  discount_amount: 0,
  coupons_ids: [],
  employee_id: this.$store.state.jintiku.employee_id || '508948528815416786',
  delivery_type: 1  // 默认总部邮寄
}
```

**响应示例** (detail.vue:561-583):
```json
{
  "code": 100000,
  "msg": ["下单成功"],
  "data": {
    "order_id": "555343665594178683",
    "flow_id": "555343665594113147",
    "is_supervise_order": 2,
    "pay_amount": 299.00
  }
}
```

**数据处理逻辑**:
```javascript
getOrderV2({...data}).then(res => {
  // res.data.order_id - 订单ID
  // res.data.flow_id - 流水ID(用于支付)
  // res.data.pay_amount - 实际支付金额
  
  if (Number(payable_amount) > 0) {
    // 需要支付，获取支付方式
    this.getPayModeListNew({
      goods_id: goods_id,
      order_id: res.data.order_id,
      flow_id: res.data.flow_id
    })
  } else {
    // 0元订单，直接跳转成功页
    this.$xh.push('jintiku', `pages/order/paySuccess?goods_id=${this.id}`)
  }
})
```

**字段说明**:
- `order_id`: 订单ID,用于查询订单
- `flow_id`: 流水ID,用于支付
- `is_supervise_order`: 是否监管订单 1=是 2=否
- `pay_amount`: 实际支付金额

---

### 7.4 我的订单列表

**接口地址**: `GET /c/order/my/list`

**功能说明**: 获取用户订单列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:908-914
export const orderList = (data = {}) => {
  return http({
    url: '/c/order/my/list',
    method: 'GET',
    data
  })
}
```

**请求参数**:
```
?status=0&page=1&size=10
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "list": [
      {
        "order_id": "555343665594178683",
        "order_no": "YKX202411231234567890",
        "goods_name": "2024口腔执业医师题库",
        "pay_amount": "299.00",
        "status": "2",
        "status_name": "已支付",
        "create_time": "2024-11-23 14:30:00",
        "pay_time": "2024-11-23 14:31:25",
        "goods_cover": "https://xxx.com/cover.png",
        "validity_day": "180",
        "expire_time": "2025-05-22 14:31:25"
      }
    ],
    "total": 15
  }
}
```

**字段说明**:
- `status`: 订单状态 0=待支付 1=支付中 2=已支付 3=已取消 4=已退款
- `status_name`: 状态名称
- `expire_time`: 过期时间

---

## 8. 支付模块

### 8.1 微信小程序支付

**接口地址**: `POST /c/pay/wechatpay/jsapi`

**功能说明**: 调起微信支付

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:916-926
export const wechatapplet = (data = {}) => {
  return http({
    url: '/c/pay/wechatpay/jsapi',
    method: 'post',
    data,
    header: {
      'Content-Type': 'application/json'
    }
  })
}
```

**请求参数** (detail.vue:618-624):
```json
{
  "flow_id": "555343665594113147",
  "wechat_app_id": "wxf787cf63760d80a0",
  "open_id": "oXxXx1234567890",
  "finance_body_id": "12345678"
}
```

**请求构造**:
```javascript
let openid = uni.getStorageSync('__xingyun_weixinInfo__').openid
wechatapplet({
  flow_id: flow_id,  // 从创建订单接口返回
  wechat_app_id: app_id,
  open_id: openid,
  finance_body_id: finance_body_id  // 从支付方式接口获取
}).then(res => {
  const payParams = {
    appId: app_id,
    timeStamp: res.data.time_stamp,
    nonceStr: res.data.nonce_str,
    signType: res.data.sign_type,
    paySign: res.data.pay_sign,
    package: res.data.package
  }
  // 调起微信支付
  wx.requestPayment(payParams)
})
```

**响应示例**:
```json
{
  "code": 100000,
  "msg": ["success"],
  "data": {
    "time_stamp": "1700728800",
    "nonce_str": "5K8264ILTKCH16CQ2502SI8ZNMTM67VS",
    "package": "prepay_id=wx23112319004583abc123def456",
    "sign_type": "RSA",
    "pay_sign": "oR9d8PuhnIc+YZ8cBHFCwfgpaK9gd7vaRvkYD7rthRAZ/"
  }
}
```

**Dart Model**:
```dart
class WechatPayParams {
  final String timeStamp;
  final String nonceStr;
  final String package;
  final String signType;
  final String paySign;
}
```

**使用方式**:
```javascript
wx.requestPayment({
  timeStamp: data.timeStamp,
  nonceStr: data.nonceStr,
  package: data.package,
  signType: data.signType,
  paySign: data.paySign,
  success: (res) => { /* 支付成功 */ },
  fail: (err) => { /* 支付失败 */ }
})
```

---

### 8.2 获取支付方式列表

**接口地址**: `GET /c/config/finance/account`

**功能说明**: 获取可用支付方式

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:964-970
export const payModeListNew = function (data = {}) {
  return http({
    url: '/c/config/finance/account',
    method: 'GET',
    data
  })
}
```

---

### 8.3 支付方式详情

**接口地址**: `GET /c/config/finance/account/detail`

**功能说明**: 获取支付方式详细配置

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:972-978
export const payModeListNewDetail = function (data = {}) {
  return http({
    url: '/c/config/finance/account/detail',
    method: 'GET',
    data
  })
}
```

---

## 9. 考点词条模块

### 9.1 获取考点词条列表

**接口地址**: `GET /c/tiku/testingcentre/gettestpointknacklist`

**功能说明**: 获取一级考点词条

**小程序调用**:
```javascript
// src/modules/jintiku/api/examEntry.js:6-12
export const getTestpointknacklist = function (data = {}) {
  return http({
    url: '/c/tiku/testingcentre/gettestpointknacklist',
    method: 'GET',
    data
  })
}
```

---

### 9.2 获取考点词条子列表

**接口地址**: `GET /c/tiku/testingcentre/gettestpointknackchildlist`

**功能说明**: 获取二级考点词条

**小程序调用**:
```javascript
// src/modules/jintiku/api/examEntry.js:14-20
export const getTestpointknackchildlist = function (data = {}) {
  return http({
    url: '/c/tiku/testingcentre/gettestpointknackchildlist',
    method: 'GET',
    data
  })
}
```

---

### 9.3 获取词条详情

**接口地址**: `GET /c/tiku/testingcentre/gettestpointknackquestion`

**功能说明**: 获取考点词条问题详情

**小程序调用**:
```javascript
// src/modules/jintiku/api/examEntry.js:22-28
export const getTestpointknackquestion = function (data = {}) {
  return http({
    url: '/c/tiku/testingcentre/gettestpointknackquestion',
    method: 'GET',
    data
  })
}
```

---

### 9.4 收藏考点词条

**接口地址**: `POST /c/tiku/testingcentre/collect`

**功能说明**: 收藏/取消收藏考点

**小程序调用**:
```javascript
// src/modules/jintiku/api/examEntry.js:49-58
export const testingcentreCollect = function (data = {}) {
  return http({
    url: '/c/tiku/testingcentre/collect',
    method: 'POST',
    header: {
      'Content-Type': 'application/json'
    },
    data
  })
}
```

---

### 9.5 记忆考点

**接口地址**: `POST /c/tiku/testingcentre/memorization`

**功能说明**: 标记考点为已记忆

**小程序调用**:
```javascript
// src/modules/jintiku/api/examEntry.js:38-47
export const memorization = function (data = {}) {
  return http({
    url: '/c/tiku/testingcentre/memorization',
    method: 'POST',
    header: {
      'Content-Type': 'application/json'
    },
    data
  })
}
```

---

## 10. 我的模块

### 10.1 我的课程测评

**接口地址**: `GET /c/goods/v2/servicehall/mine/courseevaluation`

**功能说明**: 获取我的课程测评列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:231-237
export const getMyCourseevaluation = function (data = {}) {
  return http({
    url: '/c/goods/v2/servicehall/mine/courseevaluation',
    method: 'GET',
    data
  })
}
```

---

### 10.2 测评分类树

**接口地址**: `GET /c/teachingaffair/evaluation/type/tree`

**功能说明**: 获取测评分类树

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:240-246
export const getEvaluationTypeTree = function (data = {}) {
  return http({
    url: '/c/teachingaffair/evaluation/type/tree',
    method: 'GET',
    data
  })
}
```

---

### 10.3 课程测评详情

**接口地址**: `GET /c/goods/v2/servicehall/mine/courseevaluation/detail`

**功能说明**: 获取课程测评详细信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:249-255
export const getCourseevaluationDetail = function (data = {}) {
  return http({
    url: '/c/goods/v2/servicehall/mine/courseevaluation/detail',
    method: 'GET',
    data
  })
}
```

---

### 10.4 课程测评列表

**接口地址**: `GET /c/goods/v2/servicehall/mine/courseevaluation/list`

**功能说明**: 获取课程测评题目列表

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:258-264
export const getCourseevaluationList = function (data = {}) {
  return http({
    url: '/c/goods/v2/servicehall/mine/courseevaluation/list',
    method: 'GET',
    data
  })
}
```

---

### 10.5 是否已测评

**接口地址**: `GET /c/study/learning/is/evaluation`

**功能说明**: 检查课程是否已测评

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:267-273
export const getCourseIsEvaluation = function (data = {}) {
  return http({
    url: '/c/study/learning/is/evaluation',
    method: 'GET',
    data
  })
}
```

---

### 10.6 分享记录

**接口地址**: `POST /c/goods/v2/share/record`

**功能说明**: 记录分享行为

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:275-281
export const shareRecord = function (data = {}) {
  return http({
    url: '/c/goods/v2/share/record',
    method: 'POST',
    data
  })
}
```

---

### 10.7 课程签到

**接口地址**: `POST /c/goods/v2/class/signin`

**功能说明**: 课程签到打卡

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:284-290
export const classSignin = function (data = {}) {
  return http({
    url: '/c/goods/v2/class/signin',
    method: 'POST',
    data
  })
}
```

---

### 10.8 修改基本信息

**接口地址**: `PUT /c/student/change/basic`

**功能说明**: 修改用户基本信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1008-1014
export const changeBasic = function (data = {}) {
  return http({
    url: '/c/student/change/basic',
    method: 'PUT',
    data
  })
}
```

---

### 10.9 添加备注

**接口地址**: `PUT /c/student/remark`

**功能说明**: 添加用户备注信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1065-1071
export const cityRemark = function (data = {}) {
  return http({
    url: '/c/student/remark',
    method: 'PUT',
    data
  })
}
```

---

### 10.10 小程序授权

**接口地址**: `PUT /c/student/miniapp/auth`

**功能说明**: 更新小程序授权信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1054-1063
export const miniappAuth = function (data = {}) {
  http({
    url: '/c/student/miniapp/auth',
    method: 'PUT',
    data,
    header: {
      'Content-Type': 'application/json'
    }
  })
}
```

---

### 10.11 活动记录

**接口地址**: `POST /c/marketing/activity/student/add`

**功能说明**: 记录用户参与活动

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1016-1022
export const activityRecord = function (data = {}) {
  return http({
    url: '/c/marketing/activity/student/add',
    method: 'POST',
    data
  })
}
```

---

### 10.12 激活用户记录

**接口地址**: `POST /c/student/activateuser/record`

**功能说明**: 记录用户激活信息

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1001-1007
export const activateuserRecord = function (data = {}) {
  return http({
    url: '/c/student/activateuser/record',
    method: 'POST',
    data
  })
}
```

---

## 11. 其他模块

### 11.1 获取配置

**接口地址**: `GET /c/config/common`

**功能说明**: 获取系统通用配置

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:771-777
export const getConfigCommon = (data = {}) => {
  return http({
    url: '/c/config/common',
    method: 'GET',
    data
  })
}
```

---

### 11.2 人脸识别比对

**接口地址**: `GET /c/tiku/configclient/visioncomparison`

**功能说明**: 人脸识别配置

**小程序调用**:
```javascript
// src/modules/jintiku/api/examEntry.js:61-67
export const visioncomparison = function (data = {}) {
  return http({
    url: '/c/tiku/configclient/visioncomparison',
    method: 'GET',
    data
  })
}
```

---

### 11.3 获取URL参数

**接口地址**: `GET /o/base/url/param/json`

**功能说明**: 获取活动URL参数配置

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1047-1053
export const activityRaram = function (data = {}) {
  return http({
    url: '/o/base/url/param/json',
    method: 'GET',
    data
  })
}
```

---

### 11.4 生成小程序二维码

**接口地址**: `GET /c/marketing/wechatshare/qrcode`

**功能说明**: 生成分享小程序码

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1073-1079
export const miniQrcode = {
  get: function (data = {}) {
    return http({
      url: '/c/marketing/wechatshare/qrcode',
      method: 'GET',
      data
    })
  }
}
```

---

### 11.5 解码小程序码场景值

**接口地址**: `GET /c/marketing/wechatshare/qrcode/decodescene`

**功能说明**: 解析小程序码场景参数

**小程序调用**:
```javascript
// src/modules/jintiku/api/index.js:1080-1086
miniQrcode.getQuery = function (data = {}) {
  return http({
    url: '/c/marketing/wechatshare/qrcode/decodescene',
    method: 'GET',
    data
  })
}
```

---

## 📊 接口统计

### 按模块统计

| 模块 | 接口数量 |
|------|---------|
| 用户认证模块 | 6 |
| 首页模块 | 5 |
| 学习中心模块 | 11 |
| 题库模块 | 6 |
| 章节练习模块 | 3 |
| 模考模块 | 6 |
| 商品订单模块 | 4 |
| 支付模块 | 3 |
| 考点词条模块 | 5 |
| 我的模块 | 12 |
| 其他模块 | 5 |
| **总计** | **66** |

### 按请求方法统计

| 方法 | 数量 |
|------|------|
| GET | 42 |
| POST | 22 |
| PUT | 4 |
| **总计** | **68** |

---

## 🔐 认证方式

所有接口都需要在请求头中携带token:

```
Authorization: Bearer {token}
```

Token通过登录接口获取,存储在本地缓存中。

---

## 🌐 接口基础URL

- **生产环境**: `https://yakaixin.yunsop.com`
- **开发环境**: 根据配置动态获取

---

## ⚠️ 注意事项

1. **请求头要求**:
   - 部分接口需要 `Content-Type: application/json`
   - 部分接口需要 `Content-Type: application/x-www-form-urlencoded`

2. **分页参数**:
   - `page`: 当前页码,从1开始
   - `size`: 每页数量,默认10

3. **响应格式**:
   ```json
   {
     "code": 0,  // 0:成功 非0:失败
     "msg": "success",
     "data": {}
   }
   ```

4. **Token过期处理**:
   - code=401时需要重新登录
   - 自动刷新token机制

---

## 📝 更新日志

- **2025-11-23**: 初始版本,提取小程序所有API接口
- 基于小程序源码和Swagger文档生成

---

## 🔗 相关资源

- Swagger文档: https://yakaixin.yunsop.com/swagger/doc.json
- 小程序源码: /Users/mac/Desktop/vueToFlutter/mini-dev_250812
- Flutter项目: /Users/mac/Desktop/vueToFlutter/yakaixin_app

---

**文档生成工具**: AI代码助手
**最后更新**: 2025-11-23
