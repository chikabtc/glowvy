// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    firstCategoryKoName: json['first_category_ko_name'] as String,
    firstCategoryEnName: json['first_category_en_name'] as String,
    firstCategoryName: json['first_category_name'] as String,
    secondCategories: (json['second_categories'] as List)
        ?.map((e) => e == null
            ? null
            : SecondCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    firstCategoryImage: json['first_category_image'] as String,
    firstCategoryId: json['first_category_id'] as int,
    firstIsNew: json['first_is_new'] as bool,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'first_category_ko_name': instance.firstCategoryKoName,
      'first_category_en_name': instance.firstCategoryEnName,
      'first_category_name': instance.firstCategoryName,
      'second_categories': instance.secondCategories,
      'first_category_image': instance.firstCategoryImage,
      'first_category_id': instance.firstCategoryId,
      'first_is_new': instance.firstIsNew,
    };
