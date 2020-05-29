import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../common/constants.dart';
import '../../models/product/product.dart';
import '../../widgets/product/product_card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/generated/i18n.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final bool isNameAvailable;
  final String layout;
  final dynamic onLoadMore;
  final bool showFilter;
  final bool disableScrolling;
  ProductList({
    this.products,
    this.isNameAvailable = false,
    this.onLoadMore,
    this.showFilter = false,
    this.disableScrolling = false,
    this.layout = "list",
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with AutomaticKeepAliveClientMixin<ProductList> {
  List<Product> _products;
  ScrollController _scrollController;
  bool isLoading = false;
  bool isEnd = false;
  int offset = 0;
  int limit = 80;
  bool get wantKeepAlive => true;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";
  bool isAscending = false;

  @override
  initState() {
    super.initState();
    _products = widget.products;
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
    var productModel = Provider.of<ProductModel>(context, listen: false);
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
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width / 2);

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
                padding: const EdgeInsets.only(left: 3.0, right: 3),
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        _loadData();
                        isLoading = true;
                        // setState(() {});
                      }
                      return false;
                    },
                    child: Column(
                      children: <Widget>[
                        widget.showFilter
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isAscending = !isAscending;
                                        _products.sort((a, b) => isAscending
                                            ? b.salePrice.compareTo(a.salePrice)
                                            : a.salePrice
                                                .compareTo(b.salePrice));
                                      });
                                    },
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: isAscending
                                              ? Colors.white
                                              : kLightPink,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 6),
                                        height: 24,
                                        // width: 98,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            isAscending
                                                ? Image.asset(
                                                    "assets/icons/filter-sort.png")
                                                : Image.asset(
                                                    "assets/icons/filter-sort-active.png"),
                                            DynamicText(
                                              isAscending
                                                  ? S
                                                      .of(context)
                                                      .highestToLowest
                                                  : S
                                                      .of(context)
                                                      .lowestToHighest,
                                              textAlign: TextAlign.center,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 12,
                                                  color: isAscending
                                                      ? kDarkSecondary
                                                      : kDarkAccent),
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(width: 16)
                                ],
                              )
                            : Container(),
                        SizedBox(height: 12),
                        Expanded(
                          child: Scrollbar(
                            controller: _scrollController,
                            child: GridView.builder(
                              addAutomaticKeepAlives: true,
                              padding: const EdgeInsets.all(0.0),
                              physics: widget.disableScrolling
                                  ? NeverScrollableScrollPhysics()
                                  : AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.8,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (BuildContext context, int index) =>
                                  ProductCard(
                                      isNameAvailable: widget.isNameAvailable,
                                      product: _products[index],
                                      width: widthContent),
                            ),
                          ),
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
                        Container(height: 10),
                        SizedBox(height: 12),
                      ],
                    )));
  }
}
