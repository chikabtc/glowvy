import 'package:flutter/material.dart';
import '../../services/index.dart';
import '../user/userModel.dart';
import 'cart.dart';
import 'order.dart';

class OrderModel extends ChangeNotifier {
  List<Order> myOrders = [];
  Services _service = Services();
  bool isLoading = true;
  String errMsg;
  int page = 1;
  bool endPage = false;

  Future<List<Order>> getMyOrders({UserModel userModel}) async {
    try {
      isLoading = true;
      notifyListeners();
      myOrders = await _service.getMyOrders(userModel: userModel);
      page = 1;
      errMsg = null;
      isLoading = false;
      endPage = false;
      notifyListeners();
      return myOrders;
    } catch (err) {
      errMsg =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Order> createOrder({UserModel userModel}) async {
    try {
      isLoading = true;
      notifyListeners();
      Order order = await _service.createOrder(userModel: userModel);
      page = 1;
      errMsg = null;
      isLoading = false;
      endPage = false;
      notifyListeners();
      return order;
    } catch (err) {
      errMsg =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void loadMore({UserModel userModel}) async {
    try {
      isLoading = true;
      page = page + 1;
      notifyListeners();
      var orders = await _service.getMyOrders(userModel: userModel, page: page);
      myOrders = [...myOrders, ...orders];
      if (orders.length == 0) endPage = true;
      errMsg = null;
      isLoading = false;
      notifyListeners();
    } catch (err) {
      errMsg =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
