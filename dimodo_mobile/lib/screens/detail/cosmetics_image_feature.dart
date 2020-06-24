import 'package:Dimodo/common/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../models/product/product.dart';
import '../../widgets/image_galery.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:Dimodo/common/constants.dart';

class CosmeticsImageFeature extends StatelessWidget {
  final Product product;

  CosmeticsImageFeature(this.product);

  @override
  Widget build(BuildContext parentContext) {
    var screenSize = MediaQuery.of(parentContext).size;

    _onShowGallery(context, [index = 0]) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ImageGalery(images: product.sliderImages, index: index);
          });
    }

    return LayoutBuilder(
      builder: (BuildContext buildcontext, BoxConstraints constraints) {
        return SafeArea(
          top: true,
          child: Column(
            children: <Widget>[
              // SizedBox(height: 100),
              Hero(
                  tag: 'product-${product.id}',
                  child: Tools.image(
                    url: product.thumbnail,
                    fit: BoxFit.cover,
                    width: constraints.maxWidth * 0.7,
                    size: kSize.large,
                  )),
            ],
          ),
        );
      },
    );
  }
}
