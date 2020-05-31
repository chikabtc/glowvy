import 'package:Dimodo/widgets/product/product_list.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/category.dart';
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
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  Services service = Services();
  Future<List<Product>> getProductByTagStar;
  Future<List<Product>> getProductByTagTrending;
  var bottomPopupHeightFactor;
  @override
  void initState() {
    super.initState();
    getProductByTagStar = service.getProductsByTag(tag: 6, sortBy: "id");
    getProductByTagTrending =
        service.getProductsByTag(tag: 5, sortBy: "id", start: 0, count: 200);
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
    super.build(context);
    print("building home");
    kRateMyApp.init().then((_) {});

    final screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light) // Or Brightness.dark
        );
    bottomPopupHeightFactor = 1 -
        (AppBar().preferredSize.height +
                160 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;

    _showSurvey() {
      showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return FractionallySizedBox(
                  heightFactor: bottomPopupHeightFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    width: screenSize.width,
                    height: screenSize.height * bottomPopupHeightFactor -
                        AppBar().preferredSize.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              height: AppBar().preferredSize.height,
                              width: kScreenSizeWidth,
                              child: Center(
                                child: DynamicText(
                                    S.of(context).thankYouForUsingDimodo,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              )),
                          Positioned(
                            top: 6,
                            right: 0,
                            child: IconButton(
                                icon: SvgPicture.asset(
                                    'assets/icons/address/close-popup.svg'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          )
                        ]),
                        Container(
                            width: 200,
                            height: 236,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset(
                                  'assets/images/notification-illustration.png'),
                            )),
                        // SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 32.0, left: 32, bottom: 20),
                          child: DynamicText(S.of(context).surveyDescription,
                              style: kBaseTextStyle.copyWith(
                                fontSize: 13,
                                color: kDarkSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.justify),
                        ),

                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 40.0),
                              child: MaterialButton(
                                  elevation: 0,
                                  color: kDarkAccent,
                                  minWidth: kScreenSizeWidth,
                                  height: 36,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                  ),
                                  child: Text(S.of(context).takeSurvey,
                                      style: kBaseTextStyle.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebView(
                                                url:
                                                    "https://bit.ly/measurepmf",
                                                title:
                                                    "DIMODO Users Survey ⭐️")));
                                    // await FlutterMailer.send(MailOptions(
                                    //   body: '',
                                    //   subject: 'Feedback',
                                    //   recipients: ['hbpfreeman@gmail.com'],
                                    //   isHTML: true,
                                    // ))
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: Container(),
          elevation: 0,
          // pinned: true,
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
          // expandedHeight: 221,
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
          height: screenSize.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              var productModel =
                  Provider.of<ProductModel>(context, listen: false);

              if (!productModel.isFetching &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                // _loadData();
                // isLoading = true;
                // setState(() {});
              }
              return false;
            },
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: screenSize.width,
                        child: Image.asset(
                          "assets/icons/home/top-banner.png",
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
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 21, bottom: 10, left: 16),
                        child: DynamicText(
                          S.of(context).trendingKorea,
                          style: kBaseTextStyle.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      ProductModel.showProductList(
                          isNameAvailable: true,
                          disableScroll: true,
                          future: getProductByTagTrending,
                          onLoadMore: onLoadMore),
                    ],
                  ),
                ],
              ),
            ),
//
          ),
        ));
  }
}
