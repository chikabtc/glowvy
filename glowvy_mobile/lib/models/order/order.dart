import 'package:Dimodo/models/coupon.dart';
import 'package:Dimodo/models/order/cartItem.dart';
import 'package:json_annotation/json_annotation.dart';

import 'cartItem.dart';

part 'order.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Order {
  int orderId;
  bool isPaid;
  double totalShipping;
  double totalFee;
  double totalDiscounts;
  String userId;
  int addressId;
  int dateCreated;
  List<CartItem> orderItems = [];
  List<Coupon> appliedCoupons = [];

  Order(
      {this.orderId,
      this.isPaid,
      this.dateCreated,
      this.orderItems,
      this.userId,
      this.totalShipping,
      this.totalFee,
      this.appliedCoupons,
      this.totalDiscounts,
      this.addressId});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
