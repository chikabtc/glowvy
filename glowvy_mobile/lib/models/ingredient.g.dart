// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['id'] as int,
    json['name_en'] as String,
    (json['purposes'] as List)?.map((e) => e as String)?.toList(),
    json['hazard_score'] as int,
  );
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'purposes': instance.purposes,
      'hazard_score': instance.hazardScore,
    };
