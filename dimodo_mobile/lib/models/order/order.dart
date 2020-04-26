import 'package:Dimodo/models/order/cartItem.dart';

import '../address/address.dart';
import 'cart.dart';
import 'cartItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Order {
  int orderId;
  bool isPaid;
  double totalShipping;
  double totalFee;
  int userId;
  int addressId;
  int dateCreated;
  List<CartItem> orderItems = [];

  Order(
      {this.orderId,
      this.isPaid,
      this.dateCreated,
      this.orderItems,
      this.userId,
      this.totalShipping,
      this.totalFee,
      this.addressId});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
