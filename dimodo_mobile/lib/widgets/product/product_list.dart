import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/product/product.dart';
import '../../services/index.dart';
import '../../widgets/product/product_card_view.dart';
import 'package:flutter/cupertino.dart';

class ProductList extends StatefulWidget {
  final padding;
  List<Product> products;
  final bool isFetching;
  final bool isEnd;
  bool isNameAvailable;

  final String layout;
  final Function onRefresh;
  final Function onLoadMore;
  ProductList({
    this.isFetching = false,
    this.isEnd = true,
    // this.errMsg,
    this.products,
    // this.width,
    this.isNameAvailable = false,
    this.padding = 8.0,
    this.onRefresh,
    this.onLoadMore,
    this.layout = "list",
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with AutomaticKeepAliveClientMixin<ProductList> {
  RefreshController _refreshController;
  Services _service = Services();
  List<Product> _products;
  int _page = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    _products = widget.products ?? [];
    _refreshController =
        RefreshController(initialRefresh: _products.length == 0);
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

  // _loadProduct() async {
  //   var newProducts = await _service.searchProducts(page: _page);
  //   _products = [..._products, ...newProducts];
  // }

  // _onRefresh() async {
  //   _page = 1;
  //   _products = [];
  //   _loadProduct();
  //   _refreshController.refreshCompleted();
  // }

  // _onLoading() async {
  //   _page = _page + 1;
  //   _loadProduct();
  //   _refreshController.loadComplete();
  // }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  //testing codemagic1
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width / 2);

    return widget.products == null
        ? Container(
            width: screenSize.width,
            height: 350,
            child: CupertinoActivityIndicator(animating: true),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3),
            child: CupertinoScrollbar(
              child: GridView.builder(
                addAutomaticKeepAlives: true,
                padding: const EdgeInsets.all(0.0),

                physics: ScrollPhysics(), // to disable GridView's scrolling
                shrinkWrap: true,
                itemCount: widget.products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) => ProductCard(
                    isNameAvailable: widget.isNameAvailable,
                    product: widget.products[index],
                    width: widthContent),
              ),
            ),
          );
  }
}
