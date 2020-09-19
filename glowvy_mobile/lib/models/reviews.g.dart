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
  )
    ..point1 = json['point1'] as int
    ..point2 = json['point2'] as int
    ..point3 = json['point3'] as int
    ..point4 = json['point4'] as int
    ..point5 = json['point5'] as int;
}

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'total_count': instance.totalCount,
      'average_satisfaction': instance.averageSatisfaction,
      'reviews': instance.reviews,
      'point1': instance.point1,
      'point2': instance.point2,
      'point3': instance.point3,
      'point4': instance.point4,
      'point5': instance.point5,
    };
