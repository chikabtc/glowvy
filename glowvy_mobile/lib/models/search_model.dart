import 'dart:convert' as convert;

import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchModel extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  b.User firebaseUser = b.FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  List<Brand> _filtedBrands = [];
  List<Brand> get filtedBrands => _filtedBrands;

  List<Brand> _brandSuggestions = [];
  List<Brand> get brandSuggestions => _brandSuggestions;

  List<Category> _categorySuggestion = [];
  List<Category> get categorySuggestion => _categorySuggestion;

  String _query = '';
  String get query => _query;

  //add method for searching brands
  List<Category> categories = [];
  List<Category> flatCategories = [];

  void clear() {
    print('emtpy queri');

    _query = '';
    _brandSuggestions = [];
    _categorySuggestion = [];
    notifyListeners();
  }

  Future setLocalCategories() async {
    print('Try to get localCate!');
    try {
      const categoryPath = 'lib/common/categories.json';
      final categoryJsonString = await rootBundle.loadString(categoryPath);
      final cateJson = convert.jsonDecode(categoryJsonString);
      // var localCates = <Category>[];

      // for (final cate in addressJson) {
      //   final category = Category.fromJson(cate);
      //   // category.subCategories = cates;

      //   localCates.add(category);
      // }
      categories
        ..add(Category.fromJson(cateJson[0]))
        ..add(Category.fromJson(cateJson[6]))
        ..add(Category.fromJson(cateJson[7]))
        ..add(Category.fromJson(cateJson[8]));
      //put all categories into one array
      categories.forEach((firstCate) {
        flatCategories.add(firstCate);

        firstCate.subCategories.forEach((secondCate) {
          flatCategories.add(secondCate);

          secondCate.subCategories.forEach((thirdCate) {
            flatCategories.add(thirdCate);
          });
        });
      });
      print('length cflt: ${flatCategories.length}');

      notifyListeners();
    } catch (err) {
      'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
          err.toString();

      print('error: $err');
      notifyListeners();
    }
  }

  void searchBrands(String query) {
    if (query == '') {
      _filtedBrands.clear();
      return;
    }
    _filtedBrands = _brands
        .where(
            (brand) => brand.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    // print('brands hit: ${list.length}');

    notifyListeners();
  }

  Widget showBrandList({disableScroll = false, brands}) {
    return BrandList(
      brands: brands,
      disableScrolling: true,
    );
  }

  bool isSuggestionEmpty() {
    return brandSuggestions.isEmpty && categorySuggestion.isEmpty;
  }

  Future setBrands() async {
    try {
      final list = <Brand>[];
      //get the product ref from cache
      //since all products are fetched from server on app launch,
      //the cache of the product doc will always be available
      final query = FirebaseFirestore.instance.collection('brands');
      var brandsSnap = await query.get(const GetOptions(source: Source.server));

      if (brandsSnap.docs.isEmpty) {
        print('No cached brands: fetching from server');
        brandsSnap = await query.get(const GetOptions(source: Source.server));
      }
      print('brandsSnap length: ${brandsSnap.docs.length}');

      if (brandsSnap.docs.isNotEmpty) {
        for (final doc in brandsSnap.docs) {
          list.add(Brand.fromJson(doc.data()));
        }
        _brands = list;
      } else {
        print('no _brands were found');
      }
    } catch (err) {
      rethrow;
    }
  }

  // TODO(parker): search the local brands, categories, and recent quries and recently viewed products
  Future onQueryChanged(
    String query,
  ) async {
    if (query == _query) return;

    _query = query;

    _isLoading = true;
    notifyListeners();

    //if the query is empty, show the recently viewed items
    if (query.isEmpty) {
      // _suggestions = history;
      //if query exists, then search through the local brand, categories json, user' search history (items and queries)
    } else {
      _brandSuggestions = _brands
          .where((brand) =>
              brand.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();

      //2. search categories -> use json search
      _categorySuggestion = flatCategories
          .where((category) =>
              category.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
