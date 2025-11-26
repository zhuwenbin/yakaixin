import 'data/auth_mock_data.dart';
import 'data/question_bank_mock_data.dart';
import 'data/model_exam_mock_data.dart';
import 'data/course_goods_profile_mock_data.dart';
import 'data/course_mock_data.dart';
import 'data/goods_mock_data.dart';
import 'data/exam_mock_data.dart';
import 'data/order_mock_data.dart';
import 'data/home_mock_data.dart';

/// Mock数据路由器
/// 根据API路径匹配并返回对应的Mock数据
class MockDataRouter {
  /// 根据URL路径和方法获取Mock数据
  static Map<String, dynamic>? getMockData(String path, String method) {
    // 移除查询参数
    final cleanPath = path.split('?').first;
    
    print('🔍 查找Mock数据: $method $cleanPath');
    
    // ============ F1. 用户认证模块 ============
    
    // 发送验证码 (标准版 + H5版)
    if (cleanPath.contains('/sms/sendcode') || cleanPath.contains('/sendcode')) {
      return AuthMockData.sendCode;
    }
    
    // 获取专业列表
    if (cleanPath.contains('/teaching/mapping/tree') || cleanPath.contains('/getMajor')) {
      return AuthMockData.getMajor;
    }
    
    // 保存专业 (/c/student PUT)
    if (method == 'PUT' && cleanPath.contains('/student')) {
      return AuthMockData.saveMajor;
    }
    
    // P1-1 微信授权登录
    if (cleanPath.contains('/wechat/login') || cleanPath.contains('/student/login')) {
      return AuthMockData.login;
    }
    
    // P1-2 H5登录(手机号+验证码)
    if (cleanPath.contains('/student/h5Login') || cleanPath.contains('/student/smslogin')) {
      return AuthMockData.h5Login;
    }
    
    // P1-3 选择专业 - 专业列表
    if (cleanPath.contains('/professional/list')) {
      return AuthMockData.majorList;
    }
    
    // P1-3 保存专业
    if (cleanPath.contains('/student/saveProfessional')) {
      return AuthMockData.saveMajor;
    }
    
    // ============ F2. 题库练习模块 ============
    
    // P2-1 首页数据
    if (cleanPath.contains('/home/index') || cleanPath.contains('/bistatistic/indexdata')) {
      return QuestionBankMockData.homeData;
    }
    
    // 首页Banner
    if (cleanPath.contains('/home/banner')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': MockHomeData.bannerList,
      };
    }
    
    // 首页商品列表
    if (cleanPath.contains('/home/goods')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': {'list': MockHomeData.goodsList},
      };
    }
    
    // 学习数据
    if (cleanPath.contains('/exam/learning')) {
      return QuestionBankMockData.learningData;
    }
    
    // 打卡
    if (cleanPath.contains('/exam/checkin')) {
      return QuestionBankMockData.checkinResponse;
    }
    
    // 商品列表 (根据 teaching_type 参数返回不同类型)
    if (cleanPath.contains('/goods/v2')) {
      // 检查查询参数中的 teaching_type
      final uri = Uri.parse(path);
      final teachingType = uri.queryParameters['teaching_type'];
      
      if (teachingType == '3') {
        // 网课列表
        return QuestionBankMockData.onlineCourseList;
      } else if (teachingType == '1') {
        // 直播列表
        return QuestionBankMockData.liveList;
      } else {
        // 默认返回题库列表
        return QuestionBankMockData.goodsList;
      }
    }
    
    // 根据position_identify获取商品列表 (对应小程序 getGoods 接口)
    if (cleanPath.contains('/goods') && !cleanPath.contains('/goods/v2')) {
      final uri = Uri.parse(path);
      final positionIdentify = uri.queryParameters['position_identify'];
      
      if (positionIdentify != null) {
        final list = QuestionBankMockData.getGoodsByPosition(positionIdentify);
        return {
          'code': 100000,
          'msg': ['操作成功'],
          'data': {'list': list},
        };
      }
    }
    
    // 推荐章节
    if (cleanPath.contains('/recommend/chapterpackage')) {
      return QuestionBankMockData.homeData; // 复用homeData中的recommend_chapters
    }
    
    // 上次练习进度
    if (cleanPath.contains('/last/study/progress')) {
      return QuestionBankMockData.homeData; // 复用homeData中的last_progress
    }
    
    // 学习打卡数据
    if (cleanPath.contains('/exam/learning/data') || cleanPath.contains('/exam/checkin/data')) {
      return QuestionBankMockData.homeData; // 复用homeData中的checkin_data
    }
    
    // P2-2 章节树
    if (cleanPath.contains('/section/tree') || cleanPath.contains('/chapterpackage/tree') || cleanPath.contains('/chapter/list')) {
      return QuestionBankMockData.chapterTree;
    }
    
    // P2-3 章节详情
    if (cleanPath.contains('/section/info')) {
      return QuestionBankMockData.chapterDetail;
    }
    
    // P2-4 获取题目列表
    if (cleanPath.contains('/question/list') || 
        cleanPath.contains('/test/generatePaper') ||
        cleanPath.contains('/question/getquestionlist') ||
        cleanPath.contains('/chapter/getquestionlist')) {
      return QuestionBankMockData.questionList;
    }
    
    // P2-5 提交答案
    if (cleanPath.contains('/question/submit') || 
        cleanPath.contains('/test/submitAnswer') ||
        cleanPath.contains('/question/answer')) {
      return QuestionBankMockData.submitAnswer;
    }
    
    // P2-6 成绩报告
    if (cleanPath.contains('/statistics/report') || 
        cleanPath.contains('/test/report') ||
        cleanPath.contains('/servicehall/scorereporting')) {
      return QuestionBankMockData.scoreReport;
    }
    
    // 排名
    if (cleanPath.contains('/paper/ranking')) {
      return QuestionBankMockData.scoreReport; // 复用scoreReport中的ranking数据
    }
    
    // P2-7 真题闯关首页
    if (cleanPath.contains('/challenge/index')) {
      return QuestionBankMockData.challengeIndex;
    }
    
    // P2-8 关卡列表
    if (cleanPath.contains('/challenge/levelList')) {
      return QuestionBankMockData.levelList;
    }
    
    // P2-11 智能测评首页
    if (cleanPath.contains('/intelligent/index')) {
      return QuestionBankMockData.intelligentIndex;
    }
    
    // P2-14 考点词条首页
    if (cleanPath.contains('/entry/index')) {
      return QuestionBankMockData.examEntryIndex;
    }
    
    // P2-15 考点词条详情
    if (cleanPath.contains('/entry/detail')) {
      return QuestionBankMockData.examEntryDetail;
    }
    
    // ============ F3. 模拟考试模块 ============
    
    // P3-1 模考首页 / 所有模考
    if (cleanPath.contains('/modelExam/index') || cleanPath.contains('/mockexam/allexam')) {
      return ModelExamMockData.modelExamIndex;
    }
    
    // P3-2 试卷信息 / 模考详情
    if (cleanPath.contains('/exam/info') || cleanPath.contains('/mockexam/examinfo')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': MockExamData.examInfo,
      };
    }
    
    // 考试成绩报告
    if (cleanPath.contains('/exam/report') || cleanPath.contains('/score/report')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': MockExamData.examReport,
      };
    }
    
    // 学员考试信息
    if (cleanPath.contains('/mockexam/getstudentexaminfo')) {
      return ModelExamMockData.examInfo;
    }
    
    // 模考报名
    if (cleanPath.contains('/mockexam/signup')) {
      return {
        'code': 100000,
        'msg': ['报名成功'],
        'data': null,
      };
    }
    
    // P3-3 开始考试
    if (cleanPath.contains('/exam/start') || cleanPath.contains('/mockexam/info')) {
      return ModelExamMockData.startExam;
    }
    
    // P3-4 考试中的题目
    if (cleanPath.contains('/exam/questions')) {
      return ModelExamMockData.examQuestions;
    }
    
    // P3-5 提交试卷
    if (cleanPath.contains('/exam/submit')) {
      return ModelExamMockData.submitExam;
    }
    
    // P3-7 考试记录
    if (cleanPath.contains('/exam/records')) {
      return ModelExamMockData.examRecords;
    }
    
    // ============ F4. 学习中心模块 ============
    
    // P4-1 学习中心首页
    if (cleanPath.contains('/study/index')) {
      return CourseGoodsProfileMockData.studyIndex;
    }
    
    // P4-2 我的课程
    if (cleanPath.contains('/course/myCourse')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': {'list': MockCourseData.myCourseList},
      };
    }
    
    // P4-3 课程详情
    if (cleanPath.contains('/course/detail')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': MockCourseData.courseDetail,
      };
    }
    
    // P4-4 课程列表
    if (cleanPath.contains('/course/lesson/list')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': {'list': MockCourseData.lessonList},
      };
    }
    
    // P4-5 下载资料列表
    if (cleanPath.contains('/course/download/list')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': {'list': MockCourseData.downloadList},
      };
    }
    
    // P4-4 视频播放
    if (cleanPath.contains('/course/video')) {
      return CourseGoodsProfileMockData.videoInfo;
    }
    
    // ============ F5. 商品订单模块 ============
    
    // P5-1 商品详情
    if (cleanPath.contains('/goods/detail')) {
      return MockGoodsData.goodsDetail;
    }
    
    // P5-2 我的订单
    if (cleanPath.contains('/order/my/list')) {
      // 根据status参数过滤订单
      print('📋 订单列表请求路径: $path');
      
      // 解析查询参数
      String status = '0';
      if (path.contains('?')) {
        final queryString = path.split('?')[1];
        print('📋 查询字符串: $queryString');
        
        final params = Uri.splitQueryString(queryString);
        status = params['status'] ?? '0';
      }
      
      print('📋 订单状态过滤: status=$status');
      
      List<Map<String, dynamic>> filteredList;
      if (status == '0') {
        // 0=全部
        filteredList = MockOrderData.orderList;
      } else {
        // 按照status过滤 (1=待支付, 2=已支付, 4=已取消)
        filteredList = MockOrderData.orderList
            .where((order) => order['status'] == status)
            .toList();
      }
      
      print('📋 过滤后订单数量: ${filteredList.length}');
      
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': {
          'list': filteredList,
          'total': filteredList.length,
        },
      };
    }
    
    // P5-3 支付成功页面
    if (cleanPath.contains('/order/success') || cleanPath.contains('/pay/success')) {
      return {
        'code': 100000,
        'msg': ['操作成功'],
        'data': MockOrderData.paySuccessGoodsInfo,
      };
    }
    
    // P5-3 创建订单 (/c/order/v2 POST)
    if (method == 'POST' && cleanPath.contains('/order/v2')) {
      return CourseGoodsProfileMockData.createOrder;
    }
    
    // P5-4 获取支付账户列表 (/c/config/finance/account GET)
    if (method == 'GET' && cleanPath.contains('/config/finance/account')) {
      return CourseGoodsProfileMockData.paymentAccountList;
    }
    
    // P5-5 获取微信支付参数 (/c/pay/wechatpay/jsapi POST)
    if (method == 'POST' && cleanPath.contains('/pay/wechatpay/jsapi')) {
      return CourseGoodsProfileMockData.wechatPayParams;
    }
    
    // ============ F6. 我的中心模块 ============
    
    // P6-1 我的中心首页
    if (cleanPath.contains('/student/info') || cleanPath.contains('/my/index')) {
      return CourseGoodsProfileMockData.myIndex;
    }
    
    // P6-2 个人信息编辑
    if (cleanPath.contains('/student/update')) {
      return CourseGoodsProfileMockData.updateProfile;
    }
    
    // ============ F7. 错题本模块 ============
    
    // P7-1 错题本首页
    if (cleanPath.contains('/wrongBook/index')) {
      return QuestionBankMockData.wrongBookIndex;
    }
    
    // P7-2 错题详情
    if (cleanPath.contains('/wrongBook/detail')) {
      return QuestionBankMockData.wrongBookDetail;
    }
    
    // ============ F8. 收藏管理模块 ============
    
    // P8-1 收藏首页
    if (cleanPath.contains('/collect/index')) {
      return QuestionBankMockData.collectIndex;
    }
    
    // P8-2 添加/取消收藏
    if (cleanPath.contains('/collect/toggle')) {
      return QuestionBankMockData.toggleCollect;
    }
    
    // 未匹配到任何路由
    print('⚠️ 未找到匹配的Mock路由: $cleanPath');
    return null;
  }
  
  /// 通用成功响应
  static Map<String, dynamic> successResponse([Map<String, dynamic>? data]) {
    return {
      'code': 100000,
      'msg': ['操作成功'],
      'data': data ?? {},
    };
  }
  
  /// 通用失败响应
  static Map<String, dynamic> errorResponse(String message) {
    return {
      'code': 100001,
      'msg': [message],
      'data': null,
    };
  }
}
