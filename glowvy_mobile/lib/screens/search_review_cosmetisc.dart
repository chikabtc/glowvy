import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/models/search_model.dart';
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

class ReviewCosmeticsSearchScreen extends StatefulWidget {
  final ScrollController appScrollController;
  ReviewCosmeticsSearchScreen({this.appScrollController});

  @override
  _ReviewCosmeticsSearchScreenState createState() =>
      _ReviewCosmeticsSearchScreenState();
}

class _ReviewCosmeticsSearchScreenState
    extends State<ReviewCosmeticsSearchScreen>
    with AutomaticKeepAliveClientMixin<ReviewCosmeticsSearchScreen> {
  Future<ListPage<Product>> getProducts;
  ProductModel productModel;
  SearchModel searchModel;
  Category currentFirstCategory;

  Brand pickedBrand;
  Category pickedCategory;

  bool isFocused = false;
  bool showResults = false;

  final searchController = FloatingSearchBarController();
  final _scrollController = ScrollController();
  final _innerScrollController = ScrollController();

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

    void searchAlgolia() {
      FocusScope.of(context).unfocus();
      setState(() {
        showResults = true;
        productModel.clearPaginationHistory();
        getProducts = productModel.getProductsBySearch(
          searchController.query,
        );
        searchModel.searchBrands(searchController.query);
      });
    }

    Widget buildSearchResult() {
      return FutureBuilder<ListPage<Product>>(
          future: getProducts,
          builder: (BuildContext context,
              AsyncSnapshot<ListPage<Product>> snapshot) {
            if (snapshot.hasData) {
              final listPage = snapshot.data;
              return Scrollbar(
                thickness: kScrollbarThickness,
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
                                  const SizedBox(height: 35),
                                  Text(
                                      '${snapshot.data.itemList.length ?? 0} Kết quả',
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
                        isFromReviewSearch: true,
                        disableScrolling: true,
                        saveHistory: true,
                      )),
                ),
              );
            } else {
              return Container();
            }
          });
    }

    Widget showRecentSearchItems(SearchModel model) {
      return Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Scrollbar(
          thickness: kScrollbarThickness,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
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
                            if (model.recentSearchItems.isNotEmpty)
                              Row(
                                children: [
                                  Text('Tìm kiếm gần đây',
                                      style: textTheme.bodyText1.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  const Spacer(),
                                  Container(
                                    height: 24,
                                    child: PlatformButton(
                                      onPressed: () => model.clear(),
                                      materialFlat: (_, __) =>
                                          MaterialFlatButtonData(
                                              elevation: 0,
                                              color: Colors.transparent),
                                      padding: EdgeInsets.zero,
                                      child: Text('Xóa',
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
                        isFromReviewSearch: true,
                        products: model.recentSearchItems,
                        isRecentSearchItem: true,
                      )
                    : Container()),
          ),
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
                itemCount: searchModel.recentQuerySuggestions.isEmpty
                    ? 1
                    : searchModel.recentQuerySuggestions.length,
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
                                    'Tìm kiếm',
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
                                  'Tìm kiếm',
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
                        hint: 'Sản phẩm, danh mục, thương hiệu',
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
                          FloatingSearchBarAction(
                            showIfOpened: true,
                            showIfClosed: true,
                            builder: (context, animation) {
                              final bar = FloatingSearchAppBar.of(context);
                              return ValueListenableBuilder<String>(
                                valueListenable: bar.queryNotifer,
                                builder: (context, query, _) {
                                  final canPop = Navigator.canPop(context);

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
                                          model.clear();
                                          productModel.clearPaginationHistory();
                                        } else if (canPop) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 4.0,
                                          right: 4,
                                          bottom: isFocused ? 0 : 1),
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        child: isFocused
                                            ? Icon(
                                                Icons.arrow_back,
                                                color: kSecondaryGrey,
                                                size: 22,
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
                                        model.clear();
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
                          model.onQueryChangedProductReviewSearch(query);
                        },
                        onSubmitted: (value) {
                          searchModel.onQuerySubmitted(value);
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
                            return Container();
                          }
                        },
                        body: showRecentSearchItems(model),
                      );
                    })))));
  }

  @override
  bool get wantKeepAlive => true;
}
