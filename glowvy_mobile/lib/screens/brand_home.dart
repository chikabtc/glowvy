import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/popups.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:Dimodo/widgets/product/cosmetics_product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandHomePage extends StatefulWidget {
  BrandHomePage(this.brand);
  Brand brand;

  @override
  State<StatefulWidget> createState() {
    return BrandHomePageState();
  }
}

class BrandHomePageState extends State<BrandHomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CategoryModel categoryModel;
  ProductModel productModel;
  Future<List<Product>> getProductsByBrand;
  Category currentCategory;
  Product lastProduct;
  List<Product> _products;
  String option = 'By Price';
  bool isLoading = false;

  //category variable
  //second cate variable
  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    getProductsByBrand = productModel.getProductsByBrand(widget.brand.id);
    //fetch all products
  }

  Future _loadData() async {
    isLoading = true;
    setState(() {
      if (!productModel.isEnd) {
        _products.addAll(_products);
      }
      isLoading = false;
    });
    // getProductsByBrand = productModel.getProductsByBrand(widget.brand.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context),
            backgroundColor: Colors.white,
            title: Text(widget.brand.name)),
        backgroundColor: kWhite,
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              print('load more');
              _loadData();
              // setState(() {
              //   isLoading = true;
              // });
            }
            return false;
          },
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: kQuaternaryGrey,
                    child: ClipOval(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Tools.image(
                          url: widget.brand.image,
                          width: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.brand.name,
                      maxLines: 1, style: textTheme.bodyText2),
                  const SizedBox(height: 15),
                ],
              ),
              Container(
                height: 5,
                color: kDefaultBackground,
              ),
              FutureBuilder<List<Product>>(
                future: getProductsByBrand,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    _products = snapshot.data;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Text(
                              '${_products != null ? _products.length : 0} items',
                              style: textTheme.caption),
                          const Spacer(),
                          GestureDetector(
                            onTap: () =>
                                Popups.showSortOptions(context, snapshot.data,
                                    onTap: (value, newOption) {
                              setState(() {
                                print(value);
                                option = newOption;
                                _products = value;
                              });
                            }),
                            child: Row(children: [
                              Text(option, style: textTheme.caption),
                              const Icon(Icons.arrow_drop_down,
                                  color: kQuaternaryGrey),
                            ]),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      kFullDivider,
                      CosmeticsProductList(
                        products: _products,
                        disableScrolling: true,
                        showRank: false,
                        showPadding: true,
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ));
  }
}
