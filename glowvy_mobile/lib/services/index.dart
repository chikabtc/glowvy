import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/models/order/cartItem.dart';
import 'package:Dimodo/models/review.dart';
import '../models/order/order.dart';
import '../models/product/product.dart';
import '../models/reviews.dart';
import '../models/user/user.dart';

import '../models/address/address.dart';
import '../models/address/ward.dart';
import '../models/address/district.dart';
import '../models/address/province.dart';
import '../models/coupon.dart';

import './glowvy-service.dart';
import 'package:connectivity/connectivity.dart';

abstract class BaseServices {
  Future<List<Product>> getProductsByCategory(
      {categoryId, sortBy, start, limit = 200});

  Future<List<Product>> getProductsByTag(
      {int tag, int start, int count, String sortBy});

  Future<List<Product>> getProductsBySearch({String searchText});

  Future<List<Product>> getProductsByShop({shopId});
  Future<List<Review>> getReviewsByUserId(uid);
  Future<List<Category>> getSubCategories({parentId});

  Future<User> loginFacebook({String token});
  Future<User> loginApple(String code, fullName);

  Future<User> loginGoogle({String token});

  Future<Reviews> getReviews(productId, int offset, int limit);
  Future<Product> getCosmetics(productId);
  Future<void> uploadReview(review);
  Future<List<Review>> getCosmeticsReviews(productId);
  Future<List<Ingredient>> getIngredients(productId);
  // ===========================================================================
  // COSMETICS
  // ===========================================================================
  Future<List<Product>> getCosmeticsProductsByCategory({categoryId, skinType});
  Future<List<Product>> getCosmeticsProductsByCategoryF({categoryId, skinType});

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

  Future<Address> updateAddress({Address address, String accessToken});

  Future<Address> createAddress({Address address});
  Future<bool> deleteAddress({Address address});

  Future<List<Address>> getAllAddresses({String token});

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
        GlowvyServices().appConfig(appConfig);
        serviceApi = GlowvyServices();
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
      {categoryId, sortBy, start, limit = 200}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductsByCategory(
          categoryId: categoryId, sortBy: sortBy, start: start, limit: limit);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Review>> getReviewsByUserId(uid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getReviewsByUserId(uid);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> getCosmeticsProductsByCategory(
      {categoryId, skinType}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCosmeticsProductsByCategory(
          categoryId: categoryId, skinType: skinType);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<void> uploadReview(review) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.uploadReview(review);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> getCosmeticsProductsByCategoryF(
      {categoryId, skinType}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCosmeticsProductsByCategoryF(
          categoryId: categoryId, skinType: skinType);
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Product>> getProductsByTag(
      {int tag, int start, int count, String sortBy}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductsByTag(
          tag: tag, start: start, count: count, sortBy: sortBy);
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
  Future<List<Product>> getProductsBySearch(
      {String searchText, String sortBy}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getProductsBySearch(
        searchText: searchText,
      );
    } else {
      //TODO: add no connection popup
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Category>> getSubCategories({parentId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getSubCategories(
        parentId: parentId,
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
  Future<User> loginApple(String code, fullName) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.loginApple(code, fullName);
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
  Future<List<Review>> getCosmeticsReviews(productId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCosmeticsReviews(productId);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<List<Ingredient>> getIngredients(productId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getIngredients(productId);
    } else {
      throw Exception("No internet connection");
    }
  }
  // @override
  // Future<Reviews> getCosmeticsReviews(productId) async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     return serviceApi.getCosmeticsReviews(productId);
  //   } else {
  //     throw Exception("No internet connection");
  //   }
  // }

  @override
  Future<Product> getCosmetics(productId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getCosmetics(productId);
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
  Future<Address> createAddress({Address address}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.createAddress(address: address);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<Address> updateAddress({Address address, String accessToken}) async {
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
  Future<bool> deleteAddress({Address address, String accessToken}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.deleteAddress(address: address);
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
  Future<List<Address>> getAllAddresses({String token}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return serviceApi.getAllAddresses(token: token);
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
