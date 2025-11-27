import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/mock/mock_database.dart';

/// Mock 首页数据测试页面
/// 
/// 用于快速验证首页所有Mock数据是否正常
class MockHomeTestPage extends ConsumerStatefulWidget {
  const MockHomeTestPage({super.key});

  @override
  ConsumerState<MockHomeTestPage> createState() => _MockHomeTestPageState();
}

class _MockHomeTestPageState extends ConsumerState<MockHomeTestPage> {
  String _testResult = '点击按钮开始测试...';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock 首页数据测试'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 测试说明
            _buildSection(
              title: '测试说明',
              child: Text(
                '本页面用于测试首页所需的所有Mock数据接口\n'
                '包括：题库、网课、直播商品列表和配置接口',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 测试按钮
            _buildSection(
              title: '快速测试',
              child: Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  _buildTestButton('测试题库商品', _testTikuGoods),
                  _buildTestButton('测试网课商品', _testOnlineGoods),
                  _buildTestButton('测试直播商品', _testLiveGoods),
                  _buildTestButton('测试秒杀推荐', _testRecommendGoods),
                  _buildTestButton('测试Tab配置', _testTabConfig),
                  _buildTestButton('测试全部', _testAll),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // 测试结果
            _buildSection(
              title: '测试结果',
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SelectableText(
                        _testResult,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'monospace',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        child,
      ],
    );
  }

  Widget _buildTestButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      child: Text(label),
    );
  }

  // ========================================
  // 测试方法
  // ========================================

  /// 测试题库商品
  Future<void> _testTikuGoods() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试题库商品...';
    });

    try {
      final result = await MockDatabase.queryGoods({'type': '8,10,18'});
      final list = result['data']['list'] as List;

      setState(() {
        _testResult = '''
✅ 题库商品测试成功！

查询参数: type=8,10,18
返回数量: ${list.length} 条
预期数量: 7 条
是否匹配: ${list.length == 7 ? '✅ 是' : '❌ 否'}

商品列表:
${_formatGoodsList(list)}
''';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 测试失败: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 测试网课商品
  Future<void> _testOnlineGoods() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试网课商品...';
    });

    try {
      final result = await MockDatabase.queryGoods({
        'teaching_type': '3',
        'type': '2,3',
      });
      final list = result['data']['list'] as List;

      setState(() {
        _testResult = '''
✅ 网课商品测试成功！

查询参数: teaching_type=3, type=2,3
返回数量: ${list.length} 条
预期数量: 3 条
是否匹配: ${list.length == 3 ? '✅ 是' : '❌ 否'}

商品列表:
${_formatGoodsList(list)}
''';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 测试失败: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 测试直播商品
  Future<void> _testLiveGoods() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试直播商品...';
    });

    try {
      final result = await MockDatabase.queryGoods({
        'teaching_type': '1',
        'type': '2,3',
      });
      final list = result['data']['list'] as List;

      setState(() {
        _testResult = '''
✅ 直播商品测试成功！

查询参数: teaching_type=1, type=2,3
返回数量: ${list.length} 条
预期数量: 3 条
是否匹配: ${list.length == 3 ? '✅ 是' : '❌ 否'}

商品列表:
${_formatGoodsList(list)}
''';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 测试失败: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 测试秒杀推荐
  Future<void> _testRecommendGoods() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试秒杀推荐...';
    });

    try {
      final result = await MockDatabase.queryGoods({
        'is_homepage_recommend': '1',
        'permission_status': '2',
      });
      final list = result['data']['list'] as List;

      setState(() {
        _testResult = '''
✅ 秒杀推荐测试成功！

查询参数: is_homepage_recommend=1, permission_status=2
返回数量: ${list.length} 条
预期数量: 3 条（未购买的推荐商品）
是否匹配: ${list.length == 3 ? '✅ 是' : '❌ 否'}

商品列表:
${_formatGoodsList(list)}

倒计时数据:
${_formatSeckillCountdown(list)}
''';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 测试失败: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 测试Tab配置
  Future<void> _testTabConfig() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试Tab配置...';
    });

    try {
      final result = await MockDatabase.queryConfig({'code': 'PUBLISH'});
      final value = result['data'];

      setState(() {
        _testResult = '''
✅ Tab配置测试成功！

查询参数: code=PUBLISH
返回值: $value
预期值: "2"
是否匹配: ${value == '2' ? '✅ 是' : '❌ 否'}

配置说明:
- "1": 仅显示题库Tab
- "2": 显示题库+网课+直播三个Tab

当前配置: ${value == '1' ? '仅题库' : value == '2' ? '全部Tab' : '未知'}
''';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 测试失败: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 测试全部
  Future<void> _testAll() async {
    setState(() {
      _isLoading = true;
      _testResult = '正在测试全部接口...';
    });

    try {
      final results = <String>[];

      // 1. 测试题库
      final tiku = await MockDatabase.queryGoods({'type': '8,10,18'});
      final tikuList = tiku['data']['list'] as List;
      results.add('✅ 题库商品: ${tikuList.length} 条 (预期 7 条) ${tikuList.length == 7 ? '✅' : '❌'}');

      // 2. 测试网课
      final online = await MockDatabase.queryGoods({
        'teaching_type': '3',
        'type': '2,3',
      });
      final onlineList = online['data']['list'] as List;
      results.add('✅ 网课商品: ${onlineList.length} 条 (预期 3 条) ${onlineList.length == 3 ? '✅' : '❌'}');

      // 3. 测试直播
      final live = await MockDatabase.queryGoods({
        'teaching_type': '1',
        'type': '2,3',
      });
      final liveList = live['data']['list'] as List;
      results.add('✅ 直播商品: ${liveList.length} 条 (预期 3 条) ${liveList.length == 3 ? '✅' : '❌'}');

      // 4. 测试秒杀推荐
      final recommend = await MockDatabase.queryGoods({
        'is_homepage_recommend': '1',
        'permission_status': '2',
      });
      final recommendList = recommend['data']['list'] as List;
      results.add('✅ 秒杀推荐: ${recommendList.length} 条 (预期 3 条) ${recommendList.length == 3 ? '✅' : '❌'}');

      // 5. 测试配置
      final config = await MockDatabase.queryConfig({'code': 'PUBLISH'});
      final configValue = config['data'];
      results.add('✅ Tab配置: $configValue (预期 "2") ${configValue == '2' ? '✅' : '❌'}');

      // 汇总结果
      final allPassed = tikuList.length == 7 &&
          onlineList.length == 3 &&
          liveList.length == 3 &&
          recommendList.length == 3 &&
          configValue == '2';

      setState(() {
        _testResult = '''
${allPassed ? '🎉 全部测试通过！' : '⚠️ 部分测试未通过'}

测试结果汇总:
${results.join('\n')}

数据统计:
- 总商品数: ${MockDatabase.getGoodsCount()} 条
- 题库商品: ${tikuList.length} 条
- 网课商品: ${onlineList.length} 条
- 直播商品: ${liveList.length} 条
- 秒杀推荐: ${recommendList.length} 条

${allPassed ? '✅ Mock 数据完整，可以正常使用！' : '❌ Mock 数据不完整，请检查数据文件'}
''';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 测试失败: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ========================================
  // 辅助方法
  // ========================================

  String _formatGoodsList(List list) {
    return list.map((item) {
      final name = item['name'] ?? '';
      final type = item['type'] ?? '';
      final typeName = item['type_name'] ?? '';
      final teachingType = item['teaching_type'] ?? '';
      final price = item['sale_price'] ?? '';
      return '- $name\n  类型: type=$type ($typeName), teaching_type=$teachingType\n  价格: ¥$price';
    }).join('\n\n');
  }

  String _formatSeckillCountdown(List list) {
    return list.map((item) {
      final name = item['name'] ?? '';
      final countdown = item['seckill_countdown'];
      if (countdown == null) {
        return '- $name: 无倒计时';
      } else {
        final minutes = (countdown / 60).floor();
        return '- $name: ${countdown}秒 (${minutes}分钟)';
      }
    }).join('\n');
  }
}
