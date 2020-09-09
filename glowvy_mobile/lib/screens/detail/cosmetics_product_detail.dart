import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/reviews.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/screens/detail/cosmetics_image_feature.dart';
import 'package:Dimodo/screens/detail/cosmetics_product_title.dart';
import 'package:Dimodo/screens/detail/cosmetics_review_screen.dart';
import 'package:Dimodo/screens/detail/ingredient_card.dart';
import 'package:Dimodo/screens/detail/ingredient_screen.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:Dimodo/widgets/popup_services.dart';
import 'package:Dimodo/widgets/start_rating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../models/product/product.dart';
import '../../models/app.dart';
import '../../models/product/productModel.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'productOption.dart';
import 'package:flutter/cupertino.dart';
import 'cosmetics_product_description.dart';
import '../../services/index.dart';
import '../../models/order/cart.dart';

class CosmeticsProductDetail extends StatefulWidget {
  Product product;

  CosmeticsProductDetail({this.product});

  @override
  _CosmeticsProductDetailState createState() => _CosmeticsProductDetailState();
}

class _CosmeticsProductDetailState extends State<CosmeticsProductDetail> {
  bool isLoading = false;
  bool isProductLoaded = false;
  Size screenSize;
  var bottomPopupHeightFactor;
  final services = Services();
  var hazardLevel;

  List<String> tabList = [];
  Reviews metaReviews =
      Reviews(totalCount: 0, averageSatisfaction: 100, reviews: <Review>[]);

  bool isLoggedIn = false;
  int offset = 0;
  int limit = 3;
  ProductModel productModel;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    isProductLoaded = false;

    services.getCosmeticsReviews(widget.product.sid).then((onValue) {
      if (this.mounted) {
        setState(() {
          metaReviews = onValue;
        });
        offset += 3;
        isLoading = false;
      }
    });
    services.getCosmetics(widget.product.sid).then((onValue) {
      if (this.mounted) {
        setState(() {
          widget.product = onValue;
          print("ingredient count, ${widget.product.ingredients.length}");
          isProductLoaded = true;
        });
      }
    });
    productModel = Provider.of<ProductModel>(context, listen: false);
    print("hazardScore: ${widget.product.hazardScore}");
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> getReviews() async {
    var loadedReviews = await services.getCosmeticsReviews(widget.product.sid);
    if (loadedReviews.reviews == null) {
      return true;
    } else if (loadedReviews.reviews.length == 0) {
      return true;
    }
    setState(() {
      isLoading = false;
      loadedReviews.reviews.forEach((element) {
        metaReviews.reviews.add(element);
      });
    });
    offset += 3;
    return false;
  }

  Future<void> showShippingInfo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to dismiss the popup!
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(
            S.of(context).shippingFeePolicy,
            style: kBaseTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: kBaseTextStyle,
              ),
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print("product sid: ${widget.product.sid}");
    try {
      tabList = [];
      final tabs = Provider.of<AppModel>(context, listen: false)
          .appConfig['Tabs'] as List;
      for (var tab in tabs) {
        tabList.add(tab["name"]);
      }
    } catch (err) {
      isLoading = false;
      var message =
          "There is an issue with the app during request the data, please contact admin for fixing the issues " +
              err.toString();

      print("error: $message");
    }
    switch (widget.product.hazardScore) {
      case 0:
        hazardLevel = S.of(context).undecided;
        break;
      case 1:
        hazardLevel = S.of(context).low;
        break;
      case 2:
        hazardLevel = S.of(context).moderate;
        break;
      case 3:
        hazardLevel = S.of(context).high;
        break;
      default:
    }

    renderIngredients() {
      var index = 0;
      List<Widget> widgets = [];
      if (widget.product.ingredients != null) {
        while (index < 3 && widget.product.ingredients.length > index) {
          var card = IngredientInfoCard(
            ingredient: widget.product.ingredients[index],
          );
          widgets.add(card);
          index++;
        }
        return widgets;
      }
    }

    return Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: widget.product != null
                  ? ProductOption(widget.product, isLoggedIn)
                  : null,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                // expandedHeight: screenSize.height * 0.3,
                brightness: Brightness.light,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    child: IconButton(
                      icon: CommonIcons.arrowBackward,
                    ),
                  ),
                ),
                // actions: <Widget>[CartAction()],
                backgroundColor: Colors.transparent,
              ),
              body: (widget.product == null)
                  ? Container(
                      height: 1,
                    )
                  : Container(
                      color: Colors.white,
                      child: ListView(
                        padding: EdgeInsets.only(top: 0),
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CosmeticsImageFeature(
                                widget.product,
                              ),
                              Container(
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CosmeticsProductTitle(
                                        widget.product,
                                      ),
                                      Container(
                                        height: 5,
                                        color: kDefaultBackground,
                                      ),
                                      Container(
                                        height: 5,
                                        width: screenSize.width,
                                        color: kDefaultBackground,
                                      ),
                                      CosmeticsProductDescription(
                                          widget.product),
                                      Container(
                                        height: 5,
                                        color: kDefaultBackground,
                                      ),
                                      isProductLoaded
                                          ? GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IngredientScreen(
                                                            widget.product
                                                                .ingredients,
                                                            hazardLevel,
                                                          ))),
                                              child: Container(
                                                width: screenSize.width,
                                                color: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 56,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                              S
                                                                  .of(context)
                                                                  .ingredientInfo,
                                                              style: kBaseTextStyle.copyWith(
                                                                  fontSize: 15,
                                                                  color:
                                                                      kDarkSecondary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          Spacer(),
                                                          if (metaReviews
                                                                  .totalCount !=
                                                              0)
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    S
                                                                        .of(
                                                                            context)
                                                                        .seeMore,
                                                                    style: kBaseTextStyle.copyWith(
                                                                        fontSize:
                                                                            15,
                                                                        color:
                                                                            kPrimaryOrange,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                CommonIcons
                                                                    .arrowForwardPink
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(hazardLevel,
                                                            style: kBaseTextStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                        Text(
                                                            S
                                                                .of(context)
                                                                .ewgSafeLevel,
                                                            style: kBaseTextStyle.copyWith(
                                                                fontSize: 12,
                                                                color:
                                                                    kDarkSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        SizedBox(width: 16)
                                                      ],
                                                    ),
                                                    SizedBox(height: 16),
                                                    Column(
                                                      children:
                                                          renderIngredients(),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          : Container(),
                                      Container(
                                        height: 5,
                                        color: kDefaultBackground,
                                      ),
                                      GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CosmeticsReviewScreen(
                                                          metaReviews,
                                                          getReviews,
                                                          widget.product))),
                                          child: !isLoading
                                              ? Container(
                                                  width: screenSize.width,
                                                  color: Colors.white,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        height: 56,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "${S.of(context).reviews} (${widget.product.purchaseCount})",
                                                                style: kBaseTextStyle.copyWith(
                                                                    fontSize:
                                                                        13,
                                                                    color:
                                                                        kDarkSecondary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            Spacer(),
                                                            if (metaReviews
                                                                    .totalCount !=
                                                                0)
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      S
                                                                          .of(
                                                                              context)
                                                                          .seeMore,
                                                                      style: kBaseTextStyle.copyWith(
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              kPrimaryOrange,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                  CommonIcons
                                                                      .arrowForwardPink
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                              widget.product
                                                                  .rating
                                                                  .substring(
                                                                      0, 4),
                                                              style: kBaseTextStyle.copyWith(
                                                                  fontSize: 26,
                                                                  color:
                                                                      kPrimaryOrange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SmoothStarRating(
                                                              allowHalfRating:
                                                                  false,
                                                              rating: double
                                                                  .parse(widget
                                                                      .product
                                                                      .rating
                                                                      .substring(
                                                                          0,
                                                                          4)),
                                                              size: 25.0,
                                                              color:
                                                                  kPrimaryOrange,
                                                              borderColor:
                                                                  kPrimaryOrange,
                                                              spacing: 0.0),
                                                        ],
                                                      ),
                                                      ReviewImages(
                                                          widget.product),
                                                      SizedBox(height: 20),
                                                      if (metaReviews
                                                              .totalCount !=
                                                          0)
                                                        Column(
                                                          children: <Widget>[
                                                            CosmeticsReviewCard(
                                                                isPreview: true,
                                                                context:
                                                                    context,
                                                                review: metaReviews
                                                                    .reviews[0]),
                                                            CosmeticsReviewCard(
                                                                isPreview: true,
                                                                context:
                                                                    context,
                                                                review: metaReviews
                                                                    .reviews[1]),
                                                            CosmeticsReviewCard(
                                                                isPreview: true,
                                                                context:
                                                                    context,
                                                                review: metaReviews
                                                                    .reviews[2]),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  width: screenSize.width,
                                                  height: 90,
                                                  child:
                                                      CupertinoActivityIndicator(
                                                          animating: true),
                                                )),
                                    ],
                                  )),
                            ],
                          ),
                          Container(
                            height: 5,
                            color: kDefaultBackground,
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => PopupServices.showQandA(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).officialQA,
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 15,
                                            color: kDarkSecondary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // DynamicText(
                                          //     S
                                          //         .of(context)
                                          //         .seeMore,
                                          //     style: kBaseTextStyle.copyWith(
                                          //         fontSize: 12,
                                          //         color:
                                          //             kPrimaryOrange,
                                          //         fontWeight:
                                          //             FontWeight
                                          //                 .w500)),
                                          CommonIcons.arrowForwardPink
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 17),
                                Text(
                                  S.of(context).whyLowerThanMarketPriceQuestion,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  S.of(context).whereReviewsFromQuestion,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  S.of(context).sameQualityAsInKoreaQuestion,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
            )));
  }

  List<Widget> renderTabbar() {
    List<Widget> list = [];

    tabList.asMap().forEach((index, item) {
      list.add(Container(
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
