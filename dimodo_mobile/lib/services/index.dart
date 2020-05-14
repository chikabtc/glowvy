import 'package:Dimodo/models/order/cartItem.dart';

import '../models/category.dart';
import '../models/order/order.dart';
import '../models/payment_method.dart';
import '../models/product/product.dart';
import '../models/reviews.dart';
import '../models/shipping_method.dart';
import '../models/user/user.dart';
import '../models/user/userModel.dart';

import '../models/address/address.dart';
import '../models/address/ward.dart';
import '../models/address/district.dart';
import '../models/address/province.dart';
import '../models/order/cart.dart';
import '../models/coupon.dart';
import '../models/aftership.dart';
import '../models/order/order_note.dart';

import './dimodo_services.dart';
import 'package:connectivity/connectivity.dart';

abstract class BaseServices {
  Future<List<Category>> getCategories({lang});

  Future<List<Product>> fetchProductsByCategory(
      {categoryId, sortBy, limit = 200});

  Future<List<Product>> fetchProductsByTag({tag, sortBy});

  Future<List<Product>> fetchProductsByShop({shopId});

  Future<User> loginFacebook({String token});

  Future<User> loginGoogle({String token});

  Future<Reviews> getReviews(productId, int offset, int limit);

// =============================================================================
// CART
// =============================================================================
  // Future<Cart> fetchCartItems({CartModel cartModel, UserModel user});
  //receive the quantity of the chosen product
  Future<int> createCartItem(CartItem cartItem, UserModel userModel);
  Future updateCartItem(CartItem cartItem, UserModel user);
  Future deleteCartItem(CartItem cartItem, UserModel user);
  Future<List<CartItem>> allCartItems(UserModel userModel);

  Future<Order> submitOrder({Order order, UserModel userModel});

  Future<List<Order>> getMyOrders({UserModel userModel, int page});

  Future updateOrder(orderId, {status});
// =============================================================================
// SHIPPING & PAYMENTS
// =============================================================================
  Future<List<Province>> getProvinces();

  Future<List<District>> getDistricts({int provinceId});

  Future<List<Ward>> getWards({int districtId});

  Future<bool> updateAddress({Address address, String token});

  Future<Address> getAddress({String token});

  Future<List<ShippingMethod>> getShippingMethods(
      {Address address, String token});

  Future<List<PaymentMethod>> getPaymentMethods(
      {Address address, ShippingMethod shippingMethod, String token});

  Future<List<Product>> searchProducts({name, page});

  Future<User> getUserInfo(accessToken);

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

  Future<List<Coupon>> getCoupons(UserModel userModel);

  Future<AfterShip> getAllTracking();

  Future<List<OrderNote>> getOrderNote({UserModel userModel, int orderId});

  Future<Null> createReview({int productId, Map<String, dynamic> data});

  Future<User> getUserInfor({int id});

  Future<Map<String, dynamic>> getHomeCache();
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
  Future<List<Product>> fetchProductsByCategory(
      {categoryId, sortBy, limit = 200}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.fetchProductsByCategory(
          categoryId: categoryId, sortBy: sortBy, limit: limit);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> fetchProductsByTag({tag, sortBy}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.fetchProductsByTag(tag: tag, sortBy: sortBy);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> fetchProductsByShop({shopId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.fetchProductsByShop(
        shopId: shopId,
      );
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Category>> getCategories({lang = "en"}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCategories(lang: lang);
    } else {
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
  Future<bool> updateAddress({Address address, String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.updateAddress(address: address, token: token);
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

  @override
  Future<List<ShippingMethod>> getShippingMethods(
      {Address address, String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getShippingMethods(address: address, token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods(
      {Address address, ShippingMethod shippingMethod, String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getPaymentMethods(
          address: address, shippingMethod: shippingMethod, token: token);
    } else {
      throw Exception("No internet connection");
    }
  }

  // ===========================================================================
  // CART
  // ===========================================================================
  @override
  Future<int> createCartItem(CartItem cartItem, UserModel userModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createCartItem(cartItem, userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<int> updateCartItem(CartItem cartItem, UserModel userModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.updateCartItem(cartItem, userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<int> deleteCartItem(CartItem cartItem, UserModel userModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.deleteCartItem(cartItem, userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<CartItem>> allCartItems(UserModel userModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.allCartItems(userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Order>> getMyOrders({UserModel userModel, int page}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getMyOrders(userModel: userModel, page: page);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Order> submitOrder({Order order, UserModel userModel}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.submitOrder(order: order, userModel: userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future updateOrder(orderId, {status}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.updateOrder(orderId, status: status);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> searchProducts({name, page}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.searchProducts(name: name, page: page);
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
  Future<User> getUserInfo(accessToken) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getUserInfo(accessToken);
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
  Future<List<Coupon>> getCoupons(userModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCoupons(userModel);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<AfterShip> getAllTracking() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getAllTracking();
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<OrderNote>> getOrderNote(
      {UserModel userModel, int orderId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getOrderNote(userModel: userModel, orderId: orderId);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Null> createReview({int productId, Map<String, dynamic> data}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createReview(productId: productId, data: data);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<User> getUserInfor({int id}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getUserInfor(id: id);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Map<String, dynamic>> getHomeCache() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getHomeCache();
    } else {
      throw Exception("No internet connection");
    }
  }
}
