import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/widgets/brand_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandList extends StatefulWidget {
  BrandList(
      {this.brands, this.disableScrolling = true, this.showDivider = true});

  bool disableScrolling;
  bool showDivider;
  final List<Brand> brands;

  @override
  _BrandListState createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.brands.isEmpty
        ? Container()
        : ListView.separated(
            padding: EdgeInsets.zero,
            physics: !widget.disableScrolling
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.brands.length,
            itemBuilder: (BuildContext context, int index) {
              currentIndex = index;
              return BrandCard(
                brand: widget.brands[index],
              );
            },
            separatorBuilder: (context, index) => kFullDivider);
  }
}
