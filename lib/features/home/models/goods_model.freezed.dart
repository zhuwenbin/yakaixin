// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoodsModel _$GoodsModelFromJson(Map<String, dynamic> json) {
  return _GoodsModel.fromJson(json);
}

/// @nodoc
mixin _$GoodsModel {
  @JsonKey(name: 'id')
  dynamic get goodsId =>
      throw _privateConstructorUsedError; // API可能返回String或int,使用dynamic避免溢出
  @JsonKey(name: 'name')
  String? get goodsName => throw _privateConstructorUsedError; // API返回字段是name
  @JsonKey(name: 'material_cover_path')
  String? get coverImg => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  dynamic get type => throw _privateConstructorUsedError; // 可能是String或int
  @JsonKey(name: 'type_name')
  String? get typeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'details_type')
  dynamic get detailsType =>
      throw _privateConstructorUsedError; // 可能是String或int: 1=经典 2=真题 3=科目 4=模拟
  @JsonKey(name: 'data_type')
  dynamic get dataType =>
      throw _privateConstructorUsedError; // 可能是String或int: 1=普通 2=模考 3=其他
  @JsonKey(name: 'sale_price')
  dynamic get price => throw _privateConstructorUsedError; // 可能是String或num
  @JsonKey(name: 'original_price')
  dynamic get originalPrice =>
      throw _privateConstructorUsedError; // 可能是String或num
  @JsonKey(name: 'permission_status')
  String? get permissionStatus =>
      throw _privateConstructorUsedError; // 权限状态 1:已购买 2:未购买
  @JsonKey(name: 'is_homepage_recommend')
  dynamic get isHomepageRecommend =>
      throw _privateConstructorUsedError; // 可能是String或int
  @JsonKey(name: 'seckill_countdown')
  dynamic get seckillCountdown =>
      throw _privateConstructorUsedError; // ✅ 秒杀倒计时(秒)
  @JsonKey(name: 'teaching_type')
  dynamic get teachingType =>
      throw _privateConstructorUsedError; // 可能是String或int
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_type')
  dynamic get businessType =>
      throw _privateConstructorUsedError; // 可能是String或int
  @JsonKey(name: 'is_recommend')
  dynamic get isRecommend =>
      throw _privateConstructorUsedError; // 可能是String或int
  @JsonKey(name: 'teacher_data')
  List<TeacherModel>? get teacherData => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_number')
  String? get questionNumber => throw _privateConstructorUsedError; // 题目数量
  @JsonKey(name: 'total_class_hour')
  String? get totalClassHour => throw _privateConstructorUsedError; // 总课时
  @JsonKey(name: 'validity_type')
  String? get validityType => throw _privateConstructorUsedError; // 有效期类型
  @JsonKey(name: 'validity_day')
  String? get validityDay => throw _privateConstructorUsedError; // 有效天数
  @JsonKey(name: 'validity_start_date')
  String? get validityStartDate =>
      throw _privateConstructorUsedError; // 有效期开始日期
  @JsonKey(name: 'validity_end_date')
  String? get validityEndDate => throw _privateConstructorUsedError; // 有效期结束日期
  @JsonKey(name: 'service_type_name')
  String? get serviceTypeName => throw _privateConstructorUsedError; // 服务类型名称
  @JsonKey(name: 'new_type_name')
  String? get newTypeName => throw _privateConstructorUsedError; // 新类型名称
  @JsonKey(name: 'student_num')
  dynamic get studentNum => throw _privateConstructorUsedError; // 购买人数
  @JsonKey(name: 'shop_type')
  String? get shopType => throw _privateConstructorUsedError; // 商店类型
  @JsonKey(name: 'tiku_goods_details')
  TikuGoodsDetails? get tikuGoodsDetails => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsModelCopyWith<GoodsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsModelCopyWith<$Res> {
  factory $GoodsModelCopyWith(
          GoodsModel value, $Res Function(GoodsModel) then) =
      _$GoodsModelCopyWithImpl<$Res, GoodsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic goodsId,
      @JsonKey(name: 'name') String? goodsName,
      @JsonKey(name: 'material_cover_path') String? coverImg,
      @JsonKey(name: 'type') dynamic type,
      @JsonKey(name: 'type_name') String? typeName,
      @JsonKey(name: 'details_type') dynamic detailsType,
      @JsonKey(name: 'data_type') dynamic dataType,
      @JsonKey(name: 'sale_price') dynamic price,
      @JsonKey(name: 'original_price') dynamic originalPrice,
      @JsonKey(name: 'permission_status') String? permissionStatus,
      @JsonKey(name: 'is_homepage_recommend') dynamic isHomepageRecommend,
      @JsonKey(name: 'seckill_countdown') dynamic seckillCountdown,
      @JsonKey(name: 'teaching_type') dynamic teachingType,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'business_type') dynamic businessType,
      @JsonKey(name: 'is_recommend') dynamic isRecommend,
      @JsonKey(name: 'teacher_data') List<TeacherModel>? teacherData,
      @JsonKey(name: 'question_number') String? questionNumber,
      @JsonKey(name: 'total_class_hour') String? totalClassHour,
      @JsonKey(name: 'validity_type') String? validityType,
      @JsonKey(name: 'validity_day') String? validityDay,
      @JsonKey(name: 'validity_start_date') String? validityStartDate,
      @JsonKey(name: 'validity_end_date') String? validityEndDate,
      @JsonKey(name: 'service_type_name') String? serviceTypeName,
      @JsonKey(name: 'new_type_name') String? newTypeName,
      @JsonKey(name: 'student_num') dynamic studentNum,
      @JsonKey(name: 'shop_type') String? shopType,
      @JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails});

  $TikuGoodsDetailsCopyWith<$Res>? get tikuGoodsDetails;
}

/// @nodoc
class _$GoodsModelCopyWithImpl<$Res, $Val extends GoodsModel>
    implements $GoodsModelCopyWith<$Res> {
  _$GoodsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? goodsName = freezed,
    Object? coverImg = freezed,
    Object? type = freezed,
    Object? typeName = freezed,
    Object? detailsType = freezed,
    Object? dataType = freezed,
    Object? price = freezed,
    Object? originalPrice = freezed,
    Object? permissionStatus = freezed,
    Object? isHomepageRecommend = freezed,
    Object? seckillCountdown = freezed,
    Object? teachingType = freezed,
    Object? teachingTypeName = freezed,
    Object? businessType = freezed,
    Object? isRecommend = freezed,
    Object? teacherData = freezed,
    Object? questionNumber = freezed,
    Object? totalClassHour = freezed,
    Object? validityType = freezed,
    Object? validityDay = freezed,
    Object? validityStartDate = freezed,
    Object? validityEndDate = freezed,
    Object? serviceTypeName = freezed,
    Object? newTypeName = freezed,
    Object? studentNum = freezed,
    Object? shopType = freezed,
    Object? tikuGoodsDetails = freezed,
  }) {
    return _then(_value.copyWith(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      goodsName: freezed == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImg: freezed == coverImg
          ? _value.coverImg
          : coverImg // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
      typeName: freezed == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String?,
      detailsType: freezed == detailsType
          ? _value.detailsType
          : detailsType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      dataType: freezed == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as dynamic,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as dynamic,
      permissionStatus: freezed == permissionStatus
          ? _value.permissionStatus
          : permissionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      isHomepageRecommend: freezed == isHomepageRecommend
          ? _value.isHomepageRecommend
          : isHomepageRecommend // ignore: cast_nullable_to_non_nullable
              as dynamic,
      seckillCountdown: freezed == seckillCountdown
          ? _value.seckillCountdown
          : seckillCountdown // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teachingType: freezed == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isRecommend: freezed == isRecommend
          ? _value.isRecommend
          : isRecommend // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teacherData: freezed == teacherData
          ? _value.teacherData
          : teacherData // ignore: cast_nullable_to_non_nullable
              as List<TeacherModel>?,
      questionNumber: freezed == questionNumber
          ? _value.questionNumber
          : questionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      totalClassHour: freezed == totalClassHour
          ? _value.totalClassHour
          : totalClassHour // ignore: cast_nullable_to_non_nullable
              as String?,
      validityType: freezed == validityType
          ? _value.validityType
          : validityType // ignore: cast_nullable_to_non_nullable
              as String?,
      validityDay: freezed == validityDay
          ? _value.validityDay
          : validityDay // ignore: cast_nullable_to_non_nullable
              as String?,
      validityStartDate: freezed == validityStartDate
          ? _value.validityStartDate
          : validityStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityEndDate: freezed == validityEndDate
          ? _value.validityEndDate
          : validityEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTypeName: freezed == serviceTypeName
          ? _value.serviceTypeName
          : serviceTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      newTypeName: freezed == newTypeName
          ? _value.newTypeName
          : newTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      studentNum: freezed == studentNum
          ? _value.studentNum
          : studentNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      shopType: freezed == shopType
          ? _value.shopType
          : shopType // ignore: cast_nullable_to_non_nullable
              as String?,
      tikuGoodsDetails: freezed == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as TikuGoodsDetails?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TikuGoodsDetailsCopyWith<$Res>? get tikuGoodsDetails {
    if (_value.tikuGoodsDetails == null) {
      return null;
    }

    return $TikuGoodsDetailsCopyWith<$Res>(_value.tikuGoodsDetails!, (value) {
      return _then(_value.copyWith(tikuGoodsDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoodsModelImplCopyWith<$Res>
    implements $GoodsModelCopyWith<$Res> {
  factory _$$GoodsModelImplCopyWith(
          _$GoodsModelImpl value, $Res Function(_$GoodsModelImpl) then) =
      __$$GoodsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic goodsId,
      @JsonKey(name: 'name') String? goodsName,
      @JsonKey(name: 'material_cover_path') String? coverImg,
      @JsonKey(name: 'type') dynamic type,
      @JsonKey(name: 'type_name') String? typeName,
      @JsonKey(name: 'details_type') dynamic detailsType,
      @JsonKey(name: 'data_type') dynamic dataType,
      @JsonKey(name: 'sale_price') dynamic price,
      @JsonKey(name: 'original_price') dynamic originalPrice,
      @JsonKey(name: 'permission_status') String? permissionStatus,
      @JsonKey(name: 'is_homepage_recommend') dynamic isHomepageRecommend,
      @JsonKey(name: 'seckill_countdown') dynamic seckillCountdown,
      @JsonKey(name: 'teaching_type') dynamic teachingType,
      @JsonKey(name: 'teaching_type_name') String? teachingTypeName,
      @JsonKey(name: 'business_type') dynamic businessType,
      @JsonKey(name: 'is_recommend') dynamic isRecommend,
      @JsonKey(name: 'teacher_data') List<TeacherModel>? teacherData,
      @JsonKey(name: 'question_number') String? questionNumber,
      @JsonKey(name: 'total_class_hour') String? totalClassHour,
      @JsonKey(name: 'validity_type') String? validityType,
      @JsonKey(name: 'validity_day') String? validityDay,
      @JsonKey(name: 'validity_start_date') String? validityStartDate,
      @JsonKey(name: 'validity_end_date') String? validityEndDate,
      @JsonKey(name: 'service_type_name') String? serviceTypeName,
      @JsonKey(name: 'new_type_name') String? newTypeName,
      @JsonKey(name: 'student_num') dynamic studentNum,
      @JsonKey(name: 'shop_type') String? shopType,
      @JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails});

  @override
  $TikuGoodsDetailsCopyWith<$Res>? get tikuGoodsDetails;
}

/// @nodoc
class __$$GoodsModelImplCopyWithImpl<$Res>
    extends _$GoodsModelCopyWithImpl<$Res, _$GoodsModelImpl>
    implements _$$GoodsModelImplCopyWith<$Res> {
  __$$GoodsModelImplCopyWithImpl(
      _$GoodsModelImpl _value, $Res Function(_$GoodsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? goodsName = freezed,
    Object? coverImg = freezed,
    Object? type = freezed,
    Object? typeName = freezed,
    Object? detailsType = freezed,
    Object? dataType = freezed,
    Object? price = freezed,
    Object? originalPrice = freezed,
    Object? permissionStatus = freezed,
    Object? isHomepageRecommend = freezed,
    Object? seckillCountdown = freezed,
    Object? teachingType = freezed,
    Object? teachingTypeName = freezed,
    Object? businessType = freezed,
    Object? isRecommend = freezed,
    Object? teacherData = freezed,
    Object? questionNumber = freezed,
    Object? totalClassHour = freezed,
    Object? validityType = freezed,
    Object? validityDay = freezed,
    Object? validityStartDate = freezed,
    Object? validityEndDate = freezed,
    Object? serviceTypeName = freezed,
    Object? newTypeName = freezed,
    Object? studentNum = freezed,
    Object? shopType = freezed,
    Object? tikuGoodsDetails = freezed,
  }) {
    return _then(_$GoodsModelImpl(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      goodsName: freezed == goodsName
          ? _value.goodsName
          : goodsName // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImg: freezed == coverImg
          ? _value.coverImg
          : coverImg // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
      typeName: freezed == typeName
          ? _value.typeName
          : typeName // ignore: cast_nullable_to_non_nullable
              as String?,
      detailsType: freezed == detailsType
          ? _value.detailsType
          : detailsType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      dataType: freezed == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as dynamic,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as dynamic,
      permissionStatus: freezed == permissionStatus
          ? _value.permissionStatus
          : permissionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      isHomepageRecommend: freezed == isHomepageRecommend
          ? _value.isHomepageRecommend
          : isHomepageRecommend // ignore: cast_nullable_to_non_nullable
              as dynamic,
      seckillCountdown: freezed == seckillCountdown
          ? _value.seckillCountdown
          : seckillCountdown // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teachingType: freezed == teachingType
          ? _value.teachingType
          : teachingType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teachingTypeName: freezed == teachingTypeName
          ? _value.teachingTypeName
          : teachingTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isRecommend: freezed == isRecommend
          ? _value.isRecommend
          : isRecommend // ignore: cast_nullable_to_non_nullable
              as dynamic,
      teacherData: freezed == teacherData
          ? _value._teacherData
          : teacherData // ignore: cast_nullable_to_non_nullable
              as List<TeacherModel>?,
      questionNumber: freezed == questionNumber
          ? _value.questionNumber
          : questionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      totalClassHour: freezed == totalClassHour
          ? _value.totalClassHour
          : totalClassHour // ignore: cast_nullable_to_non_nullable
              as String?,
      validityType: freezed == validityType
          ? _value.validityType
          : validityType // ignore: cast_nullable_to_non_nullable
              as String?,
      validityDay: freezed == validityDay
          ? _value.validityDay
          : validityDay // ignore: cast_nullable_to_non_nullable
              as String?,
      validityStartDate: freezed == validityStartDate
          ? _value.validityStartDate
          : validityStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      validityEndDate: freezed == validityEndDate
          ? _value.validityEndDate
          : validityEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTypeName: freezed == serviceTypeName
          ? _value.serviceTypeName
          : serviceTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      newTypeName: freezed == newTypeName
          ? _value.newTypeName
          : newTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      studentNum: freezed == studentNum
          ? _value.studentNum
          : studentNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      shopType: freezed == shopType
          ? _value.shopType
          : shopType // ignore: cast_nullable_to_non_nullable
              as String?,
      tikuGoodsDetails: freezed == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as TikuGoodsDetails?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoodsModelImpl implements _GoodsModel {
  const _$GoodsModelImpl(
      {@JsonKey(name: 'id') this.goodsId,
      @JsonKey(name: 'name') this.goodsName,
      @JsonKey(name: 'material_cover_path') this.coverImg,
      @JsonKey(name: 'type') this.type,
      @JsonKey(name: 'type_name') this.typeName,
      @JsonKey(name: 'details_type') this.detailsType,
      @JsonKey(name: 'data_type') this.dataType,
      @JsonKey(name: 'sale_price') this.price,
      @JsonKey(name: 'original_price') this.originalPrice,
      @JsonKey(name: 'permission_status') this.permissionStatus,
      @JsonKey(name: 'is_homepage_recommend') this.isHomepageRecommend,
      @JsonKey(name: 'seckill_countdown') this.seckillCountdown,
      @JsonKey(name: 'teaching_type') this.teachingType,
      @JsonKey(name: 'teaching_type_name') this.teachingTypeName,
      @JsonKey(name: 'business_type') this.businessType,
      @JsonKey(name: 'is_recommend') this.isRecommend,
      @JsonKey(name: 'teacher_data') final List<TeacherModel>? teacherData,
      @JsonKey(name: 'question_number') this.questionNumber,
      @JsonKey(name: 'total_class_hour') this.totalClassHour,
      @JsonKey(name: 'validity_type') this.validityType,
      @JsonKey(name: 'validity_day') this.validityDay,
      @JsonKey(name: 'validity_start_date') this.validityStartDate,
      @JsonKey(name: 'validity_end_date') this.validityEndDate,
      @JsonKey(name: 'service_type_name') this.serviceTypeName,
      @JsonKey(name: 'new_type_name') this.newTypeName,
      @JsonKey(name: 'student_num') this.studentNum,
      @JsonKey(name: 'shop_type') this.shopType,
      @JsonKey(name: 'tiku_goods_details') this.tikuGoodsDetails})
      : _teacherData = teacherData;

  factory _$GoodsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoodsModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final dynamic goodsId;
// API可能返回String或int,使用dynamic避免溢出
  @override
  @JsonKey(name: 'name')
  final String? goodsName;
// API返回字段是name
  @override
  @JsonKey(name: 'material_cover_path')
  final String? coverImg;
  @override
  @JsonKey(name: 'type')
  final dynamic type;
// 可能是String或int
  @override
  @JsonKey(name: 'type_name')
  final String? typeName;
  @override
  @JsonKey(name: 'details_type')
  final dynamic detailsType;
// 可能是String或int: 1=经典 2=真题 3=科目 4=模拟
  @override
  @JsonKey(name: 'data_type')
  final dynamic dataType;
// 可能是String或int: 1=普通 2=模考 3=其他
  @override
  @JsonKey(name: 'sale_price')
  final dynamic price;
// 可能是String或num
  @override
  @JsonKey(name: 'original_price')
  final dynamic originalPrice;
// 可能是String或num
  @override
  @JsonKey(name: 'permission_status')
  final String? permissionStatus;
// 权限状态 1:已购买 2:未购买
  @override
  @JsonKey(name: 'is_homepage_recommend')
  final dynamic isHomepageRecommend;
// 可能是String或int
  @override
  @JsonKey(name: 'seckill_countdown')
  final dynamic seckillCountdown;
// ✅ 秒杀倒计时(秒)
  @override
  @JsonKey(name: 'teaching_type')
  final dynamic teachingType;
// 可能是String或int
  @override
  @JsonKey(name: 'teaching_type_name')
  final String? teachingTypeName;
  @override
  @JsonKey(name: 'business_type')
  final dynamic businessType;
// 可能是String或int
  @override
  @JsonKey(name: 'is_recommend')
  final dynamic isRecommend;
// 可能是String或int
  final List<TeacherModel>? _teacherData;
// 可能是String或int
  @override
  @JsonKey(name: 'teacher_data')
  List<TeacherModel>? get teacherData {
    final value = _teacherData;
    if (value == null) return null;
    if (_teacherData is EqualUnmodifiableListView) return _teacherData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'question_number')
  final String? questionNumber;
// 题目数量
  @override
  @JsonKey(name: 'total_class_hour')
  final String? totalClassHour;
// 总课时
  @override
  @JsonKey(name: 'validity_type')
  final String? validityType;
// 有效期类型
  @override
  @JsonKey(name: 'validity_day')
  final String? validityDay;
// 有效天数
  @override
  @JsonKey(name: 'validity_start_date')
  final String? validityStartDate;
// 有效期开始日期
  @override
  @JsonKey(name: 'validity_end_date')
  final String? validityEndDate;
// 有效期结束日期
  @override
  @JsonKey(name: 'service_type_name')
  final String? serviceTypeName;
// 服务类型名称
  @override
  @JsonKey(name: 'new_type_name')
  final String? newTypeName;
// 新类型名称
  @override
  @JsonKey(name: 'student_num')
  final dynamic studentNum;
// 购买人数
  @override
  @JsonKey(name: 'shop_type')
  final String? shopType;
// 商店类型
  @override
  @JsonKey(name: 'tiku_goods_details')
  final TikuGoodsDetails? tikuGoodsDetails;

  @override
  String toString() {
    return 'GoodsModel(goodsId: $goodsId, goodsName: $goodsName, coverImg: $coverImg, type: $type, typeName: $typeName, detailsType: $detailsType, dataType: $dataType, price: $price, originalPrice: $originalPrice, permissionStatus: $permissionStatus, isHomepageRecommend: $isHomepageRecommend, seckillCountdown: $seckillCountdown, teachingType: $teachingType, teachingTypeName: $teachingTypeName, businessType: $businessType, isRecommend: $isRecommend, teacherData: $teacherData, questionNumber: $questionNumber, totalClassHour: $totalClassHour, validityType: $validityType, validityDay: $validityDay, validityStartDate: $validityStartDate, validityEndDate: $validityEndDate, serviceTypeName: $serviceTypeName, newTypeName: $newTypeName, studentNum: $studentNum, shopType: $shopType, tikuGoodsDetails: $tikuGoodsDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsModelImpl &&
            const DeepCollectionEquality().equals(other.goodsId, goodsId) &&
            (identical(other.goodsName, goodsName) ||
                other.goodsName == goodsName) &&
            (identical(other.coverImg, coverImg) ||
                other.coverImg == coverImg) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            const DeepCollectionEquality()
                .equals(other.detailsType, detailsType) &&
            const DeepCollectionEquality().equals(other.dataType, dataType) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality()
                .equals(other.originalPrice, originalPrice) &&
            (identical(other.permissionStatus, permissionStatus) ||
                other.permissionStatus == permissionStatus) &&
            const DeepCollectionEquality()
                .equals(other.isHomepageRecommend, isHomepageRecommend) &&
            const DeepCollectionEquality()
                .equals(other.seckillCountdown, seckillCountdown) &&
            const DeepCollectionEquality()
                .equals(other.teachingType, teachingType) &&
            (identical(other.teachingTypeName, teachingTypeName) ||
                other.teachingTypeName == teachingTypeName) &&
            const DeepCollectionEquality()
                .equals(other.businessType, businessType) &&
            const DeepCollectionEquality()
                .equals(other.isRecommend, isRecommend) &&
            const DeepCollectionEquality()
                .equals(other._teacherData, _teacherData) &&
            (identical(other.questionNumber, questionNumber) ||
                other.questionNumber == questionNumber) &&
            (identical(other.totalClassHour, totalClassHour) ||
                other.totalClassHour == totalClassHour) &&
            (identical(other.validityType, validityType) ||
                other.validityType == validityType) &&
            (identical(other.validityDay, validityDay) ||
                other.validityDay == validityDay) &&
            (identical(other.validityStartDate, validityStartDate) ||
                other.validityStartDate == validityStartDate) &&
            (identical(other.validityEndDate, validityEndDate) ||
                other.validityEndDate == validityEndDate) &&
            (identical(other.serviceTypeName, serviceTypeName) ||
                other.serviceTypeName == serviceTypeName) &&
            (identical(other.newTypeName, newTypeName) ||
                other.newTypeName == newTypeName) &&
            const DeepCollectionEquality()
                .equals(other.studentNum, studentNum) &&
            (identical(other.shopType, shopType) ||
                other.shopType == shopType) &&
            (identical(other.tikuGoodsDetails, tikuGoodsDetails) ||
                other.tikuGoodsDetails == tikuGoodsDetails));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(goodsId),
        goodsName,
        coverImg,
        const DeepCollectionEquality().hash(type),
        typeName,
        const DeepCollectionEquality().hash(detailsType),
        const DeepCollectionEquality().hash(dataType),
        const DeepCollectionEquality().hash(price),
        const DeepCollectionEquality().hash(originalPrice),
        permissionStatus,
        const DeepCollectionEquality().hash(isHomepageRecommend),
        const DeepCollectionEquality().hash(seckillCountdown),
        const DeepCollectionEquality().hash(teachingType),
        teachingTypeName,
        const DeepCollectionEquality().hash(businessType),
        const DeepCollectionEquality().hash(isRecommend),
        const DeepCollectionEquality().hash(_teacherData),
        questionNumber,
        totalClassHour,
        validityType,
        validityDay,
        validityStartDate,
        validityEndDate,
        serviceTypeName,
        newTypeName,
        const DeepCollectionEquality().hash(studentNum),
        shopType,
        tikuGoodsDetails
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsModelImplCopyWith<_$GoodsModelImpl> get copyWith =>
      __$$GoodsModelImplCopyWithImpl<_$GoodsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoodsModelImplToJson(
      this,
    );
  }
}

abstract class _GoodsModel implements GoodsModel {
  const factory _GoodsModel(
      {@JsonKey(name: 'id') final dynamic goodsId,
      @JsonKey(name: 'name') final String? goodsName,
      @JsonKey(name: 'material_cover_path') final String? coverImg,
      @JsonKey(name: 'type') final dynamic type,
      @JsonKey(name: 'type_name') final String? typeName,
      @JsonKey(name: 'details_type') final dynamic detailsType,
      @JsonKey(name: 'data_type') final dynamic dataType,
      @JsonKey(name: 'sale_price') final dynamic price,
      @JsonKey(name: 'original_price') final dynamic originalPrice,
      @JsonKey(name: 'permission_status') final String? permissionStatus,
      @JsonKey(name: 'is_homepage_recommend') final dynamic isHomepageRecommend,
      @JsonKey(name: 'seckill_countdown') final dynamic seckillCountdown,
      @JsonKey(name: 'teaching_type') final dynamic teachingType,
      @JsonKey(name: 'teaching_type_name') final String? teachingTypeName,
      @JsonKey(name: 'business_type') final dynamic businessType,
      @JsonKey(name: 'is_recommend') final dynamic isRecommend,
      @JsonKey(name: 'teacher_data') final List<TeacherModel>? teacherData,
      @JsonKey(name: 'question_number') final String? questionNumber,
      @JsonKey(name: 'total_class_hour') final String? totalClassHour,
      @JsonKey(name: 'validity_type') final String? validityType,
      @JsonKey(name: 'validity_day') final String? validityDay,
      @JsonKey(name: 'validity_start_date') final String? validityStartDate,
      @JsonKey(name: 'validity_end_date') final String? validityEndDate,
      @JsonKey(name: 'service_type_name') final String? serviceTypeName,
      @JsonKey(name: 'new_type_name') final String? newTypeName,
      @JsonKey(name: 'student_num') final dynamic studentNum,
      @JsonKey(name: 'shop_type') final String? shopType,
      @JsonKey(name: 'tiku_goods_details')
      final TikuGoodsDetails? tikuGoodsDetails}) = _$GoodsModelImpl;

  factory _GoodsModel.fromJson(Map<String, dynamic> json) =
      _$GoodsModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  dynamic get goodsId;
  @override // API可能返回String或int,使用dynamic避免溢出
  @JsonKey(name: 'name')
  String? get goodsName;
  @override // API返回字段是name
  @JsonKey(name: 'material_cover_path')
  String? get coverImg;
  @override
  @JsonKey(name: 'type')
  dynamic get type;
  @override // 可能是String或int
  @JsonKey(name: 'type_name')
  String? get typeName;
  @override
  @JsonKey(name: 'details_type')
  dynamic get detailsType;
  @override // 可能是String或int: 1=经典 2=真题 3=科目 4=模拟
  @JsonKey(name: 'data_type')
  dynamic get dataType;
  @override // 可能是String或int: 1=普通 2=模考 3=其他
  @JsonKey(name: 'sale_price')
  dynamic get price;
  @override // 可能是String或num
  @JsonKey(name: 'original_price')
  dynamic get originalPrice;
  @override // 可能是String或num
  @JsonKey(name: 'permission_status')
  String? get permissionStatus;
  @override // 权限状态 1:已购买 2:未购买
  @JsonKey(name: 'is_homepage_recommend')
  dynamic get isHomepageRecommend;
  @override // 可能是String或int
  @JsonKey(name: 'seckill_countdown')
  dynamic get seckillCountdown;
  @override // ✅ 秒杀倒计时(秒)
  @JsonKey(name: 'teaching_type')
  dynamic get teachingType;
  @override // 可能是String或int
  @JsonKey(name: 'teaching_type_name')
  String? get teachingTypeName;
  @override
  @JsonKey(name: 'business_type')
  dynamic get businessType;
  @override // 可能是String或int
  @JsonKey(name: 'is_recommend')
  dynamic get isRecommend;
  @override // 可能是String或int
  @JsonKey(name: 'teacher_data')
  List<TeacherModel>? get teacherData;
  @override
  @JsonKey(name: 'question_number')
  String? get questionNumber;
  @override // 题目数量
  @JsonKey(name: 'total_class_hour')
  String? get totalClassHour;
  @override // 总课时
  @JsonKey(name: 'validity_type')
  String? get validityType;
  @override // 有效期类型
  @JsonKey(name: 'validity_day')
  String? get validityDay;
  @override // 有效天数
  @JsonKey(name: 'validity_start_date')
  String? get validityStartDate;
  @override // 有效期开始日期
  @JsonKey(name: 'validity_end_date')
  String? get validityEndDate;
  @override // 有效期结束日期
  @JsonKey(name: 'service_type_name')
  String? get serviceTypeName;
  @override // 服务类型名称
  @JsonKey(name: 'new_type_name')
  String? get newTypeName;
  @override // 新类型名称
  @JsonKey(name: 'student_num')
  dynamic get studentNum;
  @override // 购买人数
  @JsonKey(name: 'shop_type')
  String? get shopType;
  @override // 商店类型
  @JsonKey(name: 'tiku_goods_details')
  TikuGoodsDetails? get tikuGoodsDetails;
  @override
  @JsonKey(ignore: true)
  _$$GoodsModelImplCopyWith<_$GoodsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TikuGoodsDetails _$TikuGoodsDetailsFromJson(Map<String, dynamic> json) {
  return _TikuGoodsDetails.fromJson(json);
}

/// @nodoc
mixin _$TikuGoodsDetails {
  @JsonKey(name: 'question_num')
  dynamic get questionNum => throw _privateConstructorUsedError; // 题目数量
  @JsonKey(name: 'paper_num')
  dynamic get paperNum => throw _privateConstructorUsedError; // 试卷数量
  @JsonKey(name: 'exam_round_num')
  dynamic get examRoundNum => throw _privateConstructorUsedError; // 考试轮次
  @JsonKey(name: 'exam_time')
  String? get examTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TikuGoodsDetailsCopyWith<TikuGoodsDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TikuGoodsDetailsCopyWith<$Res> {
  factory $TikuGoodsDetailsCopyWith(
          TikuGoodsDetails value, $Res Function(TikuGoodsDetails) then) =
      _$TikuGoodsDetailsCopyWithImpl<$Res, TikuGoodsDetails>;
  @useResult
  $Res call(
      {@JsonKey(name: 'question_num') dynamic questionNum,
      @JsonKey(name: 'paper_num') dynamic paperNum,
      @JsonKey(name: 'exam_round_num') dynamic examRoundNum,
      @JsonKey(name: 'exam_time') String? examTime});
}

/// @nodoc
class _$TikuGoodsDetailsCopyWithImpl<$Res, $Val extends TikuGoodsDetails>
    implements $TikuGoodsDetailsCopyWith<$Res> {
  _$TikuGoodsDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionNum = freezed,
    Object? paperNum = freezed,
    Object? examRoundNum = freezed,
    Object? examTime = freezed,
  }) {
    return _then(_value.copyWith(
      questionNum: freezed == questionNum
          ? _value.questionNum
          : questionNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      paperNum: freezed == paperNum
          ? _value.paperNum
          : paperNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      examRoundNum: freezed == examRoundNum
          ? _value.examRoundNum
          : examRoundNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      examTime: freezed == examTime
          ? _value.examTime
          : examTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TikuGoodsDetailsImplCopyWith<$Res>
    implements $TikuGoodsDetailsCopyWith<$Res> {
  factory _$$TikuGoodsDetailsImplCopyWith(_$TikuGoodsDetailsImpl value,
          $Res Function(_$TikuGoodsDetailsImpl) then) =
      __$$TikuGoodsDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'question_num') dynamic questionNum,
      @JsonKey(name: 'paper_num') dynamic paperNum,
      @JsonKey(name: 'exam_round_num') dynamic examRoundNum,
      @JsonKey(name: 'exam_time') String? examTime});
}

/// @nodoc
class __$$TikuGoodsDetailsImplCopyWithImpl<$Res>
    extends _$TikuGoodsDetailsCopyWithImpl<$Res, _$TikuGoodsDetailsImpl>
    implements _$$TikuGoodsDetailsImplCopyWith<$Res> {
  __$$TikuGoodsDetailsImplCopyWithImpl(_$TikuGoodsDetailsImpl _value,
      $Res Function(_$TikuGoodsDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionNum = freezed,
    Object? paperNum = freezed,
    Object? examRoundNum = freezed,
    Object? examTime = freezed,
  }) {
    return _then(_$TikuGoodsDetailsImpl(
      questionNum: freezed == questionNum
          ? _value.questionNum
          : questionNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      paperNum: freezed == paperNum
          ? _value.paperNum
          : paperNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      examRoundNum: freezed == examRoundNum
          ? _value.examRoundNum
          : examRoundNum // ignore: cast_nullable_to_non_nullable
              as dynamic,
      examTime: freezed == examTime
          ? _value.examTime
          : examTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TikuGoodsDetailsImpl implements _TikuGoodsDetails {
  const _$TikuGoodsDetailsImpl(
      {@JsonKey(name: 'question_num') this.questionNum,
      @JsonKey(name: 'paper_num') this.paperNum,
      @JsonKey(name: 'exam_round_num') this.examRoundNum,
      @JsonKey(name: 'exam_time') this.examTime});

  factory _$TikuGoodsDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TikuGoodsDetailsImplFromJson(json);

  @override
  @JsonKey(name: 'question_num')
  final dynamic questionNum;
// 题目数量
  @override
  @JsonKey(name: 'paper_num')
  final dynamic paperNum;
// 试卷数量
  @override
  @JsonKey(name: 'exam_round_num')
  final dynamic examRoundNum;
// 考试轮次
  @override
  @JsonKey(name: 'exam_time')
  final String? examTime;

  @override
  String toString() {
    return 'TikuGoodsDetails(questionNum: $questionNum, paperNum: $paperNum, examRoundNum: $examRoundNum, examTime: $examTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TikuGoodsDetailsImpl &&
            const DeepCollectionEquality()
                .equals(other.questionNum, questionNum) &&
            const DeepCollectionEquality().equals(other.paperNum, paperNum) &&
            const DeepCollectionEquality()
                .equals(other.examRoundNum, examRoundNum) &&
            (identical(other.examTime, examTime) ||
                other.examTime == examTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(questionNum),
      const DeepCollectionEquality().hash(paperNum),
      const DeepCollectionEquality().hash(examRoundNum),
      examTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TikuGoodsDetailsImplCopyWith<_$TikuGoodsDetailsImpl> get copyWith =>
      __$$TikuGoodsDetailsImplCopyWithImpl<_$TikuGoodsDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TikuGoodsDetailsImplToJson(
      this,
    );
  }
}

abstract class _TikuGoodsDetails implements TikuGoodsDetails {
  const factory _TikuGoodsDetails(
          {@JsonKey(name: 'question_num') final dynamic questionNum,
          @JsonKey(name: 'paper_num') final dynamic paperNum,
          @JsonKey(name: 'exam_round_num') final dynamic examRoundNum,
          @JsonKey(name: 'exam_time') final String? examTime}) =
      _$TikuGoodsDetailsImpl;

  factory _TikuGoodsDetails.fromJson(Map<String, dynamic> json) =
      _$TikuGoodsDetailsImpl.fromJson;

  @override
  @JsonKey(name: 'question_num')
  dynamic get questionNum;
  @override // 题目数量
  @JsonKey(name: 'paper_num')
  dynamic get paperNum;
  @override // 试卷数量
  @JsonKey(name: 'exam_round_num')
  dynamic get examRoundNum;
  @override // 考试轮次
  @JsonKey(name: 'exam_time')
  String? get examTime;
  @override
  @JsonKey(ignore: true)
  _$$TikuGoodsDetailsImplCopyWith<_$TikuGoodsDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) {
  return _TeacherModel.fromJson(json);
}

/// @nodoc
mixin _$TeacherModel {
  @JsonKey(name: 'teacher_id')
  String? get teacherId => throw _privateConstructorUsedError;
  @JsonKey(name: 'teacher_name')
  String? get teacherName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'introduction')
  String? get introduction => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeacherModelCopyWith<TeacherModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherModelCopyWith<$Res> {
  factory $TeacherModelCopyWith(
          TeacherModel value, $Res Function(TeacherModel) then) =
      _$TeacherModelCopyWithImpl<$Res, TeacherModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'teacher_id') String? teacherId,
      @JsonKey(name: 'teacher_name') String? teacherName,
      @JsonKey(name: 'avatar') String? avatar,
      @JsonKey(name: 'introduction') String? introduction});
}

/// @nodoc
class _$TeacherModelCopyWithImpl<$Res, $Val extends TeacherModel>
    implements $TeacherModelCopyWith<$Res> {
  _$TeacherModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teacherId = freezed,
    Object? teacherName = freezed,
    Object? avatar = freezed,
    Object? introduction = freezed,
  }) {
    return _then(_value.copyWith(
      teacherId: freezed == teacherId
          ? _value.teacherId
          : teacherId // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherName: freezed == teacherName
          ? _value.teacherName
          : teacherName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeacherModelImplCopyWith<$Res>
    implements $TeacherModelCopyWith<$Res> {
  factory _$$TeacherModelImplCopyWith(
          _$TeacherModelImpl value, $Res Function(_$TeacherModelImpl) then) =
      __$$TeacherModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'teacher_id') String? teacherId,
      @JsonKey(name: 'teacher_name') String? teacherName,
      @JsonKey(name: 'avatar') String? avatar,
      @JsonKey(name: 'introduction') String? introduction});
}

/// @nodoc
class __$$TeacherModelImplCopyWithImpl<$Res>
    extends _$TeacherModelCopyWithImpl<$Res, _$TeacherModelImpl>
    implements _$$TeacherModelImplCopyWith<$Res> {
  __$$TeacherModelImplCopyWithImpl(
      _$TeacherModelImpl _value, $Res Function(_$TeacherModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teacherId = freezed,
    Object? teacherName = freezed,
    Object? avatar = freezed,
    Object? introduction = freezed,
  }) {
    return _then(_$TeacherModelImpl(
      teacherId: freezed == teacherId
          ? _value.teacherId
          : teacherId // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherName: freezed == teacherName
          ? _value.teacherName
          : teacherName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherModelImpl implements _TeacherModel {
  const _$TeacherModelImpl(
      {@JsonKey(name: 'teacher_id') this.teacherId,
      @JsonKey(name: 'teacher_name') this.teacherName,
      @JsonKey(name: 'avatar') this.avatar,
      @JsonKey(name: 'introduction') this.introduction});

  factory _$TeacherModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherModelImplFromJson(json);

  @override
  @JsonKey(name: 'teacher_id')
  final String? teacherId;
  @override
  @JsonKey(name: 'teacher_name')
  final String? teacherName;
  @override
  @JsonKey(name: 'avatar')
  final String? avatar;
  @override
  @JsonKey(name: 'introduction')
  final String? introduction;

  @override
  String toString() {
    return 'TeacherModel(teacherId: $teacherId, teacherName: $teacherName, avatar: $avatar, introduction: $introduction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherModelImpl &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.teacherName, teacherName) ||
                other.teacherName == teacherName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, teacherId, teacherName, avatar, introduction);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherModelImplCopyWith<_$TeacherModelImpl> get copyWith =>
      __$$TeacherModelImplCopyWithImpl<_$TeacherModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherModelImplToJson(
      this,
    );
  }
}

abstract class _TeacherModel implements TeacherModel {
  const factory _TeacherModel(
          {@JsonKey(name: 'teacher_id') final String? teacherId,
          @JsonKey(name: 'teacher_name') final String? teacherName,
          @JsonKey(name: 'avatar') final String? avatar,
          @JsonKey(name: 'introduction') final String? introduction}) =
      _$TeacherModelImpl;

  factory _TeacherModel.fromJson(Map<String, dynamic> json) =
      _$TeacherModelImpl.fromJson;

  @override
  @JsonKey(name: 'teacher_id')
  String? get teacherId;
  @override
  @JsonKey(name: 'teacher_name')
  String? get teacherName;
  @override
  @JsonKey(name: 'avatar')
  String? get avatar;
  @override
  @JsonKey(name: 'introduction')
  String? get introduction;
  @override
  @JsonKey(ignore: true)
  _$$TeacherModelImplCopyWith<_$TeacherModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoodsListResponse _$GoodsListResponseFromJson(Map<String, dynamic> json) {
  return _GoodsListResponse.fromJson(json);
}

/// @nodoc
mixin _$GoodsListResponse {
  @JsonKey(name: 'list')
  List<GoodsModel> get list =>
      throw _privateConstructorUsedError; // 使用默认空数组,避免null导致的类型转换错误
  @JsonKey(name: 'total')
  int? get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsListResponseCopyWith<GoodsListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsListResponseCopyWith<$Res> {
  factory $GoodsListResponseCopyWith(
          GoodsListResponse value, $Res Function(GoodsListResponse) then) =
      _$GoodsListResponseCopyWithImpl<$Res, GoodsListResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'list') List<GoodsModel> list,
      @JsonKey(name: 'total') int? total});
}

/// @nodoc
class _$GoodsListResponseCopyWithImpl<$Res, $Val extends GoodsListResponse>
    implements $GoodsListResponseCopyWith<$Res> {
  _$GoodsListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = freezed,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoodsListResponseImplCopyWith<$Res>
    implements $GoodsListResponseCopyWith<$Res> {
  factory _$$GoodsListResponseImplCopyWith(_$GoodsListResponseImpl value,
          $Res Function(_$GoodsListResponseImpl) then) =
      __$$GoodsListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'list') List<GoodsModel> list,
      @JsonKey(name: 'total') int? total});
}

/// @nodoc
class __$$GoodsListResponseImplCopyWithImpl<$Res>
    extends _$GoodsListResponseCopyWithImpl<$Res, _$GoodsListResponseImpl>
    implements _$$GoodsListResponseImplCopyWith<$Res> {
  __$$GoodsListResponseImplCopyWithImpl(_$GoodsListResponseImpl _value,
      $Res Function(_$GoodsListResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = freezed,
  }) {
    return _then(_$GoodsListResponseImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<GoodsModel>,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoodsListResponseImpl implements _GoodsListResponse {
  const _$GoodsListResponseImpl(
      {@JsonKey(name: 'list') final List<GoodsModel> list = const [],
      @JsonKey(name: 'total') this.total})
      : _list = list;

  factory _$GoodsListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoodsListResponseImplFromJson(json);

  final List<GoodsModel> _list;
  @override
  @JsonKey(name: 'list')
  List<GoodsModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

// 使用默认空数组,避免null导致的类型转换错误
  @override
  @JsonKey(name: 'total')
  final int? total;

  @override
  String toString() {
    return 'GoodsListResponse(list: $list, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsListResponseImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_list), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsListResponseImplCopyWith<_$GoodsListResponseImpl> get copyWith =>
      __$$GoodsListResponseImplCopyWithImpl<_$GoodsListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoodsListResponseImplToJson(
      this,
    );
  }
}

abstract class _GoodsListResponse implements GoodsListResponse {
  const factory _GoodsListResponse(
      {@JsonKey(name: 'list') final List<GoodsModel> list,
      @JsonKey(name: 'total') final int? total}) = _$GoodsListResponseImpl;

  factory _GoodsListResponse.fromJson(Map<String, dynamic> json) =
      _$GoodsListResponseImpl.fromJson;

  @override
  @JsonKey(name: 'list')
  List<GoodsModel> get list;
  @override // 使用默认空数组,避免null导致的类型转换错误
  @JsonKey(name: 'total')
  int? get total;
  @override
  @JsonKey(ignore: true)
  _$$GoodsListResponseImplCopyWith<_$GoodsListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
