import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingByCategory extends StatefulWidget {
  const RankingByCategory({this.secondCategory, this.thirdCategory});
  final Category secondCategory;
  final Category thirdCategory;

  @override
  State<StatefulWidget> createState() {
    return RankingByCategoryState();
  }
}

class RankingByCategoryState extends State<RankingByCategory>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ProductModel productModel;
  Future getProductsByCategoryId;
  Category _thirdCategory;
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
      getProductsByCategoryId =
          productModel.getProductsByCategory(widget.secondCategory);
    } else {
      getProductsByCategoryId =
          productModel.getProductsByCategory(_thirdCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context, onPop: () {
              Navigator.pop(context);
              productModel.clearPaginationHistory();
            }),
            backgroundColor: Colors.white,
            title:
                Text(widget.secondCategory.name, style: textTheme.headline3)),
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
                        if (widget.secondCategory.subCategories.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //resetting the _thirdCategory works but the list is not?
                                _thirdCategory = null;
                                productModel.clearPaginationHistory();
                                getProductsByCategoryId =
                                    productModel.getProductsByCategory(
                                        widget.secondCategory);
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
                        for (var cate in widget.secondCategory.subCategories)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //resetting the _thirdCategory works but the list is not?
                                productModel.clearPaginationHistory();

                                _thirdCategory = cate;
                                getProductsByCategoryId = productModel
                                    .getProductsByCategory(_thirdCategory);
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
                                  cate.name,
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
                        if (widget.secondCategory.subCategories.length == 1)
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
            child: PaginatedProductListView(
              category: _thirdCategory ?? widget.secondCategory,
              showPadding: true,
            ),
          ),
        ));
  }
}
