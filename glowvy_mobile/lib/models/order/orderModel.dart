import 'package:flutter/material.dart';

import 'order.dart';

class OrderModel extends ChangeNotifier {
  List<Order> myOrders = [];
  bool isLoading = true;
  String errMsg;
  int page = 1;
  bool endPage = false;

  // Future<List<Order>> getMyOrders() async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //     myOrders = await _service.getMyOrders();
  //     page = 1;
  //     errMsg = null;
  //     isLoading = false;
  //     endPage = false;
  //     notifyListeners();
  //     return myOrders;
  //   } catch (err) {
  //     errMsg =
  //         'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
  //             err.toString();
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<Order> submitOrder({Order order}) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //     final createdOrder = await _service.submitOrder(order: order);
  //     page = 1;
  //     errMsg = null;
  //     isLoading = false;
  //     endPage = false;
  //     notifyListeners();
  //     return createdOrder;
  //   } catch (err) {
  //     errMsg =
  //         'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
  //             err.toString();
  //     isLoading = false;
  //     notifyListeners();
  //     return null;
  //   }
  // }

  // Future loadMore({UserModel userModel}) async {
  //   try {
  //     isLoading = true;
  //     page = page + 1;
  //     notifyListeners();
  //     final orders = await _service.getMyOrders();
  //     myOrders = [...myOrders, ...orders];
  //     if (orders.isEmpty) endPage = true;
  //     errMsg = null;
  //     isLoading = false;
  //     notifyListeners();
  //   } catch (err) {
  //     errMsg =
  //         'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
  //             err.toString();
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
