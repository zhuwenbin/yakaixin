import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

/// 签名工具类
/// 对应 iOS: NetworkTool.m - GetMD5String 方法
/// 
/// 签名算法:
/// 1. 获取当前日期 (yyyy-MM-dd 格式)
/// 2. 拼接: SIGNKEY + 日期
/// 3. MD5 加密
/// 4. 返回小写的 MD5 字符串
class SignUtil {
  // 签名密钥 (对应 iOS: #define SIGNKEY @"HIVF65893T73G79aQQCcDbWJzDHSnLwB")
  static const String _signKey = 'HIVF65893T73G79aQQCcDbWJzDHSnLwB';
  
  /// 生成签名
  /// 
  /// 算法:
  /// ```
  /// 当前日期 = "2025-01-25"
  /// 待加密字符串 = "HIVF65893T73G79aQQCcDbWJzDHSnLwB2025-01-25"
  /// sign = MD5(待加密字符串).toLowerCase()
  /// ```
  static String generateSign() {
    // 1. 获取当前日期 (yyyy-MM-dd 格式)
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateStr = formatter.format(now);
    
    // 2. 拼接: SIGNKEY + 日期
    final rawString = '$_signKey$dateStr';
    
    // 3. MD5 加密
    final bytes = utf8.encode(rawString);
    final digest = md5.convert(bytes);
    
    // 4. 返回小写的 MD5 字符串
    return digest.toString().toLowerCase();
  }
  
  /// 验证签名是否有效
  /// 
  /// 参数:
  /// - [sign] 待验证的签名
  /// 
  /// 返回:
  /// - true: 签名有效
  /// - false: 签名无效
  static bool verifySign(String sign) {
    final currentSign = generateSign();
    return sign.toLowerCase() == currentSign;
  }
  
  /// 获取签名密钥 (用于调试)
  static String getSignKey() {
    return _signKey;
  }
}
