import 'package:json_annotation/json_annotation.dart';
part 'reviewUser.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewUser {
  String id;
  String name;
  String imageUrl;
  int height;
  String shirtSize;
  String pantsSize;
  String footwearSize;

  ReviewUser({
    this.id,
    this.name,
    this.imageUrl,
    this.height,
    this.shirtSize,
    this.pantsSize,
    this.footwearSize,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) =>
      _$ReviewUserFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewUserToJson(this);
}
