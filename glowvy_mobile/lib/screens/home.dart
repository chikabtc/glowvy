import 'dart:io';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/inquiry_page.dart';
import 'package:Dimodo/widgets/product/products_list_view.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class CustomAppBar extends PreferredSize {
  final Widget leading;
  final Widget title;
  final Color backgroundColor;

  CustomAppBar(
      {@required this.leading,
      this.title,
      this.backgroundColor = Colors.transparent});

  @override
  Size get preferredSize => Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        leading: leading,
        title: title,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  final ScrollController appScrollController;

  const HomeScreen({this.user, this.onLogout, this.appScrollController});

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
  final _scrollController = ScrollController();

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
      productModel.getProductsByCategory(tabList[0]),
      productModel.getProductsByCategory(tabList[1]),
      productModel.getProductsByCategory(tabList[2]),
      productModel.getProductsByCategory(tabList[3]),
    ]).then((responses) {
      allProducts[1] = responses.first.itemList;
      allProducts[7] = responses[1].itemList;
      allProducts[8] = responses[2].itemList;
      allProducts[9] = responses[3].itemList;

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
          text: item.name,
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
              child: NotificationListener(
                onNotification: (ScrollUpdateNotification notification) {
                  if (notification != null &&
                      notification.metrics.axisDirection !=
                          AxisDirection.left &&
                      notification.metrics.axisDirection !=
                          AxisDirection.right) {
                    setState(() {
                      if (notification.metrics.pixels > 38 && !showTitle) {
                        showTitle = true;
                      } else if (notification.metrics.pixels < 38 &&
                          showTitle) {
                        showTitle = false;
                      }
                    });
                  }
                },
                child: NestedScrollView(
                  controller: widget.appScrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          floating: false,
                          pinned: true,
                          elevation: 0,
                          titleSpacing: 0,
                          leading: Container(),
                          backgroundColor: Colors.white,
                          centerTitle: true,
                          title: AnimatedOpacity(
                            opacity: showTitle ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () {
                                Tools.scrollToTop(widget.appScrollController);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    // color: Colors.red,

                                    child: Text(
                                      'Home',
                                      style: textTheme.bodyText1.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
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
                                  style: textTheme.headline1.copyWith(
                                      fontSize: 32,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'weekly ranking',
                                  style: textTheme.headline4.copyWith(
                                      fontSize: 22,
                                      fontStyle: FontStyle.normal),
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
                          child: Container(
                            height: 60,
                            color: Colors.white,
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
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
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
                                        unselectedLabelStyle:
                                            textTheme.headline4.copyWith(
                                                color: kSecondaryGrey,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.bold),
                                        labelStyle: textTheme.headline4
                                            .copyWith(
                                                color: Colors.white,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.bold),
                                        labelColor: Colors.white,
                                        tabs: renderTabbar(),
                                        onTap: (index) {
                                          currentCateId = tabList[index].id;
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
                      ),
                    ];
                  },
                  body: isLoading
                      ? Container(
                          width: screenSize.width,
                          height: screenSize.height,
                          child: Center(
                            child: Container(
                                // height: kScreenSizeHeight * 0.35,
                                child: kIndicator()),
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: TabBarView(
                            controller: _tabController,
                            physics: Platform.isAndroid
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            children: tabList.map((Category category) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Scrollbar(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          ProductsListView(
                                            products: allProducts[category.id],
                                            disableScrolling: true,
                                            showPadding: true,
                                            showRank: true,
                                          ),
                                          Container(
                                            height: 50,
                                          ),
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
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ),
            ));
      }),
    );
  }
}
