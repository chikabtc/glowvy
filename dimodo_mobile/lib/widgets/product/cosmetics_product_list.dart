import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../models/product/product.dart';
import '../../widgets/product/product_card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/generated/i18n.dart';

class CosmeticsProductList extends StatefulWidget {
  final List<Product> products;
  final bool isNameAvailable;
  final String layout;
  final dynamic onLoadMore;
  final bool showFilter;
  final bool disableScrolling;
  final bool showRank;
  CosmeticsProductList({
    this.products,
    this.isNameAvailable = false,
    this.onLoadMore,
    this.showFilter = false,
    this.disableScrolling = false,
    this.showRank = false,
    this.layout = "list",
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
  bool get wantKeepAlive => true;
  ProductModel productModel;
  var currentIndex = 0;

  @override
  initState() {
    super.initState();
    _products = widget.products;
    productModel = Provider.of<ProductModel>(context, listen: false);
  }

  void dispose() {
    super.dispose();
  }

  @override
  didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_products != widget.products) {
      setState(() {
        _products = widget.products;
      });
    }
  }

  _loadData() async {
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
    // print("widgetproducts: ${widget.products[0].sname}");
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width);

    return _products == null
        ? Container(
            width: screenSize.width,
            height: 350,
            child: CupertinoActivityIndicator(animating: true),
          )
        : _products.length == 0
            ? Container(
                width: screenSize.width,
                height: screenSize.height / 2,
                child: Center(
                  child: DynamicText(
                    "no products found",
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kPinkAccent),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 7.0, right: 7),
                child: NotificationListener<ScrollNotification>(
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
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          widget.showFilter
                              ? Container(
                                  height: 10,
                                  color: Colors.white,
                                )
                              : SizedBox(),
                          Scrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                                addAutomaticKeepAlives: true,
                                padding: const EdgeInsets.all(0.0),
                                physics: widget.disableScrolling
                                    ? NeverScrollableScrollPhysics()
                                    : ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  currentIndex = index;
                                  return Column(
                                    children: <Widget>[
                                      // if (index == 3)
                                      // Container(
                                      //     decoration: BoxDecoration(
                                      //         color: kLightPink,
                                      //         borderRadius:
                                      //             BorderRadius.circular(6)),
                                      //     width: screenSize.width,
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 10),
                                      //     child: Row(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.end,
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.start,
                                      //       children: <Widget>[
                                      //         Image.asset(
                                      //             "assets/images/promote-glowpick-illustration.png"),
                                      //         SizedBox(
                                      //           width: 14,
                                      //         ),
                                      //         Padding(
                                      //           padding: const EdgeInsets
                                      //                   .symmetric(
                                      //               vertical: 17.0),
                                      //           child: Column(
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment
                                      //                     .start,
                                      //             children: <Widget>[
                                      //               Text(
                                      //                 S
                                      //                     .of(context)
                                      //                     .allRankingResults,
                                      //                 style: kBaseTextStyle
                                      //                     .copyWith(
                                      //                         fontWeight:
                                      //                             FontWeight
                                      //                                 .w600,
                                      //                         fontSize: 12),
                                      //               ),
                                      //               SizedBox(height: 8),
                                      //               Image.asset(
                                      //                   "assets/images/glowpick_logo.png"),
                                      //               SizedBox(height: 5),
                                      //               Container(
                                      //                 width:
                                      //                     screenSize.width -
                                      //                         168,
                                      //                 child: Text(
                                      //                   S
                                      //                       .of(context)
                                      //                       .theMostFamousRanking,
                                      //                   maxLines: 2,
                                      //                   style: kBaseTextStyle
                                      //                       .copyWith(
                                      //                           color:
                                      //                               kSecondaryPink,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                           fontSize: 12),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         )
                                      //       ],
                                      //     )),
                                      Container(
                                        height: 120,
                                        color: Colors.white,
                                        child: CosmeticsProductCard(
                                            ranking:
                                                widget.showRank ? index : null,
                                            isNameAvailable:
                                                widget.isNameAvailable,
                                            product: _products[index],
                                            width: widthContent),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          isLoading
                              ? SpinKitCircle(
                                  color: kPinkAccent,
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
                    )));
  }
}
