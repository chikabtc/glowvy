import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingByCategory extends StatefulWidget {
  const RankingByCategory({this.secondCategory, this.thirdCategory});
  final SecondCategory secondCategory;
  final ThirdCategory thirdCategory;

  @override
  State<StatefulWidget> createState() {
    return RankingByCategoryState();
  }
}

class RankingByCategoryState extends State<RankingByCategory>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CategoryModel categoryModel;
  ProductModel productModel;
  Future getProductsByCategoryId;
  ThirdCategory _thirdCategory;
  var whiteSpace = Container(
    height: 60,
    width: kScreenSizeWidth / 3,
    decoration: BoxDecoration(
      border: Border.all(color: kQuaternaryGrey, width: 0.5),
    ),
    padding: const EdgeInsets.all(12),
  );

  // Future<ListPage<Product>> getProductsByCategory;
  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    _thirdCategory = widget.thirdCategory;

    if (widget.thirdCategory == null) {
      getProductsByCategoryId = productModel.getProductsByCategory(
          secondCategory: widget.secondCategory);
    } else {
      getProductsByCategoryId =
          productModel.getProductsByCategory(thirdCategory: _thirdCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context,
                onPop: () => productModel.clearPaginationHistory()),
            backgroundColor: Colors.white,
            title: Text(widget.secondCategory.secondCategoryName,
                style: textTheme.headline3)),
        backgroundColor: kDefaultBackground,
        body: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                  child: Container(
                width: kScreenSizeWidth,
                child: Column(
                  children: [
                    Container(
                      color: kWhite,
                      child: Wrap(children: [
                        if (widget.secondCategory.thirdCategories.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //resetting the _thirdCategory works but the list is not?
                                _thirdCategory = null;
                                productModel.clearPaginationHistory();
                                getProductsByCategoryId =
                                    productModel.getProductsByCategory(
                                        secondCategory: widget.secondCategory);
                                ;
                                //
                              });
                            },
                            child: Container(
                              height: 60,
                              width: kScreenSizeWidth / 3,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: kQuaternaryGrey, width: 0.5),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  'Tất cả sản phẩm',
                                  style: textTheme.button.copyWith(
                                      color: _thirdCategory == null
                                          ? kPrimaryOrange
                                          : kDefaultFontColor,
                                      fontWeight: _thirdCategory == null
                                          ? FontWeight.w600
                                          : FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        for (var cate in widget.secondCategory.thirdCategories)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //resetting the _thirdCategory works but the list is not?
                                productModel.clearPaginationHistory();

                                _thirdCategory = cate;
                                getProductsByCategoryId =
                                    productModel.getProductsByCategory(
                                        thirdCategory: _thirdCategory);
                                ;
                                //
                              });
                            },
                            child: Container(
                              height: 60,
                              width: kScreenSizeWidth / 3,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: kQuaternaryGrey, width: 0.5),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  cate.thirdCategoryName,
                                  style: textTheme.button.copyWith(
                                      color: _thirdCategory == cate
                                          ? kPrimaryOrange
                                          : kDefaultFontColor,
                                      fontWeight: _thirdCategory == cate
                                          ? FontWeight.w600
                                          : FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        if (widget.secondCategory.thirdCategories.length == 1)
                          whiteSpace
                      ]),
                    ),
                    Container(height: 12, color: Colors.transparent),
                  ],
                ),
              ))
            ];
          },
          body: Container(
            color: kWhite,
            child: productModel.showPaginatedProductList(
                future: getProductsByCategoryId,
                fetchProducts: () => _thirdCategory != null
                    ? productModel.getProductsByCategory(
                        thirdCategory: _thirdCategory)
                    : productModel.getProductsByCategory(
                        secondCategory: widget.secondCategory)),
          ),
        ));
  }
}
