import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/services/index.dart';
import 'package:Dimodo/widgets/cosmetics_request_button.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/i18n.dart';
import 'package:algolia/algolia.dart';

class SearchScreen extends StatefulWidget {
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

  final TextEditingController searchController = TextEditingController();
  String searchText;
  bool showResults = false;
  bool isTextFieldSelected = false;
  ProductModel productModel;

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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          leading: backIcon(context),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: kDefaultBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      onTap: () => isTextFieldSelected = true,
                      cursorColor: theme.cursorColor,
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                          if (value == "") {
                            showResults = false;
                          }
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          isTextFieldSelected = false;
                          getProductBySearch = service.getProductsBySearch(
                              searchText: searchText, sortBy: "id");
                          showResults = true;

                          FocusScope.of(context).unfocus();
                        });
                      },
                      decoration: kTextField.copyWith(
                        hintText: S.of(context).search,
                        contentPadding: EdgeInsets.only(bottom: 12, left: 12),
                      )),
                ),
              ),
              !isTextFieldSelected
                  ? Container(width: 46)
                  : Container(
                      // width: 56,
                      padding: EdgeInsets.only(right: 16, left: 10),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          searchText = "";
                          searchController.text = searchText;
                          showResults = false;
                          FocusScope.of(context).unfocus();
                        }),
                        child: Container(
                          child: Text(S.of(context).cancel,
                              style: textTheme.bodyText2),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        body: SafeArea(
          top: true,
          child: Container(
              height: screenSize.height,
              decoration: BoxDecoration(color: Colors.white),
              child: ListView(
                children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[],
                  ),
                  showResults
                      ? productModel.showCosmeticsProductList(
                          isNameAvailable: false, future: getProductBySearch)
                      : Container(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Mọi người cũng tìm kiếm",
                                textAlign: TextAlign.center,
                                style: textTheme.bodyText2
                                    .copyWith(color: kSecondaryGrey),
                              ),
                              SizedBox(height: 10),
                              Keyword(
                                  keyword: roundLab,
                                  onTap: () => search(roundLab)),
                              SizedBox(height: 10),
                              Keyword(
                                  keyword: cleanser,
                                  onTap: () => search(cleanser)),
                              SizedBox(height: 10),
                              Keyword(
                                  keyword: cream, onTap: () => search(cream)),
                              SizedBox(height: 10),
                              Keyword(
                                  keyword: sunscreen,
                                  onTap: () => search(sunscreen)),
                              SizedBox(height: 10),
                              Keyword(
                                  keyword: serum, onTap: () => search(serum)),
                              SizedBox(height: 10),
                            ],
                          )),
                  // CosmeticsRequestBtn()
                ],
              )),
        ));
  }
}

class Keyword extends StatelessWidget {
  const Keyword({
    Key key,
    @required this.keyword,
    @required this.onTap,
  }) : super(key: key);

  final String keyword;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: kLightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        // alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
          child: Text(
            keyword,
            textAlign: TextAlign.center,
            style: textTheme.bodyText2.copyWith(color: kDarkYellow),
          ),
        ),
      ),
    );
  }
}
