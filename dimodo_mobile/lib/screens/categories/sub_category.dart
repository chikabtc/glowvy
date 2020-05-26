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
import 'package:after_layout/after_layout.dart';
import 'package:Dimodo/generated/i18n.dart';

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
    with
        WidgetsBindingObserver,
        AfterLayoutMixin,
        AutomaticKeepAliveClientMixin {
  int currentPage = 0;
  bool isAscending = false;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";
  Future<List<Product>> getProductByTagTrending;
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
    print("subcategelnght: ${widget.category.subCategories.length}");
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  List<Widget> renderSubCategoriesBtns() {
    List<Widget> subCateBtns = [];
    widget.category.subCategories.forEach((element) {
      var btn = Container(
        padding: EdgeInsets.only(left: 30),
        height: 34,
        child: DynamicText(element.name,
            style: kBaseTextStyle.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: kDarkAccent,
              decoration: TextDecoration.underline,
            )),
      );

      subCateBtns.add(btn);
    });
    return subCateBtns;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("build");
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .body2
        .copyWith(fontSize: 15, color: kDefaultFontColor);
    var isNameAvailable = widget.category.id == 8 ? true : false;

    return Scaffold(
      body: Container(
          color: kDefaultBackground,
          width: screenSize.width,
          height: screenSize.height,
          child: CustomScrollView(
              //use the delegate builder for the boy
              slivers: [
                SliverAppBar(
                  brightness: Brightness.light,
                  leading: IconButton(
                    icon: CommonIcons.arrowBackward,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  pinned: true,
                  title: DynamicText(currentCate.name,
                      style: textStyle.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(90.0),
                    child: Container(
                      height: 90,
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
                                // indicator: UnderlineTabIndicator(
                                //   borderSide:
                                //       BorderSide(width: 2.0, color: kDarkAccent),
                                // ),
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 5.0),
                                isScrollable: true,
                                indicatorColor: kDarkAccent,
                                unselectedLabelColor: Colors.black,
                                unselectedLabelStyle: kBaseTextStyle.copyWith(
                                    color: kDarkSecondary),
                                labelStyle: kBaseTextStyle,
                                labelColor: kPinkAccent,
                                onTap: (i) {
                                  setState(() {
                                    currentPage = i;
                                    currentCate = i == 0
                                        ? widget.category
                                        : widget.category.subCategories[i - 1];
                                  });
                                },
                                tabs: renderTabbar(),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  //reload the list with different sorting
                                  setState(() {
                                    isAscending = !isAscending;
                                  });
                                },
                                child: Container(
                                    decoration: new BoxDecoration(
                                      color: isAscending
                                          ? Colors.white
                                          : kLightPink,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    height: 24,
                                    // width: 98,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // isAscending
                                        //     ? Image.asset(
                                        //         "assets/icons/filter-sort.png")
                                        Image.asset(
                                            "assets/icons/filter-sort-active.png"),
                                        DynamicText(
                                          isAscending
                                              ? S.of(context).highestToLowest
                                              : S.of(context).lowestToHighest,
                                          textAlign: TextAlign.center,
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 12,
                                              color: isAscending
                                                  ? kDarkSecondary
                                                  : kDarkAccent),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(width: 16)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(color: Colors.transparent, height: 14),
                    currentCate.id == 0
                        ? ProductModel.showProductList(
                            future: getProductByTagTrending,
                            isNameAvailable: true)
                        : ProductModel.showProductListByCategory(
                            cateId: currentCate.id,
                            sortBy: isAscending ? highToLow : lowToHigh,
                            limit: 2500,
                            isNameAvailable: isNameAvailable,
                            context: context),
                  ]),
                ),
              ])),
    );
  }

  List<Widget> renderTabbar() {
    List<Widget> tabBars = [];

    var allBtn = Container(
      child: Tab(
        child: DynamicText("All",
            style: kBaseTextStyle.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: currentPage == 0 ? kDarkAccent : kDarkSecondary,
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
                color: currentPage == index + 1 ? kDarkAccent : kDarkSecondary,
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
