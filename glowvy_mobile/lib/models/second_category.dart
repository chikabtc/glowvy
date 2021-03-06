// Generated by https://quicktype.io
import 'package:Dimodo/models/third_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'second_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SecondCategory {
  String secondCategoryKoName;
  String secondCategoryEnName;
  String secondCategoryName;
  bool secondIsNew;
  int secondCategoryId;
  List<ThirdCategory> thirdCategories;
  String thirdCategoryEnName;
  String thirdCategoryName;

  SecondCategory({
    this.secondCategoryKoName,
    this.secondCategoryEnName,
    this.secondCategoryName,
    this.secondIsNew,
    this.secondCategoryId,
    this.thirdCategories,
    this.thirdCategoryEnName,
    this.thirdCategoryName,
  });
  factory SecondCategory.fromJson(Map<String, dynamic> json) =>
      _$SecondCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SecondCategoryToJson(this);
}
