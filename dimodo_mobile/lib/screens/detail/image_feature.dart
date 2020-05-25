import 'package:Dimodo/common/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../models/product/product.dart';
import '../../widgets/image_galery.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageFeature extends StatelessWidget {
  final Product product;

  ImageFeature(this.product);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    _onShowGallery(context, [index = 0]) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ImageGalery(images: product.sliderImages, index: index);
          });
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: screenSize.width,
          height: screenSize.height * 0.52,
          child: Swiper(
            physics: product.sliderImages.length == 1
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int i) {
              // print("image render: ${product.sliderImages[i]}");
              return Hero(
                  tag: 'product-${product.id}',
                  child: Tools.image(
                    url: product.sliderImages[i],
                    fit: BoxFit.cover,
                    width: constraints.maxWidth,
                    size: kSize.large,
                  ));
//  CachedNetworkImage(
//                 imageUrl: product.sliderImages[i],
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//               );
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
