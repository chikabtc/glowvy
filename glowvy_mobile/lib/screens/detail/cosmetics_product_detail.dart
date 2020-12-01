import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/screens/brand_home.dart';
import 'package:Dimodo/screens/detail/Cosmetics_review_card.dart';
import 'package:Dimodo/screens/detail/cosmetics_image_feature.dart';
import 'package:Dimodo/screens/detail/cosmetics_review_page.dart';
import 'package:Dimodo/screens/detail/ingredient_card.dart';
import 'package:Dimodo/screens/detail/ingredient_screen.dart';
import 'package:Dimodo/screens/detail/review_images.dart';
import 'package:Dimodo/widgets/image_galery.dart';
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
import '../../models/product/productModel.dart';
import 'cosmetics_product_description.dart';

class CosmeticsProductDetail extends StatefulWidget {
  Product product;
  int rank;

  CosmeticsProductDetail({this.product, this.rank});

  @override
  _CosmeticsProductDetailState createState() => _CosmeticsProductDetailState();
}

class _CosmeticsProductDetailState extends State<CosmeticsProductDetail> {
  bool isLoading = false;
  Size screenSize;
  int totalCount = 0;
  String hazardLevel;
  List<Review> reviews = [];
  int offset = 0;
  int limit = 3;
  Product product;
  ProductModel productModel;
  @override
  void initState() {
    super.initState();
    product = widget.product;
    productModel = Provider.of<ProductModel>(context, listen: false);

    isLoading = true;

    productModel.getCosmeticsReviews(product.sid).then((onValue) {
      if (mounted) {
        setState(() {
          print('review count:${onValue.length}');
          reviews = onValue;
        });
        totalCount = product.reviewMetas.all.reviewCount;
        offset += 3;
      }
    });
    productModel.getWholeProduct(product.sid).then((onValue) {
      if (mounted) {
        setState(() {
          product = onValue;
          isLoading = false;
          print('hazardScore: ${product.hazardScore}');
        });
      }
    });
  }

  Future<bool> getReviews() async {
    final loadedReviews = await productModel.getCosmeticsReviews(product.sid);
    if (loadedReviews == null) {
      return true;
    } else if (loadedReviews.isEmpty) {
      return true;
    }
    setState(() {
      isLoading = false;
      loadedReviews.forEach((element) {
        reviews.add(element);
      });
    });
    offset += 3;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print('product sid: ${product.sid}');

    switch (product.hazardScore) {
      case 0:
        hazardLevel = S.of(context).undecided;
        break;
      case 1:
        hazardLevel = S.of(context).low;
        break;
      case 2:
        hazardLevel = S.of(context).moderate;
        break;
      case 3:
        hazardLevel = S.of(context).high;
        break;
      default:
    }

    List<Widget> renderIngredients() {
      var index = 0;
      var widgets = <Widget>[];
      print('product ingreidnelt legth :${product.ingredients.length}');
      if (product.ingredients != null) {
        while (index < 3 && product.ingredients.length > index) {
          final card = IngredientCard(
            showDivider: index != 2,
            ingredient: product.ingredients[index],
          );
          widgets.add(card);
          index++;
        }
        return widgets;
      } else {
        return widgets;
      }
    }

    Route _createRoute() {
      var thumbnailList = [product.thumbnail];
      if (product.descImages.isNotEmpty) {
        thumbnailList += product.descImages;
      }
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImageGalery(
            images:
                thumbnailList.isNotEmpty ? thumbnailList : product.descImages,
            index: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: kDefaultBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        leading: backIcon(context),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? Container(
              width: screenSize.width,
              height: screenSize.height,
              child: Center(
                child: Container(
                    height: kScreenSizeHeight * 0.5,
                    child: const SpinKitThreeBounce(
                        color: kPrimaryOrange, size: 21.0)),
              ))
          : SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.only(top: 0),
                children: <Widget>[
                  Column(
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
                            CosmeticsImageFeature(
                              product,
                            ),
                            Positioned(
                              bottom: 14,
                              right: 14,
                              child: Container(
                                  // width: 67,
                                  decoration: const BoxDecoration(
                                      color: kSecondaryGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  padding: const EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                      top: 4.5,
                                      bottom: 4.5),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          'assets/icons/image-icon.svg'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          product.descImages != null
                                              ? (product.descImages.length + 1)
                                                  .toString()
                                              : '1',
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(product.name,
                                    maxLines: 2, style: textTheme.headline3),
                                Text(
                                    widget.rank != null
                                        ? 'No.${widget.rank + 1} trong danh sách ${product.category.firstCategoryName}'
                                        : 'd',
                                    maxLines: 1,
                                    style: textTheme.caption2
                                        .copyWith(color: kSecondaryGrey)),
                                // if (product.ingredientScore == 0)

                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Giá tham khảo ' + ' . ' + product.volume,
                                    style: textTheme.caption1.copyWith(
                                      color: kSecondaryGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // if (isLoading)

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40.0, right: 30, top: 10),
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
                            Column(
                              children: <Widget>[
                                ReviewRatingBar(
                                    title: '5.0',
                                    percentage: totalCount != 0
                                        ? reviews.fold(
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
                                        ? reviews.fold(
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
                                        ? reviews.fold(
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
                                        ? reviews.fold(
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
                                        ? reviews.fold(
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
                      Container(
                        height: 24.5,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 5, bottom: 8),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          color: Colors.grey.withOpacity(0.7),
                                        )
                                      ]))),
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 15,
                              ),
                              Container(
                                  decoration: const BoxDecoration(
                                    color: kLightYellow,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IngredientScreen(
                                                    widget.product.ingredients,
                                                    hazardLevel,
                                                  ))),
                                      child: Container(
                                        width: screenSize.width,
                                        // cor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 56,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  const Spacer(),
                                                  Text(
                                                      S
                                                          .of(context)
                                                          .ingredientInfo,
                                                      style: textTheme.headline5
                                                          .copyWith(
                                                        color: kDarkYellow,
                                                      )),
                                                  const Spacer()
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                // Text(hazardLevel,
                                                //     style: textTheme.headline3),
                                                Text(S.of(context).ewgSafeLevel,
                                                    style: textTheme.caption2),
                                                const SizedBox(width: 16)
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            if (!isLoading)
                                              Column(
                                                  children:
                                                      renderIngredients()),
                                            const SizedBox(height: 18),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  S.of(context).viewAll,
                                                  style: textTheme.headline5
                                                      .copyWith(
                                                          color: kDarkYellow),
                                                ),
                                                forwardIcon(
                                                    context, kDarkYellow),
                                              ],
                                            ),
                                            const SizedBox(height: 18)
                                          ],
                                        ),
                                      ))),
                              Container(
                                height: 28,
                              ),
                            ],
                          )),
                    ],
                  ),
                  CosmeticsProductDescription(product),
                  Container(
                    height: 5,
                    color: kDefaultBackground,
                  ),
                  Container(height: 28, color: Colors.white),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CosmeticsReviewPage(
                                  reviews, getReviews, product))),
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
                                  if (product.descImages != null)
                                    ReviewImages(product),
                                  if (product.descImages == null)
                                    Container(height: 20),
                                  Container(height: 20),
                                  if (totalCount > 2)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        children: <Widget>[
                                          CosmeticsReviewCard(
                                              isPreview: true,
                                              context: context,
                                              review: reviews[0]),
                                          CosmeticsReviewCard(
                                              isPreview: true,
                                              context: context,
                                              review: reviews[1]),
                                          CosmeticsReviewCard(
                                              isPreview: true,
                                              context: context,
                                              showDivider: false,
                                              review: reviews[2]),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : Container(
                              width: screenSize.width,
                              height: 90,
                              child: const SpinKitThreeBounce(
                                  color: kPrimaryOrange, size: 21.0))),
                  Container(
                    height: 28,
                  ),
                ],
              ),
            ),
    );
  }
}
