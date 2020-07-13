import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/reviews.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/screens/detail/cosmetics_image_feature.dart';
import 'package:Dimodo/screens/detail/cosmetics_product_title.dart';
import 'package:Dimodo/screens/detail/cosmetics_review_screen.dart';
import 'package:Dimodo/widgets/bottom_popup_services.dart';
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
import 'cosmetics_product_description.dart';
import '../../services/index.dart';
import '../../models/order/cart.dart';
import 'package:Dimodo/common/tools.dart';

class CosmeticsProductDetail extends StatefulWidget {
  final Product product;

  CosmeticsProductDetail({this.product});

  @override
  _CosmeticsProductDetailState createState() => _CosmeticsProductDetailState();
}

class _CosmeticsProductDetailState extends State<CosmeticsProductDetail> {
  bool isLoading = false;
  Size screenSize;
  var bottomPopupHeightFactor;
  final services = Services();

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
    services.getCosmeticsReviews(widget.product.sid).then((onValue) {
      if (this.mounted) {
        setState(() {
          metaReviews = onValue;
        });
        offset += 3;
      }
    });
    productModel = Provider.of<ProductModel>(context, listen: false);
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
      //
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
          title: DynamicText(
            S.of(context).shippingFeePolicy,
            style: kBaseTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: DynamicText(
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
    var cartModel = Provider.of<CartModel>(context);
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

    return Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
                //todo: check whether the item is loaded or not
                bottomNavigationBar: widget.product != null
                    ? ProductOption(widget.product, isLoggedIn)
                    : null,
                backgroundColor: Colors.white,
                body: Scaffold(
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
                    actions: <Widget>[CartAction()],
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
                                            height: 10,
                                            color: kDefaultBackground,
                                          ),
                                          Container(
                                            height: 84,
                                            width: screenSize.width,
                                            color: Colors.white,
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 20,
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () => showShippingInfo(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      S
                                                          .of(context)
                                                          .importTaxIncluded,
                                                      style: kBaseTextStyle
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  kDarkAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  SizedBox(height: 6),
                                                  Text(
                                                      S
                                                              .of(context)
                                                              .shipFromKorea +
                                                          " | " +
                                                          S.of(context).fee +
                                                          ": ${Tools.getCurrecyFormatted(cartModel.calculateShippingFee(widget.product))}",
                                                      style: kBaseTextStyle
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  kDarkAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 5,
                                            width: screenSize.width,
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 56,
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                DynamicText(
                                                                    "${S.of(context).reviews} (${widget.product.purchaseCount})",
                                                                    style: kBaseTextStyle.copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            kDarkSecondary,
                                                                        fontWeight:
                                                                            FontWeight.w600)),
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
                                                                      DynamicText(
                                                                          S
                                                                              .of(
                                                                                  context)
                                                                              .seeMore,
                                                                          style: kBaseTextStyle.copyWith(
                                                                              fontSize: 12,
                                                                              color: kPinkAccent,
                                                                              fontWeight: FontWeight.w500)),
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
                                                                    .end,
                                                            children: <Widget>[
                                                              DynamicText(
                                                                  widget.product
                                                                      .rating
                                                                      .substring(
                                                                          0, 4),
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          24,
                                                                      color:
                                                                          kPinkAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  width: 16)
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
                                                          if (metaReviews
                                                                  .totalCount !=
                                                              0)
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                CosmeticsReviewCard(
                                                                    isPreview:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    review: metaReviews
                                                                        .reviews[0]),
                                                                CosmeticsReviewCard(
                                                                    isPreview:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    review: metaReviews
                                                                        .reviews[1]),
                                                                CosmeticsReviewCard(
                                                                    isPreview:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    review: metaReviews
                                                                        .reviews[2]),
                                                              ],
                                                            ),
                                                          Container(
                                                            height: 5,
                                                            width:
                                                                kScreenSizeWidth,
                                                            color:
                                                                kDefaultBackground,
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
                                          Container(
                                            height: 10,
                                            color: kDefaultBackground,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () =>
                                                      PopupServices.showQandA(
                                                          context),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        S
                                                            .of(context)
                                                            .officialQA,
                                                        style: kBaseTextStyle
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color:
                                                                    kDarkSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          // DynamicText(
                                                          //     S
                                                          //         .of(context)
                                                          //         .seeMore,
                                                          //     style: kBaseTextStyle.copyWith(
                                                          //         fontSize: 12,
                                                          //         color:
                                                          //             kPinkAccent,
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w500)),
                                                          CommonIcons
                                                              .arrowForwardPink
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 17),
                                                Text(
                                                  S
                                                      .of(context)
                                                      .whyLowerThanMarketPriceQuestion,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  S
                                                      .of(context)
                                                      .whereReviewsFromQuestion,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  S
                                                      .of(context)
                                                      .sameQualityAsInKoreaQuestion,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            color: kDefaultBackground,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              CosmeticsProductDescription(widget.product),
                              SizedBox(height: 100)
                            ],
                          ),
                        ),
                ))));
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