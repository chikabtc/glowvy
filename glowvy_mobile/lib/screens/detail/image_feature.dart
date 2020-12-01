import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../models/product/product.dart';
import '../../widgets/image_galery.dart';

class ImageFeature extends StatelessWidget {
  const ImageFeature(this.product);

  final Product product;

  @override
  Widget build(BuildContext parentContext) {
    var screenSize = MediaQuery.of(parentContext).size;

    void _onShowGallery(context, [index = 0]) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ImageGalery(images: product.sliderImages, index: index);
          });
    }

    return LayoutBuilder(
      builder: (BuildContext buildcontext, BoxConstraints constraints) {
        return Container(
          width: screenSize.width,
          height: screenSize.height * 0.52,
          child: Swiper(
            physics: product.sliderImages.length == 1
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              return GestureDetector(
                onTap: () => _onShowGallery(context, i),
                child: Hero(
                    tag: 'product-${product.id}',
                    child: Tools.image(
                      url: product.sliderImages[i],
                      fit: BoxFit.cover,
                      width: constraints.maxWidth,
                      size: kSize.large,
                    )),
              );
            },
            itemCount: product.sliderImages.length,
            pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                    size: 5 * kSizeConfig.containerMultiplier,
                    activeSize: 5 * kSizeConfig.containerMultiplier,
                    color: Colors.grey.withOpacity(0.8),
                    activeColor: Colors.white)),
            control: SwiperControl(
                iconNext: null, iconPrevious: null, color: Colors.red),
          ),
        );
      },
    );
  }
}
