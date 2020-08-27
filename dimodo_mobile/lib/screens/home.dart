import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/baumannTestIntro.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/cosmetics_filter_bar.dart';
import 'package:Dimodo/widgets/filter-by-skin.dart';
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
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.red));
    kRateMyApp.init().then((_) {});

    final screenSize = MediaQuery.of(context).size;

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
      // for (var l; )

      tabList.asMap().forEach((index, item) {
        list.add(Tab(
          text: item.name,
        ));
      });
      return list;
    }

    showSkinTest() {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => userModel.skinType == null
                ? BaumannTestIntro()
                : BaumannQuiz(
                    skinType: userModel.skinType,
                    skinScores: userModel.skinScores),
            fullscreenDialog: true,
          ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserModel>(builder: (context, userModel, child) {
        if (userModel.skinType != null) {
          //set the filter for the matching skin type
          print("USERMODEL SKIN ${userModel.skinType}");
          print("USERMODEL SKINSCORES ${userModel.skinScores?.dsScore}");
        }
        return SafeArea(
          top: true,
          bottom: false,
          child: Container(
            color: kDefaultBackground,
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
                    // actions: <Widget>[
                    //   IconButton(
                    //     icon: Image.asset(
                    //       "assets/icons/search/search.png",
                    //       fit: BoxFit.cover,
                    //       height: 24,
                    //     ),
                    //     onPressed: () async {
                    //       Navigator.pushNamed(context, "/login");
                    //     },
                    //   ),
                    // ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(170),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: screenSize.width,
                            color: kPrimaryGreen,
                            padding: EdgeInsets.only(
                              top: 13,
                              left: 25,
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
                                          "Ra đời nhằm đào sâu hơn vào chủ đề chăm sóc da",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.3,
                                              fontFamily: 'Nunito',
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Text(
                                          "Về Glowvy",
                                          textAlign: TextAlign.start,
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 12,
                                              height: 1.3,
                                              fontFamily: "Nunito",
                                              color: Color(0xFF6AC4A9),
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SvgPicture.asset("assets/icons/Package.svg"),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => showSkinTest(),
                                child: Container(
                                  height: 70,
                                  width: screenSize.width / 2,
                                  color: kLightYellow,
                                  padding: EdgeInsets.only(
                                    top: 13,
                                    bottom: 12,
                                    left: 16,
                                    right: 17,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
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
                                                  Radius.circular(8)),
                                              border: Border.all(
                                                  color: kDarkYellow),
                                            ),
                                            child: Text(
                                              userModel.skinType != null
                                                  ? userModel.skinType
                                                  : "????",
                                              textAlign: TextAlign.start,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 12,
                                                  fontFamily: "Nunito",
                                                  color: kDarkYellow,
                                                  letterSpacing: 2.0,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      SvgPicture.asset(
                                          "assets/icons/girl-face.svg"),
                                    ],
                                  ),
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
                                    bottom: 12,
                                    left: 16,
                                    right: 17,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              S.of(context).feedback,
                                              textAlign: TextAlign.start,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 16,
                                                  height: 1.3,
                                                  fontFamily: "Nunito",
                                                  color: kPrimaryBlue,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                border: Border.all(
                                                    color: kPrimaryBlue),
                                              ),
                                              child: Text(
                                                "Cải thiện ứng dụng",
                                                textAlign: TextAlign.start,
                                                style: kBaseTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontFamily: "Nunito",
                                                    color: kPrimaryBlue,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        SvgPicture.asset(
                                            "assets/icons/feedback.svg"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(height: 20, color: kDefaultBackground),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 138,
                      maxHeight: 138,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 5),
                              child: TabBar(
                                  controller: _tabController,
                                  indicator: new BubbleTabIndicator(
                                    indicatorHeight: 39.0,
                                    indicatorColor: kDarkAccent,
                                    tabBarIndicatorSize:
                                        TabBarIndicatorSize.tab,
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelPadding: EdgeInsets.only(
                                    left: 18.0,
                                    right: 18.0,
                                    top: 5,
                                  ),
                                  isScrollable: true,
                                  indicatorColor: Colors.white,
                                  unselectedLabelColor: kDarkSecondary,
                                  unselectedLabelStyle: kBaseTextStyle.copyWith(
                                      color: kDarkSecondary,
                                      fontSize: 15,
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.bold),
                                  labelStyle: kBaseTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.bold),
                                  labelColor: Colors.white,
                                  tabs: renderTabbar(),
                                  onTap: (index) {
                                    print("indeX!? " + index.toString());
                                    currentCateId = tabList[index].id;
                                    setState(() {
                                      showFiltered = false;
                                    });
                                  }),
                            ),
                          ),
                          userModel.skinType == null
                              ? Container(
                                  height: 78,
                                  width: screenSize.width,
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () => showSkinTest(),
                                        child: Container(
                                          height: 48,
                                          width: screenSize.width - 32,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFCFEEBEC),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                  "assets/icons/funnel.svg"),
                                              Text(
                                                "Only Check Products that Fit My Skin",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: kAccentRed,
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 78,
                                  child: FilterBySkin(
                                    skinTypeId: skinTypeId,
                                    products: allProducts.length != 0
                                        ? allProducts[currentCateId]
                                        : [],
                                    onFilterConfirm: (filteredProducts, sorting,
                                        skinTypeId) {
                                      setState(() {
                                        showFiltered = true;
                                        this.sorting = sorting;
                                        showRank =
                                            sorting == "rank" ? true : false;
                                        this.skinTypeId = skinTypeId;
                                        isFiltering = true;
                                        this.filteredResults = filteredProducts;
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          setState(() {
                                            isFiltering = false;
                                          });
                                        });
                                      });
                                    },
                                    onReset: (filteredProducts) {
                                      setState(() {
                                        showFiltered = true;
                                      });
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: tabList.map((Category category) {
                  return Builder(
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
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: isGenerating
                                                  ? Text(
                                                      "Updating the product ranks in Korea...",
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                  color: kPrimaryOrange,
                                                  size: 21.0),
                                            )
                                          : CosmeticsProductList(
                                              products:
                                                  productModel.sortAndFilter(
                                                      sorting,
                                                      skinTypeId,
                                                      allProducts[category.id]),
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
