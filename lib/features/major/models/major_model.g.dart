// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'major_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MajorModelImpl _$$MajorModelImplFromJson(Map<String, dynamic> json) =>
    _$MajorModelImpl(
      id: json['id'] as String,
      dataName: json['data_name'] as String,
      level: json['level'] as String?,
      subs: (json['subs'] as List<dynamic>?)
              ?.map((e) => MajorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MajorModelImplToJson(_$MajorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data_name': instance.dataName,
      'level': instance.level,
      'subs': instance.subs,
    };

_$CurrentMajorImpl _$$CurrentMajorImplFromJson(Map<String, dynamic> json) =>
    _$CurrentMajorImpl(
      majorId: json['major_id'] as String,
      majorName: json['major_name'] as String,
      majorPidLevel: json['major_pid_level'] as String?,
    );

Map<String, dynamic> _$$CurrentMajorImplToJson(_$CurrentMajorImpl instance) =>
    <String, dynamic>{
      'major_id': instance.majorId,
      'major_name': instance.majorName,
      'major_pid_level': instance.majorPidLevel,
    };
