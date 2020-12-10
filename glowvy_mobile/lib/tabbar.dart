import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/sizeConfig.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/category.dart';
import 'package:Dimodo/screens/profile.dart';
import 'package:Dimodo/screens/search_screen.dart';
import 'package:Dimodo/widgets/bottom_navigation_bar_root_item.dart';
import 'package:after_layout/after_layout.dart';
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
  int _selectedIndex = 0;
  TabController _tabController;
  List<Widget> _tabView = [];
  UserModel userModel;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  List<BottomNavigationBarRootItem> _bottomNavigationBarRootItems = [];

  List<BuildContext> navStack = [null, null, null];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);
    _tabView = <Widget>[
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          navStack[0] = context;
          return const HomeScreen();
        });
      }),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          navStack[1] = context;
          return SearchScreen();
        });
      }),
      Navigator(onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {
          // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
          navStack[2] = context;
          return const ProfilePage();
        });
      }),
    ];
    setTabBars();
  }

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
      case 'profile':
        return const ProfilePage();
      case 'dynamic':
      default:
        return const HomeScreen();
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
            if (Navigator.of(navStack[_tabController.index]).canPop()) {
              Navigator.of(navStack[_tabController.index]).pop();
              setState(() {
                _selectedIndex = _tabController.index;
              });
              return false;
            } else {
              if (_tabController.index == 0) {
                setState(() {
                  _selectedIndex = _tabController.index;
                });
                await SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop'); // close the app
                return true;
              } else {
                _tabController.index =
                    0; // back to first tap if current tab history stack is empty
                setState(() {
                  _selectedIndex = _tabController.index;
                });
                return false;
              }
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: _tabView,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              items: _bottomNavigationBarRootItems
                  .map((e) => e.bottomNavigationBarItem)
                  .toList(),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 36,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedLabelStyle: textTheme.bodyText2.copyWith(
                fontFamily: 'Nunito',
                height: 1.25,
                fontStyle: FontStyle.normal,
                fontSize: 12,
                color: kDefaultFontColor,
                fontWeight: FontWeight.w600,
              ),
              selectedItemColor: kDefaultFontColor,
              unselectedItemColor: kSecondaryGrey,
              unselectedLabelStyle: textTheme.bodyText2.copyWith(
                fontFamily: 'Nunito',
                height: 1.25,
                fontStyle: FontStyle.normal,
                fontSize: 12,
                color: kSecondaryGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onItemTapped(int index) {
    _tabController.index = index;
    setState(() => _selectedIndex = index);
  }

  void setTabBars() {
    final tabData = Provider.of<AppModel>(context, listen: false)
        .appConfig['TabBar'] as List;

    tabData.asMap().forEach((index, item) {
      _bottomNavigationBarRootItems.add(BottomNavigationBarRootItem(
          bottomNavigationBarItem: BottomNavigationBarItem(
              activeIcon: Container(
                height: 35,
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: SvgPicture.asset(
                  item['active-icon'],
                  color: kDefaultFontColor,
                  width: 24,
                  height: 24,
                ),
              ),
              icon: Container(
                width: 35,
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: SvgPicture.asset(
                  item['icon'],
                  color: kSecondaryGrey,
                  width: 24,
                  height: 24,
                ),
              ),
              label: item['name']),
          nestedNavigator: null,
          routeName: null));
    });
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
            builder = (BuildContext context) => const HomeScreen();
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
