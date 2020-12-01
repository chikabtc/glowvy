import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // List<Place> _suggestions = [];
  // List<Place> get suggestions => _suggestions;

  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  List<Brand> _filtedBrands = [];
  List<Brand> get filtedBrands => _filtedBrands;

  List<Brand> _brandSuggestions = [];

  List<Brand> get brandSuggestions => _brandSuggestions;

  String _query = '';
  String get query => _query;

  //add method for searching brands

  void searchBrands(String query) {
    List<Brand> list = [];
    if (query == '') {
      _filtedBrands.clear();
      return;
    }

    _brands.forEach((element) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        print(element.name);
        list.add(element);
      }
    });
    _filtedBrands = list;
    print('helo');
    // print('brands hit: ${list.length}');

    notifyListeners();
  }

  // Widget showProductList(
  //     {future,
  //     showFiler = false,
  //     showRank = false,
  //     disableScroll = false,
  //     isFromReviewPage = false,
  //     Function onLoadMore,
  //     sortBy}) {
  //   return FutureBuilder<List<Product>>(
  //     future: future,
  //     builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
  //       products = snapshot.data;
  //       return CosmeticsProductList(
  //         products: snapshot.data,
  //         onLoadMore: onLoadMore,
  //         showFilter: showFiler,
  //         isFromReviewSearch: isFromReviewPage,
  //         disableScrolling: true,
  //         showRank: showRank,
  //       );
  //     },
  //   );
  // }
  Widget showBrandList({disableScroll = false, brands}) {
    return BrandList(
      brands: brands,
      disableScrolling: true,
    );
  }

  Future setBrands() async {
    try {
      List<Brand> list = [];
      //get the product ref from cache
      //since all products are fetched from server on app launch,
      //the cache of the product doc will always be available
      final query = FirebaseFirestore.instance.collection('brands');
      var brandsSnap = await query.get(const GetOptions(source: Source.cache));

      if (brandsSnap.docs.isEmpty) {
        print('No cached ingredients: fetching from server');
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

  // void onQueryChanged(String query) async {
  //   if (query == _query) return;

  //   _query = query;
  //   _isLoading = true;
  //   notifyListeners();

  //   if (query.isEmpty) {
  //     _suggestions = history;
  //   } else {
  //     // item.autocompleteterm
  //     // .toLowerCase()
  //     // .startsWith(query.toLowerCase());

  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // void clear() {
  //   _suggestions = history;
  //   notifyListeners();
  // }
}
