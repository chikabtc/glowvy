import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/skinScores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../generated/i18n.dart';
import '../address/address.dart';
import 'user.dart';

class UserModel with ChangeNotifier {
  UserModel();

  User user = User();
  bool isLoggedIn = b.FirebaseAuth.instance.currentUser != null;
  List<Review> reviews = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var firebaseUser = b.FirebaseAuth.instance.currentUser;
  final b.FirebaseAuth _auth = b.FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  DocumentSnapshot lastReviewSnap;

  Future<void> initData() async {
    listenToAuthStateUpdate();
    await getUser();
    if (firebaseUser != null && isLoggedIn) {
      await setReviewsByUserId(firebaseUser.uid);
    }
  }

  void listenToAuthStateUpdate() {
    _auth.authStateChanges().listen((b.User user) async {
      if (user == null) {
        isLoggedIn = false;
        firebaseUser = user;
        print('User is currently signed out!');
      } else {
        isLoggedIn = true;
        firebaseUser = user;
        print('User is signed in and auth changed!');
        await setReviewsByUserId(user.uid);
      }
    });
  }

  Future setReviewsByUserId(uid) async {
    print('fetching reviews user has written');
    final list = <Review>[];
    print('UID: ${uid}');

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
        reviews = list;
        await reloadUser();
      } else {
        print('no reviews were found');

        // throw Exception('no products were found');
      }
    } catch (err) {
      rethrow;
    }
    return;
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
    // var skinType
    if (baummanType.contains('D')) {}
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
    print('dw');
    if (firebaseUser != null) {
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
        reviews.insert(0, Review.fromJson(review));
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
      await _db.collection('users').doc(firebaseUser.uid).update({
        'picture':
            'http://storage.googleapis.com/glowvy-b6cf4.appspot.com/users/pictures/$filePath',
      });

      await reloadUser();
    } catch (e) {
      print('uploadProfilePicture: $e');
    }
  }

  Future uploadScreenshot(File file, {String path}) async {
    const profileImageBucketPath = 'feedbacks/screenshots/';

    try {
      final reference = _storage.ref().child(profileImageBucketPath + '$path');

      await reference.putFile(file);
      await _db.collection('users').doc(firebaseUser.uid).update({
        'picture':
            'http://storage.googleapis.com/glowvy-b6cf4.appspot.com/feedbacks/screenshots/$path',
      });

      await reloadUser();
    } catch (e) {
      print('uploadScreenshot: $e');
    }
  }

  // Future uploadProfilePicture(File file) async {
  //   const profileImageBucketPath = 'users/pictures/';
  //   final filePath = '${firebaseUser.uid}.jpg';

  //   try {
  //     final reference =
  //         _storage.ref().child(profileImageBucketPath + '$filePath');

  //     await reference.putFile(file);
  //     await _db.collection('users').doc(firebaseUser.uid).update({
  //       'picture':
  //           'http://storage.googleapis.com/glowvy-b6cf4.appspot.com/users/pictures/$filePath',
  //     });

  //     await reloadUser();
  //   } catch (e) {
  //     print('uploadProfilePicture: $e');
  //   }
  // }

  Future updateUserName(name) async {
    await _db.collection('users').doc(firebaseUser.uid).update({
      'full_name': name,
    });
  }

  Future updateUser({@required field, @required value}) async {
    await _db.collection('users').doc(firebaseUser.uid).update({
      field: value,
    });
    await reloadUser();
  }

  Future updateUserBirthyear(int year) async {
    await _db.collection('users').doc(firebaseUser.uid).update({
      'birth_year': year,
    });
    await reloadUser();
  }

  Future updateUserSkinType(String skinType) async {
    await _db.collection('users').doc(firebaseUser.uid).update(
        {'skin_type': skinType, 'skin_type_en': Tools.getEnSkinType(skinType)});
    await reloadUser();
  }

  Future updateUserGender(String gender) async {
    await _db.collection('users').doc(firebaseUser.uid).update({
      'gender': gender,
    });
    await reloadUser();
  }

  Future updateUserIssues(List<String> issues) async {
    await _db.collection('users').doc(firebaseUser.uid).update({
      'skin_issues': issues,
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
  Future updatePassword(oldPassword, password,
      {@required Function success, @required Function fail}) async {
    try {
      await firebaseUser.updatePassword(password);
      print('Succesfull changed password');
      await firebaseUser.reload();
      success();
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        //if recent login required
        //1. enter the password again get the credentials and reauthentiate in the
        var email = user.email;
        // await logout();
        final userCredential = await b.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: oldPassword);
        await firebaseUser.updatePassword(password);
        print('Succesfully changed password');
        await firebaseUser.reload();
      } else {
        fail(e.code);
      }
    }
  }

  Future getUser() async {
    try {
      print(isLoggedIn);
      if (isLoggedIn) {
        final query = _db.collection('users').doc(firebaseUser.uid);
        DocumentSnapshot doc;
        doc = await query.get(const GetOptions(source: Source.server));
        if (doc.exists) {
          user = User.fromJson(doc.data());
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future createUser(user) async {
    try {
      await _db.collection('users').doc(firebaseUser.uid).set({
        'full_name': user.fullName,
        'email': user.email,
        'uid': firebaseUser.uid,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'address': Address().toJson(),
      });
      await reloadUser();
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

  // keytool -list -v -keystore keystore_file_name.jks

  Future sendEmailVerification(email) async {
    await firebaseUser.verifyBeforeUpdateEmail(email);
  }

  Future sendPasswordResetEmail(email,
      {@required Function success, @required Function fail}) async {
    try {
      print('send');
      await _auth.sendPasswordResetEmail(email: email);
      success();
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('The code is invalid.');
        fail('Không tìm thấy email khả dụng');
      }
    }
  }

  // Future verifyPasswordReset(code) async {

  // }

  Future<User> registerWithEmail(
      {@required fullName,
      @required email,
      @required password,
      Function success,
      Function fail}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await firebaseUser.updateProfile(displayName: fullName);
      final user = User();
      user.fullName = fullName;
      user.email = email;
      await createUser(user);
      notifyListeners();
      success(user);
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        fail('Nhập mật khẩu tối thiểu 6 ký tự');
      } else if (e.code == 'email-already-in-use') {
        fail('Email này đã tồn tại');
      } else if (e.code == 'account-exists-with-different-credential') {
        fail(
            'An account already exists with the same email address but different sign-in');
      } else {
        print(e.code);
        fail(e.message);
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future signInWithEmail(
      {@required email,
      @required password,
      Function success,
      Function fail}) async {
    try {
      final userCredential = await b.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      firebaseUser = userCredential.user;
      print('uid: ${firebaseUser.uid}');
      final snap = await _db.collection('users').doc(firebaseUser.uid).get();
      if (snap.exists) {
        final userJson = snap.data();
        user = User.fromJson(userJson);
        notifyListeners();
        success(user);
      } else {
        fail("user data doesn't exist: ${firebaseUser.uid}");
      }
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        fail('Không tìm thấy email khả dụng.');
      } else if (e.code == 'wrong-password') {
        fail('Mật khẩu nhập không đúng');
      } else if (e.code == 'account-exists-with-different-credential') {
        fail(
            'An account already exists with the same email address but different sign-in');
      } else {
        print(e.code);
        fail(e.message);
      }
    }
    return null;
  }

  Future logout() async {
    user = User();
    reviews = [];
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

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
    return fullType;
  }

  Future loginFB({Function success, Function fail}) async {
    try {
      final result = await FacebookLogin().logIn(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final accessToken = result.accessToken;
          final facebookUserId = accessToken.userId;
          final facebookAuthCred =
              b.FacebookAuthProvider.credential(accessToken.token);

          final userCredential =
              await _auth.signInWithCredential(facebookAuthCred);
          firebaseUser = userCredential.user;

          // print(
          //     'user fb displayname: ${firebaseUser.displayName} and email :${firebaseUser.email}');
          final snap =
              await _db.collection('users').doc(firebaseUser.uid).get();

          //if the user exists, return the user
          if (snap.exists) {
            final userJson = snap.data();
            user = User.fromJson(userJson);
            notifyListeners();

            //if the user doesn't exist, create an user on firestore
          } else {
            user.facebookId = facebookUserId;
            await _db.collection('users').doc(firebaseUser.uid).set({
              'full_name': firebaseUser.displayName,
              'email': firebaseUser.email,
              'uid': firebaseUser.uid,
              'facebook_user_id': facebookUserId,
              'created_at': DateTime.now().millisecondsSinceEpoch,
              'address': Address().toJson(),
            });
          }
          await reloadUser();
          success(user);

          break;
        case FacebookLoginStatus.cancelledByUser:
          fail('The login is cancel');
          break;
        case FacebookLoginStatus.error:
          fail('Error: ${result.errorMessage}');
          break;
      }

      notifyListeners();
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        fail(
            'An account already exists with the same email address but different sign-in');
      } else {
        print(e.code);
        fail(e.message);
      }
    } catch (err) {
      // TODO(parker): translate the error msg into VN.
      fail(
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString());
    }
  }

  Future loginGoogle({Function success, Function fail}) async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser.authentication;

      final b.GoogleAuthCredential credential = b.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      firebaseUser = userCredential.user;
      final snap = await _db.collection('users').doc(firebaseUser.uid).get();

      //if the user exists, return the user
      if (snap.exists) {
        final userJson = snap.data();
        user = User.fromJson(userJson);
        //if the user doesn't exist, create an user on firestore
      } else {
        await _db.collection('users').doc(firebaseUser.uid).set({
          'full_name': firebaseUser.displayName,
          'email': firebaseUser.email,
          'uid': firebaseUser.uid,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'address': Address().toJson(),
        });
      }
      await reloadUser();

      success(user);
    } catch (err) {
      // TODO(parker): translate the error msg into VN.
      fail(
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString());
    }
  }

  void loginApple({Function success, Function fail}) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final credential = b.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      firebaseUser = userCredential.user;
      final snap = await _db.collection('users').doc(firebaseUser.uid).get();

      //if the user exists, return the user
      if (snap.exists) {
        final userJson = snap.data();
        user = User.fromJson(userJson);
        //if the user doesn't exist, create an user on firestore
      } else {
        await _db.collection('users').doc(firebaseUser.uid).set({
          'full_name': firebaseUser.displayName,
          'email': firebaseUser.email,
          'uid': firebaseUser.uid,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'address': Address().toJson(),
        });
      }
      await reloadUser();
      success(user);
    } catch (err) {
      //apple sign in is cancelled
      fail('Đăng nhập với Apple không thành công');
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
