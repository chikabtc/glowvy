import 'package:Dimodo/services/index.dart';
import 'package:flutter/material.dart';
import 'ward.dart';
import 'district.dart';
import 'province.dart';
import 'address.dart';

class AddressModel with ChangeNotifier {
  //todo: turn this single address to a list of address.
  Address address;
  List<Province> provinces;
  List<District> districts;
  List<Ward> wards;
  Services _service = Services();

  AddressModel() {
    getProvincess();
  }
  void getProvincess() async {
    provinces = await _service.getProvinces();
  }

  Future<List<District>> getDistricts({int provinceId}) async {
    // print("")
    return await _service.getDistricts(provinceId: provinceId);
  }

  Future<List<Ward>> getWards({int districtId}) async {
    return await _service.getWards(districtId: districtId);
  }
}
