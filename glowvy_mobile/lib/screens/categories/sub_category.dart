// import 'package:Dimodo/models/product/product.dart';
// import 'package:Dimodo/services/index.dart';
// import 'package:Dimodo/widgets/fashion_filter_bar.dart';
// import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
// // import 'package:Dimodo/widgets/product/product_list.dart';
// // import 'package:Dimodo/widgets/product_filter_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:Dimodo/common/styles.dart';

// import 'package:Dimodo/common/colors.dart';
// import 'package:Dimodo/models/user/user.dart';
// import 'package:Dimodo/widgets/customWidgets.dart';
// import 'package:Dimodo/models/product/productModel.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:Dimodo/models/category.dart';
// import 'package:provider/provider.dart';

// class SubCategoryScreen extends StatefulWidget {
//   final User user;
//   final VoidCallback onLogout;
//   final Category category;

//   SubCategoryScreen({this.user, this.onLogout, this.category});

//   @override
//   State<StatefulWidget> createState() {
//     return SubCategoryScreenState();
//   }
// }

// class SubCategoryScreenState extends State<SubCategoryScreen>
//     with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
//   int currentIndex = 0;
//   bool isAscending = false;
//   String highToLow = '-sale_price';
//   String lowToHigh = 'sale_price';
//   Future<List<Product>> getProductByTagTrending;
//   Future<List<Product>> getProductsByCategoryId;
//   Services service = Services();
//   Category currentCate;
//   bool isNewCategoryPage = false;
//   bool showFilteredResults = false;
//   ProductModel productModel;
//   List<Product> products;
//   List<Product> filteredResults;

//   @override
//   void initState() {
//     super.initState();

//     currentCate = widget.category;
//     if (currentCate.firstCategoryId == 0) {
//       getProductByTagTrending =
//           service.getProductsByTag(tag: 5, sortBy: 'sale_price');
//     }

//     getProductsByCategoryId = service.getProductsByCategory(
//         categoryId: currentCate.firstCategoryId, sortBy: lowToHigh, start: 0, limit: 12);
//     productModel = Provider.of<ProductModel>(context, listen: false);
//   }

//   void onLoadMore(start, limit) {
//     Provider.of<ProductModel>(context, listen: false).fetchProductsByCategory(
//       categoryId: currentCate.firstCategoryId,
//       sortBy: isAscending ? highToLow : lowToHigh,
//       start: start,
//       limit: limit,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return FutureBuilder<List<Product>>(
//       future: currentCate.firstCategoryId == 0
//           ? getProductByTagTrending
//           : getProductsByCategoryId,
//       builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
//         if (snapshot.hasData) {
//           products = snapshot.data;
//         }
//         return Scaffold(
//             appBar: AppBar(
//               brightness: Brightness.light,
//               leading: IconButton(
//                 icon: CommonIcons.arrowBackward,
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               elevation: 0,
//               backgroundColor: Colors.white,
//               // pinned: true,
//               title: Text(currentCate.firstCategoryName,
//                   style: kBaseTextStyle.copyWith(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600)),
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(106),
//                 child: Container(
//                   height: 106,
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       DefaultTabController(
//                         length: widget.category.subCategories.length + 1,
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 16.0),
//                           child: TabBar(
//                             indicatorSize: TabBarIndicatorSize.label,
//                             labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
//                             isScrollable: true,
//                             indicatorColor: kDarkAccent,
//                             unselectedLabelColor: Colors.black,
//                             unselectedLabelStyle:
//                                 kBaseTextStyle.copyWith(color: kSecondaryGrey),
//                             labelStyle: kBaseTextStyle,
//                             labelColor: kPinkAccent,
//                             onTap: (i) {
//                               setState(() {
//                                 currentIndex = i;
//                                 isNewCategoryPage = true;
//                                 currentCate = i == 0
//                                     ? widget.category
//                                     : widget.category.subCategories[i - 1];
//                                 getProductsByCategoryId =
//                                     service.getProductsByCategory(
//                                         categoryId: currentCate.firstCategoryId,
//                                         sortBy: lowToHigh,
//                                         start: 0,
//                                         limit: 6);
//                                 showFilteredResults = false;
//                               });
//                             },
//                             tabs: renderTabbar(),
//                           ),
//                         ),
//                       ),
//                       FashionFilterBar(
//                         products: products,
//                         onFilterConfirm: (filteredProducts) {
//                           setState(() {
//                             showFilteredResults = true;
//                             this.filteredResults = filteredProducts;
//                           });
//                         },
//                         onSortingChanged: (sorted) {
//                           setState(() {
//                             showFilteredResults = true;
//                             this.filteredResults = sorted;
//                           });
//                         },
//                         onReset: (filteredProducts) {
//                           setState(() {
//                             showFilteredResults = false;
//                           });
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             body: CosmeticsProductList(
//               products: showFilteredResults ? filteredResults : products,
//               onLoadMore: onLoadMore,
//               isNameAvailable: true,
//             ));
//       },
//     );
//   }

//   List<Widget> renderTabbar() {
//     List<Widget> tabBars = [];

//     var allBtn = Container(
//       child: Tab(
//         child: Text('all',
//             style: kBaseTextStyle.copyWith(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: currentIndex == 0 ? kDarkAccent : kSecondaryGrey,
//             )),
//       ),
//     );
//     tabBars.add(allBtn);

//     widget.category.subCategories.asMap().forEach((index, element) {
//       var btn = Container(
//         child: Tab(
//           child: Text(widget.category.subCategories[index].name,
//               style: kBaseTextStyle.copyWith(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: currentIndex == index + 1 ? kDarkAccent : kSecondaryGrey,
//               )),
//         ),
//       );

//       tabBars.add(btn);
//     });
//     return tabBars;
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
