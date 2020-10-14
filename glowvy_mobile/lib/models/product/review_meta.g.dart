// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewMeta _$ReviewMetaFromJson(Map<String, dynamic> json) {
  return ReviewMeta(
    (json['average_rating'] as num)?.toDouble(),
    json['review_count'] as int,
    (json['ranking_score'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ReviewMetaToJson(ReviewMeta instance) =>
    <String, dynamic>{
      'average_rating': instance.averageRating,
      'review_count': instance.reviewCount,
      'ranking_score': instance.rankingScore,
    };
