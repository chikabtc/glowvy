import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/product/review_model.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/brand_home.dart';
import 'package:Dimodo/screens/detail/review_card.dart';
import 'package:Dimodo/screens/detail/image_feature.dart';
import 'package:Dimodo/screens/detail/reviews_screen.dart';
import 'package:Dimodo/screens/detail/ingredient_card.dart';
import 'package:Dimodo/screens/detail/ingredient_screen.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:Dimodo/widgets/image_galery.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/review_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../common/colors.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';
import '../../models/product/product.dart';
import '../../models/product/product_model.dart';

// ignore: must_be_immutable
class ProductDetailPage extends StatefulWidget {
  Product product;
  int rank;

  ProductDetailPage({this.product, this.rank});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isLoading = false;
  Size screenSize;
  int totalCount = 0;
  String hazardLevel;
  Color hazardLevelColor;

  ListPage<Review> initialReviewPage;
  int limit = 3;
  Product product;
  ProductModel productModel;
  ReviewModel reviewModel;
  @override
  void initState() {
    super.initState();
    product = widget.product;
    productModel = Provider.of<ProductModel>(context, listen: false);
    reviewModel = Provider.of<ReviewModel>(context, listen: false);

    isLoading = true;
    print('product ${product.sid}');
    productModel.getWholeProduct(product.sid).then((onValue) {
      if (mounted) {
        product = onValue;
        if (product.reviewMetas.all.reviewCount != 0) {
          reviewModel.getProductReviews(product.sid).then((onValue) {
            if (mounted) {
              totalCount = product.reviewMetas?.all?.reviewCount;
              initialReviewPage = onValue;
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    // print('product sid: ${product.sid}');

    switch (product.hazardScore) {
      case 0:
        hazardLevel = 'chưa xác định';
        hazardLevelColor = kDarkGrey;
        break;
      case 1:
        hazardLevel = 'thấp';
        hazardLevelColor = kDarkGrey;

        break;
      case 2:
        hazardLevel = 'trung bình';
        hazardLevelColor = kSecondaryOrange;

        break;
      case 3:
        hazardLevel = 'cao';
        hazardLevelColor = kPrimaryOrange;
        break;
      default:
        hazardLevel = 'chưa xác định';
    }

    Route _createRoute() {
      var thumbnailList = [product.thumbnail];
      // if (product.descImages != null) {
      //   thumbnailList += product.descImages;
      // }
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ImageGalery(images: thumbnailList, index: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    Widget getInitialThreeReviews() {
      const maxReviewNumberToShow = 3;
      final itemCount = initialReviewPage.itemList.length;
      // print('count :${itemCount}');
      var items = <Review>[];
      var widgets = [];
      if (itemCount < maxReviewNumberToShow) {
        items = initialReviewPage.itemList.getRange(0, itemCount).toList();
      } else {
        items = initialReviewPage.itemList.getRange(0, 3).toList();
      }
      return Column(children: [
        for (var item in items)
          ReviewCard(isPreview: true, context: context, review: item)
      ]);
    }

    return Scaffold(
      backgroundColor: kDefaultBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        leading: backIcon(context, onPop: () {
          Navigator.pop(context);
          reviewModel.clearPaginationHistory();
        }),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? Container(
              width: screenSize.width,
              height: screenSize.height,
              child: Center(
                child: Container(child: kIndicator()),
              ))
          : SafeArea(
              bottom: false,
              child: Scrollbar(
                thickness: kScrollbarThickness,
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(_createRoute()),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            width: screenSize.width - 20,
                            height: 225,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          ImageFeature(
                            product,
                          ),
                          Positioned(
                            bottom: 14,
                            right: 14,
                            child: Container(
                                // width: 67,
                                decoration: BoxDecoration(
                                    color: kSecondaryGrey,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 4.5, bottom: 4.5),
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                        'assets/icons/image-icon.svg'),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text('1',
                                        style: textTheme.caption1.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 16, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(product.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: textTheme.headline3),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${Tools.getPriceProduct(product, 'VND', onSale: true)} . ",
                                        style: textTheme.caption1),
                                    Text(product.volume,
                                        style: textTheme.caption1.copyWith(
                                          color: kSecondaryGrey,
                                        )),
                                  ],
                                ),
                                if (widget.rank != null)
                                  Text(
                                      'No.${widget.rank + 1} trong danh sách ${product.category.firstCategoryName}',
                                      maxLines: 1,
                                      style: textTheme.caption2
                                          .copyWith(color: kSecondaryGrey)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // if (isLoading)

                    GestureDetector(
                      onTap: () =>
                          Popups.showProductDescription(product, context),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, top: 10),
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: kWhite,
                                  border: Border(
                                    top: BorderSide(
                                        color: kQuaternaryGrey, width: 0.5),
                                    bottom: BorderSide(
                                        color: kQuaternaryGrey, width: 0.5),
                                  ),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 5, bottom: 8),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.info,
                                        size: 20,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 10),
                                      Text('Mô tả sản phẩm',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.caption1),
                                      // const Spacer(),
                                      // Icon(
                                      //   Icons.arrow_forward_ios,
                                      //   size: 12,
                                      //   color: Colors.grey,
                                      // )
                                    ]))),
                      ),
                    ),
                    Container(
                      height: 20,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BrandHomePage(product.brand))),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, top: 10),
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: kDefaultBackground,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 5, bottom: 8),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        height: 24,
                                        width: 24,
                                        child: Tools.image(
                                          url: product.brand.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(product.brand.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.caption1),
                                      const Spacer(),
                                      Icon(
                                        Icons.home,
                                        size: 20,
                                        color: Colors.grey.withOpacity(0.7),
                                      )
                                    ]))),
                      ),
                    ),
                    // if (product.ingredients != null)
                    GestureDetector(
                      onTap: () => product.ingredients != null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IngredientScreen(
                                        product.ingredients,
                                        hazardLevel,
                                      )))
                          : null,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, left: 16, top: 10),
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: kDefaultBackground,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 5, bottom: 8),
                                width: MediaQuery.of(context).size.width,
                                child: product.ingredients != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style:
                                                    textTheme.caption1.copyWith(
                                                  color: kSecondaryGrey,
                                                ),
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                      text: 'Chứa thành phần'),
                                                  TextSpan(
                                                      text:
                                                          ' rủi ro $hazardLevel',
                                                      style: textTheme.caption1
                                                          .copyWith(
                                                              color:
                                                                  hazardLevelColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  const TextSpan(
                                                      text: ' cho da'),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Icon(
                                              Icons.warning,
                                              size: 20,
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                            )
                                          ])
                                    : Text(
                                        'Sản phẩm không đăng ký thành phần',
                                        // textAlign: TextAlign.center,
                                        style: textTheme.caption1
                                            .copyWith(color: kSecondaryGrey),
                                      ))),
                      ),
                    ),

                    Container(
                      height: 10,
                      color: Colors.white,
                    ),
                    Container(
                      height: 5,
                      color: kDefaultBackground,
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40.0, right: 30, top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    product.reviewMetas.all.averageRating
                                        .toString()
                                        .substring(0, 3),
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                Text('trên 5', style: textTheme.caption1),
                                Text('(${product.reviewMetas.all.reviewCount})',
                                    style: textTheme.caption2
                                        .copyWith(color: kSecondaryGrey)),
                              ],
                            ),
                            const Spacer(),
                            // if (initialReviewPage != null)
                            Column(
                              children: <Widget>[
                                ReviewRatingBar(
                                    title: '5.0',
                                    percentage: totalCount != 0
                                        ? initialReviewPage.itemList.fold(
                                                0,
                                                (previousValue, element) =>
                                                    element.rating == 5
                                                        ? previousValue + 1
                                                        : previousValue) /
                                            totalCount
                                        : 0),
                                ReviewRatingBar(
                                    title: '4.0',
                                    percentage: totalCount != 0
                                        ? initialReviewPage.itemList.fold(
                                                0,
                                                (previousValue, element) =>
                                                    element.rating == 4
                                                        ? previousValue + 1
                                                        : previousValue) /
                                            totalCount
                                        : 0),
                                ReviewRatingBar(
                                    title: '3.0',
                                    percentage: totalCount != 0
                                        ? initialReviewPage.itemList.fold(
                                                0,
                                                (previousValue, element) =>
                                                    element.rating == 3
                                                        ? previousValue + 1
                                                        : previousValue) /
                                            totalCount
                                        : 0),
                                ReviewRatingBar(
                                    title: '2.0',
                                    percentage: totalCount != 0
                                        ? initialReviewPage.itemList.fold(
                                                0,
                                                (previousValue, element) =>
                                                    element.rating == 2
                                                        ? previousValue + 1
                                                        : previousValue) /
                                            totalCount
                                        : 0),
                                ReviewRatingBar(
                                    title: '1.0',
                                    percentage: totalCount != 0
                                        ? initialReviewPage.itemList.fold(
                                                0,
                                                (previousValue, element) =>
                                                    element.rating == 1
                                                        ? previousValue + 1
                                                        : previousValue) /
                                            totalCount
                                        : 0),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                      color: kDefaultBackground,
                    ),
                    Container(height: 14, color: Colors.white),
                    GestureDetector(
                        onTap: () => totalCount != 0
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewsScreen(
                                        initialReviewPage, product)))
                            : null,
                        child: !isLoading
                            ? Container(
                                width: screenSize.width,
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                              'Đánh giá (${product.reviewMetas.all.reviewCount})',
                                              style: textTheme.headline5),
                                          const Spacer(),
                                          if (totalCount != 0)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[arrowForward],
                                            ),
                                        ],
                                      ),
                                    ),
                                    // if (product.descImages != null)
                                    //   ReviewImages(product),
                                    if (product.descImages == null)
                                      Container(height: 20),
                                    Container(height: 20),
                                    if (initialReviewPage != null)
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: getInitialThreeReviews()),
                                    if (totalCount == 0)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Chưa có đánh giá',
                                              style: textTheme.bodyText1
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: kPrimaryOrange),
                                            ),
                                          ),
                                          Container(
                                            color: kWhite,
                                            height: 50,
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                              )
                            : Container()),
                    // Container(
                    //   height: 28,
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
