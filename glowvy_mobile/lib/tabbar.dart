import 'dart:io';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/sizeConfig.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/category.dart';
import 'package:Dimodo/screens/profile.dart';
import 'package:Dimodo/screens/search_screen.dart';
import 'package:Dimodo/screens/write_review_screen.dart';
import 'package:Dimodo/widgets/bottom_navigation_bar_root_item.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'models/app.dart';
import 'screens/home.dart';

class MainTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainTabsState();
  }
}

class MainTabsState extends State<MainTabs>
    with AfterLayoutMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 0;
  TabController _tabController;
  AnimationController controller;
  final ScrollController _scrollController = ScrollController();

  List<Widget> _tabView = [];
  UserModel userModel;
  List<BottomNavigationBarRootItem> _bottomNavigationBarRootItems = [];
  PageController _pageController;

  List<BuildContext> navStack = [null, null, null, null];

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(0,
        duration: const Duration(microseconds: 10000), curve: Curves.ease);
    userModel = Provider.of<UserModel>(context, listen: false);
    _pageController = PageController(initialPage: 0);

    _tabView = <Widget>[
      HomeScreen(
        appScrollController: _scrollController,
      ),
      SearchScreen(
        appScrollController: _scrollController,
      ),
      SlideTransition(
          position: Tween(begin: Offset.zero, end: const Offset(0.0, 1.0))
              .chain(CurveTween(curve: Curves.ease))
              .animate(controller),
          child: WriteReviewScreen()),
      ProfilePage(
        appScrollController: _scrollController,
      )
    ];

    setTabBars();
  }

  // Route _createRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => Page2(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = Offset(0.0, 1.0);
  //       var end = Offset.zero;
  //       var curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // addAnimationToPage(page) {

  // var begin = Offset(0.0, 1.0);
  // var end = Offset.zero;
  // var tween = Tween(begin: begin, end: end);
  // var offsetAnimation = animation.drive(tween);

  // return SlideTransition(
  //   position: offsetAnimation,
  //   child: child,
  // );

  @override
  void afterFirstLayout(BuildContext context) {
    print('after first layout!!');
    // loadTabBar(userModel);
  }

  Widget tabView(userModel, Map<String, dynamic> data) {
    switch (data['layout']) {
      case 'category':
        return CategoryScreen();
      case 'search':
        return SearchScreen();
      case 'add':
        return WriteReviewScreen();
      case 'profile':
        return const ProfilePage();
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    kSizeConfig = SizeConfig(screenSize);

    if (_tabView.isEmpty) return Container();

    return Consumer<UserModel>(builder: (context, userModel, child) {
      return Container(
        child: WillPopScope(
          onWillPop: () async {
            if (_tabController.index == 0) {
              setState(() {
                _currentPage = _tabController.index;
              });
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return true;
            } else if (Navigator.of(navStack[_tabController.index]).canPop()) {
              Navigator.of(navStack[_tabController.index]).pop();
              setState(() {
                _currentPage = _tabController.index;
                _pageController.jumpToPage(_currentPage);
              });
              return false;
            } else {
              // close the app
              _tabController.index =
                  0; // back to first tap if current tab history stack is empty
              setState(() {
                _currentPage = _tabController.index;
                _pageController.jumpToPage(_currentPage);
              });
              return false;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            body: PageView(
              controller: _pageController,
              children: _tabView,
              physics: const NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: SafeArea(
                bottom: true,
                child: Container(
                  height: 49,
                  child: Column(
                    children: [
                      kFullSectionDivider,
                      BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: kBottomNavBarColor,
                        items: _bottomNavigationBarRootItems
                            .map((e) => e.bottomNavigationBarItem)
                            .toList(),
                        fixedColor: kPrimaryOrange,
                        elevation: 0,
                        selectedFontSize: 1,
                        unselectedFontSize: 1,
                        currentIndex: _currentPage,
                        onTap: _onItemTapped,
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        selectedLabelStyle: textTheme.bodyText2.copyWith(
                          fontFamily: 'Nunito',
                          height: 1.25,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          color: kDefaultFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                        // selectedItemColor: kDefaultFontColor,
                        unselectedItemColor: Color(0x3C3C43).withOpacity(0.6),
                        unselectedLabelStyle: textTheme.bodyText2.copyWith(
                          fontFamily: 'Nunito',
                          height: 1.25,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          color: Color(0x3C3C43).withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void setTabBars() {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;

    tabData.asMap().forEach((index, item) {
      final value = index == 3
          ? 24.0
          : index == 1
              ? 28.0
              : 26.0;
      _bottomNavigationBarRootItems.add(
        BottomNavigationBarRootItem(
            routeName: null,
            nestedNavigator: null,
            bottomNavigationBarItem: BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Container(
                    child: SvgPicture.asset(
                      item['active-icon'],
                      color: kPrimaryOrange,
                      width: value,
                      height: value,
                    ),
                  ),
                ),
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SvgPicture.asset(
                    item['icon'],
                    color: Color(0x3C3C43).withOpacity(0.6),
                    width: value,
                    height: value,
                  ),
                ),
                label: item['name'])),
      );
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          WriteReviewScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (_currentPage == index) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } else if (index == 2) {
      //push the page from the bottom
      Navigator.of(context).push(_createRoute());
    } else {
      navStack[index] = context;
      _tabController.index = index;
      setState(() => _currentPage = index);
      _pageController.jumpToPage(index);
    }
  }
}

abstract class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const NestedNavigator({Key key, @required this.navigatorKey})
      : super(key: key);
}

class HomeNavigator extends NestedNavigator {
  const HomeNavigator(
      {Key key, @required GlobalKey<NavigatorState> navigatorKey})
      : super(
          key: key,
          navigatorKey: navigatorKey,
        );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => HomeScreen();
            break;
          case '/search':
            builder = (BuildContext context) => SearchScreen();
            break;
          case '/profile':
            builder = (BuildContext context) => const ProfilePage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
    );
  }
}
