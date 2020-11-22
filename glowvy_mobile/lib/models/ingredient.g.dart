// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['id'] as int,
    json['name_en'] as String,
    json['hazard_score'] as int,
  )..purposes = (json['purposes'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'purposes': instance.purposes,
      'hazard_score': instance.hazardScore,
    };
