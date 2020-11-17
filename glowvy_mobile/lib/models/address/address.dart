import 'package:Dimodo/models/address/district.dart';
import 'package:Dimodo/models/address/province.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';

import 'ward.dart';

part 'address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Address {
  Address({
    this.recipientName,
    this.street,
    this.ward,
    this.phoneNumber,
    this.isDefault,
  });

  int id;
  String recipientName;
  String street;
  String phoneNumber;

  Ward ward;
  District district;
  Province province;

  bool isDefault;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  bool isValid() {
    return recipientName.isNotEmpty &&
        street.isNotEmpty &&
        ward != null &&
        phoneNumber != null;
  }

  void saveAddress() async {
    final storage = LocalStorage('Shipping');
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem('', toJson());
      }
    } catch (err) {
      print(err);
    }
  }
}
