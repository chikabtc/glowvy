import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'dart:convert';
import "dart:core";
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/models/order/cartItem.dart';
import 'package:Dimodo/models/review.dart';
import 'package:http/http.dart' as http;
import '../models/address/address.dart';
import '../models/address/ward.dart';
import '../models/address/province.dart';
import '../models/address/district.dart';
import '../models/coupon.dart';
import '../models/order/order.dart';
import '../models/product/product.dart';
import '../models/reviews.dart';
import '../models/user/user.dart';
import 'index.dart';
import 'dart:io';
import '../common/constants.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlowvyServices implements BaseServices {
  static final GlowvyServices _instance = GlowvyServices._internal();
  factory GlowvyServices() => _instance;

  bool isProd = true;

  GlowvyServices._internal();

  static Algolia algolia = Algolia.init(
    applicationId: '50G6MO803G',
    apiKey: 'ab5eb7ec7552bb7865f3819a2b08f462',
  );

  String isSecure;
  // String baseUrl = "http://172.16.0.184:80";
  String baseUrl = "http://dimodo.app";
  DocumentSnapshot lastReviewSnap;

  void appConfig(appConfig) {
    // // accessToken =
    if (!isProd) {
      baseUrl = Platform.isAndroid
          ? 'http://10.0.2.2:80'
          : 'http://freemanMac.local:80';
    }
  }

  getAsync({String endPoint, Map<String, String> headers}) async {
    var url = '$baseUrl/$endPoint';
    print("baseURL: $url");
    print("accessToken: $kAccessToken");

    headers = kAccessToken != null
        ? {"Authorization": "Bearer $kAccessToken"}
        : {'Content-Type': 'application/json'};

    final http.Response response = await http.get(url, headers: headers);
    Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    return body;
  }

  postAsync({String endPoint, data, Map<String, String> headers}) async {
    var url = '$baseUrl/$endPoint';
    var headers = kAccessToken != null
        ? {
            "Authorization": "Bearer $kAccessToken",
          }
        : null;

    print("baseURL: $url");
    print("headers: $headers");

    if (headers != null) headers = headers;

    final http.Response response = await http.post(
      "$url",
      headers: headers,
      body: data,
    );

    Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    return body;
  }

  // ===========================================================================
  // PRODUCTS
  // ===========================================================================

  @override
  Future<Product> getProduct(id) async {
    try {
      final body = await getAsync(endPoint: "api/products/id=$id/sr=brandi");
      final product = body['Data'];

      if (body["Success"] == true) {
        print("product: ${product['options']}");
        return Product.fromJson(product);
      } else {
        var message = body["Error"];
        throw Exception("failed to retreieve product data: ${message}");
      }
    } on TimeoutException catch (e) {
      print("canceling request due to time limit: getProduct by id");
    } catch (err) {
      throw err;
    }
  }

  // ===========================================================================
  // REVIEWS
  // ===========================================================================

  @override
  Future<Reviews> getReviews(id, int offset, int limit) async {
    try {
      final body = await getAsync(
          endPoint:
              "api/products/review/id=$id/sr=brandi?offset=$offset&limit=$limit");

      if (body["Success"] == true) {
        var reviews = Reviews.fromJson(body["Data"]);
        return reviews;
      } else {
        var message = body["Error"];
        throw Exception("failed to retreieve product data: ${message}");
      }
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<List<Review>> getCosmeticsReviews(productId) async {
    try {
      List<Review> list = [];

      var query = FirebaseFirestore.instance
          .collection('reviews')
          .where('product_id', isEqualTo: productId)
          .orderBy('created_at');
      if (lastReviewSnap != null) {
        query.startAfterDocument(lastReviewSnap).limit(15);
      } else {
        query.limit(15);
      }

      var snapshot = await query.get(GetOptions(source: Source.cache));
      print('fetching reviews from cache');

      if (snapshot.docs.isEmpty) {
        print('No Cached Reviews: fetching from server');
        snapshot = await query.get(GetOptions(source: Source.server));
      }

      print(snapshot.docs.length);
      lastReviewSnap = snapshot.docs.last;

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          list.add(Review.fromJson(doc.data()));
        }
        return list;
      } else {
        throw Exception("no products were found");
      }
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<List<Ingredient>> getIngredients(productId) async {
    try {
      List<Ingredient> list = [];
      //get the product ref from cache
      //since all products are fetched from server on app launch,
      //the cache of the product doc will always be available
      var query = FirebaseFirestore.instance
          .collection('products')
          .where('sid', isEqualTo: productId);
      var productSnap = await query.get(GetOptions(source: Source.cache));
      var ingredientRef =
          productSnap.docs.first.reference.collection('ingredients');

      print('fetching ingredients from cache');
      var ingredientSnaps =
          await ingredientRef.get(GetOptions(source: Source.cache));

      if (ingredientSnaps.docs.isEmpty) {
        print('No cached ingredients: fetching from server');
        ingredientSnaps =
            await ingredientRef.get(GetOptions(source: Source.server));
      }
      print(ingredientSnaps.docs.length);

      if (ingredientSnaps.docs.isNotEmpty) {
        for (var doc in ingredientSnaps.docs) {
          list.add(Ingredient.fromJson(doc.data()));
        }
        return list;
      } else {
        throw Exception("no products were found");
      }
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<Product> getCosmetics(productId) async {
    try {
      var body = await getAsync(endPoint: "api/cosmetics/id=$productId");
      final productJson = body["Data"];
      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        return Product.fromJson(productJson);
      }
    } catch (e) {
      print("Error: $e");

      throw e;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(
      {categoryId, sortBy, start, limit = 200}) async {
    try {
      List<Product> list = [];
      var body = await getAsync(
          endPoint:
              "api/products/categories=$categoryId?start=$start&count=$limit&sort_by=$sortBy");

      final products = body["Data"];

      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        for (var item in products) {
          list.add(Product.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      print("Error: $e");

      throw e;
    }
  }

  @override
  Future<List<Product>> getCosmeticsProductsByCategory(
      {categoryId, skinType}) async {
    try {
      List<Product> list = [];
      var body = await getAsync(
          endPoint: "api/cosmetics/categories=$categoryId?skinType=$skinType");
      final products = body["Data"];

      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        for (var item in products) {
          list.add(Product.fromJson(item));
        }
        print("categoryId: $categoryId");
        return list;
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  @override
  Future<List<Product>> getCosmeticsProductsByCategoryF(
      {categoryId, skinType}) async {
    try {
      List<Product> list = [];
      var productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category.parent_id', isEqualTo: categoryId)
          .limit(15)
          .get();
      print(productSnapshot.docs.length);

      if (productSnapshot.docs.isNotEmpty) {
        for (var doc in productSnapshot.docs) {
          // print(doc.data());
          list.add(Product.fromJson(doc.data()));
        }
        print("categoryId: $categoryId");
        return list;
      } else {
        throw Exception("no products were found");
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  @override
  Future<List<Product>> getProductsBySearch({searchText}) async {
    try {
      AlgoliaQuery query =
          algolia.instance.index('cosmetics').search(searchText);

      List<Product> list = [];
      // Get Result/Objects
      AlgoliaQuerySnapshot querySnap = await query.getObjects();
      List<AlgoliaObjectSnapshot> results = querySnap.hits;
      print("querySnap: ${querySnap}");

      print('Hits count: ${querySnap.hits.length}');

      if ((querySnap.hits.length == 0)) {
        return list;
      } else {
        results.forEach((item) {
          list.add(Product.fromJson(item.data));
        });
        return list;
      }
    } catch (e) {
      print("Error: $e");

      throw e;
    }
  }

  @override
  Future<List<Category>> getSubCategories({parentId}) async {
    try {
      List<Category> list = [];
      var body = await getAsync(endPoint: "api/categories/parentId=$parentId");

      final categories = body["Data"];

      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        for (var item in categories) {
          list.add(Category.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      print("Error: $e");

      throw e;
    }
  }

  @override
  Future<List<Product>> getProductsByTag(
      {int tag, int start, int count, String sortBy}) async {
    try {
      List<Product> list = [];
      var body = await getAsync(
          endPoint:
              "api/products/tag=$tag?start=$start&count=$count&sort_by=$sortBy");

      final products = body["Data"];
      print("databody: $products");

      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        for (var item in products) {
          list.add(Product.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      print("Error: $e");

      throw e;
    }
  }

  @override
  Future<List<Product>> getProductsByShop({shopId}) async {
    try {
      List<Product> list = [];
      var body = await getAsync(endPoint: "api/products/shop=$shopId?limit=10");

      final products = body["Data"];
      // print("products: $products");

      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        for (var item in products) {
          list.add(Product.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      print("Error: $e");

      throw e;
    }
  }

// =============================================================================
// AUTHENTICATION
// =============================================================================
  @override
  Future<User> createUser({fullName, email, password}) async {
    try {
      final body = await postAsync(
          endPoint: "api/account/signup",
          data: json.encode(
              {"full_name": fullName, "email": email, "password": password}));

      final userProfile = body['Data'];

      if (body["Success"] == true) {
        print("createUser called");
        return User.fromJsonEmail(userProfile);
      } else {
        var message = body["Error"];
        throw Exception(message != null ? message : "Can not create the user.");
      }
    } catch (err) {
      print("errorprinted: $err");

      if (err.toString() ==
          'Exception: pq: duplicate key value violates unique constraint "accounts_email_key"') {
        print("same yo!");
        var duplicateErr = "Already Registered";
        throw duplicateErr;
      }
      throw err;
    }
  }

  @override
  Future<User> login({email, password}) async {
    try {
      final body = await postAsync(
          endPoint: "api/account/signin",
          data: convert.jsonEncode({'email': email, 'password': password}));
      final userProfile = body['Data'];
      // print("logged in user: $userProfile");

      if (body["Success"] == true) {
        return User.fromJsonEmail(userProfile);
      } else {
        var message = body["Error"];
        throw Exception("wrong password.");
      }
    } catch (err) {
      throw err;
    }
  }

  @override
  Future<User> loginFacebook({String token}) async {
    print("facebook login token: $token");
    try {
      final body = await postAsync(
          endPoint: "oauth2/facebook/login/$token", data: token);

      print('facebook jsondecode: $body');
      if (body["Success"] == false) {
        throw Exception("failed to login with FB${body["Error"]}");
      } else {
        return User.fromJsonFB(body);
      }
    } catch (e) {
      print("loginFacebook error: $e");
      throw e;
    }
  }

  @override
  Future<User> loginApple(String code, fullName) async {
    print("loginApple$code");
    try {
      final body = await postAsync(
          endPoint: "sign_in_with_apple?code=$code&fullName=$fullName");
      // print()

      print('apple jsondecode: $body');
      if (body["Success"] == false) {
        throw Exception("failed to login with FB${body["Error"]}");
      } else {
        return User.fromJsonFB(body);
      }
      // print('apple login jsondecode: $body');
      // if (body["Success"] == false) {
      //   throw Exception("failed to login with FB${body["Error"]}");
      // } else {
      //   return User.fromJsonFB(body);
      // }
    } catch (e) {
      print("loginApple error: $e");
      throw e;
    }
  }

  @override
  Future<User> loginGoogle({String token}) async {
    print("google login : $token");
    try {
      final body =
          await postAsync(endPoint: "oauth2/google/login/$token", data: token);

      print('googlee jsondecode: $body');

      if (body["Account"] != null) {
        return User.fromJsonGoogle(body);
      } else {
        throw ("fail to create user");
      }
    } catch (e) {
      print("loginGoogle error: $e");

      throw e;
    }
  }

  @override
  Future<String> requestPIN({email}) async {
    print("email received: $email");
    try {
      final body = await postAsync(
          endPoint: "api/password/forgot",
          data: convert.jsonEncode({"email": email}));

      String token = body["Data"];
      String result = body["Success"].toString();
      print("jsonDecode request PIN:$body");
      print('isSuccessful : $result]');
      print('accessToken : $token');

      if (result == "true") {
        return token;
      } else {
        throw ("some arbitrary error");
      }
    } catch (e) {
      print("error: fail to request PIN");

      // throw
    }
  }

  Future<bool> checkPIN({pin, token}) async {
    print("pin received: $pin token received: $token");
    try {
      final body = await postAsync(
          endPoint: "api/password/checkpin",
          data: convert.jsonEncode({"pin": pin}));

      bool result = body["Success"];
      print("jsonDecode $body");
      print('isSuccessFul??  $result');

      if (result == true) {
        return result;
      } else {
        throw ("Incorrect PIN");
      }
    } catch (e) {
      print("error: fail to request PIN: $e");

      throw e;
    }
  }

  Future<bool> resetPassword({password, accessToken}) async {
    print("pin received: $password");
    try {
      final body = await postAsync(
          endPoint: "api/password/reset",
          data: convert.jsonEncode({"new": password, "confirm_new": password}),
          headers: {"TokenResetPassword": "Bearer $accessToken"});

      bool result = body["Success"];
      print('isSuccessFul??  $jsonDecode');

      if (result == true) {
        return result;
      } else {
        throw ("failed to reset password");
      }
    } catch (e) {
      print("error: fail to request PIN");

      throw e;
    }
  }

  // ===========================================================================
  // SHIPPING AND PAYMENT
  // ===========================================================================

  @override
  Future<Address> updateAddress({Address address, String accessToken}) async {
    try {
      print("address : ${address.toJson()}");
      final body = await postAsync(
          endPoint: "api/address/update",
          data: jsonEncode({
            "recipient_name": address.recipientName,
            "id": address.id,
            "street": address.street,
            "ward_id": address.ward.id,
            "phone_number": address.phoneNumber,
            "is_default": address.isDefault,
          }));
      if (body["Success"] == true && body["Data"] != null) {
        return Address.fromJson(body["Data"]);
      } else {
        return null;
      }
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<bool> deleteAddress({Address address, String accessToken}) async {
    try {
      print("address to delete: ${address.toJson()}");
      final body = await postAsync(
          endPoint: "api/address/delete",
          data: jsonEncode({
            "id": address.id,
            "recipient_name": address.recipientName,
            "street": address.street,
            "ward_id": address.ward.id,
            "phone_number": address.phoneNumber,
            "is_default": address.isDefault,
          }));
      return body["isSuccess"];
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<Address> createAddress({Address address}) async {
    try {
      List<Address> addresses = [];

      print("address : ${address.toJson()}");
      final body = await postAsync(
          endPoint: "api/address/create",
          data: jsonEncode({
            "id": address.id,
            "recipient_name": address.recipientName,
            "street": address.street,
            "ward_id": address.ward.id,
            "phone_number": address.phoneNumber,
            "is_default": address.isDefault,
          }));
      if (body["Success"] == true && body["Data"] != null) {
        return Address.fromJson(body["Data"]);
      } else {
        return null;
      }
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<List<Address>> getAllAddresses({token}) async {
    try {
      List<Address> addresses = [];
      final body = await getAsync(endPoint: "api/address/get");

      if (body["Success"] == true && body["Data"] != null) {
        print("received ::: ${body["Data"]}");
        for (var item in body["Data"]) {
          addresses.add(Address.fromJson(item));
        }
        return addresses;
      } else {
        return null;
      }
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<List<Province>> getProvinces() async {
    try {
      final body = await getAsync(endPoint: "api/provinces/all");
      var provincesJsons = body["Data"];
      List<Province> list = [];

      for (var item in provincesJsons) {
        list.add(Province.fromJson(item));
      }

      return list;
    } catch (err) {
      throw "Error: $err";
    }
  }

  @override
  Future<List<District>> getDistricts({int provinceId}) async {
    try {
      final body = await getAsync(endPoint: "api/districts/id=$provinceId");

      var districtJsons = body["Data"];
      List<District> list = [];

      for (var item in districtJsons) {
        list.add(District.fromJson(item));
      }
      // print(list);
      return list;
    } catch (err) {
      throw "Err: $err";
    }
  }

  @override
  Future<List<Ward>> getWards({int districtId}) async {
    try {
      final body = await getAsync(endPoint: "api/wards/id=$districtId");

      var wardJsons = body["Data"];
      List<Ward> list = [];

      for (var item in wardJsons) {
        list.add(Ward.fromJson(item));
        // print("${list[0].toJson()}");
      }
      return list;
    } catch (err) {
      throw "err: $err";
    }
  }

// ==========================================================================

  // CART
  // ==========================================================================
  @override
  Future<int> createCartItem(CartItem cartItem) async {
    print("cart item option: ${cartItem.optionId}");

    try {
      final body = await postAsync(
          endPoint: "api/cart/new",
          data: jsonEncode({
            "product_id": cartItem.product.sid,
            "quantity": cartItem.quantity,
            "option": cartItem.option,
            "option_id": cartItem.optionId,
          }));

      return 1;
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<int> updateCartItem(
    CartItem cartItem,
  ) async {
    print("update quantity: ${cartItem.quantity}");

    try {
      final body = await postAsync(
          endPoint: "api/cart/update",
          data: jsonEncode({
            "product_id": cartItem.product.sid,
            "quantity": cartItem.quantity,
            "option": cartItem.option,
            "option_id": cartItem.optionId,
          }));

      return 1;
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<int> deleteCartItem(
    CartItem cartItem,
  ) async {
    try {
      final body = await postAsync(
          endPoint: "api/cart/delete",
          data: jsonEncode({
            "product_id": cartItem.product.sid,
            "quantity": cartItem.quantity,
            "option_id": cartItem.optionId,
          }));
      return 1;
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<List<CartItem>> allCartItems() async {
    try {
      final body = await getAsync(
        endPoint: "api/cart/all",
      );

      final cartItems = body['Data'];
      if (body["Success"] == true) {
        List<CartItem> list = [];
        if (cartItems == null) {
          return list;
        }
        for (var cartItem in cartItems) {
          list.add(CartItem.fromJson(cartItem));
        }
        return list;
      } else {
        var message = body["Error"];
        throw Exception("failed to retreieve product data: ${message}");
      }
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<List<Coupon>> getCoupons() async {
    try {
      final body = await getAsync(
        endPoint: "api/cart/coupons/all",
      );

      final cartItems = body['Data'];
      if (body["Success"] == true) {
        List<Coupon> list = [];
        if (cartItems == null) {
          return list;
        }
        for (var cartItem in cartItems) {
          list.add(Coupon.fromJson(cartItem));
        }
        return list;
      } else {
        var message = body["Error"];
        throw Exception("failed to retreieve coupons: ${message}");
      }
    } catch (err) {
      throw "err: $err";
    }
  }

  // ===========================================================================
  // ORDER MANAGEMENT
  // ===========================================================================
  @override
  Future<List<Order>> getMyOrders() async {
    try {
      final body = await getAsync(endPoint: "api/order/all");

      List<Order> list = [];

      if (body["Success"] == true && body["Data"].length != 0) {
        for (var item in body["Data"]) {
          list.add(Order.fromJson(item));
        }
        return list;
      } else if (body["Data"].length == 0) {
        print("null orders");
        return list;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Order> submitOrder({
    Order order,
  }) async {
    try {
      print("order to submit: ${order.toJson()}");
      final body = await postAsync(
          endPoint: "api/order/new", data: convert.jsonEncode(order));

      bool result = body["Success"];

      var createdOrder = Order.fromJson(body["Data"]);
      print("jsonDecode $body");
      print('Order isSuccessFul??  $result');

      if (result == true) {
        return createdOrder;
      } else {
        throw ("Incorrect PIN");
      }
    } catch (e) {
      print("submitorder : err$e");
      throw e;
    }
  }
}
