// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_metas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewMetas _$ReviewMetasFromJson(Map<String, dynamic> json) {
  return ReviewMetas(
    json['all'] == null
        ? null
        : ReviewMeta.fromJson(json['all'] as Map<String, dynamic>),
    json['neutral'] == null
        ? null
        : ReviewMeta.fromJson(json['neutral'] as Map<String, dynamic>),
    json['dry'] == null
        ? null
        : ReviewMeta.fromJson(json['dry'] as Map<String, dynamic>),
    json['complex'] == null
        ? null
        : ReviewMeta.fromJson(json['complex'] as Map<String, dynamic>),
    json['oily'] == null
        ? null
        : ReviewMeta.fromJson(json['oily'] as Map<String, dynamic>),
    json['sensitive'] == null
        ? null
        : ReviewMeta.fromJson(json['sensitive'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ReviewMetasToJson(ReviewMetas instance) =>
    <String, dynamic>{
      'all': instance.all,
      'complex': instance.complex,
      'dry': instance.dry,
      'neutral': instance.neutral,
      'oily': instance.oily,
      'sensitive': instance.sensitive,
    };
