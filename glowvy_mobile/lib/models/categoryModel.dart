// import 'dart:convert' as convert;

// import 'package:Dimodo/models/category.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CategoryModel with ChangeNotifier {
//   List<Category> categories = [];

//   Future setLocalCategories() async {
//     print('Try to get localCate!');
//     try {
//       const provincePath = 'lib/common/categories.json';
//       final provinceJsonString = await rootBundle.loadString(provincePath);
//       final addressJson = convert.jsonDecode(provinceJsonString);
//       // var localCates = <Category>[];

//       // for (final cate in addressJson) {
//       //   final category = Category.fromJson(cate);
//       //   // category.subCategories = cates;

//       //   localCates.add(category);
//       // }
//       categories
//         ..add(Category.fromJson(addressJson[0]))
//         ..add(Category.fromJson(addressJson[6]))
//         ..add(Category.fromJson(addressJson[7]))
//         ..add(Category.fromJson(addressJson[8]));

//       notifyListeners();
//     } catch (err) {
//       'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
//           err.toString();

//       print('error: $err');
//       notifyListeners();
//     }
//   }
// }
