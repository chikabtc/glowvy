// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/app.dart';
// import '../models/product/product.dart';
// import '../services/index.dart';
// import '../widgets/backdrop.dart';
// import '../widgets/product/product_bottom_sheet.dart';
// import '../widgets/product/product_list.dart';

// class ProductBackdrop extends StatelessWidget {
//   final ExpandingBottomSheet expandingBottomSheet;
//   final Backdrop backdrop;

//   const ProductBackdrop({Key key, this.expandingBottomSheet, this.backdrop})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         backdrop,
//         Align(child: expandingBottomSheet, alignment: Alignment.bottomRight)
//       ],
//     );
//   }
// }

// class ProductsPage extends StatefulWidget {
//   final List<Product> products;
//   final int categoryId;
//   final config;

//   ProductsPage({
//     this.products,
//     this.categoryId,
//     this.config,
//   });

//   @override
//   State<StatefulWidget> createState() {
//     return ProductsPageState();
//   }
// }

// class ProductsPageState extends State<ProductsPage>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;

//   int newCategoryId = -1;
//   // double minPrice;
//   // double maxPrice;
//   // String orderBy;
//   // String order;
//   // bool isFiltering = false;
//   List<Product> products = [];
//   String errMsg;

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       newCategoryId = widget.categoryId;
//     });
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 450),
//       value: 1.0,
//     );

//     if (widget.config != null) {
//       onRefresh();
//     }
//   }

//   void onFilter({minPrice, maxPrice, categoryId}) {
//     _controller.forward();
//     final productModel = Provider.of<ProductModel>(context, listen: false);
//     newCategoryId = categoryId;

//     productModel.setProductsList(List<Product>());

//     print([minPrice, maxPrice, categoryId]);

//     productModel.getProductsList(
//       categoryId: categoryId == -1 ? null : categoryId,
//       page: 1,
//       lang: Provider.of<AppModel>(context, listen: false).locale,
//     );
//   }

//   void onSort(order) {
//     Provider.of<ProductModel>(context).getProductsList(
//       categoryId: newCategoryId,
//       lang: Provider.of<AppModel>(context, listen: false).locale,
//       page: 1,
//     );
//   }

//   void onRefresh() async {
//     if (widget.config == null) {
//       Provider.of<ProductModel>(context).getProductsList(
//           categoryId: newCategoryId,

//           lang: Provider.of<AppModel>(context, listen: false).locale,
//           page: 1,

//           );
//     } else {
//       try {
//         var newProducts =
//             await Services().fetchProductsLayout(config: widget.config);
//         setState(() {
//           products = newProducts;
//         });
//       } catch (err) {
//         setState(() {
//           errMsg = err;
//         });
//       }
//     }
//   }

//   void onLoadMore(page) {
//     Provider.of<ProductModel>(context).getProductsList(
//       categoryId: newCategoryId,
//       lang: Provider.of<AppModel>(context, listen: false).locale,
//       page: page,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final product = Provider.of<ProductModel>(context, listen: false);
//     final title = product.categoryName;
//     /// load the product base on default 2 columns view or AsymmetricView
//     /// please note that the AsymmetricView is not ready support for loading per page.

//     return Container(
//       child: LayoutBuilder(
//         builder: (context, constraint) {
//           return FractionallySizedBox(
//             widthFactor: 1.0,
//             child: ListenableProvider.value(
//               value: product,
//               child: Consumer<ProductModel>(builder: (context, value, child) {
//                 return backdrop(
//                     products: value.productsList,
//                     isFetching: value.isFetching,
//                     errMsg: value.errMsg,
//                     isEnd: value.isEnd,
//               }),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
