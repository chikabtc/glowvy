import 'package:json_annotation/json_annotation.dart';

part 'productAttribute.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductAttribute {
  String title;
  String value;
  bool isSoldOut;
  ProductAttribute(this.title, this.value, this.isSoldOut);

  factory ProductAttribute.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAttributeToJson(this);
}
