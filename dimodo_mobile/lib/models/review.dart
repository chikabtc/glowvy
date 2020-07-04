import 'package:json_annotation/json_annotation.dart';
import 'reviewProduct.dart';
import 'reviewUser.dart';
part 'review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Review {
  String id;
  String createdTime;
  String type;
  String content;
  String scontent;
  ReviewProduct product;
  ReviewUser user;
  List<String> images;

  Review({
    this.id,
    this.createdTime,
    this.type,
    this.content,
    this.scontent,
    this.product,
    this.user,
    this.images,
  });

  @override
  String toString() => 'Review { id: ${user.name} name: ${user.skinType} }';

//testing codemagic
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
