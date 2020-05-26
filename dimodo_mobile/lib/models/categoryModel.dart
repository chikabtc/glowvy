import 'package:flutter/material.dart';
import '../services/index.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'category.dart';

class CategoryModel with ChangeNotifier {
  Services _service = Services();
  List<Category> categories = [];
  Map<int, Category> categoryList = {};

  bool isLoading = true;
  String message;

  void getLocalCategories(context, {lang}) async {
    print("Try to get localCate!");
    try {
      final localCategories =
          await Provider.of<AppModel>(context, listen: false)
              .appConfig['Categories'] as List;
      print("localCate: $localCategories");
      var localCates = List<Category>();

      for (var cate in localCategories) {
        var cates =
            await _service.getSubCategories(parentId: cate["parent_id"]);
        // cate.subCategories = cates;
        var category = Category.fromJson(cate);
        category.subCategories = cates;
        localCates.add(category);
      }
      categories = localCates;

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
