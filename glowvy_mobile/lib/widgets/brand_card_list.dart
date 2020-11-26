import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/productModel.dart';
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
  ScrollController _scrollController;
  bool isLoading = false;
  bool isEnd = false;
  int offset = 0;
  int limit = 80;
  @override
  ProductModel productModel;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // print('product length:${_products.length}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return widget.brands.isEmpty
        ? Container()
        : ListView.builder(
            padding: const EdgeInsets.all(0.0),
            physics: widget.disableScrolling
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.brands.length,
            itemBuilder: (BuildContext context, int index) {
              currentIndex = index;
              return Column(children: [
                BrandCard(
                  brand: widget.brands[index],
                ),
              ]);
            });
  }
}
