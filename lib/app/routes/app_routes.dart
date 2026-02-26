/// 应用路由定义
///
/// 基于API接口文档的功能清单和页面对应表
///
/// 功能模块:
/// - F1. 用户认证 (3个页面)
/// - F2. 题库练习 (16个页面)
/// - F3. 模拟考试 (8个页面)
/// - F4. 学习中心 (7个页面)
/// - F5. 商品订单 (3个页面)
/// - F6. 我的中心 (4个页面)
/// - F7. 错题本 (2个页面)
/// - F8. 收藏管理 (3个页面)
/// - F9. H5活动 (3个页面)

class AppRoutes {
  // ===== F1. 用户认证模块 =====

  /// P1-1 登录中心 - 微信授权登录
  static const String loginCenter = '/login-center';

  /// P1-2 H5登录 - 手机号验证码登录
  static const String h5Login = '/h5-login';

  /// P1-3 选择专业
  static const String selectMajor = '/select-major';
  
  /// P1-4 忘记密码
  static const String forgetPassword = '/forget-password';
  
  /// P1-5 修改密码
  static const String changePassword = '/change-password';

  /// P1-6 删除账户风险提示
  static const String deleteAccountRisk = '/delete-account-risk';
  
  /// P1-7 删除账户安全验证
  static const String deleteAccountVerification = '/delete-account-verification';
  
  /// P1-8 删除账户确认
  static const String deleteAccountConfirm = '/delete-account-confirm';

  /// P1-9 隐私协议弹窗（首次安装必现）
  static const String privacyAgreement = '/privacy-agreement';

  // ===== F2. 题库练习模块 =====

  /// P2-1 首页(题库) - 题库首页,章节练习入口
  static const String home = '/';

  /// P2-2 章节练习 - 章节列表
  /// 对应小程序: pages/chapterExercise/index
  static const String chapterExercise = '/chapter-list';
  static const String chapterList = '/chapter-list'; // 别名，兼容旧代码

  /// P2-3 章节详情 - 章节题目列表
  static const String chapterDetail = '/chapter-detail';

  /// P2-4 做题页 - 做题界面
  static const String makeQuestion = '/make-question';

  /// P2-5 查看解析 - 题目解析
  static const String lookAnalysis = '/look-analysis';

  /// P2-6 成绩报告 - 练习成绩
  static const String scoreReport = '/score-report';

  /// P2-7 真题闯关 - 闯关入口
  static const String challengeIndex = '/challenge-index';

  /// P2-8 关卡列表 - 关卡选择
  static const String levelList = '/level-list';

  /// P2-9 闯关练习 - 闯关做题
  static const String challengePractise = '/challenge-practise';

  /// P2-10 闯关报告 - 闯关成绩
  static const String challengeReport = '/challenge-report';

  /// P2-11 智能测评 - 测评入口
  static const String intelligentIndex = '/intelligent-index';

  /// P2-12 测评练习 - 测评做题
  static const String intelligentPractise = '/intelligent-practise';

  /// P2-13 测评报告 - 测评成绩
  static const String intelligentReport = '/intelligent-report';

  /// P2-14 考点词条 - 考点列表
  static const String examEntryIndex = '/exam-entry-index';

  /// P2-15 词条详情 - 考点内容
  static const String examEntryDetail = '/exam-entry-detail';

  /// P2-16 考点口诀 - 口诀列表
  static const String examKnack = '/exam-knack';

  // ===== F3. 模拟考试模块 =====

  /// P3-1 全部模考 - 模考列表
  static const String modelExamIndex = '/model-exam-index';

  /// P3-2 模考详情 - 模考信息
  static const String examInfo = '/exam-info';

  /// P3-2-1 模考帮助 - 模考说明
  static const String examHelp = '/exam-help';

  /// P3-3 考试须知 - 考前须知
  static const String examNotice = '/exam-notice';

  /// P3-4 考试中 - 考试答题
  static const String examinationing = '/examinationing';

  /// P3-5 交卷成功 - 交卷页
  static const String submitSuccess = '/submit-success';

  /// P3-6 试卷详情 - 历史试卷
  static const String testExam = '/test-exam';

  /// P3-7 成绩报告 - 考试成绩
  static const String examScoreReport = '/exam-score-report';

  /// P3-8 排行榜 - 成绩排名
  static const String rankList = '/rank-list';

  // ===== F4. 学习中心模块 =====

  /// P4-1 课程首页 - 学习日历/课程列表
  static const String studyIndex = '/study-index';

  /// P4-2 我的课程 - 已购课程
  static const String myCourse = '/my-course';

  /// P4-3 课程详情 - 课程信息（学习课程详情，已购买）
  static const String courseDetail = '/course-detail';

  /// P4-3-2 商品课程详情 - 商品课程信息（未购买，用于报名）
  static const String courseGoodsDetail = '/course-goods-detail';

  /// P4-4 直播课程 - 直播观看
  static const String liveIndex = '/live-index';

  /// P4-5 视频播放 - 录播观看
  static const String videoIndex = '/video-index';

  /// P4-6 资料下载 - 讲义下载
  static const String dataDownload = '/data-download';

  /// P4-7 PDF查看 - PDF预览
  static const String pdfIndex = '/pdf-index';

  // ===== F5. 商品订单模块 =====

  /// P5-1 商品详情 - 题库/试卷商品详情(经典版)
  static const String goodsDetail = '/goods-detail';

  /// P5-1-2 历年真题商品详情
  static const String secretRealDetail = '/secret-real-detail';

  /// P5-1-3 科目模考商品详情
  static const String subjectMockDetail = '/subject-mock-detail';

  /// P5-1-4 模拟考试商品详情
  static const String simulatedExamRoom = '/simulated-exam-room';

  /// P5-1-5 购买确认页（5.1.1 合规：详情页提示登录并下订单）
  static const String purchaseConfirm = '/purchase-confirm';

  /// P5-1-6 商品详情（弹窗风格，参照小程序购买弹窗，逻辑与其他详情页一致）
  static const String goodsDetailPopup = '/goods-detail-popup';

  /// P5-2 我的订单 - 订单列表
  static const String myOrder = '/my-order';

  /// P5-3 支付成功 - 支付结果
  static const String paySuccess = '/pay-success';

  // ===== F6. 我的中心模块 =====

  /// P6-1 个人中心 - 用户信息/菜单
  static const String myIndex = '/my-index';

  /// P6-2 修改资料 - 编辑个人信息
  static const String personEdit = '/person-edit';

  /// P6-3 报告中心 - 历史报告
  static const String reportCenter = '/report-center';

  /// P6-4 设置 - 系统设置
  static const String settings = '/settings';

  /// P6-5 隐私协议
  static const String privacyPolicy = '/privacy-policy';

  /// P6-6 用户协议
  static const String userServiceAgreement = '/user-service-agreement';

  /// P6-7 关于我们
  static const String aboutUs = '/about-us';

  // ===== F7. 错题本模块 =====

  /// P7-1 错题本 - 错题列表
  static const String wrongBookIndex = '/wrong-book-index';

  /// P7-2 错题详情 - 错题解析
  static const String wrongBookDetail = '/wrong-book-detail';

  // ===== F8. 收藏管理模块 =====

  /// P8-1 试题收藏 - 收藏题目列表
  static const String collectIndex = '/collect-index';

  /// P8-2 试题详情 - 收藏题目详情
  static const String collectDetail = '/collect-detail';

  /// P8-3 考点收藏 - 收藏考点列表
  static const String examEntryCollect = '/exam-entry-collect';

  // ===== F9. H5活动模块 =====

  /// P9-1 兑换码领取 - 兑换码兑换
  static const String codeReceive = '/code-receive';

  /// P9-2 APP下载 - APP下载页
  static const String appUpload = '/app-upload';

  /// P9-3 打开APP - 跳转APP
  static const String openApp = '/open-app';

  // ===== F10. 支付模块 =====

  /// P10-3 确认付款 - 确认订单页面
  static const String confirmPayment = '/confirm-payment';

  // ===== 主框架 =====

  /// 主框架(底部Tab导航)
  static const String mainTab = '/main-tab';

  /// 启动页
  static const String splash = '/splash';
}
