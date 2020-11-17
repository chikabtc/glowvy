import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'district.dart';
import 'province.dart';
import 'ward.dart';

class AddressModel with ChangeNotifier {
  AddressModel();
  //todo: turn this single address to a list of address.
  List<Province> provinces = [];
  List<District> districts = [];
  List<Ward> wards = [];
  //

  Future setProvinces() async {
    try {
      print('fail to getProvinces');
      const provincePath = 'lib/common/provinces.json';
      final provinceJsonString = await rootBundle.loadString(provincePath);
      final provincesJson = convert.jsonDecode(provinceJsonString);
      for (final json in provincesJson) {
        provinces.add(Province.fromJson(json));
      }
    } catch (e) {
      print('fail to getProvinces: $e');
    }
  }
}
