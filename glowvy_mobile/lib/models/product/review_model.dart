import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListPreferences {
  //filter options
  List<String> genders = [];
  String skinType;
  List<String> skinIssues = [];
  List<String> ageGroups = [];
  // sort options
  String orderBy;
  bool isDescending;

  ListPreferences(
      {@required this.genders,
      @required this.skinType,
      @required this.skinIssues,
      @required this.orderBy,
      @required this.isDescending,
      @required this.ageGroups});

  bool isOptionEmpty() {
    return (genders.isEmpty &&
        ageGroups.isEmpty &&
        skinType == '' &&
        skinIssues.isEmpty);
  }

  static ListPreferences init() {
    return ListPreferences(
        genders: [],
        skinIssues: [],
        skinType: '',
        ageGroups: [],
        orderBy: 'created_at',
        isDescending: false);
  }
}

class ReviewModel with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  b.User firebaseUser = b.FirebaseAuth.instance.currentUser;
  // TODO(parker): add all the filter options here and make them immutable
  DocumentSnapshot lastReviewSnap;

  List<Review> filter(List<Review> reviews, {ListPreferences listPreferences}) {
    // print('filter option: ${reviews.length}');
    //gotta save the filter parameters
    var filteredReviews = reviews;
    if (listPreferences.genders.isNotEmpty) {
      filteredReviews = filteredReviews.where((i) {
        if (listPreferences.genders.contains(i.user.gender)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (listPreferences.ageGroups.isNotEmpty) {
      filteredReviews = filteredReviews.where((i) {
        if (listPreferences.ageGroups
            .contains(Tools.getUserAgeGroup(i.user.birthYear))) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (listPreferences.skinType.isNotEmpty) {
      filteredReviews = filteredReviews.where((i) {
        if (listPreferences.skinType.contains(i.user.skinType)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (listPreferences.skinIssues.isNotEmpty) {
      filteredReviews = filteredReviews.where((i) {
        if (i.user.skinIssues == listPreferences.skinIssues) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    if (listPreferences.isOptionEmpty()) {
      // print('option empty dayo');
    }

    // print('products filtered : ${sortedProducts.length}');

    return listPreferences.isOptionEmpty() ? reviews : filteredReviews;
    //
  }

  ListPreferences getUserSkinFilter(User user) {
    final options = ListPreferences(
        ageGroups: [Tools.getUserAgeGroup(user.birthYear)],
        genders: [user.gender],
        skinType: user.skinType,
        orderBy: 'created_at',
        isDescending: false,
        skinIssues: user.skinIssues);
    return options;
  }

  void clearPaginationHistory() {
    print('cleared review pagination');
    lastReviewSnap = null;
  }

  Future<ListPage<Review>> getProductReviews(productId,
      {ListPreferences listPreferences}) async {
    var listPage = ListPage(grandTotalCount: 0, itemList: <Review>[]);
    final list = <Review>[];

    listPreferences ??= ListPreferences.init();
    var query = FirebaseFirestore.instance
        .collection('reviews')
        .where('product.sid', isEqualTo: productId);

    if (listPreferences.ageGroups.isNotEmpty) {
      var minAge;
      var maxAge = 1000;

      if (listPreferences.ageGroups.contains('dưới 20')) {
        minAge = 0;
      }
      if (listPreferences.ageGroups.contains('từ 20 đến 24')) {
        minAge ??= 20;
        maxAge = 24;
      }
      if (listPreferences.ageGroups.contains('từ 25 đến 29')) {
        minAge ??= 25;
        maxAge = 29;
      }
      if (listPreferences.ageGroups.contains('từ 30 đến 34')) {
        minAge ??= 30;
        maxAge = 34;
      }
      if (listPreferences.ageGroups.contains('từ 35')) {
        maxAge = 1000;
      }
      query = query.where('user.age', isGreaterThanOrEqualTo: minAge);
      query = query.where('user.age', isLessThanOrEqualTo: maxAge);
      query = query.orderBy('user.age', descending: true);

      //The initial orderBy() field '[[FieldPath([created_at]), false]][0][0]' has to be the same as the where() field parameter 'FieldPath([user, age])' when an inequality operator is invoked.
    }
    if (listPreferences.skinType.isNotEmpty) {
      print('fiters type');
      query =
          query.where('user.skin_type', isEqualTo: listPreferences.skinType);
    }
    //make skin type singular
    if (listPreferences.genders.isNotEmpty &&
        listPreferences.genders.length != 2) {
      print('fiters gender');

      query =
          query.where('user.gender', isEqualTo: listPreferences.genders.first);
    }

    if (listPreferences.skinIssues.isNotEmpty) {
      print('fiters skinissue');

      query = query.where('user.skin_issues',
          arrayContainsAny: listPreferences.skinIssues);
    }
    if (lastReviewSnap == null) {
      print('fiters order by');

      query = query.limit(10);
    } else {
      // TODO(parker): the orderBy is applied twice because of the startAfterDocument
      print('dsd');

      query = query
          .orderBy(listPreferences.orderBy,
              descending: listPreferences.isDescending ?? false)
          .startAfterDocument(lastReviewSnap)
          .limit(10);
    }

    try {
      var snapshot = await query.get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) {
        print('No cached reviews: fetching from server');
        snapshot = await query.get(const GetOptions(source: Source.server));
      }

      print('review count: ${snapshot.docs.length}');
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
      print(err);
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
    // print('reviews length:${reviews.length}');
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
