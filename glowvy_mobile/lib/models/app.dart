import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/config.dart';
import '../common/constants.dart';

class AppModel with ChangeNotifier {
  AppModel() {
    getConfig();
  }
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

  Future<bool> getConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      locale = prefs.getString('language') ?? kAdvanceConfig['DefaultLanguage'];
      darkTheme = prefs.getBool('darkTheme') ?? false;
      currency = prefs.getString('currency') ??
          (kAdvanceConfig['DefaultCurrency'] as Map)['currency'];
      isInit = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeLanguage(String country, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      locale = country;
      // await Provider.of<CategoryModel>(context, listen: false)
      //     .getLocalCategories(context, lang: country);
      await prefs.setString('language', country);
      await loadAppConfig();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future changeCurrency(String item, BuildContext context) async {
    try {
      // Provider.of<CartModel>(context, listen: false).changeCurrency(item);
      final prefs = await SharedPreferences.getInstance();
      currency = item;
      await prefs.setString('currency', currency);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future updateTheme(bool theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      darkTheme = theme;
      await prefs.setBool('darkTheme', theme);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
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
      final storage = LocalStorage('builder');
      final config = await storage.getItem('config');
      if (config != null) {
        appConfig = config;
      } else {
        if (kAppConfig.contains('http')) {
          // load on cloud config and update on air
          final appJson = await http.get(Uri.encodeFull(kAppConfig),
              headers: {'Accept': 'application/json'});
          appConfig = convert.jsonDecode(appJson.body);
        } else {
          final appJson = await rootBundle.loadString(kAppConfig);
          appConfig = convert.jsonDecode(appJson);
          final path = 'lib/common/config_$locale.json';
          print('path app config:$path');
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
    } catch (e) {
      isLoading = false;
      message = e.toString();
      notifyListeners();
    }
  }
}

class App {
  App(this.appConfig);

  Map<String, dynamic> appConfig;
}
