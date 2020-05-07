import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'dart:convert';
import "dart:core";
import 'package:Dimodo/models/order/cartItem.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/strings.dart';
import '../common/config.dart';
import '../models/address/address.dart';
import '../models/address/ward.dart';
import '../models/address/province.dart';
import '../models/address/district.dart';
import '../models/aftership.dart';
import '../models/order/cart.dart';
import '../models/category.dart';
import '../models/coupon.dart';
import '../models/order/order.dart';
import '../models/order/order_note.dart';
import '../models/payment_method.dart';
import '../models/product/product.dart';
import '../models/reviews.dart';
import '../models/shipping_method.dart';
import '../models/user/user.dart';
import '../models/user/userModel.dart';
import 'helper/dimodo_api.dart';
import 'index.dart';
import 'package:firebase_performance/firebase_performance.dart';

class _MetricHttpClient extends BaseClient {
  _MetricHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get);

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = request.contentLength
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }
}

class DimodoServices implements BaseServices {
  //TODO: what does these 3 lines of codes do ?
  static final DimodoServices _instance = DimodoServices._internal();
  factory DimodoServices() => _instance;
  final _MetricHttpClient metricHttpClient = _MetricHttpClient(Client());

  DimodoServices._internal();

  Map<String, dynamic> configCache;
  DimodoAPI dimodoAPIs;
  String isSecure;
  String url;
  List<Category> categories = [];

  void appConfig(appConfig) {
    dimodoAPIs = DimodoAPI(appConfig["url"], appConfig["consumerKey"],
        appConfig["consumerSecret"]);
    isSecure = appConfig["url"].indexOf('http') != -1 ? '' : '&insecure=cool';
    url = appConfig["url"];
  }

  // ===========================================================================
  // PRODUCTS
  // ===========================================================================

  Future<List<Category>> getCategoriesByPage({lang, page}) async {
    try {
      String url = "products/categories?exclude=311&per_page=100&page=$page";
      if (lang != null) {
        url += "&lang=$lang";
      }
      var response = await dimodoAPIs.getAsync(url);
      if (page == 1) {
        categories = [];
      }
      if (response is Map && isNotBlank(response["message"])) {
        throw Exception(response["message"]);
      } else {
        for (var item in response) {
          if (item['slug'] != "uncategorized" && item['count'] > 0)
            categories.add(Category.fromJson(item));
        }
        if (response.length == 100) {
          return getCategoriesByPage(lang: lang, page: page + 1);
        } else {
          return categories;
        }
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Category>> getCategories({lang}) async {
    try {
      List<Category> list = [];
      var cat = await dimodoAPIs
          .getAsync('products/categories?lang=$lang&per_page=100');
      for (var item in cat) {
        list.add(Category.fromJson(item));
      }
      print(list.length);
      return list;
    } catch (e) {
      return categories;
      //throw e;
    }
  }

  @override
  Future<Product> getProduct(id) async {
    try {
      final http.Response response =
          await http.get("http://localhost:80/api/products/id=$id/sr=brandi");

      final body = convert.jsonDecode(utf8.decode(response.bodyBytes));
      final product = body['Data'];

      if (body["Success"] == true) {
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
      // var params = {'offset': offset.toString(), 'limit': limit.toString()};
      // print(params);

      var uri =
          'http://localhost:80/api/products/review/id=$id/sr=brandi?offset=$offset&limit=$limit';
      print(uri);

      final http.Response response = await http.get(uri);

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));

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
  Future<Null> createReview({int productId, Map<String, dynamic> data}) async {
    try {
      await dimodoAPIs.postAsync("products/$productId/reviews", data);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Product>> fetchProductsByCategory(
      {categoryId, sortBy, limit = 200}) async {
    try {
      List<Product> list = [];
      var url =
          "http://localhost:80/api/products/categories=$categoryId?start=0&count=$limit&sort_by=$sortBy";
      print(url);
      final http.Response response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      final products = body["Data"];

      if ((body["Success"] == false)) {
        throw Exception(body["Success"]);
      } else {
        print("category products length: ${products.length}");
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
  Future<List<Product>> fetchProductsByTag({tag, sortBy}) async {
    try {
      List<Product> list = [];
      var url =
          "http://localhost:80/api/products/tag=$tag?start=0&count=200&sort_by=$sortBy";
      print(url);

      final http.Response response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
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
  Future<List<Product>> fetchProductsByShop({shopId}) async {
    try {
      List<Product> list = [];
      var url = "http://localhost:80/api/products/shop=$shopId?limit=10";
      print(url);
      final http.Response response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
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
      print("fullname ${fullName} email ${email} password ${password}");
      final http.Response response = await http.post(
          "http://localhost:80/api/account/signup",
          body: json.encode(
              {"full_name": fullName, "email": email, "password": password}));

      var body = json.decode(response.body);
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
      final http.Response response = await http.post(
          "http://localhost:80/api/account/signin",
          body: convert.jsonEncode({'email': email, 'password': password}));

      final body = convert.jsonDecode(utf8.decode(response.bodyBytes));
      final userProfile = body['Data'];
      // print("logged in user: $userProfile");

      if (body["Success"] == true) {
        return User.fromJsonEmail(userProfile);
      } else {
        var message = body["Error"];
        throw Exception("wrong password.");
      }
    } catch (err) {
      // return err;

      throw err;
    }
  }

  @override
  Future<User> loginFacebook({String token}) async {
    // const accessTokenLifeTime = 120960000000;
    print("facebook login token: $token");
    try {
      final http.Response response = await http.post(
          "http://localhost:80/oauth2/facebook/login/$token",
          body: token);

      var jsonDecode = convert.jsonDecode(response.body);
      print('facebook jsondecode: $jsonDecode');
      if (jsonDecode["Success"] == false) {
        throw Exception("failed to login with FB${jsonDecode["Error"]}");
      } else {
        return User.fromJsonFB(jsonDecode);
      }
    } catch (e) {
      print("loginFacebook error: $e");
      throw e;
    }
  }

  @override
  Future<User> loginGoogle({String token}) async {
    print("google login : $token");
    try {
      var url = "http://localhost:80/oauth2/google/login/$token";
      print(url);
      final http.Response response = await http.post(url, body: token);
      var body = convert.jsonDecode(response.body);

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
      final http.Response response = await http.post(
          "http://localhost:80/api/password/forgot",
          body: convert.jsonEncode({"email": email}));
      Map<String, dynamic> jsonDecode = convert.jsonDecode(response.body);
      String token = jsonDecode["Data"];
      String result = jsonDecode["Success"].toString();
      print("jsonDecode request PIN:$jsonDecode");
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
      final http.Response response = await http.post(
          "http://localhost:80/api/password/checkpin",
          body: convert.jsonEncode({"pin": pin}),
          headers: {"TokenPinResetPassword": "Bearer $token"});

      Map<String, dynamic> jsonDecode = convert.jsonDecode(response.body);
      bool result = jsonDecode["Success"];
      print("jsonDecode $jsonDecode");
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
      final http.Response response = await http.post(
          "http://localhost:80/api/password/reset",
          body: convert.jsonEncode({"new": password, "confirm_new": password}),
          headers: {"TokenResetPassword": "Bearer $accessToken"});

      Map<String, dynamic> jsonDecode = convert.jsonDecode(response.body);
      bool result = jsonDecode["Success"];
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

  @override
  Future<User> getUserInfor({int id}) async {
    try {
      // var response = await dimodoAPIs.getAsync('customers/${id.toString()}');
      // if (response is Map && isNotBlank(response["message"])) {
      //   throw Exception(response["message"]);
      // } else {
      //   return User.fromWoJson(response);
      // }
    } catch (e) {
      throw e;
    }
  }

  // ===========================================================================
  // SHIPPING AND PAYMENT
  // ===========================================================================

  @override
  Future<bool> updateAddress({Address address, token}) async {
    try {
      print("address token: ${address.ward.toJson()}");
      final http.Response response =
          await http.post("http://localhost:80/api/address/update",
              headers: {"Authorization": "Bearer $token"},
              body: jsonEncode({
                "recipient_name": address.recipientName,
                "street": address.street,
                "ward_id": address.ward.id,
                "phone_number": address.phoneNumber
              }));

      Map<String, dynamic> body = convert.jsonDecode(response.body);

      print("body: $body");

      return body["isSuccess"];
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<Address> getAddress({token}) async {
    print("getaddress token: $token");
    try {
      final http.Response response = await http
          .get("http://localhost:80/api/address/get", headers: {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json'
      });

      var body = convert.jsonDecode(utf8.decode(response.bodyBytes));

      if (body["Success"] == true && body["Data"] != null) {
        Address address = Address.fromJson(body["Data"]);
        return address;
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
      final http.Response response =
          await http.get("http://localhost:80/api/provinces/all");

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
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
      print("http://localhost:80/api/districts/id=$provinceId");
      final http.Response response =
          await http.get("http://localhost:80/api/districts/id=$provinceId");

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      // print("body: ${body["Data"]}");
      var districtJsons = body["Data"];
      // print("districtJsons: $districtJsons");
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
      final http.Response response =
          await http.get("http://localhost:80/api/wards/id=$districtId");

      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
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

  @override
  Future<List<ShippingMethod>> getShippingMethods(
      {Address address, String token}) async {
    try {
      List<ShippingMethod> list = [];
      var response = await dimodoAPIs.getAsync("address/zones");
      if (response is Map && isNotBlank(response["message"])) {
        throw Exception(response["message"]);
      } else {
        for (var zone in response) {
          final id = zone["id"];
          var response = await dimodoAPIs.getAsync("address/zones/$id/methods");
          if (response is Map && isNotBlank(response["message"])) {
            throw Exception(response["message"]);
          } else {
            var res = await dimodoAPIs.getAsync("address/zones/$id/locations");
            if (res is Map && isNotBlank(res["message"])) {
              throw Exception(res["message"]);
            } else {
              List locations = res;
              bool isValid = true;
              bool checkedPostcode = false;
              locations.forEach((o) {
                // if (o["type"] == "country" && isValid) {
                //   isValid = Shipping.country == o["code"];
                // }
                // if (o["type"] == "postcode" &&
                //     ((!checkedPostcode && isValid) ||
                //         (checkedPostcode && !isValid))) {
                //   isValid = Shipping.zipCode == o["code"];
                //   checkedPostcode = true;
                // }
              });
              if (isValid) {
                for (var item in response) {
                  list.add(ShippingMethod.fromJson(item));
                }
              }
            }
          }
        }
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<AfterShip> getAllTracking() async {
    final data = await http.get('http://api.aftership.com/v4/trackings',
        headers: {'aftership-api-key': afterShip['api']});
    return AfterShip.fromJson(json.decode(data.body));
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods(
      {Address address, ShippingMethod shippingMethod, String token}) async {
    try {
      print(shippingMethod.toString());
      var response = await dimodoAPIs.getAsync("payment_gateways");
      if (response is Map && isNotBlank(response["message"])) {
        throw Exception(response["message"]);
      } else {
        List<PaymentMethod> list = [];
        for (var item in response) {
          bool isAllowed = false;
          if (item["settings"]["enable_for_methods"] != null &&
              kAdvanceConfig["EnableShipping"]) {
            final allowedShipping =
                item["settings"]["enable_for_methods"]["value"];
            if (allowedShipping is List) {
              allowedShipping.forEach((address) {
                if (address ==
                    "${shippingMethod.methodId}:${shippingMethod.id}") {
                  isAllowed = true;
                }
              });
            } else {
              isAllowed = true;
            }
          } else {
            isAllowed = true;
          }
          if (item["enabled"] && isAllowed) {
            list.add(PaymentMethod.fromJson(item));
          }
        }
        return list;
      }
    } catch (e) {
      throw e;
    }
  } // ==========================================================================

  // CART
  // ==========================================================================
  @override
  Future<int> createCartItem(CartItem cartItem, UserModel userModel) async {
    try {
      print("cart item option: ${cartItem.optionId}");

      final http.Response response = await http.post(
          "http://localhost:80/api/cart/new",
          headers: {"Authorization": "Bearer ${userModel.user.accessToken}"},
          body: jsonEncode({
            "product_id": cartItem.product.sid,
            "quantity": cartItem.quantity,
            "option": cartItem.option,
            "option_id": cartItem.optionId,
          }));

      Map<String, dynamic> body = convert.jsonDecode(response.body);
      // var totalQuantity = body["totalQuantiy"];

      // print("body: $body");

      return 1;
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<int> updateCartItem(CartItem cartItem, UserModel userModel) async {
    try {
      final http.Response response = await http.post(
          "http://localhost:80/api/cart/update",
          headers: {"Authorization": "Bearer ${userModel.user.accessToken}"},
          body: jsonEncode({
            "product_id": cartItem.product.sid,
            "quantity": cartItem.quantity,
            "option": cartItem.option,
            "option_id": cartItem.optionId,
          }));

      Map<String, dynamic> body = convert.jsonDecode(response.body);
      // var totalQuantity = body["totalQuantiy"];

      print("body: $body");

      return 1;
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<int> deleteCartItem(CartItem cartItem, UserModel userModel) async {
    try {
      final http.Response response = await http.post(
          "http://localhost:80/api/cart/delete",
          headers: {"Authorization": "Bearer ${userModel.user.accessToken}"},
          body: jsonEncode({
            "product_id": cartItem.product.sid,
            "quantity": cartItem.quantity,
            "option_id": cartItem.optionId,
          }));

      Map<String, dynamic> body = convert.jsonDecode(response.body);
      // var totalQuantity = body["totalQuantiy"];

      print("body: $body");

      return 1;
    } catch (err) {
      throw "err: $err";
    }
  }

  @override
  Future<List<CartItem>> allCartItems(UserModel userModel) async {
    try {
      print("address token: ${userModel.user.accessToken}");

      final http.Response response = await http.get(
        "http://localhost:80/api/cart/all",
        headers: {"Authorization": "Bearer ${userModel.user.accessToken}"},
      );

      Map<String, dynamic> body =
          convert.jsonDecode(utf8.decode(response.bodyBytes));
      final cartItems = body['Data'];
      if (body["Success"] == true) {
        List<CartItem> list = [];
        if (cartItems == null) {
          return list;
        }
        for (var cartItem in cartItems) {
          print("cartItem : ${cartItem}");
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

  // ===========================================================================
  // ORDER MANAGEMENT
  // ===========================================================================
  @override
  Future<List<Order>> getMyOrders({UserModel userModel, int page}) async {
    try {
      final http.Response response = await http.get(
          "http://localhost:80/api/order/all",
          headers: {"Authorization": "Bearer ${userModel.user.accessToken}"});
      Map<String, dynamic> jsonDecode =
          convert.jsonDecode(utf8.decode(response.bodyBytes));
      print("getmyorders: $jsonDecode");
      List<Order> list = [];
      // print("getMyorders: ${jsonDecode["Data"]}");

      if (jsonDecode["Success"] == true && jsonDecode["Data"].length != 0) {
        for (var item in jsonDecode["Data"]) {
          list.add(Order.fromJson(item));
        }
        return list;
      } else if (jsonDecode["Data"].length == 0) {
        print("null orders");
        return list;
      } else {
        throw Exception(jsonDecode["message"]);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<OrderNote>> getOrderNote(
      {UserModel userModel, int orderId}) async {
    try {
      var response = await dimodoAPIs.getAsync(
          "orders/$orderId/notes?customer=${userModel.user.id}&per_page=20");
      List<OrderNote> list = [];
      if (response is Map && isNotBlank(response["message"])) {
        throw Exception(response["message"]);
      } else {
        for (var item in response) {
          list.add(OrderNote.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Order> createOrder({Order order, UserModel userModel}) async {
    try {
      print("order json: ${order.toJson()}");
      final http.Response response = await http.post(
          "http://localhost:80/api/order/new",
          headers: {"Authorization": "Bearer ${userModel.user.accessToken}"},
          body: convert.jsonEncode(order));

      Map<String, dynamic> jsonDecode = convert.jsonDecode(response.body);
      bool result = jsonDecode["Success"];

      var returnedOrder = Order.fromJson(jsonDecode["Data"]);
      print("jsonDecode $jsonDecode");
      print('Order isSuccessFul??  $result');

      if (result == true) {
        return returnedOrder;
      } else {
        throw ("Incorrect PIN");
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future updateOrder(orderId, {status}) async {
    try {
      var response =
          await dimodoAPIs.putAsync("orders/$orderId", {"status": status});
      if (response["message"] != null) {
        throw Exception(response["message"]);
      } else {
//        print(response);
        return Order.fromJson(response);
      }
    } catch (e) {
      throw e;
    }
  }

// =============================================================================
// SEARCH PRODUCTS
// =============================================================================
  @override
  Future<List<Product>> searchProducts({name, page}) async {
    try {
      var response = await dimodoAPIs.getAsync(
          "products?status=publish&search=$name&page=$page&per_page=50");
      if (response is Map && isNotBlank(response["message"])) {
        throw Exception(response["message"]);
      } else {
        List<Product> list = [];
        for (var item in response) {
          list.add(Product.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      throw e;
    }
  }

  /// Get Nonce for Any Action
  Future getNonce({method = 'register'}) async {
    try {
      http.Response response = await http.get(
          "$url/api/get_nonce/?controller=mstore_user&method=$method&$isSecure");
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body)['nonce'];
      } else {
        throw Exception(['error getNonce', response.statusCode]);
      }
    } catch (e) {
      throw e;
    }
  }

  /// Auth
  @override
  Future<User> getUserInfo(accessToken) async {}

  /// Create a New User

  Future<Map<String, dynamic>> getHomeCache() async {
    try {
      final data = await http.get('$url/wp-json/mstore/v1/cache');
      var config = json.decode(data.body);
      if (data.statusCode == 200 && config['HorizonLayout'] != null) {
        var horizontalLayout = config['HorizonLayout'] as List;
        var items = [];
        var products = [];
        List<Product> list;
        for (var i = 0; i < horizontalLayout.length; i++) {
          if (horizontalLayout[i]["radius"] != null) {
            horizontalLayout[i]["radius"] =
                double.parse("${horizontalLayout[i]["radius"]}");
          }
          if (horizontalLayout[i]["size"] != null) {
            horizontalLayout[i]["size"] =
                double.parse("${horizontalLayout[i]["size"]}");
          }
          if (horizontalLayout[i]["padding"] != null) {
            horizontalLayout[i]["padding"] =
                double.parse("${horizontalLayout[i]["padding"]}");
          }

          products = horizontalLayout[i]["data"] as List;
          list = [];
          if (products != null && products.length > 0) {
            for (var item in products) {
              Product product = Product.fromJson(item);
              product.categoryId = horizontalLayout[i]["category"];
              list.add(product);
            }
            horizontalLayout[i]["data"] = list;
          }

          items = horizontalLayout[i]["items"] as List;
          if (items != null && items.length > 0) {
            for (var j = 0; j < items.length; j++) {
              if (items[j]["padding"] != null) {
                items[j]["padding"] = double.parse("${items[j]["padding"]}");
              }

              List<Product> listProduct = [];
              var prods = items[j]["data"] as List;
              if (prods != null && prods.length > 0) {
                for (var prod in prods) {
                  listProduct.add(Product.fromJson(prod));
                }
                items[j]["data"] = listProduct;
              }
            }
          }
        }

        configCache = config;
        return config;
      }
      return null;
    } catch (e) {
      throw e;
    }
  }
}
