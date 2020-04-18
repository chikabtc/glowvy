import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import '../../common/tools.dart';
import 'package:provider/provider.dart';
import '../../common/config.dart';
import '../../generated/i18n.dart';
import '../../models/order/cart.dart';
import '../../models/app.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class OrderSummary extends StatefulWidget {
  OrderSummary({this.model});

  final CartModel model;

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
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

    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        OrderSummaryCard(
          currency: currency,
          title: S.of(context).deliveryMethod,
          subTitle: S.of(context).deliveryMethodDescription,
          fee: Tools.getCurrecyFormatted(widget.model.getShippingFee(),
              currency: currency),
        ),
        SizedBox(height: 20),
        OrderSummaryCard(
          currency: currency,
          title: S.of(context).serviceFee,
          subTitle: S.of(context).serviceFee,
          fee: Tools.getCurrecyFormatted(widget.model.getServiceFee(),
              currency: currency),
        ),
        SizedBox(height: 20),
        Divider(
          color: kDarkSecondary.withOpacity(0.1),
        ),
        SizedBox(height: 20),
        OrderSummaryCard(
          isTotalFee: true,
          currency: currency,
          title: S.of(context).total,
          subTitle:
              S.of(context).total + " of ${widget.model.totalCartQuantity}",
          fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
              currency: currency),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  // final CartModel model;
  final String currency;
  final String title;
  final String subTitle;
  final String fee;
  final bool isTotalFee;
  final bool isBankTransferSummary;

  OrderSummaryCard(
      {this.currency,
      this.title,
      this.subTitle,
      this.fee,
      this.isBankTransferSummary = false,
      this.isTotalFee = false});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DynamicText(
            title,
            style: kBaseTextStyle.copyWith(
                fontSize: isBankTransferSummary ? 12 : 13,
                fontWeight:
                    isBankTransferSummary ? FontWeight.w500 : FontWeight.w600,
                color: isBankTransferSummary ? kDarkSecondary : kDarkBG),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: DynamicText(
                  subTitle,
                  style: kBaseTextStyle.copyWith(
                      fontWeight: isBankTransferSummary
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: isBankTransferSummary ? 15 : 12,
                      color: isBankTransferSummary ? kDarkBG : kDarkSecondary),
                ),
              ),
              Spacer(),
              if (!isBankTransferSummary)
                DynamicText(
                  fee,
                  style: kBaseTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: isBankTransferSummary
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isTotalFee ? kPinkAccent : kDefaultFontColor),
                ),
            ],
          ),
        ]);
  }
}
