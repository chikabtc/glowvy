import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/second_category.dart';
import 'package:Dimodo/models/third_category.dart';
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
  ThirdCategory thirdCategory;

  //category variable
  //second cate variable
  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    thirdCategory = widget.thirdCategory;
    if (widget.secondCategory.thirdCategories.isEmpty) {
      getProductsByCategoryId = productModel.getProductsByCategoryId(
          categoryId: widget.secondCategory.secondCategoryId,
          categoryField: 'second_category_id');
    } else {
      getProductsByCategoryId = productModel.getProductsByCategoryId(
          categoryId: thirdCategory.thirdCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context),
            backgroundColor: Colors.white,
            title: Text(widget.secondCategory.secondCategoryName,
                style: textTheme.headline3)),
        backgroundColor: kDefaultBackground,
        body: ListView(
          children: [
            Container(
              color: kWhite,
              child: Wrap(
                children: [
                  for (var cate in widget.secondCategory.thirdCategories)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          thirdCategory = cate;
                          getProductsByCategoryId =
                              productModel.getProductsByCategoryId(
                            categoryId: cate.thirdCategoryId,
                          );
                        });
                      },
                      child: Container(
                        height: 60,
                        width: kScreenSizeWidth / 3,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: kQuaternaryGrey, width: 0.5),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          cate.thirdCategoryName,
                          style: textTheme.button.copyWith(
                              color: thirdCategory == cate
                                  ? kPrimaryOrange
                                  : kDefaultFontColor,
                              fontWeight: thirdCategory == cate
                                  ? FontWeight.w600
                                  : FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(height: 12, color: Colors.transparent),
            productModel.showProductList(
                future: getProductsByCategoryId, showRank: true)
          ],
        ));
  }
}
