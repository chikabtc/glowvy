// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    firstCategoryId: json['first_category_id'] as int,
    firstCategoryName: json['first_category_name'] as String,
    secondCategoryId: json['second_category_id'] as int,
    secondCategoryName: json['second_category_name'] as String,
    thirdCategoryId: json['third_category_id'] as int,
    thirdCategoryName: json['third_category_name'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'first_category_id': instance.firstCategoryId,
      'first_category_name': instance.firstCategoryName,
      'second_category_id': instance.secondCategoryId,
      'second_category_name': instance.secondCategoryName,
      'third_category_id': instance.thirdCategoryId,
      'third_category_name': instance.thirdCategoryName,
    };
