/// 订单相关Mock数据
/// 
/// 对应小程序: src/modules/jintiku/pages/test/order.vue
/// 对应小程序: src/modules/jintiku/components/commen/order-list.vue
/// API接口: GET /c/order/my/list
class MockOrderData {
  /// 订单列表
  /// 对应小程序: order-list.vue的订单数据
  /// 
  /// 订单状态分布：
  /// - status=2 (已支付): 3个订单
  /// - status=1 (待支付): 2个订单（1个有倒计时，1个即将超时）
  /// - status=4 (已取消): 2个订单
  static final List<Map<String, dynamic>> orderList = [
    // ========== 已支付订单 (status=2) ==========
    {
      'id': '523456789012345678',
      'order_id': '523456789012345678',
      'order_no': 'ORD202501250001',
      'goods_id': '408559632588540691',
      'goods_name': '2024年口腔执业医师精讲题库',
      'goods_type': '18', // 18=题库
      'status': '2', // 2=已支付
      'status_name': '已支付',
      'payable_amount': '299.00',
      'countdown': 0,
      'flow_id': 'flow_123456',
      'professional_id_name': '口腔执业医师',
      'months': 12,
      'tiku_goods_details': {
        'question_num': 5000,
        'paper_num': 0,
        'exam_round_num': 0,
      },
      'teaching_system': {
        'system_id_name': '系统精讲',
      },
    },
    {
      'id': '523456789012345681',
      'order_id': '523456789012345681',
      'order_no': 'ORD202501100004',
      'goods_id': '408559632588540694',
      'goods_name': '口腔执业医师章节练习',
      'goods_type': '18',
      'status': '2', // 2=已支付
      'status_name': '已支付',
      'payable_amount': '399.00',
      'countdown': 0,
      'flow_id': 'flow_123459',
      'professional_id_name': '口腔执业医师',
      'months': 12,
      'tiku_goods_details': {
        'question_num': 3000,
        'paper_num': 0,
        'exam_round_num': 0,
      },
      'teaching_system': {
        'system_id_name': '章节练习',
      },
    },
    {
      'id': '523456789012345685',
      'order_id': '523456789012345685',
      'order_no': 'ORD202501050008',
      'goods_id': '408559632588540698',
      'goods_name': '临床执业医师冲刺题库',
      'goods_type': '18',
      'status': '2', // 2=已支付
      'status_name': '已支付',
      'payable_amount': '199.00',
      'countdown': 0,
      'flow_id': 'flow_123463',
      'professional_id_name': '临床执业医师',
      'months': 6,
      'tiku_goods_details': {
        'question_num': 2000,
        'paper_num': 0,
        'exam_round_num': 0,
      },
      'teaching_system': {
        'system_id_name': '冲刺训练',
      },
    },
    
    // ========== 待支付订单 (status=1) ==========
    {
      'id': '523456789012345679',
      'order_id': '523456789012345679',
      'order_no': 'ORD202501200002',
      'goods_id': '408559632588540692',
      'goods_name': '口腔执业医师全真模拟试卷',
      'goods_type': '8', // 8=试卷
      'status': '1', // 1=待支付
      'status_name': '待支付',
      'payable_amount': '199.00',
      'countdown': 7200, // 倒计时2小时
      'flow_id': 'flow_123457',
      'professional_id_name': '口腔执业医师',
      'months': 6,
      'tiku_goods_details': {
        'question_num': 0,
        'paper_num': 20,
        'exam_round_num': 0,
      },
      'teaching_system': {
        'system_id_name': '全真模拟',
      },
    },
    {
      'id': '523456789012345682',
      'order_id': '523456789012345682',
      'order_no': 'ORD202501220005',
      'goods_id': '408559632588540695',
      'goods_name': '护士资格考试题库',
      'goods_type': '18',
      'status': '1', // 1=待支付
      'status_name': '待支付',
      'payable_amount': '99.00',
      'countdown': 300, // 倒计时5分钟（即将超时）
      'flow_id': 'flow_123460',
      'professional_id_name': '护士资格',
      'months': 3,
      'tiku_goods_details': {
        'question_num': 1500,
        'paper_num': 0,
        'exam_round_num': 0,
      },
      'teaching_system': {
        'system_id_name': '基础题库',
      },
    },
    
    // ========== 已取消订单 (status=4) ==========
    {
      'id': '523456789012345680',
      'order_id': '523456789012345680',
      'order_no': 'ORD202501150003',
      'goods_id': '408559632588540693',
      'goods_name': '口腔执业医师模考大赛',
      'goods_type': '10', // 10=模考
      'status': '4', // 4=已取消
      'status_name': '已取消',
      'payable_amount': '1999.00',
      'countdown': 0,
      'flow_id': 'flow_123458',
      'professional_id_name': '口腔执业医师',
      'months': 0, // 0=永久
      'tiku_goods_details': {
        'question_num': 0,
        'paper_num': 0,
        'exam_round_num': 3,
        'exam_time': '2025-03-01 09:00:00',
      },
      'teaching_system': {
        'system_id_name': '',
      },
    },
    {
      'id': '523456789012345683',
      'order_id': '523456789012345683',
      'order_no': 'ORD202501180006',
      'goods_id': '408559632588540696',
      'goods_name': '中医执业医师试卷包',
      'goods_type': '8',
      'status': '4', // 4=已取消
      'status_name': '已取消',
      'payable_amount': '299.00',
      'countdown': 0,
      'flow_id': 'flow_123461',
      'professional_id_name': '中医执业医师',
      'months': 6,
      'tiku_goods_details': {
        'question_num': 0,
        'paper_num': 30,
        'exam_round_num': 0,
      },
      'teaching_system': {
        'system_id_name': '全真模拟',
      },
    },
  ];

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
}
