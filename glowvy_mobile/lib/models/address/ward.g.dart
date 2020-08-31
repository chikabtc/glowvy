// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ward _$WardFromJson(Map<String, dynamic> json) {
  return Ward(
    id: json['id'] as int,
    name: json['name'] as String,
    proviceId: json['provice_id'] as int,
    province: json['province'] == null
        ? null
        : Province.fromJson(json['province'] as Map<String, dynamic>),
    district: json['district'] == null
        ? null
        : District.fromJson(json['district'] as Map<String, dynamic>),
    districtID: json['district_i_d'] as int,
  );
}

Map<String, dynamic> _$WardToJson(Ward instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'province': instance.province,
      'provice_id': instance.proviceId,
      'district': instance.district,
      'district_i_d': instance.districtID,
    };
