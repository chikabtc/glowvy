import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'dart:math' show max;
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class ProductDescription extends StatefulWidget {
  Product product;
  // final String description;
  // List<String> images;
  // String sizeDetail;

  ProductDescription(this.product);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription>
    with AutomaticKeepAliveClientMixin<ProductDescription> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget renderSizeDetail() {
    var sizeDetailWidget = <Widget>[];
    //create a concanteanated string
    var sizeDetails = widget.product.sizeDetails;
    if (sizeDetails != null) {
      sizeDetails.forEach((sizeDetail) {
        sizeDetail.attributes.forEach((attribute) {
          sizeDetailWidget.add(DynamicText(
            "${attribute.title} ${attribute.value}",
            style: kBaseTextStyle.copyWith(fontSize: 12),
          ));
        });
      });
    }

    return Column(
      children: sizeDetailWidget,
    );
  }

  Widget renderDescriptionImgs() {
    var imagesWidget = <Widget>[];
    //create a concanteanated string
    var images = widget.product.descImages;
    images.forEach((img) {
      print("image to render: $img");
      imagesWidget.add(Image.network(
        img,
      ));
    });
    return Column(
      children: imagesWidget,
    );
  }

  Widget build(BuildContext context) {
    // if \n has more than 4, replace them with null string
    String formattedDescription;
    if (widget.product.description != null) {
      formattedDescription =
          widget.product.description.replaceAll('\n\n\n\n\n\n', "");
    }

    return Container(
        // height: max(MediaQuery.of(context).size.height, webViewHeight),
        width: kScreenSizeWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            DynamicText(
              "id: ${widget.product.sid.toString()}",
              style: kBaseTextStyle.copyWith(fontSize: 12, color: kDarkAccent),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 50),
            renderSizeDetail(),
            widget.product.description != null
                ? DynamicText(
                    formattedDescription,
                    style: kBaseTextStyle.copyWith(
                        fontSize: 12, color: kDarkAccent),
                    textAlign: TextAlign.start,
                  )
                : Container(width: 0, height: 0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 30.0),
              child: renderDescriptionImgs(),
            )
          ]),
        ));
  }
}
