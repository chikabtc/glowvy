import 'dart:math';

import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/review_model.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:Dimodo/screens/paginated_review_list.dart';
import 'package:Dimodo/widgets/filter_option_button.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../common/colors.dart';
import '../../common/constants.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';
import '../../generated/i18n.dart';

class ReviewsPage extends StatefulWidget {
  final Product product;
  final ListPage<Review> initialPage;

  const ReviewsPage(this.initialPage, this.product);

  @override
  _StateReviews createState() => _StateReviews();
}

class _StateReviews extends State<ReviewsPage>
    with AutomaticKeepAliveClientMixin<ReviewsPage> {
  ListPage<Review> initialPage;
  FilterOptions _filterOptions;
  ReviewModel _reviewModel;
  bool isFiltered = false;
  int randomNumber;

  @override
  void initState() {
    _filterOptions = FilterOptions(
        genders: [], skinIssues: [], skinTypes: [], ageGroups: []);

    initialPage = widget.initialPage;
    _reviewModel = Provider.of<ReviewModel>(context, listen: false);
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
              leading: backIcon(context,
                  onPop: () => _reviewModel.clearPaginationHistory()),
              elevation: 0,
              backgroundColor: Colors.white,
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              if (initialPage == null)
                Container(
                  height: kScreenSizeHeight * 0.7,
                  child:
                      const SpinKitThreeBounce(color: kPinkAccent, size: 23.0),
                ),
              if (initialPage.itemList.isEmpty)
                Container(
                  child: Center(
                    child: Text(
                      S.of(context).noReviews,
                      style: textTheme.headline5,
                    ),
                  ),
                ),
              if (initialPage.itemList.isNotEmpty)
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(top: 19, left: 16, right: 16),
                        color: Colors.white,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                  '${S.of(context).reviews} (${widget.product.reviewMetas.all.reviewCount})',
                                  style: textTheme.caption2),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => showCosmeticsFilter(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Filters', style: textTheme.caption1),
                                    SvgPicture.asset('assets/icons/filter.svg',
                                        width: 24, color: kDarkAccent),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      ReviewImages(widget.product),
                      // PaginatedReviewListView()

                      // if (isFiltered)
                      PaginatedReviewListView(
                        initialPage: widget.initialPage,
                        key: Key(randomNumber.toString()),
                        fetchReviews: () => _reviewModel
                            .getCosmeticsReviews(widget.product.sid),
                        filterOptions: _filterOptions,
                        showPadding: true,
                      ),

                      Container(height: 10)
                    ],
                  ),
                )
            ])),
          ])),
    );
  }

  void showCosmeticsFilter(context) {
    final screenSize = MediaQuery.of(context).size;
    final heightFactor = 1 -
        (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    final genders = <String>['Nữ', 'Nam'];
    final skinTypes = <String>['Da dầu', 'Da khô', 'Da hỗn hợp', 'Da thường'];
    var tempFilterOptions = FilterOptions(
        genders: [], skinIssues: [], skinTypes: [], ageGroups: []);

    if (!_filterOptions.isOptionEmpty()) {
      print('filter exsits');
      tempFilterOptions = _filterOptions;
      //
    }

    final skinIssues = <String>[
      'Mụn',
      'Nhạy cảm',
      'Chàm',
      'Nhăn',
      'Tăng sắc tố da'
    ];

    final ageGroups = <String>[
      'tất cả',
      'dưới 20',
      'từ 20 đến 24',
      'Từ 25 đến 29',
      'từ 30 đến 34',
      'từ 35'
    ];

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    width: screenSize.width,
                    height: screenSize.height,
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                              color: Colors.transparent,
                              height: AppBar().preferredSize.height,
                              width: screenSize.width,
                              child: Center(
                                child: Text(S.of(context).choose,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              )),
                          Positioned(
                            top: 6,
                            right: 0,
                            child: IconButton(
                                icon: SvgPicture.asset(
                                    'assets/icons/address/close-popup.svg'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          )
                        ]),
                        Container(
                          height: screenSize.height * heightFactor -
                              AppBar().preferredSize.height -
                              100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  'Skin Type',
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                kFullDivider,
                                Wrap(children: <Widget>[
                                  for (var skinType in skinTypes)
                                    FilterOptionButton(
                                      name: skinType,
                                      onTap: () {
                                        setModalState(() {
                                          if (tempFilterOptions.skinTypes
                                              .contains(skinType)) {
                                            print('why is that');
                                            tempFilterOptions.skinTypes
                                                .remove(skinType);
                                          } else {
                                            tempFilterOptions.skinTypes
                                                .add(skinType);
                                          }
                                          print(
                                              'tem : ${tempFilterOptions.skinTypes}');
                                        });
                                      },
                                      isSelected: tempFilterOptions.skinTypes
                                          .contains(skinType),
                                    )
                                ]),
                                Text(
                                  'Skin Issues',
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                kFullDivider,
                                Wrap(children: <Widget>[
                                  for (var skinIssue in skinIssues)
                                    FilterOptionButton(
                                      name: skinIssue,
                                      onTap: () {
                                        setModalState(() {
                                          if (tempFilterOptions.skinIssues
                                              .contains(skinIssue)) {
                                            tempFilterOptions.skinIssues
                                                .remove(skinIssue);
                                          } else {
                                            tempFilterOptions.skinIssues
                                                .add(skinIssue);
                                          }
                                        });
                                      },
                                      isSelected: tempFilterOptions.skinIssues
                                          .contains(skinIssue),
                                    )
                                ]),
                                Text(
                                  'Age',
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                kFullDivider,
                                Wrap(children: <Widget>[
                                  for (var ageGroup in ageGroups)
                                    FilterOptionButton(
                                      name: ageGroup,
                                      onTap: () {
                                        setModalState(
                                          () {
                                            if (tempFilterOptions.ageGroups
                                                .contains(ageGroup)) {
                                              tempFilterOptions.ageGroups
                                                  .remove(ageGroup);
                                            } else {
                                              tempFilterOptions.ageGroups
                                                  .add(ageGroup);
                                            }
                                          },
                                        );
                                      },
                                      isSelected: tempFilterOptions.ageGroups
                                          .contains(ageGroup),
                                    )
                                ]),
                                Text(
                                  'Gender',
                                  style: kBaseTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                kFullDivider,
                                Wrap(children: <Widget>[
                                  for (var gender in genders)
                                    FilterOptionButton(
                                      name: gender,
                                      onTap: () {
                                        setModalState(() {
                                          if (tempFilterOptions.genders
                                              .contains(gender)) {
                                            tempFilterOptions.genders
                                                .remove(gender);
                                          } else {
                                            tempFilterOptions.genders
                                                .add(gender);
                                          }
                                        });
                                      },
                                      isSelected: tempFilterOptions.genders
                                          .contains(gender),
                                    )
                                ])
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              height:
                                  60.0 + MediaQuery.of(context).padding.bottom,
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 9.0, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    MaterialButton(
                                        elevation: 0,
                                        minWidth: (screenSize.width - 48) * 0.5,
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: const BorderSide(
                                                color: kPrimaryOrange,
                                                width: 1.5)),
                                        child: Text(S.of(context).reset,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: kPinkAccent)),
                                        onPressed: () {
                                          //1. clear the filterOptions UIs
                                          tempFilterOptions = FilterOptions(
                                              genders: [],
                                              skinIssues: [],
                                              skinTypes: [],
                                              ageGroups: []);
                                          setModalState(() {
                                            _filterOptions = tempFilterOptions;
                                          });
                                          //2. show the original review list
                                          setState(() {
                                            isFiltered = false;
                                          });
                                        }),
                                    const SizedBox(width: 16),
                                    MaterialButton(
                                        elevation: 0,
                                        color: kPrimaryOrange,
                                        minWidth: (screenSize.width - 48) * 0.5,
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: const BorderSide(
                                                color: kPinkAccent,
                                                width: 1.5)),
                                        child: Text(S.of(context).confirm,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        onPressed: () {
                                          setState(() {
                                            _filterOptions = tempFilterOptions;
                                          });
                                          final random = Random();
                                          randomNumber = random.nextInt(90) +
                                              10; // from 10 upto 99 included
                                          // print(_filterOptions.skinTypes);

                                          Navigator.pop(context);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }
}
