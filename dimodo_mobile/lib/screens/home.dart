import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/baumannTestIntro.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/fancyButton.dart';
import 'package:Dimodo/widgets/popup_services.dart';
import 'package:Dimodo/widgets/cosmetics_filter_bar.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'dart:math' as math;
import 'package:after_layout/after_layout.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
        AfterLayoutMixin<HomeScreen>,
        AutomaticKeepAliveClientMixin<HomeScreen>,
        TickerProviderStateMixin {
  Services service = Services();
  Future<List<Product>> getProductByTagStar;
  Future<List<Product>> getProductByTagTrending;
  Future<List<Product>> getCosmeticsProductsByCategory;
  var bottomPopupHeightFactor;
  List<Category> tabList = [];
  TabController _tabController;

  bool isGenerating = true;
  bool isSurveyFinished = false;
  bool showFiltered = false;
  bool showRank = true;
  UserModel userModel;
  ProductModel productModel;
  List<Survey> surveys = [];
  List<Product> filteredResults = [];
  int currentCateId = 3;

  int skinTypeId = 0;
  var sorting = "high";
  Map<int, List<Product>> allProducts = Map();
  // List<List<Product>> allProducts = [];
  bool isFiltering = false;
  List<Future<List<Product>>> futureLists = [];

  @override
  void initState() {
    super.initState();
    Future.wait([
      service.getCosmeticsProductsByCategory(categoryId: 32, skinType: 0),
      service.getCosmeticsProductsByCategory(categoryId: 142, skinType: 0),
      service.getCosmeticsProductsByCategory(categoryId: 3, skinType: 0),
      service.getCosmeticsProductsByCategory(categoryId: 4, skinType: 0),
      service.getCosmeticsProductsByCategory(categoryId: 14, skinType: 0),
    ]).then((responses) {
      allProducts[32] = responses.first;
      allProducts[142] = responses[1];
      print("allproduc lenght: ${responses[1].length}");

      allProducts[3] = responses[2];
      allProducts[4] = responses[3];
      allProducts[14] = responses[4];
      setState(() {
        isGenerating = false;
      });
    });
    try {
      tabList = [];
      final tabs = Provider.of<AppModel>(context, listen: false)
          .appConfig['Cosmetics_categories'] as List;
      for (var tab in tabs) {
        tabList.add(Category.fromJson(tab));
      }
    } catch (err) {
      var message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("error: $message");
    }

    _tabController = TabController(length: tabList.length, vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);
    productModel = Provider.of<ProductModel>(context, listen: false);
    //setting the ski ntype when launching
    if (userModel.skinType != null) {
      if (userModel.skinType.contains("S")) {
        skinTypeId = 1;
      } else if (userModel.skinType.contains("D")) {
        skinTypeId = 2;
      } else if (userModel.skinType.contains("O")) {
        skinTypeId = 3;
      } else if (userModel.skinType.contains("R")) {
        skinTypeId = 0;
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {}

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
    // print("building home currentPage: $currentPage");
    // print("building home allProducts leng: ${allProducts[3].length}");
    kRateMyApp.init().then((_) {});

    final screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light) // Or Brightness.dark
        );

    try {
      final surveys = Provider.of<AppModel>(context, listen: false)
          .appConfig['Cosmetics_Survey'];
      // print("surveys: $surveys");
      for (var item in surveys) {
        this.surveys.add(Survey.fromJson(item));
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
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
              // color: currentPage == index ? kDarkAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          height: 40,
          child: Tab(
            text: item.name,
          ),
        ));
      });
      return list;
    }

    return Scaffold(
      body: Consumer<UserModel>(builder: (context, userModel, child) {
        if (userModel.skinType != null) {
          //set the filter for the matching skin type
          print("USERMODEL SKIN ${userModel.skinType}");
        }
        return Container(
          color: kDefaultBackground,
          child: SafeArea(
            top: true,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverAppBar(
                    brightness: Brightness.light,
                    leading: Container(),
                    elevation: 0,
                    pinned: false,
                    backgroundColor: Colors.white,
                    title: SvgPicture.asset("assets/icons/logo.svg"),
                    actions: <Widget>[
                      IconButton(
                        icon: Image.asset(
                          "assets/icons/search/search.png",
                          fit: BoxFit.cover,
                          height: 24,
                        ),
                        onPressed: () async {
                          try {
                            final credential =
                                await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                              webAuthenticationOptions:
                                  WebAuthenticationOptions(
                                // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                clientId: 'app.dimodo.iOS',
                                redirectUri: Uri.parse(
                                  'https://glowvy.glitch.me/callbacks/sign_in_with_apple',
                                ),
                              ),
                              // TODO: Remove these if you have no need for them
                              // nonce: 'example-nonce',
                              // state: 'example-state',
                            );

                            print("credential: ${credential}");

                            // This is the endpoint that will convert an authorization code obtained
                            // via Sign in with Apple into a session in your system
                            // final signInWithAppleEndpoint = Uri(
                            //   scheme: 'http',
                            //   host: 'localhost:80',
                            //   path: '/sign_in_with_apple',
                            //   queryParameters: <String, String>{
                            //     'code': credential.authorizationCode,
                            //     'firstName': credential.givenName,
                            //     'lastName': credential.familyName,
                            //     'useBundleId':
                            //         Platform.isIOS || Platform.isMacOS
                            //             ? 'true'
                            //             : 'false',
                            //     if (credential.state != null)
                            //       'state': credential.state,
                            //   },
                            // );
                            var fullName = credential.givenName +
                                " " +
                                credential.familyName;
                            final session = await service.loginApple(
                                credential.authorizationCode, fullName);
                            // // If we got this far, a session based on the Apple ID credential has been created in your system,
                            // // and you can now set this as the app's session
                            print("session: $session");

                            // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                            // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                          } catch (e) {
                            print("caught error during apple login $e");
                          }
                        },
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(
                          userModel.skinType != null ? 223 : 155),
                      child: GestureDetector(
                        onTap: () {
                          //show
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BaumannTestIntro(),
                                fullscreenDialog: true,
                              ));
                          // PopupServices.showBaummanQuiz(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: screenSize.width,
                              color: kPrimaryGreen,
                              padding: EdgeInsets.only(
                                top: 13,
                                bottom: 8,
                                left: 20,
                                right: 17,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            S.of(context).whatIsMySkinType,
                                            textAlign: TextAlign.start,
                                            style: kBaseTextStyle.copyWith(
                                                fontSize: 16,
                                                height: 1.3,
                                                fontFamily: "Nunito",
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Text(
                                            "About Glowvy ——",
                                            textAlign: TextAlign.start,
                                            style: kBaseTextStyle.copyWith(
                                                fontSize: 12,
                                                height: 1.3,
                                                fontFamily: "Nunito",
                                                color: Color(0xff6AC4A9),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SvgPicture.asset(
                                        "assets/icons/Package.svg"),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 70,
                                  width: screenSize.width / 2,
                                  color: kLightYellow,
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    bottom: 8,
                                    left: 20,
                                    right: 17,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          DynamicText(
                                            S.of(context).yourSkin,
                                            textAlign: TextAlign.start,
                                            style: kBaseTextStyle.copyWith(
                                                fontSize: 16,
                                                fontFamily: "Nunito",
                                                color: kDarkYellow,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          // SizedBox(height: 3.5),
                                          Container(
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                              border: Border.all(
                                                  color: kDarkYellow),
                                            ),
                                            child: Text(
                                              "Click Here",
                                              textAlign: TextAlign.start,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 12,
                                                  fontFamily: "Nunito",
                                                  color: kDarkYellow,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      SvgPicture.asset(
                                          "assets/icons/girl-face.svg"),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async => {
                                    await FlutterMailer.send(MailOptions(
                                      body: '',
                                      subject:
                                          'Làm thế nào chúng tôi có thể cải thiện ứng dụng cho bạn?',
                                      recipients: ['hbpfreeman@gmail.com'],
                                    ))
                                  },
                                  child: Container(
                                    height: 70,
                                    width: screenSize.width / 2,
                                    color: kPrimaryBlue.withOpacity(0.3),
                                    padding: EdgeInsets.only(
                                      top: 13,
                                      bottom: 8,
                                      left: 20,
                                      right: 17,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              DynamicText(
                                                S.of(context).feedback,
                                                textAlign: TextAlign.start,
                                                style: kBaseTextStyle.copyWith(
                                                    fontSize: 16,
                                                    height: 1.3,
                                                    fontFamily: "Nunito",
                                                    color: kPrimaryBlue,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  border: Border.all(
                                                      color: kPrimaryBlue),
                                                ),
                                                child: Text(
                                                  "Rate App",
                                                  textAlign: TextAlign.start,
                                                  style:
                                                      kBaseTextStyle.copyWith(
                                                          fontSize: 12,
                                                          fontFamily: "Nunito",
                                                          color: kPrimaryBlue,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          SvgPicture.asset(
                                              "assets/icons/feedback.svg"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            userModel.skinType != null
                                ? GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              BaumannQuiz(
                                                  skinType: userModel.skinType),
                                          fullscreenDialog: true,
                                        )),
                                    child: Container(
                                      // color: kDefaultBackground,
                                      height: 68,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              //here update the title
                                              Text(
                                                S.of(context).yourSkinTypeIs,
                                                style: kBaseTextStyle.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  for (var i = 0;
                                                      i <
                                                          userModel
                                                              .skinType.length;
                                                      i++)
                                                    Text(
                                                      "#" +
                                                          userModel.getFullSkinType(
                                                              context,
                                                              userModel
                                                                      .skinType[
                                                                  i]) +
                                                          " ",
                                                      style: kBaseTextStyle
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  kDarkSecondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          CommonIcons.arrowForward,
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              height: 10,
                              color: kDefaultBackground,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 116.0,
                      maxHeight: 116.0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      top: 10,
                                      right: 16,
                                    ),
                                    child: Container(
                                      width: screenSize.width /
                                          (2 /
                                              (screenSize.height /
                                                  screenSize.width)),
                                      child: TabBar(
                                          controller: _tabController,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          labelPadding: EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              top: 0,
                                              bottom: 0),
                                          isScrollable: true,
                                          indicatorColor: kDarkAccent,
                                          unselectedLabelColor: kDarkSecondary,
                                          unselectedLabelStyle:
                                              kBaseTextStyle.copyWith(
                                                  color: kDarkSecondary,
                                                  fontSize: 13 *
                                                      kSizeConfig
                                                          .textMultiplier,
                                                  fontWeight: FontWeight.w600),
                                          labelStyle: kBaseTextStyle.copyWith(
                                              color: Colors.white,
                                              fontSize: 13 *
                                                  kSizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w600),
                                          labelColor: kDarkAccent,
                                          tabs: renderTabbar(),
                                          onTap: (index) {
                                            print(
                                                "indeX!? " + index.toString());
                                            currentCateId = tabList[index].id;
//
                                            setState(() {
                                              showFiltered = false;
                                            });
                                          }),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.5),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: MaterialButton(
                              child: Container(
                                width: screenSize.width - 32,
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset("assets/icons/funnel.svg"),
                                    Text(
                                      "Only Check Products that Fit My Skin",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFEF4623),
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height: 48,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24),
                              ),
                              // size: 25,
                              color: Color(0xFFCFEEBEC),
                              onPressed: () {
                                print("yo");
                                // Navigator.of(context).pop();
                              },
                            ),
                          ),

                          // MaterialButton()
                          // CosmeticsFilterBar(
                          //   skinTypeId: skinTypeId,
                          //   products: allProducts.length != 0
                          //       ? allProducts[currentCateId]
                          //       : [],
                          //   onFilterConfirm:
                          //       (filteredProducts, sorting, skinTypeId) {
                          //     setState(() {
                          //       showFiltered = true;
                          //       this.sorting = sorting;
                          //       showRank = sorting == "rank" ? true : false;
                          //       this.skinTypeId = skinTypeId;
                          //       isFiltering = true;
                          //       this.filteredResults = filteredProducts;
                          //       Future.delayed(
                          //           const Duration(milliseconds: 500), () {
                          //         setState(() {
                          //           isFiltering = false;
                          //         });
                          //       });
                          //     });
                          //   },
                          //   onReset: (filteredProducts) {
                          //     setState(() {
                          //       showFiltered = true;
                          //     });
                          //   },
                          // ),
                          // Container(
                          //   height: 10,
                          //   color: Colors.white,
                          // )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: tabList.map((Category category) {
                  return SafeArea(
                    top: true,
                    bottom: false,
                    child: Builder(
                      builder: (BuildContext context) {
                        return CustomScrollView(
                          key: PageStorageKey<String>(category.name),
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4, left: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                child: isGenerating
                                                    ? DynamicText(
                                                        "Updating the product ranks in Korea...",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: kBaseTextStyle
                                                            .copyWith(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                    : Container()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isGenerating
                                        ? productModel
                                            .showGeneartingOneRowProductList()
                                        : isFiltering
                                            ? Container(
                                                height: kScreenSizeHeight * 0.5,
                                                child: SpinKitThreeBounce(
                                                    color: kAccentGreen,
                                                    size: 21.0),
                                              )
                                            : CosmeticsProductList(
                                                products:
                                                    productModel.sortAndFilter(
                                                        sorting,
                                                        skinTypeId,
                                                        allProducts[
                                                            category.id]),
                                                showRank: true,
                                                onLoadMore: onLoadMore,
                                                disableScrolling: true,
                                                showFilter: false,
                                              ),
                                  ],
                                ),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Image.asset(
                                              "assets/images/peripera_logo.png"),
                                          Image.asset(
                                              "assets/images/merzy_logo.png"),
                                          Image.asset(
                                              "assets/images/etudehouse_logo.png"),
                                          Image.asset(
                                              "assets/images/lilybyred_logo.png"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Image.asset(
                                              "assets/images/Manmonde_logo.png"),
                                          Image.asset(
                                              "assets/images/IOPE_logo.png"),
                                          Image.asset(
                                              "assets/images/LANEIGE_logo.png"),
                                          Image.asset(
                                              "assets/images/kirshblending_logo.png"),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            )
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Solid tab bar indicator.
class SolidIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _SolidIndicatorPainter(this, onChanged);
  }
}

class _SolidIndicatorPainter extends BoxPainter {
  final SolidIndicator decoration;

  _SolidIndicatorPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = offset & configuration.size;
    final Paint paint = Paint();
    paint.color = kDarkAccent;
    paint.style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({Key key, this.onTap, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  // TODO: implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
