import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/constants.dart';
import '../../services/index.dart';
import 'user.dart';
import '../address/address.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    //todo: make the init functions synchronosu
    initData();
  }

  Services _service = Services();
  User user;
  bool isLoggedIn = false;
  bool loading = false;
  // CartModel cartModel = CartModel();

  Future<void> initData() async {
    await getUser();
    await getShippingAddress();
  }

  void login({email, password, Function success, Function fail}) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.login(
        email: email,
        password: password,
      );
      kAccessToken = user.accessToken;
      isLoggedIn = true;

      user.defaultAddress = await _service.getAddress(token: user.accessToken);

      saveUser(user);
      success(user);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail(err.toString());
      notifyListeners();
    }
  }

  void loginFB({Function success, Function fail}) async {
    try {
      final FacebookLoginResult result =
          await FacebookLogin().logIn(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          //TODO: return error if the user logging with FB fails
          user = await _service.loginFacebook(token: accessToken.token);
          // user.address = await _service.getAddress(token: user.accessToken);
          kAccessToken = user.accessToken;
          isLoggedIn = true;

          user.defaultAddress =
              await _service.getAddress(token: user.accessToken);

          print('accessToken$accessToken');

          saveUser(user);
          success(user);
          break;
        case FacebookLoginStatus.cancelledByUser:
          fail('The login is cancel');
          break;
        case FacebookLoginStatus.error:
          fail('Error: ${result.errorMessage}');
          break;
      }

      notifyListeners();
    } catch (err) {
      fail(
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString());
    }
  }

  void loginGoogle({Function success, Function fail}) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      GoogleSignInAccount res = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth = await res.authentication;
      var token = auth.accessToken;
      print('google accessToken: $token');

      user = await _service.loginGoogle(token: auth.accessToken);
      kAccessToken = user.accessToken;
      isLoggedIn = true;

      if (user.accessToken != null) {
        user.defaultAddress =
            await _service.getAddress(token: user.accessToken);
      }

      print("lgogogo: ${user.toJson()}");
      saveUser(user);
      success(user);
      notifyListeners();
    } catch (err) {
      print("Canceled Google Sign in: $err");
      fail("Canceled Google Sign in: $err");
    }
  }

  void saveUser(User user) async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      // print("saving user ${user}");
      // save to Preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true);

      // save the user Info as local storage
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(kLocalKey["userInfo"], user);
      }
    } catch (err) {
      print(err);
    }
  }

  Future getUser() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem(kLocalKey["userInfo"]);
        if (json != null) {
          user = User.fromJson(json);
          kAccessToken = user.accessToken;
          isLoggedIn = true;
          notifyListeners();
        } else {
          print("fail to get users");
        }
      }
    } catch (err) {
      print(err);
    }
  }

  Future getShippingAddress() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    if (user != null) {
      user.defaultAddress = await _service.getAddress(token: user.accessToken);
    }

    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem(kLocalKey["shippingAddress"]);
        if (json != null) {
          user.defaultAddress = Address.fromJson(json);
          print("got address: $user");
          notifyListeners();
        } else {
          print("fail to get address");
        }
      }
    } catch (err) {
      print(err);
    }
  }

  void requestPIN({email, Function success, Function fail}) async {
    try {
      loading = true;
      notifyListeners();
      var accessToken = await _service.requestPIN(
        email: email,
      );
      print("user request accessToken: $accessToken");
      isLoggedIn = true;
      success(accessToken);
      loading = false;
      notifyListeners();
    } catch (err) {
      fail(err.toString());
      loading = false;
      notifyListeners();
    }
  }

  void resetPassword(
      {password, accessToken, Function success, Function fail}) async {
    try {
      loading = true;
      notifyListeners();
      var resetPasswordResult = await _service.resetPassword(
          password: password, accessToken: accessToken);
      isLoggedIn = true;
      success(resetPasswordResult);
      loading = false;
      notifyListeners();
    } catch (err) {
      fail(err.toString());
      loading = false;
      notifyListeners();
    }
  }

  void checkPIN({pin, token, Function success, Function fail}) async {
    try {
      loading = true;
      notifyListeners();
      var result = await _service.checkPIN(pin: pin, token: token);
      isLoggedIn = true;
      success(result);
      loading = false;
      notifyListeners();
    } catch (err) {
      fail(err.toString());
      loading = false;
      notifyListeners();
    }
  }

  void createUser(
      {fullName, email, password, Function success, Function fail}) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.createUser(
        fullName: fullName,
        email: email,
        password: password,
      );
      print("Creating user: ${user}");
      isLoggedIn = true;
      saveUser(user);
      success(user);

      loading = false;
      notifyListeners();
    } catch (err) {
      var stringErr = err.toString();
      fail(stringErr);
      loading = false;
      notifyListeners();
    }
  }

  void logout() async {
    user = null;
    isLoggedIn = false;
    try {
      final ready = await kLocalStorage.ready;
      if (ready) {
        await kLocalStorage.deleteItem(kLocalKey["userInfo"]);
        await kLocalStorage.deleteItem(kLocalKey["shippingAddress"]);
        await kLocalStorage.deleteItem(kLocalKey["recentSearches"]);
        await kLocalStorage.deleteItem(kLocalKey["wishlist"]);
        await kLocalStorage.deleteItem(kLocalKey["opencart_accessToken"]);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', false);
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future<bool> isLogin() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem(kLocalKey["userInfo"]);
        return json != null;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  void updateAddress(
      {Address address, String token, Function success, Function fail}) async {
    try {
      this.user.defaultAddress = address;
      var isSuccess =
          await _service.updateAddress(address: address, accessToken: token);
      success(isSuccess);
      saveUser(user);
      notifyListeners();
    } catch (err) {
      fail(
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString());
      notifyListeners();
    }
  }
}
