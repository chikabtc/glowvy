import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../generated/i18n.dart';

class ReviewCosmeticsSearchScreen extends StatefulWidget {
  bool isEditing;
  ReviewCosmeticsSearchScreen({this.isEditing = false});
  @override
  _ReviewCosmeticsSearchScreenState createState() =>
      _ReviewCosmeticsSearchScreenState();
}

class _ReviewCosmeticsSearchScreenState
    extends State<ReviewCosmeticsSearchScreen> {
  Size screenSize;
  Future<ListPage<Product>> getProductBySearch;

  bool isAscending = false;
  String highToLow = '-sale_price';
  String lowToHigh = 'sale_price';

  final TextEditingController searchController = TextEditingController();
  String searchText;
  bool showResults = false;
  bool isTextFieldSelected = false;
  ProductModel productModel;

  var roundLab = 'Round Labs';
  var cleanser = 'Làm Sạch Da Mặt';
  var cream = 'Kem Bôi';
  var sunscreen = 'Chống Nắng';
  var serum = 'Serum';

  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
  }

  void search(text, {pageKey}) {
    isTextFieldSelected = false;
    searchController.text = text;
    getProductBySearch = productModel.getProductsBySearch(text);
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
        leading: widget.isEditing
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Text('Stop',
                      style:
                          textTheme.headline5.copyWith(color: kSecondaryGrey)),
                ),
              )
            : backIcon(context),
        title: Text('select cosmetics', style: textTheme.headline3),
      ),
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: kDefaultBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                                autofocus: true,
                                onTap: () => isTextFieldSelected = true,
                                cursorColor: theme.cursorColor,
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                    if (value == '') {
                                      showResults = false;
                                    }
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    isTextFieldSelected = false;
                                    search(value);
                                  });
                                },
                                decoration: kTextField.copyWith(
                                  prefixIcon: IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/icons/search.svg',
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: S.of(context).search,
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 12, left: 12),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ];
        },
        body: showResults
            ? productModel.showPaginatedProductList(
                future: getProductBySearch, isFromReviewPage: true)
            : Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mọi người cũng tìm kiếm',
                      textAlign: TextAlign.center,
                      style:
                          textTheme.bodyText2.copyWith(color: kSecondaryGrey),
                    ),
                    const SizedBox(height: 10),
                    Keyword(keyword: roundLab, onTap: () => search(roundLab)),
                    const SizedBox(height: 10),
                    Keyword(keyword: cleanser, onTap: () => search(cleanser)),
                    const SizedBox(height: 10),
                    Keyword(keyword: cream, onTap: () => search(cream)),
                    const SizedBox(height: 10),
                    Keyword(keyword: sunscreen, onTap: () => search(sunscreen)),
                    const SizedBox(height: 10),
                    Keyword(keyword: serum, onTap: () => search(serum)),
                    const SizedBox(height: 10),
                  ],
                )),
      ),
    );
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
