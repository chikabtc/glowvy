import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../services/index.dart';
import '../app.dart';
import 'package:flutter/services.dart';
import '../../widgets/product/product_list.dart';
import '../../models/category.dart';

import 'package:Dimodo/screens/categories/sub_category.dart';
import '../brandi/option.dart';
import '../sizeDetail.dart';
import 'product.dart';

class ProductModel with ChangeNotifier {
  static Services service = Services();
  List<List<Product>> products;
  String message;

  /// current select product id/name
  int categoryId;
  String categoryName;

  //list products for products screen
  bool isFetching = false;
  List<Product> productsList;
  String errMsg;
  bool isEnd;

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

  void getProductsList({categoryId}) async {
    try {
      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      isFetching = true;
      isEnd = false;
      notifyListeners();

      final products =
          await service.fetchProductsByCategory(categoryId: categoryId);
      if (products.isEmpty) {
        isEnd = true;
      }
      print("setting list!!!!: $products");
      productsList = products;

      // if (page == 0 || page == 1) {
      //   productsList = products;
      // } else {
      //   productsList = []..addAll(productsList)..addAll(products);
      // }
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

  void fetchProductsByCategory({categoryId, lang, page}) async {
    try {
      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      isFetching = true;
      isEnd = false;
      notifyListeners();

      final products =
          await service.fetchProductsByCategory(categoryId: categoryId);
      if (products.isEmpty) {
        isEnd = true;
      }
      print("setting list!!!!: $products");
      productsList = products;

      // if (page == 0 || page == 1) {
      //   productsList = products;
      // } else {
      //   productsList = []..addAll(productsList)..addAll(products);
      // }
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
    productsList = products;
    isFetching = false;
    isEnd = false;
    notifyListeners();
  }

  /// Show Products in Slider View
  static showList(
      {cateId, cateName, context, List<Product> products, config, noRouting}) {
    var categoryId = cateId ?? config['category'];
    final product = Provider.of<ProductModel>(context, listen: false);

    // for caching current products list
    if (products != null && products.length > 0) {
      product.setProductsList(products);
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubCategoryScreen(category: categoryId)));
    }

    // for fetching beforehand
    if (categoryId != null) product.setCategoryId(categoryId: categoryId);

    product.setProductsList(List<Product>()); //clear old products
    product.getProductsList(
      categoryId: categoryId,
    );

    if (noRouting == null)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubCategoryScreen(category: categoryId)));
    else
      return SubCategoryScreen(category: categoryId);
  }

  static showSubCategoryPage(Category category, context) {
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

  static showProductListByCategory({cateId, context}) {
    var categoryId = cateId;
    final product = Provider.of<ProductModel>(context, listen: false);

    product.setCategoryId(
      categoryId: categoryId,
    );

    //rebuilding three times
    // product.setProductsList(List<Product>()); //clear old products
    return FutureBuilder<List<Product>>(
      future: service.fetchProductsByCategory(categoryId: cateId),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        return ProductList(
          products: snapshot.data,
        );
      },
    );
  }

  static showProductListByTag({tag, context}) {
    return FutureBuilder<List<Product>>(
      future: service.fetchProductsByTag(tag: tag),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        return ProductList(
          products: snapshot.data,
        );
      },
    );
  }

  static showProductListByShop({shopId, context}) {
    //rebuildintag three times
    // product.setProductsList(List<Product>()); //clear old products
    return FutureBuilder<List<Product>>(
      future: service.fetchProductsByShop(shopId: shopId),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        return ProductList(
          products: snapshot.data,
        );
      },
    );
  }
}
