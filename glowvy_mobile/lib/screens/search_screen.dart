import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
import 'package:Dimodo/widgets/product/products_list_view.dart';

import 'package:Dimodo/widgets/second_category_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  Size screenSize;
  Future<ListPage<Product>> getProducts;
  ProductModel productModel;
  SearchModel searchModel;
  List<Category> categories = [];
  Category currentFirstCategory;

  Brand pickedBrand;
  Category pickedCategory;

  bool isFocused = false;
  bool showResults = false;
  bool isBrandSearch = false;
  bool isAlgoliaSearch = false;

  final searchController = FloatingSearchBarController();
  final _scrollController = ScrollController();

  var roundLab = 'Round Labs';
  var cleanser = 'Làm Sạch Da Mặt';
  var cream = 'Kem Bôi';
  var sunscreen = 'Chống Nắng';
  var serum = 'Serum';

  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    searchModel = Provider.of<SearchModel>(context, listen: false);
    categories = searchModel.categories;
    currentFirstCategory = categories[0];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenSize = MediaQuery.of(context).size;

    void searchByBrand(Brand brand) {
      FocusScope.of(context).unfocus();
      searchController.query = brand.name;

      setState(() {
        productModel.clearPaginationHistory();
        isAlgoliaSearch = false;

        isBrandSearch = true;
        pickedBrand = brand;
        searchModel.searchBrands(searchController.query);
        showResults = true;
      });
    }

    void searchAlgolia() {
      FocusScope.of(context).unfocus();
      setState(() {
        showResults = true;

        productModel.clearPaginationHistory();
        getProducts = productModel.getProductsBySearch(
          searchController.query,
        );
        searchModel.searchBrands(searchController.query);
        isAlgoliaSearch = true;
      });
    }

    Widget buildCategoryPage() {
      return Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Row(
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
                    addAutomaticKeepAlives: true,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: categories.length,
                    itemBuilder: (context, index) => CategoryButton(
                          categories[index],
                          isSelected: currentFirstCategory == categories[index],
                          onTap: () {
                            setState(() {
                              currentFirstCategory = categories[index];
                            });
                          },
                        ))),
            Container(
              width: kScreenSizeWidth - 80,
              child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: currentFirstCategory.subCategories.length,
                  itemBuilder: (context, index) => SecondCategoryButton(
                        currentFirstCategory.subCategories[index],
                      )),
            )
          ],
        ),
      );
    }

    Widget buildSearchResult() {
      Widget brandWidget;
      if (searchModel.filtedBrands.isNotEmpty) {
        brandWidget =
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 15),
          Text('${searchModel.filtedBrands.length} brand',
              style: textTheme.bodyText1),
          const SizedBox(height: 5),
          kFullSectionDivider,
          BrandList(
            brands: searchModel.filtedBrands,
            disableScrolling: true,
          ),
          const SizedBox(height: 35),
        ]);
      } else {
        brandWidget = Container();
      }

      //algolia result
      if (isAlgoliaSearch) {
        return FutureBuilder<ListPage<Product>>(
          future: getProducts,
          builder: (BuildContext context,
              AsyncSnapshot<ListPage<Product>> snapshot) {
            if (snapshot.hasData) {
              final listPage = snapshot.data;
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    brandWidget,
                    if (snapshot.data != null)
                      Text('${listPage.grandTotalCount} results',
                          style: textTheme.bodyText1),
                    if (snapshot.data != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: kFullSectionDivider,
                      ),
                    ProductsListView(
                      products: snapshot.data.itemList,
                    )
                  ]);
            } else {
              return Container();
            }
          },
        );
      } else if (isBrandSearch) {
        print('show brands search');
        return Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              brandWidget,
              Text('${pickedBrand.grandTotalCount} results',
                  style: textTheme.bodyText1),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: kFullSectionDivider,
              ),
              PaginatedProductListView(
                brand: pickedBrand,
              )
            ]);
      }
    }

    Widget showAutoComplete(SearchModel model) {
      //local auto completes
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: kScreenSizeHeight - 200,
              maxHeight: 100000,
            ),
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                //if no suggestions are found, show the current query in the
                //suggestion
                itemCount: model.isSuggestionEmpty()
                    ? 1
                    : model.brandSuggestions.length +
                        model.categorySuggestion.length,
                itemBuilder: (context, index) {
                  final isBrandSuggestion = model.brandSuggestions.isNotEmpty &&
                      index < model.brandSuggestions.length;
                  final isCategorySuggestion =
                      model.categorySuggestion.isNotEmpty &&
                          index <
                              model.categorySuggestion.length +
                                  model.brandSuggestions.length;
                  var suggestion = '';
                  if (isBrandSuggestion) {
                    suggestion = model.brandSuggestions[index].name;
                  } else if (isCategorySuggestion) {
                    suggestion = model
                        .categorySuggestion[
                            index - model.brandSuggestions.length]
                        .name;
                  } else if (model.isSuggestionEmpty()) {
                    suggestion = searchController.query;
                  }
                  return Container(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 8, bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          if (isBrandSuggestion) {
                            searchByBrand(model.brandSuggestions[index]);
                            //search by brand products same as in brand home
                          } else if (isCategorySuggestion) {
                            //search by category same as in category page

                          } else if (model.isSuggestionEmpty()) {}
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: kDarkAccent,
                                ),
                                const SizedBox(width: 16),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: Tools.highlightOccurrences(
                                        suggestion, searchController.query),
                                    style: textTheme.bodyText1
                                        .copyWith(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            kFullDivider
                          ],
                        ),
                      ));
                }),
          ),
        ],
      );
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SafeArea(
            top: true,
            bottom: false,
            child: Container(
                color: kWhite,
                child: NestedScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        if (!isFocused)
                          SliverAppBar(
                              floating: false,
                              pinned: false,
                              elevation: 0,
                              backgroundColor: Colors.white,
                              title: AnimatedOpacity(
                                  opacity: 0.0,
                                  duration: const Duration(milliseconds: 100),
                                  child: Text(
                                    'Search',
                                    style: textTheme.headline3,
                                    textAlign: TextAlign.start,
                                  ))),
                        SliverToBoxAdapter(
                            child: Container(
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
                              ],
                            ),
                          ),
                        )),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SafeArea(
                        top: true,
                        child:
                            Consumer<SearchModel>(builder: (context, model, _) {
                          return FloatingSearchBar(
                            height: 40,
                            onFocusChanged: (isFocused) {
                              setState(() {
                                this.isFocused = isFocused;
                              });
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(isFocused ? 52 : 0,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeIn);
                              }
                            },
                            elevation: 0,
                            borderRadius: BorderRadius.circular(12),
                            backgroundColor: kQuaternaryGrey,
                            automaticallyImplyBackButton: true,
                            controller: searchController,
                            clearQueryOnClose: true,
                            accentColor: kPrimaryOrange,
                            queryStyle: textTheme.headline5,
                            hintStyle: textTheme.headline5
                                .copyWith(color: kSecondaryGrey),
                            iconColor: Colors.grey,
                            scrollPadding: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            margins: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            transitionDuration:
                                const Duration(milliseconds: 250),
                            transitionCurve: Curves.linear,
                            axisAlignment: 0.0,
                            openAxisAlignment: 0.0,
                            closeOnBackdropTap: false,
                            maxWidth: screenSize.width,
                            backdropColor: kWhite,
                            isScrollControlled: true,
                            leadingActions: [
                              if (isFocused)
                                FloatingSearchBarAction(
                                  showIfClosed: false,
                                  showIfOpened: true,
                                  builder: (context, animation) {
                                    final canPop = Navigator.canPop(context);

                                    return CircularButton(
                                      tooltip: 'Back',
                                      size: 24,
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        final bar =
                                            FloatingSearchAppBar.of(context);

                                        if (bar.isOpen && !bar.isAlwaysOpened) {
                                          bar.close();
                                          model.clear();
                                          productModel.clearPaginationHistory();
                                        } else if (canPop) {
                                          setState(() {
                                            showResults = false;
                                          });

                                          Navigator.pop(context);
                                        }
                                      },
                                    );
                                  },
                                )
                              else
                                FloatingSearchBarAction.icon(
                                    icon: SvgPicture.asset(
                                      'assets/icons/search.svg',
                                      color: Colors.grey,
                                    ),
                                    // showIfClosed: true,
                                    showIfOpened: true,
                                    onTap: () {}
                                    // duration: const Duration(milliseconds: 500),
                                    ),
                            ],
                            actions: [
                              if (searchController?.query?.isNotEmpty ?? false)
                                FloatingSearchBarAction(
                                  showIfOpened: true,
                                  showIfClosed: false,
                                  builder: (context, animation) {
                                    final bar =
                                        FloatingSearchAppBar.of(context);

                                    return ValueListenableBuilder<String>(
                                      valueListenable: bar.queryNotifer,
                                      builder: (context, query, _) {
                                        return IconButton(
                                          tooltip: 'Back',
                                          icon: const Icon(
                                            Icons.cancel,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            final bar = FloatingSearchAppBar.of(
                                                context);
                                            bar.clear();
                                            model.clear();
                                            setState(() {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                            ],
                            debounceDelay: const Duration(milliseconds: 300),
                            onQueryChanged: (query) {
                              //hasFocus tells us whether user is viewing the
                              //search result
                              if (FocusScope.of(context).hasFocus) {
                                setState(() {
                                  //hide search result if the user is typing
                                  showResults = false;
                                });
                              }
                              model.onQueryChanged(query);
                            },
                            onSubmitted: (value) => searchAlgolia(),
                            transition: SlideFadeFloatingSearchBarTransition(),
                            builder: (context, _) {
                              // print('show result: ${showResults}');
                              if (showResults) {
                                return buildSearchResult();
                              } else if (searchController?.query?.isNotEmpty ??
                                  false) {
                                return showAutoComplete(model);
                              } else {
                                return Container();
                              }
                            },
                            body: buildCategoryPage(),
                          );
                        }),
                      ),
                    )))));
  }

  @override
  bool get wantKeepAlive => true;
}
