import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:Dimodo/models/category.dart';
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
  List<dynamic> categoriese = [];

  String _query = '';
  String get query => _query;

  //add method for searching brands
  List<Category> categories = [];

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
      const provincePath = 'lib/common/categories.json';
      final provinceJsonString = await rootBundle.loadString(provincePath);
      final addressJson = convert.jsonDecode(provinceJsonString);
      // var localCates = <Category>[];

      // for (final cate in addressJson) {
      //   final category = Category.fromJson(cate);
      //   // category.subCategories = cates;

      //   localCates.add(category);
      // }
      categories
        ..add(Category.fromJson(addressJson[0]))
        ..add(Category.fromJson(addressJson[6]))
        ..add(Category.fromJson(addressJson[7]))
        ..add(Category.fromJson(addressJson[8]));

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
    _filtedBrands = _brands.where(
        (brand) => brand.name.toLowerCase().startsWith(query.toLowerCase()));
    print('helo');
    // print('brands hit: ${list.length}');

    notifyListeners();
  }

  Widget showBrandList({disableScroll = false, brands}) {
    return BrandList(
      brands: brands,
      disableScrolling: true,
    );
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
    print('query: $query');
    _isLoading = true;
    notifyListeners();

    //if the query is empty, show the recently viewed items
    if (query.isEmpty) {
      // _suggestions = history;
      //if query exists, then search through the local brand, categories json, user' search history (items and queries)
    } else {
      //show relevant suggestions
      //1. search brands
      _brandSuggestions = _brands
          .where((brand) =>
              brand.name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();

      //2. search categories -> use json search
      categoriese = categories
          .where((category) => category.firstCategoryEnName
              .toLowerCase()
              .startsWith(query.toLowerCase()))
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
