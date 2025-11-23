import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 本地存储服务
/// 封装SharedPreferences
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// 保存String
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// 获取String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// 保存int
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// 获取int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// 保存bool
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// 获取bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// 保存double
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// 获取double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// 保存List<String>
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  /// 获取List<String>
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// 保存JSON对象
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await setString(key, jsonEncode(value));
  }

  /// 获取JSON对象
  Map<String, dynamic>? getJson(String key) {
    final str = getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// 删除
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// 清空所有
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// 判断key是否存在
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}

/// StorageService Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized in main()');
});
