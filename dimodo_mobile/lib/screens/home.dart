import 'package:Dimodo/widgets/product/product_list.dart';
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
    var safePadding = MediaQuery.of(context).padding.top;

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
              child: Column(
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
                    padding:
                        const EdgeInsets.only(top: 21, bottom: 10, left: 16),
                    child: DynamicText(
                      S.of(context).trendingKorea,
                      style: kBaseTextStyle.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: ProductModel.showProductList(
                        isNameAvailable: true,
                        disableScroll: false,
                        future: getProductByTagTrending,
                        onLoadMore: onLoadMore),
                  ),
                ],
              ),
            ),
//
          ),
        ));
  }
}
