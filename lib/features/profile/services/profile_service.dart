import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';

/// 个人资料服务
/// 对应小程序 api/index.js changeBasic
class ProfileService {
  final DioClient _dioClient;

  ProfileService(this._dioClient);

  /// 修改基本信息
  /// 对应接口: PUT /c/student/change/basic
  /// 对应小程序: changeBasic (Line 1008-1014)
  /// 小程序使用参数: { id, nickname, avatar }
  Future<void> changeBasic({
    required String studentId,
    required String nickname,
    required String avatar,
  }) async {
    try {
      print('📡 [修改个人信息] 请求参数: id=$studentId, nickname=$nickname, avatar=$avatar');
      
      final response = await _dioClient.put(
        '/c/student/change/basic',
        data: {
          'id': studentId,  // ✅ 小程序使用的是 'id' 而不是 'student_id'
          'nickname': nickname,
          'avatar': avatar,
        },
      );

      print('📡 [修改个人信息] 响应: ${response.data}');

      // 检查响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '修改失败';
        print('❌ [修改个人信息] 失败: $errorMsg');
        throw Exception(errorMsg);
      }
      
      print('✅ [修改个人信息] 成功');
    } on DioException catch (e) {
      print('❌ [修改个人信息] 网络错误: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [修改个人信息] 错误: $e');
      throw Exception('修改个人信息失败: $e');
    }
  }

  /// 上传图片
  /// 对应小程序: upLoad (utils/index.js Line 574-608)
  /// 接口: POST /c/base/uploadfiles
  /// 小程序参数: 
  ///   - header: { Authorization: 'Basic ...' }
  ///   - filePath: tempfileurl
  ///   - name: 'file'
  ///   - formData: {}
  Future<String> uploadImage(String filePath) async {
    try {
      print('📡 [上传图片] 开始上传: $filePath');
      
      // ✅ 对应小程序 Line 596-606
      // name: 'file' - 表单字段名
      // formData: {} - 额外的表单数据（小程序为空对象）
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,  // 提取文件名
        ),
      });

      print('📡 [上传图片] 请求 /c/base/uploadfiles');
      
      final response = await _dioClient.post(
        '/c/base/uploadfiles',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('📡 [上传图片] 响应: ${response.data}');

      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '上传失败';
        print('❌ [上传图片] 失败: $errorMsg');
        throw Exception(errorMsg);
      }

      // 小程序返回的是 data.data[0] (Line 586)
      // let data = JSON.parse(uploadFileRes.data)
      // return resolve(data.data[0])
      final data = response.data['data'];
      if (data == null) {
        print('❌ [上传图片] 返回数据为空');
        throw Exception('上传返回数据为空');
      }

      String avatarPath;
      if (data is List) {
        if (data.isEmpty) {
          print('❌ [上传图片] 返回数组为空');
          throw Exception('上传返回数组为空');
        }
        avatarPath = data[0] as String;
      } else if (data is Map && data.containsKey('url')) {
        avatarPath = data['url'] as String;
      } else {
        print('❌ [上传图片] 返回数据格式错误: $data');
        throw Exception('上传返回数据格式错误');
      }

      print('✅ [上传图片] 成功，路径: $avatarPath');
      return avatarPath;
    } on DioException catch (e) {
      print('❌ [上传图片] 网络错误: ${e.message}');
      print('❌ [上传图片] 错误详情: ${e.response?.data}');
      throw Exception('上传图片失败: ${e.message}');
    } catch (e) {
      print('❌ [上传图片] 错误: $e');
      throw Exception('上传图片失败: $e');
    }
  }

  /// 获取考试时间配置（包括章节练习设置）
  /// 对应小程序: getExamTime (api/userInfo.js Line 22-28)
  /// 对应接口: GET /c/tiku/configclient/getconfiginfo
  /// 返回: { chapter_number: '20' }
  Future<Map<String, dynamic>> getExamTime() async {
    try {
      print('📡 [获取考试配置] 开始请求...');
      
      final response = await _dioClient.get(
        '/c/tiku/configclient/getconfiginfo',
      );

      print('📡 [获取考试配置] 响应: ${response.data}');

      // 检查响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '获取配置失败';
        print('❌ [获取考试配置] 失败: $errorMsg');
        throw Exception(errorMsg);
      }

      final data = response.data['data'];
      if (data == null) {
        print('⚠️ [获取考试配置] 返回数据为空，使用默认值');
        return {
          'chapter_number': '20', // 默认值
        };
      }

      print('✅ [获取考试配置] 成功: chapter_number=${data['chapter_number']}');
      return data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('❌ [获取考试配置] 网络错误: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [获取考试配置] 错误: $e');
      throw Exception('获取配置失败: $e');
    }
  }

  /// 设置考试时间配置（包括章节练习设置）
  /// 对应小程序: setTimeInfo (api/userInfo.js Line 30-39)
  /// 对应接口: POST /c/tiku/configclient/setconfiginfo
  /// 参数: { chapter_number: '20' }
  Future<void> setTimeInfo({
    required String chapterNumber,
  }) async {
    try {
      print('📡 [设置考试配置] 请求参数: chapter_number=$chapterNumber');
      
      final response = await _dioClient.post(
        '/c/tiku/configclient/setconfiginfo',
        data: {
          'chapter_number': chapterNumber,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📡 [设置考试配置] 响应: ${response.data}');

      // 检查响应码
      if (response.data['code'] != 100000) {
        final errorMsg = response.data['msg']?.first ?? '设置失败';
        print('❌ [设置考试配置] 失败: $errorMsg');
        throw Exception(errorMsg);
      }
      
      print('✅ [设置考试配置] 成功');
    } on DioException catch (e) {
      print('❌ [设置考试配置] 网络错误: ${e.message}');
      throw Exception('网络请求失败: ${e.message}');
    } catch (e) {
      print('❌ [设置考试配置] 错误: $e');
      throw Exception('设置配置失败: $e');
    }
  }
}

/// ProfileService Provider
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(ref.read(dioClientProvider));
});
