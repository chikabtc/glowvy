import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandHomePage extends StatefulWidget {
  const BrandHomePage(this.brand);
  final Brand brand;

  @override
  State<StatefulWidget> createState() {
    return BrandHomePageState();
  }
}

class BrandHomePageState extends State<BrandHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CategoryModel categoryModel;
  ProductModel productModel;
  Future<List<Product>> getProductsByBrand;
  Category currentCategory;
  Product lastProduct;
  String option = 'By Price';
  bool isLoading = false;
  int itemsCount = 0;

  //category variable
  //second cate variable
  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    getProductsByBrand = productModel.getProductsByBrand(widget.brand.id);
    //fetch all products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          leading: backIcon(context, onPop: productModel.clearPagesInfo),
          backgroundColor: Colors.white,
          title: Text(widget.brand.name)),
      backgroundColor: kWhite,
      // body: PaginatedProductListView(
      //   fetchProducts: () => productModel.getProductsByBrand(widget.brand.id),
      //   showRank: false,
      //   showPadding: true,
      // ),
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: kQuaternaryGrey,
                    child: ClipOval(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Tools.image(
                          url: widget.brand.image,
                          width: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.brand.name,
                      maxLines: 1, style: textTheme.bodyText2),
                  const SizedBox(height: 15),
                  Container(
                    height: 5,
                    color: kDefaultBackground,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      //'${_products != null ? _products.length : 0}
                      Text('$itemsCount items', style: textTheme.caption),
                      const Spacer(),
                      // GestureDetector(
                      //   onTap: () =>
                      //       Popups.showSortOptions(context, snapshot.data,
                      //           onTap: (value, newOption) {
                      //     setState(() {
                      //       print(value);
                      //       option = newOption;
                      //       _products = value;
                      //     });
                      //   }),
                      //   child: Row(children: [
                      //     Text(option, style: textTheme.caption),
                      //     const Icon(Icons.arrow_drop_down,
                      //         color: kQuaternaryGrey),
                      //   ]),
                      // ),
                      const SizedBox(width: 8),
                      kFullDivider,
                    ],
                  ),
                ],
              ),
            )
          ];
        },
        body: PaginatedProductListView(
          fetchProducts: () => productModel.getProductsByBrand(widget.brand.id),
          showRank: false,
          showPadding: true,
        ),
      ),

      // body: Scrollbar(
      //   child: ListView(
      //     children: [
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           const SizedBox(height: 15),
      //           CircleAvatar(
      //             radius: 32,
      //             backgroundColor: kQuaternaryGrey,
      //             child: ClipOval(
      //               child: Container(
      //                 height: 60,
      //                 width: 60,
      //                 decoration: const BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.all(Radius.circular(20)),
      //                 ),
      //                 child: Tools.image(
      //                   url: widget.brand.image,
      //                   width: 48,
      //                   fit: BoxFit.contain,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           const SizedBox(height: 5),
      //           Text(widget.brand.name,
      //               maxLines: 1, style: textTheme.bodyText2),
      //           const SizedBox(height: 15),
      //         ],
      //       ),
      //       Container(
      //         height: 5,
      //         color: kDefaultBackground,
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const SizedBox(height: 8),
      //           Row(
      //             children: [
      //               const SizedBox(width: 16),
      //               //'${_products != null ? _products.length : 0}
      //               Text('$itemsCount items', style: textTheme.caption),
      //               const Spacer(),
      //               // GestureDetector(
      //               //   onTap: () =>
      //               //       Popups.showSortOptions(context, snapshot.data,
      //               //           onTap: (value, newOption) {
      //               //     setState(() {
      //               //       print(value);
      //               //       option = newOption;
      //               //       _products = value;
      //               //     });
      //               //   }),
      //               //   child: Row(children: [
      //               //     Text(option, style: textTheme.caption),
      //               //     const Icon(Icons.arrow_drop_down,
      //               //         color: kQuaternaryGrey),
      //               //   ]),
      //               // ),
      //               const SizedBox(width: 8),
      //             ],
      //           ),
      //           kFullDivider,
      //           PaginatedProductListView(
      //             fetchProducts: () =>
      //                 productModel.getProductsByBrand(widget.brand.id),
      //             showRank: false,
      //             showPadding: true,
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
