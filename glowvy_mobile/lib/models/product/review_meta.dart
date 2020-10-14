import 'package:json_annotation/json_annotation.dart';

part 'review_meta.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewMeta {
  double averageRating;
  int reviewCount;
  double rankingScore;
//come
  ReviewMeta(
    this.averageRating,
    this.reviewCount,
    this.rankingScore,
  );
  factory ReviewMeta.fromJson(Map<String, dynamic> json) =>
      _$ReviewMetaFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewMetaToJson(this);
}
