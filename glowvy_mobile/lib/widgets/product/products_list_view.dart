import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/screens/error_indicator.dart';
import 'package:Dimodo/widgets/product/product_card.dart';
import 'package:Dimodo/widgets/product/cosmetics_review_thumb_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/product/product.dart';

class ProductsListView extends StatefulWidget {
  final List<Product> products;
  final bool isNameAvailable;
  final dynamic onLoadMore;
  final bool showFilter;
  final bool disableScrolling;
  final bool showRank;
  final bool isFromReviewSearch;
  final bool showPadding;
  // final ListPreferences listPreferences;

  const ProductsListView({
    this.products,
    this.isNameAvailable = false,
    this.onLoadMore,
    this.showFilter = false,
    this.disableScrolling = false,
    this.showRank = false,
    this.isFromReviewSearch = false,
    this.showPadding = false,
  });

  @override
  _ProductsListViewState createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  ProductModel productModel;
  final _pagingController = PagingController<int, Product>(
    // 2
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.itemList = widget.products;
    productModel = Provider.of<ProductModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProductsListView oldWidget) {
    if (oldWidget.products != _pagingController.itemList) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: kWhite,
      child: Scrollbar(
        child: PagedListView.separated(
          shrinkWrap: true,
          physics: widget.disableScrolling
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          padding: widget.showPadding
              ? const EdgeInsets.symmetric(horizontal: 16)
              : EdgeInsets.zero,
          builderDelegate: PagedChildBuilderDelegate<Product>(
              itemBuilder: (context, product, index) {
                if (!widget.isFromReviewSearch)
                  // ignore: curly_braces_in_flow_control_structures
                  return ProductCard(
                    ranking: widget.showRank ? index : null,
                    isNameAvailable: widget.isNameAvailable,
                    showDivider: index != _pagingController.itemList.length - 1,
                    product: product,
                  );
                else {
                  return CosmeticsReviewThumbCard(
                      ranking: widget.showRank ? index : null,
                      showDivider:
                          index != _pagingController.itemList.length - 1,
                      product: product);
                }
              },
              firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                    error: _pagingController.error,
                    onTryAgain: () => _pagingController.refresh(),
                  ),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  width: screenSize.width,
                  height: screenSize.height / 1.3,
                  child: const Center(
                      child: SpinKitThreeBounce(
                          color: kPrimaryOrange, size: 21.0))),
              newPageProgressIndicatorBuilder: (context) => Container()),
          pagingController: _pagingController,
          separatorBuilder: (context, index) => const SizedBox(
            height: 0,
          ),
        ),
      ),
    );
  }
}
