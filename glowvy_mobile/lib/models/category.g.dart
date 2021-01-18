// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    koName: json['ko_name'] as String,
    enName: json['en_name'] as String,
    name: json['name'] as String,
    subCategories: (json['sub_categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    grandTotalCount: (json['grand_total_count'] as num)?.toDouble(),
    image: json['image'] as String,
    id: json['id'] as int,
    level: json['level'] as int,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'ko_name': instance.koName,
      'en_name': instance.enName,
      'name': instance.name,
      'sub_categories':
          instance.subCategories?.map((e) => e?.toJson())?.toList(),
      'image': instance.image,
      'id': instance.id,
      'level': instance.level,
      'grand_total_count': instance.grandTotalCount,
    };
