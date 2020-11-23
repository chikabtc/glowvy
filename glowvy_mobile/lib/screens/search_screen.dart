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
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
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
  bool showTitle = false;
  final controller = FloatingSearchBarController();

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
        body: SafeArea(
            top: true,
            bottom: false,
            child: Container(
                color: kDefaultBackground,
                child: NotificationListener(
                    onNotification: (ScrollUpdateNotification notification) {
                      setState(() {
                        if (notification.metrics.pixels > 52 && !showTitle) {
                          showTitle = true;
                        } else if (notification.metrics.pixels < 52 &&
                            showTitle) {
                          showTitle = false;
                        }
                      });
                    },
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                              floating: false,
                              pinned: true,
                              elevation: 0,
                              backgroundColor: Colors.white,
                              title: AnimatedOpacity(
                                  opacity: showTitle ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: Text(
                                    'Search',
                                    style: textTheme.headline3,
                                    textAlign: TextAlign.start,
                                  ))),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.only(top: 0, left: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Search',
                                      style: textTheme.headline1
                                          .copyWith(fontSize: 32),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ])),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverAppBarDelegate(
                              minHeight: 76,
                              maxHeight: 76,
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FloatingSearchBar(
                                      automaticallyImplyBackButton: false,
                                      controller: controller,
                                      clearQueryOnClose: true,
                                      hint: 'search me...',
                                      iconColor: Colors.grey,
                                      transitionDuration:
                                          const Duration(milliseconds: 800),
                                      transitionCurve: Curves.easeIn,
                                      physics: const BouncingScrollPhysics(),
                                      axisAlignment: isPortrait ? 0.0 : -1.0,
                                      openAxisAlignment: 0.0,
                                      maxWidth: isPortrait ? 600 : 500,
                                      actions: actions,
                                      progress: model.isLoading,
                                      debounceDelay:
                                          const Duration(milliseconds: 500),
                                      onQueryChanged: model.onQueryChanged,
                                      scrollPadding: EdgeInsets.zero,
                                      transition:
                                          ExpandingFloatingSearchBarTransition(),
                                      builder: (context, _) =>
                                          buildExpandableBody(model),
                                      body: buildBody(),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Container(
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: kQuaternaryGrey,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextField(
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  onTap: () {
                                                    setState(() {
                                                      isTextFieldSelected =
                                                          true;
                                                    });
                                                  },
                                                  cursorColor:
                                                      theme.cursorColor,
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
                                                      getProductBySearch =
                                                          productModel
                                                              .getProductsBySearch(
                                                                  searchText:
                                                                      searchText);
                                                      showResults = true;

                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    });
                                                  },
                                                  decoration: kTextField
                                                      .copyWith(
                                                          prefixIcon:
                                                              IconButton(
                                                        icon: SvgPicture.asset(
                                                            'assets/icons/search.svg',
                                                            color:
                                                                kSecondaryGrey),
                                                      ))
                                                      .copyWith(
                                                        hintText: S
                                                            .of(context)
                                                            .search,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 12,
                                                                left: 12),
                                                      )),
                                            ),
                                          ),
                                        ),
                                        if (isTextFieldSelected)
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 16, left: 10),
                                            child: GestureDetector(
                                              onTap: () => setState(() {
                                                searchText = '';
                                                searchController.text =
                                                    searchText;
                                                isTextFieldSelected = false;
                                                showResults = false;
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }),
                                              child: Container(
                                                child: Text(
                                                    S.of(context).cancel,
                                                    style: textTheme.bodyText2),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                                // height: screenSize.height,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
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
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: categories.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          CategoryButton(
                                                            categories[index],
                                                            isSelected:
                                                                currentFirstCategory ==
                                                                    categories[
                                                                        index],
                                                            onTap: () {
                                                              setState(() {
                                                                currentFirstCategory =
                                                                    categories[
                                                                        index];
                                                              });
                                                            },
                                                          ))),
                                          Container(
                                            width: kScreenSizeWidth - 80,
                                            child: ListView.builder(
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemCount: currentFirstCategory
                                                    .secondCategories.length,
                                                itemBuilder: (context, index) =>
                                                    SecondCategoryButton(
                                                        currentFirstCategory
                                                                .secondCategories[
                                                            index],
                                                        onTap: () {})),
                                          )
                                        ],
                                      )
                                    : ListView(
                                        physics: const ClampingScrollPhysics(),
                                        children: <Widget>[
                                          if (showResults)
                                            productModel.showProductList(
                                                future: getProductBySearch)
                                          else
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Mọi người cũng tìm kiếm',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textTheme.bodyText2
                                                          .copyWith(
                                                              color:
                                                                  kSecondaryGrey),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Keyword(
                                                        keyword: roundLab,
                                                        onTap: () =>
                                                            search(roundLab)),
                                                    const SizedBox(height: 10),
                                                    Keyword(
                                                        keyword: cleanser,
                                                        onTap: () =>
                                                            search(cleanser)),
                                                    const SizedBox(height: 10),
                                                    Keyword(
                                                        keyword: cream,
                                                        onTap: () =>
                                                            search(cream)),
                                                    const SizedBox(height: 10),
                                                    Keyword(
                                                        keyword: sunscreen,
                                                        onTap: () =>
                                                            search(sunscreen)),
                                                    const SizedBox(height: 10),
                                                    Keyword(
                                                        keyword: serum,
                                                        onTap: () =>
                                                            search(serum)),
                                                    const SizedBox(height: 10),
                                                  ],
                                                )),
                                          // CosmeticsRequestBtn()
                                        ],
                                      )),
                          ),
                        ],
                      ),
                    )))));
  }
}
