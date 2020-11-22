import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';
import '../../generated/i18n.dart';

class CosmeticsReviewPage extends StatefulWidget {
  final Product product;
  final List<Review> metaReviews;
  final Function onLoadMore;

  const CosmeticsReviewPage(this.metaReviews, this.onLoadMore, this.product);

  @override
  _StateReviews createState() => _StateReviews(metaReviews);
}

class _StateReviews extends State<CosmeticsReviewPage>
    with AutomaticKeepAliveClientMixin<CosmeticsReviewPage> {
  List<Review> reviews;
  bool showFiltered = false;
  List<Review> filteredReviews;
  bool isEnd = false;
  bool isKorean = false;
  List<bool> isSelected;
  var skinTypeId = 0;

  _StateReviews(this.reviews);

  bool isLoading = false;

  @override
  void initState() {
    isSelected = [true, false];
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
              elevation: 0,
              backgroundColor: Colors.white,
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              if (reviews == null)
                Container(
                  height: kScreenSizeHeight * 0.7,
                  child:
                      const SpinKitThreeBounce(color: kPinkAccent, size: 23.0),
                ),
              if (reviews.isEmpty)
                Container(
                  child: Center(
                    child: Text(
                      S.of(context).noReviews,
                      style: textTheme.headline5,
                    ),
                  ),
                ),
              if (reviews.isNotEmpty)
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            top: 19, bottom: 19, left: 16, right: 16),
                        color: Colors.white,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                  '${S.of(context).reviews} (${widget.product.reviewMetas.all.reviewCount})',
                                  style: textTheme.caption1
                                      .copyWith(color: kSecondaryGrey)),
                              const Spacer(),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: kTertiaryGray,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: ToggleButtons(
                                    fillColor: Colors.white,
                                    borderWidth: 0,
                                    selectedBorderColor: Colors.white,
                                    selectedColor: Colors.black,
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 6,
                                            top: 8,
                                            bottom: 8),
                                        child: Text(
                                          'Tiếng Việt',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 6,
                                            right: 10,
                                            top: 8,
                                            bottom: 8),
                                        child: Text(
                                          'Original',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                    onPressed: (int index) {
                                      setState(() {
                                        for (var i = 0;
                                            i < isSelected.length;
                                            i++) {
                                          isSelected[i] = i == index;
                                          isKorean = index == 0;
                                        }
                                      });
                                    },
                                    isSelected: isSelected,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      // CosmeticsReviewFilterBar(
                      //   showSorting: false,
                      //   reviews: metaReviews.reviews,
                      //   onFilterConfirm: (filResults) {
                      //     setState(() {
                      //       filteredReviews = filResults;
                      //       showFiltered = true;
                      //       print('filter :${filResults}\n');
                      //     });
                      //   },
                      //   onReset: () {
                      //     setState(() {
                      //       // this.filteredResults = snapshot.data;
                      //     });
                      //   },
                      //   onSkinTypeChanged: (skinTypeId) {
                      //     setState(() {
                      //       // this.skinTypeId = skinTypeId;
                      //       // filteredReviews = filResults;
                      //       // print('filter :${filResults}\n');
                      //     });
                      //   },
                      // ),
                      ReviewImages(widget.product),
                      Scrollbar(
                        child: Container(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: showFiltered
                                  ? filteredReviews.length
                                  : reviews.length,
                              itemBuilder: (context, i) => CosmeticsReviewCard(
                                  context: context,
                                  isKorean: isKorean,
                                  showDivider: reviews.length - 1 != i,
                                  review: showFiltered
                                      ? filteredReviews[i]
                                      : reviews[i])),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/heart-ballon.svg',
                        width: 30,
                        height: 42,
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
