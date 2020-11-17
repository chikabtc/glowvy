import 'dart:io';

import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/skinScores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/i18n.dart';
import '../address/address.dart';
import 'user.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    //todo: make the init functions synchronosu
    initData();
  }

  User user = User();
  bool isLoggedIn = b.FirebaseAuth.instance.currentUser != null;
  List<Review> reviews = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var firebaseUser = b.FirebaseAuth.instance.currentUser;
  final b.FirebaseAuth _auth = b.FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> initData() async {
    listenToAuthStateUpdate();
    await getUser();
  }

  void setName(String firstName, lastName) {
    if (user != null) {
      user.firstName = firstName;
      user.lastName = lastName;
      user.fullName = firstName + ' ' + lastName;
    }
  }

  Future saveBaumannResults(
      String baummanType, SkinScores baumannScores) async {
    try {
      await _db.collection('users').doc(firebaseUser.uid).update({
        'baumann_type': baummanType,
        'baumann_scores': baumannScores.toJson()
      });
      await reloadUser();
    } catch (e) {
      print('saveSkinType e: $e');
    }
  }

  Future discardReviewDraft() async {
    try {
      user.reviewDraft = null;
      await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .update({'review_draft': FieldValue.delete()});
      await reloadUser();
    } catch (e) {
      print('discardReviewDraft e: $e');
    }
  }

  Future saveDraft(Review review) async {
    try {
      user.reviewDraft = review;
      await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .update({'review_draft': review.toJson()});
      await reloadUser();
      return;
    } catch (e) {
      throw 'discardReviewDraft e: $e';
    }
  }

  void setProductInReview(Product product) {
    user.reviewDraft ??= Review();
    user.reviewDraft.product = product;
    notifyListeners();
  }

  Future uploadReview(review) async {
    try {
      final writeRes = await _db.collection('reviews').add(review);
      if (writeRes.id != null) {
        print('review id: ${writeRes.id}');
        reviews.add(Review.fromJson(review));
        await discardReviewDraft();
        await reloadUser();
      } else {
        throw 'failed to upload review';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future reloadUser() async {
    if (isLoggedIn) {
      final query = _db.collection('users').doc(firebaseUser.uid);
      DocumentSnapshot doc;
      doc = await query.get(const GetOptions(source: Source.cache));
      if (!doc.exists) {
        doc = await query.get(const GetOptions(source: Source.server));
        print('No cached ingredients: fetching from server');
      }
      user = User.fromJson(doc.data());
      notifyListeners();
    }
  }

  Future uploadProfilePicture(File file) async {
    const profileImageBucketPath = 'users/pictures/';
    final filePath = '${firebaseUser.uid}.jpg';

    try {
      final reference =
          _storage.ref().child(profileImageBucketPath + '$filePath');

      await reference.putFile(file);

      // await _db.collection('users').doc(firebaseUser.uid).update({
      //   'picture':
      //       'http://storage.googleapis.com/glowvy-b6cf4.appspot.com/users/pictures/$filePath',
      // });
      await reloadUser();
    } catch (e) {
      print('uploadProfilePicture: $e');
    }
  }

  Future updateUser({@required field, @required value}) async {
    await _db.collection('users').doc(firebaseUser.uid).update({
      field: value,
    });
    await reloadUser();
  }

  Future updateEmail(email) async {
    try {
      await _db.collection('users').doc(firebaseUser.uid).update({
        'email': email,
      });
      await firebaseUser.updateEmail(email);
    } on b.FirebaseAuthException catch (e) {
      print('Failed with eor code: ${e.code}');
      rethrow;
    } on PlatformException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
    await reloadUser();
  }

  //skinScore is json object
  Future updatePassword(password) async {
    await firebaseUser.updatePassword(password);
    print('Succesfull changed password');
    await firebaseUser.reload();
  }

  void listenToAuthStateUpdate() {
    _auth.authStateChanges().listen((b.User user) {
      if (user == null) {
        isLoggedIn = false;
        print('User is currently signed out!');
      } else {
        isLoggedIn = true;
        print('User is signed in and auth changed!');
      }
    });
  }

  Future getUser() async {
    try {
      if (isLoggedIn) {
        final query = _db.collection('users').doc(firebaseUser.uid);
        DocumentSnapshot doc;
        doc = await query.get(const GetOptions(source: Source.cache));
        print('user doc ${doc.data()}');
        if (!doc.exists) {
          print("user doesn't exist");
          doc = await query.get(const GetOptions(source: Source.server));
          print('No cached ingredients: fetching from server');
        }
        user = User.fromJson(doc.data());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future createUser() async {
    try {
      await _db.collection('users').doc(firebaseUser.uid).set({
        'full_name': user.fullName,
        'email': user.email,
        'uid': firebaseUser.uid,
        'created_at': FieldValue.serverTimestamp(),
        'address': Address(),
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      if (firebaseUser.emailVerified) {
        // await reload();
        return true;
      } else {
        return false;
      }
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
        //delete the user
        await firebaseUser.delete();
      }
      throw e.toString();
    }
  }

  Future sendEmailVerification(email) async {
    await firebaseUser.verifyBeforeUpdateEmail(email);
  }

  Future<User> signup({fullName, email, password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(email);

      final user = User();
      notifyListeners();
      return user;
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<User> loginWithEmail({email, password}) async {
    try {
      final userCredential = await b.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      firebaseUser = userCredential.user;
      final snap = await _db
          .collection('users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .get();
      if (snap.docs.isNotEmpty) {
        final userJson = snap.docs[0].data();
        user = User.fromJson(userJson);
        notifyListeners();
        return user;
      } else {
        throw "user data doesn't exist: ${firebaseUser.uid}";
      }
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user';
      }
    }
    return null;
  }

  Future logout() async {
    user = User();
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  // Future<bool> setUserSkinType({String skinType, BuildContext context}) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     cosmeticPref = skinType;
  //     // prefs.getString(cosmetics_type)

  //     await prefs.setString('skin_type', skinType);
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  String getFullSkinType(context, String type) {
    var fullType = '';
    print('type: $type');
    if (type.contains('S')) {
      fullType += S.of(context).sensitive;
    } else if (type.contains('O')) {
      fullType += S.of(context).oily;
    } else if (type.contains('D')) {
      fullType += S.of(context).dry;
    }
    // if (type.contains('P')) {
    //   fullType += S.of(context).pigmented ;
    // }
    // if (type.contains('N')) {
    //   fullType += S.of(context).nonPigmented ;
    // }
    // if (type.contains('W')) {
    //   fullType += S.of(context).wrinkled ;
    // }
    // if (type[3] == 'T') {
    //   fullType += S.of(context).tight ;
    // }
    // if (type.contains('S')) {
    //   fullType += S.of(context).sensitive ;
    // }
    // if (type.contains('R')) {
    //   fullType += S.of(context).resistant ;
    // }
    return fullType;
  }
}
