import 'mock_database.dart';

/// Mock数据路由器
///
/// 支持两种模式:
/// 1. 静态数据模式: 从 mock_data.dart 获取预定义数据
/// 2. 动态查询模式: 从 mock_database.dart 动态查询(类似数据库)
class MockDataRouter {
  /// 根据URL路径和方法获取Mock数据
  static Future<Map<String, dynamic>?> getMockData(
    String url,
    String method,
  ) async {
    print('🔍 查找Mock数据: $method $url');

    // 解析 URL
    final uri = Uri.parse(url);
    final path = uri.path;
    final params = uri.queryParameters;

    // 优先尝试动态查询模式 (从 JSON 文件)
    final dynamicData = await _getDynamicData(path, method, params);
    if (dynamicData != null) {
      print('✅ Mock数据库查询命中 (来自 JSON 文件)');
      return dynamicData;
    }

    // ⚠️ 不再回退到静态数据模式，强制使用 JSON 文件
    // 旧的Dart Mock数据类已废弃，所有数据从JSON文件加载

    // 未找到Mock数据
    print('⚠️ 未找到Mock数据: $url (请检查 JSON 文件)');
    return null;
  }

  /// 动态查询数据(类似数据库查询)
  static Future<Map<String, dynamic>?> _getDynamicData(
    String path,
    String method,
    Map<String, String> params,
  ) async {
    // ========== 认证相关接口 ==========

    // 验证码登录
    if (method == 'POST' && path.contains('/student/smslogin')) {
      return await _loginWithSms(params);
    }

    // 发送验证码
    if (method == 'POST' && path.contains('/sms/sendcode')) {
      return successResponse();
    }

    // ========== 商品相关接口 ==========

    // 商品详情查询 (商品详情页)
    if (method == 'GET' && path.contains('/goods/v2/detail')) {
      return await MockDatabase.queryGoodsDetail(params);
    }

    // 商品列表查询 (首页、题库、网课、直播)
    if (method == 'GET' &&
        (path.contains('/goods/v2') || path.contains('/goods'))) {
      // ✅ 课程章节查询 (课程详情页)
      if (path.contains('/goods/v2/chapter')) {
        return await MockDatabase.queryCourseChapters(params);
      }

      // 检查是否是特殊位置标识查询
      if (params.containsKey('position_identify')) {
        final positionIdentify = params['position_identify'];
        // 每日一测
        if (positionIdentify == 'daily30') {
          return await MockDatabase.queryDailyPractice(params);
        }
        // 绝密押题、科目模考、模拟考试等
        // 这些position_identify的商品也在goods_data.json中
        // 只需要按position_identify筛选即可
      }
      return await MockDatabase.queryGoods(params);
    }

    // 订单列表查询
    if (method == 'GET' && path.contains('/order/my/list')) {
      return await MockDatabase.queryOrders(params);
    }

    // 配置查询
    if (method == 'GET' && path.contains('/configcommon/getbycode')) {
      return await MockDatabase.queryConfig(params);
    }

    // ========== 题库相关接口 (新路径) ==========

    // 学习数据查询
    if (method == 'GET' &&
        (path.contains('/tiku/exam/learning/data') ||
            path.contains('/exam/learningData'))) {
      return await MockDatabase.queryLearningData(params);
    }

    // 打卡接口
    if (method == 'POST' &&
        (path.contains('/tiku/exam/checkin/data') ||
            path.contains('/exam/checkinData'))) {
      return successResponse();
    }

    // 章节列表查询
    if (method == 'GET' &&
        (path.contains('/tiku/chapter/list') ||
            path.contains('/exam/chapter'))) {
      return await MockDatabase.queryChapters(params);
    }

    // 技能模拟查询
    if (method == 'GET' &&
        (path.contains('/tiku/homepage/recommend/chapterpackage') ||
            path.contains('/exam/chapterpackage'))) {
      return await MockDatabase.querySkillMock(params);
    }

    // 学习日历
    if (method == 'GET' && path.contains('/study/learning/calendar')) {
      return await MockDatabase.queryStudyCalendar(params);
    }

    // 指定日期的课节
    if (method == 'GET' && path.contains('/study/learning/lesson')) {
      return await MockDatabase.queryStudyLessons(params);
    }

    // 学习计划课程
    if (method == 'GET' && path.contains('/study/learning/plan')) {
      return await MockDatabase.queryStudyPlan(params);
    }

    // ========== 学习课程详情相关接口 ==========

    // 课程详情
    if (method == 'GET' &&
        path.contains('/study/learning/series') &&
        !path.contains('/goods') &&
        !path.contains('/recent')) {
      return await _getCourseDetail(params);
    }

    // 课程课节列表
    if (method == 'GET' && path.contains('/study/learning/series/goods')) {
      return await _getCourseLessons(params);
    }

    // 最近学习记录
    if (method == 'GET' && path.contains('/study/learning/series/recent')) {
      return await _getRecentlyData(params);
    }

    // 其他接口不使用动态查询
    return null;
  }

  /// 验证码登录 Mock 数据
  static Future<Map<String, dynamic>> _loginWithSms(
    Map<String, String> params,
  ) async {
    // 从 login_mock_data.dart 导入数据
    // 注意：这里需要导入 LoginMockData，但为了保持简洁，直接返回标准响应
    // 实际数据可以从 LoginMockData.smsLoginSuccess1 获取

    print('📱 Mock登录: phone=${params['phone']}, code=${params['code']}');

    // 返回标准登录成功响应
    return {
      "msg": ["操作成功"],
      "code": 100000,
      "data": {
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token_${DateTime.now().millisecondsSinceEpoch}",
        "nickname": "Mock用户",
        "avatar": "",
        "phone": params['phone'] ?? "13800138000",
        "student_id": "594244629616925424",
        "student_name": "未填写",
        "merchant": [
          {
            "merchant_id": "408559575579495187",
            "merchant_name": "牙开心",
            "brand_id": "408559632588540691",
            "brand_name": "牙开心",
          },
        ],
        "major_id": "524033912737962623",
        "major_name": "口腔执业医师",
        "employee_id": "0",
        "is_real_name": "2",
        "promoter_id": "594244629616925424",
        "promoter_type": "2",
        "post_type_level": null,
        "employee_info": {"employee_id": "0", "post_name": "", "org_name": ""},
        "is_new": "0",
      },
    };
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

  /// 获取课程详情
  static Future<Map<String, dynamic>> _getCourseDetail(
    Map<String, String> params,
  ) async {
    final teachingType = params['teaching_type'] ?? '3';
    final page = int.tryParse(params['page'] ?? '1') ?? 1;
    final size = int.tryParse(params['size'] ?? '10') ?? 10;

    print('📚 [我的课程Mock] teaching_type=$teachingType, page=$page, size=$size');

    // ✅ 完整的课程列表数据
    final allCourses = [
      {
        "goods_id": "593505082385898301",
        "goods_name": "2026口腔执业医师精品班（录播）",
        "goods_pid": "0",
        "goods_pid_name": "",
        "order_id": "ORD001",
        "teaching_type": "3",
        "teaching_type_name": "录播",
        "business_type": 1,
        "learn_progress": 45,
        "paper_goods_id": "593505082385898301",
        "order_goods_detail_id": "67890",
        "system_id": "1",
        "evaluation_type": [
          {
            "id": "1",
            "name": "课前测评",
            "paper_version_id": "1001",
            "professional_id": "524033912737962623",
          },
          {
            "id": "2",
            "name": "课后练习",
            "paper_version_id": "1002",
            "professional_id": "524033912737962623",
          },
        ],
        "class": {
          "class_id": "class_001",
          "name": "精品班A班",
          "date": "2024年10月-2025年6月",
          "teaching_type": "3",
          "teaching_type_name": "录播",
          "lesson_num": 120,
          "lesson_attendance_num": 54,
          "address": "",
          "teacher": [
            {
              "id": "1",
              "name": "张医生",
              "title": "主任医师",
              "avatar": "avatar1.png",
            },
            {
              "id": "2",
              "name": "李医生",
              "title": "副主任医师",
              "avatar": "avatar2.png",
            },
          ],
        },
      },
      {
        "goods_id": "593505082385898302",
        "goods_name": "护理综合能力提升班（直播）",
        "goods_pid": "0",
        "goods_pid_name": "",
        "order_id": "ORD002",
        "teaching_type": "1",
        "teaching_type_name": "直播",
        "business_type": 2,
        "learn_progress": 30,
        "paper_goods_id": "593505082385898302",
        "order_goods_detail_id": "67891",
        "system_id": "2",
        "evaluation_type": [
          {
            "id": "3",
            "name": "直播互动测验",
            "paper_version_id": "1003",
            "professional_id": "524033912737962623",
          },
        ],
        "class": {
          "class_id": "class_002",
          "name": "VIP直播班",
          "date": "2024年11月-2025年5月",
          "teaching_type": "1",
          "teaching_type_name": "直播",
          "lesson_num": 80,
          "lesson_attendance_num": 24,
          "address": "线上直播",
          "teacher": [
            {
              "id": "3",
              "name": "王老师",
              "title": "高级讲师",
              "avatar": "avatar3.png",
            },
          ],
        },
      },
      {
        "goods_id": "593505082385898303",
        "goods_name": "临床实操强化训练（录播）",
        "goods_pid": "0",
        "goods_pid_name": "",
        "order_id": "ORD003",
        "teaching_type": "3",
        "teaching_type_name": "录播",
        "business_type": 1,
        "learn_progress": 75,
        "paper_goods_id": "593505082385898303",
        "order_goods_detail_id": "67892",
        "system_id": "3",
        "evaluation_type": [],
        "class": {
          "class_id": "class_003",
          "name": "实操精品班",
          "date": "2024年9月-2025年3月",
          "teaching_type": "3",
          "teaching_type_name": "录播",
          "lesson_num": 60,
          "lesson_attendance_num": 45,
          "address": "",
          "teacher": [
            {
              "id": "4",
              "name": "赵老师",
              "title": "临床导师",
              "avatar": "avatar4.png",
            },
          ],
        },
      },
      {
        "goods_id": "593505082385898304",
        "goods_name": "口腔医学综合课程（录播）",
        "goods_pid": "593505082385898305",
        "goods_pid_name": "2025护考全程套餐",
        "order_id": "ORD004",
        "teaching_type": "3",
        "teaching_type_name": "录播",
        "business_type": 3,
        "learn_progress": 60,
        "paper_goods_id": "593505082385898304",
        "order_goods_detail_id": "67893",
        "system_id": "4",
        "evaluation_type": [
          {
            "id": "4",
            "name": "综合测评",
            "paper_version_id": "1004",
            "professional_id": "524033912737962623",
          },
        ],
        "class": {
          "class_id": "class_004",
          "name": "综合班",
          "date": "2024年12月-2025年8月",
          "teaching_type": "3",
          "teaching_type_name": "录播",
          "lesson_num": 100,
          "lesson_attendance_num": 60,
          "address": "",
          "teacher": [
            {
              "id": "5",
              "name": "钱老师",
              "title": "教授",
              "avatar": "avatar5.png",
            },
          ],
        },
      },
    ];

    // ✅ 根据 teaching_type 筛选（3=录播课, 1=直播课）
    final filteredCourses = allCourses
        .where((course) => course['teaching_type'] == teachingType)
        .toList();

    // ✅ 分页
    final start = (page - 1) * size;
    final end = start + size;
    final paginatedCourses = filteredCourses.sublist(
      start,
      end > filteredCourses.length ? filteredCourses.length : end,
    );

    print('   总数: ${filteredCourses.length}, 当前页: ${paginatedCourses.length}');

    return {
      "code": 100000,
      "msg": ["成功"],
      "data": {"list": paginatedCourses, "total": filteredCourses.length},
    };
  }

  /// 获取课程课节列表
  static Future<Map<String, dynamic>> _getCourseLessons(
    Map<String, String> params,
  ) async {
    return {
      "code": 100000,
      "msg": ["成功"],
      "data": {
        "list": [
          {
            "class_id": "1",
            "name": "基础阶段",
            "teaching_type": "1",
            "teaching_type_name": "直播",
            "lesson_num": 40,
            "lesson_attendance_num": 15,
            "address": "线上直播",
            "lesson": [
              {
                "lesson_id": "101",
                "lesson_name": "口腔解剖学",
                "lesson_name_other": "牙体解剖、颌面部解剖",
                "date": "2024-10-15 19:00-21:00",
                "teaching_type": "1",
                "status": "2",
                "lesson_status": "3",
                "evaluation_type_top": [
                  {"id": "1", "name": "课前作业", "paper_version_id": "123"},
                ],
                "resource_document": [
                  {
                    "id": "1",
                    "name": "口腔解剖学讲义.pdf",
                    "path": "https://example.com/lecture1.pdf",
                  },
                ],
                "evaluation_type_bottom": [
                  {
                    "id": "2",
                    "name": "课后独立测评",
                    "paper_version_id": "124",
                    "is_evaluation": "2",
                  },
                ],
              },
              {
                "lesson_id": "102",
                "lesson_name": "口腔组织病理学",
                "lesson_name_other": "牙体组织、口腔粘膜病理",
                "date": "2024-10-22 19:00-21:00",
                "teaching_type": "1",
                "status": "1",
                "lesson_status": "1",
                "evaluation_type_top": [],
              },
            ],
          },
          {
            "class_id": "2",
            "name": "提高阶段",
            "teaching_type": "3",
            "teaching_type_name": "录播",
            "lesson_num": 50,
            "lesson_attendance_num": 20,
            "address": "",
            "lesson": [
              {
                "lesson_id": "201",
                "lesson_name": "口腔内科学",
                "lesson_name_other": "龋病、牙髓病、根尖周病",
                "date": "随时观看",
                "teaching_type": "3",
                "status": "2",
                "lesson_status": "3",
                "evaluation_type_top": [],
              },
            ],
          },
        ],
      },
    };
  }

  /// 获取最近学习记录
  static Future<Map<String, dynamic>> _getRecentlyData(
    Map<String, String> params,
  ) async {
    return {
      "code": 100000,
      "msg": ["成功"],
      "data": {"lesson_id": "101", "lesson_name": "口腔解剖学"},
    };
  }
}
