import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Ingredient {
  int id;
  String nameEn;
  List<String> purposes;
  int hazardScore;

  Ingredient(
    this.id,
    this.nameEn,
    this.hazardScore,
  );
  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
