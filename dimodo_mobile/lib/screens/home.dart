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
import 'package:algolia/algolia.dart';

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
    getProductByTagTrending = service.getProductsByTag(tag: 5, sortBy: "id");
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("building home");
    kRateMyApp.init().then((_) {});

    final screenSize = MediaQuery.of(context).size;

    final categories = Provider.of<CategoryModel>(context).categories;
    List<Widget> categoryButtons = [];

    createCategoryButton(List<Category> categories) {
      categories.forEach((cate) => categoryButtons.add(CategoryButton(cate)));
    }

    createCategoryButton(categories);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light) // Or Brightness.dark
        );

    return Scaffold(
      body: Container(
        color: kLightBG,
        width: screenSize.width,
        height: screenSize.height,
        child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                leading: Container(),
                elevation: 0,
                backgroundColor: Colors.white,
                pinned: false,
                flexibleSpace: Center(
                  child: SafeArea(
                    top: true,
                    child: Image.asset(
                      "assets/images/applogo.png",
                      fit: BoxFit.cover,
                      height: 12,
                    ),
                  ),
                ),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Image.asset(
                //       "assets/icons/search/search.png",
                //       fit: BoxFit.cover,
                //       height: 24,
                //     ),
                //     onPressed: () =>
                //         Navigator.pushNamed(context, "/search_screen"),
                //   ),
                // ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
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
                              // fontFamily: "Gill Sans",
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: kDarkAccent),
                        ),
                        // SizedBox(height: ,)
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                    "assets/icons/home/banner-support-1.svg"),
                                DynamicText(
                                  S.of(context).genuineSecurity,
                                  style: kBaseTextStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: kDarkSecondary),
                                ),
                              ],
                            ),
                            // SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                    "assets/icons/home/banner-support-2.svg"),
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
                        )
                      ],
                    ),
                  ),
                  // Container(
                  //   color: Colors.white,
                  //   height: 71,
                  //   width: screenSize.width,
                  //   child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: <Widget>[
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             Image.asset("assets/icons/home/globe.png"),
                  //             DynamicText(
                  //               S.of(context).trendDesign,
                  //               style: kBaseTextStyle.copyWith(
                  //                   fontSize: 10, fontWeight: FontWeight.w500),
                  //             )
                  //           ],
                  //         ),
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             Image.asset("assets/icons/home/mail.png"),
                  //             DynamicText(
                  //               S.of(context).koreanShipping,
                  //               style: kBaseTextStyle.copyWith(
                  //                   fontSize: 10, fontWeight: FontWeight.w500),
                  //             )
                  //           ],
                  //         ),
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             Image.asset("assets/icons/home/review.png"),
                  //             DynamicText(
                  //               S.of(context).trustReviews,
                  //               style: kBaseTextStyle.copyWith(
                  //                   fontSize: 10, fontWeight: FontWeight.w500),
                  //             )
                  //           ],
                  //         ),
                  //       ]),
                  // ),
                ]),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(height: 5),
                // Container(
                //     color: kDefaultBackground,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Padding(
                //           padding: const EdgeInsets.only(
                //               top: 16, bottom: 10, left: 16),
                //           child: DynamicText(
                //             S.of(context).editorPicks,
                //             style: kBaseTextStyle.copyWith(
                //                 fontSize: 15, fontWeight: FontWeight.w600),
                //           ),
                //         ),
                //         ProductModel.showProductList(
                //             isNameAvailable: false,
                //             future: getProductByTagStar),
                //       ],
                //     )),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10, left: 16),
                  child: DynamicText(
                    S.of(context).trendingKorea,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                ProductModel.showProductList(
                    future: getProductByTagTrending, isNameAvailable: true),
              ])),
              SliverList(
                delegate: SliverChildListDelegate([
                  SvgPicture.asset(
                    'assets/icons/heart-ballon.svg',
                    width: 30,
                    height: 42,
                  ),
                  SizedBox(height: 70),
                ]),
              )
            ]),
      ),
    );
  }
}
