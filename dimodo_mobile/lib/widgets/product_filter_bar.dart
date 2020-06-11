import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/generated/i18n.dart';

class FilterBar extends StatefulWidget {
  Function onFilterConfirm;
  Function onSortingChanged;
  Function onReset;
  List<Product> products;

  FilterBar(
      {this.onFilterConfirm,
      this.onSortingChanged,
      this.onReset,
      this.products});
  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  ProductModel productModel;
  bool showFilter = false;
  var screenSize;
  var heightFactor;

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
    print("products list ${widget.products}");
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    heightFactor = 0.5;
    return Column(
      children: [
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAscending = !isAscending;
                      });
                      var sortedProducts = productModel.sortByPrice(
                          widget.products, isAscending);
                      widget.onSortingChanged(sortedProducts);
                    },
                    child: Container(
                        decoration: new BoxDecoration(
                          color: isAscending ? Colors.white : kLightPink,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        height: 24,
                        // width: 98,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            isAscending
                                ? Image.asset("assets/icons/filter-sort.png")
                                : Image.asset(
                                    "assets/icons/filter-sort-active.png"),
                            DynamicText(
                              isAscending
                                  ? S.of(context).highestToLowest
                                  : S.of(context).lowestToHighest,
                              textAlign: TextAlign.center,
                              style: kBaseTextStyle.copyWith(
                                  fontSize: 13,
                                  color: isAscending
                                      ? kDarkSecondary
                                      : kDarkAccent),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(width: 16)
                ],
              ),
              GestureDetector(
                onTap: () => showCosmeticsFilter(),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/filter.svg",
                      width: 16,
                    ),
                    DynamicText(
                      "Filter",
                      style: kBaseTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: showFilter ? kDarkSecondary : kDarkAccent),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
                                          var filteredProducts =
                                              productModel.filteredProducts(
                                                  filterOptions: chosenOptions,
                                                  products: widget.products);
                                          widget.onReset(filteredProducts);
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
                                          //filter the products
                                          var filteredProducts =
                                              productModel.filteredProducts(
                                                  filterOptions: chosenOptions,
                                                  products: widget.products);
                                          widget.onFilterConfirm(
                                              filteredProducts);
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
      // print("Key: ${key}, Values : ${values}");
      var header = DynamicText(
        key,
        style: kBaseTextStyle.copyWith(
            fontSize: 13, fontWeight: FontWeight.w600, color: kDarkSecondary),
      );

      var options = Wrap(children: <Widget>[
        for (var value in values.toList())
          Container(
            child: ActionChip(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: chosenOptions.contains(value["value"])
                      ? kPinkAccent
                      : kLightBG,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 0,
              onPressed: () {
                setState(() {
                  if (chosenOptions.contains(value["value"])) {
                    print("choosenO: ${chosenOptions[0]}");
                    chosenOptions.remove(value["value"]);
                  } else {
                    chosenOptions.add(value["value"]);
                  }
                });
              },
              backgroundColor: kLightBG,
              label: DynamicText(
                value["value"],
                style: kBaseTextStyle.copyWith(
                    fontSize: 15,
                    color: chosenOptions.contains(value["value"])
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
