/// 商品详情Mock数据
/// 
/// 对应小程序页面：test/detail.vue
/// 数据来源：基于小程序页面分析
class MockGoodsData {
  /// 商品详情Mock数据
  /// 
  /// 对应小程序页面：test/detail.vue
  /// 对应接口：/api/goods/detail
  /// 
  /// 字段说明：
  /// - type: 商品类型（18-题库, 8-试卷, 10-模拟考试, 2/3-课程）
  /// - permission_status: 权限状态（1-已购买, 2-未购买）
  static final Map<String, dynamic> goodsDetail = {
    'id': '123',
    'goods_id': '123',
    'goods_name': '2024年口腔执业医师精讲题库',
    'type': 18, // 18-题库
    'permission_status': '2', // 2-未购买
    'material_cover_path': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/test/cover.jpg',
    'num_text': '3580道题',
    'year': '2024年',
    'professional_id': '524033912737962623',
    'price': '¥299',
    'original_price': '¥599',
    'tiku_goods_details': {
      'question_num': 3580,
      'chapter_num': 15,
    },
    'introduction': '包含口腔执业医师考试所有考点，精选历年真题和模拟题',
  };

  /// 已购买状态的商品详情
  static final Map<String, dynamic> goodsDetailPurchased = {
    ...goodsDetail,
    'permission_status': '1', // 1-已购买
  };

  /// 根据参数返回对应状态的数据
  static Map<String, dynamic> getGoodsDetail({bool isPurchased = false}) {
    return isPurchased ? goodsDetailPurchased : goodsDetail;
  }
}
