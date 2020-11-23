import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/sizeConfig.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/category.dart';
import 'package:Dimodo/screens/profile.dart';
import 'package:Dimodo/screens/search_screen.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'models/app.dart';
import 'models/order/cart.dart';
import 'screens/home.dart';

class MainTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainTabsState();
  }
}

class MainTabsState extends State<MainTabs> with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0;
  String currentTitle = 'Home';
  Color currentColor = Colors.deepPurple;
  bool isAdmin = false;
  final List<Widget> _tabView = [];
  UserModel userModel;

  @override
  void afterFirstLayout(BuildContext context) {
    print('after first layout!!');
    loadTabBar(userModel);
  }

  Widget tabView(userModel, Map<String, dynamic> data) {
    switch (data['layout']) {
      case 'category':
        return CategoryScreen();
      case 'search':
        return SearchScreen();
      case 'profile':
        return ProfilePage();
      case 'dynamic':
      default:
        return HomeScreen();
    }
  }

  void loadTabBar(userModel) {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;
    for (var i = 0; i < tabData.length; i++) {
      setState(() {
        _tabView.add(tabView(userModel, Map.from(tabData[i])));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    kSizeConfig = SizeConfig(screenSize);

    if (_tabView.isEmpty) return Container();

    return Consumer<UserModel>(builder: (context, userModel, child) {
      return Container(
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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: kDarkSecondary.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
            ),
            width: screenSize.width,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Container(
                  height: 60,
                  color: Colors.white,
                  width: screenSize.width /
                      (2 / (screenSize.height / screenSize.width)),
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    tabs: renderTabbar(),
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: Colors.transparent,
                  )),
            ),
          ),
        ),
      ));
    });
  }

  List<Widget> renderTabbar() {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;
    var list = <Widget>[];

    tabData.asMap().forEach((index, item) {
      list.add(Stack(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 35,
              padding: EdgeInsets.only(top: 11, bottom: 4),
              child: SvgPicture.asset(
                currentPage == index ? item['active-icon'] : item['icon'],
                color:
                    currentPage == index ? kDefaultFontColor : kSecondaryGrey,
                width: 24 * kSizeConfig.containerMultiplier,
                height: 24 * kSizeConfig.containerMultiplier,
              ),
            ),
            Text(
              item['name'],
              style: textTheme.bodyText2.copyWith(
                fontFamily: 'Nunito',
                height: 1.25,
                fontStyle: FontStyle.normal,
                fontSize: 10.0 * kSizeConfig.textMultiplier,
                color:
                    currentPage == index ? kDefaultFontColor : kSecondaryGrey,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        if (item['layout'] == 'cart')
          Consumer<CartModel>(builder: (context, cartModel, child) {
            return Positioned(
                right: 0,
                top: 0,
                child: cartModel.totalCartQuantity > 0
                    ? Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartModel.totalCartQuantity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container());
          }),
      ]));
    });

    return list;
  }
}
