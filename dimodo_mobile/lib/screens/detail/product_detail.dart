import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/reviews.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../common/constants.dart';
import '../../models/product/product.dart';
import '../../models/app.dart';
import '../../models/product/productModel.dart';
import 'product_title.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'productOption.dart';
import 'image_feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'reviewScreen.dart';
import 'review_card.dart';
import 'cartAction.dart';
import 'product_description.dart';
import '../../services/index.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail({this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  bool isLoading = false;
  Size screenSize;
  var bottomPopupHeightFactor;
  final services = Services();

  List<String> tabList = [];

  List<String> colors = ["Red", "Orange", "Blue"];
  List<String> sizes = ["S", "M", "L"];
  String color;
  String chosenSize;
  Reviews metaReviews =
      Reviews(totalCount: 0, averageSatisfaction: 100, reviews: <Review>[]);

  Future<Product> product;
  bool isLoggedIn = false;
  bool loaded = false;
  int offset = 0;
  int limit = 3;
  @override
  void initState() {
    super.initState();
    services.getReviews(widget.product.sid, offset, limit).then((onValue) {
      setState(() {
        metaReviews = onValue;
        print("reviews received: ${metaReviews.toJson()}");
      });
      offset += 3;
    });
  }

//14403197
  void didChangeDependencies() {
    product =
        Provider.of<ProductModel>(context).getProduct(id: widget.product.sid);
    super.didChangeDependencies();
  }

  Future<bool> getReviews() async {
    var loadedReviews =
        await services.getReviews(widget.product.sid, offset, limit);
    if (loadedReviews.reviews.length == 0) {
      return true;
    }
    setState(() {
      isLoading = false;
      loadedReviews.reviews.forEach((element) {
        metaReviews.reviews.add(element);
      });
      //
    });
    offset += 3;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    try {
      tabList = [];
      final tabs = Provider.of<AppModel>(context, listen: false)
          .appConfig['Tabs'] as List;
      for (var tab in tabs) {
        tabList.add(tab["name"]);
      }
      print("local cate: $tabList'");
    } catch (err) {
      isLoading = false;
      var message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("error: $message");
    }

    List<Widget> renderTabViews(Product product) {
      List<Widget> tabViews = [];

      tabList.asMap().forEach((index, name) {
        tabViews.add(SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            // This Builder is needed to provide a BuildContext that is "inside"
            // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
            // find the NestedScrollView.
            builder: (BuildContext context) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                // The "controller" and "primary" members should be left
                // unset, so that the NestedScrollView can control this
                // inner scroll view.
                // If the "controller" property is set, then this scroll
                // view will not be associated with the NestedScrollView.
                // The PageStorageKey should be unique to this ScrollView;
                // it allows the list to remember its scroll position when
                // the tab view is not on the screen.
                key: PageStorageKey<String>(name),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber above.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) {
                        if (index == 0) return ProductDescription(product);
                        if (index == 1)
                          return ProductModel.showProductListByCategory(
                              cateId: 7,
                              sortBy: "sale_price",
                              limit: 200,
                              context: context);
                        // if (index == 2)
                        //   return ProductModel.showProductListByCategory(
                        //       cateId: 7, context: context);
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              );
            },
          ),
        ));
      });
      return tabViews;
    }

    return Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          bottom: false,
          top: false,
          child: FutureBuilder<Product>(
              future: product,
              builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
                var reviewHeight = metaReviews.totalCount == 0 ? 0 : 90;

                return Scaffold(
                    //todo: check whether the item is loaded or not
                    bottomNavigationBar: snapshot.data != null
                        ? ProductOption(snapshot.data, isLoggedIn)
                        : null,
                    backgroundColor: Colors.white,
                    body: DefaultTabController(
                        length: 2,
                        child: NestedScrollView(
                            physics:
                                ScrollPhysics(parent: BouncingScrollPhysics()),
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [
                                SliverOverlapAbsorber(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                  child: SliverAppBar(
                                    //imageFeature (0.5) + 70 + texts(dynamic! 13 * 4 dynamic text)
                                    expandedHeight: screenSize.height * 0.52 +
                                        //title static heigt (31) and font sizes total 41 and 0.9 is the number for the height of the font
                                        //52 is the fontsizes of the service container texts.
                                        //115 is the static height of the service contaienr
                                        //40 is the tabbar height
                                        51 +
                                        60 +
                                        105 +
                                        41 * 1.2 +
                                        52 * 1.2 +
                                        40 +
                                        reviewHeight,

                                    // 179,

                                    brightness: Brightness.light,
                                    leading: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                        width: 30,
                                        child: IconButton(
                                          icon: CommonIcons.arrowBackward,
                                          // onPressed: () {
                                          //   Navigator.of(context).pop();
                                          // },
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[CartAction()],
                                    backgroundColor: Colors.white,
                                    pinned: true,
                                    floating: false,
                                    flexibleSpace: snapshot.data == null
                                        ? Container(
                                            height: kScreenSizeHeight,
                                            child: SpinKitThreeBounce(
                                                color: kPinkAccent,
                                                size: 23.0 *
                                                    kSizeConfig
                                                        .containerMultiplier),
                                          )
                                        : FlexibleSpaceBar(
                                            collapseMode: CollapseMode.pin,
                                            background: Column(
                                              children: <Widget>[
                                                ImageFeature(
                                                  snapshot.data,
                                                ),
                                                Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        ProductTitle(
                                                            snapshot.data,
                                                            widget
                                                                .product.name),
                                                        Container(
                                                          height: 5,
                                                          width:
                                                              screenSize.width,
                                                          color:
                                                              kDefaultBackground,
                                                        ),
                                                        Container(
                                                          width:
                                                              screenSize.width,
                                                          color: Colors.white,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 20,
                                                                  bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .shipFromKorea,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      color:
                                                                          kDarkSecondary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .koreanShippingFee,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kDarkAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              SizedBox(
                                                                  height: 20),
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .importTaxIncluded,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      color:
                                                                          kDarkSecondary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .importTaxFeeDescription,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kDarkAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 5,
                                                          width:
                                                              screenSize.width,
                                                          color:
                                                              kDefaultBackground,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ReviewScreen(
                                                                            metaReviews,
                                                                            getReviews))),
                                                            child: !isLoading
                                                                ? Container(
                                                                    width: screenSize
                                                                        .width,
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          height:
                                                                              56,
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 16),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              DynamicText("${S.of(context).reviews} (${metaReviews.totalCount})", style: kBaseTextStyle.copyWith(fontSize: 12, color: kDarkSecondary, fontWeight: FontWeight.w600)),
                                                                              Spacer(),
                                                                              if (metaReviews.totalCount != 0)
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: <Widget>[
                                                                                    DynamicText(S.of(context).satisfaction + " ${metaReviews.averageSatisfaction}%", style: kBaseTextStyle.copyWith(fontSize: 12, color: kPinkAccent, fontWeight: FontWeight.w600)),
                                                                                    CommonIcons.arrowForwardPink
                                                                                  ],
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        if (metaReviews.totalCount !=
                                                                            0)
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 10.0),
                                                                            child: ReviewCard(
                                                                                isPreview: true,
                                                                                context: context,
                                                                                review: metaReviews.reviews[0]),
                                                                          ),
                                                                        Container(
                                                                          height:
                                                                              5,
                                                                          width:
                                                                              kScreenSizeWidth,
                                                                          color:
                                                                              kDefaultBackground,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: screenSize
                                                                        .width,
                                                                    height: 90,
                                                                    child: CupertinoActivityIndicator(
                                                                        animating:
                                                                            true),
                                                                  )),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                    bottom: snapshot.data == null
                                        ? null
                                        : TabBar(
                                            labelPadding: EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            isScrollable: false,
                                            indicatorColor: kPinkAccent,
                                            unselectedLabelColor: Colors.black,
                                            unselectedLabelStyle:
                                                kBaseTextStyle.copyWith(
                                                    color: kDarkSecondary),
                                            labelStyle: kBaseTextStyle,
                                            labelColor: kPinkAccent,
                                            onTap: (index) {
                                              setState(() {});
                                            },
                                            tabs: renderTabbar(),
                                          ),
                                  ),
                                )
                              ];
                            },
                            body: (snapshot.data == null)
                                ? Container(
                                    height: 1,
                                  )
                                : TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: renderTabViews(snapshot.data)))));
              }),
        ));
  }

  List<Widget> renderTabbar() {
    List<Widget> list = [];

    tabList.asMap().forEach((index, item) {
      list.add(Container(
        // padding: EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        height: 40,
        child: Tab(
          text: item,
        ),
      ));
    });
    return list;
  }
}
