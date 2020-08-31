import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/review.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/generated/i18n.dart';

class CosmeticsReviewFilterBar extends StatefulWidget {
  Function onFilterConfirm;
  Function onSkinTypeChanged;
  Function onReset;
  bool showSorting;
  List<Review> reviews;

  CosmeticsReviewFilterBar(
      {this.onFilterConfirm,
      this.onSkinTypeChanged,
      this.onReset,
      this.showSorting = true,
      this.reviews});
  @override
  _CosmeticsReviewFilterBarState createState() =>
      _CosmeticsReviewFilterBarState();
}

class Sorting {
  static String low = "low";
  static String high = "high";
  static String rank = "rank";
}

class _CosmeticsReviewFilterBarState extends State<CosmeticsReviewFilterBar> {
  ProductModel productModel;
  bool showFilter = false;
  var screenSize;
  var heightFactor;
  var sorting = Sorting.low;
  int skinTypeId = 0;

  List<String> chosenOptions = [];
  AppModel appModel;
  Map<String, dynamic> cosmeticsFilters;
  var isAscending = false;

  @override
  initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    appModel = Provider.of<AppModel>(context, listen: false);
    var appConfig = appModel.appConfig;
    cosmeticsFilters = appConfig["Cosmetics-Filters"] as Map<String, dynamic>;
    print("products list ${widget.reviews}");
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Received products: ${widget.products}");
    screenSize = MediaQuery.of(context).size;
    heightFactor = 0.5;
    return Column(
      children: [
        Container(
          color: Colors.white,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.showSorting)
                Container(
                  // color: Colors.orange,
                  width: screenSize.width / 2 - 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // switch (sorting) {
                          //   case "high":
                          //     sorting = Sorting.rank;
                          //     var sortedProducts =
                          //         productModel.sortByDefaultRank(widget.reviews);

                          //     widget.onFilterConfirm(sortedProducts);
                          //     break;

                          //   case "rank":
                          //     sorting = Sorting.low;
                          //     var sortedProducts =
                          //         productModel.sortByPrice(widget.reviews, true);
                          //     widget.onFilterConfirm(sortedProducts);
                          //     break;
                          //   case "low":
                          //     sorting = Sorting.high;
                          //     var sortedProducts =
                          //         productModel.sortByPrice(widget.reviews, false);
                          //     widget.onFilterConfirm(sortedProducts);
                          //     break;
                          //   default:
                          // }
                          // filterProduct();
                        },
                        child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            height: 24,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                sorting == "rank"
                                    ? Image.asset(
                                        "assets/icons/filter-sort.png")
                                    : sorting == "low"
                                        ? Image.asset(
                                            "assets/icons/filter-sort.png")
                                        : Image.asset(
                                            "assets/icons/filter-sort-active.png"),
                                DynamicText(
                                  sorting == "rank"
                                      ? S.of(context).byRanking
                                      : sorting == "low"
                                          ? S.of(context).highestToLowest
                                          : S.of(context).lowestToHighest,
                                  textAlign: TextAlign.center,
                                  style: kBaseTextStyle.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: sorting == "low"
                                          ? kDarkSecondary
                                          : kDarkAccent),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(width: 16)
                    ],
                  ),
                ),
              Container(
                width: screenSize.width / 2 - 10,
                child: GestureDetector(
                  onTap: () => showCosmeticsFilter(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/filter.svg",
                        width: 16,
                      ),
                      DynamicText(
                        productModel.getSkinTypeById(skinTypeId, context),
                        style: kBaseTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: showFilter ? kDarkSecondary : kDarkAccent),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  filterProduct() {
    // var filteredProducts = productModel.filteredProductsBySkinType(
    //     skinTypeId: skinTypeId, products: widget.reviews);
    // widget.onFilterConfirm(filteredProducts);

    // widget.onFilterConfirm(filteredProducts);
    // switch (sorting) {
    //   case "high":
    //     var sortedProducts = productModel.sortByPrice(filteredProducts, false);

    //     widget.onFilterConfirm(sortedProducts);
    //     break;

    //   case "rank":
    //     var sortedProducts = productModel.sortByDefaultRank(filteredProducts);

    //     widget.onFilterConfirm(sortedProducts);
    //     break;
    //   case "low":
    //     var sortedProducts = productModel.sortByPrice(filteredProducts, true);
    //     widget.onFilterConfirm(sortedProducts);
    //     break;
    //   default:
    // }
  }

  showCosmeticsFilter() {
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
                heightFactor: heightFactor,
                child: Container(
                    decoration: BoxDecoration(
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
                                child: DynamicText(S.of(context).choose,
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
                              shrinkWrap: true,
                              children: <Widget>[
                                showCompoundOptions(setState),
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
                                                new BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: kPinkAccent,
                                                width: 1.5)),
                                        child: DynamicText(S.of(context).reset,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: kPinkAccent)),
                                        onPressed: () {
                                          skinTypeId = 0;
                                          widget
                                              .onFilterConfirm(widget.reviews);
                                          setState(() {
                                            chosenOptions.clear();
                                          });
                                          Navigator.pop(context);
                                        }),
                                    SizedBox(width: 16),
                                    MaterialButton(
                                        elevation: 0,
                                        color: kPinkAccent,
                                        minWidth: (screenSize.width - 48) * 0.5,
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: kPinkAccent,
                                                width: 1.5)),
                                        child: DynamicText(
                                            S.of(context).confirm,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        onPressed: () {
                                          var filteredReviews = productModel
                                              .filteredReviewsBySkinType(
                                                  skinTypeId: skinTypeId,
                                                  reviews: widget.reviews);
                                          widget
                                              .onFilterConfirm(filteredReviews);

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

  showCompoundOptions(StateSetter setState) {
    List<Widget> widgets = [];
    // enumerate the two compound options

    cosmeticsFilters.forEach((key, values) {
      // print("Key: ${key}, value["name"]s : ${value["name"]s}");
      var header = DynamicText(
        key,
        style: kBaseTextStyle.copyWith(
            fontSize: 13, fontWeight: FontWeight.w600, color: kDarkSecondary),
      );
      // print("values :${values[0]}");

      var options = Wrap(children: <Widget>[
        for (var value in values)
          Container(
            child: ActionChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: skinTypeId == value["id"] ? kPinkAccent : kLightBG,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 0,
              onPressed: () {
                setState(() {
                  skinTypeId = value["id"];
                });
              },
              backgroundColor: kLightBG,
              label: DynamicText(
                value["name"],
                style: kBaseTextStyle.copyWith(
                    fontSize: 15,
                    color: skinTypeId == value["id"]
                        ? kPinkAccent
                        : kDarkSecondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
          )
      ]);
      widgets.addAll([
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Divider(
            height: 1,
            color: kDarkSecondary.withOpacity(0.3),
          ),
        ),
        header,
        options,
        Container(height: 10)
      ]);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
