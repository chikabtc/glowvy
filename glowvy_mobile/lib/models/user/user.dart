import '../address/address.dart';
import 'package:json_annotation/json_annotation.dart';
import '../address/billing.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  int id;
  // bool loggedIn;
  String displayName;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String picture;
  String skinType;
  int skinTypeId;
  int age;
  String accessToken;
  Address defaultAddress;
  List<Address> addresses = [];

  Billing billing;
  User(
      {this.id,
      // this.loggedIn,
      this.fullName,
      this.email,
      this.picture,
      this.skinType,
      this.accessToken,
      this.defaultAddress,
      this.billing});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.fromJsonEmail(Map<String, dynamic> json) {
    try {
      var user = User.fromJson(json["Account"]);
      accessToken = json["AccessToken"];
      id = user.id;
      // loggedIn = user.loggedIn;
      fullName = user.fullName;
      email = user.email;
      skinType = user.skinType;
      picture = user.picture;
      defaultAddress = user.defaultAddress;
      addresses = user.addresses;
    } catch (e) {
      print(e.toString());
    }
  }

  // from Dimodo Json
  //todo: user logins with FB and does something --> we have to create their account in
  //todo: our backend as well. We use accessToken as ID for each user.
  User.fromJsonFB(Map<String, dynamic> json) {
    try {
      accessToken = json['AccessToken'];

      var user = json['Account'];
      // loggedIn = true;
      id = user['id'];
      // skinType = user.skinType;

      fullName = user["full_name"];
      email = user["email"];
      // picture = user["picture"]['data']['url'] ?? '';
    } catch (e) {
      print(e.toString());
    }
  }

  User.fromJsonGoogle(Map<String, dynamic> json) {
    try {
      accessToken = json['AccessToken'];
      skinType = skinType;

      var user = json['Account'];
      id = json['id'];
      fullName = user["full_name"];
      email = user["email"];
      // picture = user["picture"]['data']['url'] ?? '';
    } catch (e) {
      print(e.toString());
    }
  }

  User.fromLocalJson(Map<String, dynamic> json) {
    try {
      // print("fromLocalJsonUser: $json");
      accessToken = json['access_token'];
      var user = json['Account'];
      id = user['id'];
      fullName = user['full_name'];
      email = user['email'];
      defaultAddress = user['address'];
      addresses = user['addresses'];
      skinType = user.skinType;

      // picture = user['picture'];
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  String toString() =>
      'User { id: $id full_name: $fullName email: $email, accessToken: $accessToken}, skinType: $skinType';
}
