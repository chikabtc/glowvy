import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
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
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Size screenSize;
  Future<ListPage<Product>> getProductBySearch;
  String searchText;
  bool showResults = false;
  bool isTextFieldSelected = false;
  ProductModel productModel;
  CategoryModel categoryModel;
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
    categoryModel = Provider.of<CategoryModel>(context, listen: false);
    categoryModel = Provider.of<CategoryModel>(context, listen: false);
    searchModel = Provider.of<SearchModel>(context, listen: false);
    categories = categoryModel.categories;
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

    Widget buildItem(BuildContext context, Place place) {
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;

      final model = Provider.of<SearchModel>(context, listen: false);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              FloatingSearchBar.of(context).close();
              Future.delayed(
                const Duration(milliseconds: 500),
                () => model.clear(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 36,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: Icon(Icons.history, key: Key('history')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: textTheme.subtitle1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          place.level2Address,
                          style: textTheme.bodyText2
                              .copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (model.suggestions.isNotEmpty && place != model.suggestions.last)
            const Divider(height: 0),
        ],
      );
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
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: currentFirstCategory.secondCategories.length,
                  itemBuilder: (context, index) => SecondCategoryButton(
                      currentFirstCategory.secondCategories[index],
                      onTap: () {})),
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

            // print('future builder co: ${listPage.itemList[0].brand.toJson()}');
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

    Widget buildExpandableBody(SearchModel model) {
      return Material(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8),
        child: ImplicitlyAnimatedList<Place>(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          items: model.suggestions.take(6).toList(),
          areItemsTheSame: (a, b) => a == b,
          itemBuilder: (context, animation, place, i) {
            return SizeFadeTransition(
              animation: animation,
              child: buildItem(context, place),
            );
          },
          updateItemBuilder: (context, animation, place) {
            return FadeTransition(
              opacity: animation,
              child: buildItem(context, place),
            );
          },
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
                            closeOnBackdropTap: true,
                            maxWidth: screenSize.width,
                            backdropColor: kWhite,
                            isScrollControlled: true,
                            leadingActions: [
                              if (isFocused)
                                FloatingSearchBarAction.back()
                              else
                                FloatingSearchBarAction.icon(
                                  icon: SvgPicture.asset(
                                    'assets/icons/search.svg',
                                    color: Colors.grey,
                                  ),
                                  // showIfClosed: true,
                                  showIfOpened: true,
                                  onTap: () => print('tn'),
                                  // duration: const Duration(milliseconds: 500),
                                ),
                            ],
                            actions: [
                              if (!isQueryEmpty)
                                FloatingSearchBarAction(
                                  showIfOpened: true,
                                  showIfClosed: false,
                                  builder: (context, animation) {
                                    final bar =
                                        FloatingSearchAppBar.of(context);

                                    return ValueListenableBuilder<String>(
                                      valueListenable: bar.queryNotifer,
                                      builder: (context, query, _) {
                                        final isEmpty = query.isEmpty;

                                        return IconButton(
                                          tooltip: 'Back',
                                          // size: 20,

                                          icon: const Icon(
                                            Icons.cancel,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            final bar = FloatingSearchAppBar.of(
                                                context);
                                            bar.clear();
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
                                productModel.clearPagesInfo();

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
                            onQueryChanged: (query) {
                              setState(() {
                                isQueryEmpty = query.isNotEmpty ? false : true;
                              });
                              model.onQueryChanged;
                            },
                            transition: SlideFadeFloatingSearchBarTransition(),
                            builder: (context, _) {
                              return showResults
                                  ? buildSearchResult()
                                  : buildExpandableBody(model);
                            },
                            body: buildCategoryPage(),
                          );
                        }),
                      ),
                    )))));
  }
}
