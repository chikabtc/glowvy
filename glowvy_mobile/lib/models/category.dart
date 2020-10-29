import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Category {
  int firstCategoryId;
  String firstCategoryName;
  int secondCategoryId;
  String secondCategoryName;
  int thirdCategoryId;
  String thirdCategoryName;
  Category(
      {this.firstCategoryId,
      this.firstCategoryName,
      this.secondCategoryId,
      this.secondCategoryName,
      this.thirdCategoryId,
      this.thirdCategoryName});
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
