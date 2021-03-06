import 'package:Dimodo/common/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/product/product.dart';
import '../../widgets/image_galery.dart';

class ImageFeature extends StatelessWidget {
  final Product product;

  const ImageFeature(this.product);

  @override
  Widget build(BuildContext parentContext) {
    void _onShowGallery(context, [index = 0]) {
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
              height: 150,
              size: kSize.large,
            ));
      },
    );
  }
}
