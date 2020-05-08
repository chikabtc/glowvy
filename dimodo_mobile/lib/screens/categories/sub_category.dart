import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/category.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<Widget> _tabView;
  int currentPage = 0;
  bool isAscending = false;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";

  Category currentCate;

  @override
  void initState() {
    super.initState();
    currentCate = widget.category;
    print("currentCate Id: ${widget.category.id}");
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // loadTabViews();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("build");
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .body2
        .copyWith(fontSize: 15, color: kDefaultFontColor);

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
                  title: DynamicText(widget.category.name,
                      style: textStyle.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(40.0),
                    child: Container(
                      height: 40,
                      color: Colors.white,
                      child: Row(
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
                                  color:
                                      isAscending ? Colors.white : kLightPink,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                height: 24,
                                // width: 98,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(color: Colors.transparent, height: 14),
                    ProductModel.showProductListByCategory(
                        cateId: currentCate.id,
                        sortBy: isAscending ? highToLow : lowToHigh,
                        limit: 2500,
                        context: context)
                  ]),
                ),
              ])),
    );
  }

  List<Widget> renderTabbar() {
    List<Widget> list = [];

    widget.category.subCategories.asMap().forEach((index, item) {
      list.add(Container(
        child: Tab(
            child: DynamicText(currentCate.name,
                style: kBaseTextStyle.copyWith(
                    fontSize: 13,
                    color: currentPage == index ? kPinkAccent : kDarkSecondary,
                    fontWeight: FontWeight.w600))),
      ));
    });
    return list;
  }

  @override
  bool get wantKeepAlive => true;
}
