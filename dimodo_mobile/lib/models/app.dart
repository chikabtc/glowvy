import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../common/constants.dart';
import 'package:provider/provider.dart';
import '../models/categoryModel.dart';
import '../services/index.dart';
import '../common/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';
import 'order/cart.dart';

class AppModel with ChangeNotifier {
  Map<String, dynamic> appConfig;
  bool isLoading = true;
  String message;
  bool darkTheme = false;
  String locale = kAdvanceConfig['DefaultLanguage'];
  String productListLayout;
  String currency; //USD, VND
  bool showDemo = false;
  String username;
  bool isInit = false;

  AppModel() {
    getConfig();
  }

  Future<bool> getConfig() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locale = prefs.getString("language") ?? kAdvanceConfig['DefaultLanguage'];
      darkTheme = prefs.getBool("darkTheme") ?? false;
      currency = prefs.getString("currency") ??
          (kAdvanceConfig['DefaultCurrency'] as Map)['currency'];
      isInit = true;
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> changeLanguage(String country, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locale = country;
      await Provider.of<CategoryModel>(context, listen: false)
          .getLocalCategories(context, lang: country);
      await prefs.setString("language", country);
      await loadAppConfig();
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  void changeCurrency(String item, BuildContext context) async {
    try {
      Provider.of<CartModel>(context, listen: false).changeCurrency(item);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      currency = item;
      await prefs.setString("currency", currency);
      notifyListeners();
    } catch (err) {}
  }

  void updateTheme(bool theme) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      darkTheme = theme;
      await prefs.setBool("darkTheme", theme);
      notifyListeners();
    } catch (e) {}
  }

  void updateShowDemo(bool value) {
    showDemo = value;
    notifyListeners();
  }

  void updateUsername(String user) {
    username = user;
    notifyListeners();
  }

  void loadStreamConfig(config) {
    appConfig = config;
    productListLayout = appConfig['Setting']['ProductListLayout'];
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAppConfig() async {
    try {
      if (!isInit) {
        await getConfig();
      }
      final LocalStorage storage = LocalStorage('builder');
      var config = await storage.getItem('config');
      if (config != null) {
        appConfig = config;
      } else {
        if (kAppConfig.indexOf('http') != -1) {
          // load on cloud config and update on air
          final appJson = await http.get(Uri.encodeFull(kAppConfig),
              headers: {"Accept": "application/json"});
          appConfig = convert.jsonDecode(appJson.body);
        } else {
          final appJson = await rootBundle.loadString(kAppConfig);
          appConfig = convert.jsonDecode(appJson);
          // // load local config
          String path = "lib/common/config_$locale.json";
          print("path app config:$path");
          try {
            final appJson = await rootBundle.loadString(path);
            appConfig = convert.jsonDecode(appJson);
          } catch (e) {
            final appJson = await rootBundle.loadString(kAppConfig);
            appConfig = convert.jsonDecode(appJson);
          }
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      message = err.toString();
      notifyListeners();
    }
  }
}

class App {
  Map<String, dynamic> appConfig;

  App(this.appConfig);
}
