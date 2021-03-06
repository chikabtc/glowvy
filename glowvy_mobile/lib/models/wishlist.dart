import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../common/constants.dart';
import '../models/product/product.dart';

class WishListModel extends ChangeNotifier {
  WishListModel() {
    getLocalWishlist();
  }

  List<Product> products = [];

  List<Product> getWishList() => products;

  void addToWishlist(Product product) {
    final isExist = products.firstWhere((item) => item.id == product.id,
        orElse: () => null);
    if (isExist == null) {
      products.add(product);
      saveWishlist(products);
      notifyListeners();
    }
  }

  void removeToWishlist(Product product) {
    final isExist = products.firstWhere((item) => item.id == product.id,
        orElse: () => null);
    if (isExist != null) {
      products = products.where((item) => item.id != product.id).toList();
      saveWishlist(products);
      notifyListeners();
    }
  }

  void saveWishlist(List<Product> products) async {
    final storage = LocalStorage('Dimodo');
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(kLocalKey['wishlist'], products);
      }
    } catch (err) {
      print(err);
    }
  }

  void getLocalWishlist() async {
    final storage = LocalStorage('Dimodo');
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = await storage.getItem(kLocalKey['wishlist']);
        if (json != null) {
          var list = <Product>[];
          for (var item in json) {
            list.add(Product.fromJson(item));
          }
          products = list;
        }
      }
    } catch (err) {
      print(err);
    }
  }
}
