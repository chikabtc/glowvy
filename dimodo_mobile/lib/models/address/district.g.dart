// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

District _$DistrictFromJson(Map<String, dynamic> json) {
  return District(
    id: json['id'] as int,
    name: json['name'] as String,
    province: json['province'] == null
        ? null
        : Province.fromJson(json['province'] as Map<String, dynamic>),
    provinceId: json['province_id'] as int,
  );
}

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'province': instance.province,
      'province_id': instance.provinceId,
    };
