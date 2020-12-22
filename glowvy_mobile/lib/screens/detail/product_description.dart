import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription(this.product);

  final Product product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription>
    with AutomaticKeepAliveClientMixin<ProductDescription> {
  @override
  bool get wantKeepAlive => true;
  bool isKorean = false;
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if \n has more than 4, replace them with null string
    String formattedDescription;
    if (widget.product.description != null) {
      formattedDescription = isKorean
          ? widget.product.sdescription.replaceAll('\n\n\n\n\n\n', '')
          : widget.product.description.replaceAll('\n\n\n\n\n\n', '');
    }

    return Container(
        color: Colors.white,
        width: kScreenSizeWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Text(
              //         'Mô tả sản phẩm',
              //         style: textTheme.headline5,
              //         textAlign: TextAlign.start,
              //       ),
              //       const SizedBox(height: 15),

              //       // const SizedBox(height: 20),
              //     ],
              //   ),
              // ),
              // if (widget.product.tags.isNotEmpty)
              //   Container(
              //     height: 28,
              //     child: ListView.separated(
              //         padding: const EdgeInsets.only(left: 10),
              //         separatorBuilder: (BuildContext context, int index) =>
              //             const SizedBox(width: 10),
              //         scrollDirection: Axis.horizontal,
              //         itemCount: widget.product.tags.length,
              //         itemBuilder: (context, index) {
              //           return Container(
              //             decoration: BoxDecoration(
              //               color: kDefaultBackground,
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //             alignment: Alignment.center,
              //             padding: const EdgeInsets.only(
              //                 left: 10, right: 10, top: 6, bottom: 6),
              //             child: Text(
              //               widget.product.tags[index],
              //               maxLines: 1,
              //               style: textTheme.bodyText2.copyWith(
              //                 color: kSecondaryGrey,
              //               ),
              //             ),
              //           );
              //         }),
              //   ),
              // const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                child: widget.product.sdescription != null
                    ? Text(
                        formattedDescription,
                        maxLines: 100,
                        style: textTheme.headline4.copyWith(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: kDarkAccent),
                        textAlign: TextAlign.start,
                      )
                    : Container(width: 0, height: 0),
              ),
            ]));
  }
}
