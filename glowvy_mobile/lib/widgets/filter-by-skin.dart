import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FilterBySkin extends StatefulWidget {
  Function onFilterConfirm;
  Function onReset;
  int skinTypeId;
  List<Product> products;

  FilterBySkin(
      {this.onFilterConfirm, this.onReset, this.products, this.skinTypeId});
  @override
  _FilterBySkinState createState() => _FilterBySkinState();
}

class Sorting {
  static String low = 'low';
  static String high = 'high';
  static String rank = 'rank';
}

class _FilterBySkinState extends State<FilterBySkin> {
  ProductModel productModel;
  bool showFilter = false;
  Size screenSize;
  double heightFactor;
  var sorting = Sorting.rank;

  List<String> chosenOptions = [];
  AppModel appModel;
  UserModel userModel;
  Map<String, dynamic> cosmeticsFilters;
  var isAscending = false;
  List<Product> products;

  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    appModel = Provider.of<AppModel>(context, listen: false);
    final appConfig = appModel.appConfig;
    cosmeticsFilters = appConfig['Cosmetics-Filters'] as Map<String, dynamic>;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Received products: ${widget.products}');
    screenSize = MediaQuery.of(context).size;
    heightFactor = 0.5;
    var widgets = <Widget>[];

    cosmeticsFilters.forEach((key, values) {
      var options = Wrap(children: <Widget>[
        for (var value in values)
          GestureDetector(
            onTap: () => setState(() {
              widget.skinTypeId = value['id'];
              widget.onFilterConfirm(
                  sortProducts(widget.products), sorting, widget.skinTypeId);
            }),
            child: Container(
              height: 24,
              padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 4),
              decoration: BoxDecoration(
                color: widget.skinTypeId == value['id']
                    ? kLightYellow
                    : Color(0xFFEEEEEE),
                border: Border.all(
                    color: widget.skinTypeId == value['id']
                        ? kDarkYellow
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                value['name'],
                style: kBaseTextStyle.copyWith(
                    fontSize: 14,
                    color: widget.skinTypeId == value['id']
                        ? kDarkYellow
                        : kSecondaryGrey,
                    fontWeight: FontWeight.w600),
              ),
              margin: EdgeInsets.only(right: 10),
            ),
          )
      ]);
      widgets.addAll([
        options,
      ]);
    });

    return Container(
      color: Colors.white,
      // height: 78,
      padding: EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // const SizedBox(height: 25),
          Container(
            height: 40,
            width: screenSize.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: ListView(
                        scrollDirection: Axis.horizontal, children: widgets),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }

  // filterProduct() {
  //   var filteredProducts = productModel.filterBySkinType(widget.products);
  //   return filteredProducts;
  // }voi

  List<Product> sortProducts(filteredProducts) {
    List<Product> products;
    switch (sorting) {
      case 'high':
        products = productModel.sortByPrice(filteredProducts, false);
        break;

      case 'rank':
        products =
            productModel.sortBySkinType(userModel.user, filteredProducts);
        break;
      case 'low':
        products = productModel.sortByPrice(filteredProducts, true);
        break;
      default:
    }
    return products;
  }

  void showCosmeticsSortingOptions() {
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
                            padding: EdgeInsets.only(left: 16.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                renderSortingOptions(setState),
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
                                padding: EdgeInsets.only(top: 9.0, bottom: 10),
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
                                            side: BorderSide(
                                                color: kDarkYellow,
                                                width: 1.5)),
                                        child: Text(S.of(context).reset,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: kDarkYellow)),
                                        onPressed: () {
                                          setState(() {
                                            sortProducts(widget.products);
                                            widget.onReset(products);
                                            widget.skinTypeId = 0;
                                          });
                                          Navigator.pop(context);
                                        }),
                                    const SizedBox(width: 16),
                                    MaterialButton(
                                        elevation: 0,
                                        color: kDarkYellow,
                                        minWidth: (screenSize.width - 48) * 0.5,
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: kDarkYellow,
                                                width: 1.5)),
                                        child: Text(S.of(context).confirm,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        onPressed: () {
                                          widget.onFilterConfirm(
                                              sortProducts(widget.products));

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

  void showCosmeticsFilter() {
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
                            padding: EdgeInsets.only(left: 16.0),
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
                                padding: EdgeInsets.only(top: 9.0, bottom: 10),
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
                                            side: BorderSide(
                                                color: kDarkYellow,
                                                width: 1.5)),
                                        child: Text(S.of(context).reset,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: kDarkYellow)),
                                        onPressed: () {
                                          setState(() {
                                            sortProducts(widget.products);
                                            widget.onReset(products);
                                            widget.skinTypeId = 0;
                                          });
                                          Navigator.pop(context);
                                        }),
                                    const SizedBox(width: 16),
                                    MaterialButton(
                                        elevation: 0,
                                        color: kDarkYellow,
                                        minWidth: (screenSize.width - 48) * 0.5,
                                        height: 40,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: kDarkYellow,
                                                width: 1.5)),
                                        child: Text(S.of(context).confirm,
                                            style: kBaseTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        onPressed: () {
                                          widget.onFilterConfirm(
                                              sortProducts(widget.products),
                                              sorting,
                                              widget.skinTypeId);

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

  Widget showCompoundOptions(StateSetter setState) {
    var widgets = <Widget>[];
    // enumerate the two compound options

    cosmeticsFilters.forEach((key, values) {
      // print('Key: ${key}, value['name']s : ${value['name']s}');
      var header = Text(
        key,
        style: kBaseTextStyle.copyWith(
            fontSize: 13, fontWeight: FontWeight.w600, color: kSecondaryGrey),
      );
      // print('values :${values[0]}');

      var options = Wrap(children: <Widget>[
        for (var value in values)
          Container(
            child: ActionChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: widget.skinTypeId == value['id']
                      ? kDarkYellow
                      : kSecondaryWhite,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 0,
              onPressed: () {
                setState(() {
                  widget.skinTypeId = value['id'];
                });
              },
              backgroundColor: kSecondaryWhite,
              label: Text(
                value['name'],
                style: kBaseTextStyle.copyWith(
                    fontSize: 15,
                    color: widget.skinTypeId == value['id']
                        ? kDarkYellow
                        : kSecondaryGrey,
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
            color: kSecondaryGrey.withOpacity(0.3),
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

  Widget renderSortingOptions(StateSetter setState) {
    var widgets = <Widget>[];
    // enumerate the two compound options

    cosmeticsFilters.forEach((key, values) {
      // print('Key: ${key}, value['name']s : ${value['name']s}');
      var header = Text(
        key,
        style: kBaseTextStyle.copyWith(
            fontSize: 13, fontWeight: FontWeight.w600, color: kSecondaryGrey),
      );
      // print('values :${values[0]}');

      var options = Wrap(children: <Widget>[
        for (var value in values)
          Container(
            child: ActionChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: widget.skinTypeId == value['id']
                      ? kDarkYellow
                      : kSecondaryWhite,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 0,
              onPressed: () {
                setState(() {
                  widget.skinTypeId = value['id'];
                });
              },
              backgroundColor: kSecondaryWhite,
              label: Text(
                value['name'],
                style: kBaseTextStyle.copyWith(
                    fontSize: 15,
                    color: widget.skinTypeId == value['id']
                        ? kDarkYellow
                        : kSecondaryGrey,
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
            color: kSecondaryGrey.withOpacity(0.3),
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
