// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    parentName: json['parent_name'] as String,
    parentId: json['parent_id'] as int,
    subCategories: (json['sub_categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'parent_name': instance.parentName,
      'name': instance.name,
      'image': instance.image,
      'sub_categories': instance.subCategories,
    };
