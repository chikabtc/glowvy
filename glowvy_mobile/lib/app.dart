import 'dart:async';
import 'dart:ui';

import 'package:Dimodo/models/product/review_model.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/screens/category.dart';
import 'package:Dimodo/screens/glowvy-onboard.dart';
import 'package:Dimodo/screens/search_screen.dart';
import 'package:Dimodo/screens/setting/forgot_password.dart';
import 'package:Dimodo/screens/setting/reset_password.dart';
import 'package:Dimodo/screens/setting/verify_email.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/config.dart';
import 'common/styles.dart';
import 'generated/i18n.dart';
import 'models/address/addressModel.dart';
import 'models/app.dart';
import 'models/categoryModel.dart';
import 'models/order/cart.dart';
import 'models/order/orderModel.dart';
import 'models/product/productModel.dart';
import 'models/product/recent_product.dart';
import 'models/user/userModel.dart';
import 'models/wishlist.dart';
import 'screens//setting/login.dart';
import 'screens/profile.dart';
import 'screens/setting/signup.dart';
import 'tabbar.dart';

class Glowvy extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<Glowvy> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final analytics = FirebaseAnalytics();

    return MaterialApp(
        title: 'Glowvy',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GlowvyState();
  }
}

class GlowvyState extends State<MyApp> with AfterLayoutMixin {
  final _app = AppModel();
  final _addressModel = AddressModel();
  final _userModel = UserModel();
  final _product = ProductModel();
  final _review = ReviewModel();
  final _wishlist = WishListModel();
  final _order = OrderModel();

  final _recent = RecentModel();
  final _search = SearchModel();
  bool isFirstSeen = false;
  bool isChecking = true;
  bool isLoggedIn = false;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void afterFirstLayout(BuildContext context) async {
    await _app.loadAppConfig();
    await _userModel.initData();
    await _addressModel.setProvinces();
    await _search.setBrands();
    await _search.setLocalCategories();
    await precacheImage(
        const AssetImage('assets/icons/default-avatar.png'), context);
    isFirstSeen = await checkFirstSeen();
    isLoggedIn = await checkLogin();
    setState(() {
      isChecking = false;
    });
  }

  Future checkFirstSeen() async {
    final storage = LocalStorage('Dimodo');
    final ready = await storage.ready;

    final _seen = storage.getItem('seen') ?? false;
    print('isSeen?: ${storage.getItem('seen')}?');

    if (_seen) {
      return false;
    } else {
      await storage.setItem('seen', true);

      return true;
    }
  }

  Future checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Widget renderFirstScreen() {
    if (isFirstSeen) return GlowvyOnBoardScreen();
    if (kAdvanceConfig['IsRequiredLogin'] && !isLoggedIn) {
      return const LoginScreen();
    }
    final data = MediaQuery.of(context).copyWith(textScaleFactor: 1);

    return MediaQuery(data: data, child: MainTabs());
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark, // Only honored in Android M and above

        statusBarBrightness: Brightness.light));

    print('building app.dart');
    if (isChecking) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(),
        ),
      );
    }

    return ChangeNotifierProvider<AppModel>.value(
      value: _app,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Container(
              color: Colors.white,
            );
          }
          return MultiProvider(
            providers: [
              Provider<ProductModel>.value(value: _product),
              Provider<ReviewModel>.value(value: _review),
              Provider<WishListModel>.value(value: _wishlist),
              Provider<OrderModel>.value(value: _order),
              Provider<RecentModel>.value(value: _recent),
              ChangeNotifierProvider(create: (_) => _addressModel),
              ChangeNotifierProvider(create: (_) => _userModel),
              ChangeNotifierProvider(create: (_) => CartModel()),
              ChangeNotifierProvider(create: (_) => _search),
            ],
            child: GestureDetector(
              onTap: () {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: Locale(
                    Provider.of<AppModel>(context, listen: false).locale, ''),
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                localeListResolutionCallback:
                    S.delegate.listResolution(fallback: const Locale('en', '')),
                home: renderFirstScreen(),
                onGenerateRoute: (settings) {
                  final arguments = settings.arguments;
                  switch (settings.name) {
                    // case '/add_address':
                    //   if (arguments is Address) {
                    //     print('bullshit2');

                    //     // the details page for one specific user
                    //     return MaterialPageRoute<bool>(
                    //         builder: (BuildContext context) =>
                    //             AddShippingAddress(
                    //               address: arguments,
                    //             ));
                    //   } else {
                    //     // a route showing the list of all users
                    //     return MaterialPageRoute<bool>(
                    //         builder: (BuildContext context) =>
                    //             AddShippingAddress());
                    //   }
                    //   break;
                    // case '/manage_address':
                    //   if (arguments is bool) {
                    //     print('bullshit');
                    //     return MaterialPageRoute<bool>(
                    //         builder: (BuildContext context) =>
                    //             ManageShippingScreen(
                    //               isFromOrderScreen: arguments,
                    //             ));
                    //   }

                    default:
                      return null;
                  }
                },
                routes: <String, WidgetBuilder>{
                  '/home': (context) => MainTabs(),
                  '/search_screen': (context) => SearchScreen(),
                  '/login': (context) => const LoginScreen(),
                  '/signup': (context) => const SignupScreen(),
                  '/setting': (context) => const ProfilePage(),
                  '/category': (context) => CategoryScreen(),
                  '/verify_email': (context) => const VerifyEmailScreen(),
                  '/reset_password': (context) => ResetPasswordScreen(),
                  '/forgot_password': (context) => ForgotPasswordScreen(),
                },
                theme: buildLightTheme(),
              ),
            ),
          );
        },
      ),
    );
  }
}
