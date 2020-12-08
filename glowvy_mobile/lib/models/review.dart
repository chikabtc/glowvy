import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Review {
  int id;
  String content;
  String scontent;
  int rating;
  List<String> images;
  User user;
  int createdAt;
  Product product;
  int likeCount;

  Review({
    this.id,
    this.createdAt,
    this.content,
    this.scontent,
    this.rating,
    this.user,
    this.images,
  });
  // @JsonKey(fromJson: _fromJson, toJson: _toJson)
  // static DateTime _fromJson(int int) =>
  //     DateTime.fromMillisecondsSinceEpoch(int);
  // static int _toJson(DateTime time) => time.millisecondsSinceEpoch;

  @override
  String toString() => 'Review { id: ${user.fullName} name: ${user.age} }';

//testing codemagic
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
