import 'package:Dimodo/models/productAttribute.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productEtcInfo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductEtcInfo {
  List<ProductAttribute> attributes;

  ProductEtcInfo({
    this.attributes,
  });

  factory ProductEtcInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductEtcInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductEtcInfoToJson(this);
}
