import 'package:Dimodo/screens/category.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/sizeConfig.dart';
import 'package:provider/provider.dart';
import 'common/config.dart' as config;
import 'common/constants.dart';
import 'models/order/cart.dart';
import 'models/categoryModel.dart';
import 'screens/cart.dart';
import 'screens/home.dart';
import 'screens/user.dart';
import 'models/app.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/models/user/userModel.dart';

class MainTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainTabsState();
  }
}

class MainTabsState extends State<MainTabs> with AfterLayoutMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0;
  String currentTitle = "Home";
  Color currentColor = Colors.deepPurple;
  bool isAdmin = false;
  List<Widget> _tabView = [];

  @override
  void afterFirstLayout(BuildContext context) {
    print("after first layout!!");
    loadTabBar();
    print("locale: ${Provider.of<AppModel>(context, listen: false).locale}");
    // Provider.of<CategoryModel>(context, listen: false).getLocalCategories(
    //     context,
    //     lang: Provider.of<AppModel>(context, listen: false).locale);
    //wait for the user to login..
    Future.delayed(const Duration(milliseconds: 1000), () {
      Provider.of<CartModel>(context, listen: false)
          .getAllCartItems(Provider.of<UserModel>(context, listen: false));
    });
  }

  Widget tabView(Map<String, dynamic> data) {
    switch (data['layout']) {
      case 'category':
        return CategoryScreen();
      case 'cart':
        return CartScreen();
      case 'profile':
        return UserScreen();
      case 'dynamic':
      default:
        return HomeScreen();
    }
  }

  void loadTabBar() {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;
    for (var i = 0; i < tabData.length; i++) {
      setState(() {
        _tabView.add(tabView(Map.from(tabData[i])));
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    kSizeConfig = SizeConfig(screenSize);

    if (_tabView.length < 1) return Container();

    return Container(
        color: Colors.white,
        child: DefaultTabController(
          length: _tabView.length,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: _tabView,
            ),
            // bottomNavigationBar: Container(
            //   color: Colors.white,
            //   width: screenSize.width,
            //   child: SafeArea(
            //     bottom: true,
            //     child: FittedBox(
            //       child: Container(
            //           height: 50,
            //           color: Colors.white,
            //           width: screenSize.width /
            //               (2 / (screenSize.height / screenSize.width)),
            //           child: TabBar(
            //             onTap: (index) {
            //               setState(() {
            //                 currentPage = index;
            //               });
            //             },
            //             tabs: renderTabbar(),
            //             labelColor: Colors.red,
            //             unselectedLabelColor: Colors.white,
            //             indicatorColor: Colors.transparent,
            //           )),
            //     ),
            //   ),
            // ),
          ),
        ));
  }

  List<Widget> renderTabbar() {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;
    List<Widget> list = [];

    tabData.asMap().forEach((index, item) {
      list.add(Tab(
          // iconMargin: EdgeInsets.only(bottom: 0),
          child: Stack(children: <Widget>[
        Container(
          width: 35,
          padding: const EdgeInsets.all(6.0),
          child: SvgPicture.asset(
            currentPage == index ? item["active-icon"] : item["icon"],
            // color:  ? Colors.black : kDarkSecondary,
            width: 24 * kSizeConfig.containerMultiplier,
            height: 24 * kSizeConfig.containerMultiplier,
          ),
        ),
        if (item["layout"] == "cart")
          Consumer<CartModel>(builder: (context, cartModel, child) {
            return Positioned(
                right: 0,
                top: 0,
                child: cartModel.totalCartQuantity > 0
                    ? Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: new Text(
                          cartModel.totalCartQuantity.toString(),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container());
          }),
      ])));
    });

    return list;
  }
}
