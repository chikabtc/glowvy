import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/skinScores.dart';
import 'package:json_annotation/json_annotation.dart';

import '../address/address.dart';
import '../address/billing.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class User {
  String uid;
  String facebookId;
  String displayName;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String picture;
  String gender;
  String skinType;
  List<String> skinIssues;
  String baumannType;
  SkinScores baumannScores;
  int skinTypeId;
  int birthYear;
  int age;
  Address address;
  int createdAt;
  List<Address> addresses = [];
  List<Product> recentSearchItems = [];
  List<String> recentSearchQueries;
  Review reviewDraft;

  Billing billing;
  User(
      {this.fullName,
      this.email,
      this.picture,
      this.facebookId,
      this.skinType,
      this.skinIssues,
      this.birthYear,
      this.gender,
      this.createdAt,
      this.recentSearchItems,
      this.address,
      this.recentSearchQueries,
      this.billing});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // User.fromJsonEmail(Map<String, dynamic> json) {
  //   try {
  //     var user = User.fromJson(json['Account']);
  //     // accessToken = json['AccessToken'];
  //     // id = user.id;
  //     // loggedIn = user.loggedIn;
  //     fullName = user.fullName;
  //     email = user.email;
  //     skinType = user.skinType;
  //     picture = user.picture;
  //     defaultAddress = user.defaultAddress;
  //     addresses = user.addresses;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // // from Dimodo Json
  // //todo: user logins with FB and does something --> we have to create their account in
  // //todo: our backend as well. We use accessToken as ID for each user.
  // User.fromJsonFB(Map<String, dynamic> json) {
  //   try {
  //     accessToken = json['AccessToken'];

  //     var user = json['Account'];
  //     // loggedIn = true;
  //     id = user['id'];
  //     // skinType = user.skinType;

  //     fullName = user['full_name'];
  //     email = user['email'];
  //     // picture = user['picture']['data']['url'] ?? '';
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // User.fromJsonGoogle(Map<String, dynamic> json) {
  //   try {
  //     accessToken = json['AccessToken'];
  //     skinType = skinType;

  //     var user = json['Account'];
  //     id = json['id'];
  //     fullName = user['full_name'];
  //     email = user['email'];
  //     // picture = user['picture']['data']['url'] ?? '';
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // User.fromLocalJson(Map<String, dynamic> json) {
  //   try {
  //     // print('fromLocalJsonUser: $json');
  //     accessToken = json['access_token'];
  //     var user = json['Account'];
  //     id = user['id'];
  //     fullName = user['full_name'];
  //     email = user['email'];
  //     defaultAddress = user['address'];
  //     addresses = user['addresses'];
  //     skinType = user.skinType;

  //     // picture = user['picture'];
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  String toString() =>
      'User {full_name: $fullName email: $email, accessToken: $uid}, skinType: $skinType';
}
