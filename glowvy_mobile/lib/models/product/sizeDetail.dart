import 'package:Dimodo/models/productAttribute.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sizeDetail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SizeDetail {
  List<ProductAttribute> attributes;

  SizeDetail({
    this.attributes,
  });

  factory SizeDetail.fromJson(Map<String, dynamic> json) =>
      _$SizeDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SizeDetailToJson(this);
}
