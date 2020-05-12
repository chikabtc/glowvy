import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import '../common/tools.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../common/config.dart';
import '../generated/i18n.dart';
import '../models/order/cart.dart';
import '../services/index.dart';
import '../models/app.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShoppingCartSummary extends StatefulWidget {
  ShoppingCartSummary({this.model});

  final CartModel model;

  @override
  _ShoppingCartSummaryState createState() => _ShoppingCartSummaryState();
}

class _ShoppingCartSummaryState extends State<ShoppingCartSummary> {
  final services = Services();
  Map<String, dynamic> defaultCurrency = kAdvanceConfig['DefaultCurrency'];

  @override
  void initState() {
    super.initState();
  }

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text('Warning: $message'),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context, listen: false).currency;

    return Container(
        height: 48,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DynamicText(S.of(context).total,
                  style: kBaseTextStyle.copyWith(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              SizedBox(width: 5),
              DynamicText(
                S.of(context).includingTaxAndFee,
                style: kBaseTextStyle.copyWith(
                    fontSize: 12, color: kDarkSecondary),
              ),
              Center(child: SvgPicture.asset('assets/icons/cart/info.svg')),
              Spacer(),
              //not updating properly...why?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DynamicText(
                    Tools.getCurrecyFormatted(widget.model.getTotal(),
                        currency: currency),
                    style: kBaseTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPinkAccent),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset('assets/icons/cart/coupon.png'),
                      DynamicText(
                        "-" +
                            Tools.getCurrecyFormatted(
                                widget.model.getTotalDiscounts(),
                                currency: currency),
                        style: kBaseTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kPinkAccent),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
