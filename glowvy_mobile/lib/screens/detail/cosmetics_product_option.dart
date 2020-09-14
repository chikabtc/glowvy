import 'package:Dimodo/models/order/cartItem.dart';
import 'package:flutter/material.dart';
import '../../common/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dimodo/widgets/login_animation.dart';

import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/productAttribute.dart';
import 'package:Dimodo/models/brandi/option.dart';
import 'package:Dimodo/models/order/cart.dart';

import 'package:Dimodo/models/user/userModel.dart';
import '../../common/constants.dart';
import 'package:Dimodo/common/tools.dart';

class CosmeticsProductOption extends StatefulWidget {
  final Product product;
  final bool isLoggedIn;
  CosmeticsProductOption(this.product, this.isLoggedIn);
  @override
  _CosmeticsProductOptionState createState() => _CosmeticsProductOptionState();
}

class _CosmeticsProductOptionState extends State<CosmeticsProductOption>
    with TickerProviderStateMixin {
  Function onAddToCart;
  Function onSupport;
  bool isLoading = false;
  Size screenSize;
  AnimationController addToCartButtonController;
  int quantity = 1;
  bool isSingleOption;
  SingleOptions singleOptions;
  var chosenOptions = ["", ""];
  List<CompoundOption> compoundOptions;

  @override
  void initState() {
    // parseOptions(widget.product);
    addToCartButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    super.initState();
  }

  //parseOptions will take a list of option and return either single or compound options
  //that are easier for creating options UI widgets;
  // void parseOptions(Product product) {
  //   var options = product.options;
  //   //check whether there are two options
  //   if (options == null) {
  //     return;
  //   }
  //   if (options[0].attributes.length == 1) {
  //     singleOptions = Option.newSingleOptions(options);
  //     isSingleOption = true;
  //   } else if (options[0].attributes.length == 2) {
  //     compoundOptions = Option.newCompoundOptions(options);
  //     isSingleOption = false;
  //   }
  // }

  void addToCart(Product product) {
    final cartModel = Provider.of<CartModel>(context, listen: false); //
    print("adding to cart price: ${product.salePrice}");
    var cartItem = CartItem(
        product: product,
        optionId: getOptionId(),
        quantity: quantity,
        option: isSingleOption
            ? chosenOptions[0]
            : "${chosenOptions[0]} / ${chosenOptions[1]}");
    cartModel.addProductToCart(cartItem: cartItem);
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 300), () {
      showAddedToCartAlert();
    });
  }

  Future<void> showAddedToCartAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to dismiss the popup!
      builder: (BuildContext buildContext) {
        // Future.delayed(const Duration(milliseconds: 1500), () {
        //   Navigator.of(buildContext).pop();
        // });

        return AlertDialog(
          title: Text(
            S.of(context).addedToYourCart,
            style: kBaseTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: kBaseTextStyle,
              ),
              onPressed: () {
                Navigator.of(buildContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //returns the product_id of the option with the same attribute Value

  int getOptionId() {
    var optionID;
    widget.product.options.forEach((option) {
      if (isSingleOption) {
        if (option.attributes[0].value == chosenOptions[0]) {
          print("single option ID: ${option.productId}");
          optionID = option.productId;
        }
      } else {
        if (option.attributes[0].value == chosenOptions[0] &&
            option.attributes[1].value == chosenOptions[1]) {
          print("compound option ID: ${option.productId}");
          optionID = option.productId;
        }
      }
    });
    return int.parse(optionID);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    var bottomPopupHeightFactor = 1 -
        (AppBar().preferredSize.height +
                60 +
                MediaQuery.of(context).padding.bottom) /
            kScreenSizeHeight;
    return Container(
      height: 60.0 + MediaQuery.of(context).padding.bottom,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 9.0, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MaterialButton(
                elevation: 0,
                minWidth: (screenSize.width - 48) * 0.5,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    side: BorderSide(color: kPinkAccent, width: 1.5)),
                child: Text(S.of(context).customerSupport,
                    style: kBaseTextStyle.copyWith(
                        fontWeight: FontWeight.w600, color: kPinkAccent)),
                onPressed: () =>
                    CustomerSupport.openFacebookMessenger(context)),
            SizedBox(width: 16),
            MaterialButton(
                elevation: 0,
                color: kPinkAccent,
                minWidth: (screenSize.width - 48) * 0.5,
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    side: BorderSide(color: kPinkAccent, width: 1.5)),
                child: Text(S.of(context).addToCart,
                    style: kBaseTextStyle.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
                onPressed: () {
                  addToCart(widget.product);
                }),
          ],
        ),
      ),
    );
  }
}
