import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WriteReviewScreen extends StatefulWidget {
  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen>
    with TickerProviderStateMixin {
  Size screenSize;
  AnimationController _postButtonController;
  final TextEditingController _reviewTextController = TextEditingController();

  Review review = Review();
  UserModel userModel;
  bool isLoading = false;
  bool isRatingEmpty = false;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    // print('user:${userModel.user.toJson()}');

    _postButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _postButtonController.dispose();
    super.dispose();
  }

  void validateInput() {
    if (review.product == null) {
      throw 'select product';
    } else if (review.rating == 0) {
      throw 'select rating';
    } else if (review.content == null) {
      throw 'content too show at least over 20 characters';
    } else if (review.content.length < 20) {
      throw 'content too show at least over 20 characters';
    } else if (review.content.length > 5000) {
      throw 'content too long (up to 5000 chars';
    }
  }

  Future uploadReview(context) async {
    try {
      final user = userModel.user;
      validateInput();

      var reviewJson = {
        'text': review.content,
        'user': {
          'uid': user.uid,
          'full_name': user.fullName,
          'skin_type': 'dry',
          'email': user.email,
          'birth_year': user.birthYear,
        },
        'product': {
          'name': review.product.sname,
          'brand_name': review.product.brand.name,
          'category': review.product.category.toJson(),
          'thumbnail': review.product.thumbnail,
          'sid': review.product.sid,
        },
        'rating': review.rating,
        'like_count': 0,
        'created_at': DateTime.now().millisecondsSinceEpoch
      };

      await userModel.uploadReview(reviewJson);
      await _postButtonController.reverse();
      showSuccesPopup();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      await _postButtonController.reverse();
      Popups.simpleAlert(context, e);
    }
  }

  String getRatingExpression() {
    if (review != null) {
      switch (review.rating) {
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
          return 'Tap to rate';
      }
    } else {
      return 'Tap to rate';
    }
  }

  void showSuccesPopup() {
    BuildContext dialogContext;
    showDialog(
        context: context,
        barrierColor: Color(0x01000000),
        builder: (BuildContext context) {
          dialogContext = context;

          return Center(
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
                  )));
        }).then((value) {});
  }

  Future askSaveDraft() {
    final act = CupertinoActionSheet(
        title: Container(
          child: Text('If you go back now, your review edits will discarded.',
              style: textTheme.caption1),
        ),
        actions: <Widget>[
          Container(
            // color: kDefaultBackground2,
            child: CupertinoActionSheetAction(
              child: Text('Discard',
                  style: textTheme.bodyText1.copyWith(color: kPrimaryOrange)),
              onPressed: () async {
                // userModel
                await userModel.discardReviewDraft();
                Navigator.of(context, rootNavigator: true).pop('Discard');

                Navigator.pop(context);
              },
            ),
          ),
          Container(
            // color: kDefaultBackground2,
            child: CupertinoActionSheetAction(
              child: Text('Save Draft', style: textTheme.bodyText1),
              onPressed: () async {
                await userModel.saveDraft(review);
                Navigator.of(context, rootNavigator: true).pop('Discard');
                Navigator.pop(context);
                print('pressed');
              },
            ),
          )
        ],
        cancelButton: Container(
          decoration: BoxDecoration(
              color: Color(0xffEFEFEF),
              borderRadius: BorderRadius.circular(16)),
          child: CupertinoActionSheetAction(
            child: Text('Cancel', style: textTheme.bodyText1),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('Discard');
            },
          ),
        ));
    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => act);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    // if (user)

    return Scaffold(
        backgroundColor: kSecondaryWhite,
        bottomNavigationBar: SafeArea(
          child: Container(
            color: kSecondaryWhite,
            // height: 79,
            padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 14),
            child: GestureDetector(
              onTap: () => print('gp'),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: textTheme.caption1.copyWith(
                      fontWeight: FontWeight.w600, color: kSecondaryGrey),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            'To ensure effectiveness and fairness, learn more about '),
                    TextSpan(
                        text: 'review guidelines ',
                        style: textTheme.bodyText2.copyWith(
                          color: kPrimaryBlue,
                        )),
                    TextSpan(text: 'here'),
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: kWhite,
          leading: IconButton(
              onPressed: () =>
                  review == null ? Navigator.of(context).pop() : askSaveDraft(),
              icon: SvgPicture.asset(
                'assets/icons/arrow_backward.svg',
                width: 26,
                color: kDarkAccent,
              )),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Builder(
                  builder: (context) => StaggerAnimation(
                    btnColor: kPrimaryOrange,
                    width: 57,
                    height: 34,
                    buttonTitle: 'Done',
                    buttonController: _postButtonController.view,
                    onTap: () async {
                      _postButtonController.forward();
                      await uploadReview(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Container(
              color: kWhite,
              height: screenSize.height,
              child: Consumer<UserModel>(builder: (context, userModel, child) {
                var user = userModel.user;
                //1. if review draft is available, load the draft
                if (user.reviewDraft != null) {
                  review = user.reviewDraft;
                  print('user.reviewDraft ${user.reviewDraft.toJson()}');
                  _reviewTextController.text = review.content;

                  //2. if product is chosen
                } else if (review != Review() && user.reviewDraft != null) {
                  if (user.reviewDraft.product != null) {
                    review.product = user.reviewDraft.product;
                  }
                }

                return ListView(
                  children: <Widget>[
                    if (review.product == null)
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReviewCosmeticsSearchScreen())),
                        child: Container(
                          color: kWhite,
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/icons/search_cosmetics.svg',
                              ),
                              const SizedBox(width: 7),
                              Text('Select cosmetics',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.button2),
                              const Spacer(),
                              SvgPicture.asset(
                                'assets/icons/arrow_forward.svg',
                                width: 24,
                                color: kSecondaryGrey,
                              )
                            ],
                          ),
                        ),
                      ),
                    if (review.product != null)
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReviewCosmeticsSearchScreen(
                                      isEditing: true,
                                    ))),
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
                                  url: review.product.thumbnail,
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
                                      const SizedBox(height: 2),
                                      Text('${review.product.name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.button2),
                                      Text('${review.product.name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.caption2),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Change',
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
                        const SizedBox(height: 7),
                        Text(
                            !isRatingEmpty
                                ? getRatingExpression()
                                : 'Please Rate',
                            style: textTheme.caption1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: !isRatingEmpty
                                    ? kDefaultFontColor
                                    : kPrimaryOrange)),
                        const SizedBox(height: 20),
                        RatingBar(
                            initialRating: review.rating != null
                                ? review.rating.toDouble()
                                : 0,
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
                                  isRatingEmpty = false;
                                  print(rating);
                                  review.rating = rating.toInt();
                                })),
                        const SizedBox(height: 27),
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
                            onChanged: (value) {
                              review ??= Review();
                              review.content = value;
                            },
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
