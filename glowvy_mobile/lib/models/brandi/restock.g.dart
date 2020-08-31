// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restock _$RestockFromJson(Map<String, dynamic> json) {
  return Restock(
    json['isManaged'] as bool,
    json['isRequested'] as bool,
  );
}

Map<String, dynamic> _$RestockToJson(Restock instance) => <String, dynamic>{
      'isManaged': instance.isManaged,
      'isRequested': instance.isRequested,
    };
