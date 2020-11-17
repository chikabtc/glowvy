import 'package:Dimodo/common/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/styles.dart';
import '../../generated/i18n.dart';
import '../../models/reviews.dart';
import 'cartAction.dart';
import 'review_card.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen(this.metaReviews, this.onLoadMore);

  final Reviews metaReviews;
  final Function onLoadMore;

  @override
  _StateReviews createState() => _StateReviews(metaReviews);
}

class _StateReviews extends State<ReviewScreen>
    with AutomaticKeepAliveClientMixin<ReviewScreen> {
  _StateReviews(this.metaReviews);

  Reviews metaReviews;
  bool isEnd = false;

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
              leading: backIcon(context),
              actions: <Widget>[CartAction()],
              elevation: 0,
              backgroundColor: Colors.white,
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              if (metaReviews == null)
                Container(
                  height: kScreenSizeHeight * 0.7,
                  child: SpinKitThreeBounce(
                      color: kPinkAccent,
                      size: 23.0 * kSizeConfig.containerMultiplier),
                ),
              if (metaReviews.reviews.isEmpty)
                Container(
                  child: Center(
                    child: Text(
                      S.of(context).noReviews,
                      style: kBaseTextStyle,
                    ),
                  ),
                ),
              if (metaReviews.reviews.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 18),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                  '${S.of(context).reviews} (${metaReviews.totalCount})',
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 13,
                                      color: kSecondaryGrey,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(children: <Widget>[
                                  Image.asset(
                                      'assets/icons/product_detail/google-translate.png'),
                                  Text(
                                    S.of(context).translatedByGoogle,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 12,
                                        color: kDarkAccent.withOpacity(0.7)),
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
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    isEnd = await widget.onLoadMore();
                                    setState(() {
                                      print('isend?? $isEnd');
                                      isLoading = false;
                                    });
                                  },
                                  height: 40,
                                  minWidth: 62,
                                  color: kSecondaryWhite,
                                  child: Center(
                                      child: Text(
                                    'Load More',
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        color: kSecondaryGrey,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                      Container(height: 10)
                    ],
                  ),
                )
            ])),
          ])),
    );
  }
}
