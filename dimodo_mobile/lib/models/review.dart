import 'package:json_annotation/json_annotation.dart';
import 'reviewProduct.dart';
import 'reviewUser.dart';
part 'review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Review {
  String id;
  String createdTime;
  String type;
  String text;
  ReviewProduct product;
  ReviewUser user;
  List<String> images;

  Review({
    this.id,
    this.createdTime,
    this.type,
    this.text,
    this.product,
    this.user,
    this.images,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
