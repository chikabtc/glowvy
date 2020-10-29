import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/icons.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/services/index.dart';
import 'package:Dimodo/widgets/cosmetics_request_button.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../generated/i18n.dart';
import 'package:algolia/algolia.dart';

class WriteReviewScreen extends StatefulWidget {
  Product product;
  WriteReviewScreen({this.product});

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  Size screenSize;
  Future<List<Product>> getProductBySearch;
  Services service = Services();
  bool isAscending = false;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";

  final TextEditingController searchController = TextEditingController();
  String searchText;
  bool showResults = false;
  bool isTextFieldSelected = false;
  ProductModel productModel;
  String reviewText;

  var roundLab = "Round Labs";
  var cleanser = "Làm Sạch Da Mặt";
  var cream = "Kem Bôi";
  var sunscreen = "Chống Nắng";
  var serum = "Serum";

  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
  }

  search(text) {
    isTextFieldSelected = false;
    searchController.text = text;
    getProductBySearch =
        service.getProductsBySearch(searchText: text, sortBy: "id");
    showResults = true;
    FocusScope.of(context).unfocus();
  }

  uploadReview(reviewText, rating) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    var review = {
      'content': reviewText,
      'user': userModel.user.toJson(),
      'product_id': widget.product.sid,
      'rating': rating,
      'created_at': FieldValue.serverTimestamp()
    };

    await service.writeReview(review);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kDefaultBackground,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 35.0),
          child: GestureDetector(
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => WebView(
                //             url: "https://bit.ly/measurepmf",
                //             title:
                //                 "DIMODO Users Survey ⭐️")));
              },
              child: Container(
                height: 48,
                decoration: kButton,
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
                child: Text("Làm khảo sát",
                    style: kBaseTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              )),
        ),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          leading: backIcon(context),
        ),
        body: SafeArea(
          top: true,
          child: Container(
              height: screenSize.height,
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Column(
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Tools.image(
                                    url: widget.product.thumbnail,
                                    fit: BoxFit.cover,
                                    width: 34,
                                    height: 36,
                                    size: kSize.large,
                                  ),
                                ),
                                // // item name
                                SizedBox(width: 7),
                                Flexible(
                                  child: Container(
                                    height: 35,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 2),
                                        Text("${widget.product.name}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.button2),
                                        Text("${widget.product.name}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.caption2),

                                        // SizedBox(height: 9),

                                        // // SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Change",
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
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 7),
                      Text("Tap to rate",
                          style: textTheme.caption1
                              .copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 20),
                      RatingBar(
                        initialRating: 3,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset('assets/icons/rank-flower.svg',
                              color: kPrimaryOrange),
                          half:
                              SvgPicture.asset('assets/icons/rank-flower.svg'),
                          empty:
                              SvgPicture.asset('assets/icons/rank-flower.svg'),
                        ),
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(height: 27),
                      TextField(
                        cursorColor: kPinkAccent,
                        onChanged: (value) => reviewText = value,
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
                    ],
                  ),
                ],
              )),
        ));
  }
}
