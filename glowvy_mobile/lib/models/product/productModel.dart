import 'package:Dimodo/models/product/generating_product_list.dart';
import 'package:Dimodo/models/product/one_item_generating_list.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/constants.dart';
import '../../services/index.dart';
import '../../widgets/product/product_list.dart';
import '../../models/category.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:Dimodo/generated/i18n.dart';

import 'package:Dimodo/screens/categories/sub_category.dart';
import 'product.dart';

class Sorting {
  static String low = "low";
  static String high = "high";
  static String rank = "rank";
}

class ProductModel with ChangeNotifier {
  static Services service = Services();
  List<Product> products;
  List<Review> reviews;
  String message;
  Map<String, dynamic> cosmeticsFilter;

  /// current select product id/name
  int categoryId;
  int _tagId;
  String _sortBy;
  String categoryName;

  //list products for products screen
  bool isFetching = false;
  bool isEnd = false;
  bool isLoading = false;
  int offset = 0;
  int limit = 80;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";
  bool isAscending = false;
  String errMsg;

//ProductVariation can be used for layout variation
  ProductVariation productVariation;

  void setCategoryId({categoryId}) {
    this.categoryId = categoryId;
    notifyListeners();
  }

  void saveProducts(Map<String, dynamic> data) async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(kLocalKey["home"], data);
      }
    } catch (err) {
      print(err);
    }
  }

  sortAndFilter(sorting, skinTypeId, products) {
    var filtered;
    switch (sorting) {
      case "high":
        filtered = sortByPrice(products, false);
        break;
      case "rank":
        filtered = sortByDefaultRank(products);
        break;
      case "low":
        filtered = sortByPrice(products, true);
        break;
      default:
        filtered = sortByDefaultRank(products);
        break;
    }
    print("products filtered : ${filtered.length}");

    return filteredProductsBySkinType(skinTypeId, filtered);
  }

  List<Product> sortByPrice(List<Product> products, bool isAscending) {
    print("sorb y price : ${products.length}");
    products.sort((a, b) => isAscending
        ? b.salePrice.compareTo(a.salePrice)
        : a.salePrice.compareTo(b.salePrice));
    // print("rating: ${products[0].rating}");
    return products;
  }

  List<Product> sortByProductsBySkinType(skinTypeId, List<Product> products) {
    switch (skinTypeId) {
      //all
      case 0:
        products.sort((a, b) => a.cosmeticsRank.allSkinRank["Int32"]
            .compareTo(b..cosmeticsRank.allSkinRank["Int32"]));
        break;
      //sensitive
      case 1:
        products.sort((a, b) => a.cosmeticsRank.sensitiveSkinRank["Int32"]
            .compareTo(b..cosmeticsRank.sensitiveSkinRank["Int32"]));
        break;
      //dry
      case 2:
        products.sort((a, b) => a.cosmeticsRank.drySkinRank["Int32"]
            .compareTo(b..cosmeticsRank.drySkinRank["Int32"]));

        break;
      //oily
      case 3:
        products.sort((a, b) => a.cosmeticsRank.oilySkinRank["Int32"]
            .compareTo(b.cosmeticsRank.oilySkinRank["Int32"]));
        break;
    }
    return products;
  }

  List<Product> sortByDefaultRank(
    List<Product> products,
  ) {
    products.sort((a, b) => b.rating.compareTo(a.rating));

    return products;
  }

  // List<Product> setProducts(products) {
  //   this.products = sortAndFilter(products);
  //   return products;
  // }

  List<Product> filteredProducts(
      {List<String> filterOptions, List<Product> products}) {
    var filterProducts = products.where((p) {
      var isMatching = false;
      filterOptions.forEach((option) {
        if (p.tags.contains(option)) {
          isMatching = true;
        }
      });
      return isMatching;
    }).toList();
    return filterProducts;
  }

  getSkinTypeById(skinTypeId, context) {
    switch (skinTypeId) {
      //all
      case 0:
        return S.of(context).filter;
        break;
      //sensitive
      case 1:
        return S.of(context).sensitive;
        break;
      //dry
      case 2:
        return S.of(context).dry;
        break;
      //oily
      case 3:
        return S.of(context).oily;

        break;
    }
  }

  List<Product> filteredProductsBySkinType(skinTypeId, List<Product> products) {
    print("fitered products: ${products.length}");

    products = products.where((p) {
      var isMatching = true;
      switch (skinTypeId) {
        //all
        case 0:
          break;
        //sensitive
        case 1:
          isMatching =
              p.cosmeticsRank.sensitiveSkinRank["Int32"] == 0 ? false : true;
          break;
        //dry
        case 2:
          isMatching = p.cosmeticsRank.drySkinRank["Int32"] == 0 ? false : true;
          if (isMatching = p.cosmeticsRank.drySkinRank["Int32"] != 0) {}
          break;
        //oily
        case 3:
          isMatching =
              p.cosmeticsRank.oilySkinRank["Int32"] == 0 ? false : true;
          break;
        default:
          isMatching = true;
          break;
      }
      return isMatching;
    }).toList();
    print("fitered products: ${products.length}");
    return products;
  }

  List<Review> filteredReviewsBySkinType(
      {int skinTypeId, List<Review> reviews}) {
    reviews = reviews.where((r) {
      var isMatching = false;
      switch (skinTypeId) {
        //all
        case 0:
          isMatching = true;
          break;
        //sensitive
        case 1:
          isMatching = r.user.skinTypeId == 1 ? true : false;
          break;
        //dry
        case 2:
          isMatching = r.user.skinTypeId == 2 ? true : false;
          break;
        //oily
        case 3:
          isMatching = r.user.skinTypeId == 3 ? true : false;
          print(isMatching);
          break;
        default:
          print("default");
      }
      return isMatching;
    }).toList();
    print("reviews length:${reviews.length}");
    return reviews;
  }

  void getProductsList({categoryId, sortBy}) async {
    try {
      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      isFetching = true;
      isEnd = false;
      notifyListeners();

      products = await service.getProductsByCategory(
          categoryId: categoryId, sortBy: sortBy);
      if (products.isEmpty) {
        isEnd = true;
      }
      isFetching = false;
      errMsg = null;
      notifyListeners();
    } catch (err) {
      errMsg =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      isFetching = false;
      notifyListeners();
    }
  }

  Future<Product> getProduct({id}) async {
    try {
      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      isFetching = true;
      isEnd = false;
      notifyListeners();

      final product = await service.getProduct(id);

      isFetching = false;
      errMsg = null;
      notifyListeners();
      return product;
    } catch (err) {
      errMsg =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("errMsg $errMsg");
      isFetching = false;
      notifyListeners();
    }
  }

  void fetchProductsByCategory({categoryId, start, limit, sortBy}) async {
    try {
      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      isFetching = true;
      isEnd = false;
      notifyListeners();

      final products = await service.getProductsByCategory(
          categoryId: categoryId, start: start, limit: limit, sortBy: sortBy);
      if (products.isEmpty) {
        isEnd = true;
      }
      this.products = products;

      isFetching = false;
      errMsg = null;
      notifyListeners();
    } catch (err) {
      errMsg =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();
      isFetching = false;
      notifyListeners();
    }
  }

  void setProductsList(products) {
    products = products;
    isFetching = false;
    isEnd = false;
    notifyListeners();
  }

  showSubCategoryPage(Category category, String sortBy, context,
      {bool isNameAvailable}) {
    final product = Provider.of<ProductModel>(context, listen: false);
    print("show subcate");
    print("cate id: ${category.name}");

    // for fetching beforehand
    product.setCategoryId(categoryId: category.id);
    product.setProductsList(List<Product>()); //clear old products
    // _service.fetchProductsByCategory(categoryId: category.id);

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => SubCategoryScreen(category: category)));
  }

  showProductListByCategory(
      {cateId, sortBy, context, limit, isNameAvailable = false, onLoadMore}) {
    return FutureBuilder<List<Product>>(
      future: service.getProductsByCategory(
        categoryId: cateId,
        // start: start,
        limit: limit,
        sortBy: sortBy,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        products = snapshot.data;
        return ProductList(
          products: snapshot.data,
          onLoadMore: onLoadMore,
          isNameAvailable: isNameAvailable,
        );
      },
    );
  }

  Widget showProductList(
      {isNameAvailable,
      future,
      isListView,
      showFiler = false,
      disableScroll = false,
      Function onLoadMore,
      sortBy}) {
    return FutureBuilder<List<Product>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        products = snapshot.data;

        return ProductList(
          products: snapshot.data,
          onLoadMore: onLoadMore,
          showFilter: showFiler,
          isListView: isListView,
          disableScrolling: disableScroll,
          isNameAvailable: isNameAvailable,
        );
      },
    );
  }

  Widget showCosmeticsProductList(
      {isNameAvailable,
      future,
      showFiler = false,
      disableScroll = false,
      Function onLoadMore,
      sortBy}) {
    return FutureBuilder<List<Product>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        products = snapshot.data;

        return CosmeticsProductList(
          products: snapshot.data,
          onLoadMore: onLoadMore,
          showFilter: showFiler,
          disableScrolling: disableScroll,
          isNameAvailable: isNameAvailable,
        );
      },
    );
  }

  Widget showGeneartingProductList() {
    return GeneratingProductList();
  }

  Widget showGeneartingOneRowProductList() {
    return GeneratingOneRowList();
  }

  void getProductsByTag({tag, start, limit, sortBy}) async {
    _tagId = tag;
    _sortBy = sortBy;

    this.products = await service.getProductsByTag(
      tag: _tagId,
      sortBy: _sortBy,
      start: start,
      count: limit,
    );
    print("new products2323 length: ${products.length}");
  }
}
