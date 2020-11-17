// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return ProductCategory(
    firstCategoryId: json['first_category_id'] as int,
    firstCategoryName: json['first_category_name'] as String,
    secondCategoryId: json['second_category_id'] as int,
    secondCategoryName: json['second_category_name'] as String,
    thirdCategoryId: json['third_category_id'] as int,
    thirdCategoryName: json['third_category_name'] as String,
  );
}

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'first_category_id': instance.firstCategoryId,
      'first_category_name': instance.firstCategoryName,
      'second_category_id': instance.secondCategoryId,
      'second_category_name': instance.secondCategoryName,
      'third_category_id': instance.thirdCategoryId,
      'third_category_name': instance.thirdCategoryName,
    };
