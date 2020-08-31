// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reviews _$ReviewsFromJson(Map<String, dynamic> json) {
  return Reviews(
    totalCount: json['total_count'] as int,
    averageSatisfaction: json['average_satisfaction'] as int,
    reviews: (json['reviews'] as List)
        ?.map((e) =>
            e == null ? null : Review.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'total_count': instance.totalCount,
      'average_satisfaction': instance.averageSatisfaction,
      'reviews': instance.reviews,
    };
