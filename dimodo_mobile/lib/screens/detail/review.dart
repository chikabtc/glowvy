import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../common/tools.dart';
import 'dart:math';
import '../../common/constants.dart';
import '../../widgets/image_galery.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/styles.dart';
import '../../generated/i18n.dart';
import '../../models/review.dart';
import '../../services/index.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loadmore/loadmore.dart';

class Reviews extends StatefulWidget {
  final int productId;

  Reviews(this.productId);

  @override
  _StateReviews createState() => _StateReviews(productId);
}

class _StateReviews extends State<Reviews>
    with AutomaticKeepAliveClientMixin<Reviews> {
  final services = Services();
  double rating = 0.0;
  List<Review> reviews;
  final int productId;
  var count = 0;
  bool isEnd = false;

  _StateReviews(this.productId);
  int offset = 0;
  int limit = 3;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    services.getReviews(productId, offset, limit).then((onValue) {
      setState(() {
        reviews = onValue;
      });
      offset += 3;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateRating(double index) {
    setState(() {
      rating = index;
    });
  }

  void getReviews() async {
    var loadedReviews = await services.getReviews(productId, offset, limit);
    if (loadedReviews.length == 0) {
      isEnd = true;
    }
    setState(() {
      // print("reviews received: $loadedReviews");
      isLoading = false;
      loadedReviews.forEach((element) {
        reviews.add(element);
      });
      //
    });
    offset += 3;
    // limit += 3;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return reviews == null
        ? Container(
            height: kScreenSizeHeight * 0.7,
            child: SpinKitThreeBounce(
                color: kPinkAccent,
                size: 23.0 * kSizeConfig.containerMultiplier),
          )
        : (reviews.length == 0
            ? Container(
                child: Center(
                  child: DynamicText(
                    S.of(context).noReviews,
                    style: kBaseTextStyle,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 18),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // Container(
                          //   padding: EdgeInsets.only(left: 16),
                          //   child: DynamicText(
                          //     "Reviews",
                          //     style: kBaseTextStyle.copyWith(
                          //         fontSize: 13,
                          //         fontWeight: FontWeight.w600,
                          //         color: kDarkAccent),
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: kDefaultBackground,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(children: <Widget>[
                              Image.asset(
                                  "assets/icons/product_detail/google-translate.png"),
                              DynamicText(
                                S.of(context).translatedByGoogle,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 12,
                                    color: kDarkAccent.withOpacity(0.7)),
                                textAlign: TextAlign.start,
                              ),
                            ]),
                          ),
                        ]),
                    // SizedBox(height: 50),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (context, i) =>
                            renderItem(context, reviews[i])),
                    isLoading
                        ? SpinKitCircle(
                            color: kPinkAccent,
                            size: 23.0 * kSizeConfig.containerMultiplier)
                        : isEnd
                            ? SvgPicture.asset(
                                'assets/icons/heart-ballon.svg',
                                width: 30,
                                height: 42,
                              )
                            : MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                elevation: 0,
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  getReviews();
                                },
                                height: 40,
                                minWidth: 62,
                                color: kLightBG,
                                child: Center(
                                    child: DynamicText(
                                  "Load More",
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 15,
                                      color: kDarkSecondary,
                                      fontWeight: FontWeight.w600),
                                )),
                              ),
                    Container(height: 10)
                  ],
                ),
              ));
  }

  List<Widget> renderImgs(context, Review review) {
    var imgsButtons = <Widget>[];
    review.images.forEach((element) {
      var imgBtn = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: IconButton(
              iconSize: 150,
              icon: Image.network(
                element,
                fit: BoxFit.fill,
              ),
              onPressed: () => _onShowGallery(context, review.images)));

      imgsButtons.add(imgBtn);
    });
    return imgsButtons;
    //on the external display, the lag is unusable..
  }

  _onShowGallery(context, images, [index = 0]) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ImageGalery(images: images, index: index);
        });
  }

//todo: render imgs gallery
  Widget renderItem(context, Review review) {
    final ThemeData theme = Theme.of(context);
    var sanitizedText = review.text.replaceAll("\n", "");
    var rng = new Random();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2.0)),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //todo: assign the same profile pic
              Image.asset(
                'assets/icons/account/profile${rng.nextInt(2)}.png',
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DynamicText(review.user.name,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    DynamicText(review.product.optionName,
                        style: TextStyle(
                            color: kDarkSecondary.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 10),
                    DynamicText(sanitizedText,
                        style: kBaseTextStyle.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    if (review.images.length != 0)
                      Container(
                        height: 150,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: renderImgs(context, review)),
                      ),
                    // Row(children: renderImgs(context, review)),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 5,
            width: kScreenSizeWidth,
            color: kDefaultBackground,
          ),
        ],
      ),
    );
  }
}
