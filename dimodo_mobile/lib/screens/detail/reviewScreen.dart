import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'dart:math';
import '../../common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/styles.dart';
import '../../generated/i18n.dart';
import '../../models/reviews.dart';
import '../../services/index.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'review_card.dart';
import 'package:flutter/cupertino.dart';
import 'cartAction.dart';

class ReviewScreen extends StatefulWidget {
  final Reviews metaReviews;
  final Function onLoadMore;

  ReviewScreen(this.metaReviews, this.onLoadMore);

  @override
  _StateReviews createState() => _StateReviews(metaReviews);
}

class _StateReviews extends State<ReviewScreen>
    with AutomaticKeepAliveClientMixin<ReviewScreen> {
  final services = Services();
  Reviews metaReviews;
  bool isEnd = false;

  _StateReviews(this.metaReviews);

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          color: Colors.white,
          width: screenSize.width,
          height: screenSize.height,
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              leading: IconButton(
                icon: CommonIcons.arrowBackward,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[CartAction()],
              elevation: 0,
              backgroundColor: Colors.white,
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              metaReviews == null
                  ? Container(
                      height: kScreenSizeHeight * 0.7,
                      child: SpinKitThreeBounce(
                          color: kPinkAccent,
                          size: 23.0 * kSizeConfig.containerMultiplier),
                    )
                  : (metaReviews.reviews.length == 0
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      DynamicText(
                                          "${S.of(context).reviews} (${metaReviews.totalCount})",
                                          style: kBaseTextStyle.copyWith(
                                              fontSize: 13,
                                              color: kDarkSecondary,
                                              fontWeight: FontWeight.w600)),
                                      Spacer(),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Row(children: <Widget>[
                                          Image.asset(
                                              "assets/icons/product_detail/google-translate.png"),
                                          DynamicText(
                                            S.of(context).translatedByGoogle,
                                            style: kBaseTextStyle.copyWith(
                                                fontSize: 12,
                                                color: kDarkAccent
                                                    .withOpacity(0.7)),
                                            textAlign: TextAlign.start,
                                          ),
                                        ]),
                                      ),
                                    ]),
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: metaReviews.reviews.length,
                                  itemBuilder: (context, i) => ReviewCard(
                                      context: context,
                                      review: metaReviews.reviews[i])),
                              isLoading
                                  ? SpinKitCircle(
                                      color: kPinkAccent,
                                      size: 23.0 *
                                          kSizeConfig.containerMultiplier)
                                  : isEnd
                                      ? SvgPicture.asset(
                                          'assets/icons/heart-ballon.svg',
                                          width: 30,
                                          height: 42,
                                        )
                                      : MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          elevation: 0,
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            isEnd = await widget.onLoadMore();
                                            print("isend?? $isEnd");
                                            isLoading = false;
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
                        ))
            ])),
          ])),
    );
  }
}
