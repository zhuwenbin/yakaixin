import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/mock/data/course_mock_data.dart';

/// 资料下载页面 - 对应小程序 study/dataDownload/index.vue
/// 功能：显示课程资料列表，支持搜索、预览、下载
class DataDownloadPage extends ConsumerStatefulWidget {
  final String? lessonId;

  const DataDownloadPage({
    super.key,
    this.lessonId,
  });

  @override
  ConsumerState<DataDownloadPage> createState() => _DataDownloadPageState();
}

class _DataDownloadPageState extends ConsumerState<DataDownloadPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  List<Map<String, dynamic>> _dataList = [];
  List<Map<String, dynamic>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });
    // TODO: API调用
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _dataList = _mockDataList;
      _filteredList = _dataList;
      _loading = false;
    });
  }

  void _onSearch(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredList = _dataList;
      } else {
        _filteredList = _dataList.where((item) {
          final name = item['name']?.toString().toLowerCase() ?? '';
          return name.contains(keyword.toLowerCase());
        }).toList();
      }
    });
  }

  void _onPreview(Map<String, dynamic> item) {
    // TODO: 打开预览页面
    final link = item['link'] ?? '';
    if (link.isNotEmpty) {
      // 跳转到 WebView 预览
      print('预览文件: $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('资料下载'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildFileList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: '搜索文档名称',
          hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF999999)),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildFileList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_filteredList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) {
        return _FileItem(
          file: _filteredList[index],
          onPreview: () => _onPreview(_filteredList[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            '暂无资料',
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  // 从 Mock数据文件获取数据
  List<Map<String, dynamic>> get _mockDataList => MockCourseData.downloadList;
}

/// 文件项组件
class _FileItem extends StatelessWidget {
  final Map<String, dynamic> file;
  final VoidCallback onPreview;

  const _FileItem({
    required this.file,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final name = file['name']?.toString() ?? '';
    final downloadCount = file['num'] ?? 0;
    final pages = file['Pages'] ?? 0;
    final iconUrl = file['src']?.toString() ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(bottom: 10.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E9EA), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(iconUrl),
          SizedBox(width: 17.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFileName(name),
                SizedBox(height: 8.h),
                _buildFileInfo(downloadCount, pages),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String iconUrl) {
    return Container(
      width: 35.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: iconUrl.isNotEmpty
          ? Image.network(
              iconUrl,
              width: 35.w,
              height: 40.h,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.description_outlined,
                  size: 24.sp,
                  color: const Color(0xFF999999),
                );
              },
            )
          : Icon(
              Icons.description_outlined,
              size: 24.sp,
              color: const Color(0xFF999999),
            ),
    );
  }

  Widget _buildFileName(String name) {
    return Text(
      name,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF262629),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFileInfo(int downloadCount, int pages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '$downloadCount下载',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF262629).withOpacity(0.6),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '$pages页',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF262629).withOpacity(0.6),
              ),
            ),
          ],
        ),
        _buildPreviewButton(),
      ],
    );
  }

  Widget _buildPreviewButton() {
    return GestureDetector(
      onTap: onPreview,
      child: Container(
        width: 72.w,
        height: 26.h,
        decoration: BoxDecoration(
          color: const Color(0xFFEAFFF7),
          border: Border.all(color: const Color(0xFF0EA96D)),
          borderRadius: BorderRadius.circular(14.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '预览',
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF0EA96D),
          ),
        ),
      ),
    );
  }
}
