import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:flutter/services.dart';
import '../models/order/cart.dart';

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
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin {
  bool enabledNotification = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      checkNotificationPermission();
    });
  }

  void checkNotificationPermission() async {
    try {
      NotificationPermissions.getNotificationPermissionStatus().then((status) {
        if (mounted)
          setState(() {
            enabledNotification = status == PermissionStatus.granted;
          });
      });
    } catch (err) {}
  }

//testing codemagic
  @override
  Widget build(BuildContext context) {
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
    //it will rebuild cartScreens when it's not ready... in the tab..?

    return Scaffold(
      body: Container(
        color: kLightBG,
        // margin: EdgeInsets.only(left: 7, right: 7),
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
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    color: kLightPink,
                    height: 100,
                    width: screenSize.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DynamicText(
                          S.of(context).bannerTitle,
                          style: kBaseTextStyle.copyWith(
                              // fontFamily: "Gill Sans",
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: kPinkAccent),
                        ),
                        // SizedBox(height: ,)
                        DynamicText(
                          S.of(context).bannerDescription,
                          style: kBaseTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: kPinkAccent),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 71,
                    width: screenSize.width,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/icons/home/globe.png"),
                              DynamicText(
                                S.of(context).trendDesign,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/icons/home/mail.png"),
                              DynamicText(
                                S.of(context).koreanShipping,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/icons/home/review.png"),
                              DynamicText(
                                S.of(context).trustReviews,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ]),
                  ),
                ]),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(height: 5),
                Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 10, left: 16),
                          child: DynamicText(
                            S.of(context).editorPicks,
                            style: kBaseTextStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ProductModel.showProductListByTag(
                            context: context, tag: "star", sortBy: "id"),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10, left: 16),
                  child: DynamicText(
                    S.of(context).trendingKorea,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                ProductModel.showProductListByTag(
                    context: context, tag: "trending", sortBy: "id"),
              ])),
              // ProductModel.showProductListByTag(context: context, tag: "event"),
              SliverList(
                delegate: SliverChildListDelegate([
                  SvgPicture.asset(
                    'assets/icons/heart-ballon.svg',
                    width: 30,
                    height: 42,
                  ),
                  // SizedBox(height: 16.5),
                  // DynamicText(
                  //   "Oh! It seems to hit the bottom. \n Btw, do you like our app?",
                  //   style: kBaseTextStyle.copyWith(
                  //       color: kDarkSecondary,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w600),
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(height: 15),
                  // Container(
                  //   padding: EdgeInsets.only(right: 16, left: 16),
                  //   width: screenSize.width,
                  //   child: Column(
                  //     children: <Widget>[
                  //       MaterialButton(
                  //           elevation: 0,
                  //           color: Theme.of(context).buttonColor,
                  //           minWidth: screenSize.width - 32,
                  //           height: 48,
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: new BorderRadius.circular(25.0),
                  //               side: BorderSide(color: kPinkAccent, width: 1.5)),
                  //           child: DynamicText(S.of(context).yesGood,
                  //               style: kBaseTextStyle.copyWith(
                  //                   fontWeight: FontWeight.w600,
                  //                   fontSize: 14,
                  //                   color: Colors.white)),
                  //           onPressed: () {
                  //             kRateMyApp
                  //                 .showRateDialog(context)
                  //                 .then((v) => setState(() {}));
                  //             // if (!isLoading) {
                  //             Navigator.of(context)
                  //                 .pushReplacementNamed('/setting');
                  //             // }
                  //           }),
                  //       SizedBox(height: 10),
                  //       MaterialButton(
                  //           elevation: 0,
                  //           minWidth: screenSize.width - 32,
                  //           height: 48,
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: new BorderRadius.circular(25.0),
                  //               side: BorderSide(color: kPinkAccent, width: 1.5)),
                  //           child: DynamicText(S.of(context).noSendUsSuggestions,
                  //               style: kBaseTextStyle.copyWith(
                  //                   fontWeight: FontWeight.w600,
                  //                   fontSize: 14,
                  //                   color: kPinkAccent)),
                  //           onPressed: () async {
                  //             await FlutterMailer.send(MailOptions(
                  //               body: '',
                  //               subject: 'Feedback',
                  //               recipients: ['hbpfreem@gmail.com'],
                  //             ));
                  //             // if (!isLoading) {
                  //             // Navigator.of(context)
                  //             //     .pushReplacementNamed('/forgot_password');
                  //             // }l
                  //           }),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 70),
                ]),
              )
            ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
