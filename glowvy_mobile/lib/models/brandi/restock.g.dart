// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restock _$RestockFromJson(Map<String, dynamic> json) {
  return Restock(
    json['is_managed'] as bool,
    json['is_requested'] as bool,
  );
}

Map<String, dynamic> _$RestockToJson(Restock instance) => <String, dynamic>{
      'is_managed': instance.isManaged,
      'is_requested': instance.isRequested,
    };
