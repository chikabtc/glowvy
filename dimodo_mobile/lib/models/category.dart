import 'package:flutter/material.dart';
import '../services/index.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'app.dart';

class CategoryModel with ChangeNotifier {
  Services _service = Services();
  List<Category> categories = [];
  Map<int, Category> categoryList = {};

  bool isLoading = true;
  String message;

  void getCategories({lang}) async {
    try {
      categories = await _service.getCategories(lang: lang);
      isLoading = false;
      message = null;
      for (Category cat in categories) {
        categoryList[cat.id] = cat;
      }
//      print(categories);
      notifyListeners();
    } catch (err) {
      isLoading = false;
      message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      notifyListeners();
    }
  }

  void getLocalCategories(context, {lang}) async {
    print("Try to get localCate!");
    try {
      final localCategories =
          await Provider.of<AppModel>(context, listen: false)
              .appConfig['Categories'] as List;
      // print("localCate: $localCategories");
      var localCates = List<Category>();

      for (var cate in localCategories) {
        localCates.add(Category.fromJson(cate));
      }
      categories = localCates;
      print("local cate: $categories'");

      isLoading = false;
      message = null;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("error: $message");
      notifyListeners();
    }
  }
}

class Category {
  int id;
  String name;
  String image;
  int parent;
  List<dynamic> subCategories;
  int totalProduct;

  Category.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = HtmlUnescape().convert(parsedJson["name"]);
    image = parsedJson["image"];

    var categoryList = List();
    if (parsedJson["subCategories"] != null) {
      for (var cate in parsedJson["subCategories"]) {
        categoryList.add(Category.fromJson(cate));
      }
      subCategories = categoryList;
    }
  }

  @override
  String toString() => 'Category { id: $id  name: $name}';
}
