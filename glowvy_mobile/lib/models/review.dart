import 'package:Dimodo/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'reviewProduct.dart';
import 'reviewUser.dart';
part 'review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Review {
  int id;
  String content;
  String scontent;
  int userId;
  int productId;
  int rating;
  List<String> images;
  User user;
  String createdTime;

  Review({
    this.id,
    this.createdTime,
    this.content,
    this.scontent,
    this.rating,
    this.productId,
    this.user,
    // this.product,
    this.images,
  });

  @override
  String toString() => 'Review { id: ${user.displayName} name: ${user.age} }';

//testing codemagic
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
