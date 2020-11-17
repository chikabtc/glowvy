import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/cosmetics_request_button.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_card.dart';
import 'package:Dimodo/widgets/product/cosmetics_review_thumb_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
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
  CosmeticsProductList({
    this.products,
    this.isNameAvailable = false,
    this.onLoadMore,
    this.showFilter = false,
    this.disableScrolling = false,
    this.showRank = false,
    this.isFromReviewSearch = false,
    this.layout = 'list',
    this.onProductSelect,
  });

  @override
  _CosmeticsProductListState createState() => _CosmeticsProductListState();
}

class _CosmeticsProductListState extends State<CosmeticsProductList>
    with AutomaticKeepAliveClientMixin<CosmeticsProductList> {
  List<Product> _products;
  ScrollController _scrollController;
  bool isLoading = false;
  bool isEnd = false;
  int offset = 0;
  int limit = 80;
  @override
  bool get wantKeepAlive => true;
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

  Future _loadData() async {
    offset += limit;
    await widget.onLoadMore(offset, limit);
    isEnd = productModel.isEnd;
    setState(() {
      if (!isEnd) {
        _products = [..._products, ...productModel.products];
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('widgetproducts: ${widget.products[0].sname}');
    final screenSize = MediaQuery.of(context).size;
    final widthContent = screenSize.width;

    return _products == null
        ? Container(
            width: screenSize.width,
            height: 350,
            child: Container(
                height: kScreenSizeHeight * 0.5,
                child: const SpinKitThreeBounce(
                    color: kPrimaryOrange, size: 21.0)))
        : _products.isEmpty
            ? Column(
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
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _loadData();
                    setState(() {
                      isLoading = true;
                    });
                  }
                  return false;
                },
                child: Scrollbar(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: <Widget>[
                      Scrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                            addAutomaticKeepAlives: true,
                            padding: const EdgeInsets.all(0.0),
                            physics: widget.disableScrolling
                                ? const NeverScrollableScrollPhysics()
                                : const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _products.length,
                            itemBuilder: (BuildContext context, int index) {
                              currentIndex = index;
                              return _products.isEmpty
                                  ? Column(
                                      children: [
                                        Container(height: 41),
                                        Center(
                                          child: Text(
                                            'không tìm thấy sản phẩm',
                                            style: textTheme.bodyText2
                                                .copyWith(color: kTertiaryGray),
                                          ),
                                        ),
                                        CosmeticsRequestBtn(),
                                      ],
                                    )
                                  : Column(
                                      children: <Widget>[
                                        !widget.isFromReviewSearch
                                            ? CosmeticsProductCard(
                                                ranking: widget.showRank
                                                    ? index
                                                    : null,
                                                isNameAvailable:
                                                    widget.isNameAvailable,
                                                showDivider: index !=
                                                    _products.length - 1,
                                                product: _products[index],
                                              )
                                            : CosmeticsReviewThumbCard(
                                                ranking: widget.showRank
                                                    ? index
                                                    : null,
                                                showDivider: index !=
                                                    _products.length - 1,
                                                product: _products[index])
                                      ],
                                    );
                            }),
                      ),
                      isLoading
                          ? SpinKitCircle(
                              color: kPrimaryOrange,
                              size: 23.0 * kSizeConfig.containerMultiplier)
                          : isEnd
                              ? SvgPicture.asset(
                                  'assets/icons/heart-ballon.svg',
                                  width: 30,
                                  height: 42,
                                )
                              : Container(),
                    ],
                  ),
                ));
  }
}
