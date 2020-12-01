import 'dart:io' show Platform;

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/inquiry_page.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
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
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

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
      final tabs =
          Provider.of<CategoryModel>(context, listen: false).categories;
      tabs.forEach((tab) {
        tabList.add(tab);
      });
    } catch (err) {
      final message =
          'Fail to fetch products from firestore: ' + err.toString();
      print('error: $message');
    }

    _tabController = TabController(length: tabList.length, vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);
    productModel = Provider.of<ProductModel>(context, listen: false);

    Future.wait([
      productModel.getProductsByCategoryId(1, isFirstCate: true),
      productModel.getProductsByCategoryId(7, isFirstCate: true),
      productModel.getProductsByCategoryId(8, isFirstCate: true),
      productModel.getProductsByCategoryId(9, isFirstCate: true),
    ]).then((responses) {
      allProducts[1] = responses.first;
      allProducts[7] = responses[1];
      allProducts[8] = responses[2];
      allProducts[9] = responses[3];
      print('eweweweweew ${allProducts[1].length}');
      setState(() {
        isLoading = false;
      });
    });
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
                              style: textTheme.headline1.copyWith(fontSize: 32),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'weekly ranking',
                              style: textTheme.headline4.copyWith(fontSize: 22),
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
                  : NotificationListener(
                      onNotification: (ScrollUpdateNotification notification) {
                        if (notification != null &&
                            notification.metrics.axisDirection !=
                                AxisDirection.left &&
                            notification.metrics.axisDirection !=
                                AxisDirection.right) {
                          setState(() {
                            if (notification.metrics.pixels > 52 &&
                                !showTitle) {
                              showTitle = true;
                              print('show title');
                            } else if (notification.metrics.pixels < 52 &&
                                showTitle) {
                              showTitle = false;
                              print('dont show title:');
                            }
                          });
                        }
                      },
                      child: TabBarView(
                        controller: _tabController,
                        children: tabList.map((Category category) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  if (!isLoading)
                                    CosmeticsProductList(
                                      products:
                                          allProducts[category.firstCategoryId],
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
                                          padding: EdgeInsets.only(
                                              left: 48, right: 48),
                                          child: Text(
                                            'Có vấn đề với ứng dụng? Hãy gửi mail cho nhà phát triển! Glowvy team sẽ phản hồi nhanh nhất có thể.',
                                            textAlign: TextAlign.center,
                                            style: textTheme.headline4.copyWith(
                                                color: kSecondaryGrey,
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600),
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
                                                    textAlign: TextAlign.center,
                                                    style: textTheme.button1
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
                                              child: Text('Complement Glowvy!',
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
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
