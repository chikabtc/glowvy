import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/widgets/cosmetics_review_filter_bar.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/styles.dart';
import '../../generated/i18n.dart';
import '../../models/reviews.dart';
import '../../services/index.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'cartAction.dart';

class CosmeticsReviewScreen extends StatefulWidget {
  final Product product;
  final Reviews metaReviews;
  final Function onLoadMore;

  CosmeticsReviewScreen(this.metaReviews, this.onLoadMore, this.product);

  @override
  _StateReviews createState() => _StateReviews(metaReviews);
}

class _StateReviews extends State<CosmeticsReviewScreen>
    with AutomaticKeepAliveClientMixin<CosmeticsReviewScreen> {
  final services = Services();
  Reviews metaReviews;
  bool showFiltered = false;
  List<Review> filteredReviews;
  bool isEnd = false;
  bool isKorean = false;
  List<bool> isSelected;
  var skinTypeId = 0;

  _StateReviews(this.metaReviews);

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
                      child: SpinKitThreeBounce(color: kPinkAccent, size: 23.0),
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
                                          "${S.of(context).reviews} (${widget.product.purchaseCount})",
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
                                        child: Container(
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: kTertiaryGray,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: ToggleButtons(
                                            fillColor: Colors.white,
                                            borderWidth: 0,
                                            selectedBorderColor: Colors.white,
                                            selectedColor: Colors.black,
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 6,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  'Tiếng Việt',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6,
                                                    right: 10,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  'Original',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ],
                                            onPressed: (int index) {
                                              setState(() {
                                                for (int i = 0;
                                                    i < isSelected.length;
                                                    i++) {
                                                  isSelected[i] = i == index;
                                                  isKorean =
                                                      index == 0 ? false : true;
                                                }
                                              });
                                            },
                                            isSelected: isSelected,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              CosmeticsReviewFilterBar(
                                showSorting: false,
                                reviews: metaReviews.reviews,
                                onFilterConfirm: (filResults) {
                                  setState(() {
                                    filteredReviews = filResults;
                                    showFiltered = true;
                                    print("filter :${filResults}\n");
                                  });
                                },
                                onReset: () {
                                  setState(() {
                                    // this.filteredResults = snapshot.data;
                                  });
                                },
                                onSkinTypeChanged: (skinTypeId) {
                                  setState(() {
                                    // this.skinTypeId = skinTypeId;
                                    // filteredReviews = filResults;
                                    // print("filter :${filResults}\n");
                                  });
                                },
                              ),
                              Scrollbar(
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: showFiltered
                                        ? filteredReviews.length
                                        : metaReviews.reviews.length,
                                    itemBuilder: (context, i) =>
                                        CosmeticsReviewCard(
                                            context: context,
                                            isKorean: isKorean,
                                            review: showFiltered
                                                ? filteredReviews[i]
                                                : metaReviews.reviews[i])),
                              ),
                              SvgPicture.asset(
                                'assets/icons/heart-ballon.svg',
                                width: 30,
                                height: 42,
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
