import 'package:json_annotation/json_annotation.dart';
part 'reviewProduct.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ReviewProduct {
  String id;
  String sid;
  String optionName;
  String sellerId;

  ReviewProduct({
    this.id,
    this.sid,
    this.optionName,
    this.sellerId,
  });

  factory ReviewProduct.fromJson(Map<String, dynamic> json) =>
      _$ReviewProductFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewProductToJson(this);
}
