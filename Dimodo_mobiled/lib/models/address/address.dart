import 'package:localstorage/localstorage.dart';
import 'ward.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Address {
  String recipientName;
  String street;
  Ward ward;
  String phoneNumber;

  Address({
    this.recipientName,
    this.street,
    this.ward,
    this.phoneNumber,
  });

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
    final LocalStorage storage = new LocalStorage("Shipping");
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem('', this.toJson());
      }
    } catch (err) {
      print(err);
    }
  }
}
