import 'dart:convert';
import 'package:flutter/services.dart';
import 'mock_query_engine.dart';

/// Mock 数据库（从 JSON 文件加载）
/// 
/// 零依赖方案：使用 assets 中的 JSON 文件存储数据
/// 开发阶段可手动编辑 JSON 文件，生产环境不打包
class MockDatabase {
  // JSON 数据缓存
  static List<Map<String, dynamic>>? _goodsTable;
  static List<Map<String, dynamic>>? _orderTable;
  static Map<String, dynamic>? _configTable;
  static List<Map<String, dynamic>>? _learningDataTable;
  static List<Map<String, dynamic>>? _chapterTable;
  static List<Map<String, dynamic>>? _dailyPracticeTable;
  static List<Map<String, dynamic>>? _skillMockTable;
  static Map<String, dynamic>? _studyDataTable;
  
  // 是否已初始化
  static bool _initialized = false;
  
  // 初始化锁，防止并发初始化
  static Future<void>? _initFuture;
  
  /// 初始化数据库（从 JSON 文件加载）
  static Future<void> init() async {
    if (_initialized) return;
    
    // 如果正在初始化，等待完成
    if (_initFuture != null) {
      await _initFuture;
      return;
    }
    
    // 开始初始化
    _initFuture = _performInit();
    await _initFuture;
    _initFuture = null;
  }
  
  /// 执行实际的初始化
  static Future<void> _performInit() async {
    if (_initialized) return;
    
    print('🗄️ 初始化 Mock 数据库...');
    
    try {
      // 加载商品数据
      final goodsJson = await rootBundle.loadString('assets/mock/goods_data.json');
      final goodsData = jsonDecode(goodsJson) as Map<String, dynamic>;
      _goodsTable = (goodsData['data'] as List).cast<Map<String, dynamic>>();
      print('   ✅ 商品数据加载成功: ${_goodsTable!.length} 条');
      
      // 加载订单数据
      final orderJson = await rootBundle.loadString('assets/mock/order_data.json');
      final orderData = jsonDecode(orderJson) as Map<String, dynamic>;
      _orderTable = (orderData['data'] as List).cast<Map<String, dynamic>>();
      print('   ✅ 订单数据加载成功: ${_orderTable!.length} 条');
      
      // 加载配置数据
      final configJson = await rootBundle.loadString('assets/mock/config_data.json');
      final configData = jsonDecode(configJson) as Map<String, dynamic>;
      _configTable = configData['data'] as Map<String, dynamic>;
      print('   ✅ 配置数据加载成功: ${_configTable!.length} 项');
      
      // 加载学习数据
      final learningJson = await rootBundle.loadString('assets/mock/learning_data.json');
      final learningData = jsonDecode(learningJson) as Map<String, dynamic>;
      _learningDataTable = (learningData['data'] as List).cast<Map<String, dynamic>>();
      print('   ✅ 学习数据加载成功: ${_learningDataTable!.length} 条');
      
      // 加载章节数据
      final chapterJson = await rootBundle.loadString('assets/mock/chapter_data.json');
      final chapterData = jsonDecode(chapterJson) as Map<String, dynamic>;
      _chapterTable = (chapterData['data'] as List).cast<Map<String, dynamic>>();
      print('   ✅ 章节数据加载成功: ${_chapterTable!.length} 条');
      
      // 加载每日一测数据
      final dailyJson = await rootBundle.loadString('assets/mock/daily_practice_data.json');
      final dailyData = jsonDecode(dailyJson) as Map<String, dynamic>;
      _dailyPracticeTable = (dailyData['data'] as List).cast<Map<String, dynamic>>();
      print('   ✅ 每日一测数据加载成功: ${_dailyPracticeTable!.length} 条');
      
      // 加载技能模拟数据
      final skillJson = await rootBundle.loadString('assets/mock/skill_mock_data.json');
      final skillData = jsonDecode(skillJson) as Map<String, dynamic>;
      _skillMockTable = (skillData['data'] as List).cast<Map<String, dynamic>>();
      print('   ✅ 技能模拟数据加载成功: ${_skillMockTable!.length} 条');
      
      // 加载学习中心数据（calendar/lessons/plan）
      final studyJson = await rootBundle.loadString('assets/mock/study_data.json');
      final studyData = jsonDecode(studyJson) as Map<String, dynamic>;
      _studyDataTable = studyData['data'] as Map<String, dynamic>;
      print('   ✅ 学习中心数据加载成功: ${_studyDataTable!.keys.length} 项');
      
      _initialized = true;
    } catch (e) {
      print('   ❌ Mock 数据库初始化失败: $e');
      // 初始化为空列表，避免崩溃
      _goodsTable = [];
      _orderTable = [];
      _configTable = {};
      _learningDataTable = [];
      _chapterTable = [];
      _dailyPracticeTable = [];
      _skillMockTable = [];
      _studyDataTable = {};
      _initialized = true;
    }
  }
  
  // ========================================
  // 查询接口 (动态查询)
  // ========================================
  
  /// 查询商品列表
  /// 
  /// 支持参数:
  /// - type: 商品类型 (支持逗号分隔: 8,10,18)
  /// - teaching_type: 授课类型 (1=直播, 3=录播)
  /// - permission_status: 权限状态 (1=已购买, 2=未购买)
  /// - is_homepage_recommend: 是否首页推荐 (1=是)
  /// - name_like: 商品名称模糊查询
  /// - sale_price_min, sale_price_max: 价格范围
  /// - sort: 排序字段 (create_time, student_num, sale_price)
  /// - order: 排序方式 (asc, desc)
  /// - page: 页码
  /// - page_size: 每页数量
  static Future<Map<String, dynamic>> queryGoods(Map<String, dynamic> params) async {
    // 确保已初始化
    await init();
    
    print('🗄️ Mock数据库查询 - 商品列表');
    print('   查询参数: $params');
    
    // 使用查询引擎筛选数据
    final filteredData = MockQueryEngine.query(
      dataSource: _goodsTable!,
      queryParams: params,
    );
    
    print('   查询结果: ${filteredData.length} 条 / 总计 ${_goodsTable!.length} 条');
    
    // 构建响应
    return MockQueryEngine.buildResponse(
      allData: filteredData,
      filteredData: filteredData,
      queryParams: params,
    );
  }
  
  /// 查询订单列表
  /// 
  /// 支持参数:
  /// - status: 订单状态 (0=全部, 1=待支付, 2=已支付, 3=已取消)
  /// - goods_type: 商品类型
  /// - pay_type: 支付方式 (1=微信, 2=支付宝)
  /// - start_time: 开始时间
  /// - end_time: 结束时间
  /// - sort: 排序字段
  /// - order: 排序方式
  /// - page: 页码
  /// - page_size: 每页数量
  static Future<Map<String, dynamic>> queryOrders(Map<String, dynamic> params) async {
    // 确保已初始化
    await init();
    
    print('🗄️ Mock数据库查询 - 订单列表');
    print('   查询参数: $params');
    
    // 特殊处理: status=0 表示查询全部
    final queryParams = Map<String, dynamic>.from(params);
    if (queryParams['status'] == '0') {
      queryParams.remove('status');
    }
    
    // 使用查询引擎筛选数据
    final filteredData = MockQueryEngine.query(
      dataSource: _orderTable!,
      queryParams: queryParams,
    );
    
    print('   查询结果: ${filteredData.length} 条 / 总计 ${_orderTable!.length} 条');
    
    return MockQueryEngine.buildResponse(
      allData: filteredData,
      filteredData: filteredData,
      queryParams: params,
    );
  }
  
  /// 查询配置
  /// 
  /// 参数:
  /// - code: 配置代码 (如 PUBLISH)
  static Future<Map<String, dynamic>> queryConfig(Map<String, dynamic> params) async {
    // 确保已初始化
    await init();
    
    final code = params['code'] as String?;
    print('🗄️ Mock数据库查询 - 配置');
    print('   配置代码: $code');
    
    if (code == null || !_configTable!.containsKey(code)) {
      print('   ❌ 配置不存在');
      return {
        'code': 0,
        'msg': '配置不存在',
        'data': null,
      };
    }
    
    final config = _configTable![code] as Map<String, dynamic>;
    final value = config['value'];
    
    print('   查询结果: $value');
    
    return {
      'code': 200,
      'msg': 'success',
      'data': value,
    };
  }
  
  // ========================================
  // 辅助方法
  // ========================================
  
  /// 获取商品总数
  static int getGoodsCount() => _goodsTable?.length ?? 0;
  
  /// 获取订单总数
  static int getOrderCount() => _orderTable?.length ?? 0;
  
  /// 查询学习数据
  /// 
  /// 参数:
  /// - professional_id: 专业ID
  static Future<Map<String, dynamic>> queryLearningData(Map<String, dynamic> params) async {
    await init();
    
    final professionalId = params['professional_id'] as String?;
    print('🗄️ Mock数据库查询 - 学习数据');
    print('   专业ID: $professionalId');
    
    // 根据专业ID筛选
    final filteredData = _learningDataTable!.where((item) {
      return item['professional_id'] == professionalId;
    }).toList();
    
    print('   查询结果: ${filteredData.length} 条');
    
    if (filteredData.isEmpty) {
      return {
        'code': 100000,
        'msg': 'success',
        'data': {
          'checkin_num': 0,
          'total_num': 0,
          'correct_rate': '0',
          'is_checkin': 0,
          'continuous_days': 0,
          'wrong_num': 0,
          'collect_num': 0,
        },
      };
    }
    
    return {
      'code': 100000,
      'msg': 'success',
      'data': filteredData[0],
    };
  }
  
  /// 查询章节列表
  /// 
  /// 参数:
  /// - professional_id: 专业ID
  static Future<Map<String, dynamic>> queryChapters(Map<String, dynamic> params) async {
    await init();
    
    final professionalId = params['professional_id'] as String?;
    print('🗄️ Mock数据库查询 - 章节列表');
    print('   专业ID: $professionalId');
    
    // 根据专业ID筛选
    final filteredData = _chapterTable!.where((item) {
      return item['professional_id'] == professionalId;
    }).toList();
    
    print('   查询结果: ${filteredData.length} 条');
    
    return {
      'code': 100000,
      'msg': 'success',
      'data': filteredData,
    };
  }
  
  /// 查询课程章节数据
  /// 
  /// 对应接口: GET /c/goods/v2/chapter
  /// 对应小程序: chapterpaper (courseDetail.vue:342-356)
  /// 参数:
  ///   - goods_id: 课程商品ID
  ///   - no_professional_id: 不筛选专业ID (固定"1")
  ///   - no_user_id: 不筛选用户ID (固定"1")
  static Future<Map<String, dynamic>> queryCourseChapters(Map<String, dynamic> params) async {
    await init();
    
    final goodsId = params['goods_id'] as String?;
    print('🗄️ Mock数据库查询 - 课程章节');
    print('   商品ID: $goodsId');
    
    // ✅ Mock数据: 返回课程章节列表
    // 对应小程序返回结构: res.data (Array)
    final mockChapters = [
      {
        'id': '1',
        'name': '第一章 口腔解剖生理学',
        'sections': [
          {
            'id': '1-1',
            'name': '1.1 牙体组织',
            'time': '00:15:30',
            'is_trial_listening': 1, // 1=可以试听, 0=不可以
            'video_url': '',
          },
          {
            'id': '1-2',
            'name': '1.2 牙髓组织',
            'time': '00:20:15',
            'is_trial_listening': 0,
            'video_url': '',
          },
        ],
      },
      {
        'id': '2',
        'name': '第二章 口腔预防医学',
        'sections': [
          {
            'id': '2-1',
            'name': '2.1 龋病预防',
            'time': '00:18:45',
            'is_trial_listening': 0,
            'video_url': '',
          },
          {
            'id': '2-2',
            'name': '2.2 牙周病预防',
            'time': '00:22:30',
            'is_trial_listening': 0,
            'video_url': '',
          },
        ],
      },
      {
        'id': '3',
        'name': '第三章 口腔修复学',
        'sections': [
          {
            'id': '3-1',
            'name': '3.1 牙体缺损修复',
            'time': '00:25:00',
            'is_trial_listening': 0,
            'video_url': '',
          },
        ],
      },
    ];
    
    print('   查询结果: ${mockChapters.length} 章');
    
    return {
      'code': 100000,
      'msg': '操作成功',
      'data': mockChapters,
    };
  }
  
  /// 查询每日一测
  /// 
  /// 参数:
  /// - professional_id: 专业ID
  /// - position_identify: 位置标识 (daily30)
  static Future<Map<String, dynamic>> queryDailyPractice(Map<String, dynamic> params) async {
    await init();
    
    final professionalId = params['professional_id'] as String?;
    final positionIdentify = params['position_identify'] as String?;
    print('🗄️ Mock数据库查询 - 每日一测');
    print('   专业ID: $professionalId, 位置标识: $positionIdentify');
    
    // 根据专业ID和位置标识筛选
    final filteredData = _dailyPracticeTable!.where((item) {
      final matchProfessional = professionalId == null || item['professional_id'] == professionalId;
      final matchPosition = positionIdentify == null || item['position_identify'] == positionIdentify;
      return matchProfessional && matchPosition;
    }).toList();
    
    print('   查询结果: ${filteredData.length} 条');
    
    return {
      'code': 100000,
      'msg': 'success',
      'data': {'list': filteredData},
    };
  }
  
  /// 查询技能模拟
  /// 
  /// 参数:
  /// - professional_id: 专业ID
  /// - position_identify: 位置标识 (jinengmoni)
  static Future<Map<String, dynamic>> querySkillMock(Map<String, dynamic> params) async {
    await init();
    
    final professionalId = params['professional_id'] as String?;
    final positionIdentify = params['position_identify'] as String?;
    print('🗄️ Mock数据库查询 - 技能模拟');
    print('   专业ID: $professionalId, 位置标识: $positionIdentify');
    
    // 根据专业ID和位置标识筛选
    final filteredData = _skillMockTable!.where((item) {
      final matchProfessional = professionalId == null || item['professional_id'] == professionalId;
      final matchPosition = positionIdentify == null || item['position_identify'] == positionIdentify;
      return matchProfessional && matchPosition;
    }).toList();
    
    print('   查询结果: ${filteredData.length} 条');
    
    if (filteredData.isEmpty) {
      return {
        'code': 100000,
        'msg': 'success',
        'data': {'id': 0}, // 没有技能模拟
      };
    }
    
    return {
      'code': 100000,
      'msg': 'success',
      'data': filteredData[0],
    };
  }
  
  /// 打卡接口
  /// 
  /// 参数:
  /// - professional_id: 专业ID
  static Future<Map<String, dynamic>> checkin(Map<String, dynamic> params) async {
    await init();
    
    final professionalId = params['professional_id'] as String?;
    print('🗄️ Mock数据库 - 打卡');
    print('   专业ID: $professionalId');
    
    // 模拟打卡成功，更新 is_checkin 状态
    final index = _learningDataTable!.indexWhere((item) {
      return item['professional_id'] == professionalId;
    });
    
    if (index != -1) {
      _learningDataTable![index]['is_checkin'] = 1;
      _learningDataTable![index]['checkin_num'] = (_learningDataTable![index]['checkin_num'] as int) + 1;
    }
    
    return {
      'code': 100000,
      'msg': '打卡成功',
      'data': null,
    };
  }
  
  /// 重新加载数据（用于热更新 JSON 文件）
  static Future<void> reload() async {
    print('🔄 重新加载 Mock 数据库...');
    _initialized = false;
    _initFuture = null;  // 重置初始化锁
    
    // 清空数据缓存
    _goodsTable = null;
    _orderTable = null;
    _configTable = null;
    _learningDataTable = null;
    _chapterTable = null;
    _dailyPracticeTable = null;
    _skillMockTable = null;
    _studyDataTable = null;
    
    await init();
  }
  
  // ========================================
  // 学习中心查询接口
  // ========================================
  
  /// 查询学习日历
  /// 
  /// 对应接口: GET /c/study/learning/calendar
  /// 参数:
  /// - start_date: 开始日期 (yyyy-MM-dd)
  /// - end_date: 结束日期 (yyyy-MM-dd)
  static Future<Map<String, dynamic>> queryStudyCalendar(Map<String, dynamic> params) async {
    await init();
    
    print('🗄️ Mock数据库查询 - 学习日历');
    print('   查询参数: $params');
    
    final calendarData = _studyDataTable!['calendar'] as List;
    
    // 如果有日期范围参数，可以筛选
    // 这里暂时返回所有数据
    
    return {
      'code': 100000,
      'msg': 'success',
      'data': calendarData,
    };
  }
  
  /// 查询指定日期的课节
  /// 
  /// 对应接口: GET /c/study/learning/lesson
  /// 参数:
  /// - date: 日期 (yyyy-MM-dd)
  static Future<Map<String, dynamic>> queryStudyLessons(Map<String, dynamic> params) async {
    await init();
    
    print('🗄️ Mock数据库查询 - 课节列表');
    print('   查询参数: $params');
    
    final lessonResponse = _studyDataTable!['lesson_response'] as Map<String, dynamic>;
    
    // 这里可以根据日期筛选，暂时返回所有数据
    return {
      'code': 100000,
      'msg': 'success',
      'data': lessonResponse,
    };
  }
  
  /// 查询学习计划课程
  /// 
  /// 对应接口: GET /c/study/learning/plan
  /// 参数:
  /// - teaching_type: 授课形式 ('': 全部, '1': 直播, '2': 面授, '3': 录播)
  /// - date: 日期 (yyyy-MM-dd)
  static Future<Map<String, dynamic>> queryStudyPlan(Map<String, dynamic> params) async {
    await init();
    
    print('🗄️ Mock数据库查询 - 学习计划');
    print('   查询参数: $params');
    
    final teachingType = params['teaching_type'] as String?;
    final allCourses = _studyDataTable!['plan_courses'] as List;
    
    // 根据授课形式筛选
    List filteredCourses;
    if (teachingType == null || teachingType.isEmpty) {
      // 全部
      filteredCourses = allCourses;
    } else {
      // 筛选指定授课形式
      filteredCourses = allCourses.where((course) {
        return course['teaching_type'] == teachingType;
      }).toList();
    }
    
    print('   查询结果: ${filteredCourses.length} 条 / 总计 ${allCourses.length} 条');
    
    return {
      'code': 100000,
      'msg': 'success',
      'data': filteredCourses,
    };
  }
}
