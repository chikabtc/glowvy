import 'package:Dimodo/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/tools.dart';
import '../../models/product/product.dart';
import '../../models/product/productModel.dart';
import '../../widgets/image_galery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageFeature extends StatelessWidget {
  final Product product;

  ImageFeature(this.product);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    ProductVariation productVariation;
    productVariation = Provider.of<ProductModel>(context).productVariation;

    _onShowGallery(context, [index = 0]) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ImageGalery(images: product.sliderImages, index: index);
          });
    }

    List<Widget> renderImgs(BoxConstraints constraints) {
      List<Container> imgs = [];
      product.sliderImages.asMap().forEach((i, item) {
        var img = Container(
            width: double.maxFinite,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: double.parse(kProductDetail['marginTop'].toString()),
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: Tools.image(
                      url: product.sliderImages[i],
                      fit: BoxFit.cover,
                      width: constraints.maxWidth,
                      size: kSize.large,
                    ),
                  ),
                ),
              ],
            ));
        imgs.add(img);
      });
      return imgs;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: screenSize.width,
          height: screenSize.height * 0.52,
          child: Swiper(
            itemBuilder: (BuildContext context, int i) {
              return Image.network(
                product.sliderImages[i],
                fit: BoxFit.cover,
              );
            },
            itemCount: product.sliderImages.length,
            pagination: new SwiperPagination(
                margin: new EdgeInsets.all(5.0),
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.grey.withOpacity(0.8),
                    activeColor: Colors.white)),
            control: new SwiperControl(
                iconNext: null, iconPrevious: null, color: Colors.red),
          ),
        );
      },
    );
  }
}
