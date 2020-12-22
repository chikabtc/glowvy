import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/product/review_model.dart';
import 'package:Dimodo/screens/detail/product_description.dart';
import 'package:Dimodo/widgets/baumann_quiz.dart';
import 'package:Dimodo/widgets/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Popups {
  static void failMessage(message, context) {
    FocusScope.of(context).requestFocus(FocusNode());

    final snackBar = SnackBar(
      content: Text(
        '$message',
        style: textTheme.headline5.copyWith(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccesPopup(context, {message = 'success'}) {
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
                      message,
                      style: textTheme.caption2.copyWith(
                          color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )));
        }).then((value) {});
  }

  static void simpleAlert(context, bodyText, {buttonText = 'Ok'}) {
    showDialog(
        context: context,
        // barrierColor: kAlertBackground,
        // barrierColor: Colors.grey.withOpacity(0.7),
        builder: (BuildContext context) {
          return Center(
              // Aligns the container to center
              child: Container(
                  decoration: BoxDecoration(
                      color: kWhite, borderRadius: BorderRadius.circular(16)),
                  // A simplified version of dialog.
                  width: 315.0,
                  height: 125.0,
                  padding: const EdgeInsets.only(top: 28, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        bodyText,
                        style: textTheme.headline5
                            .copyWith(decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 28),
                      kFullDivider,
                      // const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          color: Colors.transparent,
                          width: 315,
                          // padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Center(
                            child: Text(
                              buttonText,
                              style: textTheme.button1.copyWith(
                                  decoration: TextDecoration.none,
                                  color: kPrimaryOrange),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
        }).then((value) {
      // Future.delayed(const Duration(milliseconds: 700), () {
      //   Navigator.of(context).pop();
      //   // Navigator.of(dialogContext).pop();
      // });
    });
  }

  static void showPMF(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: screenSize.width,
                height: 313,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          height: AppBar().preferredSize.height,
                          width: kScreenSizeWidth,
                          child: Center(
                            child: Text(S.of(context).thankYouForUsingDimodo,
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
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
                    const SizedBox(
                      height: 14,
                    ),
                    SvgPicture.asset('assets/icons/big-logo.svg'),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 32.0, left: 32, bottom: 34),
                      child: Text(
                          'Hey~ Chúng tôi là Glowvy team và luôn mong muốn có thể cải thiện dịch vụ. Chúng tôi rất trân trọng các ý tưởng của bạn! Bạn có thể dành ra vài phút trả lời câu hỏi không?',
                          style: kBaseTextStyle.copyWith(
                            fontSize: 14,
                            color: kSecondaryGrey,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 35.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebView(
                                            url: 'https://bit.ly/measurepmf',
                                            title: 'DIMODO Users Survey ⭐️')));
                              },
                              child: Container(
                                height: 36,
                                decoration: const BoxDecoration(
                                    color: kDarkAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 7, bottom: 7),
                                child: Text('Làm khảo sát',
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static void showProductDescription(Product product, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: screenSize.width,
                height: kScreenSizeHeight * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          height: AppBar().preferredSize.height,
                          width: kScreenSizeWidth,
                          child: Center(
                            // TODO(parker): translate
                            child: Text('Mô tả sản phẩm',
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
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
                    const SizedBox(
                      height: 14,
                    ),
                    ProductDescription(product),
                    const SizedBox(height: 14),
                  ],
                ),
              );
            },
          );
        });
  }

  static void showReviewGuidelines(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: screenSize.width,
                height: 650,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          height: AppBar().preferredSize.height,
                          width: kScreenSizeWidth,
                          child: Center(
                            child: Text('Các tiêu chí xét duyệt review',
                                style: kBaseTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 32.0, left: 32),
                      child: Text(
                          'Cùng nhau xây dựng một Glowvy có ích cho tất cả mọi người hơn bằng cách chú ý những điều sau đây khi viết review nhé!',
                          style: textTheme.caption1
                              .copyWith(color: kSecondaryGrey),
                          textAlign: TextAlign.justify),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 32.0,
                        left: 32,
                      ),
                      child: Text(
                          '1. Review thiếu thông tin hoặc review quá chung chung\n\n2. Review có nhiều nội dung lặp đi lặp lại và lỗi đánh máy nghiêm trọng\n\n3. Review sử dụng các từ ngữ chửi thề, thô tục\n\n4. Review các sản phẩm mà bản thân chưa hề sử dụng\n\n5. Review với những hình ảnh không hợp lệ\n\n6.Review bao gồm thông tin cá nhân( địa chỉ liên lạc, email)\n\n7. Review có chứa các thông tin nhằm thuyết phục trao đổi, mua bán\n\n8. Review không lịch sự, thô lỗ\n\n9. Review chứa các nội dung phỉ báng, vi phạm bản quyền hoặc liên quan đến trộm cắp',
                          style: textTheme.bodyText2,
                          textAlign: TextAlign.justify),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 50.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child:
                                SvgPicture.asset('assets/icons/big-logo.svg'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static void showSortOptions(BuildContext context, List<Product> products,
      {@required onTap, option}) {
    final screenSize = MediaQuery.of(context).size;
    var productModel = Provider.of<ProductModel>(context, listen: false);

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                width: screenSize.width,
                height: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    FlatButton(
                      child: Text('By ranking',
                          style: textTheme.caption
                              .copyWith(color: kDefaultFontColor)),
                      onPressed: () {
                        productModel.sortByAllRanking(products);
                        onTap(products, 'By ranking');
                        Navigator.pop(context);
                        //return sorted products here
                      },
                    ),
                    FlatButton(
                      child: Text('By review count',
                          style: textTheme.caption
                              .copyWith(color: kDefaultFontColor)),
                      onPressed: () {
                        productModel.sortByHighReviews(products,
                            isDescending: true);
                        onTap(products, 'By review count');
                        Navigator.pop(context);
                        //return sorted products here
                      },
                    ),
                    FlatButton(
                      child: Text('Price low to high',
                          style: textTheme.caption
                              .copyWith(color: kDefaultFontColor)),
                      onPressed: () {
                        productModel.sortByPrice(products, isDescending: false);
                        onTap(products, 'Price low to high');
                        Navigator.pop(context);
                        //return sorted products here
                      },
                    ),
                    FlatButton(
                      child: Text('New In',
                          style: textTheme.caption
                              .copyWith(color: kDefaultFontColor)),
                      onPressed: () {
                        productModel.sortByCreatedDate(products,
                            isAscending: true);
                        onTap(products, 'New In');
                        Navigator.pop(context);
                        //return sorted products here
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  static void showBaummanQuiz(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final heighFactor = 1 -
        (AppBar().preferredSize.height +
                450 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: 0.27,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: Text(S.of(context).thankYouForUsingDimodo,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, left: 32, bottom: 20),
                        child: Text(S.of(context).discoverYourType,
                            style: kBaseTextStyle.copyWith(
                              fontSize: 14,
                              color: kSecondaryGrey,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify),
                      ),
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 108, right: 108, bottom: 40.0),
                            child: MaterialButton(
                                elevation: 0,
                                color: kDarkAccent,
                                minWidth: kScreenSizeWidth,
                                // height: 44,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                // padding: const EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(S.of(context).startTheTest,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            BaumannQuiz(),
                                        fullscreenDialog: true,
                                      ));
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static void showQandA(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final heighFactor = 1 -
        (AppBar().preferredSize.height +
                80 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heighFactor,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: Text(S.of(context).officialQA,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              S.of(context).whyLowerThanMarketpriceAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).whereReivewsFromAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).sameQualityAsInKoreaAnswer,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 100,
                            )
                          ],
                        ),
                      )

                      // Expanded(
                      //   child: Align(
                      //     alignment: FractionalOffset.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 16, right: 16, bottom: 40.0),
                      //       child: MaterialButton(
                      //           elevation: 0,
                      //           color: kDarkAccent,
                      //           minWidth: kScreenSizeWidth,
                      //           height: 36,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: new BorderRadius.circular(25.0),
                      //           ),
                      //           child: Text(S.of(context).takeSurvey,
                      //               style: kBaseTextStyle.copyWith(
                      //                   fontSize: 15,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: Colors.white)),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => WebView(
                      //                         url: 'https://bit.ly/measurepmf',
                      //                         title:
                      //                             'DIMODO Users Survey ⭐️')));
                      //           }),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static void showGlowvyStory(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final heighFactor = 1 -
        (AppBar().preferredSize.height +
                160 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FractionallySizedBox(
                heightFactor: heighFactor,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  width: screenSize.width,
                  height: screenSize.height * heighFactor -
                      AppBar().preferredSize.height,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            height: AppBar().preferredSize.height,
                            width: kScreenSizeWidth,
                            child: Center(
                              child: Text(S.of(context).dimodoServices,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 16,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              S.of(context).provenKoreanCosmeticsStory,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).getTheCheapesPriceStory,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 10,
                            ),
                            Text(
                              S.of(context).moneyBackGuaranteeStory,
                              style: kBaseTextStyle.copyWith(fontSize: 15),
                              maxLines: 100,
                            )
                          ],
                        ),
                      )

                      // Expanded(
                      //   child: Align(
                      //     alignment: FractionalOffset.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 16, right: 16, bottom: 40.0),
                      //       child: MaterialButton(
                      //           elevation: 0,
                      //           color: kDarkAccent,
                      //           minWidth: kScreenSizeWidth,
                      //           height: 36,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: new BorderRadius.circular(25.0),
                      //           ),
                      //           child: Text(S.of(context).takeSurvey,
                      //               style: kBaseTextStyle.copyWith(
                      //                   fontSize: 15,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: Colors.white)),
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => WebView(
                      //                         url: 'https://bit.ly/measurepmf',
                      //                         title:
                      //                             'DIMODO Users Survey ⭐️')));
                      //           }),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
