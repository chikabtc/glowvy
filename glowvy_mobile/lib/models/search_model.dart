import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Place> _suggestions = [];
  List<Place> get suggestions => _suggestions;

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

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = history;
    } else {
      // item.autocompleteterm
      // .toLowerCase()
      // .startsWith(query.toLowerCase());

    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = history;
    notifyListeners();
  }
}

const List<Place> history = [
  Place(
    name: 'San Fracisco',
    country: 'United States of America',
    state: 'California',
  ),
  Place(
    name: 'Singapore',
    country: 'Singapore',
  ),
  Place(
    name: 'Munich',
    state: 'Bavaria',
    country: 'Germany',
  ),
  Place(
    name: 'London',
    country: 'United Kingdom',
  ),
];

class Place {
  final String name;
  final String state;
  final String country;
  const Place({
    @required this.name,
    this.state,
    @required this.country,
  })  : assert(name != null),
        assert(country != null);

  bool get hasState => state?.isNotEmpty == true;
  bool get hasCountry => country?.isNotEmpty == true;

  bool get isCountry => hasCountry && name == country;
  bool get isState => hasState && name == state;

  factory Place.fromJson(Map<String, dynamic> map) {
    final props = map['properties'];

    return Place(
      name: props['name'] ?? '',
      state: props['state'] ?? '',
      country: props['country'] ?? '',
    );
  }

  String get address {
    if (isCountry) return country;
    return '$name, $level2Address';
  }

  String get addressShort {
    if (isCountry) return country;
    return '$name, $country';
  }

  String get level2Address {
    if (isCountry || isState || !hasState) return country;
    if (!hasCountry) return state;
    return '$state, $country';
  }

  @override
  String toString() => 'Place(name: $name, state: $state, country: $country)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Place &&
        o.name == name &&
        o.state == state &&
        o.country == country;
  }

  @override
  int get hashCode => name.hashCode ^ state.hashCode ^ country.hashCode;
}
