import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/services/index.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import '../generated/i18n.dart';
import 'package:algolia/algolia.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Size screenSize;
  Future<List<Product>> getProductBySearch;
  Services service = Services();
  bool isAscending = false;
  String highToLow = "-sale_price";
  String lowToHigh = "sale_price";
  static Algolia algolia = Algolia.init(
    applicationId: '50G6MO803G',
    apiKey: 'ab5eb7ec7552bb7865f3819a2b08f462',
  );
  final TextEditingController searchController = TextEditingController();
  String searchText;
  bool showResults = false;

  @override
  void initState() {
    super.initState();
    getProductBySearch =
        service.getProductsBySearch(searchText: "드레스", sortBy: "id");
  }

  //need to use is
  // void search() async {
  //   var products = await service.getProductsBySearch(searchText: searchText);
  // }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            top: true,
            child: Container(
              height: screenSize.height,
              decoration: BoxDecoration(color: Colors.white),
              child: CustomScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: CommonIcons.arrowBackward,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Expanded(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: kDefaultBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                cursorColor: kPinkAccent,
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                    showResults = false;
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    showResults = true;
                                    getProductBySearch =
                                        service.getProductsBySearch(
                                            searchText: searchText,
                                            sortBy: "id");
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: S.of(context).search,
                                  hintStyle: kBaseTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkSecondary.withOpacity(0.5),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 20, bottom: 12),
                                ),
                              ),
                            ),
                          ),
                          showResults
                              ? Container(width: 46)
                              : Container(
                                  width: 56,
                                  padding: EdgeInsets.only(right: 16, left: 10),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      searchText = "";
                                      searchController.text = searchText;
                                      showResults = true;
                                      FocusScope.of(context).unfocus();
                                    }),
                                    child: Container(
                                      child: Text(
                                        S.of(context).cancel,
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        height: 40,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                //reload the list with different sorting
                                setState(() {
                                  isAscending = !isAscending;
                                });
                              },
                              child: Container(
                                  decoration: new BoxDecoration(
                                    color:
                                        isAscending ? Colors.white : kLightPink,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  height: 24,
                                  // width: 98,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                          "assets/icons/filter-sort-active.png"),
                                      DynamicText(
                                        isAscending
                                            ? S.of(context).highestToLowest
                                            : S.of(context).lowestToHighest,
                                        textAlign: TextAlign.center,
                                        style: kBaseTextStyle.copyWith(
                                            fontSize: 12,
                                            color: isAscending
                                                ? kDarkSecondary
                                                : kDarkAccent),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(width: 12)
                          ],
                        ),
                      ),
                      Visibility(
                          visible: !showResults,
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DynamicText(
                                    S.of(context).searchForItems,
                                    textAlign: TextAlign.center,
                                    style: kBaseTextStyle.copyWith(
                                        fontSize: 12, color: kDarkSecondary),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: kDefaultBackground,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Center(
                                            child: DynamicText(
                                              S.of(context).cancel,
                                              textAlign: TextAlign.center,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: kDarkSecondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: kDefaultBackground,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Center(
                                            child: DynamicText(
                                              S.of(context).cancel,
                                              textAlign: TextAlign.center,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: kDarkSecondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 30 *
                                            kSizeConfig.containerMultiplier,
                                        decoration: BoxDecoration(
                                          color: kDefaultBackground,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Center(
                                            child: DynamicText(
                                              S.of(context).cancel,
                                              textAlign: TextAlign.center,
                                              style: kBaseTextStyle.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: kDarkSecondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ))),
                      Visibility(
                        child: ProductModel.showProductList(
                            isNameAvailable: false, future: getProductBySearch),
                        visible: showResults,
                      ),
                    ]))
                  ]),
            )));
  }
}
