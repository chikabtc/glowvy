import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/ingredient.dart';
import 'package:Dimodo/models/product/generating_product_list.dart';
import 'package:Dimodo/models/product/one_item_generating_list.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../common/constants.dart';
import '../product_category.dart';
import 'product.dart';

class Sorting {
  static String low = 'low';
  static String high = 'high';
  static String rank = 'rank';
}

class ProductModel with ChangeNotifier {
  List<Product> products;
  FirebaseFirestore db = FirebaseFirestore.instance;
  b.User firebaseUser = b.FirebaseAuth.instance.currentUser;
  Map<String, dynamic> cosmeticsFilter;
  DocumentSnapshot lastReviewSnap;

  static Algolia algolia = const Algolia.init(
    applicationId: '50G6MO803G',
    apiKey: 'ab5eb7ec7552bb7865f3819a2b08f462',
  );

  //list products for products screen
  bool isEnd = false;
  int offset = 0;
  int limit = 80;
  String highToLow = '-sale_price';
  String lowToHigh = 'sale_price';
  bool isAscending = false;

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
        sortedProducts = sortByPrice(products, false);
        break;
      case 'rank':
        sortedProducts = sortBySkinType(skinTypeId, products);
        break;
      case 'low':
        sortedProducts = sortByPrice(products, true);
        break;
      default:
        sortedProducts = sortByAllRanking(products);
        break;
    }
    // print('products filtered : ${sortedProducts.length}');

    return sortedProducts;
  }

  List<Product> sortByPrice(List<Product> products, bool isAscending) {
    print('sorb y price : ${products.length}');
    products.sort((a, b) => isAscending
        ? b.salePrice.compareTo(a.salePrice)
        : a.salePrice.compareTo(b.salePrice));
    // print('rating: ${products[0].rating}');
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

  List<Product> sortByAllRanking(List<Product> products) {
    // var skinType = getSkinTypeById(skinTypeId);
    products.sort((a, b) => b.reviewMetas.all.rankingScore
        .compareTo(a.reviewMetas.all.rankingScore));

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

  @override
  Future<List<Review>> getReviewsByUserId(uid) async {
    final list = <Review>[];

    try {
      final query = FirebaseFirestore.instance
          .collection('reviews')
          .where('user.uid', isEqualTo: uid)
          .orderBy('created_at', descending: true);
      if (lastReviewSnap != null) {
        query.startAfterDocument(lastReviewSnap).limit(15);
      } else {
        query.limit(15);
      }

      final snapshot = await query.get(const GetOptions(source: Source.server));

      if (snapshot.docs.isNotEmpty) {
        print(snapshot.docs.length);
        for (final doc in snapshot.docs) {
          list.add(Review.fromJson(doc.data()));
        }
      } else {
        print('no products were found');

        // throw Exception('no products were found');
      }
    } catch (err) {
      rethrow;
    }
    return list;
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
          await query.get(const GetOptions(source: Source.cache));
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

  @override
  Future<void> uploadReview(reviewJson) async {
    try {
      final writeRes = await FirebaseFirestore.instance
          .collection('reviews')
          .add(reviewJson);

      if (writeRes.id != null) {
        print('review id: ${writeRes.id}');
        return;
      } else {
        throw Exception('failed to upload review');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  @override
  Future<Product> getProductById(id) async {
    try {
      final query = FirebaseFirestore.instance
          .collection('products')
          .where('sid', isEqualTo: id);

      var snapshot = await query.get(const GetOptions(source: Source.cache));
      print('fetching reviews from cache');

      if (snapshot.docs.isEmpty) {
        print('No Cached Reviews: fetching from server');
        snapshot = await query.get(const GetOptions(source: Source.server));
      }
      print(snapshot.docs.length);

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

  Future<List<Product>> getProductsByCategoryId(
      {categoryId, categoryField = 'third_category_id'}) async {
    try {
      List<Product> list = [];
      final productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category.${categoryField}', isEqualTo: categoryId)
          .limit(15)
          .get();
      print(productSnapshot.docs.length);

      if (productSnapshot.docs.isNotEmpty) {
        for (final doc in productSnapshot.docs) {
          // print(doc.data());q
          list.add(Product.fromJson(doc.data()));
        }
        // print('categoryId: $categoryId');
        return list;
      } else {
        return list;
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsBySearch({searchText}) async {
    try {
      final query = algolia.instance.index('cosmetics').search(searchText);

      List<Product> list = <Product>[];
      // Get Result/Objects
      final querySnap = await query.getObjects();
      final results = querySnap.hits;

      print('Hits count: ${querySnap.hits.length}');

      if (querySnap.hits.isEmpty) {
        return list;
      } else {
        results.forEach((item) {
          // print('item :${item.data}');
          list.add(Product.fromJson(item.data));
        });
        return list;
      }
    } catch (e) {
      print('Error: $e');

      rethrow;
    }
  }

  Future<List<Review>> getCosmeticsReviews(productId) async {
    final list = <Review>[];

    try {
      final query = FirebaseFirestore.instance
          .collection('reviews')
          .where('product_id', isEqualTo: productId)
          .orderBy('created_at');
      if (lastReviewSnap != null) {
        query.startAfterDocument(lastReviewSnap).limit(15);
      } else {
        query.limit(15);
      }

      var snapshot = await query.get(const GetOptions(source: Source.cache));
      print('fetching reviews from cache');

      if (snapshot.docs.isEmpty) {
        print('No Cached Reviews: fetching from server');
        snapshot = await query.get(const GetOptions(source: Source.server));
      }

      print(snapshot.docs.length);
      lastReviewSnap = snapshot.docs.last;

      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          list.add(Review.fromJson(doc.data()));
        }
        return list;
      } else {
        return list;
      }
    } catch (err) {
      // return list;

      print(err);
      return list;
    }
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
          isMatching = r.user.skinTypeId == 1;
          break;
        //dry
        case 2:
          isMatching = r.user.skinTypeId == 2;
          break;
        //oily
        case 3:
          isMatching = r.user.skinTypeId == 3;
          print(isMatching);
          break;
        default:
          print('default');
      }
      return isMatching;
    }).toList();
    print('reviews length:${reviews.length}');
    return reviews;
  }

  void showSubCategoryPage(ProductCategory category, String sortBy, context,
      {bool isNameAvailable}) {
    print('show subcate');
    print('cate id: ${category.firstCategoryName}');

    // for fetching beforehand

    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //         builder: (context) => SubCategoryScreen(category: category)));
  }

  Widget showProductList(
      {future,
      showFiler = false,
      showRank = false,
      disableScroll = false,
      isFromReviewPage = false,
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
          isFromReviewSearch: isFromReviewPage,
          disableScrolling: true,
          showRank: showRank,
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
}
