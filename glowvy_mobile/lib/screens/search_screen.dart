import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/models/user/userModel.dart';
import 'package:Dimodo/packages/floating_search_bar/material_floating_search_bar.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
import 'package:Dimodo/widgets/product/products_list_view.dart';

import 'package:Dimodo/widgets/second_category_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final ScrollController appScrollController;
  SearchScreen({this.appScrollController});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  Future<ListPage<Product>> getProducts;
  ProductModel productModel;
  SearchModel searchModel;
  Category currentFirstCategory;

  Brand pickedBrand;
  Category pickedCategory;

  bool isFocused = false;
  bool showResults = false;
  bool isBrandSearch = false;
  bool isAlgoliaSearch = false;
  bool isCategorySearch = false;

  final searchController = FloatingSearchBarController();
  final _scrollController = ScrollController();
  final _innerScrollController = ScrollController();

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
    currentFirstCategory = searchModel.categories[0];
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _innerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

    void searchByCategory(Category category) {
      FocusScope.of(context).unfocus();
      searchController.query = category.name;

      setState(() {
        productModel.clearPaginationHistory();
        isAlgoliaSearch = false;
        isBrandSearch = false;
        isCategorySearch = true;
        pickedCategory = category;
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
                    itemCount: searchModel.categories.length,
                    itemBuilder: (context, index) => CategoryButton(
                          searchModel.categories[index],
                          isSelected: currentFirstCategory ==
                              searchModel.categories[index],
                          onTap: () {
                            setState(() {
                              currentFirstCategory =
                                  searchModel.categories[index];
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
          Text('${searchModel.filtedBrands.length ?? 0} brand',
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
        brandWidget = Container(
          height: 15,
        );
      }

      //algolia result
      if (isAlgoliaSearch) {
        return FutureBuilder<ListPage<Product>>(
            future: getProducts,
            builder: (BuildContext context,
                AsyncSnapshot<ListPage<Product>> snapshot) {
              if (snapshot.hasData) {
                final listPage = snapshot.data;
                return Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NestedScrollView(
                        controller: widget.appScrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverToBoxAdapter(
                                child: Container(
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    brandWidget,
                                    Text(
                                        '${snapshot.data.itemList.length ?? 0} results',
                                        style: textTheme.bodyText1),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    kFullSectionDivider,
                                  ],
                                ),
                              ),
                            )),
                          ];
                        },
                        body: ProductsListView(
                          products: snapshot.data.itemList,
                          disableScrolling: true,
                          saveHistory: true,
                        )),
                  ),
                );
              } else {
                return Container();
              }
            });
      } else if (isBrandSearch) {
        return Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: NestedScrollView(
              controller: widget.appScrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                      child: Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          brandWidget,
                          Text('${pickedBrand.grandTotalCount ?? 0} results',
                              style: textTheme.bodyText1),
                          const SizedBox(
                            height: 5,
                          ),
                          kFullSectionDivider,
                        ],
                      ),
                    ),
                  )),
                ];
              },
              body: PaginatedProductListView(
                brand: pickedBrand,
                disableSrolling: true,
              ),
            ),
          ),
        );
      } else if (isCategorySearch) {
        return Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: NestedScrollView(
              controller: widget.appScrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                      child: Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          brandWidget,
                          Text(
                              '${pickedCategory.grandTotalCount.toInt() ?? 0} results',
                              style: textTheme.bodyText1),
                          const SizedBox(
                            height: 5,
                          ),
                          kFullSectionDivider,
                        ],
                      ),
                    ),
                  )),
                ];
              },
              body: PaginatedProductListView(
                category: pickedCategory,
                disableSrolling: true,
              ),
            ),
          ),
        );
      }
    }

    Widget showRecentSearchItems(SearchModel model) {
      return Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: NestedScrollView(
              controller: widget.appScrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                      child: Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          if (model.recentSearchItems.isNotEmpty)
                            Row(
                              children: [
                                Text('Recently Searched',
                                    style: textTheme.bodyText1
                                        .copyWith(fontWeight: FontWeight.w700)),
                                const Spacer(),
                                Container(
                                  height: 24,
                                  child: PlatformButton(
                                    onPressed: () => model.clear(),
                                    padding: EdgeInsets.zero,
                                    child: Text('Clear',
                                        style: textTheme.bodyText1.copyWith(
                                            color: kPrimaryOrange,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 5),
                          kFullSectionDivider,
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  )),
                ];
              },
              body: model.recentSearchItems.isNotEmpty
                  ? ProductsListView(
                      products: model.recentSearchItems,
                      isRecentSearchItem: true,
                      // isFromReviewSearch: true,
                    )
                  : Container()),
        ),
      );
    }

    Widget showSuggestions(SearchModel model) {
      const maxSuggestionCount = 5;
      //local auto completes
      ///show only 5 suggestions at most
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 8),
            ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                //if no suggestions are found, show the current query in the
                //suggestion
                itemCount: searchModel.getSuggestionCount(),
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 8, bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          //search by brand products same as in brand home
                          if (model.isSuggestionEmpty()) {
                            searchAlgolia();
                          } else if (index <
                              model.recentQuerySuggestions.length) {
                            searchController.query = searchModel.getSuggestion(
                                index, searchController.query);
                            searchAlgolia();
                          } else if (index <
                              model.categorySuggestion.length +
                                  model.recentQuerySuggestions.length) {
                            searchByCategory(model.categorySuggestion[
                                index - model.recentQuerySuggestions.length]);
                          } else {
                            searchByBrand(model.brandSuggestions[index -
                                model.recentQuerySuggestions.length -
                                model.categorySuggestion.length]);
                          }
                        },
                        child: Container(
                          width: kScreenSizeWidth,
                          color: Colors.transparent,
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
                                          searchModel.getSuggestion(
                                              index, searchController.query),
                                          searchController.query),
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
                        ),
                      ));
                }),
          ],
        ),
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
                                  style: textTheme.headline1.copyWith(
                                      fontSize: 32,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                          ),
                        )),
                      ];
                    },
                    body: Consumer<SearchModel>(builder: (context, model, _) {
                      return FloatingSearchBar(
                        height: 36,
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
                        hint: 'search',
                        elevation: 0,
                        scrollController: _scrollController,
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: kSearchBarColor,
                        automaticallyImplyBackButton: false,
                        controller: searchController,
                        clearQueryOnClose: true,
                        accentColor: kPrimaryOrange,
                        queryStyle: textTheme.headline5
                            .copyWith(fontSize: 17, height: 1.2),
                        hintStyle: textTheme.headline5.copyWith(
                            color: kSecondaryGrey, fontSize: 17, height: 1.2),
                        iconColor: Colors.grey,
                        scrollPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        margins:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        transitionDuration: const Duration(milliseconds: 250),
                        transitionCurve: Curves.linear,
                        axisAlignment: 0.0,
                        openAxisAlignment: 0.0,
                        closeOnBackdropTap: false,
                        maxWidth: kScreenSizeWidth,
                        backdropColor: kWhite,
                        isScrollControlled: true,
                        leadingActions: [
                          // FloatingSearchBarAction.hamburgerToBack(),

                          FloatingSearchBarAction(
                            showIfOpened: true,
                            showIfClosed: true,
                            builder: (context, animation) {
                              final bar = FloatingSearchAppBar.of(context);
                              return ValueListenableBuilder<String>(
                                valueListenable: bar.queryNotifer,
                                builder: (context, query, _) {
                                  final canPop = Navigator.canPop(context);
                                  // return Container();
                                  return GestureDetector(
                                    onTap: () {
                                      if (isFocused) {
                                        final bar =
                                            FloatingSearchAppBar.of(context);
                                        setState(() {
                                          showResults = false;
                                        });

                                        if (bar.isOpen && !bar.isAlwaysOpened) {
                                          bar.close();
                                          model.clearSuggestion();
                                          productModel.clearPaginationHistory();
                                        } else if (canPop) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.0,
                                          right: 8,
                                          bottom: isFocused ? 0 : 1),
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        child: isFocused
                                            ? Icon(
                                                Icons.arrow_back,
                                                color: kSecondaryGrey,
                                                size: 24,
                                              )
                                            : SvgPicture.asset(
                                                'assets/icons/search.svg',
                                                color: kSecondaryGrey),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        ],
                        actions: [
                          if (searchController?.query?.isNotEmpty ?? false)
                            FloatingSearchBarAction(
                              showIfOpened: true,
                              showIfClosed: false,
                              builder: (context, animation) {
                                final bar = FloatingSearchAppBar.of(context);

                                return ValueListenableBuilder<String>(
                                  valueListenable: bar.queryNotifer,
                                  builder: (context, query, _) {
                                    return IconButton(
                                      tooltip: 'cancel',
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.cancel,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        final bar =
                                            FloatingSearchAppBar.of(context);
                                        bar.clear();
                                        model.clearSuggestion();
                                        setState(() {
                                          showResults = false;
                                        });
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                            )
                        ],
                        debounceDelay: const Duration(milliseconds: 100),
                        onQueryChanged: (query) {
                          if (FocusScope.of(context).hasFocus) {
                            setState(() {
                              showResults = false;
                            });
                          }
                          model.onQueryChanged(query);
                        },
                        onSubmitted: (value) {
                          if (Provider.of<UserModel>(context, listen: false)
                              .isLoggedIn) {
                            searchModel.onQuerySubmitted(value);
                          }
                          searchAlgolia();
                        },
                        transition: SlideFadeFloatingSearchBarTransition(),
                        builder: (context, _) {
                          if (showResults) {
                            return buildSearchResult();
                          } else if (searchController?.query?.isNotEmpty ??
                              false) {
                            return showSuggestions(model);
                          } else {
                            return showRecentSearchItems(model);
                          }
                        },
                        body: buildCategoryPage(),
                      );
                    })))));
  }

  @override
  bool get wantKeepAlive => true;
}
