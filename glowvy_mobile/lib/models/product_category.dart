import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductCategory {
  int firstCategoryId;
  String firstCategoryName;
  int secondCategoryId;
  String secondCategoryName;
  int thirdCategoryId;
  String thirdCategoryName;
  ProductCategory(
      {this.firstCategoryId,
      this.firstCategoryName,
      this.secondCategoryId,
      this.secondCategoryName,
      this.thirdCategoryId,
      this.thirdCategoryName});
  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}
