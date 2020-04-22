import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/styles.dart';
import '../../common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/product/product.dart';
import '../../models/product/productModel.dart';
import '../../models/user/userModel.dart';
import 'product_title.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/widgets/login_animation.dart';
import 'productOption.dart';
import 'package:Dimodo/models/order/cart.dart';
import 'image_feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'review.dart';
import 'package:Dimodo/common/tools.dart';
import 'product_description.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail({this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  int quantity = 1;
  bool isLoading = false;
  Size screenSize;
  var bottomPopupHeightFactor;

  List<String> tabList = ["Description", "Reviews", "other products"];

  List<String> colors = ["Red", "Orange", "Blue"];
  List<String> sizes = ["S", "M", "L"];
  String color;
  String chosenSize;

  Future<Product> product;
  bool isLoggedIn = false;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

//14403197
  void didChangeDependencies() {
    product =
        Provider.of<ProductModel>(context).getProduct(id: widget.product.sid);
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn = Provider.of<UserModel>(context, listen: false).isLoggedIn;
    screenSize = MediaQuery.of(context).size;

    return Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          bottom: false,
          top: false,
          child: FutureBuilder<Product>(
              future: product,
              builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
                return Scaffold(
                    //todo: check whether the item is loaded or not
                    bottomNavigationBar: snapshot.data != null
                        ? ProductOption(snapshot.data, isLoggedIn)
                        : null,
                    backgroundColor: Colors.white,
                    body: DefaultTabController(
                        length: 3,
                        child: NestedScrollView(
                            physics:
                                ScrollPhysics(parent: BouncingScrollPhysics()),
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [
                                SliverOverlapAbsorber(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                  child: SliverAppBar(
                                    //imageFeature (0.5) + 70 + texts(dynamic! 13 * 4 dynamic text)
                                    expandedHeight: screenSize.height * 0.52 +
                                        //title static heigt (31) and font sizes total 41 and 0.9 is the number for the height of the font
                                        //52 is the fontsizes of the service container texts.
                                        //70 is the static height of the service contaienr
                                        //40 is the tabbar height
                                        51 +
                                        70 +
                                        41 * 1.2 +
                                        52 * 1.2 +
                                        40,
                                    brightness: Brightness.light,
                                    leading: IconButton(
                                      icon: CommonIcons.arrowBackward,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    actions: <Widget>[
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.pushReplacementNamed(
                                                context, "/cart", arguments: {
                                          "showBackSpace": true
                                        }),
                                        icon: SvgPicture.asset(
                                          "assets/icons/cart-product-detail.svg",
                                          width: 24 *
                                              kSizeConfig.containerMultiplier,
                                          height: 24 *
                                              kSizeConfig.containerMultiplier,
                                        ),
                                      )
                                    ],
                                    backgroundColor: Colors.white,
                                    pinned: true,
                                    floating: false,
                                    flexibleSpace: snapshot.data == null
                                        ? Container(
                                            height: kScreenSizeHeight,
                                            child: SpinKitThreeBounce(
                                                color: kPinkAccent,
                                                size: 23.0 *
                                                    kSizeConfig
                                                        .containerMultiplier),
                                          )
                                        : FlexibleSpaceBar(
                                            collapseMode: CollapseMode.pin,
                                            background: Column(
                                              children: <Widget>[
                                                ImageFeature(
                                                  snapshot.data,
                                                ),
                                                Container(
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        ProductTitle(
                                                            snapshot.data,
                                                            widget
                                                                .product.name),
                                                        Container(
                                                          height: 5,
                                                          width:
                                                              screenSize.width,
                                                          color:
                                                              kDefaultBackground,
                                                        ),
                                                        Container(
                                                          width:
                                                              screenSize.width,
                                                          color: Colors.white,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 20,
                                                                  bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .shipFrom,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      color:
                                                                          kDarkSecondary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .koreanShippingFee,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kDarkAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              SizedBox(
                                                                  height: 20),
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .serviceIncludes,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      color:
                                                                          kDarkSecondary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              DynamicText(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .quanlityGuarantee,
                                                                  style: kBaseTextStyle.copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          kDarkAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 5,
                                                          width:
                                                              screenSize.width,
                                                          color:
                                                              kDefaultBackground,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                    bottom: snapshot.data == null
                                        ? null
                                        : TabBar(
                                            labelPadding: EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            isScrollable: false,
                                            indicatorColor: kPinkAccent,
                                            unselectedLabelColor: Colors.black,
                                            unselectedLabelStyle:
                                                kBaseTextStyle.copyWith(
                                                    color: kDarkSecondary),
                                            labelStyle: kBaseTextStyle,
                                            labelColor: kPinkAccent,
                                            onTap: (index) {
                                              setState(() {});
                                            },
                                            tabs: renderTabbar(),
                                          ),
                                  ),
                                )
                              ];
                            },
                            body: (snapshot.data == null)
                                ? Container(
                                    height: 1,
                                  )
                                : TabBarView(
                                    children: tabList.map((String name) {
                                      return SafeArea(
                                        top: false,
                                        bottom: false,
                                        child: Builder(
                                          // This Builder is needed to provide a BuildContext that is "inside"
                                          // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                                          // find the NestedScrollView.
                                          builder: (BuildContext context) {
                                            return CustomScrollView(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              // The "controller" and "primary" members should be left
                                              // unset, so that the NestedScrollView can control this
                                              // inner scroll view.
                                              // If the "controller" property is set, then this scroll
                                              // view will not be associated with the NestedScrollView.
                                              // The PageStorageKey should be unique to this ScrollView;
                                              // it allows the list to remember its scroll position when
                                              // the tab view is not on the screen.
                                              key: PageStorageKey<String>(name),
                                              slivers: <Widget>[
                                                SliverOverlapInjector(
                                                  // This is the flip side of the SliverOverlapAbsorber above.
                                                  handle: NestedScrollView
                                                      .sliverOverlapAbsorberHandleFor(
                                                          context),
                                                ),
                                                SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int i) {
                                                      if (name ==
                                                          "other products")
                                                        return ProductModel
                                                            .showProductListByCategory(
                                                                cateId: 7,
                                                                context:
                                                                    context);
                                                      else if (name !=
                                                          "other products")
                                                        return name == "Reviews"
                                                            ? Reviews(snapshot
                                                                .data.sid)
                                                            : ProductDescription(
                                                                snapshot.data);
                                                    },
                                                    childCount: 1,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ))));
              }),
        ));
  }

  List<Widget> renderTabbar() {
    List<Widget> list = [];

    tabList.asMap().forEach((index, item) {
      list.add(Container(
        height: 40,
        child: Tab(
          text: item,
        ),
      ));
    });
    return list;
  }
}
