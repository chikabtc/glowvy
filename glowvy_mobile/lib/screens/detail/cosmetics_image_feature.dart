import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
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
        return Hero(
            tag: 'product-${product.id}',
            child: Tools.image(
              url: product.thumbnail,
              fit: BoxFit.cover,
              height: 227,
              size: kSize.large,
            ));
      },
    );
  }
}
