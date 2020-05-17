import 'package:Dimodo/models/order/cartItem.dart';
import '../models/order/order.dart';
import '../models/product/product.dart';
import '../models/reviews.dart';
import '../models/user/user.dart';

import '../models/address/address.dart';
import '../models/address/ward.dart';
import '../models/address/district.dart';
import '../models/address/province.dart';
import '../models/coupon.dart';

import './dimodo_services.dart';
import 'package:connectivity/connectivity.dart';

abstract class BaseServices {
  Future<List<Product>> getProductsByCategory(
      {categoryId, sortBy, limit = 200});

  Future<List<Product>> getProductsByTag({int tag, String sortBy});

  Future<List<Product>> getProductsByShop({shopId});

  Future<User> loginFacebook({String token});

  Future<User> loginGoogle({String token});

  Future<Reviews> getReviews(productId, int offset, int limit);

// CART
// =============================================================================
  Future<int> createCartItem(CartItem cartItem);
  Future updateCartItem(CartItem cartItem);
  Future deleteCartItem(CartItem cartItem);
  Future<List<CartItem>> allCartItems();

  Future<Order> submitOrder({Order order});

  Future<List<Order>> getMyOrders();

// =============================================================================
// SHIPPING & PAYMENTS
// =============================================================================
  Future<List<Province>> getProvinces();

  Future<List<District>> getDistricts({int provinceId});

  Future<List<Ward>> getWards({int districtId});

  Future<bool> updateAddress({Address address, String accessToken});

  Future<Address> getAddress({String token});

  Future<User> createUser({
    fullName,
    email,
    password,
  });

  Future<String> requestPIN({
    email,
  });

  Future<bool> checkPIN({String pin, String token});

  Future<bool> resetPassword({
    password,
    accessToken,
  });
  Future<User> login({email, password});

  Future<Product> getProduct(id);

  Future<List<Coupon>> getCoupons();
}

class Services implements BaseServices {
  BaseServices serviceApi;

  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  void setAppConfig(appConfig) {
    switch (appConfig["type"]) {
      default:
        DimodoServices().appConfig(appConfig);
        serviceApi = DimodoServices();
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
      {categoryId, sortBy, limit = 200}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductsByCategory(
          categoryId: categoryId, sortBy: sortBy, limit: limit);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> getProductsByTag({int tag, String sortBy}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductsByTag(tag: tag, sortBy: sortBy);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> getProductsByShop({shopId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductsByShop(
        shopId: shopId,
      );
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> loginFacebook({String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.loginFacebook(token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> loginGoogle({String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.loginGoogle(token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Reviews> getReviews(productId, int offset, int limit) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getReviews(productId, offset, limit);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<bool> updateAddress({Address address, String accessToken}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.updateAddress(
          address: address, accessToken: accessToken);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Province>> getProvinces() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProvinces();
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<District>> getDistricts({int provinceId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getDistricts(provinceId: provinceId);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Ward>> getWards({int districtId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getWards(districtId: districtId);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Address> getAddress({String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getAddress(token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  // ===========================================================================
  // CART
  // ===========================================================================
  @override
  Future<int> createCartItem(CartItem cartItem) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createCartItem(cartItem);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<int> updateCartItem(CartItem cartItem) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.updateCartItem(cartItem);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<int> deleteCartItem(CartItem cartItem) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.deleteCartItem(cartItem);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<CartItem>> allCartItems() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.allCartItems();
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Order>> getMyOrders() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getMyOrders();
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Order> submitOrder({Order order}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.submitOrder(order: order);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> createUser({fullName, email, password}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createUser(
        fullName: fullName,
        email: email,
        password: password,
      );
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<String> requestPIN({email}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.requestPIN(
        email: email,
      );
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<bool> resetPassword({password, accessToken}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.resetPassword(
          password: password, accessToken: accessToken);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<bool> checkPIN({pin, token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.checkPIN(pin: pin, token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> login({email, password}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.login(
        email: email,
        password: password,
      );
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Product> getProduct(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProduct(id);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Coupon>> getCoupons() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCoupons();
    } else {
      throw Exception("No internet connection");
    }
  }
}
