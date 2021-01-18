import 'package:json_annotation/json_annotation.dart';

part 'attribute.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OptionAttribute {
  String title;
  String value;
  int order;

  OptionAttribute(
    this.title,
    this.value,
    this.order,
  );
  factory OptionAttribute.fromJson(Map<String, dynamic> json) =>
      _$OptionAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$OptionAttributeToJson(this);
}
