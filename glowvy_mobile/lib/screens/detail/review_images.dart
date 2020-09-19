import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/widgets/image_galery.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:Dimodo/common/tools.dart';

class ReviewImages extends StatefulWidget {
  Product product;
  ReviewImages(this.product);
  @override
  _ReviewImagesState createState() => _ReviewImagesState();
}

class _ReviewImagesState extends State<ReviewImages> {
  Route _createRoute(context, images, index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ImageGalery(images: widget.product.descImages, index: index),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var imagesWidgets = <Widget>[];
    //create a concanteanated string
    var images = widget.product.descImages;
    if (images != null && images != "") {
      images.forEach((img) {
        // print("image to render: $img");
        imagesWidgets.add(GestureDetector(
            onTap: () => Navigator.of(context)
                .push(_createRoute(context, images, images.indexOf(img))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Tools.image(
                url: img,
                fit: BoxFit.cover,
                size: kSize.large,
              ),
            )));
      });
    }
    return widget.product.descImages != null
        ? Container(
            width: kScreenSizeWidth,
            height: 120,
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: ListView.separated(
                padding: EdgeInsets.only(left: 16),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(width: 15),
                scrollDirection: Axis.horizontal,
                addAutomaticKeepAlives: true,
                // shrinkWrap: true,
                itemCount: imagesWidgets.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return imagesWidgets[index];
                }),
          )
        : Container();
  }
}
