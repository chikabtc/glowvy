import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import '../../common/tools.dart';
import 'package:provider/provider.dart';
import '../../common/config.dart';
import '../../generated/i18n.dart';
import '../../models/order/cart.dart';
import '../../models/app.dart';
import 'orderSummary.dart';
import 'package:Dimodo/common/tools.dart';

class BankTransferSummary extends StatefulWidget {
  BankTransferSummary({this.model});

  final CartModel model;

  @override
  _BankTransferSummaryState createState() => _BankTransferSummaryState();
}

class _BankTransferSummaryState extends State<BankTransferSummary> {
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
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              currency: currency,
              title: S.of(context).paymentMethod,
              subTitle: S.of(context).bankTransfer,
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              currency: currency,
              title: S.of(context).bankInfo,
              subTitle: "Shinhan Bank Vietnam 700-014-783205",
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              currency: currency,
              title: S.of(context).accountHolder,
              subTitle: "Hongbeom Park",
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
            OrderSummaryCard(
              isBankTransferSummary: true,
              isTotalFee: true,
              currency: currency,
              title: S.of(context).totalAmount,
              subTitle: Tools.getCurrecyFormatted(widget.model.getTotal()),
              fee: Tools.getCurrecyFormatted(widget.model.getTotal(),
                  currency: currency),
            ),
            SizedBox(height: 20),
          ],
        ));
  }
}
