import 'package:Dimodo/models/product/product.dart';
import 'package:localstorage/localstorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orderItem.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderItem {
  String option;
  int optionId;
  int quantity;
  Product product;
  int orderId;
  OrderItem({
    this.option,
    this.optionId,
    this.quantity,
    this.product,
    this.orderId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
