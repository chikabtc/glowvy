import 'package:json_annotation/json_annotation.dart';
import 'review.dart';
part 'reviews.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Reviews {
  int totalCount;
  int averageSatisfaction;
  List<Review> reviews = [];
  int point1;
  int point2;
  int point3;
  int point4;
  int point5;

  Reviews({this.totalCount, this.averageSatisfaction, this.reviews});

//testing codemagic
  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}
