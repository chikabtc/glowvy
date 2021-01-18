// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) {
  return Notice(
    json['restock'] == null
        ? null
        : Restock.fromJson(json['restock'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'restock': instance.restock?.toJson(),
    };
