import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../generated/i18n.dart';
import '../../models/address/address.dart';
import '../../models/order/cart.dart';
import '../../models/user/user.dart';
import '../../services/index.dart';
import '../../common/constants.dart';

class ChooseShipping extends StatefulWidget {
  @override
  _StateChooseShipping createState() => _StateChooseShipping();
}

class _StateChooseShipping extends State<ChooseShipping> {
  List<Address> listShipping = [];
  User user;

  @override
  void initState() {
    super.initState();
    // getDatafromLocal();
    // getUserInfor();
  }

  void getDatafromLocal() async {
    final LocalStorage storage = new LocalStorage("shipping");
    List<Address> _list = [];
    try {
      final ready = await storage.ready;
      if (ready) {
        var data = storage.getItem('data');
        if (data != null) {
          (data as List).forEach((item) {
            final add = Address.fromJson(item);
            _list.add(add);
          });
        }
      }
      setState(() {
        listShipping = _list;
      });
    } catch (err) {
      print(err);
    }
  }

  void removeData(int index) {
    final LocalStorage storage = new LocalStorage("shipping");
    try {
      var data = storage.getItem('data');
      if (data != null) {
        (data as List).removeAt(index);
      }
      storage.setItem('data', data);
    } catch (err) {
      print(err);
    }
    getDatafromLocal();
  }

  Widget convertToCard(BuildContext context, Address address) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${s.streetName}:  ",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text("${address.street}")],
              ),
            )
          ],
        ),
        SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${s.city}:  ",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text("${address.ward.district}")],
              ),
            )
          ],
        ),
        SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${s.province}:  ",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Column(
                children: <Widget>[Text("${address.ward.province}")],
              ),
            )
          ],
        ),
        SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${s.country}:  ",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            // Flexible(
            //   child: Column(
            //     children: <Widget>[Text("${shipping.country}")],
            //   ),
            // )
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _renderBillingShipping() {
    if (user == null) return Container();
    return GestureDetector(
      onTap: () {
        final add = Address(
          recipientName: user.billing.fullName.isNotEmpty
              ? user.billing.fullName
              : user.fullName,
          // email:
          // user.billing.email.isNotEmpty ? user.billing.email : user.email,
          street: user.billing.shipping1,
          // ward: user.billing.ward,
          // province: user.billing.province,
          // phoneNumber: user.billing.phone,
          // district: user.billing.city,
        );
        // Provider.of<CartModel>(context, listen: false).setShipping(add);
        Navigator.of(context).pop();
        // widget.callback(add);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Billing Shipping',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(user.billing.fullName + ' '),
            Text(user.billing.phone),
            Text(user.billing.email),
            Text(user.billing.shipping1),
            Text(user.billing.city),
            Text(user.billing.postCode)
          ],
        ),
      ),
    );
  }

  Widget _renderShippingShipping() {
    if (user == null) return Container();
    return GestureDetector(
      onTap: () {
        final add = Address(
          recipientName: user.address.recipientName.isNotEmpty
              ? user.address.recipientName
              : user.fullName,
          // email: user.email,
          street: user.address.street,
          ward: user.address.ward,
        );
        // Provider.of<CartModel>(context, listen: false).setShipping(add);
        Navigator.of(context).pop();
        // widget.callback(add);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Shipping Shipping',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(user.address.recipientName + ' '),
            Text(user.address.street),
            Text(user.address.ward.district.name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).selectShipping,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _renderBillingShipping(),
            _renderShippingShipping(),
            Column(
              children: List.generate(listShipping.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: GestureDetector(
                      onTap: () {
                        // Provider.of<CartModel>(context, listen: false)
                        // .setShipping(listShipping[index]);
                        Navigator.of(context).pop();
                        // widget.callback(listShipping[index]);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                child: Icon(
                                  Icons.home,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child:
                                    convertToCard(context, listShipping[index]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  removeData(index);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
