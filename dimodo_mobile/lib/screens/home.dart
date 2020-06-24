import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/personalized_survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter/services.dart';
import 'package:Dimodo/services/index.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  HomeScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with
        AutomaticKeepAliveClientMixin<HomeScreen>,
        SingleTickerProviderStateMixin {
  Services service = Services();
  Future<List<Product>> getProductByTagStar;
  Future<List<Product>> getProductByTagTrending;
  Future<List<Product>> getCosmeticsProductsByCategory;
  var bottomPopupHeightFactor;
  List<String> tabList = [];
  var currentIndex = 0;
  TabController _tabController;

  bool isGenerating = false;
  bool isSurveyFinished = false;
  UserModel userModel;
  ProductModel productModel;
  List<Survey> surveys = [];

  @override
  void initState() {
    super.initState();
    getProductByTagStar = service.getProductsByTag(tag: 6, sortBy: "id");
    getCosmeticsProductsByCategory = service.getCosmeticsProductsByCategory(
        categoryId: 32, skinType: "sensitive");
    getProductByTagTrending =
        service.getProductsByTag(tag: 5, sortBy: "id", start: 0, count: 200);
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);

    productModel = Provider.of<ProductModel>(context, listen: false);
  }

  @override
  bool get wantKeepAlive => true;

  void onLoadMore(start, limit) {
    Provider.of<ProductModel>(context, listen: false).getProductsByTag(
      tag: 5,
      sortBy: "id",
      start: start,
      limit: limit,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      print("cosmetics pref: ${userModel.cosmeticPref}");
    });

    super.build(context);
    print("building home");
    kRateMyApp.init().then((_) {});

    final screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light) // Or Brightness.dark
        );

    try {
      final surveys = Provider.of<AppModel>(context, listen: false)
          .appConfig['Cosmetics_Survey'];
      print("surveys: $surveys");
      for (var item in surveys) {
        this.surveys.add(Survey.fromJson(item));
      }
    } catch (err) {
      var message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("error: $message");
    }
    try {
      tabList = [];
      final tabs = Provider.of<AppModel>(context, listen: false)
          .appConfig['Home_tabs'] as List;
      for (var tab in tabs) {
        tabList.add(tab["name"]);
      }
    } catch (err) {
      var message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("error: $message");
    }

    List<Widget> renderTabbar() {
      List<Widget> list = [];

      tabList.asMap().forEach((index, item) {
        list.add(Container(
          alignment: Alignment.center,
          height: 40,
          child: Tab(
            child: DynamicText(item,
                style: kBaseTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: currentIndex == index ? kDarkAccent : kDarkSecondary,
                )),
          ),
        ));
      });
      return list;
    }

    _generatePersonalizedPackages() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: isGenerating
                          ? DynamicText(
                              "Generating your personal cosmetic packages...",
                              overflow: TextOverflow.ellipsis,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 13, fontWeight: FontWeight.w500))
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                DynamicText("${userModel.cosmeticPref}",
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                DynamicText("(Last Update 22/06 10:00)",
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 10,
                                        color: kDarkSecondary.withOpacity(0.5),
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                    ),
                    if (!isGenerating)
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 26,
                            padding: EdgeInsets.only(
                                top: 2, bottom: 2, left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                color: kPinkAccent),

                            alignment: Alignment.center,
                            // nip: BubbleNip.rightTop,
                            child: Text(S.of(context).seeAll,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                          IconButton(
                            onPressed: () => print("show all!"),
                            icon: CommonIcons.arrowForward,
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            isGenerating
                ? productModel.showGeneartingProductList()
                : productModel.showProductList(
                    isNameAvailable: true,
                    isListView: true,
                    future: getCosmeticsProductsByCategory,
                    onLoadMore: onLoadMore),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: Container(),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(
            child: SafeArea(
              top: true,
              child: Image.asset(
                "assets/images/applogo.png",
                fit: BoxFit.cover,
                height: 12,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/icons/search/search.png",
                fit: BoxFit.cover,
                height: 24,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        body: Container(
          color: kLightBG,
          width: screenSize.width,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              var productModel =
                  Provider.of<ProductModel>(context, listen: false);

              if (!productModel.isFetching &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {}
              return false;
            },
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        width: screenSize.width,
                        child: Image.asset(
                          "assets/images/home_top_banner.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, top: 15, bottom: 15),
                        color: Colors.white,
                        width: screenSize.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DynamicText(
                              S.of(context).dimodoSupport,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: kDarkAccent),
                            ),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                    "assets/icons/home/banner-support-1.svg"),
                                SizedBox(width: 4.3),
                                DynamicText(
                                  S.of(context).genuineSecurity,
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: kDarkSecondary),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                    "assets/icons/home/banner-support-2.svg"),
                                SizedBox(width: 4.3),
                                DynamicText(
                                  S.of(context).sevenDayWorryFree,
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: kDarkSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: kDefaultBackground,
                              padding: EdgeInsets.only(
                                  left: 16, bottom: 10, top: 10),
                              child: TabBar(
                                controller: _tabController,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 5.0),
                                isScrollable: true,
                                indicatorColor: kDarkAccent,
                                unselectedLabelColor: Colors.black,
                                unselectedLabelStyle: kBaseTextStyle.copyWith(
                                    color: kDarkSecondary),
                                labelStyle: kBaseTextStyle,
                                labelColor: kPinkAccent,
                                onTap: (i) {
                                  setState(() {
                                    currentIndex = i;
                                  });
                                },
                                tabs: renderTabbar(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // =======================================================
                      // TabBarViews
                      // =======================================================
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_tabController.index == 1)
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 21, bottom: 10, left: 16),
                                child: DynamicText(
                                  S.of(context).trendingKorea,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          if (_tabController.index == 1)
                            Container(
                              color: kDefaultBackground,
                              child: productModel.showProductList(
                                  isNameAvailable: true,
                                  isListView: false,
                                  future: getProductByTagTrending,
                                  onLoadMore: onLoadMore),
                            ),
                          if (_tabController.index == 0)
                            !isSurveyFinished
                                ? PersonalSurvey(
                                    surveys: surveys,
                                    onSurveyFinish: () {
                                      setState(() {
                                        isSurveyFinished = true;
                                        isGenerating = true;
                                        Future.delayed(
                                            const Duration(milliseconds: 2000),
                                            () {
                                          setState(() {
                                            isGenerating = false;
                                            // Here you can write your code for open new view
                                          });
                                        });
                                      });
                                    })
                                : _generatePersonalizedPackages(),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
