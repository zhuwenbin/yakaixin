import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// 统一响应包装
/// 对应小程序响应格式: {status, message, data, code}
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool status,
    String? message,
    String? msg,
    T? data,
    int? code,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

/// 分页响应
/// 对应小程序分页接口
@Freezed(genericArgumentFactories: true)
class PaginationResponse<T> with _$PaginationResponse<T> {
  const factory PaginationResponse({
    required List<T> list,
    required int total,
    required int page,
    required int size,
    int? totalPage,
  }) = _PaginationResponse<T>;

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginationResponseFromJson(json, fromJsonT);
}
