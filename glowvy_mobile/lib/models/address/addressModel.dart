import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/services/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ward.dart';
import 'district.dart';
import 'province.dart';
import 'address.dart';
import 'dart:convert' as convert;

class AddressModel with ChangeNotifier {
  //todo: turn this single address to a list of address.
  Address address;
  List<Province> provinces = [];
  List<District> districts = [];
  List<Ward> wards = [];
  Services _service = Services();

  AddressModel() {}
  Future getProvincess() async {
    try {
      print("fail to getProvinces");
      String provincePath = "lib/common/provinces.json";
      final provinceJsonString = await rootBundle.loadString(provincePath);
      final provincesJson = convert.jsonDecode(provinceJsonString);
      for (var json in provincesJson) {
        provinces.add(Province.fromJson(json));
      }
    } catch (e) {
      print('fail to getProvinces: ${e}');
    }
  }

  Future<List<District>> getDistricts({int provinceId}) async {
    // print("")
    return await _service.getDistricts(provinceId: provinceId);
  }

  Future<List<Ward>> getWards({int districtId}) async {
    return await _service.getWards(districtId: districtId);
  }
}

// class Data {
//   List<Province> provinces;

//   getProvincess() async {
//     try {
//       String provincePath = "lib/common/provinces.json";
//       final provinceJsonString = await rootBundle.loadString(provincePath);
//       final provincesJson = convert.jsonDecode(provinceJsonString);
//       for (var json in provincesJson) {
//         provinces.add(Province.fromJson(json));
//       }
//     } catch (e) {
//       // final provinceJsonString = await rootBundle.loadString(kAppConfig);
//       // appConfig = convert.jsonDecode(provinceJsonString);
//     }
//   }
// }
