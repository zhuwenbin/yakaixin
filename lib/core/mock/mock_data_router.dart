import 'mock_database.dart';

/// Mock数据路由器
/// 
/// 支持两种模式:
/// 1. 静态数据模式: 从 mock_data.dart 获取预定义数据
/// 2. 动态查询模式: 从 mock_database.dart 动态查询(类似数据库)
class MockDataRouter {
  /// 根据URL路径和方法获取Mock数据
  static Future<Map<String, dynamic>?> getMockData(String url, String method) async {
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
    // 商品列表查询 (首页、题库、网课、直播)
    if (method == 'GET' && (path.contains('/goods/v2') || path.contains('/goods'))) {
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
    
    // 学习数据查询
    if (method == 'GET' && path.contains('/exam/learningData')) {
      return await MockDatabase.queryLearningData(params);
    }
    
    // 章节列表查询
    if (method == 'GET' && path.contains('/exam/chapter')) {
      return await MockDatabase.queryChapters(params);
    }
    
    // 技能模拟查询
    if (method == 'GET' && path.contains('/exam/chapterpackage')) {
      return await MockDatabase.querySkillMock(params);
    }
    
    // 打卡接口
    if (method == 'POST' && path.contains('/exam/checkinData')) {
      return await MockDatabase.checkin(params);
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
    
    // 其他接口不使用动态查询
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
