import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/screens/search_review_cosmetisc.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/widgets/second_category_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/i18n.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Size screenSize;
  Future<List<Product>> getProductBySearch;
  bool isAscending = false;
  String highToLow = '-sale_price';
  String lowToHigh = 'sale_price';

  final TextEditingController searchController = TextEditingController();
  String searchText;
  bool showResults = false;
  bool isTextFieldSelected = false;
  ProductModel productModel;
  CategoryModel categoryModel;
  List<Category> categories = [];
  Category currentFirstCategory;

  var roundLab = 'Round Labs';
  var cleanser = 'Làm Sạch Da Mặt';
  var cream = 'Kem Bôi';
  var sunscreen = 'Chống Nắng';
  var serum = 'Serum';

  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    categoryModel = Provider.of<CategoryModel>(context, listen: false);
    categories = categoryModel.categories;
    currentFirstCategory = categories[0];
  }

  void search(text) {
    searchController.text = text;
    getProductBySearch = productModel.getProductsBySearch(searchText: text);
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
                      onTap: () {
                        setState(() {
                          isTextFieldSelected = true;
                        });
                      },
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
                          getProductBySearch = productModel.getProductsBySearch(
                              searchText: searchText);
                          showResults = true;

                          FocusScope.of(context).unfocus();
                        });
                      },
                      decoration: kTextField.copyWith(
                        hintText: S.of(context).search,
                        contentPadding:
                            const EdgeInsets.only(bottom: 12, left: 12),
                      )),
                ),
              ),
              if (isTextFieldSelected)
                Container(
                  padding: const EdgeInsets.only(right: 16, left: 10),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      searchText = '';
                      searchController.text = searchText;
                      isTextFieldSelected = false;
                      showResults = false;
                      FocusScope.of(context).unfocus();
                    }),
                    child: Container(
                      child: Text(S.of(context).cancel,
                          style: textTheme.bodyText2),
                    ),
                  ),
                )
              else
                Container(width: 46)
            ],
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Container(
              height: screenSize.height,
              decoration: const BoxDecoration(color: Colors.white),
              child: (!isTextFieldSelected && !showResults)
                  ? Row(
                      children: [
                        Container(
                            width: 80,
                            decoration: const BoxDecoration(
                                color: kQuaternaryGrey,
                                border: Border(
                                    right: BorderSide(
                                  color: kQuaternaryGrey,
                                  width: 0.7,
                                ))),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: categories.length,
                                itemBuilder: (context, index) => CategoryButton(
                                      categories[index],
                                      isSelected: currentFirstCategory ==
                                          categories[index],
                                      onTap: () {
                                        setState(() {
                                          currentFirstCategory =
                                              categories[index];
                                        });
                                      },
                                    ))),
                        Container(
                          width: kScreenSizeWidth - 80,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  currentFirstCategory.secondCategories.length,
                              itemBuilder: (context, index) =>
                                  SecondCategoryButton(
                                      currentFirstCategory
                                          .secondCategories[index],
                                      onTap: () {})),
                        )
                      ],
                    )
                  : ListView(
                      children: <Widget>[
                        if (showResults)
                          productModel.showProductList(
                              future: getProductBySearch)
                        else
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Mọi người cũng tìm kiếm',
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyText2
                                        .copyWith(color: kSecondaryGrey),
                                  ),
                                  const SizedBox(height: 10),
                                  Keyword(
                                      keyword: roundLab,
                                      onTap: () => search(roundLab)),
                                  const SizedBox(height: 10),
                                  Keyword(
                                      keyword: cleanser,
                                      onTap: () => search(cleanser)),
                                  const SizedBox(height: 10),
                                  Keyword(
                                      keyword: cream,
                                      onTap: () => search(cream)),
                                  const SizedBox(height: 10),
                                  Keyword(
                                      keyword: sunscreen,
                                      onTap: () => search(sunscreen)),
                                  const SizedBox(height: 10),
                                  Keyword(
                                      keyword: serum,
                                      onTap: () => search(serum)),
                                  const SizedBox(height: 10),
                                ],
                              )),
                        // CosmeticsRequestBtn()
                      ],
                    )),
        ));
  }
}
