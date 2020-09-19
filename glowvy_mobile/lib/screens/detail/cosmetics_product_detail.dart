import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/reviews.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/screens/detail/cosmetics_image_feature.dart';
import 'package:Dimodo/screens/detail/cosmetics_product_title.dart';
import 'package:Dimodo/screens/detail/cosmetics_review_screen.dart';
import 'package:Dimodo/screens/detail/ingredient_card.dart';
import 'package:Dimodo/screens/detail/ingredient_screen.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:Dimodo/widgets/image_galery.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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

class CosmeticsProductDetail extends StatefulWidget {
  Product product;
  int rank;

  CosmeticsProductDetail({this.product, this.rank});

  @override
  _CosmeticsProductDetailState createState() => _CosmeticsProductDetailState();
}

class _CosmeticsProductDetailState extends State<CosmeticsProductDetail> {
  bool isLoading = false;
  bool isProductLoaded = false;
  Size screenSize;
  var bottomPopupHeightFactor;
  int totalCount = 0;
  final services = Services();
  var hazardLevel;

  List<String> tabList = [];
  Reviews metaReviews =
      Reviews(totalCount: 0, averageSatisfaction: 100, reviews: <Review>[]);

  bool isLoggedIn = false;
  int offset = 0;
  int limit = 3;
  Product product;
  ProductModel productModel;
  @override
  void initState() {
    super.initState();
    product = widget.product;
    isLoading = true;
    isProductLoaded = false;

    services.getCosmeticsReviews(product.sid).then((onValue) {
      if (this.mounted) {
        setState(() {
          metaReviews = onValue;
        });
        offset += 3;
        totalCount = metaReviews.reviews.length;
        isLoading = false;
      }
    });
    services.getCosmetics(product.sid).then((onValue) {
      if (this.mounted) {
        setState(() {
          product = onValue;
          print("ingredient count, ${product.ingredients.length}");
          isProductLoaded = true;
        });
      }
    });
    productModel = Provider.of<ProductModel>(context, listen: false);
    print("hazardScore: ${product.hazardScore}");
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> getReviews() async {
    var loadedReviews = await services.getCosmeticsReviews(product.sid);
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
    print("product sid: ${product.sid}");
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
    switch (product.hazardScore) {
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
      if (product.ingredients != null) {
        while (index < 3 && product.ingredients.length > index) {
          var card = IngredientCard(
            showDivider: index == 2 ? false : true,
            ingredient: product.ingredients[index],
          );
          widgets.add(card);
          index++;
        }
        return widgets;
      } else {
        return widgets;
      }
    }

    Route _createRoute() {
      List thumbnailList = []..add(product.thumbnail);
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImageGalery(
            images:
                product.descImages != null ? product.descImages : thumbnailList,
            index: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    _onShowGallery(context, images, [index = 0]) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ImageGalery(images: images, index: index);
          });
    }

    return Scaffold(
      backgroundColor: kDefaultBackground,
      bottomNavigationBar:
          product != null ? ProductOption(product, isLoggedIn) : null,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        // expandedHeight: screenSize.height * 0.3,
        brightness: Brightness.light,
        leading: CommonIcons.backIcon(context),
        backgroundColor: Colors.transparent,
      ),
      body: (product == null)
          ? Container(
              height: 1,
            )
          : SafeArea(
              bottom: false,
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(_createRoute()),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: screenSize.width - 20,
                              height: 225,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            CosmeticsImageFeature(
                              product,
                            ),
                            Positioned(
                              bottom: 14,
                              right: 14,
                              child: Container(
                                  // width: 67,
                                  decoration: BoxDecoration(
                                      color: kDarkSecondary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  padding: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      top: 4.5,
                                      bottom: 4.5),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          "assets/icons/image-icon.svg"),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          product.descImages != null
                                              ? product.descImages.length
                                                  .toString()
                                              : "0",
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                      CosmeticsProductTitle(
                        product,
                      ),
                      !isLoading
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(product.rating.substring(0, 3),
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      Text("trên 5",
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          "(${product.purchaseCount.toString()})",
                                          style: kBaseTextStyle.copyWith(
                                              color: kDarkSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: <Widget>[
                                      ReviewRatingBar(
                                          title: "5.0",
                                          percentage: metaReviews.reviews.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.score == 5
                                                          ? previousValue + 1
                                                          : previousValue) /
                                              totalCount),
                                      ReviewRatingBar(
                                          title: "4.0",
                                          percentage: metaReviews.reviews.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.score == 4
                                                          ? previousValue + 1
                                                          : previousValue) /
                                              totalCount),
                                      ReviewRatingBar(
                                          title: "3.0",
                                          percentage: metaReviews.reviews.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.score == 3
                                                          ? previousValue + 1
                                                          : previousValue) /
                                              totalCount),
                                      ReviewRatingBar(
                                          title: "2.0",
                                          percentage: metaReviews.reviews.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.score == 2
                                                          ? previousValue + 1
                                                          : previousValue) /
                                              totalCount),
                                      ReviewRatingBar(
                                          title: "1.0",
                                          percentage: metaReviews.reviews.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      element.score == 1
                                                          ? previousValue + 1
                                                          : previousValue) /
                                              totalCount),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        height: 24.5,
                      ),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 24.5,
                              ),
                              widget.rank != null && widget.rank < 9
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          widget.rank > 3
                                              ? SvgPicture.asset(
                                                  "assets/icons/ranking-list.svg")
                                              : SvgPicture.asset(
                                                  "assets/icons/ranking-list.svg",
                                                  color: kPrimaryOrange),
                                          Text(
                                              "No.${widget.rank + 1} trong danh sách ${product.categoryName}",
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    )
                                  : Container(height: 0),
                              Container(
                                decoration: BoxDecoration(
                                  color: kLightYellow,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: isProductLoaded
                                    ? GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    IngredientScreen(
                                                      widget
                                                          .product.ingredients,
                                                      hazardLevel,
                                                    ))),
                                        child: Container(
                                          width: screenSize.width,
                                          // color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: 56,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Spacer(),
                                                    Text(
                                                        S
                                                            .of(context)
                                                            .ingredientInfo,
                                                        style: kBaseTextStyle
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color:
                                                                    kDarkYellow,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    Spacer(),
                                                    if (metaReviews
                                                            .totalCount !=
                                                        0)
                                                      CommonIcons.forwardIcon(
                                                          context, kDarkYellow)
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(hazardLevel,
                                                      style: kBaseTextStyle
                                                          .copyWith(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  Text(
                                                      S
                                                          .of(context)
                                                          .ewgSafeLevel,
                                                      style: kBaseTextStyle
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                  SizedBox(width: 16)
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              Column(
                                                children: renderIngredients(),
                                              ),
                                              SizedBox(height: 28)
                                            ],
                                          ),
                                        ))
                                    : Container(),
                              ),
                              Container(
                                height: 28,
                              ),
                            ],
                          )),
                    ],
                  ),
                  CosmeticsProductDescription(product),
                  Container(
                    height: 5,
                    color: kDefaultBackground,
                  ),
                  Container(height: 28, color: Colors.white),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CosmeticsReviewScreen(
                                  metaReviews, getReviews, product))),
                      child: !isLoading
                          ? Container(
                              width: screenSize.width,
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                            "Đánh giá r(${product.purchaseCount})",
                                            style: kBaseTextStyle.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
                                        Spacer(),
                                        if (metaReviews.totalCount != 0)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CommonIcons.arrowForward
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  product.descImages != null
                                      ? ReviewImages(product)
                                      : Container(height: 20),
                                  // Container(height: 20, color: Colors.red),
                                  if (metaReviews.totalCount != 0)
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        children: <Widget>[
                                          CosmeticsReviewCard(
                                              isPreview: true,
                                              context: context,
                                              review: metaReviews.reviews[0]),
                                          CosmeticsReviewCard(
                                              isPreview: true,
                                              context: context,
                                              review: metaReviews.reviews[1]),
                                          CosmeticsReviewCard(
                                              isPreview: true,
                                              context: context,
                                              showDivider: false,
                                              review: metaReviews.reviews[2]),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : Container(
                              width: screenSize.width,
                              height: 90,
                              child:
                                  CupertinoActivityIndicator(animating: true),
                            )),
                ],
              ),
            ),
    );
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

class ReviewRatingBar extends StatelessWidget {
  const ReviewRatingBar({
    Key key,
    @required this.title,
    @required this.percentage,
  }) : super(key: key);

  final String title;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: kBaseTextStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBFBFBF)),
          ),
          SizedBox(width: 7),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              animateFromLastPercent: true,
              width: screenSize.width / 2 - 44 - 15,
              animation: true,
              animationDuration: 500,
              lineHeight: 3.0,
              percent: percentage,
              backgroundColor: Colors.white,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: kPrimaryOrange,
            ),
          ),
          SizedBox(width: 7),
          Text(
            (percentage * 100).toInt().toString() + "%",
            textAlign: TextAlign.start,
            style: kBaseTextStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBFBFBF)),
          ),
        ],
      ),
    );
  }
}
