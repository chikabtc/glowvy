import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/models/category.dart';

import 'package:Dimodo/models/product/brand.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/product_model.dart';
import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/widgets/product/list_page.dart';
import 'package:Dimodo/widgets/product/paginated_product_list.dart';
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
  ProductModel productModel;
  Future<ListPage<Product>> getProductsByBrand;
  Category currentCategory;
  Product lastProduct;
  String option = 'By Price';
  bool isLoading = false;
  int itemsCount = 0;
  ListPage<Product> brandProducts;
  Brand _brand;
  //category variable
  //second cate variable
  @override
  void initState() {
    super.initState();
    //get the brand from searchModel by id
    final brands = Provider.of<SearchModel>(context, listen: false).brands;
    _brand = brands.where((element) => widget.brand.id == element.id).first;

    productModel = Provider.of<ProductModel>(context, listen: false);
    getProductsByBrand = productModel.getProductsByBrand(widget.brand);

    //fetch all products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0,
            leading: backIcon(context, onPop: () {
              Navigator.pop(context);
              productModel.clearPaginationHistory();
            }),
            backgroundColor: Colors.white,
            title: Text(_brand.name)),
        backgroundColor: kWhite,
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
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
                            url: _brand.image,
                            width: 48,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(_brand.name, maxLines: 1, style: textTheme.bodyText2),
                    const SizedBox(height: 15),
                    Container(
                      height: 5,
                      color: kDefaultBackground,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Text('${_brand.grandTotalCount ?? 0} sản phẩm',
                            style: textTheme.caption),
                        const Spacer(),
                        const SizedBox(width: 8),
                        kFullDivider,
                      ],
                    ),
                  ],
                ),
              )
            ];
          },
          body: PaginatedProductListView(
            showPadding: true,
            showNoMoreItemsIndicator: false,
            brand: _brand,
          ),
        ));
  }
}
