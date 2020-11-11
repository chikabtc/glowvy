import 'dart:io';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/skinScores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../common/constants.dart';
import '../../services/index.dart';
import 'user.dart';
import '../address/address.dart';
import '../../generated/i18n.dart';
import 'package:firebase_auth/firebase_auth.dart' as b;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserModel with ChangeNotifier {
  UserModel() {
    //todo: make the init functions synchronosu
    initData();
  }

  FirebaseFirestore db;
  Services _service = Services();
  User user = User();
  bool isLoggedIn = false;
  bool loading = false;
  String cosmeticPref;
  SkinScores skinScores;
  String ageGroup;
  List<Review> reviews = [];
  firebase_storage.FirebaseStorage _storage;
  String profileImageBucketPath = 'users/pictures/';

  Future<void> initData() async {
    db = FirebaseFirestore.instance;
    _storage = firebase_storage.FirebaseStorage.instance;

    await getUser();
    await listenToAuthStateUpdate();
    await getSkinScores();
  }

  void setName(String firstName, lastName) {
    if (this.user != null) {
      this.user.firstName = firstName;
      this.user.lastName = lastName;
      this.user.fullName = firstName + " " + lastName;
    }
  }

  void saveSkinType(String skinType, SkinScores skinScores) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'skin_type': skinType, 'skin_scores': skinScores.toJson()});
      this.user.skinType = skinType;
      this.user.skinScores = skinScores;
    } catch (err) {
      print("saveSkinType err: $err");
    }
  }

  Future discardReviewDraft() async {
    try {
      user.reviewDraft = null;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'review_draft': FieldValue.delete()});
      await reloadUser();
    } catch (err) {
      print("discardReviewDraft err: $err");
    }
  }

  Future saveDraft(Review review) async {
    try {
      user.reviewDraft = review;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'review_draft': review.toJson()});
      await reloadUser();
      return;
    } catch (err) {
      print("discardReviewDraft err: $err");
    }
  }

  void setProductInReview(Product product) {
    if (user.reviewDraft == null) {
      user.reviewDraft = Review();
    }
    this.user.reviewDraft.product = product;
    notifyListeners();
  }

  Future uploadReview(review) async {
    try {
      var writeRes =
          await FirebaseFirestore.instance.collection('reviews').add(review);
      if (writeRes.id != null) {
        print('review id: ${writeRes.id}');
        reviews.add(Review.fromJson(review));
        await discardReviewDraft();
        reloadUser();
        return;
      } else {
        throw Exception("failed to upload review");
      }
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  Future reloadUser() async {
    var newUserSnap = await db
        .collection('users')
        .doc(user.uid)
        .get(GetOptions(source: Source.cache));
    user = User.fromJson(newUserSnap.data());
    print(newUserSnap.data());
    notifyListeners();
    return;
  }

  Future uploadProfilePicture(File file) async {
    String filePath = '${user.uid}.jpg';

    try {
      firebase_storage.Reference reference =
          _storage.ref().child(profileImageBucketPath + '$filePath');

      await reference.putFile(file);

      await db.collection('users').doc(user.uid).update({
        'picture':
            'http://storage.googleapis.com/glowvy-b6cf4.appspot.com/users/pictures/$filePath',
      });
      await reloadUser();
    } catch (e) {
      print("uploadProfilePicture: $e");
    }

    // success("successfully updated user name");
    return;
  }

  Future updateUser({@required field, @required value}) async {
    await db.collection('users').doc(user.uid).update({
      field: value,
    });
    await reloadUser();
    return;
  }

  Future updateEmail(email) async {
    try {
      var firebaseUser = b.FirebaseAuth.instance.currentUser;
      await db.collection('users').doc(user.uid).update({
        'email': email,
      });
      await firebaseUser.updateEmail(email);
    } on b.FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      throw (e);
    } on PlatformException catch (e) {
      throw (e);
      // Handle err
    } catch (e) {
      throw (e);
    }
    await reloadUser();
    return;
  }

  void loginFB({Function success, Function fail}) async {
    try {
      final FacebookLoginResult result =
          await FacebookLogin().logIn(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          //TODO: return error if the user logging with FB fails
          user = await _service.loginFacebook(token: accessToken.token);
          // user.address = await _service.getAddress(token: user.accessToken)``
          print('accessToken$accessToken');

          // saveUser(user);
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
    } catch (err) {
      fail("Fail to login with FB: " + err.toString());
    }
  }

  void loginGoogle({Function success, Function fail}) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      GoogleSignInAccount res = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth = await res.authentication;
      var token = auth.accessToken;
      print('google accessToken: $token');

      user = await _service.loginGoogle(token: auth.accessToken);

      print("lgogogo: ${user.toJson()}");
      // saveUser(user);
      success(user);
      notifyListeners();
    } catch (err) {
      print("Canceled Google Sign in: $err");
      fail("Canceled Google Sign in: $err");
    }
  }

  void loginApple({Function success, Function fail}) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'app.dimodo.iOS',
          redirectUri: Uri.parse(
            'https://glowvy.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
      );
      print("credential: ${credential}");
      var fullName = "";
      if (credential.givenName != null && credential.familyName != null) {
        fullName = credential.givenName + " " + credential.familyName;
      }
      // print("session: $session");

      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
      // after they have been validated with Apple (see `Integration` section for more information on how to do thi
      user = await _service.loginApple(credential.authorizationCode, fullName);

      print("lgogogo: ${user.toJson()}");
      // saveUser(user);
      success(user);
      notifyListeners();
    } catch (err) {
      print("Canceled Apple Sign in: $err");
      fail("Canceled Apple Sign in: $err");
    }
  }

  //skinScore is json object
  Future updatePassword(password) async {
    b.User user = b.FirebaseAuth.instance.currentUser;
    await user.updatePassword(password);
    print("Succesfull changed password");
    user.reload();
  }

  listenToAuthStateUpdate() {
    b.FirebaseAuth.instance.authStateChanges().listen((b.User user) {
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
    var firebaseUser = b.FirebaseAuth.instance.currentUser;
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .get(GetOptions(source: Source.cache));
      if (snap.docs.isNotEmpty) {
        var userJson = snap.docs[0].data();
        this.user = User.fromJson(userJson);
      }
    } catch (err) {
      print(err);
    }
  }

  Future getSkinScores() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem(kLocalKey["skinScores"]);
        if (json != null) {
          print("skinScoreJson: $json");
          skinScores = SkinScores.fromJson(json);
          notifyListeners();
        } else {
          print("fail to get users");
        }
      }
    } catch (err) {
      print(err);
    }
  }

  Future createUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'full_name': user.fullName,
        'email': user.email,
        'uid': user.uid,
        'created_at': FieldValue.serverTimestamp(),
        'address': Address(),
      });
    } catch (e) {}
  }

  Future<bool> isEmailVerified() async {
    var user = b.FirebaseAuth.instance.currentUser;

    b.FirebaseAuth auth = b.FirebaseAuth.instance;
    user = auth.currentUser;
    try {
      if (user.emailVerified) {
        // await reload();
        return true;
      } else {
        return false;
      }
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
        //delete the user
        await b.FirebaseAuth.instance.currentUser.delete();
      }
      throw (e.toString());
    }
  }

  Future sendEmailVerification(email) async {
    var firebaseUser = b.FirebaseAuth.instance.currentUser;
    await firebaseUser.verifyBeforeUpdateEmail(email);
  }

  Future<User> signup({fullName, email, password}) async {
    b.FirebaseAuth auth = b.FirebaseAuth.instance;

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(email);

      var user = User();
      notifyListeners();
      return user;
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      }
    } catch (e) {
      loading = false;
      throw (e.toString());
      // throw Exception(e);
    }
    return null;
  }

  Future<User> loginWithEmail({email, password}) async {
    try {
      b.UserCredential userCredential = await b.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var firebaseUser = userCredential.user;
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .get();
      if (snap.docs.isNotEmpty) {
        var userJson = snap.docs[0].data();
        this.user = User.fromJson(userJson);
        notifyListeners();
        return user;
      } else {
        throw ("user data doesn't exist: ${firebaseUser.uid}");
      }
    } on b.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future logout() async {
    user = User();
    try {
      await b.FirebaseAuth.instance.signOut();
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
  // void logout() async {
  //   user = null;
  //   isLoggedIn = false;
  //   try {
  //     final ready = await kLocalStorage.ready;
  //     if (ready) {
  //       await kLocalStorage.deleteItem(kLocalKey["userInfo"]);
  //       await kLocalStorage.deleteItem(kLocalKey["shippingAddress"]);
  //       await kLocalStorage.deleteItem(kLocalKey["recentSearches"]);
  //       await kLocalStorage.deleteItem(kLocalKey["wishlist"]);
  //       await kLocalStorage.deleteItem(kLocalKey["opencart_accessToken"]);

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setBool('loggedIn', false);
  //     }
  //   } catch (err) {
  //     print(err);
  //   }
  //   notifyListeners();
  // }

  Future<bool> isLogin() async {
    final LocalStorage storage = new LocalStorage("Dimodo");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem(kLocalKey["userInfo"]);
        return json != null;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  // bool isLoggedIn() {
  //   b.FirebaseAuth.instance.currentUser.reload();
  //   return b.FirebaseAuth.instance.currentUser == null ? false : true;
  // }

  void updateAddress(
      {Address address, String token, Function success, Function fail}) async {
    try {
      var returnedAddress = await _service.updateAddress(address: address);
      if (address.isDefault) {
        user.addresses.forEach((element) {
          if (element != address) {
            element.isDefault = false;
          }
          user.address = address;
        });
      }
      var originalIndex = this.user.addresses.indexOf(address, 0);
      this.user.addresses[originalIndex] = address;

      success(true);
      notifyListeners();
    } catch (err) {
      fail("Fail to update address: " + err.toString());
      notifyListeners();
    }
  }

  void createAddress({Address address, Function success, Function fail}) async {
    try {
      var returnedAddress = await _service.createAddress(address: address);
      if (user.addresses == null) {
        user.addresses = [];
      }
      this.user.addresses.add(address);
      if (address.isDefault) {
        user.addresses.forEach((element) {
          if (element != address) {
            element.isDefault = false;
          }
          user.address = address;
        });
      }
      address.id = returnedAddress.id;

      success(true);

      notifyListeners();
    } catch (err) {
      fail("Fail to create address:  " + err.toString());
      notifyListeners();
    }
  }

  void deleteAddress({Address address, Function success, Function fail}) async {
    try {
      var isSuccess = await _service.deleteAddress(address: address);
      user.addresses.remove(address);

      success(isSuccess);

      notifyListeners();
    } catch (err) {
      fail("Fail to delete address: " + err.toString());
      notifyListeners();
    }
  }

  Future<bool> setUserSkinType({String skinType, BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cosmeticPref = skinType;
      // prefs.getString(cosmetics_type)

      await prefs.setString("skin_type", skinType);
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<String> getUserCosmeticsTypesPref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      cosmeticPref = prefs.getString("cosmetics_type");

      return cosmeticPref;
    } catch (err) {
      return err.toString();
    }
  }

  // Future<String> getSkinTypePref() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();

  //     skinType = prefs.getString("skin_type");

  //     return cosmeticPref;
  //   } catch (err) {
  //     return err.toString();
  //   }
  // }

  Future<String> getUserAgePref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ageGroup = prefs.getString("age_group");
      // prefs.getString(cosmetics_type)

      return ageGroup;
    } catch (err) {
      return err.toString();
    }
  }

  Future<bool> setUserAgeGroup({String ageGroup, BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ageGroup = ageGroup;

      await prefs.setString("age_group", ageGroup);
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  String getFullSkinType(context, String type) {
    String fullType = "";
    print("type: $type");
    if (type.contains("S")) {
      fullType += S.of(context).sensitive;
    } else if (type.contains("O")) {
      fullType += S.of(context).oily;
    } else if (type.contains("D")) {
      fullType += S.of(context).dry;
    }
    // if (type.contains("P")) {
    //   fullType += S.of(context).pigmented ;
    // }
    // if (type.contains("N")) {
    //   fullType += S.of(context).nonPigmented ;
    // }
    // if (type.contains("W")) {
    //   fullType += S.of(context).wrinkled ;
    // }
    // if (type[3] == "T") {
    //   fullType += S.of(context).tight ;
    // }
    // if (type.contains("S")) {
    //   fullType += S.of(context).sensitive ;
    // }
    // if (type.contains("R")) {
    //   fullType += S.of(context).resistant ;
    // }
    return fullType;
  }
}
