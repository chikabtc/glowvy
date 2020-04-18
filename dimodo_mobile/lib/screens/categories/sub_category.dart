import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/models/category.dart';
import 'package:after_layout/after_layout.dart';

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
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(color: Colors.transparent, height: 21),
                    ProductModel.showProductListByCategory(
                        cateId: currentCate.id, context: context)
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
