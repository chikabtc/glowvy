import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../services/index.dart';
import '../../widgets/product/product_list.dart';
import '../../models/category.dart';

import 'package:Dimodo/screens/categories/sub_category.dart';
import 'product.dart';

class ProductModel with ChangeNotifier {
  static Services service = Services();
  List<Product> products;
  String message;

  /// current select product id/name
  int categoryId;
  int _tagId;
  String _sortBy;
  String categoryName;

  //list products for products screen
  bool isFetching = false;
  bool isEnd = false;

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

  static showSubCategoryPage(Category category, String sortBy, context,
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
        MaterialPageRoute(
            builder: (context) => SubCategoryScreen(category: category)));
  }

  static showProductListByCategory(
      {cateId, sortBy, context, limit, isNameAvailable = false, onLoadMore}) {
    return FutureBuilder<List<Product>>(
      future: service.getProductsByCategory(
        categoryId: cateId,
        // start: start,
        limit: limit,
        sortBy: sortBy,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        return ProductList(
          products: snapshot.data,
          onLoadMore: onLoadMore,
          isNameAvailable: isNameAvailable,
        );
      },
    );
  }

  static Widget showProductList(
      {isNameAvailable,
      future,
      showFiler = false,
      disableScroll = false,
      Function onLoadMore,
      sortBy}) {
    return FutureBuilder<List<Product>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        return ProductList(
          products: snapshot.data,
          onLoadMore: onLoadMore,
          showFilter: showFiler,
          disableScrolling: disableScroll,
          isNameAvailable: isNameAvailable,
        );
      },
    );
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

  // void getProductsBy({tag, start, limit, sortBy}) async {
  //   _tagId = tag;
  //   _sortBy = sortBy;

  //   this.products = await service.getProductsByTag(
  //     tag: _tagId,
  //     sortBy: _sortBy,
  //     start: start,
  //     count: limit,
  //   );
  //   print("new products2323 length: ${products.length}");
  // }
}
