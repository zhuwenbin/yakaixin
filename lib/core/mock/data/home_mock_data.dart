/// 首页Mock数据
/// 
/// 对应小程序页面：index/index.vue
/// 数据来源：基于小程序页面分析
class MockHomeData {
  /// Banner列表
  /// 对应接口：/api/home/banner
  static final List<Map<String, dynamic>> bannerList = [
    {
      'id': '1',
      'image': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/banner1.jpg',
      'url': '',
      'type': 1, // 1-外部链接 2-商品详情
    },
    {
      'id': '2',
      'image': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/banner2.jpg',
      'url': '',
      'type': 1,
    },
  ];

  /// 商品列表
  /// 对应接口：/api/goods/list
  static final List<Map<String, dynamic>> goodsList = [
    {
      'goods_id': '1',
      'goods_name': '2024年口腔执业医师精讲题库',
      'type': 18, // 18-题库
      'cover': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/goods1.jpg',
      'price': '¥299',
      'original_price': '¥599',
    },
    {
      'goods_id': '2',
      'goods_name': '口腔执业医师精品课程',
      'type': 2, // 2-课程
      'cover': 'https://yakaixin.oss-cn-beijing.aliyuncs.com/goods2.jpg',
      'price': '¥1999',
      'original_price': '¥3999',
    },
  ];
}
