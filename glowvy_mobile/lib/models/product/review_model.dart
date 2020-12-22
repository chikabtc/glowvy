import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterOptions {
  List<String> genders = [];
  List<String> skinTypes = [];
  List<String> skinIssues = [];
  List<String> ageGroups = [];
  // int age;

  FilterOptions(
      {@required this.genders,
      @required this.skinTypes,
      @required this.skinIssues,
      @required this.ageGroups});

  bool isOptionEmpty() {
    return (this.genders.isEmpty &&
        this.ageGroups.isEmpty &&
        this.skinTypes.isEmpty &&
        this.skinIssues.isEmpty);
  }
}

class ReviewModel with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  b.User firebaseUser = b.FirebaseAuth.instance.currentUser;
  // TODO(parker): add all the filter options here and make them immutable
  DocumentSnapshot lastReviewSnap;

  List<Review> filter(List<Review> reviews, FilterOptions filterOptions) {
    //gotta save the filter parameters
    var filteredReviews = <Review>[];
    print('reviews! ${reviews.length}');
    if (filterOptions.genders.isNotEmpty) {
      print('gender option');
      filteredReviews = reviews.where((i) {
        if (filterOptions.genders.contains(i.user.gender)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (filterOptions.ageGroups.isNotEmpty) {
      print('ageGroup option');

      filteredReviews = reviews.where((i) {
        if (filterOptions.ageGroups
            .contains(Tools.getUserAgeGroup(i.user.birthYear))) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (filterOptions.skinTypes.isNotEmpty) {
      print('skintype option');

      filteredReviews = reviews.where((i) {
        if (filterOptions.skinTypes.contains(i.user.skinType)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (filterOptions.skinIssues.isNotEmpty) {
      print('skintype option');

      filteredReviews = reviews.where((i) {
        if (i.user.skinIssues == filterOptions.skinIssues) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (filterOptions.isOptionEmpty()) {
      print('option empty dayo');
    }

    return filterOptions.isOptionEmpty() ? reviews : filteredReviews;
    //
  }

  FilterOptions getUserSkinFilter(User user) {
    final options = FilterOptions(
        ageGroups: [Tools.getUserAgeGroup(user.age)],
        genders: [user.gender],
        skinTypes: [user.skinType],
        skinIssues: user.skinIssues);
    return options;
  }

  void clearPaginationHistory() {
    lastReviewSnap = null;
  }

  Future<ListPage<Review>> getCosmeticsReviews(productId) async {
    var listPage = ListPage(grandTotalCount: 0, itemList: <Review>[]);
    final list = <Review>[];

    try {
      var query;
      if (lastReviewSnap != null) {
        print('lastReviewSnap exists');
        query = FirebaseFirestore.instance
            .collection('reviews')
            .where('product.sid', isEqualTo: productId)
            .orderBy('created_at')
            .startAfterDocument(lastReviewSnap)
            .limit(15);
      } else {
        query = FirebaseFirestore.instance
            .collection('reviews')
            .where('product.sid', isEqualTo: productId)
            .orderBy('created_at')
            .limit(15);
      }

      var snapshot = await query.get(const GetOptions(source: Source.cache));
      print('fetching reviews from cache');

      if (snapshot.docs.isEmpty) {
        print('No Cached Reviews: fetching from server');
        snapshot = await query.get(const GetOptions(source: Source.server));
      }

      print('review length: ${snapshot.docs.length}');
      if (snapshot.docs.isNotEmpty) {
        lastReviewSnap = snapshot.docs.last;

        for (final doc in snapshot.docs) {
          list.add(Review.fromJson(doc.data()));
        }
        listPage.itemList = list;
        listPage.grandTotalCount = 0;
      }
      return listPage;
    } catch (err) {
      throw (err);
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
}
