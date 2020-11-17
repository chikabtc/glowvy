import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Ingredient {
  int id;
  String nameEn;
  String purposeVi;
  int hazardScore;

  Ingredient(
    this.id,
    this.nameEn,
    this.purposeVi,
    this.hazardScore,
  );
  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
