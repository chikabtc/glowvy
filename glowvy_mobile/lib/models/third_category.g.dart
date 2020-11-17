// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'third_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThirdCategory _$ThirdCategoryFromJson(Map<String, dynamic> json) {
  return ThirdCategory(
    thirdIsNew: json['third_is_new'] as bool,
    thirdCategoryKoName: json['third_category_ko_name'] as String,
    thirdCategoryEnName: json['third_category_en_name'] as String,
    thirdCategoryName: json['third_category_name'] as String,
    thirdCategoryId: json['third_category_id'] as int,
  );
}

Map<String, dynamic> _$ThirdCategoryToJson(ThirdCategory instance) =>
    <String, dynamic>{
      'third_is_new': instance.thirdIsNew,
      'third_category_ko_name': instance.thirdCategoryKoName,
      'third_category_en_name': instance.thirdCategoryEnName,
      'third_category_name': instance.thirdCategoryName,
      'third_category_id': instance.thirdCategoryId,
    };
