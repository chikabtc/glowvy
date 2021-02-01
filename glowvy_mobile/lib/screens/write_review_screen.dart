import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/screens/setting/login.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'package:Dimodo/widgets/product_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WriteReviewScreen extends StatefulWidget {
  final ScrollController scrollController;
  Function onReviewComplete;
  WriteReviewScreen({this.scrollController, this.onReviewComplete});
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
      throw 'Sản phẩm chưa được chọn';
    } else if (review.rating == 0 || review.rating == null) {
      throw 'select rating';
    } else if (review.content == null) {
      throw 'content too shorts at least over 20 characters';
    } else if (review.content.length < 20) {
      throw 'content too shorts at least over 20 characters';
    } else if (review.content.length > 5000) {
      throw 'content too long (up to 5000 chars';
    }
  }

  Future uploadReview(context) async {
    try {
      final user = userModel.user;
      validateInput();

      final reviewJson = {
        'content': review.content,
        'user': {
          'uid': user.uid,
          'full_name': user.fullName,
          'skin_type': user.skinType,
          'email': user.email,
          'birth_year': user.birthYear,
        },
        'product': {
          'name': review.product.name,
          'brand': review.product.brand.toJson(),
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
      Popups.showSuccesPopup(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
      widget.onReviewComplete();
    } catch (e) {
      await _postButtonController.reverse();
      Popups.failMessage(e.toString(), context);
    }
  }

  String getRatingExpression() {
    if (review != null) {
      switch (review.rating) {
        case 1:
          return 'Siêu tệ!';
          break;
        case 2:
          return ' Khá tệ ';
          break;
        case 3:
          return 'Bình thường';
          break;
        case 4:
          return 'Ổn áp';
          break;
        case 5:
          return 'Siêu tốt!';
          break;
        case 0:
          return 'Nhấn để đánh giá';
          break;
        default:
          return 'nhấn để đánh giá';
      }
    }
  }

  Future askSaveDraft() {
    final act = CupertinoActionSheet(
        title: Container(
          child: Text(
              'Nếu bạn rời khỏi trang này, đánh giá của bạn sẽ bị hủy bỏ',
              style: textTheme.caption1),
        ),
        actions: <Widget>[
          Container(
            // color: kDefaultBackground2,
            child: CupertinoActionSheetAction(
              child: Text('Bỏ đánh giá',
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
              child: Text('Lưu bản nháp', style: textTheme.bodyText1),
              onPressed: () async {
                if (userModel.isLoggedIn) {
                  await userModel.saveDraft(review);
                } else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }
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
            child: Text('Tiếp tục chỉnh sửa', style: textTheme.bodyText1),
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
    onBackButtonClick() {
      if (review.content == null &&
          review.rating == null &&
          review.product == null) {
        Navigator.pop(context);
      } else {
        askSaveDraft();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        onBackButtonClick();
      },
      child: Scaffold(
          backgroundColor: kSecondaryWhite,
          bottomNavigationBar: SafeArea(
            child: Container(
              color: kSecondaryWhite,
              // height: 79,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 14, bottom: 14),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  Popups.showReviewGuidelines(context);
                },
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kSecondaryGrey.withOpacity(0.5)),
                    children: <TextSpan>[
                      const TextSpan(
                          text:
                              'Cùng Glowvy xây dựng một cộng đồng làm đẹp lành mạnh và hiệu quả với '),
                      TextSpan(
                          text: 'Chính sách đánh giá sản phẩm chất lượng',
                          style: textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kPrimaryBlue,
                          )),
                      const TextSpan(text: ' trước khi bắt đầu viết nha'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            backgroundColor: kWhite,
            leading: backIcon(context, onPop: () {
              onBackButtonClick();
            }),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Builder(
                    builder: (context) => StaggerAnimation(
                      btnColor: kPrimaryOrange,
                      width: 57,
                      height: 34,
                      buttonTitle: 'Xong',
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
                child:
                    Consumer<UserModel>(builder: (context, userModel, child) {
                  var user = userModel.user;
                  //1. if review draft is available, load the draft
                  if (user.reviewDraft != null) {
                    review = user.reviewDraft;
                    // print('user.reviewDraft ${user.reviewDraft.toJson()}');
                    _reviewTextController.text = review.content;

                    //2. if product is chosen
                  } else if (review != Review() && user.reviewDraft != null) {
                    if (user.reviewDraft.product != null) {
                      review.product = user.reviewDraft.product;
                    }
                  }

                  return ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/icons/search_cosmetics.svg',
                                ),
                                const SizedBox(width: 7),
                                Text('chọn sản phẩm',
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
                                        ReviewCosmeticsSearchScreen())),
                            child: ProductThumbnail(
                              review.product,
                              allowEdit: true,
                            )),
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
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
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
                              autofocus: false,
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
                                    'Hãy chia sẻ cảm xúc và trải nghiệm của bạn về sản phẩm này nhé (bất cứ điều gì như ưu nhược điểm, kết quả sau khi sử dụng, bạn đã dùng như thế nào, v.v.)',
                                hintStyle: textTheme.headline5.copyWith(
                                  color: kSecondaryGrey.withOpacity(0.5),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 16, right: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                })),
          )),
    );
  }
}
