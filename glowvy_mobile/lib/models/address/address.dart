import 'package:localstorage/localstorage.dart';
import 'ward.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Address {
  int id;
  String recipientName;
  String street;
  Ward ward;
  int wardId;
  String phoneNumber;
  bool isDefault;

  Address({
    this.recipientName,
    this.street,
    this.ward,
    this.phoneNumber,
    this.isDefault,
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
