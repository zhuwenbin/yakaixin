// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_name')
  String? get studentName => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_info')
  EmployeeInfoModel? get employeeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'major')
  List<MajorModel>? get majors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String token,
      @JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'student_name') String? studentName,
      String? nickname,
      String? avatar,
      String? phone,
      @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
      @JsonKey(name: 'major') List<MajorModel>? majors});

  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? merchants = freezed,
    Object? employeeInfo = freezed,
    Object? majors = freezed,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchants: freezed == merchants
          ? _value.merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<MerchantModel>?,
      employeeInfo: freezed == employeeInfo
          ? _value.employeeInfo
          : employeeInfo // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoModel?,
      majors: freezed == majors
          ? _value.majors
          : majors // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo {
    if (_value.employeeInfo == null) {
      return null;
    }

    return $EmployeeInfoModelCopyWith<$Res>(_value.employeeInfo!, (value) {
      return _then(_value.copyWith(employeeInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String token,
      @JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'student_name') String? studentName,
      String? nickname,
      String? avatar,
      String? phone,
      @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
      @JsonKey(name: 'major') List<MajorModel>? majors});

  @override
  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? merchants = freezed,
    Object? employeeInfo = freezed,
    Object? majors = freezed,
  }) {
    return _then(_$UserModelImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchants: freezed == merchants
          ? _value._merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<MerchantModel>?,
      employeeInfo: freezed == employeeInfo
          ? _value.employeeInfo
          : employeeInfo // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoModel?,
      majors: freezed == majors
          ? _value._majors
          : majors // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.token,
      @JsonKey(name: 'student_id') required this.studentId,
      @JsonKey(name: 'student_name') this.studentName,
      this.nickname,
      this.avatar,
      this.phone,
      @JsonKey(name: 'merchant') final List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') this.employeeInfo,
      @JsonKey(name: 'major') final List<MajorModel>? majors})
      : _merchants = merchants,
        _majors = majors;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String token;
  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  @JsonKey(name: 'student_name')
  final String? studentName;
  @override
  final String? nickname;
  @override
  final String? avatar;
  @override
  final String? phone;
  final List<MerchantModel>? _merchants;
  @override
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants {
    final value = _merchants;
    if (value == null) return null;
    if (_merchants is EqualUnmodifiableListView) return _merchants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'employee_info')
  final EmployeeInfoModel? employeeInfo;
  final List<MajorModel>? _majors;
  @override
  @JsonKey(name: 'major')
  List<MajorModel>? get majors {
    final value = _majors;
    if (value == null) return null;
    if (_majors is EqualUnmodifiableListView) return _majors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserModel(token: $token, studentId: $studentId, studentName: $studentName, nickname: $nickname, avatar: $avatar, phone: $phone, merchants: $merchants, employeeInfo: $employeeInfo, majors: $majors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            const DeepCollectionEquality()
                .equals(other._merchants, _merchants) &&
            (identical(other.employeeInfo, employeeInfo) ||
                other.employeeInfo == employeeInfo) &&
            const DeepCollectionEquality().equals(other._majors, _majors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      token,
      studentId,
      studentName,
      nickname,
      avatar,
      phone,
      const DeepCollectionEquality().hash(_merchants),
      employeeInfo,
      const DeepCollectionEquality().hash(_majors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
          {required final String token,
          @JsonKey(name: 'student_id') required final String studentId,
          @JsonKey(name: 'student_name') final String? studentName,
          final String? nickname,
          final String? avatar,
          final String? phone,
          @JsonKey(name: 'merchant') final List<MerchantModel>? merchants,
          @JsonKey(name: 'employee_info') final EmployeeInfoModel? employeeInfo,
          @JsonKey(name: 'major') final List<MajorModel>? majors}) =
      _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get token;
  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  @JsonKey(name: 'student_name')
  String? get studentName;
  @override
  String? get nickname;
  @override
  String? get avatar;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants;
  @override
  @JsonKey(name: 'employee_info')
  EmployeeInfoModel? get employeeInfo;
  @override
  @JsonKey(name: 'major')
  List<MajorModel>? get majors;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MajorModel _$MajorModelFromJson(Map<String, dynamic> json) {
  return _MajorModel.fromJson(json);
}

/// @nodoc
mixin _$MajorModel {
  @JsonKey(name: 'major_id')
  String get majorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'major_name')
  String get majorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'major_code')
  String? get majorCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'major_logo')
  String? get majorLogo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MajorModelCopyWith<MajorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MajorModelCopyWith<$Res> {
  factory $MajorModelCopyWith(
          MajorModel value, $Res Function(MajorModel) then) =
      _$MajorModelCopyWithImpl<$Res, MajorModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'major_id') String majorId,
      @JsonKey(name: 'major_name') String majorName,
      @JsonKey(name: 'major_code') String? majorCode,
      @JsonKey(name: 'major_logo') String? majorLogo});
}

/// @nodoc
class _$MajorModelCopyWithImpl<$Res, $Val extends MajorModel>
    implements $MajorModelCopyWith<$Res> {
  _$MajorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? majorId = null,
    Object? majorName = null,
    Object? majorCode = freezed,
    Object? majorLogo = freezed,
  }) {
    return _then(_value.copyWith(
      majorId: null == majorId
          ? _value.majorId
          : majorId // ignore: cast_nullable_to_non_nullable
              as String,
      majorName: null == majorName
          ? _value.majorName
          : majorName // ignore: cast_nullable_to_non_nullable
              as String,
      majorCode: freezed == majorCode
          ? _value.majorCode
          : majorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      majorLogo: freezed == majorLogo
          ? _value.majorLogo
          : majorLogo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MajorModelImplCopyWith<$Res>
    implements $MajorModelCopyWith<$Res> {
  factory _$$MajorModelImplCopyWith(
          _$MajorModelImpl value, $Res Function(_$MajorModelImpl) then) =
      __$$MajorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'major_id') String majorId,
      @JsonKey(name: 'major_name') String majorName,
      @JsonKey(name: 'major_code') String? majorCode,
      @JsonKey(name: 'major_logo') String? majorLogo});
}

/// @nodoc
class __$$MajorModelImplCopyWithImpl<$Res>
    extends _$MajorModelCopyWithImpl<$Res, _$MajorModelImpl>
    implements _$$MajorModelImplCopyWith<$Res> {
  __$$MajorModelImplCopyWithImpl(
      _$MajorModelImpl _value, $Res Function(_$MajorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? majorId = null,
    Object? majorName = null,
    Object? majorCode = freezed,
    Object? majorLogo = freezed,
  }) {
    return _then(_$MajorModelImpl(
      majorId: null == majorId
          ? _value.majorId
          : majorId // ignore: cast_nullable_to_non_nullable
              as String,
      majorName: null == majorName
          ? _value.majorName
          : majorName // ignore: cast_nullable_to_non_nullable
              as String,
      majorCode: freezed == majorCode
          ? _value.majorCode
          : majorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      majorLogo: freezed == majorLogo
          ? _value.majorLogo
          : majorLogo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MajorModelImpl implements _MajorModel {
  const _$MajorModelImpl(
      {@JsonKey(name: 'major_id') required this.majorId,
      @JsonKey(name: 'major_name') required this.majorName,
      @JsonKey(name: 'major_code') this.majorCode,
      @JsonKey(name: 'major_logo') this.majorLogo});

  factory _$MajorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MajorModelImplFromJson(json);

  @override
  @JsonKey(name: 'major_id')
  final String majorId;
  @override
  @JsonKey(name: 'major_name')
  final String majorName;
  @override
  @JsonKey(name: 'major_code')
  final String? majorCode;
  @override
  @JsonKey(name: 'major_logo')
  final String? majorLogo;

  @override
  String toString() {
    return 'MajorModel(majorId: $majorId, majorName: $majorName, majorCode: $majorCode, majorLogo: $majorLogo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MajorModelImpl &&
            (identical(other.majorId, majorId) || other.majorId == majorId) &&
            (identical(other.majorName, majorName) ||
                other.majorName == majorName) &&
            (identical(other.majorCode, majorCode) ||
                other.majorCode == majorCode) &&
            (identical(other.majorLogo, majorLogo) ||
                other.majorLogo == majorLogo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, majorId, majorName, majorCode, majorLogo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MajorModelImplCopyWith<_$MajorModelImpl> get copyWith =>
      __$$MajorModelImplCopyWithImpl<_$MajorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MajorModelImplToJson(
      this,
    );
  }
}

abstract class _MajorModel implements MajorModel {
  const factory _MajorModel(
      {@JsonKey(name: 'major_id') required final String majorId,
      @JsonKey(name: 'major_name') required final String majorName,
      @JsonKey(name: 'major_code') final String? majorCode,
      @JsonKey(name: 'major_logo') final String? majorLogo}) = _$MajorModelImpl;

  factory _MajorModel.fromJson(Map<String, dynamic> json) =
      _$MajorModelImpl.fromJson;

  @override
  @JsonKey(name: 'major_id')
  String get majorId;
  @override
  @JsonKey(name: 'major_name')
  String get majorName;
  @override
  @JsonKey(name: 'major_code')
  String? get majorCode;
  @override
  @JsonKey(name: 'major_logo')
  String? get majorLogo;
  @override
  @JsonKey(ignore: true)
  _$$MajorModelImplCopyWith<_$MajorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MerchantModel _$MerchantModelFromJson(Map<String, dynamic> json) {
  return _MerchantModel.fromJson(json);
}

/// @nodoc
mixin _$MerchantModel {
  @JsonKey(name: 'merchant_id')
  String get merchantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant_name')
  String get merchantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_id')
  String? get brandId => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_name')
  String? get brandName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MerchantModelCopyWith<MerchantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantModelCopyWith<$Res> {
  factory $MerchantModelCopyWith(
          MerchantModel value, $Res Function(MerchantModel) then) =
      _$MerchantModelCopyWithImpl<$Res, MerchantModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'merchant_id') String merchantId,
      @JsonKey(name: 'merchant_name') String merchantName,
      @JsonKey(name: 'brand_id') String? brandId,
      @JsonKey(name: 'brand_name') String? brandName});
}

/// @nodoc
class _$MerchantModelCopyWithImpl<$Res, $Val extends MerchantModel>
    implements $MerchantModelCopyWith<$Res> {
  _$MerchantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? merchantName = null,
    Object? brandId = freezed,
    Object? brandName = freezed,
  }) {
    return _then(_value.copyWith(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MerchantModelImplCopyWith<$Res>
    implements $MerchantModelCopyWith<$Res> {
  factory _$$MerchantModelImplCopyWith(
          _$MerchantModelImpl value, $Res Function(_$MerchantModelImpl) then) =
      __$$MerchantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'merchant_id') String merchantId,
      @JsonKey(name: 'merchant_name') String merchantName,
      @JsonKey(name: 'brand_id') String? brandId,
      @JsonKey(name: 'brand_name') String? brandName});
}

/// @nodoc
class __$$MerchantModelImplCopyWithImpl<$Res>
    extends _$MerchantModelCopyWithImpl<$Res, _$MerchantModelImpl>
    implements _$$MerchantModelImplCopyWith<$Res> {
  __$$MerchantModelImplCopyWithImpl(
      _$MerchantModelImpl _value, $Res Function(_$MerchantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantId = null,
    Object? merchantName = null,
    Object? brandId = freezed,
    Object? brandName = freezed,
  }) {
    return _then(_$MerchantModelImpl(
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: null == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      brandName: freezed == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantModelImpl implements _MerchantModel {
  const _$MerchantModelImpl(
      {@JsonKey(name: 'merchant_id') required this.merchantId,
      @JsonKey(name: 'merchant_name') required this.merchantName,
      @JsonKey(name: 'brand_id') this.brandId,
      @JsonKey(name: 'brand_name') this.brandName});

  factory _$MerchantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantModelImplFromJson(json);

  @override
  @JsonKey(name: 'merchant_id')
  final String merchantId;
  @override
  @JsonKey(name: 'merchant_name')
  final String merchantName;
  @override
  @JsonKey(name: 'brand_id')
  final String? brandId;
  @override
  @JsonKey(name: 'brand_name')
  final String? brandName;

  @override
  String toString() {
    return 'MerchantModel(merchantId: $merchantId, merchantName: $merchantName, brandId: $brandId, brandName: $brandName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantModelImpl &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, merchantId, merchantName, brandId, brandName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantModelImplCopyWith<_$MerchantModelImpl> get copyWith =>
      __$$MerchantModelImplCopyWithImpl<_$MerchantModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantModelImplToJson(
      this,
    );
  }
}

abstract class _MerchantModel implements MerchantModel {
  const factory _MerchantModel(
          {@JsonKey(name: 'merchant_id') required final String merchantId,
          @JsonKey(name: 'merchant_name') required final String merchantName,
          @JsonKey(name: 'brand_id') final String? brandId,
          @JsonKey(name: 'brand_name') final String? brandName}) =
      _$MerchantModelImpl;

  factory _MerchantModel.fromJson(Map<String, dynamic> json) =
      _$MerchantModelImpl.fromJson;

  @override
  @JsonKey(name: 'merchant_id')
  String get merchantId;
  @override
  @JsonKey(name: 'merchant_name')
  String get merchantName;
  @override
  @JsonKey(name: 'brand_id')
  String? get brandId;
  @override
  @JsonKey(name: 'brand_name')
  String? get brandName;
  @override
  @JsonKey(ignore: true)
  _$$MerchantModelImplCopyWith<_$MerchantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeInfoModel _$EmployeeInfoModelFromJson(Map<String, dynamic> json) {
  return _EmployeeInfoModel.fromJson(json);
}

/// @nodoc
mixin _$EmployeeInfoModel {
  @JsonKey(name: 'employee_id')
  dynamic get employeeId =>
      throw _privateConstructorUsedError; // ⚠️ String或int，兼容"0"和0
  @JsonKey(name: 'post_name')
  String? get postName => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_name')
  String? get orgName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmployeeInfoModelCopyWith<EmployeeInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeInfoModelCopyWith<$Res> {
  factory $EmployeeInfoModelCopyWith(
          EmployeeInfoModel value, $Res Function(EmployeeInfoModel) then) =
      _$EmployeeInfoModelCopyWithImpl<$Res, EmployeeInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_id') dynamic employeeId,
      @JsonKey(name: 'post_name') String? postName,
      @JsonKey(name: 'org_name') String? orgName});
}

/// @nodoc
class _$EmployeeInfoModelCopyWithImpl<$Res, $Val extends EmployeeInfoModel>
    implements $EmployeeInfoModelCopyWith<$Res> {
  _$EmployeeInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = freezed,
    Object? postName = freezed,
    Object? orgName = freezed,
  }) {
    return _then(_value.copyWith(
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postName: freezed == postName
          ? _value.postName
          : postName // ignore: cast_nullable_to_non_nullable
              as String?,
      orgName: freezed == orgName
          ? _value.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeInfoModelImplCopyWith<$Res>
    implements $EmployeeInfoModelCopyWith<$Res> {
  factory _$$EmployeeInfoModelImplCopyWith(_$EmployeeInfoModelImpl value,
          $Res Function(_$EmployeeInfoModelImpl) then) =
      __$$EmployeeInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_id') dynamic employeeId,
      @JsonKey(name: 'post_name') String? postName,
      @JsonKey(name: 'org_name') String? orgName});
}

/// @nodoc
class __$$EmployeeInfoModelImplCopyWithImpl<$Res>
    extends _$EmployeeInfoModelCopyWithImpl<$Res, _$EmployeeInfoModelImpl>
    implements _$$EmployeeInfoModelImplCopyWith<$Res> {
  __$$EmployeeInfoModelImplCopyWithImpl(_$EmployeeInfoModelImpl _value,
      $Res Function(_$EmployeeInfoModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = freezed,
    Object? postName = freezed,
    Object? orgName = freezed,
  }) {
    return _then(_$EmployeeInfoModelImpl(
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postName: freezed == postName
          ? _value.postName
          : postName // ignore: cast_nullable_to_non_nullable
              as String?,
      orgName: freezed == orgName
          ? _value.orgName
          : orgName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeInfoModelImpl implements _EmployeeInfoModel {
  const _$EmployeeInfoModelImpl(
      {@JsonKey(name: 'employee_id') this.employeeId,
      @JsonKey(name: 'post_name') this.postName,
      @JsonKey(name: 'org_name') this.orgName});

  factory _$EmployeeInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'employee_id')
  final dynamic employeeId;
// ⚠️ String或int，兼容"0"和0
  @override
  @JsonKey(name: 'post_name')
  final String? postName;
  @override
  @JsonKey(name: 'org_name')
  final String? orgName;

  @override
  String toString() {
    return 'EmployeeInfoModel(employeeId: $employeeId, postName: $postName, orgName: $orgName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeInfoModelImpl &&
            const DeepCollectionEquality()
                .equals(other.employeeId, employeeId) &&
            (identical(other.postName, postName) ||
                other.postName == postName) &&
            (identical(other.orgName, orgName) || other.orgName == orgName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(employeeId), postName, orgName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeInfoModelImplCopyWith<_$EmployeeInfoModelImpl> get copyWith =>
      __$$EmployeeInfoModelImplCopyWithImpl<_$EmployeeInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeInfoModelImplToJson(
      this,
    );
  }
}

abstract class _EmployeeInfoModel implements EmployeeInfoModel {
  const factory _EmployeeInfoModel(
          {@JsonKey(name: 'employee_id') final dynamic employeeId,
          @JsonKey(name: 'post_name') final String? postName,
          @JsonKey(name: 'org_name') final String? orgName}) =
      _$EmployeeInfoModelImpl;

  factory _EmployeeInfoModel.fromJson(Map<String, dynamic> json) =
      _$EmployeeInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'employee_id')
  dynamic get employeeId;
  @override // ⚠️ String或int，兼容"0"和0
  @JsonKey(name: 'post_name')
  String? get postName;
  @override
  @JsonKey(name: 'org_name')
  String? get orgName;
  @override
  @JsonKey(ignore: true)
  _$$EmployeeInfoModelImplCopyWith<_$EmployeeInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WechatLoginResponse _$WechatLoginResponseFromJson(Map<String, dynamic> json) {
  return _WechatLoginResponse.fromJson(json);
}

/// @nodoc
mixin _$WechatLoginResponse {
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_name')
  String? get studentName => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_info')
  EmployeeInfoModel? get employeeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'major_id')
  dynamic get majorId =>
      throw _privateConstructorUsedError; // ⚠️ String或int，大数值使用String
  @JsonKey(name: 'major_name')
  String? get majorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id')
  dynamic get employeeId =>
      throw _privateConstructorUsedError; // ⚠️ String或int，兼容"0"和0
  @JsonKey(name: 'is_real_name')
  dynamic get isRealName =>
      throw _privateConstructorUsedError; // ⚠️ String或int，兼容"2"和2
  @JsonKey(name: 'promoter_id')
  String? get promoterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'promoter_type')
  dynamic get promoterType =>
      throw _privateConstructorUsedError; // ⚠️ String或int，兼容"2"和2
  @JsonKey(name: 'is_new')
  dynamic get isNew => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WechatLoginResponseCopyWith<WechatLoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WechatLoginResponseCopyWith<$Res> {
  factory $WechatLoginResponseCopyWith(
          WechatLoginResponse value, $Res Function(WechatLoginResponse) then) =
      _$WechatLoginResponseCopyWithImpl<$Res, WechatLoginResponse>;
  @useResult
  $Res call(
      {String token,
      @JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'student_name') String? studentName,
      String? nickname,
      String? avatar,
      String? phone,
      @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
      @JsonKey(name: 'major_id') dynamic majorId,
      @JsonKey(name: 'major_name') String? majorName,
      @JsonKey(name: 'employee_id') dynamic employeeId,
      @JsonKey(name: 'is_real_name') dynamic isRealName,
      @JsonKey(name: 'promoter_id') String? promoterId,
      @JsonKey(name: 'promoter_type') dynamic promoterType,
      @JsonKey(name: 'is_new') dynamic isNew});

  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo;
}

/// @nodoc
class _$WechatLoginResponseCopyWithImpl<$Res, $Val extends WechatLoginResponse>
    implements $WechatLoginResponseCopyWith<$Res> {
  _$WechatLoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? merchants = freezed,
    Object? employeeInfo = freezed,
    Object? majorId = freezed,
    Object? majorName = freezed,
    Object? employeeId = freezed,
    Object? isRealName = freezed,
    Object? promoterId = freezed,
    Object? promoterType = freezed,
    Object? isNew = freezed,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchants: freezed == merchants
          ? _value.merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<MerchantModel>?,
      employeeInfo: freezed == employeeInfo
          ? _value.employeeInfo
          : employeeInfo // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoModel?,
      majorId: freezed == majorId
          ? _value.majorId
          : majorId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      majorName: freezed == majorName
          ? _value.majorName
          : majorName // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isRealName: freezed == isRealName
          ? _value.isRealName
          : isRealName // ignore: cast_nullable_to_non_nullable
              as dynamic,
      promoterId: freezed == promoterId
          ? _value.promoterId
          : promoterId // ignore: cast_nullable_to_non_nullable
              as String?,
      promoterType: freezed == promoterType
          ? _value.promoterType
          : promoterType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isNew: freezed == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo {
    if (_value.employeeInfo == null) {
      return null;
    }

    return $EmployeeInfoModelCopyWith<$Res>(_value.employeeInfo!, (value) {
      return _then(_value.copyWith(employeeInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WechatLoginResponseImplCopyWith<$Res>
    implements $WechatLoginResponseCopyWith<$Res> {
  factory _$$WechatLoginResponseImplCopyWith(_$WechatLoginResponseImpl value,
          $Res Function(_$WechatLoginResponseImpl) then) =
      __$$WechatLoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String token,
      @JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'student_name') String? studentName,
      String? nickname,
      String? avatar,
      String? phone,
      @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
      @JsonKey(name: 'major_id') dynamic majorId,
      @JsonKey(name: 'major_name') String? majorName,
      @JsonKey(name: 'employee_id') dynamic employeeId,
      @JsonKey(name: 'is_real_name') dynamic isRealName,
      @JsonKey(name: 'promoter_id') String? promoterId,
      @JsonKey(name: 'promoter_type') dynamic promoterType,
      @JsonKey(name: 'is_new') dynamic isNew});

  @override
  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo;
}

/// @nodoc
class __$$WechatLoginResponseImplCopyWithImpl<$Res>
    extends _$WechatLoginResponseCopyWithImpl<$Res, _$WechatLoginResponseImpl>
    implements _$$WechatLoginResponseImplCopyWith<$Res> {
  __$$WechatLoginResponseImplCopyWithImpl(_$WechatLoginResponseImpl _value,
      $Res Function(_$WechatLoginResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? merchants = freezed,
    Object? employeeInfo = freezed,
    Object? majorId = freezed,
    Object? majorName = freezed,
    Object? employeeId = freezed,
    Object? isRealName = freezed,
    Object? promoterId = freezed,
    Object? promoterType = freezed,
    Object? isNew = freezed,
  }) {
    return _then(_$WechatLoginResponseImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchants: freezed == merchants
          ? _value._merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<MerchantModel>?,
      employeeInfo: freezed == employeeInfo
          ? _value.employeeInfo
          : employeeInfo // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoModel?,
      majorId: freezed == majorId
          ? _value.majorId
          : majorId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      majorName: freezed == majorName
          ? _value.majorName
          : majorName // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isRealName: freezed == isRealName
          ? _value.isRealName
          : isRealName // ignore: cast_nullable_to_non_nullable
              as dynamic,
      promoterId: freezed == promoterId
          ? _value.promoterId
          : promoterId // ignore: cast_nullable_to_non_nullable
              as String?,
      promoterType: freezed == promoterType
          ? _value.promoterType
          : promoterType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isNew: freezed == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WechatLoginResponseImpl implements _WechatLoginResponse {
  const _$WechatLoginResponseImpl(
      {required this.token,
      @JsonKey(name: 'student_id') required this.studentId,
      @JsonKey(name: 'student_name') this.studentName,
      this.nickname,
      this.avatar,
      this.phone,
      @JsonKey(name: 'merchant') final List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') this.employeeInfo,
      @JsonKey(name: 'major_id') this.majorId,
      @JsonKey(name: 'major_name') this.majorName,
      @JsonKey(name: 'employee_id') this.employeeId,
      @JsonKey(name: 'is_real_name') this.isRealName,
      @JsonKey(name: 'promoter_id') this.promoterId,
      @JsonKey(name: 'promoter_type') this.promoterType,
      @JsonKey(name: 'is_new') this.isNew})
      : _merchants = merchants;

  factory _$WechatLoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WechatLoginResponseImplFromJson(json);

  @override
  final String token;
  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  @JsonKey(name: 'student_name')
  final String? studentName;
  @override
  final String? nickname;
  @override
  final String? avatar;
  @override
  final String? phone;
  final List<MerchantModel>? _merchants;
  @override
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants {
    final value = _merchants;
    if (value == null) return null;
    if (_merchants is EqualUnmodifiableListView) return _merchants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'employee_info')
  final EmployeeInfoModel? employeeInfo;
  @override
  @JsonKey(name: 'major_id')
  final dynamic majorId;
// ⚠️ String或int，大数值使用String
  @override
  @JsonKey(name: 'major_name')
  final String? majorName;
  @override
  @JsonKey(name: 'employee_id')
  final dynamic employeeId;
// ⚠️ String或int，兼容"0"和0
  @override
  @JsonKey(name: 'is_real_name')
  final dynamic isRealName;
// ⚠️ String或int，兼容"2"和2
  @override
  @JsonKey(name: 'promoter_id')
  final String? promoterId;
  @override
  @JsonKey(name: 'promoter_type')
  final dynamic promoterType;
// ⚠️ String或int，兼容"2"和2
  @override
  @JsonKey(name: 'is_new')
  final dynamic isNew;

  @override
  String toString() {
    return 'WechatLoginResponse(token: $token, studentId: $studentId, studentName: $studentName, nickname: $nickname, avatar: $avatar, phone: $phone, merchants: $merchants, employeeInfo: $employeeInfo, majorId: $majorId, majorName: $majorName, employeeId: $employeeId, isRealName: $isRealName, promoterId: $promoterId, promoterType: $promoterType, isNew: $isNew)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WechatLoginResponseImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            const DeepCollectionEquality()
                .equals(other._merchants, _merchants) &&
            (identical(other.employeeInfo, employeeInfo) ||
                other.employeeInfo == employeeInfo) &&
            const DeepCollectionEquality().equals(other.majorId, majorId) &&
            (identical(other.majorName, majorName) ||
                other.majorName == majorName) &&
            const DeepCollectionEquality()
                .equals(other.employeeId, employeeId) &&
            const DeepCollectionEquality()
                .equals(other.isRealName, isRealName) &&
            (identical(other.promoterId, promoterId) ||
                other.promoterId == promoterId) &&
            const DeepCollectionEquality()
                .equals(other.promoterType, promoterType) &&
            const DeepCollectionEquality().equals(other.isNew, isNew));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      token,
      studentId,
      studentName,
      nickname,
      avatar,
      phone,
      const DeepCollectionEquality().hash(_merchants),
      employeeInfo,
      const DeepCollectionEquality().hash(majorId),
      majorName,
      const DeepCollectionEquality().hash(employeeId),
      const DeepCollectionEquality().hash(isRealName),
      promoterId,
      const DeepCollectionEquality().hash(promoterType),
      const DeepCollectionEquality().hash(isNew));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WechatLoginResponseImplCopyWith<_$WechatLoginResponseImpl> get copyWith =>
      __$$WechatLoginResponseImplCopyWithImpl<_$WechatLoginResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WechatLoginResponseImplToJson(
      this,
    );
  }
}

abstract class _WechatLoginResponse implements WechatLoginResponse {
  const factory _WechatLoginResponse(
          {required final String token,
          @JsonKey(name: 'student_id') required final String studentId,
          @JsonKey(name: 'student_name') final String? studentName,
          final String? nickname,
          final String? avatar,
          final String? phone,
          @JsonKey(name: 'merchant') final List<MerchantModel>? merchants,
          @JsonKey(name: 'employee_info') final EmployeeInfoModel? employeeInfo,
          @JsonKey(name: 'major_id') final dynamic majorId,
          @JsonKey(name: 'major_name') final String? majorName,
          @JsonKey(name: 'employee_id') final dynamic employeeId,
          @JsonKey(name: 'is_real_name') final dynamic isRealName,
          @JsonKey(name: 'promoter_id') final String? promoterId,
          @JsonKey(name: 'promoter_type') final dynamic promoterType,
          @JsonKey(name: 'is_new') final dynamic isNew}) =
      _$WechatLoginResponseImpl;

  factory _WechatLoginResponse.fromJson(Map<String, dynamic> json) =
      _$WechatLoginResponseImpl.fromJson;

  @override
  String get token;
  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  @JsonKey(name: 'student_name')
  String? get studentName;
  @override
  String? get nickname;
  @override
  String? get avatar;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants;
  @override
  @JsonKey(name: 'employee_info')
  EmployeeInfoModel? get employeeInfo;
  @override
  @JsonKey(name: 'major_id')
  dynamic get majorId;
  @override // ⚠️ String或int，大数值使用String
  @JsonKey(name: 'major_name')
  String? get majorName;
  @override
  @JsonKey(name: 'employee_id')
  dynamic get employeeId;
  @override // ⚠️ String或int，兼容"0"和0
  @JsonKey(name: 'is_real_name')
  dynamic get isRealName;
  @override // ⚠️ String或int，兼容"2"和2
  @JsonKey(name: 'promoter_id')
  String? get promoterId;
  @override
  @JsonKey(name: 'promoter_type')
  dynamic get promoterType;
  @override // ⚠️ String或int，兼容"2"和2
  @JsonKey(name: 'is_new')
  dynamic get isNew;
  @override
  @JsonKey(ignore: true)
  _$$WechatLoginResponseImplCopyWith<_$WechatLoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return _UserInfoModel.fromJson(json);
}

/// @nodoc
mixin _$UserInfoModel {
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_name')
  String? get studentName => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_info')
  EmployeeInfoModel? get employeeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'major')
  List<MajorModel>? get majors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInfoModelCopyWith<UserInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoModelCopyWith<$Res> {
  factory $UserInfoModelCopyWith(
          UserInfoModel value, $Res Function(UserInfoModel) then) =
      _$UserInfoModelCopyWithImpl<$Res, UserInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'student_name') String? studentName,
      String? nickname,
      String? avatar,
      String? phone,
      @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
      @JsonKey(name: 'major') List<MajorModel>? majors});

  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo;
}

/// @nodoc
class _$UserInfoModelCopyWithImpl<$Res, $Val extends UserInfoModel>
    implements $UserInfoModelCopyWith<$Res> {
  _$UserInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? studentName = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? merchants = freezed,
    Object? employeeInfo = freezed,
    Object? majors = freezed,
  }) {
    return _then(_value.copyWith(
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchants: freezed == merchants
          ? _value.merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<MerchantModel>?,
      employeeInfo: freezed == employeeInfo
          ? _value.employeeInfo
          : employeeInfo // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoModel?,
      majors: freezed == majors
          ? _value.majors
          : majors // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo {
    if (_value.employeeInfo == null) {
      return null;
    }

    return $EmployeeInfoModelCopyWith<$Res>(_value.employeeInfo!, (value) {
      return _then(_value.copyWith(employeeInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserInfoModelImplCopyWith<$Res>
    implements $UserInfoModelCopyWith<$Res> {
  factory _$$UserInfoModelImplCopyWith(
          _$UserInfoModelImpl value, $Res Function(_$UserInfoModelImpl) then) =
      __$$UserInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'student_id') String studentId,
      @JsonKey(name: 'student_name') String? studentName,
      String? nickname,
      String? avatar,
      String? phone,
      @JsonKey(name: 'merchant') List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') EmployeeInfoModel? employeeInfo,
      @JsonKey(name: 'major') List<MajorModel>? majors});

  @override
  $EmployeeInfoModelCopyWith<$Res>? get employeeInfo;
}

/// @nodoc
class __$$UserInfoModelImplCopyWithImpl<$Res>
    extends _$UserInfoModelCopyWithImpl<$Res, _$UserInfoModelImpl>
    implements _$$UserInfoModelImplCopyWith<$Res> {
  __$$UserInfoModelImplCopyWithImpl(
      _$UserInfoModelImpl _value, $Res Function(_$UserInfoModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? studentName = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? phone = freezed,
    Object? merchants = freezed,
    Object? employeeInfo = freezed,
    Object? majors = freezed,
  }) {
    return _then(_$UserInfoModelImpl(
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      merchants: freezed == merchants
          ? _value._merchants
          : merchants // ignore: cast_nullable_to_non_nullable
              as List<MerchantModel>?,
      employeeInfo: freezed == employeeInfo
          ? _value.employeeInfo
          : employeeInfo // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoModel?,
      majors: freezed == majors
          ? _value._majors
          : majors // ignore: cast_nullable_to_non_nullable
              as List<MajorModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoModelImpl implements _UserInfoModel {
  const _$UserInfoModelImpl(
      {@JsonKey(name: 'student_id') required this.studentId,
      @JsonKey(name: 'student_name') this.studentName,
      this.nickname,
      this.avatar,
      this.phone,
      @JsonKey(name: 'merchant') final List<MerchantModel>? merchants,
      @JsonKey(name: 'employee_info') this.employeeInfo,
      @JsonKey(name: 'major') final List<MajorModel>? majors})
      : _merchants = merchants,
        _majors = majors;

  factory _$UserInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  @JsonKey(name: 'student_name')
  final String? studentName;
  @override
  final String? nickname;
  @override
  final String? avatar;
  @override
  final String? phone;
  final List<MerchantModel>? _merchants;
  @override
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants {
    final value = _merchants;
    if (value == null) return null;
    if (_merchants is EqualUnmodifiableListView) return _merchants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'employee_info')
  final EmployeeInfoModel? employeeInfo;
  final List<MajorModel>? _majors;
  @override
  @JsonKey(name: 'major')
  List<MajorModel>? get majors {
    final value = _majors;
    if (value == null) return null;
    if (_majors is EqualUnmodifiableListView) return _majors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserInfoModel(studentId: $studentId, studentName: $studentName, nickname: $nickname, avatar: $avatar, phone: $phone, merchants: $merchants, employeeInfo: $employeeInfo, majors: $majors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoModelImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            const DeepCollectionEquality()
                .equals(other._merchants, _merchants) &&
            (identical(other.employeeInfo, employeeInfo) ||
                other.employeeInfo == employeeInfo) &&
            const DeepCollectionEquality().equals(other._majors, _majors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      studentId,
      studentName,
      nickname,
      avatar,
      phone,
      const DeepCollectionEquality().hash(_merchants),
      employeeInfo,
      const DeepCollectionEquality().hash(_majors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      __$$UserInfoModelImplCopyWithImpl<_$UserInfoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoModelImplToJson(
      this,
    );
  }
}

abstract class _UserInfoModel implements UserInfoModel {
  const factory _UserInfoModel(
          {@JsonKey(name: 'student_id') required final String studentId,
          @JsonKey(name: 'student_name') final String? studentName,
          final String? nickname,
          final String? avatar,
          final String? phone,
          @JsonKey(name: 'merchant') final List<MerchantModel>? merchants,
          @JsonKey(name: 'employee_info') final EmployeeInfoModel? employeeInfo,
          @JsonKey(name: 'major') final List<MajorModel>? majors}) =
      _$UserInfoModelImpl;

  factory _UserInfoModel.fromJson(Map<String, dynamic> json) =
      _$UserInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  @JsonKey(name: 'student_name')
  String? get studentName;
  @override
  String? get nickname;
  @override
  String? get avatar;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'merchant')
  List<MerchantModel>? get merchants;
  @override
  @JsonKey(name: 'employee_info')
  EmployeeInfoModel? get employeeInfo;
  @override
  @JsonKey(name: 'major')
  List<MajorModel>? get majors;
  @override
  @JsonKey(ignore: true)
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
