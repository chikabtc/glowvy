import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/generating_product_list.dart';
import 'package:Dimodo/models/product/one_item_generating_list.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
import 'package:Dimodo/widgets/product/products_list_view.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';

import '../../common/constants.dart';
import '../product_category.dart';
import 'product.dart';

class PagesInfo {
  int algoliaPage = 0;
  DocumentSnapshot lastBrandProdutSnap;
  DocumentSnapshot lastCategoryProductSnap;
}

class ProductModel with ChangeNotifier {
  List<Product> products;
  FirebaseFirestore db = FirebaseFirestore.instance;
  b.User firebaseUser = b.FirebaseAuth.instance.currentUser;
  PagesInfo pagesInfo = PagesInfo();

  static Algolia algolia = const Algolia.init(
    applicationId: '50G6MO803G',
    apiKey: 'ab5eb7ec7552bb7865f3819a2b08f462',
  );

  void saveProducts(Map<String, dynamic> data) async {
    final storage = LocalStorage('Dimodo');
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(kLocalKey['home'], data);
      }
    } catch (err) {
      print(err);
    }
  }

  dynamic sortProducts(sorting, skinTypeId, products) {
    List<Product> sortedProducts;
    switch (sorting) {
      case 'high':
        sortedProducts = sortByPrice(products, isDescending: false);
        break;
      case 'rank':
        sortedProducts = sortBySkinType(skinTypeId, products);
        break;
      case 'low':
        sortedProducts = sortByPrice(products, isDescending: true);
        break;
      default:
        sortedProducts = sortByAllRanking(products);
        break;
    }
    // print('products filtered : ${sortedProducts.length}');

    return sortedProducts;
  }

  List<Product> sortByPrice(List<Product> products, {bool isDescending}) {
    products.sort((a, b) => isDescending
        ? b.sprice.compareTo(a.sprice)
        : a.sprice.compareTo(b.sprice));
    // print('rating: ${products[0].rating}');
    return products;
  }

  List<Product> sortByCreatedDate(List<Product> products, {bool isAscending}) {
    products.sort((a, b) => isAscending
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    // print('rating: ${products[0].rating}');
    return products;
  }

  List<Product> sortByHighReviews(List<Product> products, {bool isDescending}) {
    products.sort((a, b) => isDescending
        ? b.reviewMetas.all.reviewCount.compareTo(a.reviewMetas.all.reviewCount)
        : a.reviewMetas.all.reviewCount
            .compareTo(b.reviewMetas.all.reviewCount));

    return products;
  }

  List<Product> sortByAllRanking(List<Product> products) {
    products.sort((a, b) {
      // print('compare a: ${a.reviewMetas.all.toJson()} and b: ${b.sid}');
      return b.reviewMetas.all.rankingScore
          .compareTo(a.reviewMetas.all.rankingScore);
    });
    return products;
  }

  List<Product> sortBySkinType(skinTypeId, List<Product> products) {
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
      //oily
    }
    return products;
  }

  List<Product> sortByRating(List<Product> products) {
    // var skinType = getSkinTypeById(skinTypeId);
    products.sort((a, b) => b.reviewMetas.all.averageRating
        .compareTo(a.reviewMetas.all.averageRating));

    return products;
  }

  List<Product> filteredProducts(
      {List<String> filterOptions, List<Product> products}) {
    final filterProducts = products.where((p) {
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

  String getSkinTypeById(skinTypeId, context) {
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

  void clearPaginationHistory() {
    print('cleared pagination history');
    pagesInfo = PagesInfo();
    pagesInfo.algoliaPage = 0;
  }

  Future<ListPage<Product>> getProductsByBrand(Brand brand,
      {sortMethod = 'review_metas.all.ranking_score'}) async {
    print('brand id: ${brand.id}');
    try {
      var listPage = ListPage(grandTotalCount: 0, itemList: <Product>[]);

      var query = FirebaseFirestore.instance
          .collection('products')
          .where('brand.id', isEqualTo: brand.id);
      QuerySnapshot productSnapshot;

      if (pagesInfo.lastBrandProdutSnap == null) {
        print('productsnapshot');
        productSnapshot = await query.limit(10).get();
      } else {
        productSnapshot = await query
            .startAfterDocument(pagesInfo.lastBrandProdutSnap)
            .limit(10)
            .get();
      }

      if (productSnapshot.docs.isNotEmpty) {
        pagesInfo.lastBrandProdutSnap = productSnapshot.docs.last;
        for (final doc in productSnapshot.docs) {
          listPage.itemList.add(Product.fromJson(doc.data()));
        }
        listPage.grandTotalCount = brand.grandTotalCount;
        print('not my e: ${listPage.itemList.length}');

        return listPage;
      } else {
        return listPage;
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

//get all product info with ingredients
  Future<Product> getWholeProduct(productId) async {
    try {
      Product product;
      final ingredientList = <Ingredient>[];
      //get the product ref from cache
      //since all products are fetched from server on app launch,
      //the cache of the product doc will always be available
      final query = FirebaseFirestore.instance
          .collection('products')
          .where('sid', isEqualTo: productId);
      final productSnap =
          await query.get(const GetOptions(source: Source.server));
      if (productSnap.docs.isNotEmpty) {
        product = Product.fromJson(productSnap.docs.first.data());
      } else {
        print('no products were found by $productId');
        return null;
      }
      final ingredientRef =
          productSnap.docs.first.reference.collection('ingredients');

      var ingredientSnaps =
          await ingredientRef.get(const GetOptions(source: Source.cache));

      if (ingredientSnaps.docs.isEmpty) {
        print('No cached ingredients: fetching from server');
        ingredientSnaps =
            await ingredientRef.get(const GetOptions(source: Source.server));
      }
      print('ingredients length: ${ingredientSnaps.docs.length}');

      if (ingredientSnaps.docs.isNotEmpty) {
        for (final doc in ingredientSnaps.docs) {
          ingredientList.add(Ingredient.fromJson(doc.data()));
        }
        product.ingredients = ingredientList;
        return product;
      } else {
        print('no ingredients were found');
      }
      return product;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Ingredient>> getIngredients(productId) async {
    try {
      final list = <Ingredient>[];
      //get the product ref from cache
      //since all products are fetched from server on app launch,
      //the cache of the product doc will always be available
      final query = FirebaseFirestore.instance
          .collection('products')
          .where('sid', isEqualTo: productId);
      final productSnap =
          await query.get(const GetOptions(source: Source.server));
      final ingredientRef =
          productSnap.docs.first.reference.collection('ingredients');

      print('fetching ingredients from cache');
      var ingredientSnaps =
          await ingredientRef.get(const GetOptions(source: Source.cache));

      if (ingredientSnaps.docs.isEmpty) {
        print('No cached ingredients: fetching from server');
        ingredientSnaps =
            await ingredientRef.get(const GetOptions(source: Source.server));
      }
      print('ingredients length: ${ingredientSnaps.docs.length}');

      if (ingredientSnaps.docs.isNotEmpty) {
        for (final doc in ingredientSnaps.docs) {
          list.add(Ingredient.fromJson(doc.data()));
        }
        return list;
      } else {
        print('no products were found');

        return list;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<Product> getProductById(id) async {
    try {
      final query = FirebaseFirestore.instance
          .collection('products')
          .where('sid', isEqualTo: id);

      var snapshot = await query.get(const GetOptions(source: Source.cache));
      print('fetching product from cache');

      if (snapshot.docs.isEmpty) {
        print('No Cached product: fetching from server');
        snapshot = await query.get(const GetOptions(source: Source.server));
      }

      if (snapshot.docs.isNotEmpty) {
        return Product.fromJson(snapshot.docs.first.data());
      } else {
        throw Exception('no products were found');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<ListPage<Product>> getProductsByCategory(Category category,
      {orderBy = 'review_metas.all.average_rating'}) async {
    // ignore: prefer_typing_uninitialized_variables
    var categoryField;

    if (category.level == 0) {
      categoryField = 'first_category_id';
    } else if (category.level == 1) {
      categoryField = 'second_category_id';
    } else if (category.level == 2) {
      categoryField = 'third_category_id';
    }

    print('getProductsByCategoryId: ${category.id}');

    try {
      var listPage = ListPage(grandTotalCount: 0, itemList: <Product>[]);
      var list = <Product>[];
      QuerySnapshot productSnapshot;
      if (pagesInfo.lastCategoryProductSnap != null) {
        var product =
            Product.fromJson(pagesInfo.lastCategoryProductSnap.data());

        print(
            'firestore category pagination last product cate id: ${product.sid}');
        productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('category.$categoryField', isEqualTo: category.id)
            .startAfterDocument(pagesInfo.lastCategoryProductSnap)
            .limit(15)
            .get();
      } else {
        print('no firestore category pagination data');
        productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('category.$categoryField', isEqualTo: category.id)
            .limit(15)
            .get();
      }

      if (productSnapshot.docs.isNotEmpty) {
        for (final doc in productSnapshot.docs) {
          list.add(Product.fromJson(doc.data()));
        }
        list = sortByRating(list);
        listPage.itemList = list;
        pagesInfo.lastCategoryProductSnap = productSnapshot.docs.last;
        listPage.grandTotalCount = 0;
        return listPage;
      } else {
        return listPage;
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<ListPage<Product>> getProductsBySearch(String searchText) async {
    print('searching products');
    try {
      var page = ListPage(grandTotalCount: 0, itemList: <Product>[]);

      assert(searchText.isNotEmpty);

      final querySnap = await algolia.instance
          .index('cosmetics')
          .setHitsPerPage(200)
          .search(searchText)
          .getObjects();

      // Get Result/Objects
      final results = querySnap.hits;

      print('Hits count: ${querySnap.hits.length}');

      if (querySnap.hits.isEmpty) {
        print('passing empty page');
        return page;
      } else {
        pagesInfo.algoliaPage++;
        page.grandTotalCount = querySnap.hits.length;
        results.forEach((item) {
          page.itemList.add(Product.fromJson(item.data));
          // print('item ${item.data}');
        });
        return page;
      }
    } catch (e) {
      print('Error: $e');

      rethrow;
    }
  }

  void showSubCategoryPage(ProductCategory category, String sortBy, context,
      {bool isNameAvailable}) {
    print('show subcate');
    print('cate id: ${category.firstCategoryName}');
  }

  Widget showGeneartingProductList() {
    return GeneratingProductList();
  }

  Widget showGeneartingOneRowProductList() {
    return GeneratingOneRowList();
  }
}
