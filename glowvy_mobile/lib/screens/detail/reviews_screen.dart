import 'dart:math';

import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/review_model.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:Dimodo/screens/paginated_review_list.dart';
import 'package:Dimodo/screens/setting/login.dart';
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

class ReviewsScreen extends StatefulWidget {
  final Product product;
  final ListPage<Review> initialPage;

  const ReviewsScreen(this.initialPage, this.product);

  @override
  _StateReviews createState() => _StateReviews();
}

class _StateReviews extends State<ReviewsScreen>
    with AutomaticKeepAliveClientMixin<ReviewsScreen> {
  ListPage<Review> initialPage;
  ListPreferences _listPreferences;
  ReviewModel _reviewModel;
  bool isFiltered = false;
  int randomNumber;
  List<bool> isSelected;
  UserModel _userModel;
  Future<ListPage<Review>> getReviews;
  String _orderBy = 'Mới nhất';

  @override
  void initState() {
    _listPreferences = ListPreferences.init();

    isSelected = [true, false];
    _userModel = Provider.of<UserModel>(context, listen: false);
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

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: backIcon(context, onPop: () {
          _reviewModel.clearPaginationHistory();
          Navigator.pop(context);
        }),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 19, left: 16, right: 16),
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => showSortOptions(context),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/sort.svg',
                                      color: kDarkSecondary,
                                      width: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(_orderBy ?? '',
                                        style: textTheme.caption1
                                            .copyWith(color: kDarkSecondary))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text('My Skin Type', style: textTheme.caption1),
                          Switch(
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                            activeColor: Colors.white,
                            activeTrackColor: kPrimaryOrange,
                            inactiveTrackColor: kSecondaryGrey.withOpacity(0.7),
                            onChanged: (newValue) {
                              setState(() {
                                _reviewModel.clearPaginationHistory();
                                //1.check if the user is logged in
                                if (_userModel.isLoggedIn) {
                                  //2.set filter to my skin type filter
                                  if (newValue) {
                                    _listPreferences = _reviewModel
                                        .getUserSkinFilter(_userModel.user);
                                  } else {
                                    _listPreferences = ListPreferences.init();
                                  }
                                  isFiltered = newValue;
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                }
                              });
                            },
                            value: isFiltered,
                          ),
                          GestureDetector(
                            onTap: () => showFilterOptions(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 15,
                                    width: 0.5,
                                    color: kSecondaryGrey),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/filter.svg',
                                  color: _listPreferences.isOptionEmpty()
                                      ? kSecondaryGrey
                                      : kPrimaryOrange,
                                  width: 24,
                                ),
                                Text('Filters',
                                    style: textTheme.caption1.copyWith(
                                        color: _listPreferences.isOptionEmpty()
                                            ? kDefaultFontColor
                                            : kPrimaryOrange))
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          if (initialPage == null)
                            Container(
                              height: kScreenSizeHeight * 0.7,
                              child: const SpinKitThreeBounce(
                                  color: kPinkAccent, size: 23.0),
                            ),
                          if (initialPage.itemList.isNotEmpty)
                            ReviewImages(widget.product),
                          Container(height: 10)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: PaginatedReviewListView(
            key: Key(randomNumber.toString()),
            productId: widget.product.sid,
            listPreferences: _listPreferences,
            showPadding: true,
          )),
    );
  }

  void showFilterOptions(context) {
    final screenSize = MediaQuery.of(context).size;
    final heightFactor = 1 -
        (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    final genders = <String>['Nữ', 'Nam'];
    final skinTypes = <String>['Da dầu', 'Da khô', 'Da hỗn hợp', 'Da thường'];
    var tempFilterOptions = ListPreferences.init();

    if (!_listPreferences.isOptionEmpty()) {
      print('filter exsits');
      tempFilterOptions = _listPreferences;
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
      'dưới 20',
      'từ 20 đến 24',
      'Từ 25 đến 29',
      'từ 30 đến 34',
      'từ 35'
    ];

    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        // backgroundColor: Colors.transparent,
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
                                          if (tempFilterOptions.skinType ==
                                              skinType) {
                                            tempFilterOptions.skinType = null;
                                          } else {
                                            tempFilterOptions.skinType =
                                                skinType;
                                          }
                                          print(
                                              'tem : ${tempFilterOptions.skinType}');
                                        });
                                      },
                                      isSelected: tempFilterOptions.skinType ==
                                          skinType,
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

                                          setModalState(() {
                                            tempFilterOptions =
                                                ListPreferences.init();
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
                                          _reviewModel.clearPaginationHistory();

                                          setState(() {
                                            final random = Random();
                                            randomNumber =
                                                random.nextInt(90) + 10;
                                            _listPreferences =
                                                tempFilterOptions;
                                          });

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

  void showSortOptions(context) {
    final screenSize = MediaQuery.of(context).size;

    final options = <String>[
      'Mới nhất',
      'Cũ nhất',
      'Được yêu thích nhất',
      'Xếp hạng cao',
      'Xếp hạng thấp'
    ];

    showModalBottomSheet(
        isScrollControlled: true,

        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: screenSize.width,
                height: 330,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: kQuaternaryGrey,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                setState(() {
                                  _reviewModel.clearPaginationHistory();
                                  setModalState(() {
                                    final random = Random();
                                    randomNumber = random.nextInt(90) + 10;
                                    //set the descending value
                                    //set the field name
                                    _orderBy = options[index];
                                    switch (index) {
                                      case 0:
                                        _listPreferences.orderBy = 'created_at';
                                        _listPreferences.isDescending = true;
                                        break;
                                      case 1:
                                        _listPreferences.orderBy = 'created_at';
                                        _listPreferences.isDescending = false;
                                        break;
                                      case 2:
                                        _listPreferences.orderBy = 'like_count';
                                        _listPreferences.isDescending = true;
                                        break;
                                      case 3:
                                        _listPreferences.orderBy = 'rating';
                                        _listPreferences.isDescending = true;
                                        break;
                                      case 4:
                                        _listPreferences.orderBy = 'rating';
                                        _listPreferences.isDescending = false;
                                        break;
                                      default:
                                    }
                                  });
                                  //pass the sort option to the paginated review list
                                });
                                Navigator.pop(context);
                              },
                              trailing: _orderBy == options[index]
                                  ? const Icon(
                                      Icons.check,
                                      color: kPrimaryOrange,
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: kPrimaryOrange,
                                      size: 0,
                                    ),
                              title: Text(options[index],
                                  style: textTheme.bodyText1),
                            ),
                            if (index != options.length - 1) kDivider,
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
