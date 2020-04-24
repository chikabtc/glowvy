import '../address/address.dart';
import 'package:json_annotation/json_annotation.dart';
import '../address/billing.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  int id;
  bool loggedIn;
  // String name;
  String fullName;
  String email;
  String picture;
  String accessToken;
  Address address;
  Billing billing;
  User(this.id, this.loggedIn, this.fullName, this.email, this.picture,
      this.accessToken, this.address, this.billing);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.fromJsonEmail(Map<String, dynamic> json) {
    try {
      var user = User.fromJson(json["Account"]);

      // print("fromJsonEmail: $user");
      accessToken = json["AccessToken"];
      print("userFromJsonEmail accessToken: $accessToken");
      id = user.id;
      loggedIn = user.loggedIn;
      fullName = user.fullName;
      email = user.email;
      picture = user.picture;
      address = user.address;
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
      loggedIn = true;
      id = user['id'];
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
      address = json["Address"];
      var user = json['Account'];
      id = user['id'];
      fullName = user['full_name'];
      email = user['email'];
      address = user['address'];

      // picture = user['picture'];
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  String toString() =>
      'User { id: $id full_name: $fullName email: $email, accessToken: $accessToken}';
}
