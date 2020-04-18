import 'package:Dimodo/models/product/product.dart';
import 'package:localstorage/localstorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cartItem.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CartItem {
  String option;
  int optionId;
  int quantity;
  Product product;

  CartItem({
    this.option,
    this.optionId,
    this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
