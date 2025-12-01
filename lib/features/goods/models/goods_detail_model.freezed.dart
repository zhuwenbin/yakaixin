// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoodsDetailModel _$GoodsDetailModelFromJson(Map<String, dynamic> json) {
  return _GoodsDetailModel.fromJson(json);
}

/// @nodoc
mixin _$GoodsDetailModel {
  @JsonKey(name: 'id')
  dynamic get goodsId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  dynamic get type =>
      throw _privateConstructorUsedError; // 18=章节练习, 8=试卷, 10=模考
  @JsonKey(name: 'material_cover_path')
  String? get materialCoverPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'material_intro_path')
  String? get materialIntroPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'long_img_path')
  String? get longImgPath => throw _privateConstructorUsedError; // 长图路径（科目模考专用）
  @JsonKey(name: 'permission_status')
  String? get permissionStatus =>
      throw _privateConstructorUsedError; // 1=已购买, 2=未购买
  @JsonKey(name: 'professional_id')
  String? get professionalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'professional_id_name')
  String? get professionalIdName => throw _privateConstructorUsedError;
  @JsonKey(name: 'year')
  String? get year => throw _privateConstructorUsedError;
  @JsonKey(name: 'exam_title')
  String? get examTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'prices')
  List<GoodsPriceModel> get prices => throw _privateConstructorUsedError;
  @JsonKey(name: 'tiku_goods_details')
  TikuGoodsDetails? get tikuGoodsDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'teaching_system')
  TeachingSystem? get teachingSystem => throw _privateConstructorUsedError;
  @JsonKey(name: 'paper_statistics')
  PaperStatistics? get paperStatistics => throw _privateConstructorUsedError;
  @JsonKey(name: 'recitation_question_model')
  dynamic get recitationQuestionModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'permission_order_id')
  dynamic get permissionOrderId =>
      throw _privateConstructorUsedError; // ✅ 新增：套餐包含的商品列表
  @JsonKey(name: 'detail_package_goods')
  List<PackageGoodsModel>? get detailPackageGoods =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsDetailModelCopyWith<GoodsDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsDetailModelCopyWith<$Res> {
  factory $GoodsDetailModelCopyWith(
          GoodsDetailModel value, $Res Function(GoodsDetailModel) then) =
      _$GoodsDetailModelCopyWithImpl<$Res, GoodsDetailModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic goodsId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'type') dynamic type,
      @JsonKey(name: 'material_cover_path') String? materialCoverPath,
      @JsonKey(name: 'material_intro_path') String? materialIntroPath,
      @JsonKey(name: 'long_img_path') String? longImgPath,
      @JsonKey(name: 'permission_status') String? permissionStatus,
      @JsonKey(name: 'professional_id') String? professionalId,
      @JsonKey(name: 'professional_id_name') String? professionalIdName,
      @JsonKey(name: 'year') String? year,
      @JsonKey(name: 'exam_title') String? examTitle,
      @JsonKey(name: 'prices') List<GoodsPriceModel> prices,
      @JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system') TeachingSystem? teachingSystem,
      @JsonKey(name: 'paper_statistics') PaperStatistics? paperStatistics,
      @JsonKey(name: 'recitation_question_model')
      dynamic recitationQuestionModel,
      @JsonKey(name: 'permission_order_id') dynamic permissionOrderId,
      @JsonKey(name: 'detail_package_goods')
      List<PackageGoodsModel>? detailPackageGoods});

  $TikuGoodsDetailsCopyWith<$Res>? get tikuGoodsDetails;
  $TeachingSystemCopyWith<$Res>? get teachingSystem;
  $PaperStatisticsCopyWith<$Res>? get paperStatistics;
}

/// @nodoc
class _$GoodsDetailModelCopyWithImpl<$Res, $Val extends GoodsDetailModel>
    implements $GoodsDetailModelCopyWith<$Res> {
  _$GoodsDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? name = freezed,
    Object? type = freezed,
    Object? materialCoverPath = freezed,
    Object? materialIntroPath = freezed,
    Object? longImgPath = freezed,
    Object? permissionStatus = freezed,
    Object? professionalId = freezed,
    Object? professionalIdName = freezed,
    Object? year = freezed,
    Object? examTitle = freezed,
    Object? prices = null,
    Object? tikuGoodsDetails = freezed,
    Object? teachingSystem = freezed,
    Object? paperStatistics = freezed,
    Object? recitationQuestionModel = freezed,
    Object? permissionOrderId = freezed,
    Object? detailPackageGoods = freezed,
  }) {
    return _then(_value.copyWith(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
      materialCoverPath: freezed == materialCoverPath
          ? _value.materialCoverPath
          : materialCoverPath // ignore: cast_nullable_to_non_nullable
              as String?,
      materialIntroPath: freezed == materialIntroPath
          ? _value.materialIntroPath
          : materialIntroPath // ignore: cast_nullable_to_non_nullable
              as String?,
      longImgPath: freezed == longImgPath
          ? _value.longImgPath
          : longImgPath // ignore: cast_nullable_to_non_nullable
              as String?,
      permissionStatus: freezed == permissionStatus
          ? _value.permissionStatus
          : permissionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalId: freezed == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalIdName: freezed == professionalIdName
          ? _value.professionalIdName
          : professionalIdName // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      examTitle: freezed == examTitle
          ? _value.examTitle
          : examTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      prices: null == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as List<GoodsPriceModel>,
      tikuGoodsDetails: freezed == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as TikuGoodsDetails?,
      teachingSystem: freezed == teachingSystem
          ? _value.teachingSystem
          : teachingSystem // ignore: cast_nullable_to_non_nullable
              as TeachingSystem?,
      paperStatistics: freezed == paperStatistics
          ? _value.paperStatistics
          : paperStatistics // ignore: cast_nullable_to_non_nullable
              as PaperStatistics?,
      recitationQuestionModel: freezed == recitationQuestionModel
          ? _value.recitationQuestionModel
          : recitationQuestionModel // ignore: cast_nullable_to_non_nullable
              as dynamic,
      permissionOrderId: freezed == permissionOrderId
          ? _value.permissionOrderId
          : permissionOrderId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      detailPackageGoods: freezed == detailPackageGoods
          ? _value.detailPackageGoods
          : detailPackageGoods // ignore: cast_nullable_to_non_nullable
              as List<PackageGoodsModel>?,
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

  @override
  @pragma('vm:prefer-inline')
  $TeachingSystemCopyWith<$Res>? get teachingSystem {
    if (_value.teachingSystem == null) {
      return null;
    }

    return $TeachingSystemCopyWith<$Res>(_value.teachingSystem!, (value) {
      return _then(_value.copyWith(teachingSystem: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PaperStatisticsCopyWith<$Res>? get paperStatistics {
    if (_value.paperStatistics == null) {
      return null;
    }

    return $PaperStatisticsCopyWith<$Res>(_value.paperStatistics!, (value) {
      return _then(_value.copyWith(paperStatistics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoodsDetailModelImplCopyWith<$Res>
    implements $GoodsDetailModelCopyWith<$Res> {
  factory _$$GoodsDetailModelImplCopyWith(_$GoodsDetailModelImpl value,
          $Res Function(_$GoodsDetailModelImpl) then) =
      __$$GoodsDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic goodsId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'type') dynamic type,
      @JsonKey(name: 'material_cover_path') String? materialCoverPath,
      @JsonKey(name: 'material_intro_path') String? materialIntroPath,
      @JsonKey(name: 'long_img_path') String? longImgPath,
      @JsonKey(name: 'permission_status') String? permissionStatus,
      @JsonKey(name: 'professional_id') String? professionalId,
      @JsonKey(name: 'professional_id_name') String? professionalIdName,
      @JsonKey(name: 'year') String? year,
      @JsonKey(name: 'exam_title') String? examTitle,
      @JsonKey(name: 'prices') List<GoodsPriceModel> prices,
      @JsonKey(name: 'tiku_goods_details') TikuGoodsDetails? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system') TeachingSystem? teachingSystem,
      @JsonKey(name: 'paper_statistics') PaperStatistics? paperStatistics,
      @JsonKey(name: 'recitation_question_model')
      dynamic recitationQuestionModel,
      @JsonKey(name: 'permission_order_id') dynamic permissionOrderId,
      @JsonKey(name: 'detail_package_goods')
      List<PackageGoodsModel>? detailPackageGoods});

  @override
  $TikuGoodsDetailsCopyWith<$Res>? get tikuGoodsDetails;
  @override
  $TeachingSystemCopyWith<$Res>? get teachingSystem;
  @override
  $PaperStatisticsCopyWith<$Res>? get paperStatistics;
}

/// @nodoc
class __$$GoodsDetailModelImplCopyWithImpl<$Res>
    extends _$GoodsDetailModelCopyWithImpl<$Res, _$GoodsDetailModelImpl>
    implements _$$GoodsDetailModelImplCopyWith<$Res> {
  __$$GoodsDetailModelImplCopyWithImpl(_$GoodsDetailModelImpl _value,
      $Res Function(_$GoodsDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsId = freezed,
    Object? name = freezed,
    Object? type = freezed,
    Object? materialCoverPath = freezed,
    Object? materialIntroPath = freezed,
    Object? longImgPath = freezed,
    Object? permissionStatus = freezed,
    Object? professionalId = freezed,
    Object? professionalIdName = freezed,
    Object? year = freezed,
    Object? examTitle = freezed,
    Object? prices = null,
    Object? tikuGoodsDetails = freezed,
    Object? teachingSystem = freezed,
    Object? paperStatistics = freezed,
    Object? recitationQuestionModel = freezed,
    Object? permissionOrderId = freezed,
    Object? detailPackageGoods = freezed,
  }) {
    return _then(_$GoodsDetailModelImpl(
      goodsId: freezed == goodsId
          ? _value.goodsId
          : goodsId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
      materialCoverPath: freezed == materialCoverPath
          ? _value.materialCoverPath
          : materialCoverPath // ignore: cast_nullable_to_non_nullable
              as String?,
      materialIntroPath: freezed == materialIntroPath
          ? _value.materialIntroPath
          : materialIntroPath // ignore: cast_nullable_to_non_nullable
              as String?,
      longImgPath: freezed == longImgPath
          ? _value.longImgPath
          : longImgPath // ignore: cast_nullable_to_non_nullable
              as String?,
      permissionStatus: freezed == permissionStatus
          ? _value.permissionStatus
          : permissionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalId: freezed == professionalId
          ? _value.professionalId
          : professionalId // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalIdName: freezed == professionalIdName
          ? _value.professionalIdName
          : professionalIdName // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      examTitle: freezed == examTitle
          ? _value.examTitle
          : examTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      prices: null == prices
          ? _value._prices
          : prices // ignore: cast_nullable_to_non_nullable
              as List<GoodsPriceModel>,
      tikuGoodsDetails: freezed == tikuGoodsDetails
          ? _value.tikuGoodsDetails
          : tikuGoodsDetails // ignore: cast_nullable_to_non_nullable
              as TikuGoodsDetails?,
      teachingSystem: freezed == teachingSystem
          ? _value.teachingSystem
          : teachingSystem // ignore: cast_nullable_to_non_nullable
              as TeachingSystem?,
      paperStatistics: freezed == paperStatistics
          ? _value.paperStatistics
          : paperStatistics // ignore: cast_nullable_to_non_nullable
              as PaperStatistics?,
      recitationQuestionModel: freezed == recitationQuestionModel
          ? _value.recitationQuestionModel
          : recitationQuestionModel // ignore: cast_nullable_to_non_nullable
              as dynamic,
      permissionOrderId: freezed == permissionOrderId
          ? _value.permissionOrderId
          : permissionOrderId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      detailPackageGoods: freezed == detailPackageGoods
          ? _value._detailPackageGoods
          : detailPackageGoods // ignore: cast_nullable_to_non_nullable
              as List<PackageGoodsModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoodsDetailModelImpl implements _GoodsDetailModel {
  const _$GoodsDetailModelImpl(
      {@JsonKey(name: 'id') this.goodsId,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'type') this.type,
      @JsonKey(name: 'material_cover_path') this.materialCoverPath,
      @JsonKey(name: 'material_intro_path') this.materialIntroPath,
      @JsonKey(name: 'long_img_path') this.longImgPath,
      @JsonKey(name: 'permission_status') this.permissionStatus,
      @JsonKey(name: 'professional_id') this.professionalId,
      @JsonKey(name: 'professional_id_name') this.professionalIdName,
      @JsonKey(name: 'year') this.year,
      @JsonKey(name: 'exam_title') this.examTitle,
      @JsonKey(name: 'prices') final List<GoodsPriceModel> prices = const [],
      @JsonKey(name: 'tiku_goods_details') this.tikuGoodsDetails,
      @JsonKey(name: 'teaching_system') this.teachingSystem,
      @JsonKey(name: 'paper_statistics') this.paperStatistics,
      @JsonKey(name: 'recitation_question_model') this.recitationQuestionModel,
      @JsonKey(name: 'permission_order_id') this.permissionOrderId,
      @JsonKey(name: 'detail_package_goods')
      final List<PackageGoodsModel>? detailPackageGoods})
      : _prices = prices,
        _detailPackageGoods = detailPackageGoods;

  factory _$GoodsDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoodsDetailModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final dynamic goodsId;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'type')
  final dynamic type;
// 18=章节练习, 8=试卷, 10=模考
  @override
  @JsonKey(name: 'material_cover_path')
  final String? materialCoverPath;
  @override
  @JsonKey(name: 'material_intro_path')
  final String? materialIntroPath;
  @override
  @JsonKey(name: 'long_img_path')
  final String? longImgPath;
// 长图路径（科目模考专用）
  @override
  @JsonKey(name: 'permission_status')
  final String? permissionStatus;
// 1=已购买, 2=未购买
  @override
  @JsonKey(name: 'professional_id')
  final String? professionalId;
  @override
  @JsonKey(name: 'professional_id_name')
  final String? professionalIdName;
  @override
  @JsonKey(name: 'year')
  final String? year;
  @override
  @JsonKey(name: 'exam_title')
  final String? examTitle;
  final List<GoodsPriceModel> _prices;
  @override
  @JsonKey(name: 'prices')
  List<GoodsPriceModel> get prices {
    if (_prices is EqualUnmodifiableListView) return _prices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prices);
  }

  @override
  @JsonKey(name: 'tiku_goods_details')
  final TikuGoodsDetails? tikuGoodsDetails;
  @override
  @JsonKey(name: 'teaching_system')
  final TeachingSystem? teachingSystem;
  @override
  @JsonKey(name: 'paper_statistics')
  final PaperStatistics? paperStatistics;
  @override
  @JsonKey(name: 'recitation_question_model')
  final dynamic recitationQuestionModel;
  @override
  @JsonKey(name: 'permission_order_id')
  final dynamic permissionOrderId;
// ✅ 新增：套餐包含的商品列表
  final List<PackageGoodsModel>? _detailPackageGoods;
// ✅ 新增：套餐包含的商品列表
  @override
  @JsonKey(name: 'detail_package_goods')
  List<PackageGoodsModel>? get detailPackageGoods {
    final value = _detailPackageGoods;
    if (value == null) return null;
    if (_detailPackageGoods is EqualUnmodifiableListView)
      return _detailPackageGoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GoodsDetailModel(goodsId: $goodsId, name: $name, type: $type, materialCoverPath: $materialCoverPath, materialIntroPath: $materialIntroPath, longImgPath: $longImgPath, permissionStatus: $permissionStatus, professionalId: $professionalId, professionalIdName: $professionalIdName, year: $year, examTitle: $examTitle, prices: $prices, tikuGoodsDetails: $tikuGoodsDetails, teachingSystem: $teachingSystem, paperStatistics: $paperStatistics, recitationQuestionModel: $recitationQuestionModel, permissionOrderId: $permissionOrderId, detailPackageGoods: $detailPackageGoods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsDetailModelImpl &&
            const DeepCollectionEquality().equals(other.goodsId, goodsId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            (identical(other.materialCoverPath, materialCoverPath) ||
                other.materialCoverPath == materialCoverPath) &&
            (identical(other.materialIntroPath, materialIntroPath) ||
                other.materialIntroPath == materialIntroPath) &&
            (identical(other.longImgPath, longImgPath) ||
                other.longImgPath == longImgPath) &&
            (identical(other.permissionStatus, permissionStatus) ||
                other.permissionStatus == permissionStatus) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.professionalIdName, professionalIdName) ||
                other.professionalIdName == professionalIdName) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.examTitle, examTitle) ||
                other.examTitle == examTitle) &&
            const DeepCollectionEquality().equals(other._prices, _prices) &&
            (identical(other.tikuGoodsDetails, tikuGoodsDetails) ||
                other.tikuGoodsDetails == tikuGoodsDetails) &&
            (identical(other.teachingSystem, teachingSystem) ||
                other.teachingSystem == teachingSystem) &&
            (identical(other.paperStatistics, paperStatistics) ||
                other.paperStatistics == paperStatistics) &&
            const DeepCollectionEquality().equals(
                other.recitationQuestionModel, recitationQuestionModel) &&
            const DeepCollectionEquality()
                .equals(other.permissionOrderId, permissionOrderId) &&
            const DeepCollectionEquality()
                .equals(other._detailPackageGoods, _detailPackageGoods));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(goodsId),
      name,
      const DeepCollectionEquality().hash(type),
      materialCoverPath,
      materialIntroPath,
      longImgPath,
      permissionStatus,
      professionalId,
      professionalIdName,
      year,
      examTitle,
      const DeepCollectionEquality().hash(_prices),
      tikuGoodsDetails,
      teachingSystem,
      paperStatistics,
      const DeepCollectionEquality().hash(recitationQuestionModel),
      const DeepCollectionEquality().hash(permissionOrderId),
      const DeepCollectionEquality().hash(_detailPackageGoods));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsDetailModelImplCopyWith<_$GoodsDetailModelImpl> get copyWith =>
      __$$GoodsDetailModelImplCopyWithImpl<_$GoodsDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoodsDetailModelImplToJson(
      this,
    );
  }
}

abstract class _GoodsDetailModel implements GoodsDetailModel {
  const factory _GoodsDetailModel(
      {@JsonKey(name: 'id') final dynamic goodsId,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'type') final dynamic type,
      @JsonKey(name: 'material_cover_path') final String? materialCoverPath,
      @JsonKey(name: 'material_intro_path') final String? materialIntroPath,
      @JsonKey(name: 'long_img_path') final String? longImgPath,
      @JsonKey(name: 'permission_status') final String? permissionStatus,
      @JsonKey(name: 'professional_id') final String? professionalId,
      @JsonKey(name: 'professional_id_name') final String? professionalIdName,
      @JsonKey(name: 'year') final String? year,
      @JsonKey(name: 'exam_title') final String? examTitle,
      @JsonKey(name: 'prices') final List<GoodsPriceModel> prices,
      @JsonKey(name: 'tiku_goods_details')
      final TikuGoodsDetails? tikuGoodsDetails,
      @JsonKey(name: 'teaching_system') final TeachingSystem? teachingSystem,
      @JsonKey(name: 'paper_statistics') final PaperStatistics? paperStatistics,
      @JsonKey(name: 'recitation_question_model')
      final dynamic recitationQuestionModel,
      @JsonKey(name: 'permission_order_id') final dynamic permissionOrderId,
      @JsonKey(name: 'detail_package_goods')
      final List<PackageGoodsModel>?
          detailPackageGoods}) = _$GoodsDetailModelImpl;

  factory _GoodsDetailModel.fromJson(Map<String, dynamic> json) =
      _$GoodsDetailModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  dynamic get goodsId;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'type')
  dynamic get type;
  @override // 18=章节练习, 8=试卷, 10=模考
  @JsonKey(name: 'material_cover_path')
  String? get materialCoverPath;
  @override
  @JsonKey(name: 'material_intro_path')
  String? get materialIntroPath;
  @override
  @JsonKey(name: 'long_img_path')
  String? get longImgPath;
  @override // 长图路径（科目模考专用）
  @JsonKey(name: 'permission_status')
  String? get permissionStatus;
  @override // 1=已购买, 2=未购买
  @JsonKey(name: 'professional_id')
  String? get professionalId;
  @override
  @JsonKey(name: 'professional_id_name')
  String? get professionalIdName;
  @override
  @JsonKey(name: 'year')
  String? get year;
  @override
  @JsonKey(name: 'exam_title')
  String? get examTitle;
  @override
  @JsonKey(name: 'prices')
  List<GoodsPriceModel> get prices;
  @override
  @JsonKey(name: 'tiku_goods_details')
  TikuGoodsDetails? get tikuGoodsDetails;
  @override
  @JsonKey(name: 'teaching_system')
  TeachingSystem? get teachingSystem;
  @override
  @JsonKey(name: 'paper_statistics')
  PaperStatistics? get paperStatistics;
  @override
  @JsonKey(name: 'recitation_question_model')
  dynamic get recitationQuestionModel;
  @override
  @JsonKey(name: 'permission_order_id')
  dynamic get permissionOrderId;
  @override // ✅ 新增：套餐包含的商品列表
  @JsonKey(name: 'detail_package_goods')
  List<PackageGoodsModel>? get detailPackageGoods;
  @override
  @JsonKey(ignore: true)
  _$$GoodsDetailModelImplCopyWith<_$GoodsDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoodsPriceModel _$GoodsPriceModelFromJson(Map<String, dynamic> json) {
  return _GoodsPriceModel.fromJson(json);
}

/// @nodoc
mixin _$GoodsPriceModel {
  @JsonKey(name: 'goods_months_price_id')
  String? get goodsMonthsPriceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'month')
  dynamic get month => throw _privateConstructorUsedError; // 0=永久
  @JsonKey(name: 'sale_price')
  String? get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_price')
  String? get originalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'days')
  String? get days => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsPriceModelCopyWith<GoodsPriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsPriceModelCopyWith<$Res> {
  factory $GoodsPriceModelCopyWith(
          GoodsPriceModel value, $Res Function(GoodsPriceModel) then) =
      _$GoodsPriceModelCopyWithImpl<$Res, GoodsPriceModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_months_price_id') String? goodsMonthsPriceId,
      @JsonKey(name: 'month') dynamic month,
      @JsonKey(name: 'sale_price') String? salePrice,
      @JsonKey(name: 'original_price') String? originalPrice,
      @JsonKey(name: 'days') String? days});
}

/// @nodoc
class _$GoodsPriceModelCopyWithImpl<$Res, $Val extends GoodsPriceModel>
    implements $GoodsPriceModelCopyWith<$Res> {
  _$GoodsPriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsMonthsPriceId = freezed,
    Object? month = freezed,
    Object? salePrice = freezed,
    Object? originalPrice = freezed,
    Object? days = freezed,
  }) {
    return _then(_value.copyWith(
      goodsMonthsPriceId: freezed == goodsMonthsPriceId
          ? _value.goodsMonthsPriceId
          : goodsMonthsPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as dynamic,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      days: freezed == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoodsPriceModelImplCopyWith<$Res>
    implements $GoodsPriceModelCopyWith<$Res> {
  factory _$$GoodsPriceModelImplCopyWith(_$GoodsPriceModelImpl value,
          $Res Function(_$GoodsPriceModelImpl) then) =
      __$$GoodsPriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'goods_months_price_id') String? goodsMonthsPriceId,
      @JsonKey(name: 'month') dynamic month,
      @JsonKey(name: 'sale_price') String? salePrice,
      @JsonKey(name: 'original_price') String? originalPrice,
      @JsonKey(name: 'days') String? days});
}

/// @nodoc
class __$$GoodsPriceModelImplCopyWithImpl<$Res>
    extends _$GoodsPriceModelCopyWithImpl<$Res, _$GoodsPriceModelImpl>
    implements _$$GoodsPriceModelImplCopyWith<$Res> {
  __$$GoodsPriceModelImplCopyWithImpl(
      _$GoodsPriceModelImpl _value, $Res Function(_$GoodsPriceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goodsMonthsPriceId = freezed,
    Object? month = freezed,
    Object? salePrice = freezed,
    Object? originalPrice = freezed,
    Object? days = freezed,
  }) {
    return _then(_$GoodsPriceModelImpl(
      goodsMonthsPriceId: freezed == goodsMonthsPriceId
          ? _value.goodsMonthsPriceId
          : goodsMonthsPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as dynamic,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as String?,
      days: freezed == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoodsPriceModelImpl implements _GoodsPriceModel {
  const _$GoodsPriceModelImpl(
      {@JsonKey(name: 'goods_months_price_id') this.goodsMonthsPriceId,
      @JsonKey(name: 'month') this.month,
      @JsonKey(name: 'sale_price') this.salePrice,
      @JsonKey(name: 'original_price') this.originalPrice,
      @JsonKey(name: 'days') this.days});

  factory _$GoodsPriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoodsPriceModelImplFromJson(json);

  @override
  @JsonKey(name: 'goods_months_price_id')
  final String? goodsMonthsPriceId;
  @override
  @JsonKey(name: 'month')
  final dynamic month;
// 0=永久
  @override
  @JsonKey(name: 'sale_price')
  final String? salePrice;
  @override
  @JsonKey(name: 'original_price')
  final String? originalPrice;
  @override
  @JsonKey(name: 'days')
  final String? days;

  @override
  String toString() {
    return 'GoodsPriceModel(goodsMonthsPriceId: $goodsMonthsPriceId, month: $month, salePrice: $salePrice, originalPrice: $originalPrice, days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsPriceModelImpl &&
            (identical(other.goodsMonthsPriceId, goodsMonthsPriceId) ||
                other.goodsMonthsPriceId == goodsMonthsPriceId) &&
            const DeepCollectionEquality().equals(other.month, month) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.days, days) || other.days == days));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      goodsMonthsPriceId,
      const DeepCollectionEquality().hash(month),
      salePrice,
      originalPrice,
      days);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsPriceModelImplCopyWith<_$GoodsPriceModelImpl> get copyWith =>
      __$$GoodsPriceModelImplCopyWithImpl<_$GoodsPriceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoodsPriceModelImplToJson(
      this,
    );
  }
}

abstract class _GoodsPriceModel implements GoodsPriceModel {
  const factory _GoodsPriceModel(
      {@JsonKey(name: 'goods_months_price_id') final String? goodsMonthsPriceId,
      @JsonKey(name: 'month') final dynamic month,
      @JsonKey(name: 'sale_price') final String? salePrice,
      @JsonKey(name: 'original_price') final String? originalPrice,
      @JsonKey(name: 'days') final String? days}) = _$GoodsPriceModelImpl;

  factory _GoodsPriceModel.fromJson(Map<String, dynamic> json) =
      _$GoodsPriceModelImpl.fromJson;

  @override
  @JsonKey(name: 'goods_months_price_id')
  String? get goodsMonthsPriceId;
  @override
  @JsonKey(name: 'month')
  dynamic get month;
  @override // 0=永久
  @JsonKey(name: 'sale_price')
  String? get salePrice;
  @override
  @JsonKey(name: 'original_price')
  String? get originalPrice;
  @override
  @JsonKey(name: 'days')
  String? get days;
  @override
  @JsonKey(ignore: true)
  _$$GoodsPriceModelImplCopyWith<_$GoodsPriceModelImpl> get copyWith =>
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

TeachingSystem _$TeachingSystemFromJson(Map<String, dynamic> json) {
  return _TeachingSystem.fromJson(json);
}

/// @nodoc
mixin _$TeachingSystem {
  @JsonKey(name: 'system_id_name')
  String? get systemIdName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeachingSystemCopyWith<TeachingSystem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeachingSystemCopyWith<$Res> {
  factory $TeachingSystemCopyWith(
          TeachingSystem value, $Res Function(TeachingSystem) then) =
      _$TeachingSystemCopyWithImpl<$Res, TeachingSystem>;
  @useResult
  $Res call({@JsonKey(name: 'system_id_name') String? systemIdName});
}

/// @nodoc
class _$TeachingSystemCopyWithImpl<$Res, $Val extends TeachingSystem>
    implements $TeachingSystemCopyWith<$Res> {
  _$TeachingSystemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemIdName = freezed,
  }) {
    return _then(_value.copyWith(
      systemIdName: freezed == systemIdName
          ? _value.systemIdName
          : systemIdName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeachingSystemImplCopyWith<$Res>
    implements $TeachingSystemCopyWith<$Res> {
  factory _$$TeachingSystemImplCopyWith(_$TeachingSystemImpl value,
          $Res Function(_$TeachingSystemImpl) then) =
      __$$TeachingSystemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'system_id_name') String? systemIdName});
}

/// @nodoc
class __$$TeachingSystemImplCopyWithImpl<$Res>
    extends _$TeachingSystemCopyWithImpl<$Res, _$TeachingSystemImpl>
    implements _$$TeachingSystemImplCopyWith<$Res> {
  __$$TeachingSystemImplCopyWithImpl(
      _$TeachingSystemImpl _value, $Res Function(_$TeachingSystemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemIdName = freezed,
  }) {
    return _then(_$TeachingSystemImpl(
      systemIdName: freezed == systemIdName
          ? _value.systemIdName
          : systemIdName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeachingSystemImpl implements _TeachingSystem {
  const _$TeachingSystemImpl(
      {@JsonKey(name: 'system_id_name') this.systemIdName});

  factory _$TeachingSystemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeachingSystemImplFromJson(json);

  @override
  @JsonKey(name: 'system_id_name')
  final String? systemIdName;

  @override
  String toString() {
    return 'TeachingSystem(systemIdName: $systemIdName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeachingSystemImpl &&
            (identical(other.systemIdName, systemIdName) ||
                other.systemIdName == systemIdName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, systemIdName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeachingSystemImplCopyWith<_$TeachingSystemImpl> get copyWith =>
      __$$TeachingSystemImplCopyWithImpl<_$TeachingSystemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeachingSystemImplToJson(
      this,
    );
  }
}

abstract class _TeachingSystem implements TeachingSystem {
  const factory _TeachingSystem(
          {@JsonKey(name: 'system_id_name') final String? systemIdName}) =
      _$TeachingSystemImpl;

  factory _TeachingSystem.fromJson(Map<String, dynamic> json) =
      _$TeachingSystemImpl.fromJson;

  @override
  @JsonKey(name: 'system_id_name')
  String? get systemIdName;
  @override
  @JsonKey(ignore: true)
  _$$TeachingSystemImplCopyWith<_$TeachingSystemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaperStatistics _$PaperStatisticsFromJson(Map<String, dynamic> json) {
  return _PaperStatistics.fromJson(json);
}

/// @nodoc
mixin _$PaperStatistics {
  @JsonKey(name: 'do_count')
  dynamic get doCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_accuracy_rate')
  dynamic get totalAccuracyRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaperStatisticsCopyWith<PaperStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaperStatisticsCopyWith<$Res> {
  factory $PaperStatisticsCopyWith(
          PaperStatistics value, $Res Function(PaperStatistics) then) =
      _$PaperStatisticsCopyWithImpl<$Res, PaperStatistics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'do_count') dynamic doCount,
      @JsonKey(name: 'total_accuracy_rate') dynamic totalAccuracyRate});
}

/// @nodoc
class _$PaperStatisticsCopyWithImpl<$Res, $Val extends PaperStatistics>
    implements $PaperStatisticsCopyWith<$Res> {
  _$PaperStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doCount = freezed,
    Object? totalAccuracyRate = freezed,
  }) {
    return _then(_value.copyWith(
      doCount: freezed == doCount
          ? _value.doCount
          : doCount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalAccuracyRate: freezed == totalAccuracyRate
          ? _value.totalAccuracyRate
          : totalAccuracyRate // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaperStatisticsImplCopyWith<$Res>
    implements $PaperStatisticsCopyWith<$Res> {
  factory _$$PaperStatisticsImplCopyWith(_$PaperStatisticsImpl value,
          $Res Function(_$PaperStatisticsImpl) then) =
      __$$PaperStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'do_count') dynamic doCount,
      @JsonKey(name: 'total_accuracy_rate') dynamic totalAccuracyRate});
}

/// @nodoc
class __$$PaperStatisticsImplCopyWithImpl<$Res>
    extends _$PaperStatisticsCopyWithImpl<$Res, _$PaperStatisticsImpl>
    implements _$$PaperStatisticsImplCopyWith<$Res> {
  __$$PaperStatisticsImplCopyWithImpl(
      _$PaperStatisticsImpl _value, $Res Function(_$PaperStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? doCount = freezed,
    Object? totalAccuracyRate = freezed,
  }) {
    return _then(_$PaperStatisticsImpl(
      doCount: freezed == doCount
          ? _value.doCount
          : doCount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totalAccuracyRate: freezed == totalAccuracyRate
          ? _value.totalAccuracyRate
          : totalAccuracyRate // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaperStatisticsImpl implements _PaperStatistics {
  const _$PaperStatisticsImpl(
      {@JsonKey(name: 'do_count') this.doCount,
      @JsonKey(name: 'total_accuracy_rate') this.totalAccuracyRate});

  factory _$PaperStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaperStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'do_count')
  final dynamic doCount;
  @override
  @JsonKey(name: 'total_accuracy_rate')
  final dynamic totalAccuracyRate;

  @override
  String toString() {
    return 'PaperStatistics(doCount: $doCount, totalAccuracyRate: $totalAccuracyRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaperStatisticsImpl &&
            const DeepCollectionEquality().equals(other.doCount, doCount) &&
            const DeepCollectionEquality()
                .equals(other.totalAccuracyRate, totalAccuracyRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(doCount),
      const DeepCollectionEquality().hash(totalAccuracyRate));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaperStatisticsImplCopyWith<_$PaperStatisticsImpl> get copyWith =>
      __$$PaperStatisticsImplCopyWithImpl<_$PaperStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaperStatisticsImplToJson(
      this,
    );
  }
}

abstract class _PaperStatistics implements PaperStatistics {
  const factory _PaperStatistics(
      {@JsonKey(name: 'do_count') final dynamic doCount,
      @JsonKey(name: 'total_accuracy_rate')
      final dynamic totalAccuracyRate}) = _$PaperStatisticsImpl;

  factory _PaperStatistics.fromJson(Map<String, dynamic> json) =
      _$PaperStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'do_count')
  dynamic get doCount;
  @override
  @JsonKey(name: 'total_accuracy_rate')
  dynamic get totalAccuracyRate;
  @override
  @JsonKey(ignore: true)
  _$$PaperStatisticsImplCopyWith<_$PaperStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PackageGoodsModel _$PackageGoodsModelFromJson(Map<String, dynamic> json) {
  return _PackageGoodsModel.fromJson(json);
}

/// @nodoc
mixin _$PackageGoodsModel {
  @JsonKey(name: 'id')
  dynamic get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageGoodsModelCopyWith<PackageGoodsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageGoodsModelCopyWith<$Res> {
  factory $PackageGoodsModelCopyWith(
          PackageGoodsModel value, $Res Function(PackageGoodsModel) then) =
      _$PackageGoodsModelCopyWithImpl<$Res, PackageGoodsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic id, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class _$PackageGoodsModelCopyWithImpl<$Res, $Val extends PackageGoodsModel>
    implements $PackageGoodsModelCopyWith<$Res> {
  _$PackageGoodsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackageGoodsModelImplCopyWith<$Res>
    implements $PackageGoodsModelCopyWith<$Res> {
  factory _$$PackageGoodsModelImplCopyWith(_$PackageGoodsModelImpl value,
          $Res Function(_$PackageGoodsModelImpl) then) =
      __$$PackageGoodsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') dynamic id, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class __$$PackageGoodsModelImplCopyWithImpl<$Res>
    extends _$PackageGoodsModelCopyWithImpl<$Res, _$PackageGoodsModelImpl>
    implements _$$PackageGoodsModelImplCopyWith<$Res> {
  __$$PackageGoodsModelImplCopyWithImpl(_$PackageGoodsModelImpl _value,
      $Res Function(_$PackageGoodsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_$PackageGoodsModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageGoodsModelImpl implements _PackageGoodsModel {
  const _$PackageGoodsModelImpl(
      {@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name});

  factory _$PackageGoodsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageGoodsModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final dynamic id;
  @override
  @JsonKey(name: 'name')
  final String? name;

  @override
  String toString() {
    return 'PackageGoodsModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageGoodsModelImpl &&
            const DeepCollectionEquality().equals(other.id, id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(id), name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageGoodsModelImplCopyWith<_$PackageGoodsModelImpl> get copyWith =>
      __$$PackageGoodsModelImplCopyWithImpl<_$PackageGoodsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageGoodsModelImplToJson(
      this,
    );
  }
}

abstract class _PackageGoodsModel implements PackageGoodsModel {
  const factory _PackageGoodsModel(
      {@JsonKey(name: 'id') final dynamic id,
      @JsonKey(name: 'name') final String? name}) = _$PackageGoodsModelImpl;

  factory _PackageGoodsModel.fromJson(Map<String, dynamic> json) =
      _$PackageGoodsModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  dynamic get id;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$PackageGoodsModelImplCopyWith<_$PackageGoodsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
