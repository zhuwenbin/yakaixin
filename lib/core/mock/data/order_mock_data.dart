/// 订单相关Mock数据
/// 
/// 对应小程序页面：order/paySuccess.vue
/// 数据来源：基于小程序页面分析
class MockOrderData {
  /// 支付成功页面商品信息
  /// 
  /// 对应小程序页面：order/paySuccess.vue
  static final Map<String, dynamic> paySuccessGoodsInfo = {
    'order_id': 'order_20250125001',
    'goods_id': '123',
    'goods_name': '2024年口腔执业医师精讲题库',
    'type': 18, // 18-题库
    'cover': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/test/cover.jpg',
    'price': '¥299',
    'pay_time': '2025-01-25 14:30:00',
    'status': 1, // 1-支付成功
  };

  /// 订单列表
  static final List<Map<String, dynamic>> orderList = [
    {
      'order_id': 'order_20250125001',
      'goods_name': '2024年口腔执业医师精讲题库',
      'price': '¥299',
      'status': 1, // 1-已支付
      'create_time': '2025-01-25 14:30:00',
    },
    {
      'order_id': 'order_20250120001',
      'goods_name': '口腔执业医师精品课程',
      'price': '¥1999',
      'status': 0, // 0-待支付
      'create_time': '2025-01-20 10:15:00',
    },
  ];
}
