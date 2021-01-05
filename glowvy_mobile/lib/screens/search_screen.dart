import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/widgets/brand_card_list.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
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
  Future<ListPage<Product>> getProductBySearch;
  String searchText;
  bool showResults = false;
  bool isTextFieldSelected = false;
  ProductModel productModel;
  SearchModel searchModel;
  List<Category> categories = [];
  Category currentFirstCategory;

  bool isFocused = false;
  bool isQueryEmpty = true;
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
    screenSize = MediaQuery.of(context).size;

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
                  itemCount: currentFirstCategory.secondCategories.length,
                  itemBuilder: (context, index) => SecondCategoryButton(
                        currentFirstCategory.secondCategories[index],
                      )),
            )
          ],
        ),
      );
    }

    Widget buildSearchResult() {
      return FutureBuilder<ListPage<Product>>(
        future: getProductBySearch,
        builder:
            (BuildContext context, AsyncSnapshot<ListPage<Product>> snapshot) {
          if (snapshot.hasData) {
            final listPage = snapshot.data;

            return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (searchModel.filtedBrands.isNotEmpty)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text('${searchModel.filtedBrands.length} brand',
                              style: textTheme.bodyText1),
                          const Divider(
                            color: kQuaternaryGrey,
                            thickness: 1.5,
                          )
                        ]),

                  BrandList(
                    brands: searchModel.filtedBrands,
                    disableScrolling: true,
                  ),
                  const SizedBox(height: 35),
                  // const SizedBox(height: 35),
                  if (snapshot.data != null)
                    Text('${listPage.grandTotalCount} results',
                        style: textTheme.bodyText1),
                  if (snapshot.data != null)
                    const Divider(
                      color: kQuaternaryGrey,
                      thickness: 1.5,
                    ),
                  PaginatedProductListView(
                      initialPage: snapshot.data,
                      fetchProducts: () => productModel.getProductsBySearch(
                            searchText,
                          ))
                ]);
          } else {
            return Container();
          }
        },
      );
    }

    Widget showAutoComplete(SearchModel model) {
      //local auto completes
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: kScreenSizeHeight,
              maxHeight: 100000,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: model.brandSuggestions.length,
              itemBuilder: (context, index) => Container(
                padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
                //aggregate all suggestions and show different result based on the index.
                child: Column(
                  children: [
                    //1. brand card &j category
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
                                model.brandSuggestions[index].name,
                                searchController.query),
                            style: textTheme.bodyText1.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    kFullDivider
                  ],
                ),
              ),
            ),
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

                            onSubmitted: (value) {
                              showResults = false;
                              setState(() {
                                productModel.clearPaginationHistory();

                                searchText = value;
                                getProductBySearch =
                                    productModel.getProductsBySearch(
                                  searchText,
                                );
                                searchModel.searchBrands(value);
                                showResults = true;
                              });

                              FocusScope.of(context).unfocus();
                            },
                            debounceDelay: const Duration(milliseconds: 500),
                            // TODO(parker): show autocomplete
                            onQueryChanged: (query) {
                              model.onQueryChanged(query);
                            },
                            transition: SlideFadeFloatingSearchBarTransition(),
                            builder: (context, _) {
                              if (showResults) {
                                return buildSearchResult();
                              } else if (true) {
                                return showAutoComplete(model);
                              } else if (searchController?.query?.isEmpty ||
                                  searchController.query == null) {
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
