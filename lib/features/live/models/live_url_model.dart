import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_url_model.freezed.dart';
part 'live_url_model.g.dart';

/// 直播地址响应Model
/// 对应小程序API: /c/study/learning/live
@freezed
class LiveUrlResponse with _$LiveUrlResponse {
  const factory LiveUrlResponse({
    /// 直播地址 (有值表示直播进行中或未开始)
    @JsonKey(name: 'live_url') String? liveUrl,
    
    /// 回放地址 (有值表示直播已结束，可观看回放)
    @JsonKey(name: 'playback_url') String? playbackUrl,
    
    /// 商品ID
    @JsonKey(name: 'goods_id') String? goodsId,
    
    /// 课节ID
    @JsonKey(name: 'lesson_id') String? lessonId,
  }) = _LiveUrlResponse;

  factory LiveUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$LiveUrlResponseFromJson(json);
}
