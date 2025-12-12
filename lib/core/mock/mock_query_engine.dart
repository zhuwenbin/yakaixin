/// Mock 查询引擎
///
/// 类似数据库查询，根据 URL 参数动态筛选 Mock 数据
///
/// 特性：
/// 1. Mock 数据存储完整数据集
/// 2. 根据请求参数动态筛选
/// 3. 支持多条件组合查询
/// 4. 支持排序、分页
class MockQueryEngine {
  /// 查询数据
  ///
  /// [dataSource] 完整数据集
  /// [queryParams] URL 查询参数
  /// [config] 查询配置(字段映射、默认值等)
  static List<Map<String, dynamic>> query({
    required List<Map<String, dynamic>> dataSource,
    required Map<String, dynamic> queryParams,
    QueryConfig? config,
  }) {
    List<Map<String, dynamic>> result = List.from(dataSource);

    // 1. 条件筛选
    result = _filterByParams(result, queryParams, config);

    // 2. 排序
    result = _sortByParams(result, queryParams, config);

    // 3. 分页
    result = _paginateByParams(result, queryParams, config);

    return result;
  }

  /// 条件筛选
  static List<Map<String, dynamic>> _filterByParams(
    List<Map<String, dynamic>> data,
    Map<String, dynamic> queryParams,
    QueryConfig? config,
  ) {
    return data.where((item) {
      // ✅ 特殊处理: is_buyed 参数（根据 permission_status 筛选）
      if (queryParams.containsKey('is_buyed')) {
        final isBuyed = queryParams['is_buyed']?.toString();
        final permissionStatus = item['permission_status']?.toString() ?? '';
        
        if (isBuyed == '1') {
          // is_buyed=1 表示已购买，permission_status 应该为 '1'
          if (permissionStatus != '1') {
            return false;
          }
        } else if (isBuyed == '0') {
          // is_buyed=0 表示未购买，permission_status 应该为 '2'
          if (permissionStatus != '2') {
            return false;
          }
        }
      }

      // 遍历所有查询参数
      for (final entry in queryParams.entries) {
        final paramKey = entry.key;
        final paramValue = entry.value?.toString() ?? '';

        // 跳过非筛选参数(如 page, pageSize, sort)
        if (_isNonFilterParam(paramKey)) continue;

        // ✅ 新增：模糊查询支持 (参数名以 _like 结尾)
        if (paramKey.endsWith('_like')) {
          final actualField = paramKey.replaceAll('_like', '');
          final actualValue = item[actualField]?.toString() ?? '';
          if (!actualValue.toLowerCase().contains(paramValue.toLowerCase())) {
            return false;
          }
          continue;
        }

        // ✅ 新增：范围查询支持 (最小值: _min)
        if (paramKey.endsWith('_min')) {
          final actualField = paramKey.replaceAll('_min', '');
          final actualValue =
              num.tryParse(item[actualField]?.toString() ?? '0') ?? 0;
          final minValue = num.tryParse(paramValue) ?? 0;
          if (actualValue < minValue) {
            return false;
          }
          continue;
        }

        // ✅ 新增：范围查询支持 (最大值: _max)
        if (paramKey.endsWith('_max')) {
          final actualField = paramKey.replaceAll('_max', '');
          final actualValue =
              num.tryParse(item[actualField]?.toString() ?? '0') ?? 0;
          final maxValue = num.tryParse(paramValue) ?? double.infinity;
          if (actualValue > maxValue) {
            return false;
          }
          continue;
        }

        // 获取字段映射(URL参数名 → 数据字段名)
        final fieldName = config?.fieldMapping?[paramKey] ?? paramKey;

        // 获取数据项的字段值
        final itemValue = item[fieldName]?.toString() ?? '';

        // 精确匹配
        if (paramValue.contains(',')) {
          // 支持逗号分隔的多值匹配 (如 type=8,10,18)
          final values = paramValue.split(',');
          if (!values.contains(itemValue)) {
            return false;
          }
        } else {
          // 单值精确匹配
          if (itemValue != paramValue) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }

  /// 排序
  static List<Map<String, dynamic>> _sortByParams(
    List<Map<String, dynamic>> data,
    Map<String, dynamic> queryParams,
    QueryConfig? config,
  ) {
    final sortBy = queryParams['sort']?.toString();
    final order = queryParams['order']?.toString() ?? 'asc';

    if (sortBy == null || sortBy.isEmpty) {
      return data;
    }

    data.sort((a, b) {
      final aValue = a[sortBy];
      final bValue = b[sortBy];

      int compareResult = 0;

      // 数字比较
      if (aValue is num && bValue is num) {
        compareResult = aValue.compareTo(bValue);
      }
      // 字符串比较
      else {
        compareResult = aValue.toString().compareTo(bValue.toString());
      }

      // 降序
      return order == 'desc' ? -compareResult : compareResult;
    });

    return data;
  }

  /// 分页
  static List<Map<String, dynamic>> _paginateByParams(
    List<Map<String, dynamic>> data,
    Map<String, dynamic> queryParams,
    QueryConfig? config,
  ) {
    final page = int.tryParse(queryParams['page']?.toString() ?? '1') ?? 1;
    final pageSize =
        int.tryParse(queryParams['page_size']?.toString() ?? '20') ?? 20;

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= data.length) {
      return [];
    }

    return data.sublist(
      startIndex,
      endIndex > data.length ? data.length : endIndex,
    );
  }

  /// 非筛选参数(用于排序、分页等)
  static bool _isNonFilterParam(String key) {
    const nonFilterParams = [
      // 分页和排序
      'page', 'page_size', 'pageSize', 'sort', 'order',
      // 业务标识参数（不用于筛选）
      'shelf_platform_id', 'professional_id',
      // ⚠️ is_buyed 已在 _filterByParams 中特殊处理，不能添加到此列表
      'platform_id', 'merchant_id', 'brand_id', 'channel_id', 'extend_uid',
      // 用户相关参数（不用于筛选）
      'user_id', 'student_id',
      // 其他非筛选参数
      'no_professional_id', 'no_user_id',
    ];
    return nonFilterParams.contains(key);
  }

  /// 构建完整响应(包含分页信息)
  static Map<String, dynamic> buildResponse({
    required List<Map<String, dynamic>> allData,
    required List<Map<String, dynamic>> filteredData,
    required Map<String, dynamic> queryParams,
  }) {
    final page = int.tryParse(queryParams['page']?.toString() ?? '1') ?? 1;
    final pageSize =
        int.tryParse(queryParams['page_size']?.toString() ?? '20') ?? 20;

    return {
      'code': 100000,
      'msg': ['操作成功'],
      'data': {
        'list': filteredData,
        'total': allData.length,
        'page': page,
        'page_size': pageSize,
        'total_pages': (allData.length / pageSize).ceil(),
      },
    };
  }
}

/// 查询配置
class QueryConfig {
  /// 字段映射 (URL参数名 → 数据字段名)
  /// 例如: {'type' → 'goods_type', 'status' → 'order_status'}
  final Map<String, String>? fieldMapping;

  /// 默认排序字段
  final String? defaultSort;

  /// 默认分页大小
  final int? defaultPageSize;

  const QueryConfig({
    this.fieldMapping,
    this.defaultSort,
    this.defaultPageSize,
  });
}
