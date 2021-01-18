import 'package:json_annotation/json_annotation.dart';

part 'restock.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Restock {
  bool isManaged;
  bool isRequested;

  Restock(
    this.isManaged,
    this.isRequested,
  );
  factory Restock.fromJson(Map<String, dynamic> json) =>
      _$RestockFromJson(json);
  Map<String, dynamic> toJson() => _$RestockToJson(this);
}
