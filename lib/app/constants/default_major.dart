import '../../features/auth/models/user_model.dart';

/// 默认专业（游客模式兜底）
///
/// 目的：
/// - 未登录时也能正常请求需要 professional_id 的接口
/// - 避免页面出现“未选择专业/无法加载数据”
class DefaultMajor {
  static const String id = '524033912737962623';
  static const String name = '口腔执业医师';

  static MajorModel get model => const MajorModel(majorId: id, majorName: name);

  static Map<String, dynamic> get json => <String, dynamic>{
        'major_id': id,
        'major_name': name,
      };
}

