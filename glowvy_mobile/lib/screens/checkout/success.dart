import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';

import '../../common/styles.dart';
import '../../generated/i18n.dart';
import '../../models/order/order.dart';
import '../../models/user/userModel.dart';
import 'package:provider/provider.dart';

class OrderedSuccess extends StatelessWidget {
  final Order order;

  OrderedSuccess({this.order});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(color: kGrey200),
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).itsOrdered,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).orderNo,
                          style: TextStyle(fontSize: 14, color: kGrey900),
                        ),
                        SizedBox(width: 5),
                      ],
                    )
                  ])),
        ),
        SizedBox(height: 30),
        Text(S.of(context).orderSuccessTitle1,
            style: TextStyle(fontSize: 18, color: Colors.black)),
        SizedBox(height: 15),
        Text(
          S.of(context).orderSuccessMsg1,
          style: TextStyle(color: kGrey900, height: 1.4, fontSize: 14),
        ),
        if (userModel.user != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(children: [
              Expanded(
                child: ButtonTheme(
                  height: 45,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed("/orders");
                    },
                    child: Text(
                      S.of(context).showAllMyOrdered.toUpperCase(),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        SizedBox(height: 40),
        Text(S.of(context).orderSuccessTitle2,
            style: TextStyle(fontSize: 18, color: Colors.black)),
        SizedBox(height: 10),
        Text(
          S.of(context).orderSuccessMsg2,
          style: TextStyle(color: kGrey900, height: 1.4, fontSize: 14),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Row(children: [
            Expanded(
                child: ButtonTheme(
              height: 45,
              child: OutlineButton(
                  borderSide: BorderSide(color: Colors.black),
                  child: new Text(S.of(context).backToShop.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/home");
                  },
                  shape: RoundedRectangleBorder()),
            )),
          ]),
        )
      ],
    );
  }
}
