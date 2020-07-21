import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/widgets/popup_services.dart';
import 'package:Dimodo/widgets/cosmetics_filter_bar.dart';
import 'package:Dimodo/widgets/popup_services.dart';
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
    with AutomaticKeepAliveClientMixin<HomeScreen>, TickerProviderStateMixin {
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
  int currentPage = 0;

  int skinTypeId = 0;
  var sorting = "rank";
  List<List<Product>> allProducts = [];
  bool isFiltering = false;
  List<Future<List<Product>>> futureLists = [];

  @override
  void initState() {
    super.initState();
    // getProductByTagStar = service.getProductsByTag(tag: 6, sortBy: "id");
    service
        .getCosmeticsProductsByCategory(categoryId: 3, skinType: 0)
        .then((value) => allProducts.add(value));
    service
        .getCosmeticsProductsByCategory(categoryId: 4, skinType: 0)
        .then((value) => allProducts.add(value));
    service
        .getCosmeticsProductsByCategory(categoryId: 32, skinType: 0)
        .then((value) => allProducts.add(value));
    service
        .getCosmeticsProductsByCategory(categoryId: 41, skinType: 0)
        .then((value) => allProducts.add(value));
    service
        .getCosmeticsProductsByCategory(categoryId: 14, skinType: 0)
        .then((value) => allProducts.add(value));
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

    print("TabList Length: ${tabList.length}");
    _tabController = TabController(length: tabList.length, vsync: this);
    userModel = Provider.of<UserModel>(context, listen: false);

    productModel = Provider.of<ProductModel>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 2000), () async {
      setState(() {
        isGenerating = false;
      });
    });
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

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                leading: Container(),
                elevation: 0,
                pinned: false,
                backgroundColor: Colors.white,
                title: Text(
                  "SKIN101",
                  style: kBaseTextStyle.copyWith(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Image.asset(
                        "assets/icons/search/search.png",
                        fit: BoxFit.cover,
                        height: 24,
                      ),
                      onPressed: () => PopupServices.showBaummanQuiz(context)),
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 100.0,
                  maxHeight: 100.0,
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
                                padding: EdgeInsets.only(left: 16, top: 10),
                                child: Container(
                                  // color: Colors.brown,
                                  width: screenSize.width /
                                      (2 /
                                          (screenSize.height /
                                              screenSize.width)),
                                  child: TabBar(
                                      controller: _tabController,
                                      indicatorSize: TabBarIndicatorSize.tab,
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
                                                  kSizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w600),
                                      labelStyle: kBaseTextStyle.copyWith(
                                          color: Colors.white,
                                          fontSize:
                                              13 * kSizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600),
                                      labelColor: kDarkAccent,
                                      tabs: renderTabbar(),
                                      onTap: (index) {
                                        print("indeX!? " + index.toString());
                                        setState(() {
                                          currentPage = index;
                                          showFiltered = false;
                                        });
                                      }),
                                )),
                          ),
                        ],
                      ),
                      CosmeticsFilterBar(
                        products: allProducts.length != 0
                            ? allProducts[currentPage]
                            : [],
                        onFilterConfirm:
                            (filteredProducts, sorting, skinTypeId) {
                          setState(() {
                            showFiltered = true;
                            this.sorting = sorting;
                            showRank = sorting == "rank" ? true : false;
                            this.skinTypeId = skinTypeId;
                            isFiltering = true;
                            this.filteredResults = filteredProducts;
                            Future.delayed(const Duration(milliseconds: 500),
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
                      Container(
                        height: 10,
                        color: Colors.white,
                      )
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
                            FutureBuilder<List<Product>>(
                              future: futureLists[tabList.indexOf(category)],
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Product>> snapshot) {
                                print("CATEGORYNAME : ${category.name}");
                                //if new category is chosen, pass the new category products to the filter bar
                                if (filteredResults == null || !showFiltered) {
                                  if (allProducts.length != 5 &&
                                      snapshot.data != null) {
                                    allProducts.add(snapshot.data);
                                    // print(
                                    //     "index ${currentPage} product length ${allProducts[currentPage].length}");
                                  }
                                  if (snapshot.data != null) {
                                    filteredResults =
                                        productModel.sortAndFilter(
                                            sorting, skinTypeId, snapshot.data);
                                    if (currentPage == 3) {
                                      filteredResults = snapshot.data;
                                    }
                                    // print("filtered: ${filteredResults}");
                                  }
                                }
                                return Column(
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
                                                    color: kPinkAccent,
                                                    size: 21.0),
                                              )
                                            : CosmeticsProductList(
                                                products: filteredResults,
                                                showRank: showRank,
                                                onLoadMore: onLoadMore,
                                                disableScrolling: true,
                                                showFilter: false,
                                              ),
                                  ],
                                );
                              },
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
