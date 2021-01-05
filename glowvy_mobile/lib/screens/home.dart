import 'dart:io';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/birth_year_onboarding_page.dart';
import 'package:Dimodo/screens/inquiry_page.dart';
import 'package:Dimodo/widgets/personalized_survey.dart';
import 'package:Dimodo/widgets/product/products_list_view.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const HomeScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen>, TickerProviderStateMixin {
  Future<List<Product>> getProductByTagStar;
  Future<List<Product>> getProductByTagTrending;
  Future<List<Product>> getCosmeticsProductsByCategory;
  bool showTitle = false;

  List<Category> tabList = [];
  TabController _tabController;
  bool isLoading = true;
  bool isSurveyFinished = false;
  bool showFiltered = false;
  bool showRank = true;
  UserModel userModel;
  ProductModel productModel;
  List<Product> filteredResults = [];
  int currentCateId = 3;
  int skinTypeId = 0;
  Map<int, List<Product>> allProducts = {};
  List<Survey> surveys = [];

  bool isFiltering = false;
  final divider = const Divider(
    color: kQuaternaryGrey,
    height: 0.7,
    thickness: 0.7,
    indent: 15,
    endIndent: 15,
  );

  @override
  void initState() {
    super.initState();
    try {
      tabList = [];
      final tabs = Provider.of<SearchModel>(context, listen: false).categories;
      tabs.forEach((tab) {
        tabList.add(tab);
      });
    } catch (err) {
      final message =
          'Fail to fetch products from firestore: ' + err.toString();
      print('error: $message');
    }

    print('tabList : ${tabList.length}');

    _tabController = TabController(length: tabList.length, vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);
    productModel = Provider.of<ProductModel>(context, listen: false);

    Future.wait([
      productModel.getProductsByCategory(firstCategory: tabList[0]),
      productModel.getProductsByCategory(firstCategory: tabList[1]),
      productModel.getProductsByCategory(firstCategory: tabList[2]),
      productModel.getProductsByCategory(firstCategory: tabList[3]),
    ]).then((responses) {
      allProducts[1] = responses.first.itemList;
      allProducts[7] = responses[1].itemList;
      allProducts[8] = responses[2].itemList;
      allProducts[9] = responses[3].itemList;

      setState(() {
        isLoading = false;
      });
    });

    // try {
    //   final surveys = Provider.of<AppModel>(context, listen: false)
    //       .appConfig['Cosmetics_Survey'];
    //   for (var item in surveys) {
    //     this.surveys.add(Survey.fromJson(item));
    //   }
    // } catch (err) {
    //   var message =
    //       'There is an issue with the app during request the data, please contact admin for fixing the issues ' +
    //           err.toString();
    //   print('error: $message');
    // }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    kRateMyApp.init().then((_) {});

    final screenSize = MediaQuery.of(context).size;
    kScreenSizeWidth = screenSize.width;
    kScreenSizeHeight = screenSize.height;

    List<Widget> renderTabbar() {
      var list = <Widget>[];
      // for (var l; )

      tabList.asMap().forEach((index, item) {
        list.add(Tab(
          text: item.firstCategoryName,
        ));
      });
      return list;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserModel>(builder: (context, userModel, child) {
        return SafeArea(
            top: true,
            bottom: false,
            child: Container(
              color: kDefaultBackground,
              child: NestedScrollView(
                physics: const NeverScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        floating: false,
                        pinned: true,
                        elevation: 0,
                        leading: Container(),
                        backgroundColor: Colors.white,
                        title: AnimatedOpacity(
                          opacity: showTitle ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 100),
                          child: Text(
                            'Home',
                            style: textTheme.headline3,
                            textAlign: TextAlign.start,
                          ),
                        )),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 0, left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home',
                                style:
                                    textTheme.headline1.copyWith(fontSize: 32),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'weekly ranking',
                                style:
                                    textTheme.headline4.copyWith(fontSize: 22),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                        minHeight: 60,
                        maxHeight: 60,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                padding: const EdgeInsets.only(top: 5),
                                child: TabBar(
                                    controller: _tabController,
                                    indicator: const BubbleTabIndicator(
                                      indicatorHeight: 39.0,
                                      indicatorColor: kDarkAccent,
                                      tabBarIndicatorSize:
                                          TabBarIndicatorSize.tab,
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelPadding: const EdgeInsets.only(
                                      left: 18.0,
                                      right: 18.0,
                                      top: 5,
                                    ),
                                    isScrollable: true,
                                    indicatorColor: Colors.white,
                                    unselectedLabelColor: kSecondaryGrey,
                                    unselectedLabelStyle: textTheme.headline4
                                        .copyWith(
                                            color: kSecondaryGrey,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold),
                                    labelStyle: textTheme.headline4.copyWith(
                                        color: Colors.white,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold),
                                    labelColor: Colors.white,
                                    tabs: renderTabbar(),
                                    onTap: (index) {
                                      currentCateId =
                                          tabList[index].firstCategoryId;
                                      setState(() {
                                        showFiltered = false;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: isLoading
                    ? Container(
                        width: screenSize.width,
                        height: screenSize.height,
                        child: Center(
                          child: Container(
                              height: kScreenSizeHeight * 0.5,
                              child: const SpinKitThreeBounce(
                                  color: kPrimaryOrange, size: 21.0)),
                        ))
                    : TabBarView(
                        controller: _tabController,
                        children: tabList.map((Category category) {
                          return Builder(
                            builder: (BuildContext context) {
                              return NotificationListener(
                                onNotification:
                                    (ScrollUpdateNotification notification) {
                                  if (notification != null &&
                                      notification.metrics.axisDirection !=
                                          AxisDirection.left &&
                                      notification.metrics.axisDirection !=
                                          AxisDirection.right) {
                                    setState(() {
                                      if (notification.metrics.pixels > 52 &&
                                          !showTitle) {
                                        showTitle = true;
                                      } else if (notification.metrics.pixels <
                                              52 &&
                                          showTitle) {
                                        showTitle = false;
                                      }
                                    });
                                  }
                                },
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    if (!isLoading)
                                      ProductsListView(
                                        products: allProducts[
                                            category.firstCategoryId],
                                        showRank: true,
                                        disableScrolling: true,
                                        showFilter: false,
                                        showPadding: true,
                                      ),
                                    Container(height: 50),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 48, right: 48),
                                            child: Text(
                                              'Có vấn đề với ứng dụng? Hãy gửi mail cho nhà phát triển! Glowvy team sẽ phản hồi nhanh nhất có thể.',
                                              textAlign: TextAlign.center,
                                              style: textTheme.headline4
                                                  .copyWith(
                                                      color: kSecondaryGrey,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(height: 22),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InquiryPage()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 48, right: 48),
                                              child: Container(
                                                  height: 48,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Liên hệ nhà phát triển Glowvy',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textTheme.button
                                                          .copyWith(
                                                              color:
                                                                  kPrimaryOrange,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: kSecondaryOrange,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!isLoading)
                                      Column(
                                        children: [
                                          Container(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              Share.share(Platform.isAndroid
                                                  ? 'https://play.google.com/store/apps/details?id=app.dimodo.android&hl=en_US'
                                                  : 'https://apps.apple.com/us/app/id1506979635');
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              height: 48,
                                              child: Center(
                                                child: Text(
                                                    'Share with your friends',
                                                    style: textTheme.headline5
                                                        .copyWith(
                                                            color:
                                                                kSecondaryGrey)),
                                              ),
                                            ),
                                          ),
                                          divider,
                                          GestureDetector(
                                            onTap: () {
                                              kRateMyApp
                                                  .showRateDialog(context)
                                                  .then((v) => setState(() {}));
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              height: 48,
                                              child: Center(
                                                child: Text(
                                                    'Complement Glowvy!',
                                                    style: textTheme.headline5
                                                        .copyWith(
                                                            color:
                                                                kSecondaryGrey)),
                                              ),
                                            ),
                                          ),
                                          divider,
                                          Container(height: 50),
                                        ],
                                      )
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
              ),
            ));
      }),
    );
  }
}
