import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/cosmetics_request_button.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_card.dart';
import 'package:Dimodo/widgets/product/cosmetics_review_thumb_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../models/product/product.dart';

class CosmeticsProductList extends StatefulWidget {
  final List<Product> products;
  final bool isNameAvailable;
  final String layout;
  final dynamic onLoadMore;
  final bool showFilter;
  final bool disableScrolling;
  final bool showRank;
  final bool isFromReviewSearch;
  final Function onProductSelect;
  final bool showPadding;
  const CosmeticsProductList({
    this.products,
    this.isNameAvailable = false,
    this.onLoadMore,
    this.showFilter = false,
    this.disableScrolling = false,
    this.showRank = false,
    this.isFromReviewSearch = false,
    this.layout = 'list',
    this.showPadding = false,
    this.onProductSelect,
  });

  @override
  _CosmeticsProductListState createState() => _CosmeticsProductListState();
}

class _CosmeticsProductListState extends State<CosmeticsProductList> {
  List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isEnd = false;
  int offset = 0;
  int limit = 80;
  @override
  // bool get wantKeepAlive => true;
  ProductModel productModel;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _products = widget.products;

    productModel = Provider.of<ProductModel>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_products != widget.products) {
      setState(() {
        _products = widget.products;
      });
    }
  }

  // Future _loadData() async {
  //   offset += limit;
  //   await widget.onLoadMore(offset, limit);
  //   isEnd = productModel.isEnd;
  //   setState(() {
  //     if (!isEnd) {
  //       _products = [..._products, ...productModel.products];
  //     }
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_products == null) {
      return Container(
          width: screenSize.width,
          height: screenSize.height / 1.3,
          child: Center(
            child: const SpinKitThreeBounce(color: kPrimaryOrange, size: 21.0),
          ));
    } else if (_products.isNotEmpty) {
      return Container(
        color: Colors.white,
        padding: widget.showPadding
            ? const EdgeInsets.symmetric(horizontal: 16)
            : EdgeInsets.zero,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: widget.disableScrolling
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _products.length,
            itemBuilder: (BuildContext context, int index) {
              currentIndex = index;
              if (!widget.isFromReviewSearch)
                // ignore: curly_braces_in_flow_control_structures
                return CosmeticsProductCard(
                  ranking: widget.showRank ? index : null,
                  isNameAvailable: widget.isNameAvailable,
                  showDivider: index != _products.length - 1,
                  product: _products[index],
                );
              else
                CosmeticsReviewThumbCard(
                    ranking: widget.showRank ? index : null,
                    showDivider: index != _products.length - 1,
                    product: _products[index]);
            }),
      );
    } else
      return Column(
        children: [
          Container(height: 41),
          Center(
            child: Text(
              'không tìm thấy sản phẩm',
              style: textTheme.bodyText2.copyWith(color: kTertiaryGray),
            ),
          ),
          CosmeticsRequestBtn(),
        ],
      );
  }
}
