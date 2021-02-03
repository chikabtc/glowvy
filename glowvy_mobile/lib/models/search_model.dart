import 'dart:convert' as convert;

import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  b.User firebaseUser = b.FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  List<Brand> _filteredBrands = [];
  List<Brand> get filteredBrands => _filteredBrands;

  List<Brand> _brandSuggestions = [];
  List<Brand> get brandSuggestions => _brandSuggestions;

  List<Category> _categorySuggestion = [];
  List<Category> get categorySuggestion => _categorySuggestion;

  List<String> queryHistory = [];
  List<String> _recentQuerySuggestions = [];
  List<String> get recentQuerySuggestions => _recentQuerySuggestions;

  List<Product> recentSearchItems = [];

  String _query = '';
  String get query => _query;
  final b.FirebaseAuth _auth = b.FirebaseAuth.instance;

  //add method for searching brands
  List<Category> categories = [];
  List<Category> flatCategories = [];

  Future<void> initData() async {
    listenToAuthStateUpdate();
    await setBrands();
    await setCategories();
  }

  void onLogout() {
    queryHistory = [];
    recentSearchItems = [];
    _recentQuerySuggestions = [];
    _query = '';
    notifyListeners();
  }

  void listenToAuthStateUpdate() {
    _auth.authStateChanges().listen((b.User user) async {
      if (user == null) {
        firebaseUser = user;
        print('User is currently signed out!');
      } else {
        firebaseUser = user;
        print('User is signed in and auth changed!');
      }
    });
  }

  void setSerchHistory(UserModel userModel) {
    try {
      queryHistory = userModel.user.recentSearchQueries ?? [];
      recentSearchItems = userModel.user.recentSearchItems ?? [];
      if (recentSearchItems.isNotEmpty) {
        recentSearchItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      notifyListeners();
    } catch (err) {
      'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
          err.toString();

      print('error: $err');
      notifyListeners();
    }
  }

  Future setCategories() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('id', descending: false)
          .get();

      var allCategories = <Category>[];

      snap.docs.forEach((element) {
        allCategories.add(Category.fromJson(element.data()));
      });

      categories
        ..add(allCategories[0])
        ..add(allCategories[6])
        ..add(allCategories[7])
        ..add(allCategories[8]);

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

      notifyListeners();
    } catch (err) {
      'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
          err.toString();

      print('setCategories error: $err');
      notifyListeners();
    }
  }

  void searchBrands(String query) {
    if (query == '') {
      _filteredBrands.clear();
      return;
    }
    _filteredBrands = _brands
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
    return brandSuggestions.isEmpty &&
        categorySuggestion.isEmpty &&
        _recentQuerySuggestions.isEmpty;
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

      if (brandsSnap.docs.isNotEmpty) {
        for (final doc in brandsSnap.docs) {
          final brand = Brand.fromJson(doc.data());
          list.add(brand);
          // print('brandsn :${brand.id}');
        }
        _brands = list;
      } else {
        print('no _brands were found');
      }
      print('brandsSnap length: ${brandsSnap.docs.length}');
    } catch (err) {
      rethrow;
    }
  }

  Future onQueryChanged(
    String query,
  ) async {
    if (query == _query) return;

    _query = query;

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
      _recentQuerySuggestions = queryHistory
          .where((recentQuery) =>
              recentQuery.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    }
    print(_recentQuerySuggestions.length);

    notifyListeners();
  }

  Future onQueryChangedProductReviewSearch(
    String query,
  ) async {
    if (query == _query) return;

    _query = query;

    //if the query is empty, show the recently viewed items
    if (query.isEmpty) {
      // _suggestions = history;
      //if query exists, then search through the local brand, categories json, user' search history (items and queries)
    } else {
      _recentQuerySuggestions = queryHistory
          .where((recentQuery) =>
              recentQuery.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  Future clearSuggestion() async {
    try {
      _query = '';
      _brandSuggestions = [];
      _categorySuggestion = [];

      notifyListeners();
      return;
    } catch (e) {
      throw 'clearSuggestion e: $e';
    }
  }

  Future clear() async {
    try {
      await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .update({'recent_search_items': FieldValue.delete()});
      recentSearchItems = [];

      _query = '';
      _brandSuggestions = [];
      _categorySuggestion = [];

      notifyListeners();
      return;
    } catch (e) {
      throw 'clearSearchHistory e: $e';
    }
  }

  void clearBrandsResult() {
    _filteredBrands = [];
    notifyListeners();
  }

  Future onQuerySubmitted(String query) async {
    try {
      if (!queryHistory.contains(query)) {
        queryHistory.add(query);
        await _db.collection('users').doc(firebaseUser.uid).update({
          'recent_search_queries': FieldValue.arrayUnion([query])
        });
      }

      notifyListeners();
      return;
    } catch (e) {
      throw 'onQuerySubmitted e: $e';
    }
  }

  Future saveRecentSearchItem(Product product) async {
    try {
      final json = {
        'sid': product.sid,
        'name': product.name,
        'thumbnail': product.thumbnail,
        'volume': product.volume,
        'hazard_score': product.hazardScore,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'brand': product.brand.toJson(),
        'category': product.category.toJson(),
      };

      if (!recentSearchItems.contains(product)) {
        recentSearchItems.insert(0, product);
        await _db.collection('users').doc(firebaseUser.uid).update({
          'recent_search_items': FieldValue.arrayUnion([json])
        });
      }

      notifyListeners();
      return;
    } catch (e) {
      throw 'saveRecentSearchItem e: $e';
    }
  }

  int getSuggestionCount() {
    var itemCount;
    if (isSuggestionEmpty()) {
      itemCount = 1;
    } else {
      itemCount = brandSuggestions.length +
          categorySuggestion.length +
          _recentQuerySuggestions.length;
      ;
    }
    return itemCount <= 5 ? itemCount : 5;
  }

  String getSuggestion(index, query) {
    var suggestion = '';
    if (isSuggestionEmpty()) {
      suggestion = query;
    } else if (index < _recentQuerySuggestions.length) {
      suggestion = _recentQuerySuggestions[index];
    } else if (index <
        _categorySuggestion.length + _recentQuerySuggestions.length) {
      suggestion =
          categorySuggestion[index - _recentQuerySuggestions.length].name;
    } else {
      suggestion = _brandSuggestions[index -
              _recentQuerySuggestions.length -
              _categorySuggestion.length]
          .name;
    }
    return suggestion;
  }
}
