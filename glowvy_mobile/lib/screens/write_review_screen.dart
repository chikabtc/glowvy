import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/icons.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/services/index.dart';
import 'package:Dimodo/widgets/cosmetics_request_button.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../generated/i18n.dart';
import 'package:algolia/algolia.dart';

class WriteReviewScreen extends StatefulWidget {
  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen>
    with TickerProviderStateMixin {
  Size screenSize;
  AnimationController _shareBtnController;
  final TextEditingController _reviewTextController = TextEditingController();

  Services service = Services();

  String reviewText;
  Product product;

  int rating = 0;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _shareBtnController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  uploadReview(reviewText, rating, {Function success, fail}) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    var review = {
      'content': reviewText,
      'user': userModel.user.toJson(),
      'product_id': product.sid,
      'rating': rating,
      'created_at': FieldValue.serverTimestamp()
    };
    print("review: ${review}");
    try {
      await service.writeReview(review);
      success();
    } catch (e) {
      fail(e);
    }
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _shareBtnController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _shareBtnController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  getRatingExpression() {
    switch (rating) {
      case 0:
        return 'Tap to rate';
        break;
      case 1:
        return 'Tap to rate2';
        break;
      case 2:
        return 'Tap to rate1';
        break;
      case 3:
        return 'Tap to rat4e';
        break;
      case 4:
        return 'Tap to rate4';
        break;
      case 5:
        return 'Tap to rate5';
        break;
      default:
    }
  }

  showPop() {
    showDialog(
        context: context,
        barrierColor: Color(0x01000000),
        builder: (_) => Center(
            // Aligns the container to center
            child: Container(
                decoration: BoxDecoration(
                    color: kDarkAccent,
                    borderRadius: BorderRadius.circular(44)),
                // A simplified version of dialog.
                width: 152.0,
                height: 44.0,
                child: Center(
                  child: Text(
                    'posted successfully',
                    style: textTheme.caption2.copyWith(
                        color: Colors.white, decoration: TextDecoration.none),
                  ),
                ))));
  }

  onProductSelect(Product product) {
    this.product = product;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kSecondaryWhite,
        bottomNavigationBar: Container(
          color: kSecondaryWhite,
          // height: 79,
          padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 29),
          child: Text(
            "To ensure effectiveness and fairness, learn more about review guidelines here",
            style: textTheme.caption1
                .copyWith(fontWeight: FontWeight.w600, color: kSecondaryGrey),
          ),
        ),
        // bottomNavigationBar: Container(
        //   color: kSecondaryWhite,
        //   child: Padding(
        //     padding: const EdgeInsets.only(
        //         top: 27, left: 16, right: 16, bottom: 35.0),
        //     child: StaggerAnimation(
        //         btnColor: kPrimaryOrange,
        //         buttonTitle: S.of(context).share,
        //         buttonController: _shareBtnController.view,
        //         onTap: () async {
        //           _playAnimation();
        //           await uploadReview(reviewText, rating, success: () {
        //             Future.delayed(const Duration(milliseconds: 500), () {
        //               setState(() {
        //                 _stopAnimation();
        //                 Navigator.popUntil(
        //                     context, ModalRoute.withName('/setting'));
        //               });
        //             });
        //           }, fail: (user) {
        //             print("fail to upload");
        //             _stopAnimation();
        //           });
        //           // Future.delayed(const Duration(milliseconds: 500), () {
        //           //   setState(() {
        //           //     _stopAnimation();
        //           //     Navigator.popUntil(
        //           //         context, ModalRoute.withName('/login'));
        //           //   });
        //           // });
        //         }),
        //   ),
        // ),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: kDefaultBackground2,
          leading: IconButton(
              onPressed: () => reviewText == null
                  ? Navigator.of(context).pop()
                  : Navigator.of(context).pop(),
              icon: SvgPicture.asset(
                'assets/icons/arrow_backward.svg',
                width: 26,
                color: kDarkAccent,
              )),
          actions: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReviewCosmeticsSearchScreen())),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    "Post",
                    style: textTheme.button1.copyWith(color: kPrimaryOrange),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Container(
              color: kDefaultBackground2,
              height: screenSize.height,
              child: Consumer<UserModel>(builder: (context, userModel, child) {
                print("product added!");
                return ListView(
                  children: <Widget>[
                    if (userModel.productInReview == null)
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReviewCosmeticsSearchScreen())),
                        child: Container(
                          color: kDefaultBackground2,
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/icons/search_cosmetics.svg',
                              ),
                              SizedBox(width: 7),
                              Text("Select cosmetics",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.button2),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/icons/arrow_forward.svg',
                                width: 24,
                                color: kSecondaryGrey,
                              )
                            ],
                          ),
                        ),
                      ),
                    if (userModel.productInReview != null)
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReviewCosmeticsSearchScreen())),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.cover,
                                child: Tools.image(
                                  url: product.thumbnail,
                                  fit: BoxFit.cover,
                                  width: 34,
                                  height: 36,
                                  size: kSize.large,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  height: 35,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 2),
                                      Text("${product.name}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.button2),
                                      Text("${product.name}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.caption2),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Change",
                                    style: textTheme.caption1
                                        .copyWith(color: kSecondaryGrey),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/arrow_forward.svg',
                                    width: 24,
                                    color: kSecondaryGrey,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        SizedBox(height: 7),
                        Text(getRatingExpression(),
                            style: textTheme.caption1
                                .copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 20),
                        RatingBar(
                            initialRating: 0,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: SvgPicture.asset(
                                  'assets/icons/rank-flower.svg',
                                  color: kPrimaryOrange),
                              half: SvgPicture.asset(
                                  'assets/icons/rank-flower.svg'),
                              empty: SvgPicture.asset(
                                  'assets/icons/rank-flower.svg'),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) => setState(() {
                                  print(rating);
                                  this.rating = rating.toInt();
                                })),
                        SizedBox(height: 27),
                        Container(
                          height: screenSize.height -
                              367 +
                              MediaQuery.of(context).padding.top,
                          // color: Colors.red,
                          child: TextFormField(
                            controller: _reviewTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            cursorColor: kPinkAccent,
                            onChanged: (value) => reviewText = value,
                            style: textTheme.headline5
                                .copyWith(color: kDefaultFontColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintMaxLines: 10,
                              hintText:
                                  'Share any thoughts about this product (advantage, disadvantage, result, how to use...)',
                              hintStyle: textTheme.headline5.copyWith(
                                color: kSecondaryGrey.withOpacity(0.5),
                              ),
                              contentPadding: EdgeInsets.only(left: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              })),
        ));
  }
}
