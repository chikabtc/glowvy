// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviewUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewUser _$ReviewUserFromJson(Map<String, dynamic> json) {
  return ReviewUser(
    id: json['id'] as String,
    name: json['name'] as String,
    imageUrl: json['image_url'] as String,
    height: json['height'] as int,
    shirtSize: json['shirt_size'] as String,
    pantsSize: json['pants_size'] as String,
    footwearSize: json['footwear_size'] as String,
  )
    ..age = json['age'] as int
    ..skinType = json['skin_type'] as String;
}

Map<String, dynamic> _$ReviewUserToJson(ReviewUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'height': instance.height,
      'shirt_size': instance.shirtSize,
      'pants_size': instance.pantsSize,
      'age': instance.age,
      'skin_type': instance.skinType,
      'footwear_size': instance.footwearSize,
    };
