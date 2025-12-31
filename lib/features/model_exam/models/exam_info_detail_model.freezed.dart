// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_info_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExamInfoDetailModel _$ExamInfoDetailModelFromJson(Map<String, dynamic> json) {
  return _ExamInfoDetailModel.fromJson(json);
}

/// @nodoc
mixin _$ExamInfoDetailModel {
  /// 模考信息
  @JsonKey(name: 'mock_exam')
  MockExamModel get mockExam => throw _privateConstructorUsedError;

  /// 考试轮次列表
  @JsonKey(name: 'mock_exam_details')
  List<ExamRoundModel> get examRounds => throw _privateConstructorUsedError;

  /// 报名人数
  @JsonKey(name: 'sign_up_count')
  String get signUpCount => throw _privateConstructorUsedError;

  /// 模考状态
  @JsonKey(name: 'mock_status')
  String get mockStatus => throw _privateConstructorUsedError;

  /// 模考状态名称
  @JsonKey(name: 'mock_status_name')
  String get mockStatusName => throw _privateConstructorUsedError;

  /// 其他模考列表
  @JsonKey(name: 'mock_list')
  List<MockExamListItemModel> get mockList =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamInfoDetailModelCopyWith<ExamInfoDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamInfoDetailModelCopyWith<$Res> {
  factory $ExamInfoDetailModelCopyWith(
          ExamInfoDetailModel value, $Res Function(ExamInfoDetailModel) then) =
      _$ExamInfoDetailModelCopyWithImpl<$Res, ExamInfoDetailModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'mock_exam') MockExamModel mockExam,
      @JsonKey(name: 'mock_exam_details') List<ExamRoundModel> examRounds,
      @JsonKey(name: 'sign_up_count') String signUpCount,
      @JsonKey(name: 'mock_status') String mockStatus,
      @JsonKey(name: 'mock_status_name') String mockStatusName,
      @JsonKey(name: 'mock_list') List<MockExamListItemModel> mockList});

  $MockExamModelCopyWith<$Res> get mockExam;
}

/// @nodoc
class _$ExamInfoDetailModelCopyWithImpl<$Res, $Val extends ExamInfoDetailModel>
    implements $ExamInfoDetailModelCopyWith<$Res> {
  _$ExamInfoDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mockExam = null,
    Object? examRounds = null,
    Object? signUpCount = null,
    Object? mockStatus = null,
    Object? mockStatusName = null,
    Object? mockList = null,
  }) {
    return _then(_value.copyWith(
      mockExam: null == mockExam
          ? _value.mockExam
          : mockExam // ignore: cast_nullable_to_non_nullable
              as MockExamModel,
      examRounds: null == examRounds
          ? _value.examRounds
          : examRounds // ignore: cast_nullable_to_non_nullable
              as List<ExamRoundModel>,
      signUpCount: null == signUpCount
          ? _value.signUpCount
          : signUpCount // ignore: cast_nullable_to_non_nullable
              as String,
      mockStatus: null == mockStatus
          ? _value.mockStatus
          : mockStatus // ignore: cast_nullable_to_non_nullable
              as String,
      mockStatusName: null == mockStatusName
          ? _value.mockStatusName
          : mockStatusName // ignore: cast_nullable_to_non_nullable
              as String,
      mockList: null == mockList
          ? _value.mockList
          : mockList // ignore: cast_nullable_to_non_nullable
              as List<MockExamListItemModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MockExamModelCopyWith<$Res> get mockExam {
    return $MockExamModelCopyWith<$Res>(_value.mockExam, (value) {
      return _then(_value.copyWith(mockExam: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExamInfoDetailModelImplCopyWith<$Res>
    implements $ExamInfoDetailModelCopyWith<$Res> {
  factory _$$ExamInfoDetailModelImplCopyWith(_$ExamInfoDetailModelImpl value,
          $Res Function(_$ExamInfoDetailModelImpl) then) =
      __$$ExamInfoDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'mock_exam') MockExamModel mockExam,
      @JsonKey(name: 'mock_exam_details') List<ExamRoundModel> examRounds,
      @JsonKey(name: 'sign_up_count') String signUpCount,
      @JsonKey(name: 'mock_status') String mockStatus,
      @JsonKey(name: 'mock_status_name') String mockStatusName,
      @JsonKey(name: 'mock_list') List<MockExamListItemModel> mockList});

  @override
  $MockExamModelCopyWith<$Res> get mockExam;
}

/// @nodoc
class __$$ExamInfoDetailModelImplCopyWithImpl<$Res>
    extends _$ExamInfoDetailModelCopyWithImpl<$Res, _$ExamInfoDetailModelImpl>
    implements _$$ExamInfoDetailModelImplCopyWith<$Res> {
  __$$ExamInfoDetailModelImplCopyWithImpl(_$ExamInfoDetailModelImpl _value,
      $Res Function(_$ExamInfoDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mockExam = null,
    Object? examRounds = null,
    Object? signUpCount = null,
    Object? mockStatus = null,
    Object? mockStatusName = null,
    Object? mockList = null,
  }) {
    return _then(_$ExamInfoDetailModelImpl(
      mockExam: null == mockExam
          ? _value.mockExam
          : mockExam // ignore: cast_nullable_to_non_nullable
              as MockExamModel,
      examRounds: null == examRounds
          ? _value._examRounds
          : examRounds // ignore: cast_nullable_to_non_nullable
              as List<ExamRoundModel>,
      signUpCount: null == signUpCount
          ? _value.signUpCount
          : signUpCount // ignore: cast_nullable_to_non_nullable
              as String,
      mockStatus: null == mockStatus
          ? _value.mockStatus
          : mockStatus // ignore: cast_nullable_to_non_nullable
              as String,
      mockStatusName: null == mockStatusName
          ? _value.mockStatusName
          : mockStatusName // ignore: cast_nullable_to_non_nullable
              as String,
      mockList: null == mockList
          ? _value._mockList
          : mockList // ignore: cast_nullable_to_non_nullable
              as List<MockExamListItemModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamInfoDetailModelImpl implements _ExamInfoDetailModel {
  const _$ExamInfoDetailModelImpl(
      {@JsonKey(name: 'mock_exam') required this.mockExam,
      @JsonKey(name: 'mock_exam_details')
      required final List<ExamRoundModel> examRounds,
      @JsonKey(name: 'sign_up_count') this.signUpCount = '0',
      @JsonKey(name: 'mock_status') this.mockStatus = '',
      @JsonKey(name: 'mock_status_name') this.mockStatusName = '',
      @JsonKey(name: 'mock_list')
      final List<MockExamListItemModel> mockList = const []})
      : _examRounds = examRounds,
        _mockList = mockList;

  factory _$ExamInfoDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamInfoDetailModelImplFromJson(json);

  /// 模考信息
  @override
  @JsonKey(name: 'mock_exam')
  final MockExamModel mockExam;

  /// 考试轮次列表
  final List<ExamRoundModel> _examRounds;

  /// 考试轮次列表
  @override
  @JsonKey(name: 'mock_exam_details')
  List<ExamRoundModel> get examRounds {
    if (_examRounds is EqualUnmodifiableListView) return _examRounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_examRounds);
  }

  /// 报名人数
  @override
  @JsonKey(name: 'sign_up_count')
  final String signUpCount;

  /// 模考状态
  @override
  @JsonKey(name: 'mock_status')
  final String mockStatus;

  /// 模考状态名称
  @override
  @JsonKey(name: 'mock_status_name')
  final String mockStatusName;

  /// 其他模考列表
  final List<MockExamListItemModel> _mockList;

  /// 其他模考列表
  @override
  @JsonKey(name: 'mock_list')
  List<MockExamListItemModel> get mockList {
    if (_mockList is EqualUnmodifiableListView) return _mockList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mockList);
  }

  @override
  String toString() {
    return 'ExamInfoDetailModel(mockExam: $mockExam, examRounds: $examRounds, signUpCount: $signUpCount, mockStatus: $mockStatus, mockStatusName: $mockStatusName, mockList: $mockList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamInfoDetailModelImpl &&
            (identical(other.mockExam, mockExam) ||
                other.mockExam == mockExam) &&
            const DeepCollectionEquality()
                .equals(other._examRounds, _examRounds) &&
            (identical(other.signUpCount, signUpCount) ||
                other.signUpCount == signUpCount) &&
            (identical(other.mockStatus, mockStatus) ||
                other.mockStatus == mockStatus) &&
            (identical(other.mockStatusName, mockStatusName) ||
                other.mockStatusName == mockStatusName) &&
            const DeepCollectionEquality().equals(other._mockList, _mockList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mockExam,
      const DeepCollectionEquality().hash(_examRounds),
      signUpCount,
      mockStatus,
      mockStatusName,
      const DeepCollectionEquality().hash(_mockList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamInfoDetailModelImplCopyWith<_$ExamInfoDetailModelImpl> get copyWith =>
      __$$ExamInfoDetailModelImplCopyWithImpl<_$ExamInfoDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamInfoDetailModelImplToJson(
      this,
    );
  }
}

abstract class _ExamInfoDetailModel implements ExamInfoDetailModel {
  const factory _ExamInfoDetailModel(
      {@JsonKey(name: 'mock_exam') required final MockExamModel mockExam,
      @JsonKey(name: 'mock_exam_details')
      required final List<ExamRoundModel> examRounds,
      @JsonKey(name: 'sign_up_count') final String signUpCount,
      @JsonKey(name: 'mock_status') final String mockStatus,
      @JsonKey(name: 'mock_status_name') final String mockStatusName,
      @JsonKey(name: 'mock_list')
      final List<MockExamListItemModel> mockList}) = _$ExamInfoDetailModelImpl;

  factory _ExamInfoDetailModel.fromJson(Map<String, dynamic> json) =
      _$ExamInfoDetailModelImpl.fromJson;

  @override

  /// 模考信息
  @JsonKey(name: 'mock_exam')
  MockExamModel get mockExam;
  @override

  /// 考试轮次列表
  @JsonKey(name: 'mock_exam_details')
  List<ExamRoundModel> get examRounds;
  @override

  /// 报名人数
  @JsonKey(name: 'sign_up_count')
  String get signUpCount;
  @override

  /// 模考状态
  @JsonKey(name: 'mock_status')
  String get mockStatus;
  @override

  /// 模考状态名称
  @JsonKey(name: 'mock_status_name')
  String get mockStatusName;
  @override

  /// 其他模考列表
  @JsonKey(name: 'mock_list')
  List<MockExamListItemModel> get mockList;
  @override
  @JsonKey(ignore: true)
  _$$ExamInfoDetailModelImplCopyWith<_$ExamInfoDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MockExamModel _$MockExamModelFromJson(Map<String, dynamic> json) {
  return _MockExamModel.fromJson(json);
}

/// @nodoc
mixin _$MockExamModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_id')
  String get professionalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'mock_name')
  String get mockName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MockExamModelCopyWith<MockExamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MockExamModelCopyWith<$Res> {
  factory $MockExamModelCopyWith(
          MockExamModel value, $Res Function(MockExamModel) then) =
      _$MockExamModelCopyWithImpl<$Res, MockExamModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'professional_id') String professionalId,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'mock_name') String mockName});
}

/// @nodoc
class _$MockExamModelCopyWithImpl<$Res, $Val extends MockExamModel>
    implements $MockExamModelCopyWith<$Res> {
  _$MockExamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? professionalId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? mockName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      professionalId: null == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      mockName: null == mockName
          ? _value.mockName
          : mockName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MockExamModelImplCopyWith<$Res>
    implements $MockExamModelCopyWith<$Res> {
  factory _$$MockExamModelImplCopyWith(
          _$MockExamModelImpl value, $Res Function(_$MockExamModelImpl) then) =
      __$$MockExamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'professional_id') String professionalId,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'mock_name') String mockName});
}

/// @nodoc
class __$$MockExamModelImplCopyWithImpl<$Res>
    extends _$MockExamModelCopyWithImpl<$Res, _$MockExamModelImpl>
    implements _$$MockExamModelImplCopyWith<$Res> {
  __$$MockExamModelImplCopyWithImpl(
      _$MockExamModelImpl _value, $Res Function(_$MockExamModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? professionalId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? mockName = null,
  }) {
    return _then(_$MockExamModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      professionalId: null == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      mockName: null == mockName
          ? _value.mockName
          : mockName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MockExamModelImpl implements _MockExamModel {
  const _$MockExamModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'professional_id') this.professionalId = '',
      @JsonKey(name: 'start_time') this.startTime = '',
      @JsonKey(name: 'end_time') this.endTime = '',
      @JsonKey(name: 'mock_name') this.mockName = ''});

  factory _$MockExamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MockExamModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'professional_id')
  final String professionalId;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'mock_name')
  final String mockName;

  @override
  String toString() {
    return 'MockExamModel(id: $id, professionalId: $professionalId, startTime: $startTime, endTime: $endTime, mockName: $mockName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MockExamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.mockName, mockName) ||
                other.mockName == mockName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, professionalId, startTime, endTime, mockName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MockExamModelImplCopyWith<_$MockExamModelImpl> get copyWith =>
      __$$MockExamModelImplCopyWithImpl<_$MockExamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MockExamModelImplToJson(
      this,
    );
  }
}

abstract class _MockExamModel implements MockExamModel {
  const factory _MockExamModel(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'professional_id') final String professionalId,
      @JsonKey(name: 'start_time') final String startTime,
      @JsonKey(name: 'end_time') final String endTime,
      @JsonKey(name: 'mock_name') final String mockName}) = _$MockExamModelImpl;

  factory _MockExamModel.fromJson(Map<String, dynamic> json) =
      _$MockExamModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'professional_id')
  String get professionalId;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'mock_name')
  String get mockName;
  @override
  @JsonKey(ignore: true)
  _$$MockExamModelImplCopyWith<_$MockExamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExamRoundModel _$ExamRoundModelFromJson(Map<String, dynamic> json) {
  return _ExamRoundModel.fromJson(json);
}

/// @nodoc
mixin _$ExamRoundModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'mock_id')
  String get mockId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_round_name')
  String get examRoundName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status =>
      throw _privateConstructorUsedError; // 1-进行中, 2-未报名, 3-已完成, 4-补考未开启, 5-补考
  @JsonKey(name: 'status_name')
  String get statusName => throw _privateConstructorUsedError;
  @JsonKey(name: 'btn_is_enable')
  String get btnIsEnable => throw _privateConstructorUsedError; // 1-可操作, 2-不可操作
  @JsonKey(name: 'exam_paper_id')
  String get examPaperId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subject_name')
  String get subjectName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExamRoundModelCopyWith<ExamRoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamRoundModelCopyWith<$Res> {
  factory $ExamRoundModelCopyWith(
          ExamRoundModel value, $Res Function(ExamRoundModel) then) =
      _$ExamRoundModelCopyWithImpl<$Res, ExamRoundModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'mock_id') String mockId,
      @JsonKey(name: 'exam_round_name') String examRoundName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'status_name') String statusName,
      @JsonKey(name: 'btn_is_enable') String btnIsEnable,
      @JsonKey(name: 'exam_paper_id') String examPaperId,
      @JsonKey(name: 'subject_name') String subjectName});
}

/// @nodoc
class _$ExamRoundModelCopyWithImpl<$Res, $Val extends ExamRoundModel>
    implements $ExamRoundModelCopyWith<$Res> {
  _$ExamRoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mockId = null,
    Object? examRoundName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? statusName = null,
    Object? btnIsEnable = null,
    Object? examPaperId = null,
    Object? subjectName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mockId: null == mockId
          ? _value.mockId
          : mockId // ignore: cast_nullable_to_non_nullable
              as String,
      examRoundName: null == examRoundName
          ? _value.examRoundName
          : examRoundName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
      btnIsEnable: null == btnIsEnable
          ? _value.btnIsEnable
          : btnIsEnable // ignore: cast_nullable_to_non_nullable
              as String,
      examPaperId: null == examPaperId
          ? _value.examPaperId
          : examPaperId // ignore: cast_nullable_to_non_nullable
              as String,
      subjectName: null == subjectName
          ? _value.subjectName
          : subjectName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamRoundModelImplCopyWith<$Res>
    implements $ExamRoundModelCopyWith<$Res> {
  factory _$$ExamRoundModelImplCopyWith(_$ExamRoundModelImpl value,
          $Res Function(_$ExamRoundModelImpl) then) =
      __$$ExamRoundModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'mock_id') String mockId,
      @JsonKey(name: 'exam_round_name') String examRoundName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'status_name') String statusName,
      @JsonKey(name: 'btn_is_enable') String btnIsEnable,
      @JsonKey(name: 'exam_paper_id') String examPaperId,
      @JsonKey(name: 'subject_name') String subjectName});
}

/// @nodoc
class __$$ExamRoundModelImplCopyWithImpl<$Res>
    extends _$ExamRoundModelCopyWithImpl<$Res, _$ExamRoundModelImpl>
    implements _$$ExamRoundModelImplCopyWith<$Res> {
  __$$ExamRoundModelImplCopyWithImpl(
      _$ExamRoundModelImpl _value, $Res Function(_$ExamRoundModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mockId = null,
    Object? examRoundName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? statusName = null,
    Object? btnIsEnable = null,
    Object? examPaperId = null,
    Object? subjectName = null,
  }) {
    return _then(_$ExamRoundModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mockId: null == mockId
          ? _value.mockId
          : mockId // ignore: cast_nullable_to_non_nullable
              as String,
      examRoundName: null == examRoundName
          ? _value.examRoundName
          : examRoundName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      statusName: null == statusName
          ? _value.statusName
          : statusName // ignore: cast_nullable_to_non_nullable
              as String,
      btnIsEnable: null == btnIsEnable
          ? _value.btnIsEnable
          : btnIsEnable // ignore: cast_nullable_to_non_nullable
              as String,
      examPaperId: null == examPaperId
          ? _value.examPaperId
          : examPaperId // ignore: cast_nullable_to_non_nullable
              as String,
      subjectName: null == subjectName
          ? _value.subjectName
          : subjectName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamRoundModelImpl implements _ExamRoundModel {
  const _$ExamRoundModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'mock_id') this.mockId = '',
      @JsonKey(name: 'exam_round_name') this.examRoundName = '',
      @JsonKey(name: 'start_time') this.startTime = '',
      @JsonKey(name: 'end_time') this.endTime = '',
      @JsonKey(name: 'status') this.status = '',
      @JsonKey(name: 'status_name') this.statusName = '',
      @JsonKey(name: 'btn_is_enable') this.btnIsEnable = '1',
      @JsonKey(name: 'exam_paper_id') this.examPaperId = '',
      @JsonKey(name: 'subject_name') this.subjectName = ''});

  factory _$ExamRoundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamRoundModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'mock_id')
  final String mockId;
  @override
  @JsonKey(name: 'exam_round_name')
  final String examRoundName;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'status')
  final String status;
// 1-进行中, 2-未报名, 3-已完成, 4-补考未开启, 5-补考
  @override
  @JsonKey(name: 'status_name')
  final String statusName;
  @override
  @JsonKey(name: 'btn_is_enable')
  final String btnIsEnable;
// 1-可操作, 2-不可操作
  @override
  @JsonKey(name: 'exam_paper_id')
  final String examPaperId;
  @override
  @JsonKey(name: 'subject_name')
  final String subjectName;

  @override
  String toString() {
    return 'ExamRoundModel(id: $id, mockId: $mockId, examRoundName: $examRoundName, startTime: $startTime, endTime: $endTime, status: $status, statusName: $statusName, btnIsEnable: $btnIsEnable, examPaperId: $examPaperId, subjectName: $subjectName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamRoundModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mockId, mockId) || other.mockId == mockId) &&
            (identical(other.examRoundName, examRoundName) ||
                other.examRoundName == examRoundName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusName, statusName) ||
                other.statusName == statusName) &&
            (identical(other.btnIsEnable, btnIsEnable) ||
                other.btnIsEnable == btnIsEnable) &&
            (identical(other.examPaperId, examPaperId) ||
                other.examPaperId == examPaperId) &&
            (identical(other.subjectName, subjectName) ||
                other.subjectName == subjectName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      mockId,
      examRoundName,
      startTime,
      endTime,
      status,
      statusName,
      btnIsEnable,
      examPaperId,
      subjectName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamRoundModelImplCopyWith<_$ExamRoundModelImpl> get copyWith =>
      __$$ExamRoundModelImplCopyWithImpl<_$ExamRoundModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamRoundModelImplToJson(
      this,
    );
  }
}

abstract class _ExamRoundModel implements ExamRoundModel {
  const factory _ExamRoundModel(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'mock_id') final String mockId,
          @JsonKey(name: 'exam_round_name') final String examRoundName,
          @JsonKey(name: 'start_time') final String startTime,
          @JsonKey(name: 'end_time') final String endTime,
          @JsonKey(name: 'status') final String status,
          @JsonKey(name: 'status_name') final String statusName,
          @JsonKey(name: 'btn_is_enable') final String btnIsEnable,
          @JsonKey(name: 'exam_paper_id') final String examPaperId,
          @JsonKey(name: 'subject_name') final String subjectName}) =
      _$ExamRoundModelImpl;

  factory _ExamRoundModel.fromJson(Map<String, dynamic> json) =
      _$ExamRoundModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'mock_id')
  String get mockId;
  @override
  @JsonKey(name: 'exam_round_name')
  String get examRoundName;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override // 1-进行中, 2-未报名, 3-已完成, 4-补考未开启, 5-补考
  @JsonKey(name: 'status_name')
  String get statusName;
  @override
  @JsonKey(name: 'btn_is_enable')
  String get btnIsEnable;
  @override // 1-可操作, 2-不可操作
  @JsonKey(name: 'exam_paper_id')
  String get examPaperId;
  @override
  @JsonKey(name: 'subject_name')
  String get subjectName;
  @override
  @JsonKey(ignore: true)
  _$$ExamRoundModelImplCopyWith<_$ExamRoundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MockExamListItemModel _$MockExamListItemModelFromJson(
    Map<String, dynamic> json) {
  return _MockExamListItemModel.fromJson(json);
}

/// @nodoc
mixin _$MockExamListItemModel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'mock_name')
  String get mockName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MockExamListItemModelCopyWith<MockExamListItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MockExamListItemModelCopyWith<$Res> {
  factory $MockExamListItemModelCopyWith(MockExamListItemModel value,
          $Res Function(MockExamListItemModel) then) =
      _$MockExamListItemModelCopyWithImpl<$Res, MockExamListItemModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'mock_name') String mockName,
      @JsonKey(name: 'start_time') String startTime});
}

/// @nodoc
class _$MockExamListItemModelCopyWithImpl<$Res,
        $Val extends MockExamListItemModel>
    implements $MockExamListItemModelCopyWith<$Res> {
  _$MockExamListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mockName = null,
    Object? startTime = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mockName: null == mockName
          ? _value.mockName
          : mockName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MockExamListItemModelImplCopyWith<$Res>
    implements $MockExamListItemModelCopyWith<$Res> {
  factory _$$MockExamListItemModelImplCopyWith(
          _$MockExamListItemModelImpl value,
          $Res Function(_$MockExamListItemModelImpl) then) =
      __$$MockExamListItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'mock_name') String mockName,
      @JsonKey(name: 'start_time') String startTime});
}

/// @nodoc
class __$$MockExamListItemModelImplCopyWithImpl<$Res>
    extends _$MockExamListItemModelCopyWithImpl<$Res,
        _$MockExamListItemModelImpl>
    implements _$$MockExamListItemModelImplCopyWith<$Res> {
  __$$MockExamListItemModelImplCopyWithImpl(_$MockExamListItemModelImpl _value,
      $Res Function(_$MockExamListItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mockName = null,
    Object? startTime = null,
  }) {
    return _then(_$MockExamListItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mockName: null == mockName
          ? _value.mockName
          : mockName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MockExamListItemModelImpl implements _MockExamListItemModel {
  const _$MockExamListItemModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'mock_name') this.mockName = '',
      @JsonKey(name: 'start_time') this.startTime = ''});

  factory _$MockExamListItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MockExamListItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'mock_name')
  final String mockName;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;

  @override
  String toString() {
    return 'MockExamListItemModel(id: $id, mockName: $mockName, startTime: $startTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MockExamListItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mockName, mockName) ||
                other.mockName == mockName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, mockName, startTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MockExamListItemModelImplCopyWith<_$MockExamListItemModelImpl>
      get copyWith => __$$MockExamListItemModelImplCopyWithImpl<
          _$MockExamListItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MockExamListItemModelImplToJson(
      this,
    );
  }
}

abstract class _MockExamListItemModel implements MockExamListItemModel {
  const factory _MockExamListItemModel(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'mock_name') final String mockName,
          @JsonKey(name: 'start_time') final String startTime}) =
      _$MockExamListItemModelImpl;

  factory _MockExamListItemModel.fromJson(Map<String, dynamic> json) =
      _$MockExamListItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'mock_name')
  String get mockName;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(ignore: true)
  _$$MockExamListItemModelImplCopyWith<_$MockExamListItemModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
