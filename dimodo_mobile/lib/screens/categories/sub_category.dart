import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/services/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/category.dart';
import 'package:provider/provider.dart';

class SubCategoryScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  final Category category;

  SubCategoryScreen({this.user, this.onLogout, this.category});

  @override
  State<StatefulWidget> createState() {
    return SubCategoryScreenState();
  }
}

class SubCategoryScreenState extends State<SubCategoryScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  bool isAscending = false;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";
  Future<List<Product>> getProductByTagTrending;
  Future<List<Product>> getProductsByCategoryId;
  Services service = Services();
  Category currentCate;

  @override
  void initState() {
    super.initState();

    currentCate = widget.category;
    if (currentCate.id == 0) {
      getProductByTagTrending =
          service.getProductsByTag(tag: 5, sortBy: "sale_price");
    }

    getProductsByCategoryId = service.getProductsByCategory(
        categoryId: currentCate.id, sortBy: lowToHigh, start: 0, limit: 12);
  }

  void onLoadMore(start, limit) {
    Provider.of<ProductModel>(context, listen: false).fetchProductsByCategory(
      categoryId: currentCate.id,
      sortBy: isAscending ? highToLow : lowToHigh,
      start: start,
      limit: limit,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var isNameAvailable = widget.category.id == 8 ? true : false;

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: CommonIcons.arrowBackward,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          // pinned: true,
          title: DynamicText(currentCate.name,
              style: kBaseTextStyle.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(66.0),
            child: Container(
              height: 66,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTabController(
                    length: widget.category.subCategories.length + 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                        isScrollable: true,
                        indicatorColor: kDarkAccent,
                        unselectedLabelColor: Colors.black,
                        unselectedLabelStyle:
                            kBaseTextStyle.copyWith(color: kDarkSecondary),
                        labelStyle: kBaseTextStyle,
                        labelColor: kPinkAccent,
                        onTap: (i) {
                          setState(() {
                            currentIndex = i;
                            currentCate = i == 0
                                ? widget.category
                                : widget.category.subCategories[i - 1];
                            getProductsByCategoryId =
                                service.getProductsByCategory(
                                    categoryId: currentCate.id,
                                    sortBy: lowToHigh,
                                    start: 0,
                                    limit: 6);
                          });
                        },
                        tabs: renderTabbar(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ProductModel.showProductList(
            onLoadMore: onLoadMore,
            showFiler: true,
            future: currentCate.id == 0
                ? getProductByTagTrending
                : getProductsByCategoryId,
            isNameAvailable: true));
  }

  List<Widget> renderTabbar() {
    List<Widget> tabBars = [];

    var allBtn = Container(
      child: Tab(
        child: DynamicText("all",
            style: kBaseTextStyle.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: currentIndex == 0 ? kDarkAccent : kDarkSecondary,
            )),
      ),
    );
    tabBars.add(allBtn);

    widget.category.subCategories.asMap().forEach((index, element) {
      var btn = Container(
        child: Tab(
          child: DynamicText(widget.category.subCategories[index].name,
              style: kBaseTextStyle.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: currentIndex == index + 1 ? kDarkAccent : kDarkSecondary,
              )),
        ),
      );

      tabBars.add(btn);
    });
    return tabBars;
  }

  @override
  bool get wantKeepAlive => true;
}
