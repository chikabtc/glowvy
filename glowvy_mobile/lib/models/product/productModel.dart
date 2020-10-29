import 'package:Dimodo/models/product/generating_product_list.dart';
import 'package:Dimodo/models/product/one_item_generating_list.dart';
import 'package:Dimodo/models/product/review_meta.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/constants.dart';
import '../../services/index.dart';
// import '../../widgets/product/product_list.dart';
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
  int skinTypeId;
  // ReviewMeta selectedreviewMeta;

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

  sortProducts(sorting, skinTypeId, products) {
    var sortedProducts;
    switch (sorting) {
      case "high":
        sortedProducts = sortByPrice(products, false);
        break;
      case "rank":
        sortedProducts = sortBySkinType(products);
        break;
      case "low":
        sortedProducts = sortByPrice(products, true);
        break;
      default:
        sortedProducts = sortByAllRanking(products);
        break;
    }
    // print("products filtered : ${sortedProducts.length}");

    return sortedProducts;
  }

  List<Product> sortByPrice(List<Product> products, bool isAscending) {
    print("sorb y price : ${products.length}");
    products.sort((a, b) => isAscending
        ? b.salePrice.compareTo(a.salePrice)
        : a.salePrice.compareTo(b.salePrice));
    // print("rating: ${products[0].rating}");
    return products;
  }

  updateSkinType(skinTypeId) {
    this.skinTypeId = skinTypeId;
  }

  List<Product> sortBySkinType(List<Product> products) {
    switch (skinTypeId) {
      //all
      case 0:
        products.sort((a, b) => a.reviewMetas.all.rankingScore
            .compareTo(b.reviewMetas.all.rankingScore));
        break;
      //sensitive
      case 1:
        products.sort((a, b) => a.reviewMetas.sensitive.rankingScore
            .compareTo(b.reviewMetas.sensitive.rankingScore));
        break;
      //dry
      case 2:
        products.sort((a, b) => a.reviewMetas.dry.rankingScore
            .compareTo(b.reviewMetas.dry.rankingScore));

        break;
      //oily
      case 3:
        products.sort((a, b) => a.reviewMetas.oily.rankingScore
            .compareTo(b.reviewMetas.oily.rankingScore));
        break;
      //oily
      case 3:
        products.sort((a, b) => a.reviewMetas.complex.rankingScore
            .compareTo(b.reviewMetas.complex.rankingScore));
        break;
      //oily
      case 3:
        products.sort((a, b) => a.reviewMetas.neutral.rankingScore
            .compareTo(b.reviewMetas.neutral.rankingScore));
        break;
    }
    return products;
  }

  List<Product> sortByAllRanking(List<Product> products) {
    // var skinType = getSkinTypeById(skinTypeId);
    products.sort((a, b) => b.reviewMetas.all.rankingScore
        .compareTo(a.reviewMetas.all.rankingScore));

    return products;
  }

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
        return S.of(context).all;
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
      //complex
      case 4:
        return 'complex';
      //neutral
      case 5:
        return 'neutral';

        break;
    }
  }

  // List<Product> filterBySkinType(List<Product> products) {
  //   print("fitered products: ${products.length}");

  //   products = products.where((p) {
  //     var isMatching = true;
  //     switch (skinTypeId) {
  //       //all
  //       case 0:
  //         break;
  //       //sensitive
  //       case 1:
  //         isMatching = p.reviewMetas.sensitive.reviewCount == 0 ? false : true;
  //         break;
  //       //dry
  //       case 2:
  //         isMatching = p.reviewMetas.dry.reviewCount == 0 ? false : true;
  //         if (isMatching = p.reviewMetas.dry.reviewCount != 0) {}
  //         break;
  //       //oily
  //       case 3:
  //         isMatching = p.reviewMetas.oily.reviewCount == 0 ? false : true;
  //         break;
  //       //complex
  //       case 4:
  //         isMatching = p.reviewMetas.oily.reviewCount == 0 ? false : true;
  //         break;
  //       //neutral
  //       case 5:
  //         isMatching = p.reviewMetas.neutral.reviewCount == 0 ? false : true;
  //         break;
  //       default:
  //         isMatching = true;
  //         break;
  //     }
  //     return isMatching;
  //   }).toList();
  //   print("fitered products: ${products.length}");
  //   return products;
  // }

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
    print("cate id: ${category.firstCategoryName}");

    // for fetching beforehand
    product.setCategoryId(categoryId: category.firstCategoryId);
    product.setProductsList(List<Product>()); //clear old products
    // _service.fetchProductsByCategory(categoryId: category.id);

    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //         builder: (context) => SubCategoryScreen(category: category)));
  }

  // showProductListByCategory(
  //     {cateId, sortBy, context, limit, isNameAvailable = false, onLoadMore}) {
  //   return FutureBuilder<List<Product>>(
  //     future: service.getProductsByCategory(
  //       categoryId: cateId,
  //       // start: start,
  //       limit: limit,
  //       sortBy: sortBy,
  //     ),
  //     builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
  //       products = snapshot.data;
  //       return ProductList(
  //         products: snapshot.data,
  //         onLoadMore: onLoadMore,
  //         isNameAvailable: isNameAvailable,
  //       );
  //     },
  //   );
  // }

  // Widget showProductList(
  //     {isNameAvailable,
  //     future,
  //     isListView,
  //     showFiler = false,
  //     disableScroll = false,
  //     Function onLoadMore,
  //     sortBy}) {
  //   return FutureBuilder<List<Product>>(
  //     future: future,
  //     builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
  //       products = snapshot.data;

  //       return ProductList(
  //         products: snapshot.data,
  //         onLoadMore: onLoadMore,
  //         showFilter: showFiler,
  //         isListView: isListView,
  //         disableScrolling: disableScroll,
  //         isNameAvailable: isNameAvailable,
  //       );
  //     },
  //   );
  // }

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
          disableScrolling: true,
          showRank: false,
        );
      },
    );
  }

  Widget showCosmeticsReviewProductList(
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
          isProductReviewList: true,
          showFilter: showFiler,
          disableScrolling: true,
          showRank: false,
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
