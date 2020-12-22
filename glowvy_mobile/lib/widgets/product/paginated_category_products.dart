// import 'package:Dimodo/common/colors.dart';
// import 'package:Dimodo/common/constants.dart';
// import 'package:Dimodo/common/widgets.dart';
// import 'package:Dimodo/models/product/productModel.dart';
// import 'package:Dimodo/screens/error_indicator.dart';
// import 'package:Dimodo/widgets/cosmetics_request_button.dart';
// import 'package:Dimodo/widgets/product/cosmetics_product_card.dart';
// import 'package:Dimodo/widgets/product/cosmetics_review_thumb_card.dart';
// import 'package:Dimodo/widgets/product/list_page.dart';
// import 'package:after_layout/after_layout.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:provider/provider.dart';

// import '../../models/product/product.dart';

// class PaginatedProductListView extends StatefulWidget {
//   final ListPage<Product> initialPage;
//   final bool showFilter;
//   final bool showRank;
//   final bool isFromReviewSearch;
//   final dynamic fetchProducts;
//   final dynamic listPreferences;
//   final bool showPadding;

//   const PaginatedProductListView({
//     this.initialPage,
//     this.showFilter = false,
//     this.showRank = false,
//     this.isFromReviewSearch = false,
//     this.fetchProducts,
//     this.listPreferences,
//     this.showPadding = false,
//   });

//   @override
//   _PaginatedProductListViewState createState() =>
//       _PaginatedProductListViewState();
// }

// class _PaginatedProductListViewState extends State<PaginatedProductListView>
//     with AfterLayoutMixin {
//   ProductModel productModel;
//   final _pagingController = PagingController<int, Product>(firstPageKey: 0);

//   @override
//   void initState() {
//     super.initState();
//     _pagingController.itemList = widget.initialPage.itemList;

//     if (widget.initialPage.isLastPage(0)) {
//       print('set last page ');
//       _pagingController.nextPageKey = null;
//     }

//     productModel = Provider.of<ProductModel>(context, listen: false);
//     _pagingController.addPageRequestListener((pageKey) {
//       print('listen');
//       _fetchPage(pageKey);
//     });
//   }

//   @override
//   void didUpdateWidget(PaginatedProductListView oldWidget) {
//     if (oldWidget.listPreferences != widget.listPreferences) {
//       _pagingController.refresh();
//     }
//     if (oldWidget.initialPage != widget.initialPage) {
//       _pagingController.itemList = widget.initialPage.itemList;
//       // _pagingController.refresh();
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void afterFirstLayout(BuildContext context) {}

//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchPage(int pageKey) async {
//     assert(_pagingController.nextPageKey != null);

//     try {
//       print('fetching');
//       final ListPage<Product> newPage = await widget.fetchProducts();
//       if (newPage != null) {
//         print('new page exists');
//         final previouslyFetchedItemsCount =
//             _pagingController.itemList?.length ?? 0;
//         final isLastPage = newPage.itemList.isEmpty ||
//             newPage.isLastPage(previouslyFetchedItemsCount);
//         if (isLastPage) {
//           print('last page');
//           _pagingController.appendLastPage(newPage.itemList);
//         } else {
//           final nextPageKey = pageKey + 1;
//           _pagingController.appendPage(newPage.itemList, nextPageKey);
//         }
//       } else {
//         print('new page is null');
//       }
//     } catch (error) {
//       print(error);
//       _pagingController.error = error;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return Scrollbar(
//       child: PagedListView.separated(
//         addAutomaticKeepAlives: false,
//         shrinkWrap: true,
//         physics: const ClampingScrollPhysics(),
//         builderDelegate: PagedChildBuilderDelegate<Product>(
//             itemBuilder: (context, product, index) {
//               if (!widget.isFromReviewSearch) {
//                 return CosmeticsProductCard(
//                   ranking: widget.showRank ? index : null,
//                   showDivider: index != _pagingController.itemList.length - 1,
//                   product: product,
//                 );
//               } else {
//                 return CosmeticsReviewThumbCard(
//                     ranking: widget.showRank ? index : null,
//                     showDivider: index != _pagingController.itemList.length - 1,
//                     product: product);
//               }
//             },
//             firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
//                   error: _pagingController.error,
//                   onTryAgain: () => _pagingController.refresh(),
//                 ),
//             noItemsFoundIndicatorBuilder: (context) => Column(
//                   children: [
//                     Container(height: 41),
//                     Center(
//                       child: Text(
//                         'không tìm thấy sản phẩm',
//                         style:
//                             textTheme.bodyText2.copyWith(color: kTertiaryGray),
//                       ),
//                     ),
//                     CosmeticsRequestBtn(),
//                   ],
//                 ),
//             firstPageProgressIndicatorBuilder: (context) => Container(
//                 width: screenSize.width,
//                 height: screenSize.height / 3,
//                 child: const Center(
//                     child:
//                         SpinKitThreeBounce(color: kPrimaryOrange, size: 21.0))),
//             newPageProgressIndicatorBuilder: (context) => Container(
//                   height: screenSize.height / 10,
//                   child: Center(child: kIndicator()),
//                 )),
//         pagingController: _pagingController,
//         padding: widget.showPadding
//             ? const EdgeInsets.symmetric(horizontal: 16)
//             : EdgeInsets.zero,
//         separatorBuilder: (context, index) => const SizedBox(
//           height: 0,
//         ),
//       ),
//     );
//   }
// }
