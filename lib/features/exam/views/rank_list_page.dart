import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yakaixin_app/core/network/dio_client.dart';
import 'package:yakaixin_app/features/exam/widgets/rank_header.dart';
import '../../../app/config/api_config.dart';

/// 排行榜页面 - 对应小程序 test/rankList.vue
/// 功能：显示试卷成绩排行榜，前3名在头部，其余列表显示
class RankListPage extends ConsumerStatefulWidget {
  final String paperVersionId;
  final String goodsId;

  const RankListPage({
    super.key,
    required this.paperVersionId,
    required this.goodsId,
  });

  @override
  ConsumerState<RankListPage> createState() => _RankListPageState();
}

class _RankListPageState extends ConsumerState<RankListPage> {
  // ✅ 排行榜数据
  final List<Map<String, dynamic>> _list = [];
  final List<Map<String, dynamic>> _threeRankData = [];
  
  int _page = 1;
  final int _pageSize = 20;
  bool _loading = false;
  bool _isEnd = false;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadRankData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动监听 - 对应小程序 Line 117-125
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_loading && !_isEnd) {
        _page += 1;
        _loadRankData();
      }
    }
  }

  /// 加载排行榜数据 - 对应小程序 Line 67-105
  /// API: index.js Line 201-207 (GET /c/tiku/paper/ranking)
  Future<void> _loadRankData() async {
    if (_loading) return;
    
    setState(() {
      _loading = true;
    });

    try {
      final dio = ref.read(dioClientProvider);

      final response = await dio.get(
        '/c/tiku/paper/ranking',
        queryParameters: {
          'page': _page,
          'size': _pageSize,
          'paper_version_id': widget.paperVersionId,
          'goods_id': widget.goodsId,
        },
      );

      if (response.data['code'] == 100000) {
        final data = response.data['data'];
        final list = (data['list'] ?? []) as List;

        if (list.isEmpty) {
          setState(() {
            _isEnd = true;
            _loading = false;
          });
          return;
        }

        setState(() {
          for (var item in list) {
            final rank = _toInt(item['rank']);
            
            // ✅ 前3名放入头部排行榜
            if (rank <= 3 && _page == 1) {
              _threeRankData.add(item);
            } else {
              // ✅ 其他名次放入列表
              _list.add(_formatRankItem(item));
            }
          }
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('加载排行榜失败: $e');
    }
  }

  /// 格式化排行榜数据项 - 对应小程序 Line 85-94
  Map<String, dynamic> _formatRankItem(Map<String, dynamic> item) {
    // ✅ 处理头像URL
    String avatar = item['avatar'] ?? '';
    if (avatar.isNotEmpty && !avatar.startsWith('http')) {
      avatar = ApiConfig.completeImageUrl(avatar);
    }
    if (avatar.isEmpty) {
      avatar = 'https://xy-shunshun-pro.oss-cn-hangzhou.aliyuncs.com/yakaixindf.png';
    }

    // ✅ 处理时间
    final kaoshiTime = _toInt(item['kaoshi_time']);
    final time = _formatTime(kaoshiTime);

    // ✅ 处理昵称
    final name = item['nickname'] ?? item['name'] ?? '';

    // ✅ 处理分数
    final score = item['score'] != null ? '${item['score']}分' : '';

    return {
      'index': _toInt(item['rank']),
      'avatar': avatar,
      'name': name,
      'score': score,
      'time': time,
    };
  }

  /// 格式化时间 - 对应小程序 utils/index.js formatSeconds
  String _formatTime(int seconds) {
    if (seconds <= 0) return '';
    
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final parts = <String>[];
    if (hours > 0) {
      parts.add('${hours}h');
    }
    if (minutes > 0) {
      parts.add('${minutes}min');
    }
    parts.add('${secs}s');

    return parts.join(' ');
  }

  int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildContent(),
        ],
      ),
    );
  }

  /// 渐变背景 - 对应小程序 Line 287-297
  Widget _buildGradientBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 275.h,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2F69FF), Color(0xFF2F69FF), Colors.white],
            stops: [0.0, 0.38, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Column(
                children: [
                  // ✅ 前3名排行榜 - 对应小程序 Line 12
                  RankHeader(
                    showRankButton: false,
                    rankData: _threeRankData,
                    onRankButtonTap: () {},
                  ),
                  SizedBox(height: 16.h),
                  
                  // ✅ 排行榜列表 - 对应小程序 Line 13-27
                  _buildRankList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 页面头部 - 对应小程序 Line 3-10
  Widget _buildHeader() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '排行榜',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.sp),
        ],
      ),
    );
  }

  /// 排行榜列表 - 对应小程序 Line 15-24
  Widget _buildRankList() {
    if (_list.isEmpty && !_loading) {
      return Container(
        padding: EdgeInsets.all(40.h),
        child: Text(
          '暂无排行数据',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF999999),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          // 列表项
          ..._list.map((item) => _buildRankItem(item)),
          
          // 加载更多
          if (_loading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const CircularProgressIndicator(),
            ),
          
          // 没有更多
          if (_isEnd && _list.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                '没有更多了',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFFCCCCCC),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 排行榜列表项 - 对应小程序 Line 15-24, 308-365
  Widget _buildRankItem(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F1F1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 排名 - 对应小程序 Line 16, 355-364
          SizedBox(
            width: 30.w, // 60rpx → 30.w
            child: Text(
              '${item['index']}',
              style: TextStyle(
                fontSize: 14.sp, // 28rpx → 14.sp
                fontWeight: FontWeight.bold,
                color: const Color(0xFF222333),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 10.w),
          
          // 头像 - 对应小程序 Line 17-20, 348-353
          Container(
            width: 36.w, // 72rpx → 36.w
            height: 36.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8FF),
              borderRadius: BorderRadius.circular(18.w),
            ),
            child: ClipOval(
              child: Image.network(
                item['avatar'],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 20.sp,
                  color: const Color(0xFF999999),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          
          // 姓名 - 对应小程序 Line 21, 315-322
          SizedBox(
            width: 70.w, // 140rpx → 70.w
            child: Text(
              item['name'],
              style: TextStyle(
                fontSize: 14.sp, // 28rpx → 14.sp
                color: const Color(0xFF222333),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          
          const Spacer(),
          
          // 分数 - 对应小程序 Line 22, 324-332
          SizedBox(
            width: 60.w, // 120rpx → 60.w
            child: Text(
              item['score'],
              style: TextStyle(
                fontSize: 12.sp, // 24rpx → 12.sp
                color: const Color(0xFF222333),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 8.w),
          
          // 时间 - 对应小程序 Line 23, 334-345
          SizedBox(
            width: 77.w, // 154rpx → 77.w
            child: Text(
              item['time'],
              style: TextStyle(
                fontSize: 12.sp, // 24rpx → 12.sp
                color: Colors.black.withOpacity(0.65),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
