import 'package:flutter/material.dart';

/// P3-2 模考详情 - 模考信息
/// 对应小程序: pages/modelExaminationCompetition/examInfo
/// 
/// 参数:
/// - productId: 商品ID
/// - title: 商品标题
/// - page: 来源页面 ('home')
class ExamInfoPage extends StatelessWidget {
  final String? productId;
  final String? title;
  final String? page;
  
  const ExamInfoPage({
    super.key,
    this.productId,
    this.title,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '模考详情')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('模考信息页面'),
            const SizedBox(height: 16),
            Text('商品ID: ${productId ?? "未知"}'),
            Text('来源: ${page ?? "未知"}'),
            const SizedBox(height: 32),
            const Text(
              '📝 待实现功能:\n- 模考信息展示\n- 考试须知\n- 开始考试按钮',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
