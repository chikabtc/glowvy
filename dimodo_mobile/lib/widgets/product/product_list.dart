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

class ProductList extends StatefulWidget {
  final List<Product> products;
  final bool isNameAvailable;
  final String layout;
  final dynamic onLoadMore;
  final bool showFilter;
  final bool isListView;
  final bool disableScrolling;
  ProductList({
    this.products,
    this.isNameAvailable = false,
    this.onLoadMore,
    this.isListView = false,
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
  ProductModel productModel;

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
    final screenSize = MediaQuery.of(context).size;
    final widthContent =
        widget.isListView ? (screenSize.width) : (screenSize.width / 2);

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
                padding: const EdgeInsets.only(left: 3.0, right: 3, bottom: 22),
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
                          widget.showFilter ? SizedBox(height: 12) : SizedBox(),
                          Scrollbar(
                            controller: _scrollController,
                            child: GridView.builder(
                                addAutomaticKeepAlives: true,
                                padding: const EdgeInsets.all(0.0),
                                physics: widget.disableScrolling
                                    ? NeverScrollableScrollPhysics()
                                    : ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: widget.isListView ? 3 : 0.8,
                                  crossAxisCount: widget.isListView ? 1 : 2,
                                ),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    ProductCard(
                                        isNameAvailable: widget.isNameAvailable,
                                        product: _products[index],
                                        width: widthContent)),
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
